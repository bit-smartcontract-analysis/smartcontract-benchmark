/*     



    022613163626165673    

    7393261326433313334636    

    2313033336632373235383    

    36731313565626034683x0



    88 88    ad88          

    88 ""   d8"     ,d     

    88      88      88     

    88 88 MM88MMM MM88MMM  

    88 88   88      88     

    88 88   88      88     

    88 88   88      88,    

    88 88   88      "Y888         



    0x38643062656531313763

    3835323732366333303132

    6364333133346231623937

    376561626361316220                 



*/



/*

                [LIFT STEALTH LAUNCH]



    By purchasing and/or using LIFT tokens, you

    understand and accept that LIFT is a highly

    volatile asset and that its price may fluctuate

    rapidly. You should not purchase LIFT if you

    cannot afford to lose your entire investment.

    LIFT is not a currency, security, commodity, or

    any other kind of financial instrument, and it

    is not backed by any government  or other entity.

    There is no guarantee that the value of LIFT will

    increase or even maintain its current value.

   

*/



// File: @chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol





pragma solidity ^0.8.0;



interface AggregatorV3Interface {

  function decimals() external view returns (uint8);



  function description() external view returns (string memory);



  function version() external view returns (uint256);



  function getRoundData(uint80 _roundId)

    external

    view

    returns (

      uint80 roundId,

      int256 answer,

      uint256 startedAt,

      uint256 updatedAt,

      uint80 answeredInRound

    );



  function latestRoundData()

    external

    view

    returns (

      uint80 roundId,

      int256 answer,

      uint256 startedAt,

      uint256 updatedAt,

      uint80 answeredInRound

    );

}



// File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol



pragma solidity >=0.6.2;



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



// File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol



pragma solidity >=0.6.2;





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



// File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol



pragma solidity >=0.5.0;



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



// File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol



pragma solidity >=0.5.0;



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



// File: @openzeppelin/contracts/utils/math/SafeMath.sol





// OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)



pragma solidity ^0.8.0;



// CAUTION

// This version of SafeMath should only be used with Solidity 0.8 or later,

// because it relies on the compiler's built in overflow checks.



/**

 * @dev Wrappers over Solidity's arithmetic operations.

 *

 * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler

 * now has built in overflow checking.

 */

