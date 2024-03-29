// File: @openzeppelin\upgrades\contracts\Initializable.sol



pragma solidity >=0.4.24 <0.6.0;





/**

 * @title Initializable

 *

 * @dev Helper contract to support initializer functions. To use it, replace

 * the constructor with a function that has the `initializer` modifier.

 * WARNING: Unlike constructors, initializer functions must be manually

 * invoked. This applies both to deploying an Initializable contract, as well

 * as extending an Initializable contract via inheritance.

 * WARNING: When used with inheritance, manual care must be taken to not invoke

 * a parent initializer twice, or ensure that all initializers are idempotent,

 * because this is not dealt with automatically as with constructors.

 */

contract Initializable {



  /**

   * @dev Indicates that the contract has been initialized.

   */

  bool private initialized;



  /**

   * @dev Indicates that the contract is in the process of being initialized.

   */

  bool private initializing;



  /**

   * @dev Modifier to use in the initializer function of a contract.

   */

  modifier initializer() {

    require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");



    bool isTopLevelCall = !initializing;

    if (isTopLevelCall) {

      initializing = true;

      initialized = true;

    }



    _;



    if (isTopLevelCall) {

      initializing = false;

    }

  }



  /// @dev Returns true if and only if the function is running in the constructor

  function isConstructor() private view returns (bool) {

    // extcodesize checks the size of the code stored in an address, and

    // address returns the current address. Since the code is still not

    // deployed when running a constructor, any checks on its code size will

    // yield zero, making it an effective way to detect if a contract is

    // under construction or not.

    uint256 cs;

    assembly { cs := extcodesize(address) }

    return cs == 0;

  }



  // Reserved storage space to allow for layout changes in the future.

  uint256[50] private ______gap;

}



// File: @openzeppelin\contracts-ethereum-package\contracts\math\SafeMath.sol



pragma solidity ^0.5.0;



/**

 * @dev Wrappers over Solidity's arithmetic operations with added overflow

 * checks.

 *

 * Arithmetic operations in Solidity wrap on overflow. This can easily result

 * in bugs, because programmers usually assume that an overflow raises an

 * error, which is the standard behavior in high level programming languages.

 * `SafeMath` restores this intuition by reverting the transaction when an

 * operation overflows.

 *

 * Using this library instead of the unchecked operations eliminates an entire

 * class of bugs, so it's recommended to use it always.

 */

