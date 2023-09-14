// Sources flattened with hardhat v2.4.3 https://hardhat.org



// File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.1.0



// SPDX-License-Identifier: MIT



pragma solidity ^0.6.0;



/**

 * @dev Interface of the ERC20 standard as defined in the EIP.

 */

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

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);



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





// File @openzeppelin/contracts/math/SafeMath.sol@v3.1.0





pragma solidity ^0.6.0;



/**

 * @dev Wrappers over Solidity's arithmetic operations with added overflow

 * checks.

 *

 * Arithmetic operations in Solidity wrap on overflow. This can easily result

 * in bugs, because programmers usually assume that an overflow raises an

 * error, which is the standard behavior in high level programming languages.

 * `SafeMath` restores this intuition by reverting the transaction when an

 * operation overflows.

 *

 * Using this library instead of the unchecked operations eliminates an entire

 * class of bugs, so it's recommended to use it always.

 */

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



    /**

     * @dev Returns the integer division of two unsigned integers. Reverts on

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

    function div(uint256 a, uint256 b) internal pure returns (uint256) {

        return div(a, b, "SafeMath: division by zero");

    }



    /**

     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on

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

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b > 0, errorMessage);

        uint256 c = a / b;

        // assert(a == b * c + a % b); // There is no case in which this doesn't hold



        return c;

    }



    /**

     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),

     * Reverts when dividing by zero.

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

        return mod(a, b, "SafeMath: modulo by zero");

    }



    /**

     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),

     * Reverts with custom message when dividing by zero.

     *

     * Counterpart to Solidity's `%` operator. This function uses a `revert`

     * opcode (which leaves remaining gas untouched) while Solidity uses an

     * invalid opcode to revert (consuming all remaining gas).

     *

     * Requirements:

     *

     * - The divisor cannot be zero.

     */

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b != 0, errorMessage);

        return a % b;

    }

}





// File contracts/sone-smart-contracts/uniswapv2/interfaces/IUniswapV2Pair.sol



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





// File contracts/sone-smart-contracts/uniswapv2/interfaces/IUniswapV2Factory.sol



pragma solidity >=0.5.0;



interface IUniswapV2Factory {

    event PairCreated(address indexed token0, address indexed token1, address pair, uint);



    function feeTo() external view returns (address);

    function withdrawFeeTo() external view returns (address);

    function swapFee() external view returns (uint);

    function withdrawFee() external view returns (uint);

    function soneConvert() external view returns (address);

    

    function feeSetter() external view returns (address);

    function migrator() external view returns (address);



    function getPair(address tokenA, address tokenB) external view returns (address pair);

    function allPairs(uint) external view returns (address pair);

    function allPairsLength() external view returns (uint);



    function createPair(address tokenA, address tokenB) external returns (address pair);



    function setFeeTo(address) external;

    function setWithdrawFeeTo(address) external;

    function setSwapFee(uint) external;

    function setFeeSetter(address) external;

    function setMigrator(address) external;

    function setSoneConvert(address) external;

}





// File contracts/sone-smart-contracts/uniswapv2/libraries/UniswapV2Library.sol



pragma solidity >=0.5.0;