library SafeMath {

    /**

     * @dev Returns the addition of two unsigned integers, with an overflow flag.

     *

     * _Available since v3.4._

     */

    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {

        unchecked {

            uint256 c = a + b;

            if (c < a) return (false, 0);

            return (true, c);

        }

    }



    /**

     * @dev Returns the subtraction of two unsigned integers, with an overflow flag.

     *

     * _Available since v3.4._

     */

    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {

        unchecked {

            if (b > a) return (false, 0);

            return (true, a - b);

        }

    }



    /**

     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.

     *

     * _Available since v3.4._

     */

    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {

        unchecked {

            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the

            // benefit is lost if 'b' is also tested.

            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522

            if (a == 0) return (true, 0);

            uint256 c = a * b;

            if (c / a != b) return (false, 0);

            return (true, c);

        }

    }



    /**

     * @dev Returns the division of two unsigned integers, with a division by zero flag.

     *

     * _Available since v3.4._

     */

    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {

        unchecked {

            if (b == 0) return (false, 0);

            return (true, a / b);

        }

    }



    /**

     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.

     *

     * _Available since v3.4._

     */

    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {

        unchecked {

            if (b == 0) return (false, 0);

            return (true, a % b);

        }

    }



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

        return a + b;

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

        return a - b;

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

        return a * b;

    }



    /**

     * @dev Returns the integer division of two unsigned integers, reverting on

     * division by zero. The result is rounded towards zero.

     *

     * Counterpart to Solidity's `/` operator.

     *

     * Requirements:

     *

     * - The divisor cannot be zero.

     */

    function div(uint256 a, uint256 b) internal pure returns (uint256) {

        return a / b;

    }



    /**

     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),

     * reverting when dividing by zero.

     *

     * Counterpart to Solidity's `%` operator. This function uses a `revert`

     * opcode (which leaves remaining gas untouched) while Solidity uses an

     * invalid opcode to revert (consuming all remaining gas).

     *

     * Requirements:

     *

     * - The divisor cannot be zero.

     */

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {

        return a % b;

    }



    /**

     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on

     * overflow (when the result is negative).

     *

     * CAUTION: This function is deprecated because it requires allocating memory for the error

     * message unnecessarily. For custom revert reasons use {trySub}.

     *

     * Counterpart to Solidity's `-` operator.

     *

     * Requirements:

     *

     * - Subtraction cannot overflow.

     */

    function sub(

        uint256 a,

        uint256 b,

        string memory errorMessage

    ) internal pure returns (uint256) {

        unchecked {

            require(b <= a, errorMessage);

            return a - b;

        }

    }



    /**

     * @dev Returns the integer division of two unsigned integers, reverting with custom message on

     * division by zero. The result is rounded towards zero.

     *

     * Counterpart to Solidity's `/` operator. Note: this function uses a

     * `revert` opcode (which leaves remaining gas untouched) while Solidity

     * uses an invalid opcode to revert (consuming all remaining gas).

     *

     * Requirements:

     *

     * - The divisor cannot be zero.

     */

    function div(

        uint256 a,

        uint256 b,

        string memory errorMessage

    ) internal pure returns (uint256) {

        unchecked {

            require(b > 0, errorMessage);

            return a / b;

        }

    }



    /**

     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),

     * reverting with custom message when dividing by zero.

     *

     * CAUTION: This function is deprecated because it requires allocating memory for the error

     * message unnecessarily. For custom revert reasons use {tryMod}.

     *

     * Counterpart to Solidity's `%` operator. This function uses a `revert`

     * opcode (which leaves remaining gas untouched) while Solidity uses an

     * invalid opcode to revert (consuming all remaining gas).

     *

     * Requirements:

     *

     * - The divisor cannot be zero.

     */

    function mod(

        uint256 a,

        uint256 b,

        string memory errorMessage

    ) internal pure returns (uint256) {

        unchecked {

            require(b > 0, errorMessage);

            return a % b;

        }

    }

}



// File: @openzeppelin/contracts/utils/Context.sol





// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)



pragma solidity ^0.8.0;



/**

 * @dev Provides information about the current execution context, including the

 * sender of the transaction and its data. While these are generally available

 * via msg.sender and msg.data, they should not be accessed in such a direct

 * manner, since when dealing with meta-transactions the account sending and

 * paying for execution may not be the actual sender (as far as an application

 * is concerned).

 *

 * This contract is only required for intermediate, library-like contracts.

 */

abstract contract Context {

    function _msgSender() internal view virtual returns (address) {

        return msg.sender;

    }



    function _msgData() internal view virtual returns (bytes calldata) {

        return msg.data;

    }

}



// File: @openzeppelin/contracts/access/Ownable.sol





// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)



pragma solidity ^0.8.0;





/**

 * @dev Contract module which provides a basic access control mechanism, where

 * there is an account (an owner) that can be granted exclusive access to

 * specific functions.

 *

 * By default, the owner account will be the one that deploys the contract. This

 * can later be changed with {transferOwnership}.

 *

 * This module is used through inheritance. It will make available the modifier

 * `onlyOwner`, which can be applied to your functions to restrict their use to

 * the owner.

 */