library SafeMath {

    /**

     * @dev Returns the addition of two unsigned integers, reverting on

     * overflow.

     *

     * Counterpart to Solidity's `+` operator.

     *

     * Requirements:

     * - Addition cannot overflow.

     */

    function add(uint256 a, uint256 b) internal pure returns (uint256) {

        uint256 c = a + b;

        require(c >= a, "SafeMath: addition overflow");



        return c;

    }



    /**

     * @dev Returns the subtraction of two unsigned integers, reverting on

     * overflow (when the result is negative).

     *

     * Counterpart to Solidity's `-` operator.

     *

     * Requirements:

     * - Subtraction cannot overflow.

     */

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {

        return sub(a, b, "SafeMath: subtraction overflow");

    }



    /**

     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on

     * overflow (when the result is negative).

     *

     * Counterpart to Solidity's `-` operator.

     *

     * Requirements:

     * - Subtraction cannot overflow.

     *

     * _Available since v2.4.0._

     */

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b <= a, errorMessage);

        uint256 c = a - b;



        return c;

    }



    /**

     * @dev Returns the multiplication of two unsigned integers, reverting on

     * overflow.

     *

     * Counterpart to Solidity's `*` operator.

     *

     * Requirements:

     * - Multiplication cannot overflow.

     */

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {

        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the

        // benefit is lost if 'b' is also tested.

        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522

        if (a == 0) {

            return 0;

        }



        uint256 c = a * b;

        require(c / a == b, "SafeMath: multiplication overflow");



        return c;

    }



    /**

     * @dev Returns the integer division of two unsigned integers. Reverts on

     * division by zero. The result is rounded towards zero.

     *

     * Counterpart to Solidity's `/` operator. Note: this function uses a

     * `revert` opcode (which leaves remaining gas untouched) while Solidity

     * uses an invalid opcode to revert (consuming all remaining gas).

     *

     * Requirements:

     * - The divisor cannot be zero.

     */

    function div(uint256 a, uint256 b) internal pure returns (uint256) {

        return div(a, b, "SafeMath: division by zero");

    }



    /**

     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on

     * division by zero. The result is rounded towards zero.

     *

     * Counterpart to Solidity's `/` operator. Note: this function uses a

     * `revert` opcode (which leaves remaining gas untouched) while Solidity

     * uses an invalid opcode to revert (consuming all remaining gas).

     *

     * Requirements:

     * - The divisor cannot be zero.

     *

     * _Available since v2.4.0._

     */

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        // Solidity only automatically asserts when dividing by 0

        require(b > 0, errorMessage);

        uint256 c = a / b;

        // assert(a == b * c + a % b); // There is no case in which this doesn't hold



        return c;

    }



    /**

     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),

     * Reverts when dividing by zero.

     *

     * Counterpart to Solidity's `%` operator. This function uses a `revert`

     * opcode (which leaves remaining gas untouched) while Solidity uses an

     * invalid opcode to revert (consuming all remaining gas).

     *

     * Requirements:

     * - The divisor cannot be zero.

     */

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {

        return mod(a, b, "SafeMath: modulo by zero");

    }



    /**

     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),

     * Reverts with custom message when dividing by zero.

     *

     * Counterpart to Solidity's `%` operator. This function uses a `revert`

     * opcode (which leaves remaining gas untouched) while Solidity uses an

     * invalid opcode to revert (consuming all remaining gas).

     *

     * Requirements:

     * - The divisor cannot be zero.

     *

     * _Available since v2.4.0._

     */

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b != 0, errorMessage);

        return a % b;

    }

}



// File: @openzeppelin\contracts-ethereum-package\contracts\token\ERC20\IERC20.sol



pragma solidity ^0.5.0;



/**

 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include

 * the optional functions; to access them see {ERC20Detailed}.

 */

interface IERC20 {

    /**

     * @dev Returns the amount of tokens in existence.

     */

    function totalSupply() external view returns (uint256);



    /**

     * @dev Returns the amount of tokens owned by `account`.

     */

    function balanceOf(address account) external view returns (uint256);



    /**

     * @dev Moves `amount` tokens from the caller's account to `recipient`.

     *

     * Returns a boolean value indicating whether the operation succeeded.

     *

     * Emits a {Transfer} event.

     */

    function transfer(address recipient, uint256 amount) external returns (bool);



    /**

     * @dev Returns the remaining number of tokens that `spender` will be

     * allowed to spend on behalf of `owner` through {transferFrom}. This is

     * zero by default.

     *

     * This value changes when {approve} or {transferFrom} are called.

     */

    function allowance(address owner, address spender) external view returns (uint256);



    /**

     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.

     *

     * Returns a boolean value indicating whether the operation succeeded.

     *

     * IMPORTANT: Beware that changing an allowance with this method brings the risk

     * that someone may use both the old and the new allowance by unfortunate

     * transaction ordering. One possible solution to mitigate this race

     * condition is to first reduce the spender's allowance to 0 and set the

     * desired value afterwards:

     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729

     *

     * Emits an {Approval} event.

     */

    function approve(address spender, uint256 amount) external returns (bool);



    /**

     * @dev Moves `amount` tokens from `sender` to `recipient` using the

     * allowance mechanism. `amount` is then deducted from the caller's

     * allowance.

     *

     * Returns a boolean value indicating whether the operation succeeded.

     *

     * Emits a {Transfer} event.

     */

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);



    /**

     * @dev Emitted when `value` tokens are moved from one account (`from`) to

     * another (`to`).

     *

     * Note that `value` may be zero.

     */

    event Transfer(address indexed from, address indexed to, uint256 value);



    /**

     * @dev Emitted when the allowance of a `spender` for an `owner` is set by

     * a call to {approve}. `value` is the new allowance.

     */

    event Approval(address indexed owner, address indexed spender, uint256 value);

}



// File: contracts\UniSwap_ETH_cDAI.sol