library UniswapV2Library {

    using SafeMath for uint;



    // returns sorted token addresses, used to handle return values from pairs sorted in this order

    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {

        require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');

        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);

        require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');

    }



    function pairFor(address factory, address tokenA, address tokenB) internal view returns (address pair) {

        return IUniswapV2Factory(factory).getPair(tokenA, tokenB);

    }



    // fetches and sorts the reserves for a pair

    function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {

        (address token0,) = sortTokens(tokenA, tokenB);

        address pair = pairFor(factory, tokenA, tokenB);

        (uint reserve0, uint reserve1,) = IUniswapV2Pair(pair).getReserves();

        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);

    }



    // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset

    function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {

        require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');

        require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');

        amountB = amountA.mul(reserveB) / reserveA;

    }



    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset

    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut, uint swapFee) internal pure returns (uint amountOut) {

        require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');

        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');

        uint amountInWithFee = amountIn.mul(1000 - swapFee);

        uint numerator = amountInWithFee.mul(reserveOut);

        uint denominator = reserveIn.mul(1000).add(amountInWithFee);

        amountOut = numerator / denominator;

    }



    // given an output amount of an asset and pair reserves, returns a required input amount of the other asset

    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut, uint swapFee) internal pure returns (uint amountIn) {

        require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');

        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');

        uint numerator = reserveIn.mul(amountOut).mul(1000);

        uint denominator = reserveOut.sub(amountOut).mul(1000 - swapFee);

        amountIn = (numerator / denominator).add(1);

    }



    // performs chained getAmountOut calculations on any number of pairs

    function getAmountsOut(address factory, uint amountIn, address[] memory path, uint swapFee) internal view returns (uint[] memory amounts) {

        require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');

        amounts = new uint[](path.length);

        amounts[0] = amountIn;

        for (uint i; i < path.length - 1; i++) {

            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);

            amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut, swapFee);

        }

    }



    // performs chained getAmountIn calculations on any number of pairs

    function getAmountsIn(address factory, uint amountOut, address[] memory path, uint swapFee) internal view returns (uint[] memory amounts) {

        require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');

        amounts = new uint[](path.length);

        amounts[amounts.length - 1] = amountOut;

        for (uint i = path.length - 1; i > 0; i--) {

            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);

            amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut, swapFee);

        }

    }

}





// File contracts/sone-smart-contracts/uniswapv2/libraries/TransferHelper.sol



pragma solidity >=0.6.0;



// helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false

library TransferHelper {

    function safeApprove(address token, address to, uint value) internal {

        // bytes4(keccak256(bytes('approve(address,uint256)')));

        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));

        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');

    }



    function safeTransfer(address token, address to, uint value) internal {

        // bytes4(keccak256(bytes('transfer(address,uint256)')));

        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));

        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');

    }



    function safeTransferFrom(address token, address from, address to, uint value) internal {

        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));

        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));

        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');

    }



    function safeTransferETH(address to, uint value) internal {

        (bool success,) = to.call{value:value}(new bytes(0));

        require(success, 'TransferHelper: ETH_TRANSFER_FAILED');

    }

}





// File contracts/sone-smart-contracts/uniswapv2/interfaces/IUniswapV2Router01.sol



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

    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external view returns (uint amountOut);

    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external view returns (uint amountIn);

    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);

    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);

}





// File contracts/sone-smart-contracts/uniswapv2/interfaces/IUniswapV2Router02.sol



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





// File contracts/sone-smart-contracts/uniswapv2/interfaces/IWETH.sol



pragma solidity >=0.5.0;



interface IWETH {

    function deposit() external payable;

    function transfer(address to, uint value) external returns (bool);

    function withdraw(uint) external;

}





// File contracts/sone-smart-contracts/uniswapv2/UniswapV2Router02.sol



pragma solidity =0.6.12;















