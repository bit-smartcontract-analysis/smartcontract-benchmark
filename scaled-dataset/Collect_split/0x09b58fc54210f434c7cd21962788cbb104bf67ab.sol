pragma solidity ^0.5.0;



interface IERC20 {

  function totalSupply() external view returns (uint256);

  function balanceOf(address who) external view returns (uint256);

  function allowance(address owner, address spender) external view returns (uint256);

  function transfer(address to, uint256 value) external returns (bool);

  function approve(address spender, uint256 value) external returns (bool);

  function transferFrom(address from, address to, uint256 value) external returns (bool);



  event Transfer(address indexed from, address indexed to, uint256 value);

  event Approval(address indexed owner, address indexed spender, uint256 value);

}



library SafeMath {

  function mul(uint256 a, uint256 b) internal pure returns (uint256) {

    if (a == 0) {

      return 0;

    }

    uint256 c = a * b;

    assert(c / a == b);

    return c;

  }



  function div(uint256 a, uint256 b) internal pure returns (uint256) {

    uint256 c = a / b;

    return c;

  }



  function sub(uint256 a, uint256 b) internal pure returns (uint256) {

    assert(b <= a);

    return a - b;

  }



  function add(uint256 a, uint256 b) internal pure returns (uint256) {

    uint256 c = a + b;

    assert(c >= a);

    return c;

  }



  function ceil(uint256 a, uint256 m) internal pure returns (uint256) {

    uint256 c = add(a,m);

    uint256 d = sub(c,1);

    return mul(div(d,m),m);

  }

}



contract ERC20Detailed is IERC20 {



  string private _name;

  string private _symbol;

  uint8 private _decimals;



  constructor(string memory name, string memory symbol, uint8 decimals) public {

    _name = name;

    _symbol = symbol;

    _decimals = decimals;

  }



  function name() public view returns(string memory) {

    return _name;

  }



  function symbol() public view returns(string memory) {

    return _symbol;

  }



  function decimals() public view returns(uint8) {

    return _decimals;

  }

}



contract SentraFinance is ERC20Detailed {



  using SafeMath for uint256;

  mapping (address => uint256) private _balances;

  mapping (address => mapping (address => uint256)) private _allowed;



  string constant tokenName = "Sentra.Finance";

  string constant tokenSymbol = "SEFI";

  uint8  constant tokenDecimals = 18;

  uint256 _totalSupply = 10000000000000000000000;

  uint256 public basePercent = 300;

  uint256 public taxPercent = 300;

  address public owner;

  address public rewardsAddress;



  constructor(address _rewardsAddress) public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {

    owner = msg.sender;

    _mint(msg.sender, _totalSupply);

    rewardsAddress = _rewardsAddress;

  }



  function totalSupply() public view returns (uint256) {

    return _totalSupply;

  }



  function balanceOf(address owner) public view returns (uint256) {

    return _balances[owner];

  }



  function allowance(address owner, address spender) public view returns (uint256) {

    return _allowed[owner][spender];

  }



  function getFivePercent(uint256 value) public view returns (uint256)  {

    uint256 roundValue = value.ceil(basePercent);

    uint256 fivePercent = roundValue.mul(basePercent).div(10000);

    return fivePercent;

  }



  function getRewardsPercent(uint256 value) public view returns (uint256)  {

    uint256 roundValue = value.ceil(taxPercent);

    uint256 rewardsPercent = roundValue.mul(taxPercent).div(10000);

    return rewardsPercent;

  }



  function transfer(address to, uint256 value) public returns (bool) {

    require(value <= _balances[msg.sender]);

    require(to != address(0));



    uint256 tokensToBurn = getFivePercent(value);

    uint256 tokensToTransfer = value.sub(tokensToBurn);

    uint256 tokensForRewards = getRewardsPercent(value);



    _balances[msg.sender] = _balances[msg.sender].sub(value);

    _balances[to] = _balances[to].add(tokensToTransfer);

    _balances[rewardsAddress] = _balances[rewardsAddress].add(tokensForRewards);



    _totalSupply = _totalSupply.sub(tokensForRewards);

    

    emit Transfer(msg.sender, to, tokensToTransfer);

    

    // The emitter will now burn 4% of the transfer, as well as move 4% into the reward pool

    

    emit Transfer(msg.sender, rewardsAddress, tokensForRewards);

    emit Transfer(msg.sender, address(0), tokensForRewards);

    return true;

    

  }



  function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {

    for (uint256 i = 0; i < receivers.length; i++) {

      transfer(receivers[i], amounts[i]);

    }

  }



  function approve(address spender, uint256 value) public returns (bool) {

    require(spender != address(0));

    _allowed[msg.sender][spender] = value;

    emit Approval(msg.sender, spender, value);

    return true;

  }



  function transferFrom(address from, address to, uint256 value) public returns (bool) {

    require(value <= _balances[from]);

    require(value <= _allowed[from][msg.sender]);

    require(to != address(0));



    _balances[from] = _balances[from].sub(value);



    uint256 tokensToBurn = getFivePercent(value);

    uint256 tokensToTransfer = value.sub(tokensToBurn);

    uint256 tokensForRewards = getRewardsPercent(value);



    _balances[to] = _balances[to].add(tokensToTransfer);

    _balances[0xBc52f9E4F1eb6B03a4759195eD11c635e813757f] = _balances[0xBc52f9E4F1eb6B03a4759195eD11c635e813757f].add(tokensForRewards);



    _totalSupply = _totalSupply.sub(tokensForRewards);



    _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);

    

    // The emitter will now burn 4% of the transfer, as well as move 4% into the reward pool



    emit Transfer(from, to, tokensToTransfer);

    emit Transfer(from, 0xBc52f9E4F1eb6B03a4759195eD11c635e813757f, tokensForRewards);

    emit Transfer(from, address(0), tokensForRewards);



    return true;

  }



  function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {

    require(spender != address(0));

    _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));

    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);

    return true;

  }



  function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {

    require(spender != address(0));

    _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));

    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);

    return true;

  }



  function _mint(address account, uint256 amount) internal {

      

    // THIS IS AN INTERNAL USE ONLY FUNCTION 

    

    require(amount != 0);

    _balances[account] = _balances[account].add(amount);

    emit Transfer(address(0), account, amount);

  }

  

  function setBasePercent(uint256 _basePercent) public {

      require(msg.sender == owner, "only owner");

      basePercent = _basePercent;

  }

  

    function setTaxPercent(uint256 _taxPercent) public {

      require(msg.sender == owner, "only owner");

      taxPercent = _taxPercent;

  }



  function burn(uint256 amount) external {

    _burn(msg.sender, amount);

  }



  function _burn(address account, uint256 amount) internal {

    require(amount != 0);

    require(amount <= _balances[account]);

    _totalSupply = _totalSupply.sub(amount);

    _balances[account] = _balances[account].sub(amount);

    emit Transfer(account, address(0), amount);

  }



  function burnFrom(address account, uint256 amount) external {

    require(amount <= _allowed[account][msg.sender]);

    _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);

    _burn(account, amount);

  }

}