// Copyright (C) 2019, 2020 dipeshsukhani, nodarjonashi, toshsharma, suhailg



// This program is free software: you can redistribute it and/or modify

// it under the terms of the GNU Affero General Public License as published by

// the Free Software Foundation, either version 2 of the License, or

// (at your option) any later version.

//

// This program is distributed in the hope that it will be useful,

// but WITHOUT ANY WARRANTY; without even the implied warranty of

// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the

// GNU Affero General Public License for more details.

//

// Visit <https://www.gnu.org/licenses/>for a copy of the GNU Affero General Public License



/**

 * WARNING: This is an upgradable contract. Be careful not to disrupt

 * the existing storage layout when making upgrades to the contract. In particular,

 * existing fields should not be removed and should not have their types changed.

 * The order of field declarations must not be changed, and new fields must be added

 * below all existing declarations.

 *

 * The base contracts and the order in which they are declared must not be changed.

 * New fields must not be added to base contracts (unless the base contract has

 * reserved placeholder fields for this purpose).

 *

 * See https://docs.zeppelinos.org/docs/writing_contracts.html for more info.

*/



pragma solidity ^0.5.0;



///@author DeFiZap

///@notice this contract implements one click conversion from ETH to unipool liquidity tokens (cDAI)



interface IuniswapFactory {

    function getExchange(address token) external view returns (address exchange);

}



interface IuniswapExchange {

    function getEthToTokenInputPrice(uint256 eth_sold) external view returns (uint256 tokens_bought);

    function getTokenToEthInputPrice(uint256 tokens_sold) external view returns (uint256 eth_bought);

    function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline) external payable returns (uint256  tokens_bought);

    function balanceOf(address _owner) external view returns (uint256);

    function transfer(address _to, uint256 _value) external returns (bool);

    function transferFrom(address _from, address _to, uint256 value) external returns (bool);

    function approve(address _spender, uint256 _value) external returns (bool);

    function allowance(address _owner, address _spender) external view returns (uint256);

    function totalSupply() external view returns (uint256);

    function addLiquidity(uint256 min_liquidity, uint256 max_tokens, uint256 deadline) external payable returns (uint256);

    function removeLiquidity(uint256 amount, uint256 min_eth, uint256 min_tokens, uint256 deadline) external returns (uint256, uint256);

}



interface Compound {

    function approve ( address spender, uint256 amount ) external returns ( bool );

    function mint ( uint256 mintAmount ) external returns ( uint256 );

    function balanceOf(address _owner) external view returns (uint256 balance);

    function transfer(address _to, uint _value) external returns (bool success);

}



interface IOneSplitInterface {



    function getExpectedReturn(

        address fromToken,

        address toToken,

        uint256 amount,

        uint256 parts,

        uint256 disableFlags // 1 - Uniswap, 2 - Kyber, 4 - Bancor, 8 - Oasis, 16 - Compound, 32 - Fulcrum, 64 - Chai, 128 - Aave, 256 - SmartToken

    )

        external

        view

        returns(

            uint256 returnAmount,

            uint256[] memory distribution // [Uniswap, Kyber, Bancor, Oasis]

        );



    function swap(

        address fromToken,

        address toToken,

        uint256 amount,

        uint256 minReturn,

        uint256[] calldata distribution, // [Uniswap, Kyber, Bancor, Oasis]

        uint256 disableFlags // 16 - Compound, 32 - Fulcrum, 64 - Chai, 128 - Aave, 256 - SmartToken

    )

        external

        payable;



    function goodSwap(

        address fromToken,

        address toToken,

        uint256 amount,

        uint256 minReturn,

        uint256 parts,

        uint256 disableFlags // 1 - Uniswap, 2 - Kyber, 4 - Bancor, 8 - Oasis, 16 - Compound, 32 - Fulcrum, 64 - Chai, 128 - Aave, 256 - SmartToken

    )

        external

        payable;

}