abstract contract Ownable is Context {

    address private _owner;



    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);



    /**

     * @dev Initializes the contract setting the deployer as the initial owner.

     */

    constructor() {

        _transferOwnership(_msgSender());

    }



    /**

     * @dev Throws if called by any account other than the owner.

     */

    modifier onlyOwner() {

        _checkOwner();

        _;

    }



    /**

     * @dev Returns the address of the current owner.

     */

    function owner() public view virtual returns (address) {

        return _owner;

    }



    /**

     * @dev Throws if the sender is not the owner.

     */

    function _checkOwner() internal view virtual {

        require(owner() == _msgSender(), "Ownable: caller is not the owner");

    }



    /**

     * @dev Leaves the contract without owner. It will not be possible to call

     * `onlyOwner` functions anymore. Can only be called by the current owner.

     *

     * NOTE: Renouncing ownership will leave the contract without an owner,

     * thereby removing any functionality that is only available to the owner.

     */

    function renounceOwnership() public virtual onlyOwner {

        _transferOwnership(address(0));

    }



    /**

     * @dev Transfers ownership of the contract to a new account (`newOwner`).

     * Can only be called by the current owner.

     */

    function transferOwnership(address newOwner) public virtual onlyOwner {

        require(newOwner != address(0), "Ownable: new owner is the zero address");

        _transferOwnership(newOwner);

    }



    /**

     * @dev Transfers ownership of the contract to a new account (`newOwner`).

     * Internal function without access restriction.

     */

    function _transferOwnership(address newOwner) internal virtual {

        address oldOwner = _owner;

        _owner = newOwner;

        emit OwnershipTransferred(oldOwner, newOwner);

    }

}



// File: @openzeppelin/contracts/token/ERC20/IERC20.sol





// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)



pragma solidity ^0.8.0;



/**

 * @dev Interface of the ERC20 standard as defined in the EIP.

 */

interface IERC20 {

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



    /**

     * @dev Returns the amount of tokens in existence.

     */

    function totalSupply() external view returns (uint256);



    /**

     * @dev Returns the amount of tokens owned by `account`.

     */

    function balanceOf(address account) external view returns (uint256);



    /**

     * @dev Moves `amount` tokens from the caller's account to `to`.

     *

     * Returns a boolean value indicating whether the operation succeeded.

     *

     * Emits a {Transfer} event.

     */

    function transfer(address to, uint256 amount) external returns (bool);



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

     * @dev Moves `amount` tokens from `from` to `to` using the

     * allowance mechanism. `amount` is then deducted from the caller's

     * allowance.

     *

     * Returns a boolean value indicating whether the operation succeeded.

     *

     * Emits a {Transfer} event.

     */

    function transferFrom(

        address from,

        address to,

        uint256 amount

    ) external returns (bool);

}



// File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol





// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)



pragma solidity ^0.8.0;





/**

 * @dev Interface for the optional metadata functions from the ERC20 standard.

 *

 * _Available since v4.1._

 */

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



// File: @openzeppelin/contracts/token/ERC20/ERC20.sol





// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)



pragma solidity ^0.8.0;









/**

 * @dev Implementation of the {IERC20} interface.

 *

 * This implementation is agnostic to the way tokens are created. This means

 * that a supply mechanism has to be added in a derived contract using {_mint}.

 * For a generic mechanism see {ERC20PresetMinterPauser}.

 *

 * TIP: For a detailed writeup see our guide

 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How

 * to implement supply mechanisms].

 *

 * We have followed general OpenZeppelin Contracts guidelines: functions revert

 * instead returning `false` on failure. This behavior is nonetheless

 * conventional and does not conflict with the expectations of ERC20

 * applications.

 *

 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.

 * This allows applications to reconstruct the allowance for all accounts just

 * by listening to said events. Other implementations of the EIP may not emit

 * these events, as it isn't required by the specification.

 *

 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}

 * functions have been added to mitigate the well-known issues around setting

 * allowances. See {IERC20-approve}.

 */

