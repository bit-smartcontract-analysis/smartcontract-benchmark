pragma solidity 0.5.8;



contract ERC20TokenInterface {



    function totalSupply () external view returns (uint);

    function balanceOf (address tokenOwner) external view returns (uint balance);

    function transfer (address to, uint tokens) external returns (bool success);

    function transferFrom (address from, address to, uint tokens) external returns (bool success);



}



/**

 * Math operations with safety checks that throw on overflows.

 */

library SafeMath {



    function mul (uint256 a, uint256 b) internal pure returns (uint256 c) {

        if (a == 0) {

            return 0;

        }

        c = a * b;

        require(c / a == b);

        return c;

    }



    function div (uint256 a, uint256 b) internal pure returns (uint256) {

        // assert(b > 0); // Solidity automatically throws when dividing by 0

        // uint256 c = a / b;

        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return a / b;

    }



    function sub (uint256 a, uint256 b) internal pure returns (uint256) {

        require(b <= a);

        return a - b;

    }



    function add (uint256 a, uint256 b) internal pure returns (uint256 c) {

        c = a + b;

        require(c >= a);

        return c;

    }



}



/**

 * DreamTeam tokens vesting smart contract. 

 * This vesting smart contracts releases 25% of tokens 6 months after the smart contract was initialized,

 * 50% of tokens after 1 year, 75% of tokens after 1 year 6 months and 100% tokens are available after 2 years.

 * 0.1% of tokens are available right after vesting contract initialization.

 * The withdrawal address is set during the initialization (initializeVestingFor function).

 * To withdraw tokens, send an empty transaction to this smart contract address (send 0 ETH).

 * Once vesting period (2 year) ends and after all tokens are withdrawn, this smart contract self-destructs.

 */

