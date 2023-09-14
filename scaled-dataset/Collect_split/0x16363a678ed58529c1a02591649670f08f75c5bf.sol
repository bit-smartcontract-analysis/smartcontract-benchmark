// **UniverseSwap by Jason Butcher&Fabio Perreca

//

pragma solidity ^0.4.16;

contract owned {

    address public owner;

constructor() public {

        owner = msg.sender;

    }

modifier onlyOwner {

        require(msg.sender == owner);

        _;

    }

function transferOwnership(address newOwner) onlyOwner public {

        owner = newOwner;

    }

}

interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }

contract TokenERC20 {

    // Public variables of the token

    string public name;

    string public symbol;

    uint8 public decimals = 18;

    // 18 decimals is the strongly default

    uint256 public totalSupply;

// This creates an array with all balances

    mapping (address => uint256) public balanceOf;

    mapping (address => mapping (address => uint256)) public allowance;

// This generates a public event on the blockchain that will notify clients

    event Transfer(address indexed from, address indexed to, uint256 value);

    

    // This generates a public event on the blockchain that will notify clients

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

// Burn tokens

    event Burn(address indexed from, uint256 value);

/**

     * Constrctor function

     *

     * Initializes contract with initial supply tokens

     */

    constructor(

        uint256 initialSupply,

        string tokenName,

        string tokenSymbol

    ) public {

        totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount

        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens

        name = tokenName;                                   // Set the name for display purposes

        symbol = tokenSymbol;                               // Set the symbol for display purposes

    }

/**

     * Internal transfer, only can be called by the smart contract

     */

    function _transfer(address _from, address _to, uint _value) internal {

        // Prevent transfer to 0x0 address. Use burn() instead

        require(_to != 0x0);

        // Check if the sender has enough

        require(balanceOf[_from] >= _value);

        // Check for overflows

        require(balanceOf[_to] + _value > balanceOf[_to]);

        // Save this for an assertion in the future

        uint previousBalances = balanceOf[_from] + balanceOf[_to];

        // Subtract from the sender

        balanceOf[_from] -= _value;

        // Add the same to the recipient

        balanceOf[_to] += _value;

        emit Transfer(_from, _to, _value);

        // Asserts are used to use static analysis to find bugs in your code. They should never fail

        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);

    }

/**

     * Transfer tokens

     *

     * Send `_value` tokens to `_to` from your account

     *

     * @param _to The address of the recipient

     * @param _value the amount to send

     */

    function transfer(address _to, uint256 _value) public returns (bool success) {

        _transfer(msg.sender, _to, _value);

        return true;

    }

/**

     * Transfer tokens from other address

     *

     * Send `_value` tokens to `_to` in behalf of `_from`

     *

     * @param _from The address of the sender

     * @param _to The address of the recipient

     * @param _value the amount to send

     */

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {

        require(_value <= allowance[_from][msg.sender]);     // Check allowance

        allowance[_from][msg.sender] -= _value;

        _transfer(_from, _to, _value);

        return true;

    }

/**

     * Set allowance for other address

     */

    function approve(address _spender, uint256 _value) public

        returns (bool success) {

        allowance[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;

    }

/**

     * Set allowance for other address and notify

     *

     */

    function approveAndCall(address _spender, uint256 _value, bytes _extraData)

        public

        returns (bool success) {

        tokenRecipient spender = tokenRecipient(_spender);

        if (approve(_spender, _value)) {

            spender.receiveApproval(msg.sender, _value, this, _extraData);

            return true;

        }

    }

/**

     * 

     *

     * 10% Burn token every trx

     *

     */

    function burn(uint256 _value) public returns (bool success) {

        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough

        balanceOf[msg.sender] -= _value;            // Subtract from the sender

        totalSupply -= _value;                      // Updates totalSupply

        emit Burn(msg.sender, _value);

        return true;

    }



}

/******************************************/

/*       UniverseSwap

*/

/******************************************/

contract UniverseSwap is owned, TokenERC20 {

uint256 public sellPrice;

    uint256 public buyPrice;

mapping (address => bool) public frozenAccount;

/* This generates a public event on the blockchain that will notify clients */

    event FrozenFunds(address target, bool frozen);

/* Initializes contract with initial supply tokens to the creator of the contract */

    constructor(

        uint256 initialSupply,

        string tokenName,

        string tokenSymbol

    ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}

/* ETH 2.0 staking part */

    function _transfer(address _from, address _to, uint _value) internal {

        require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead

        require (balanceOf[_from] >= _value);               // Check if the sender has enough

        require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows

        require(!frozenAccount[_from]);                     // Check if sender is frozen

        require(!frozenAccount[_to]);                       // Check if recipient is frozen

        balanceOf[_from] -= _value;                         // Subtract from the sender

        balanceOf[_to] += _value;                           // Add the same to the recipient

        emit Transfer(_from, _to, _value);

    }

/// Mint function for staking ETH 2.0

    ///param mint for token USWAP is disabled

    function mintToken(address target, uint256 mintedAmount) onlyOwner public {

        balanceOf[target] += mintedAmount;

        totalSupply += mintedAmount;

        emit Transfer(0, this, mintedAmount);

        emit Transfer(this, target, mintedAmount);

    }



/// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth

    /// @param newSellPrice Price the users can sell to the contract

    /// @param newBuyPrice Price users can buy from the contract

    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {

        sellPrice = newSellPrice;

        buyPrice = newBuyPrice;

    }

/// @notice Buy tokens from contract by sending ether

    function buy() payable public {

        uint amount = msg.value / buyPrice;               // calculates the amount

        _transfer(this, msg.sender, amount);              // makes the transfers

    }

/// @notice Sell `1%` tokens to contract and send to wallet

    function sell(uint256 amount) public {

        address myAddress = this;

        require(myAddress.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy

        _transfer(msg.sender, this, amount);              // makes the transfers

        msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks

    }

}