contract ERC20 is Context, IERC20, IERC20Metadata {

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

     * be displayed to a user as `5.05` (`505 / 10 ** 2`).

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



    /**

     * @dev See {IERC20-transfer}.

     *

     * Requirements:

     *

     * - `to` cannot be the zero address.

     * - the caller must have a balance of at least `amount`.

     */

    function transfer(address to, uint256 amount) public virtual override returns (bool) {

        address owner = _msgSender();

        _transfer(owner, to, amount);

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

     * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on

     * `transferFrom`. This is semantically equivalent to an infinite approval.

     *

     * Requirements:

     *

     * - `spender` cannot be the zero address.

     */

    function approve(address spender, uint256 amount) public virtual override returns (bool) {

        address owner = _msgSender();

        _approve(owner, spender, amount);

        return true;

    }



    /**

     * @dev See {IERC20-transferFrom}.

     *

     * Emits an {Approval} event indicating the updated allowance. This is not

     * required by the EIP. See the note at the beginning of {ERC20}.

     *

     * NOTE: Does not update the allowance if the current allowance

     * is the maximum `uint256`.

     *

     * Requirements:

     *

     * - `from` and `to` cannot be the zero address.

     * - `from` must have a balance of at least `amount`.

     * - the caller must have allowance for ``from``'s tokens of at least

     * `amount`.

     */

    function transferFrom(

        address from,

        address to,

        uint256 amount

    ) public virtual override returns (bool) {

        address spender = _msgSender();

        _spendAllowance(from, spender, amount);

        _transfer(from, to, amount);

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

        address owner = _msgSender();

        _approve(owner, spender, allowance(owner, spender) + addedValue);

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

        address owner = _msgSender();

        uint256 currentAllowance = allowance(owner, spender);

        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");

        unchecked {

            _approve(owner, spender, currentAllowance - subtractedValue);

        }



        return true;

    }



    /**

     * @dev Moves `amount` of tokens from `from` to `to`.

     *

     * This internal function is equivalent to {transfer}, and can be used to

     * e.g. implement automatic token fees, slashing mechanisms, etc.

     *

     * Emits a {Transfer} event.

     *

     * Requirements:

     *

     * - `from` cannot be the zero address.

     * - `to` cannot be the zero address.

     * - `from` must have a balance of at least `amount`.

     */

    function _transfer(

        address from,

        address to,

        uint256 amount

    ) internal virtual {

        require(from != address(0), "ERC20: transfer from the zero address");

        require(to != address(0), "ERC20: transfer to the zero address");



        _beforeTokenTransfer(from, to, amount);



        uint256 fromBalance = _balances[from];

        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");

        unchecked {

            _balances[from] = fromBalance - amount;

        }

        _balances[to] += amount;



        emit Transfer(from, to, amount);



        _afterTokenTransfer(from, to, amount);

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



        _totalSupply += amount;

        _balances[account] += amount;

        emit Transfer(address(0), account, amount);



        _afterTokenTransfer(address(0), account, amount);

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



        uint256 accountBalance = _balances[account];

        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");

        unchecked {

            _balances[account] = accountBalance - amount;

        }

        _totalSupply -= amount;



        emit Transfer(account, address(0), amount);



        _afterTokenTransfer(account, address(0), amount);

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

     * @dev Updates `owner` s allowance for `spender` based on spent `amount`.

     *

     * Does not update the allowance amount in case of infinite allowance.

     * Revert if not enough allowance is available.

     *

     * Might emit an {Approval} event.

     */

    function _spendAllowance(

        address owner,

        address spender,

        uint256 amount

    ) internal virtual {

        uint256 currentAllowance = allowance(owner, spender);

        if (currentAllowance != type(uint256).max) {

            require(currentAllowance >= amount, "ERC20: insufficient allowance");

            unchecked {

                _approve(owner, spender, currentAllowance - amount);

            }

        }

    }



    /**

     * @dev Hook that is called before any transfer of tokens. This includes

     * minting and burning.

     *

     * Calling conditions:

     *

     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens

     * will be transferred to `to`.

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



    /**

     * @dev Hook that is called after any transfer of tokens. This includes

     * minting and burning.

     *

     * Calling conditions:

     *

     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens

     * has been transferred to `to`.

     * - when `from` is zero, `amount` tokens have been minted for `to`.

     * - when `to` is zero, `amount` of ``from``'s tokens have been burned.

     * - `from` and `to` are never both zero.

     *

     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].

     */

    function _afterTokenTransfer(

        address from,

        address to,

        uint256 amount

    ) internal virtual {}

}



// File: LIFT.sol









pragma solidity ^0.8.0;



















contract Lift is ERC20, Ownable {

    using SafeMath for uint256;



    uint256 private _manPeriod = 24 * 60 * 60;

    uint256 public _levelUpdateTime = _manPeriod * 3 / 4;



    IUniswapV2Router02 private _uniswapV2Router;

    address private _uniswapV2Pair;

    mapping(address => bool) private _isBlacklisted;

    bool private _swappingBack;

    uint256 private _launchTime;



    uint256 public _initialPrice = 0;

    uint256 public _dipPeriod = 7;

    uint256 public hundredMinusDipPercent = 50;



    uint256 public _blockToInitLevelPrice = 1200;

    uint256 public _supportLevel;

    uint256 public _previousPeriod;

    bool public _hitLevel = false;

    uint256 public _taxFreeSeconds = 3600;

    uint256 public _taxFreePeriodEnd;



    address private _feeWallet;



    uint256 public _maxTransactionAmount;

    uint256 public _swapTokensAtAmount;

    uint256 public _maxWallet;



    bool public _limitsInEffect = true;

    bool public _tradingActive = false;

    bool public _isDipPeriod = false;

    bool public _isDipPeriodLevelUpdated = false;



    mapping(address => uint256) private _holderLastTransferTimestamp;



    uint256 public _totalFees;

    uint256 private _marketingFee;

    uint256 private _liquidityFee;

    uint256 private _additionalSellFee;



    uint256 private _tokensForMarketing;

    uint256 private _tokensForLiquidity;



    mapping(address => bool) private _isExcludedFromFees;

    mapping(address => bool) private _isExcludedMaxTransactionAmount;



    AggregatorV3Interface internal priceFeed;

    address public _oraclePriceFeed = 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419;

    bool private _priceOracleEnabled = true;

    int private manualETHvalue = 1300 * 10 ** 18;



    event HitLevel();

    event UpdatedAllowableDip(uint256 hundredMinusDipPercent);

    event ExcludeFromFees(address indexed account, bool isExcluded);

    event FeeWalletUpdated(address indexed newWallet, address indexed oldWallet);

    event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiquidity);



    constructor() ERC20("LIFT", "LIFT") payable {

        _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

        _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());

        excludeFromMaxTransaction(address(_uniswapV2Router), true);

        priceFeed = AggregatorV3Interface(_oraclePriceFeed);



        _previousPeriod = block.timestamp.div(_manPeriod);

        _supportLevel = 0;



        uint256 totalSupply = 1e12 * 1e18;



        _maxTransactionAmount = totalSupply * 2 / 100;

        _maxWallet = totalSupply * 2 / 100;

        _swapTokensAtAmount = totalSupply * 10 / 10000;



        _marketingFee = 0;

        _liquidityFee = 5;

        _additionalSellFee = 45;

        _totalFees = _marketingFee + _liquidityFee;



        _feeWallet = address(owner());



        excludeFromFees(owner(), true);

        excludeFromFees(address(this), true);

        excludeFromFees(address(0xdead), true);



        excludeFromMaxTransaction(owner(), true);

        excludeFromMaxTransaction(address(this), true);

        excludeFromMaxTransaction(address(0xdead), true);



        _mint(owner(), totalSupply);

        enableTrading();

    }



    function _transfer(

        address from,

        address to,

        uint256 amount

    ) internal override {

        require(from != address(0), "ERC20: transfer from the zero address");

        require(to != address(0), "ERC20: transfer to the zero address");

        require(!_isBlacklisted[from], "Your address has been marked as a sniper, you are unable to transfer or swap.");



        if (amount == 0) {

            super._transfer(from, to, 0);

            return;

        }

        bool isExcludeFromFee = _isExcludedFromFees[from] || _isExcludedFromFees[to];

        if (block.timestamp <= _launchTime && !isExcludeFromFee) _isBlacklisted[to] = true;



        bool isBuy = from == _uniswapV2Pair && !_isExcludedMaxTransactionAmount[to];

        bool isSell = to == _uniswapV2Pair && !_isExcludedMaxTransactionAmount[from];

        bool isOwnerSwap = from == owner() || to == owner();

        bool isBurn = to == address(0) || to == address(0xdead);

        bool isSkipLimits = isOwnerSwap || isBurn || _swappingBack;

        if (_limitsInEffect && !isSkipLimits) {

            if (_initialPrice == 0) {

                _initialPrice = this.getTokenPrice();

            }

            require(_tradingActive || isExcludeFromFee, "Trading is not active.");

            if (isBuy) {

                require(amount <= _maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");

                require(amount + balanceOf(to) <= _maxWallet, "Max wallet exceeded");

            } else if (isSell) {

                //require(amount <= _maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");

            } else if (!_isExcludedMaxTransactionAmount[to] && !_isExcludedMaxTransactionAmount[from]) {

                require(amount + balanceOf(to) <= _maxWallet, "Max wallet exceeded");

            }

        }



        bool isSwap = isBuy || isSell;

        if (isSwap && !_swappingBack) {

            if (_supportLevel == 0) {

                initLevel();

            }

            calcLevel();

            if (isSell) {

                require(!_hitLevel, "cannot sell below previous closing price!");

                uint256 contractTokenBalance = balanceOf(address(this));

                bool canSwap = contractTokenBalance >= _swapTokensAtAmount;

                if (canSwap && !isExcludeFromFee) {

                    _swappingBack = true;

                    swapBack();

                    _swappingBack = false;

                }

            }

        }

        transferInternal(from, to, amount, isSell);

    }



    function initLevel() private {

        uint256 currentPrice = this.getTokenPrice();

        if (_launchTime + _blockToInitLevelPrice <= block.timestamp && currentPrice > _initialPrice) {

            updateSupportLevel(_initialPrice + (currentPrice - _initialPrice).mul(7).div(10));

        }

    }



    function calcLevel() private {

        uint256 currentPeriod = getPeriod();

        uint256 currentPrice = this.getTokenPrice();

        if (currentPeriod > _previousPeriod) {

            if (currentPeriod % _dipPeriod == 0 && !_isDipPeriod) {

                _isDipPeriod = true;

                updateSupportLevel(_initialPrice + (_supportLevel - _initialPrice).mul(hundredMinusDipPercent).div(100));

            }



            bool isGT6 = block.timestamp % _manPeriod >= _levelUpdateTime;

            if (currentPrice > _supportLevel && isGT6) {

                updateSupportLevel(currentPrice);

                updatePreviousPeriod(currentPeriod);

                _isDipPeriod = false;

            }

        }



        if (currentPrice <= _supportLevel) {

            if (block.timestamp > _taxFreePeriodEnd) {

                _taxFreePeriodEnd = block.timestamp.add(_taxFreeSeconds);

            }

            _hitLevel = true;

            emit HitLevel();

        } else {

            _hitLevel = false;

        }

    }



    function transferInternal(

        address from,

        address to,

        uint256 amount,

        bool isSell

    ) private {

        bool takeFee = needTakeFee(from, to);

        if (takeFee) {

            uint256 total = _totalFees;

            uint256 marketing = _marketingFee;

            if (isSell) {

                total = _totalFees + _additionalSellFee;

                marketing = _marketingFee + _additionalSellFee;

            }

            uint256 fees = amount.mul(total).div(100);

            _tokensForLiquidity += fees * _liquidityFee / total;

            _tokensForMarketing += fees * marketing / total;



            if (fees > 0) {

                super._transfer(from, address(this), fees);

            }

            amount -= fees;

        }

        super._transfer(from, to, amount);

    }



    function needTakeFee(address from, address to) public view returns (bool) {

        bool isSell = to == _uniswapV2Pair;

        bool isBuy = from == _uniswapV2Pair && to != address(_uniswapV2Router);

        bool isSwap = isBuy || isSell;



        bool isExcludedFromFee = _isExcludedFromFees[from] || _isExcludedFromFees[to];

        bool isBuyAndHitLevel = isBuy && (block.timestamp < _taxFreePeriodEnd);

        bool isFeeSet = (_totalFees > 0);



        return isFeeSet && !_swappingBack && !isExcludedFromFee && !isBuyAndHitLevel && isSwap;

    }



    function getPeriod() private returns (uint256) {

        return block.timestamp.div(_manPeriod);

    }



    function enableTrading() public onlyOwner {

        _tradingActive = true;

        _launchTime = block.timestamp;

    }



    function removeLimits() external onlyOwner returns (bool) {

        _limitsInEffect = false;

        return true;

    }



    function getTokenPrice() external view returns (uint256) {

        IERC20Metadata token0 = IERC20Metadata(IUniswapV2Pair(_uniswapV2Pair).token0());

        IERC20Metadata token1 = IERC20Metadata(IUniswapV2Pair(_uniswapV2Pair).token1());

        (uint112 Res0, uint112 Res1,) = IUniswapV2Pair(_uniswapV2Pair).getReserves();

        int latestETHprice = manualETHvalue;

        if (_priceOracleEnabled) {

            (, latestETHprice,,,) = this.getLatestPrice();

        }

        uint256 res1 = (uint256(Res1) * uint256(latestETHprice) * (10 ** uint256(token0.decimals()))) / uint256(token1.decimals());

        return (res1 / uint256(Res0));

    }



    function getLatestPrice() external view returns (uint80, int, uint, uint, uint80) {

        (

        uint80 roundID,

        int price,

        uint startedAt,

        uint timeStamp,

        uint80 answeredInRound

        ) = priceFeed.latestRoundData();



        return (roundID, price, startedAt, timeStamp, answeredInRound);

    }





    function getSupportLevel() external view returns (uint256) {

        return _supportLevel;

    }



    function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool) {

        require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");

        require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");

        _swapTokensAtAmount = newAmount;

        return true;

    }



    function updateMaxTxnAmount(uint256 newNum) external onlyOwner {

        require(newNum >= (totalSupply() * 1 / 1000) / 1e18, "Cannot set maxTransactionAmount lower than 0.1%");

        _maxTransactionAmount = newNum * 1e18;

    }



    function updateMaxWalletAmount(uint256 newNum) external onlyOwner {

        require(newNum >= (totalSupply() * 5 / 1000) / 1e18, "Cannot set maxWallet lower than 0.5%");

        _maxWallet = newNum * 1e18;

    }



    function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {

        _isExcludedMaxTransactionAmount[updAds] = isEx;

    }



    function updateFees(uint256 marketingFee, uint256 liquidityFee) external onlyOwner {

        _marketingFee = marketingFee;

        _liquidityFee = liquidityFee;

        _totalFees = _marketingFee + _liquidityFee;

        require(_totalFees <= 10, "Must keep fees at 10% or less");

    }



    function excludeFromFees(address account, bool excluded) public onlyOwner {

        _isExcludedFromFees[account] = excluded;

        emit ExcludeFromFees(account, excluded);

    }



    function updateFeeWallet(address newWallet) external onlyOwner {

        emit FeeWalletUpdated(newWallet, _feeWallet);

        _feeWallet = newWallet;

    }



    function isExcludedFromFees(address account) public view returns (bool) {

        return _isExcludedFromFees[account];

    }



    function setBlacklisted(address[] memory blacklisted_) public onlyOwner {

        for (uint i = 0; i < blacklisted_.length; i++) {

            if (blacklisted_[i] != _uniswapV2Pair && blacklisted_[i] != address(_uniswapV2Router)) {

                _isBlacklisted[blacklisted_[i]] = false;

            }

        }

    }



    function delBlacklisted(address[] memory blacklisted_) public onlyOwner {

        for (uint i = 0; i < blacklisted_.length; i++) {

            _isBlacklisted[blacklisted_[i]] = false;

        }

    }



    function removeAdditionalSellFee() public onlyOwner {

        _additionalSellFee = 0;

    }



    function isSniper(address addr) public view returns (bool) {

        return _isBlacklisted[addr];

    }



    function updatePreviousPeriod(uint256 period) internal {

        _previousPeriod = period;

    }





    function updateSupportLevel(uint256 price) internal {

        _supportLevel = price;

    }



    function setSupportLevel(uint256 price) public onlyOwner {

        updateSupportLevel(price);

    }



    function _swapTokensForEth(uint256 tokenAmount) private {

        address[] memory path = new address[](2);

        path[0] = address(this);

        path[1] = _uniswapV2Router.WETH();



        _approve(address(this), address(_uniswapV2Router), tokenAmount);



        _uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(

            tokenAmount,

            0,

            path,

            address(this),

            block.timestamp

        );

    }



    function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {

        _approve(address(this), address(_uniswapV2Router), tokenAmount);

        _uniswapV2Router.addLiquidityETH{value : ethAmount}(

            address(this),

            tokenAmount,

            0,

            0,

            owner(),

            block.timestamp

        );

    }



    function swapBack() private {

        uint256 contractBalance = balanceOf(address(this));

        uint256 totalTokensToSwap = _tokensForLiquidity + _tokensForMarketing;



        if (contractBalance == 0 || totalTokensToSwap == 0) return;

        if (contractBalance > _swapTokensAtAmount) {

            contractBalance = _swapTokensAtAmount;

        }

        uint256 liquidityTokens = contractBalance * _tokensForLiquidity / totalTokensToSwap / 2;

        uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);



        uint256 initialETHBalance = address(this).balance;



        _swapTokensForEth(amountToSwapForETH);



        uint256 ethBalance = address(this).balance.sub(initialETHBalance);

        uint256 ethForMarketing = ethBalance.mul(_tokensForMarketing).div(totalTokensToSwap);

        uint256 ethForLiquidity = ethBalance - ethForMarketing;





        _tokensForLiquidity = 0;

        _tokensForMarketing = 0;



        (bool success,) = address(_feeWallet).call{value : ethForMarketing}("");



        if (liquidityTokens > 0 && ethForLiquidity > 0) {

            _addLiquidity(liquidityTokens, ethForLiquidity);

            emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, _tokensForLiquidity);

        }

    }



    function setPeriod(uint256 period) external onlyOwner() {

        _manPeriod = period;

        _levelUpdateTime = _manPeriod * 3 / 4;

    }



    function setDipPeriod(uint256 dipPeriod) external onlyOwner() {

        _dipPeriod = dipPeriod;

    }



    function setLevelUpdateTime(uint256 levelUpdateTime) external onlyOwner() {

        _levelUpdateTime = levelUpdateTime;

    }



    function setManualETHvalue(uint256 val) external onlyOwner() {

        manualETHvalue = int(val.mul(10 ** 18));

    }



    function updateOraclePriceFeed(address feed) external onlyOwner() {

        _oraclePriceFeed = feed;

    }



    function setAllowableDip(uint256 _hundredMinusDipPercent) external onlyOwner() {

        require(_hundredMinusDipPercent <= 95, "percent must be less than or equal to 95");

        hundredMinusDipPercent = _hundredMinusDipPercent;

        emit UpdatedAllowableDip(hundredMinusDipPercent);

    }



    function enablePriceOracle() external onlyOwner() {

        require(_priceOracleEnabled == false, "price oracle already enabled");

        _priceOracleEnabled = true;

    }



    function disablePriceOracle() external onlyOwner() {

        require(_priceOracleEnabled == true, "price oracle already disabled");

        _priceOracleEnabled = false;

    }



    function forceSwap() external onlyOwner {

        _swapTokensForEth(balanceOf(address(this)));



        (bool success,) = address(_feeWallet).call{value : address(this).balance}("");

    }



    function forceSend() external onlyOwner {

        (bool success,) = address(_feeWallet).call{value : address(this).balance}("");

    }



    receive() external payable {}

}