contract UniswapV2Router02 is IUniswapV2Router02 {

    using SafeMath for uint;



    address public override factory;

    address public override WETH;



    modifier ensure(uint deadline) {

        require(deadline >= block.timestamp, 'UniswapV2Router: EXPIRED');

        _;

    }



    constructor(address _factory, address _WETH) public {

        factory = _factory;

        WETH = _WETH;

    }



    receive() external payable {

        assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract

    }



    // **** ADD LIQUIDITY ****

    function _addLiquidity(

        address tokenA,

        address tokenB,

        uint amountADesired,

        uint amountBDesired,

        uint amountAMin,

        uint amountBMin

    ) internal virtual returns (uint amountA, uint amountB) {

        // create the pair if it doesn't exist yet

        if (IUniswapV2Factory(factory).getPair(tokenA, tokenB) == address(0)) {

            IUniswapV2Factory(factory).createPair(tokenA, tokenB);

        }

        (uint reserveA, uint reserveB) = UniswapV2Library.getReserves(factory, tokenA, tokenB);

        if (reserveA == 0 && reserveB == 0) {

            (amountA, amountB) = (amountADesired, amountBDesired);

        } else {

            uint amountBOptimal = UniswapV2Library.quote(amountADesired, reserveA, reserveB);

            if (amountBOptimal <= amountBDesired) {

                require(amountBOptimal >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');

                (amountA, amountB) = (amountADesired, amountBOptimal);

            } else {

                uint amountAOptimal = UniswapV2Library.quote(amountBDesired, reserveB, reserveA);

                assert(amountAOptimal <= amountADesired);

                require(amountAOptimal >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');

                (amountA, amountB) = (amountAOptimal, amountBDesired);

            }

        }

    }

    function addLiquidity(

        address tokenA,

        address tokenB,

        uint amountADesired,

        uint amountBDesired,

        uint amountAMin,

        uint amountBMin,

        address to,

        uint deadline

    ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {

        (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);

        address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);

        TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);

        TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);

        liquidity = IUniswapV2Pair(pair).mint(to);

    }

    function addLiquidityETH(

        address token,

        uint amountTokenDesired,

        uint amountTokenMin,

        uint amountETHMin,

        address to,

        uint deadline

    ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {

        (amountToken, amountETH) = _addLiquidity(

            token,

            WETH,

            amountTokenDesired,

            msg.value,

            amountTokenMin,

            amountETHMin

        );

        address pair = UniswapV2Library.pairFor(factory, token, WETH);

        TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);

        IWETH(WETH).deposit{value: amountETH}();

        assert(IWETH(WETH).transfer(pair, amountETH));

        liquidity = IUniswapV2Pair(pair).mint(to);

        // refund dust eth, if any

        if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);

    }



    // **** REMOVE LIQUIDITY ****

    function removeLiquidity(

        address tokenA,

        address tokenB,

        uint liquidity,

        uint amountAMin,

        uint amountBMin,

        address to,

        uint deadline

    ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {

        address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);

        IUniswapV2Pair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair

        (uint amount0, uint amount1) = IUniswapV2Pair(pair).burn(to);

        (address token0,) = UniswapV2Library.sortTokens(tokenA, tokenB);

        (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);

        require(amountA >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');

        require(amountB >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');

    }

    function removeLiquidityETH(

        address token,

        uint liquidity,

        uint amountTokenMin,

        uint amountETHMin,

        address to,

        uint deadline

    ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {

        (amountToken, amountETH) = removeLiquidity(

            token,

            WETH,

            liquidity,

            amountTokenMin,

            amountETHMin,

            address(this),

            deadline

        );

        TransferHelper.safeTransfer(token, to, amountToken);

        IWETH(WETH).withdraw(amountETH);

        TransferHelper.safeTransferETH(to, amountETH);

    }

    function removeLiquidityWithPermit(

        address tokenA,

        address tokenB,

        uint liquidity,

        uint amountAMin,

        uint amountBMin,

        address to,

        uint deadline,

        bool approveMax, uint8 v, bytes32 r, bytes32 s

    ) external virtual override returns (uint amountA, uint amountB) {

        address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);

        uint value = approveMax ? uint(-1) : liquidity;

        IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);

        (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);

    }

    function removeLiquidityETHWithPermit(

        address token,

        uint liquidity,

        uint amountTokenMin,

        uint amountETHMin,

        address to,

        uint deadline,

        bool approveMax, uint8 v, bytes32 r, bytes32 s

    ) external virtual override returns (uint amountToken, uint amountETH) {

        address pair = UniswapV2Library.pairFor(factory, token, WETH);

        uint value = approveMax ? uint(-1) : liquidity;

        IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);

        (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);

    }



    // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****

    function removeLiquidityETHSupportingFeeOnTransferTokens(

        address token,

        uint liquidity,

        uint amountTokenMin,

        uint amountETHMin,

        address to,

        uint deadline

    ) public virtual override ensure(deadline) returns (uint amountETH) {

        (, amountETH) = removeLiquidity(

            token,

            WETH,

            liquidity,

            amountTokenMin,

            amountETHMin,

            address(this),

            deadline

        );

        TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));

        IWETH(WETH).withdraw(amountETH);

        TransferHelper.safeTransferETH(to, amountETH);

    }

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(

        address token,

        uint liquidity,

        uint amountTokenMin,

        uint amountETHMin,

        address to,

        uint deadline,

        bool approveMax, uint8 v, bytes32 r, bytes32 s

    ) external virtual override returns (uint amountETH) {

        address pair = UniswapV2Library.pairFor(factory, token, WETH);

        uint value = approveMax ? uint(-1) : liquidity;

        IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);

        amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(

            token, liquidity, amountTokenMin, amountETHMin, to, deadline

        );

    }



    // **** SWAP ****

    // requires the initial amount to have already been sent to the first pair

    function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {

        for (uint i; i < path.length - 1; i++) {

            (address input, address output) = (path[i], path[i + 1]);

            (address token0,) = UniswapV2Library.sortTokens(input, output);

            uint amountOut = amounts[i + 1];

            (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));

            address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;

            IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output)).swap(

                amount0Out, amount1Out, to, new bytes(0)

            );

        }

    }

    function swapExactTokensForTokens(

        uint amountIn,

        uint amountOutMin,

        address[] calldata path,

        address to,

        uint deadline

    ) external virtual override ensure(deadline) returns (uint[] memory amounts) {

        amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path, IUniswapV2Factory(factory).swapFee());

        require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');

        TransferHelper.safeTransferFrom(

            path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]

        );

        _swap(amounts, path, to);

    }

    function swapTokensForExactTokens(

        uint amountOut,

        uint amountInMax,

        address[] calldata path,

        address to,

        uint deadline

    ) external virtual override ensure(deadline) returns (uint[] memory amounts) {

        amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path, IUniswapV2Factory(factory).swapFee());

        require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');

        TransferHelper.safeTransferFrom(

            path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]

        );

        _swap(amounts, path, to);

    }

    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)

        external

        virtual

        override

        payable

        ensure(deadline)

        returns (uint[] memory amounts)

    {

        require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');

        amounts = UniswapV2Library.getAmountsOut(factory, msg.value, path, IUniswapV2Factory(factory).swapFee());

        require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');

        IWETH(WETH).deposit{value: amounts[0]}();

        assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));

        _swap(amounts, path, to);

    }

    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)

        external

        virtual

        override

        ensure(deadline)

        returns (uint[] memory amounts)

    {

        require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');

        amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path, IUniswapV2Factory(factory).swapFee());

        require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');

        TransferHelper.safeTransferFrom(

            path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]

        );

        _swap(amounts, path, address(this));

        IWETH(WETH).withdraw(amounts[amounts.length - 1]);

        TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);

    }

    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)

        external

        virtual

        override

        ensure(deadline)

        returns (uint[] memory amounts)

    {

        require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');

        amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path, IUniswapV2Factory(factory).swapFee());

        require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');

        TransferHelper.safeTransferFrom(

            path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]

        );

        _swap(amounts, path, address(this));

        IWETH(WETH).withdraw(amounts[amounts.length - 1]);

        TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);

    }

    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)

        external

        virtual

        override

        payable

        ensure(deadline)

        returns (uint[] memory amounts)

    {

        require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');

        amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path, IUniswapV2Factory(factory).swapFee());

        require(amounts[0] <= msg.value, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');

        IWETH(WETH).deposit{value: amounts[0]}();

        assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));

        _swap(amounts, path, to);

        // refund dust eth, if any

        if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);

    }



    // **** SWAP (supporting fee-on-transfer tokens) ****

    // requires the initial amount to have already been sent to the first pair

    function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {

        for (uint i; i < path.length - 1; i++) {

            (address input, address output) = (path[i], path[i + 1]);

            (address token0,) = UniswapV2Library.sortTokens(input, output);

            IUniswapV2Pair pair = IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output));

            uint amountInput;

            uint amountOutput;

            { // scope to avoid stack too deep errors

            (uint reserve0, uint reserve1,) = pair.getReserves();

            (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);

            amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);

            amountOutput = UniswapV2Library.getAmountOut(amountInput, reserveInput, reserveOutput, IUniswapV2Factory(factory).swapFee());

            }

            (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));

            address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;

            pair.swap(amount0Out, amount1Out, to, new bytes(0));

        }

    }

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(

        uint amountIn,

        uint amountOutMin,

        address[] calldata path,

        address to,

        uint deadline

    ) external virtual override ensure(deadline) {

        TransferHelper.safeTransferFrom(

            path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn

        );

        uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);

        _swapSupportingFeeOnTransferTokens(path, to);

        require(

            IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,

            'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'

        );

    }

    function swapExactETHForTokensSupportingFeeOnTransferTokens(

        uint amountOutMin,

        address[] calldata path,

        address to,

        uint deadline

    )

        external

        virtual

        override

        payable

        ensure(deadline)

    {

        require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');

        uint amountIn = msg.value;

        IWETH(WETH).deposit{value: amountIn}();

        assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn));

        uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);

        _swapSupportingFeeOnTransferTokens(path, to);

        require(

            IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,

            'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'

        );

    }

    function swapExactTokensForETHSupportingFeeOnTransferTokens(

        uint amountIn,

        uint amountOutMin,

        address[] calldata path,

        address to,

        uint deadline

    )

        external

        virtual

        override

        ensure(deadline)

    {

        require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');

        TransferHelper.safeTransferFrom(

            path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn

        );

        _swapSupportingFeeOnTransferTokens(path, address(this));

        uint amountOut = IERC20(WETH).balanceOf(address(this));

        require(amountOut >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');

        IWETH(WETH).withdraw(amountOut);

        TransferHelper.safeTransferETH(to, amountOut);

    }



    // **** LIBRARY FUNCTIONS ****

    function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {

        return UniswapV2Library.quote(amountA, reserveA, reserveB);

    }



    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)

        public

        view

        virtual

        override

        returns (uint amountOut)

    {

        return UniswapV2Library.getAmountOut(amountIn, reserveIn, reserveOut, IUniswapV2Factory(factory).swapFee());

    }



    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)

        public

        view

        virtual

        override

        returns (uint amountIn)

    {

        return UniswapV2Library.getAmountIn(amountOut, reserveIn, reserveOut, IUniswapV2Factory(factory).swapFee());

    }



    function getAmountsOut(uint amountIn, address[] memory path)

        public

        view

        virtual

        override

        returns (uint[] memory amounts)

    {

        return UniswapV2Library.getAmountsOut(factory, amountIn, path, IUniswapV2Factory(factory).swapFee());

    }



    function getAmountsIn(uint amountOut, address[] memory path)

        public

        view

        virtual

        override

        returns (uint[] memory amounts)

    {

        return UniswapV2Library.getAmountsIn(factory, amountOut, path, IUniswapV2Factory(factory).swapFee());

    }

}





