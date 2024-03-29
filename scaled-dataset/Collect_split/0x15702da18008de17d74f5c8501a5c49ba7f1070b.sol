pragma solidity ^0.4.24;



contract SafeMath {

    function safeAdd(uint a, uint b) public pure returns (uint c) {

        c = a + b;

        require(c >= a);

    }



    function safeSub(uint a, uint b) public pure returns (uint c) {

        require(b <= a);

        c = a - b;

    }



    function safeMul(uint a, uint b) public pure returns (uint c) {

        c = a * b;

        require(a == 0 || c / a == b);

    }



    function safeDiv(uint a, uint b) public pure returns (uint c) {

        require(b > 0);

        c = a / b;

    }

}



contract ERC20Interface {

    function totalSupply() public constant returns (uint);



    function balanceOf(address tokenOwner) public constant returns (uint balance);



    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);



    function transfer(address to, uint tokens) public returns (bool success);



    function approve(address spender, uint tokens) public returns (bool success);



    function transferFrom(address from, address to, uint tokens) public returns (bool success);



    event Transfer(address indexed from, address indexed to, uint tokens);

    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

}



contract ApproveAndCallFallBack {

    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;

}



contract Owned {

    address public owner;

    address public newOwner;



    event OwnershipTransferred(address indexed _from, address indexed _to);

    constructor() public {

        owner = msg.sender;

    }

    modifier onlyOwner {

        require(msg.sender == owner);

        _;

    }

    function transferOwnership(address _newOwner) public onlyOwner {

        newOwner = _newOwner;

    }



    function acceptOwnership() public {

        require(msg.sender == newOwner);

        emit OwnershipTransferred(owner, newOwner);

        owner = newOwner;

        newOwner = address(0);

    }

}



contract LuxToken is ERC20Interface, Owned, SafeMath {

    string public symbol;

    string public  name;

    uint256 public constant decimals = 18;

    uint public _totalSupply;

    mapping(address => uint) balances;

    mapping(address => mapping(address => uint)) allowed;



    uint public constant supplyNumber = 80000000;

    uint public constant powNumber = 10;

    uint public constant TOKEN_SUPPLY_TOTAL = supplyNumber * powNumber ** decimals;



    constructor() public {

        symbol = "LXT";

        name = "LUX Token";

        _totalSupply = TOKEN_SUPPLY_TOTAL;

        balances[msg.sender] = _totalSupply;

        emit Transfer(address(0), msg.sender, _totalSupply);

    }

    function totalSupply() public constant returns (uint) {

        return _totalSupply - balances[address(0)];

    }



    function balanceOf(address tokenOwner) public constant returns (uint balance) {

        return balances[tokenOwner];

    }



    function transfer(address to, uint tokens) public returns (bool success) {

        balances[msg.sender] = safeSub(balances[msg.sender], tokens);

        balances[to] = safeAdd(balances[to], tokens);

        emit Transfer(msg.sender, to, tokens);

        return true;

    }



    function batchTransfer(address[] _receivers, uint256[] _amounts) public returns (bool) {

        uint256 cnt = _receivers.length;

        require(cnt > 0 && cnt <= 100);

        require(cnt == _amounts.length);

        cnt = (uint8)(cnt);

        uint256 totalAmount = 0;

        for (uint8 i = 0; i < cnt; i++) {

            totalAmount = safeAdd(totalAmount, _amounts[i]);

        }

        require(totalAmount <= balances[msg.sender]);

        balances[msg.sender] = safeSub(balances[msg.sender], totalAmount);

        for (i = 0; i < cnt; i++) {

            balances[_receivers[i]] = safeAdd(balances[_receivers[i]], _amounts[i]);

            emit Transfer(msg.sender, _receivers[i], _amounts[i]);

        }

        return true;

    }



    function approve(address spender, uint tokens) public returns (bool success) {

        allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);

        return true;

    }



    function transferFrom(address from, address to, uint tokens) public returns (bool success) {

        balances[from] = safeSub(balances[from], tokens);

        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);

        balances[to] = safeAdd(balances[to], tokens);

        emit Transfer(from, to, tokens);

        return true;

    }



    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {

        return allowed[tokenOwner][spender];

    }



    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {

        allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);

        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);

        return true;

    }



    function() public payable {

        revert();

    }



    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {

        return ERC20Interface(tokenAddress).transfer(owner, tokens);

    }



    function burn(uint256 _value) public {

        require(balances[msg.sender] >= _value);

        balances[msg.sender] -= _value;

        balances[0x0] += _value;

        emit Transfer(msg.sender, 0x0, _value);

    }

}