contract TwoYearDreamTokensVesting {



    /**

     * Sets up an array with vesting stages dates and percentages.

     */

    function vestingRules () internal {



        uint256 year = halfOfYear * 2;

                                                                        // Token availability stages:

        stages[0].date = vestingStartUnixTimestamp;                     // Right after initialization

        stages[1].date = vestingStartUnixTimestamp + halfOfYear;        // 1/2 years after initialization

        stages[2].date = vestingStartUnixTimestamp + year;              // 1 year after initialization

        stages[3].date = vestingStartUnixTimestamp + year + halfOfYear; // 1 + 1/2 years after initialization

        stages[4].date = vestingStartUnixTimestamp + (year * 2);        // 2 years after initialization

                                                    // Token availability values:

        stages[0].tokensUnlockedPercentage = 10;    // 0.1%

        stages[1].tokensUnlockedPercentage = 2500;  // 25%

        stages[2].tokensUnlockedPercentage = 5000;  // 50%

        stages[3].tokensUnlockedPercentage = 7500;  // 75%

        stages[4].tokensUnlockedPercentage = 10000; // 100%



    }



    using SafeMath for uint256;



    /**

     * Address of DREAM token.

     */

    ERC20TokenInterface public dreamToken;



    /**

     * Address which will receive tokens. This address is set during initialization.

     */

    address payable public withdrawalAddress = address(0x0);

    

    uint256 public constant halfOfYear = 182 days + 15 hours; // x2 = ~365.25 days in a year



    /**

     * Tokens vesting stage structure with vesting date and tokens allowed to unlock.

     */

    struct VestingStage {

        uint256 date;

        uint256 tokensUnlockedPercentage;

    }



    /**

     * Array for storing all vesting stages with structure defined above.

     */

    VestingStage[5] public stages;



    /**

     * Total amount of tokens to send.

     */

    uint256 public initialTokensBalance;



    /**

     * Amount of tokens already sent.

     */

    uint256 public tokensSent;



    /**

     * Unix timestamp at when the vesting has begun.

     */

    uint256 public vestingStartUnixTimestamp;



    /**

     * Account that deployed this smart contract, which is authorized to initialize vesting.

     */

    address public deployer;



    modifier deployerOnly { require(msg.sender == deployer); _; }

    modifier whenInitialized { require(withdrawalAddress != address(0x0)); _; }

    modifier whenNotInitialized { require(withdrawalAddress == address(0x0)); _; }



    /**

     * Event raised on each successful withdraw.

     */

    event Withdraw(uint256 amount, uint256 timestamp);



    /**

     * Dedicate vesting smart contract for a particular token during deployment.

     */

    constructor (ERC20TokenInterface addr) public {

        dreamToken = addr;

        deployer = msg.sender;

    }



    /**

     * Fallback: function that releases locked tokens within schedule. Send an empty transaction to this

     * smart contract for withdrawalAddress to receive tokens.

     */

    function () external {

        withdrawTokens();

    }



    /**

     * Vesting initialization function. Contract deployer has to trigger this function after vesting amount

     * was sent to this smart contract.

     * @param account Account to initialize vesting for.

     */

    function initializeVestingFor (address payable account) external deployerOnly whenNotInitialized {

        initialTokensBalance = dreamToken.balanceOf(address(this));

        require(initialTokensBalance != 0);

        withdrawalAddress = account;

        vestingStartUnixTimestamp = block.timestamp;

        vestingRules();

    }



    /**

     * Calculate tokens amount that is sent to withdrawalAddress.

     * @return Amount of tokens that can be sent.

     */

    function getAvailableTokensToWithdraw () public view returns (uint256) {

        uint256 tokensUnlockedPercentage = getTokensUnlockedPercentage();

        // withdrawalAddress will only be able to get all additional tokens sent to this smart contract

        // at the end of the vesting period

        if (tokensUnlockedPercentage >= 10000) {

            return dreamToken.balanceOf(address(this));

        } else {

            return getTokensAmountAllowedToWithdraw(tokensUnlockedPercentage);

        }

    }



    /**

     * Function for tokens withdrawal from the vesting smart contract. Triggered from the fallback function.

     */

    function withdrawTokens () private whenInitialized {

        uint256 tokensToSend = getAvailableTokensToWithdraw();

        sendTokens(tokensToSend);

        if (dreamToken.balanceOf(address(this)) == 0) { // When all tokens were sent, destroy this smart contract

            selfdestruct(withdrawalAddress);

        }

    }



    /**

     * Send tokens to withdrawalAddress.

     * @param tokensToSend Amount of tokens will be sent.

     */

    function sendTokens (uint256 tokensToSend) private {

        if (tokensToSend == 0) {

            return;

        }

        tokensSent = tokensSent.add(tokensToSend); // Update tokensSent variable to send correct amount later

        dreamToken.transfer(withdrawalAddress, tokensToSend); // Send allowed number of tokens

        emit Withdraw(tokensToSend, now); // Emitting a notification that tokens were withdrawn

    }



    /**

     * Calculate tokens available for withdrawal.

     * @param tokensUnlockedPercentage Percent of tokens that are allowed to be sent.

     * @return Amount of tokens that can be sent according to provided percentage.

     */

    function getTokensAmountAllowedToWithdraw (uint256 tokensUnlockedPercentage) private view returns (uint256) {

        uint256 totalTokensAllowedToWithdraw = initialTokensBalance.mul(tokensUnlockedPercentage).div(10000);

        uint256 unsentTokensAmount = totalTokensAllowedToWithdraw.sub(tokensSent);

        return unsentTokensAmount;

    }



    /**

     * Get tokens unlocked percentage on current stage.

     * @return Percent of tokens allowed to be sent.

     */

    function getTokensUnlockedPercentage () private view returns (uint256) {



        uint256 allowedPercent;



        for (uint8 i = 0; i < stages.length; i++) {

            if (now >= stages[i].date) {

                allowedPercent = stages[i].tokensUnlockedPercentage;

            }

        }



        return allowedPercent;



    }



}