// File contracts/sone-smart-contracts/interfaces/ISoneConvert.sol



pragma solidity >=0.5.0;



interface ISoneConvert {

	function convertToSone(

		address token0,

		address token1,

		uint256 liquidity,

		uint256 totalSupply,

		address to

	) external;

}





// File contracts/sone-smart-contracts/SoneSwapRouter.sol



pragma solidity =0.6.12;





contract SoneSwapRouter is UniswapV2Router02 {

	constructor(address factory_, address WETH_) public UniswapV2Router02(factory_, WETH_) {}



	function swapExactTokensForTokensNoFee(

		uint256 amountIn,

		uint256 amountOutMin,

		address[] calldata path,

		address to,

		uint256 deadline

	) external ensure(deadline) returns (uint256[] memory amounts) {

		require(msg.sender == IUniswapV2Factory(factory).soneConvert(), 'Caller is not SoneConvert.');

		amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path, 0);

		if (amounts[1] == 0) return new uint256[](2);

		(address token0, address token1) = UniswapV2Library.sortTokens(path[0], path[1]);

		(uint256 reserve0, uint256 reserve1) = UniswapV2Library.getReserves(factory, path[0], path[1]);

		if (token0 == path[1] && reserve0 < amounts[1]) return new uint256[](2);

		if (token1 == path[1] && reserve1 < amounts[1]) return new uint256[](2);

		require(amounts[1] >= amountOutMin, "UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT");

		TransferHelper.safeTransferFrom(path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]);

		_swap(amounts, path, to);

	}



	function removeLiquidity(

		address tokenA,

		address tokenB,

		uint256 liquidity,

		uint256 amountAMin,

		uint256 amountBMin,

		address to,

		uint256 deadline

	) public virtual override ensure(deadline) returns (uint256 amountA, uint256 amountB) {

		address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);

		uint256 totalSupply = IUniswapV2Pair(pair).totalSupply();

		(amountA, amountB) = _removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);

		_convert(tokenA, tokenB, liquidity, totalSupply, to);

	}



	function removeLiquidityETH(

		address token,

		uint256 liquidity,

		uint256 amountTokenMin,

		uint256 amountETHMin,

		address to,

		uint256 deadline

	) public virtual override ensure(deadline) returns (uint256 amountToken, uint256 amountETH) {

		address pair = UniswapV2Library.pairFor(factory, token, WETH);

		uint256 totalSupply = IUniswapV2Pair(pair).totalSupply();

		(amountToken, amountETH) = _removeLiquidity(token, WETH, liquidity, amountTokenMin, amountETHMin, address(this), deadline);

		TransferHelper.safeTransfer(token, to, amountToken);

		IWETH(WETH).withdraw(amountETH);

		TransferHelper.safeTransferETH(to, amountETH);

		_convert(token, WETH, liquidity, totalSupply, to);

	}



	// **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****

	function removeLiquidityETHSupportingFeeOnTransferTokens(

		address token,

		uint256 liquidity,

		uint256 amountTokenMin,

		uint256 amountETHMin,

		address to,

		uint256 deadline

	) public virtual override ensure(deadline) returns (uint256 amountETH) {

		address pair = UniswapV2Library.pairFor(factory, token, WETH);

		uint256 totalSupply = IUniswapV2Pair(pair).totalSupply();

		(, amountETH) = _removeLiquidity(token, WETH, liquidity, amountTokenMin, amountETHMin, address(this), deadline);

		TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));

		IWETH(WETH).withdraw(amountETH);

		TransferHelper.safeTransferETH(to, amountETH);

		_convert(token, WETH, liquidity, totalSupply, to);

	}



	function _removeLiquidity(

		address tokenA,

		address tokenB,

		uint256 liquidity,

		uint256 amountAMin,

		uint256 amountBMin,

		address to,

		uint256 deadline

	) internal ensure(deadline) returns (uint256 amountA, uint256 amountB) {

		address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);

		IUniswapV2Pair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair

		(uint256 amount0, uint256 amount1) = IUniswapV2Pair(pair).burn(to);

		(address token0, ) = UniswapV2Library.sortTokens(tokenA, tokenB);

		(amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);

		require(amountA >= amountAMin, "UniswapV2Router: INSUFFICIENT_A_AMOUNT");

		require(amountB >= amountBMin, "UniswapV2Router: INSUFFICIENT_B_AMOUNT");

	}



	function addLiquidityOneToken(

		uint256 amountIn,

		uint256 amountAMin,

		uint256 amountBMin,

		uint256 amountOutMin,

		address[] calldata path,

		address to,

		uint256 deadline

	)

		external

		virtual

		ensure(deadline)

		returns (

			uint256 amountA,

			uint256 amountB,

			uint256 liquidity

		)

	{

		uint256 _amountTokenIn = amountIn.div(2);

		uint256[] memory amounts = _swapExactTokensForTokensOneMode(_amountTokenIn, amountOutMin, path, to);

		address _to = to;

		{

			uint256 _amountAMin = amountAMin;

			uint256 _amountBMin = amountBMin;

			(amountA, amountB, liquidity) = _addLiquidityOneMode(path[0], path[1], _amountTokenIn, amounts[1], _amountAMin, _amountBMin, _to);

		}

	}



	function addLiquidityOneTokenETHExactETH(

		uint256 amountTokenMin,

		uint256 amountETHMin,

		uint256 amountOutTokenMin,

		address[] calldata path,

		address to,

		uint256 deadline

	)

		external

		payable

		virtual

		ensure(deadline)

		returns (

			uint256 amountToken,

			uint256 amountETH,

			uint256 liquidity

		)

	{

		uint256[] memory amounts = _swapExactETHForTokensOneMode(msg.value.div(2), amountOutTokenMin, path, to);

		(amountToken, amountETH, liquidity) = _addLiquidityETHOneMode(path[1], amounts[1], msg.value.div(2), amountTokenMin, amountETHMin, to);

	}



	function addLiquidityOneTokenETHExactToken(

		uint256 amountIn,

		uint256 amountTokenMin,

		uint256 amountETHMin,

		uint256 amountOutETHMin,

		address[] calldata path,

		address to,

		uint256 deadline

	)

		external

		payable

		virtual

		ensure(deadline)

		returns (

			uint256 amountToken,

			uint256 amountETH,

			uint256 liquidity

		)

	{

		uint256 _amountIn = amountIn.div(2);

		uint256[] memory amounts = _swapExactTokensForETHOneMode(_amountIn, amountOutETHMin, path);

		{

			address _to = to;

			uint256 _amountTokenMin = amountTokenMin;

			uint256 _amountETHMin = amountETHMin;

			(amountToken, amountETH, liquidity) = _addLiquidityETHOneMode(path[0], _amountIn, amounts[1], _amountTokenMin, _amountETHMin, _to);

		}

	}



	function _convert(

		address tokenA,

		address tokenB,

		uint256 liquidity,

		uint256 totalSupply,

		address to

	) internal {

		if (IUniswapV2Factory(factory).soneConvert() != address(0)) {

			ISoneConvert(IUniswapV2Factory(factory).soneConvert()).convertToSone(tokenA, tokenB, liquidity, totalSupply, to);

		}

	}



	function _swapExactTokensForTokensOneMode(

		uint256 amountIn,

		uint256 amountOutMin,

		address[] calldata path,

		address to

	) private returns (uint256[] memory amounts) {

		amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path, IUniswapV2Factory(factory).swapFee());

		require(amounts[1] >= amountOutMin, "UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT");

		TransferHelper.safeTransferFrom(path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]);

		_swap(amounts, path, to);

	}



	function _addLiquidityOneMode(

		address tokenA,

		address tokenB,

		uint256 amountADesired,

		uint256 amountBDesired,

		uint256 amountAMin,

		uint256 amountBMin,

		address to

	)

		private

		returns (

			uint256 amountA,

			uint256 amountB,

			uint256 liquidity

		)

	{

		(amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);

		address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);

		TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);

		TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);

		liquidity = IUniswapV2Pair(pair).mint(to);

	}



	function _swapExactETHForTokensOneMode(

		uint256 amountETHMin,

		uint256 amountOutMin,

		address[] calldata path,

		address to

	) private returns (uint256[] memory amounts) {

		require(path[0] == WETH, "UniswapV2Router: INVALID_PATH");

		amounts = UniswapV2Library.getAmountsOut(factory, amountETHMin, path, IUniswapV2Factory(factory).swapFee());

		require(amounts[1] >= amountOutMin, "UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT");

		IWETH(WETH).deposit{value: amounts[0]}();

		assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));

		_swap(amounts, path, to);

	}



	function _addLiquidityETHOneMode(

		address token,

		uint256 amountTokenDesired,

		uint256 amountETHDesired,

		uint256 amountTokenMin,

		uint256 amountETHMin,

		address to

	)

		private

		returns (

			uint256 amountToken,

			uint256 amountETH,

			uint256 liquidity

		)

	{

		(amountToken, amountETH) = _addLiquidity(token, WETH, amountTokenDesired, amountETHDesired, amountTokenMin, amountETHMin);

		address pair = UniswapV2Library.pairFor(factory, token, WETH);

		TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);

		IWETH(WETH).deposit{value: amountETH}();

		assert(IWETH(WETH).transfer(pair, amountETH));

		liquidity = IUniswapV2Pair(pair).mint(to);

		// refund dust eth, if any

		if (amountETHDesired > amountETH) TransferHelper.safeTransferETH(msg.sender, amountETHDesired - amountETH);

	}



	function _swapExactTokensForETHOneMode(

		uint256 amountIn,

		uint256 amountOutMin,

		address[] calldata path

	) private returns (uint256[] memory amounts) {

		require(path[1] == WETH, "UniswapV2Router: INVALID_PATH");

		amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path, IUniswapV2Factory(factory).swapFee());

		require(amounts[1] >= amountOutMin, "UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT");

		TransferHelper.safeTransferFrom(path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]);

		_swap(amounts, path, address(this));

		IWETH(WETH).withdraw(amounts[1]);

	}

}