contract UniSwap_ETH_CDAIZap is Initializable {

    using SafeMath for uint;

    // state variables



    // - THESE MUST ALWAYS STAY IN THE SAME LAYOUT

    bool private stopped;

    address payable public owner;

    IuniswapFactory public UniSwapFactoryAddress;

    IOneSplitInterface public OneSplitInterfaceAddress;

    IERC20 public NEWDAI_TOKEN_ADDRESS;

    Compound public COMPOUND_TOKEN_ADDRESS;

    address public DAI_TOKEN_ADDRESS;

    address public ETH_TOKEN_ADDRESS;

    address public ONESPLIT_ADDRESS;





    // events

    event ERC20TokenHoldingsOnConversionDaiChai(uint);

    event ERC20TokenHoldingsOnConversionEthDai(uint);

    event LiquidityTokens(uint);



    // circuit breaker modifiers

    modifier stopInEmergency {if (!stopped) _;}

    modifier onlyInEmergency {if (stopped) _;}

    modifier onlyOwner() {

        require(isOwner(), "you are not authorised to call this function");

        _;

    }





    function initialize() initializer public {

        stopped = false;

        owner = msg.sender;

        UniSwapFactoryAddress = IuniswapFactory(0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95);

        NEWDAI_TOKEN_ADDRESS = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);

        COMPOUND_TOKEN_ADDRESS = Compound(0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643);

        OneSplitInterfaceAddress = IOneSplitInterface(0xD010B65120E027419586216D25bF86C2c24FCC4a);

        ONESPLIT_ADDRESS = address(0xD010B65120E027419586216D25bF86C2c24FCC4a);

        DAI_TOKEN_ADDRESS = address(0x6B175474E89094C44Da98b954EedeAC495271d0F);

        ETH_TOKEN_ADDRESS = address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);

    }





    function set_new_UniSwapFactoryAddress(address _new_UniSwapFactoryAddress) public onlyOwner {

        UniSwapFactoryAddress = IuniswapFactory(_new_UniSwapFactoryAddress);

    }



    function set_new_DAI_TOKEN_ADDRESS(address _new_DAI_TOKEN_ADDRESS) public onlyOwner {

        NEWDAI_TOKEN_ADDRESS = IERC20(_new_DAI_TOKEN_ADDRESS);

        DAI_TOKEN_ADDRESS = _new_DAI_TOKEN_ADDRESS;

    }



    function set_new_cDAI_TokenContractAddress(address _new_cDAI_TokenContractAddress) public onlyOwner {

        COMPOUND_TOKEN_ADDRESS = Compound(_new_cDAI_TokenContractAddress);

    }



    function set_OneSplitInterfaceAddress(address _new_OneSplitInterfaceAddress) public onlyOwner {

        OneSplitInterfaceAddress = IOneSplitInterface(_new_OneSplitInterfaceAddress);

        ONESPLIT_ADDRESS = _new_OneSplitInterfaceAddress;

    }



    function getExpectedReturn(uint256 eth) public view returns (uint256) {

      uint256 _minReturn = 0;

      (_minReturn, ) = OneSplitInterfaceAddress.getExpectedReturn(ETH_TOKEN_ADDRESS, DAI_TOKEN_ADDRESS, eth, 1, 0);

      return _minReturn;

    }



    function LetsInvest(address _towhomtoissue, uint256 _minReturn) public payable stopInEmergency returns (uint) {

        IERC20 ERC20TokenAddress = IERC20(address(COMPOUND_TOKEN_ADDRESS));

        IuniswapExchange UniSwapExchangeContractAddress = IuniswapExchange(UniSwapFactoryAddress.getExchange(address(COMPOUND_TOKEN_ADDRESS)));



        // determining the portion of the incoming ETH to be converted to the ERC20 Token

        uint conversionPortion = SafeMath.div(SafeMath.mul(msg.value, 505), 1000);

        uint non_conversionPortion = SafeMath.sub(msg.value,conversionPortion);



        if (_minReturn == 0) {

          (_minReturn, ) = OneSplitInterfaceAddress.getExpectedReturn(ETH_TOKEN_ADDRESS, DAI_TOKEN_ADDRESS, conversionPortion, 1, 0);

        }



        OneSplitInterfaceAddress.goodSwap.value(conversionPortion)(ETH_TOKEN_ADDRESS, DAI_TOKEN_ADDRESS, conversionPortion, _minReturn, 1, 0);

        uint tokenBalance = NEWDAI_TOKEN_ADDRESS.balanceOf(address(this));



        require(tokenBalance > 0, "the conversion did not happen as planned");



        // conversion of DAI to cDAI

        uint qty2approve = SafeMath.mul(tokenBalance, 3);

        require(NEWDAI_TOKEN_ADDRESS.approve(address(ERC20TokenAddress), qty2approve));

        COMPOUND_TOKEN_ADDRESS.mint(tokenBalance);

        uint ERC20TokenHoldings = ERC20TokenAddress.balanceOf(address(this));

        require (ERC20TokenHoldings > 0, "the conversion did not happen as planned");

        emit ERC20TokenHoldingsOnConversionDaiChai(ERC20TokenHoldings);

        NEWDAI_TOKEN_ADDRESS.approve(address(ERC20TokenAddress), 0);

        ERC20TokenAddress.approve(address(UniSwapExchangeContractAddress),ERC20TokenHoldings);



        // adding Liquidity

        uint max_tokens_ans = getMaxTokens(address(UniSwapExchangeContractAddress), ERC20TokenAddress, non_conversionPortion);

        UniSwapExchangeContractAddress.addLiquidity.value(non_conversionPortion)(1,max_tokens_ans,SafeMath.add(now,1800));

        ERC20TokenAddress.approve(address(UniSwapExchangeContractAddress),0);



        // transferring Liquidity

        uint LiquityTokenHoldings = UniSwapExchangeContractAddress.balanceOf(address(this));

        emit LiquidityTokens(LiquityTokenHoldings);

        UniSwapExchangeContractAddress.transfer(_towhomtoissue, LiquityTokenHoldings);

        ERC20TokenHoldings = ERC20TokenAddress.balanceOf(address(this));

        ERC20TokenAddress.transfer(_towhomtoissue, ERC20TokenHoldings);

        return LiquityTokenHoldings;

    }



    function Redeem(address _towhomtosend, uint256 _amount) public stopInEmergency returns (uint) {

        // Compound contract address

        IERC20 ERC20TokenAddress = IERC20(address(COMPOUND_TOKEN_ADDRESS));



        // Compound uniswap exchange

        IuniswapExchange UniSwapExchangeContractAddress = IuniswapExchange(UniSwapFactoryAddress.getExchange(address(COMPOUND_TOKEN_ADDRESS)));



        uint256 balance = UniSwapExchangeContractAddress.balanceOf(msg.sender);

        require(balance >= _amount, "insufficient balance");

        uint256 allowance = UniSwapExchangeContractAddress.allowance(msg.sender, address(this));

        require(allowance >= _amount, "insufficient allowance");



        // Send users uni-v1 to contract address (will fail if not approved)

        uint mybalance = UniSwapExchangeContractAddress.balanceOf(address(this));

        bool result = UniSwapExchangeContractAddress.transferFrom(msg.sender, address(this), _amount);

        uint newbalance = UniSwapExchangeContractAddress.balanceOf(address(this));

        require(result, "transfer of uni failed");

        require(newbalance >= mybalance, "insufficient uni balance");



        // Get min_eth and min_token for removeLiquidity call

        //(, uint256 ownerSharesEth, uint256 ownerSharesToken) = getReturn(address(UniSwapExchangeContractAddress), ERC20TokenAddress, _amount);

        // Swap uni-v1 for eth and tokens

        (uint256 eth, uint256 tokens) = UniSwapExchangeContractAddress.removeLiquidity(_amount, 1, 1, SafeMath.add(now,1800));



        // Approve onesplit to take the compound tokens

        ERC20TokenAddress.approve(ONESPLIT_ADDRESS, tokens);

        // Get the expected return in ETH

        (uint256 _minReturn, ) = OneSplitInterfaceAddress.getExpectedReturn(address(COMPOUND_TOKEN_ADDRESS), ETH_TOKEN_ADDRESS, tokens, 1, 0);

        // Swap for the expected ETH

        OneSplitInterfaceAddress.goodSwap.value(0)(address(COMPOUND_TOKEN_ADDRESS), ETH_TOKEN_ADDRESS, tokens, _minReturn, 1, 0);





        ERC20TokenAddress.approve(ONESPLIT_ADDRESS, 0);



        uint256 ethReturn = SafeMath.add(eth, _minReturn);

        (result, ) = _towhomtosend.call.value(ethReturn).gas(50000)("");

        require(result, "transfer of ETH failed");

        return ethReturn;

    }



    function getMaxTokens(address _UniSwapExchangeContractAddress, IERC20 _ERC20TokenAddress, uint _value) public view returns (uint) {

        uint contractBalance = _UniSwapExchangeContractAddress.balance;

        uint eth_reserve = SafeMath.sub(contractBalance, _value);

        uint token_reserve = _ERC20TokenAddress.balanceOf(_UniSwapExchangeContractAddress);

        uint token_amount = SafeMath.div(SafeMath.mul(_value,token_reserve),eth_reserve) + 1;

        return token_amount;

    }



    function getEthBalance(address _UniSwapExchangeContractAddress) public view returns (uint) {

      uint ethBalance = _UniSwapExchangeContractAddress.balance;

      return ethBalance;

    }



    function getTokenReserves(address _UniSwapExchangeContractAddress, IERC20 _ERC20TokenAddress) public view returns (uint) {

      uint token_reserve = _ERC20TokenAddress.balanceOf(_UniSwapExchangeContractAddress);

      return token_reserve;

    }





    function getTotalShares(address _UniSwapExchangeContractAddress) public view returns (uint) {

      uint totalShares = IuniswapExchange(_UniSwapExchangeContractAddress).totalSupply();

      return totalShares;

    }



    function getReturn(address _UniSwapExchangeContractAddress, IERC20 _ERC20TokenAddress, uint _value) public view returns (uint, uint, uint) {

        // Token balance in uniswap contract

        uint token_reserve = _ERC20TokenAddress.balanceOf(_UniSwapExchangeContractAddress);

        // ETH balance in uniswap contract

        uint ethBalance = _UniSwapExchangeContractAddress.balance;



        // Get total pool shares

        uint totalShares = IuniswapExchange(_UniSwapExchangeContractAddress).totalSupply();



        // Calculate owner share pool

        uint ownerSharesEth = SafeMath.div(SafeMath.mul(_value, ethBalance), totalShares);

        uint ownerSharesToken = SafeMath.div(SafeMath.mul(_value, token_reserve), totalShares);



        // Calculate eth value

        uint ethBought = IuniswapExchange(_UniSwapExchangeContractAddress).getTokenToEthInputPrice(ownerSharesToken);

        uint ethValue = SafeMath.add(ethBought, ownerSharesEth);



        return (ethValue, ownerSharesEth, ownerSharesToken);

    }



    // incase of half-way error

    function inCaseTokengetsStuck(IERC20 _TokenAddress) onlyOwner public {

        uint qty = _TokenAddress.balanceOf(address(this));

        _TokenAddress.transfer(owner, qty);

    }



    // - fallback function let you / anyone send ETH to this wallet without the need to call any function

    function() external payable {

        if (msg.sender != owner) {

            LetsInvest(msg.sender, 0);

        }

    }



    // - to Pause the contract

    function toggleContractActive() onlyOwner public {

        stopped = !stopped;

    }

    // - to withdraw any ETH balance sitting in the contract

    function withdraw() onlyOwner public{

        owner.transfer(address(this).balance);

    }

    // - to kill the contract

    function destruct() public onlyOwner {

        selfdestruct(owner);

    }

    /**

     * @return true if `msg.sender` is the owner of the contract.

     */

    function isOwner() public view returns (bool) {

        return msg.sender == owner;

    }



    /**

     * @dev Transfers ownership of the contract to a new account (`newOwner`).

     * Can only be called by the current owner.

     */

    function transferOwnership(address payable newOwner) public onlyOwner {

        _transferOwnership(newOwner);

    }



    /**

     * @dev Transfers ownership of the contract to a new account (`newOwner`).

     */

    function _transferOwnership(address payable newOwner) internal {

        require(newOwner != address(0), "Ownable: new owner is the zero address");

        owner = newOwner;

    }



}