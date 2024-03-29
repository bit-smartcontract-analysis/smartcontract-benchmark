pragma solidity ^0.5.6;







// ----------------------------------------------------------------------------

// Safe maths

// ----------------------------------------------------------------------------

contract SafeMath {

    function safeAdd(uint a, uint b) internal pure returns (uint c) {

        c = a + b;

        require(c >= a);

    }

    function safeSub(uint a, uint b) internal pure returns (uint c) {

        require(b <= a);

        c = a - b;

    }

    function safeMul(uint a, uint b) internal pure returns (uint c) {

        c = a * b;

        require(a == 0 || c / a == b);

    }

    function safeDiv(uint a, uint b) internal pure returns (uint c) {

        require(b > 0);

        c = a / b;

    }

}





// ----------------------------------------------------------------------------

// ERC Token Standard #20 Interface

// ----------------------------------------------------------------------------

contract ERC20Interface {

    function totalSupply() public returns (uint);

    function balanceOf(address tokenOwner) public returns (uint balance);

    function allowance(address tokenOwner, address spender) public returns (uint remaining);

    function transfer(address to, uint tokens) public returns (bool success);

    function approve(address spender, uint tokens) public returns (bool success);

    function transferFrom(address from, address to, uint tokens) public returns (bool success);



    event Transfer(address indexed from, address indexed to, uint tokens);

    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

}





// ----------------------------------------------------------------------------

// Contract function to receive approval and execute function in one call

//

// Borrowed from MiniMeToken

// ----------------------------------------------------------------------------

contract ApproveAndCallFallBack {

    function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;

}





// ----------------------------------------------------------------------------

// Owned contract

// ----------------------------------------------------------------------------

contract Owned {

    address public owner;



    event OwnershipTransferred(address indexed _from, address indexed _to);



    constructor() public {

        owner = msg.sender;

    }



    modifier onlyOwner {

        require(msg.sender == owner);

        _;

    }







}





// ----------------------------------------------------------------------------

// ERC20 Token, with the addition of symbol, name and decimals and assisted

// token transfers

// ----------------------------------------------------------------------------

contract Token is ERC20Interface, Owned, SafeMath {

    string public symbol;

    string public  name;

    uint public decimals;

    string public comments;

    uint private _totalSupply;



    mapping(address => uint) balances;

    mapping(address => mapping(address => uint)) allowed;





    // ------------------------------------------------------------------------

    // Constructor

    // ------------------------------------------------------------------------

    constructor(

        uint256 initialSupply,

        string memory tokenName,

        uint8 decimalUnits,

        string memory tokenSymbol,

        string memory tokenComments

    ) public {

        symbol = tokenSymbol;

        name = tokenName;

        decimals = decimalUnits;

        comments = tokenComments;

        _totalSupply = initialSupply;

        _totalSupply = _totalSupply * 10 ** decimals;

        balances[owner] = _totalSupply;

        emit Transfer(address(0), owner, _totalSupply);

    }





    // ------------------------------------------------------------------------

    // Total supply

    // ------------------------------------------------------------------------

    function totalSupply() public returns (uint) {

        return _totalSupply;

    }





    // ------------------------------------------------------------------------

    // Get the token balance for account tokenOwner

    // ------------------------------------------------------------------------

    function balanceOf(address tokenOwner) public returns (uint balance) {

        return balances[tokenOwner];

    }





    // ------------------------------------------------------------------------

    // Transfer the balance from token owner's account to to account

    // - Owner's account must have sufficient balance to transfer

    // - 0 value transfers are allowed

    // ------------------------------------------------------------------------

    function transfer(address to, uint tokens) public returns (bool success) {

        balances[msg.sender] = safeSub(balances[msg.sender], tokens);

        balances[to] = safeAdd(balances[to], tokens);

        emit Transfer(msg.sender, to, tokens);

        return true;

    }





    // ------------------------------------------------------------------------

    // Token owner can approve for spender to transferFrom(...) tokens

    // from the token owner's account

    //

    // recommends that there are no checks for the approval double-spend attack

    // as this should be implemented in user interfaces

    // ------------------------------------------------------------------------

    function approve(address spender, uint tokens) public returns (bool success) {

        allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);

        return true;

    }





    // ------------------------------------------------------------------------

    // Transfer tokens from the from account to the to account

    //

    // The calling account must already have sufficient tokens approve(...)-d

    // for spending from the from account and

    // - From account must have sufficient balance to transfer

    // - Spender must have sufficient allowance to transfer

    // - 0 value transfers are allowed

    // ------------------------------------------------------------------------

    function transferFrom(address from, address to, uint tokens) public returns (bool success) {

        balances[from] = safeSub(balances[from], tokens);

        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);

        balances[to] = safeAdd(balances[to], tokens);

        emit Transfer(from, to, tokens);

        return true;

    }





    // ------------------------------------------------------------------------

    // Returns the amount of tokens approved by the owner that can be

    // transferred to the spender's account

    // ------------------------------------------------------------------------

    function allowance(address tokenOwner, address spender) public returns (uint remaining) {

        return allowed[tokenOwner][spender];

    }





    // ------------------------------------------------------------------------

    // Token owner can approve for spender to transferFrom(...) tokens

    // from the token owner's account. The spender contract function

    // receiveApproval(...) is then executed

    // ------------------------------------------------------------------------

    function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {

        allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);

        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);

        return true;

    }





    // ------------------------------------------------------------------------

    // Don't accept ETH

    // ------------------------------------------------------------------------

    function () external payable {

        revert();

    }





    function transferOwnership(address _newOwner) public onlyOwner {

        owner = _newOwner;

    }





    /**

    * @dev Internal function that mints an amount of the token and assigns it to

    * an account. This encapsulates the modification of balances such that the

    * proper events are emitted.

    * @param account The account that will receive the created tokens.

    * @param value The amount that will be created.

    */

    function mint(address account, uint256 value) public onlyOwner {

        require(account != address(0));



        _totalSupply = safeAdd(_totalSupply, value);

        balances[account] = safeAdd(balances[account], value);

        emit Transfer(address(0), account, value);

    }



    /**

     * @dev Internal function that burns an amount of the token of a given

     * account.

     * @param account The account whose tokens will be burnt.

     * @param value The amount that will be burnt.

     */

    function burn(address account, uint256 value) public onlyOwner {

        require(account != address(0));



        _totalSupply = safeSub(_totalSupply, value);

        balances[account] = safeSub(balances[account], value);

        emit Transfer(account, address(0), value);

    }

}