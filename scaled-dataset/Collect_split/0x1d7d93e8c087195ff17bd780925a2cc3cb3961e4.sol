// SPDX-License-Identifier: MIT



pragma solidity 0.6.12;







// Part: OpenZeppelin/openzeppelin-contracts@3.1.0/Address



/**

 * @dev Collection of functions related to the address type

 */

library Address {

    /**

     * @dev Returns true if `account` is a contract.

     *

     * [IMPORTANT]

     * ====

     * It is unsafe to assume that an address for which this function returns

     * false is an externally-owned account (EOA) and not a contract.

     *

     * Among others, `isContract` will return false for the following

     * types of addresses:

     *

     *  - an externally-owned account

     *  - a contract in construction

     *  - an address where a contract will be created

     *  - an address where a contract lived, but was destroyed

     * ====

     */

    function isContract(address account) internal view returns (bool) {

        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts

        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned

        // for accounts without code, i.e. `keccak256('')`

        bytes32 codehash;

        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;

        // solhint-disable-next-line no-inline-assembly

        assembly { codehash := extcodehash(account) }

        return (codehash != accountHash && codehash != 0x0);

    }



    /**

     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to

     * `recipient`, forwarding all available gas and reverting on errors.

     *

     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost

     * of certain opcodes, possibly making contracts go over the 2300 gas limit

     * imposed by `transfer`, making them unable to receive funds via

     * `transfer`. {sendValue} removes this limitation.

     *

     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].

     *

     * IMPORTANT: because control is transferred to `recipient`, care must be

     * taken to not create reentrancy vulnerabilities. Consider using

     * {ReentrancyGuard} or the

     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].

     */

    function sendValue(address payable recipient, uint256 amount) internal {

        require(address(this).balance >= amount, "Address: insufficient balance");



        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value

        (bool success, ) = recipient.call{ value: amount }("");

        require(success, "Address: unable to send value, recipient may have reverted");

    }



    /**

     * @dev Performs a Solidity function call using a low level `call`. A

     * plain`call` is an unsafe replacement for a function call: use this

     * function instead.

     *

     * If `target` reverts with a revert reason, it is bubbled up by this

     * function (like regular Solidity function calls).

     *

     * Returns the raw returned data. To convert to the expected return value,

     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].

     *

     * Requirements:

     *

     * - `target` must be a contract.

     * - calling `target` with `data` must not revert.

     *

     * _Available since v3.1._

     */

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {

      return functionCall(target, data, "Address: low-level call failed");

    }



    /**

     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with

     * `errorMessage` as a fallback revert reason when `target` reverts.

     *

     * _Available since v3.1._

     */

    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {

        return _functionCallWithValue(target, data, 0, errorMessage);

    }



    /**

     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],

     * but also transferring `value` wei to `target`.

     *

     * Requirements:

     *

     * - the calling contract must have an ETH balance of at least `value`.

     * - the called Solidity function must be `payable`.

     *

     * _Available since v3.1._

     */

    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {

        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");

    }



    /**

     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but

     * with `errorMessage` as a fallback revert reason when `target` reverts.

     *

     * _Available since v3.1._

     */

    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {

        require(address(this).balance >= value, "Address: insufficient balance for call");

        return _functionCallWithValue(target, data, value, errorMessage);

    }



    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {

        require(isContract(target), "Address: call to non-contract");



        // solhint-disable-next-line avoid-low-level-calls

        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);

        if (success) {

            return returndata;

        } else {

            // Look for revert reason and bubble it up if present

            if (returndata.length > 0) {

                // The easiest way to bubble the revert reason is using memory via assembly



                // solhint-disable-next-line no-inline-assembly

                assembly {

                    let returndata_size := mload(returndata)

                    revert(add(32, returndata), returndata_size)

                }

            } else {

                revert(errorMessage);

            }

        }

    }

}



// Part: OpenZeppelin/openzeppelin-contracts@3.1.0/IERC20



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



// Part: OpenZeppelin/openzeppelin-contracts@3.1.0/SafeMath



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



// Part: OpenZeppelin/openzeppelin-contracts@3.1.0/SafeERC20



/**

 * @title SafeERC20

 * @dev Wrappers around ERC20 operations that throw on failure (when the token

 * contract returns false). Tokens that return no value (and instead revert or

 * throw on failure) are also supported, non-reverting calls are assumed to be

 * successful.

 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,

 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.

 */

library SafeERC20 {

    using SafeMath for uint256;

    using Address for address;



    function safeTransfer(IERC20 token, address to, uint256 value) internal {

        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));

    }



    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {

        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));

    }



    /**

     * @dev Deprecated. This function has issues similar to the ones found in

     * {IERC20-approve}, and its usage is discouraged.

     *

     * Whenever possible, use {safeIncreaseAllowance} and

     * {safeDecreaseAllowance} instead.

     */

    function safeApprove(IERC20 token, address spender, uint256 value) internal {

        // safeApprove should only be called when setting an initial allowance,

        // or when resetting it to zero. To increase and decrease it, use

        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'

        // solhint-disable-next-line max-line-length

        require((value == 0) || (token.allowance(address(this), spender) == 0),

            "SafeERC20: approve from non-zero to non-zero allowance"

        );

        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));

    }



    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {

        uint256 newAllowance = token.allowance(address(this), spender).add(value);

        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));

    }



    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {

        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");

        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));

    }



    /**

     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement

     * on the return value: the return value is optional (but if data is returned, it must not be false).

     * @param token The token targeted by the call.

     * @param data The call data (encoded using abi.encode or one of its variants).

     */

    function _callOptionalReturn(IERC20 token, bytes memory data) private {

        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since

        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that

        // the target address contains contract code and also asserts for success in the low-level call.



        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional

            // solhint-disable-next-line max-line-length

            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");

        }

    }

}



// File: MasterChef.sol



contract MasterChef {

    using SafeERC20 for IERC20;

    using SafeMath for uint256;



    address public governance;

    address public pendingGovernance;

    address public guardian;

    uint256 public effectTime;

    uint256 constant public maxStartLeadTime = 60 days;

    uint256 constant public maxPeriod = 800 days;



    IERC20  public rewardToken;

    uint256 public totalReward;

    uint256 public totalGain;

    uint256 public intervalTime;



    uint256 public epochId;

    uint256 public reward;

    uint256 public startTime;

    uint256 public endTime;

    uint256 public period;



    // Total allocation poitns. Must be the sum of all allocation points in all pools.

    uint256 public totalAllocPoint;



    // Info of each user.

    struct UserInfo {

        uint256 depositTime;

        uint256 amount; // How many LP tokens the user has provided.

        uint256 rewardDebt; // Reward debt.

        uint256 reward;

        uint256 rewardDebtLp; // Reward debt.

        uint256 rewardLp;

    }

    // Info of each pool.

    struct PoolInfo {

        IERC20  lpToken; // Address of LP token contract.

        uint256 amount;  // How many LP tokens.

        uint256 lastRewardTime; // Last block number that Token distribution occurs.

        uint256 allocPoint; // How many allocation points assigned to this pool. Token to distribute per block.

        uint256 accTokenPerShare; // Accumulated Token per share, times 1e18. See below.

        address owner;

        address rewardToken;

        uint256 totalReward;

        uint256 epochId;

        uint256 reward;

        uint256 startTime;

        uint256 endTime;

        uint256 period;

        uint256 accRewardTokenPerShare; // Accumulated Token per share, times 1e18. See below.

    }

    struct EpochReward {

        uint256 epochId;

        uint256 startTime;

        uint256 endTime;

        uint256 reward;

    }

    mapping(uint256 => EpochReward) public epochRewards;

    mapping(uint256 => mapping(uint256 => EpochReward)) public lpEpochRewards;

    // Info of each user that stakes LP tokens.

    mapping(uint256 => mapping(address => UserInfo)) public userInfos;



    // Info of each pool.

    PoolInfo[] public poolInfos;



    event Deposit(address indexed user, uint256 indexed pid, uint256 amount);

    event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);

    event Harvest(address indexed user, uint256 indexed pid, uint256 reward, address rewardToken, uint256 rewardLp);

    event EmergencyWithdraw(address indexed user, uint256 indexed pid,  uint256 amount);

    event SetLpReward(uint256 indexed pid, uint256 indexed epochId, uint256 startTime, uint256 period, uint256 reward);



    constructor(address _rewardToken, uint256 _intervalTime) public {

        rewardToken = IERC20(_rewardToken);

        governance = msg.sender;

        guardian = msg.sender;

        intervalTime = _intervalTime;

        effectTime = block.timestamp + 60 days;

    }



    function setGuardian(address _guardian) external {

        require(msg.sender == guardian, "!guardian");

        guardian = _guardian;

    }

    function addGuardianTime(uint256 _addTime) external {

        require(msg.sender == guardian || msg.sender == governance, "!guardian");

        effectTime = effectTime.add(_addTime);

    }



    function acceptGovernance() external {

        require(msg.sender == pendingGovernance, "!pendingGovernance");

        governance = msg.sender;

        pendingGovernance = address(0);

    }

    function setPendingGovernance(address _pendingGovernance) external {

        require(msg.sender == governance, "!governance");

        pendingGovernance = _pendingGovernance;

    }



    function setIntervalTime(uint256 _intervalTime) external {

        require(msg.sender == governance, "!governance");

        intervalTime = _intervalTime;

    }

    function setAllocPoint(uint256 _pid, uint256 _allocPoint, bool _withUpdate) external {

        require(msg.sender == governance, "!governance");

        require(_pid < poolInfos.length, "!_pid");



        if (_withUpdate) {

            massUpdatePools();

        }

        totalAllocPoint = totalAllocPoint.sub(poolInfos[_pid].allocPoint).add(_allocPoint);

        require(totalAllocPoint > 0, "!totalAllocPoint");

        poolInfos[_pid].allocPoint = _allocPoint;

    }



    function addPool(address _lpToken, address _owner, uint256 _allocPoint, bool _withUpdate) external {

        require(msg.sender == governance, "!governance");



        uint256 length = poolInfos.length;

        for (uint256 i = 0; i < length; i++) {

            require(_lpToken != address(poolInfos[i].lpToken), "!_lpToken");

        }

        if (_withUpdate) {

            massUpdatePools();

        }



        totalAllocPoint = totalAllocPoint.add(_allocPoint);

        poolInfos.push(

            PoolInfo({

                lpToken: IERC20(_lpToken),

                amount: 0,

                lastRewardTime: block.timestamp,

                allocPoint: _allocPoint,

                accTokenPerShare: 0,

                owner: _owner,

                rewardToken: address(0),

                totalReward: 0,

                epochId: 0,

                reward: 0,

                startTime: 0,

                endTime: 0,

                period: 0,

                accRewardTokenPerShare: 0

            })

        );

    }



    function setLpRewardToken(uint256 _pid, address _rewardToken) external {

        require(_pid < poolInfos.length, "!_pid");

        PoolInfo storage pool = poolInfos[_pid];

        require(msg.sender == pool.owner || msg.sender == governance, "!pool.owner");

        require(pool.rewardToken == address(0), "!pool.rewardToken");

        pool.rewardToken = _rewardToken;

    }



    function setLpOwner(uint256 _pid, address _owner) external {

        require(_pid < poolInfos.length, "!_pid");

        PoolInfo storage pool = poolInfos[_pid];

        require(msg.sender == pool.owner || msg.sender == governance, "!pool.owner");

        pool.owner = _owner;

    }



    function setReward(uint256 _startTime, uint256 _period, uint256 _reward, bool _withUpdate) external {

        require(msg.sender == governance, "!governance");

        require(endTime < block.timestamp, "!endTime");

        require(block.timestamp <= _startTime, "!_startTime");

        require(_startTime <= block.timestamp + maxStartLeadTime, "!_startTime maxStartLeadTime");

        require(_period > 0, "!_period");

        require(_period <= maxPeriod, "!_period maxPeriod");



        if (_withUpdate) {

            massUpdatePools();

        }



        uint256 _balance = rewardToken.balanceOf(address(this));

        require(_balance >= _reward, "!_reward");

        totalReward = totalReward.add(_reward);

        reward = _reward;

        startTime = _startTime;

        endTime = _startTime.add(_period);

        period = _period;

        epochId++;



        epochRewards[epochId] = EpochReward({

            epochId: epochId,

            startTime: _startTime,

            endTime: endTime,

            reward: _reward

        });

    }



    function setLpReward(uint256 _pid, uint256 _startTime, uint256 _period, uint256 _reward) external {

        require(_pid < poolInfos.length, "!_pid");

        PoolInfo storage pool = poolInfos[_pid];

        require(msg.sender == pool.owner || msg.sender == governance, "!pool.owner");



        require(pool.rewardToken != address(0), "!pool.rewardToken");

        require(pool.endTime < block.timestamp, "!endTime");

        require(block.timestamp <= _startTime, "!_startTime");

        require(_startTime <= block.timestamp + maxStartLeadTime, "!_startTime maxStartLeadTime");

        require(_period > 0, "!_period");

        require(_period <= maxPeriod, "!_period maxPeriod");



        updatePool(_pid);

        IERC20(pool.rewardToken).safeTransferFrom(msg.sender, address(this), _reward);



        pool.totalReward = pool.totalReward.add(_reward);

        pool.epochId++;

        pool.reward = _reward;

        pool.startTime = _startTime;

        pool.endTime = _startTime.add(_period);

        pool.period = _period;



        lpEpochRewards[_pid][epochId] = EpochReward({

            epochId: epochId,

            startTime: _startTime,

            endTime: endTime,

            reward: _reward

        });

        emit SetLpReward(_pid, pool.epochId, _startTime, _period, _reward);

    }



    function getReward(uint256 _from, uint256 _to) public view returns (uint256) {

        if (_to <= startTime || _from >= endTime) {

            return 0;

        }



        if (_from < startTime) {

            _from = startTime; // [startTime, endTime)

        }



        if (_to > endTime) {

            _to = endTime;  // (startTime, endTime]

        }

        require(_from < _to, "!_from < _to");



        return _to.sub(_from).mul(reward).div(period);

    }



    function getLpReward(uint256 _pid, uint256 _from, uint256 _to) public view returns (uint256) {

        PoolInfo storage pool = poolInfos[_pid];

        uint256 _startTime = pool.startTime;

        uint256 _endTime = pool.endTime;

        if (_to <= _startTime || _from >= _endTime) {

            return 0;

        }



        if (_from < _startTime) {

            _from = _startTime; // [startTime, endTime)

        }



        if (_to > _endTime) {

            _to = _endTime;  // (startTime, endTime]

        }

        require(_from < _to, "!_from < _to");



        return _to.sub(_from).mul(pool.reward).div(pool.period);

    }



    // View function to see pending Token on frontend.

    function pendingToken(uint256 _pid, address _user) external view returns (uint256, uint256) {

        require(_pid < poolInfos.length, "!_pid");

        PoolInfo storage pool = poolInfos[_pid];

        UserInfo storage user = userInfos[_pid][_user];

        uint256 _accTokenPerShare = pool.accTokenPerShare;

        uint256 _accRewardTokenPerShare = pool.accRewardTokenPerShare;

        uint256 _lpSupply = pool.amount;

        if (block.timestamp > pool.lastRewardTime && _lpSupply != 0) {

            if (block.timestamp > startTime && pool.lastRewardTime < endTime) {

                uint256 _rewardAmount =  getReward(pool.lastRewardTime, block.timestamp);

                if (_rewardAmount > 0) {

                    _rewardAmount = _rewardAmount.mul(pool.allocPoint).div(totalAllocPoint);

                    _accTokenPerShare = _accTokenPerShare.add(_rewardAmount.mul(1e18).div(_lpSupply));

                }

            }

            if (block.timestamp > pool.startTime && pool.lastRewardTime < pool.endTime) {

                uint256 _rewardLpAmount =  getLpReward(_pid, pool.lastRewardTime, block.timestamp);

                if (_rewardLpAmount > 0) {

                    _accRewardTokenPerShare = _accRewardTokenPerShare.add(_rewardLpAmount.mul(1e18).div(_lpSupply));

                }

            }

        }

        uint256 _reward = user.amount.mul(_accTokenPerShare).div(1e18).sub(user.rewardDebt);

        uint256 _rewardLp = user.amount.mul(_accRewardTokenPerShare).div(1e18).sub(user.rewardDebtLp);

        return (user.reward.add(_reward), user.rewardLp.add(_rewardLp));

    }



    // Update reward vairables for all pools. Be careful of gas spending!

    function massUpdatePools() public {

        uint256 length = poolInfos.length;

        for (uint256 pid = 0; pid < length; ++pid) {

            updatePool(pid);

        }

    }



    // Update reward variables of the given pool to be up-to-date.

    function updatePool(uint256 _pid) public {

        require(_pid < poolInfos.length, "!_pid");



        _updateRewardPerShare(_pid);

        PoolInfo storage pool = poolInfos[_pid];

        uint256 _lastRewardTime = pool.lastRewardTime;

        if (block.timestamp <= _lastRewardTime) {

            return;

        }

        pool.lastRewardTime = block.timestamp;

        if (_lastRewardTime >= endTime) {

            return;

        }

        if (block.timestamp <= startTime) {

            return;

        }

        uint256 _lpSupply = pool.amount;

        if (_lpSupply == 0) {

            return;

        }



        uint256 _rewardAmount = getReward(_lastRewardTime, block.timestamp);

        if (_rewardAmount > 0) {

            _rewardAmount = _rewardAmount.mul(pool.allocPoint).div(totalAllocPoint);

            pool.accTokenPerShare = pool.accTokenPerShare.add(_rewardAmount.mul(1e18).div(_lpSupply));

        }

    }



    function _updateRewardPerShare(uint256 _pid) internal {

        PoolInfo storage pool = poolInfos[_pid];

        uint256 _lastRewardTime = pool.lastRewardTime;



        if (block.timestamp <= _lastRewardTime) {

            return;

        }

        if (_lastRewardTime >= pool.endTime) {

            return;

        }

        if (block.timestamp <= pool.startTime) {

            return;

        }



        uint256 _lpSupply = pool.amount;

        if (_lpSupply == 0) {

            return;

        }

        uint256 _rewardAmount = getLpReward(_pid, _lastRewardTime, block.timestamp);

        if (_rewardAmount > 0) {

            pool.accRewardTokenPerShare = pool.accRewardTokenPerShare.add(_rewardAmount.mul(1e18).div(_lpSupply));

        }

    }



    function deposit(uint256 _pid, uint256 _amount) external {

        require(_pid < poolInfos.length, "!_pid");

        PoolInfo storage pool = poolInfos[_pid];

        UserInfo storage user = userInfos[_pid][msg.sender];



        updatePool(_pid);

        if (user.amount > 0) {

            uint256 _reward = user.amount.mul(pool.accTokenPerShare).div(1e18).sub(user.rewardDebt);

            uint256 _rewardLp = user.amount.mul(pool.accRewardTokenPerShare).div(1e18).sub(user.rewardDebtLp);

            user.reward = _reward.add(user.reward);

            user.rewardLp = _rewardLp.add(user.rewardLp);

        }



        pool.lpToken.safeTransferFrom(msg.sender, address(this), _amount);

        user.depositTime = block.timestamp;

        user.amount = user.amount.add(_amount);

        pool.amount = pool.amount.add(_amount);

        user.rewardDebt = user.amount.mul(pool.accTokenPerShare).div(1e18);

        user.rewardDebtLp = user.amount.mul(pool.accRewardTokenPerShare).div(1e18);

        emit Deposit(msg.sender, _pid, _amount);

    }



    function withdraw(uint256 _pid, uint256 _amount) external {

        require(_pid < poolInfos.length, "!_pid");

        PoolInfo storage pool = poolInfos[_pid];

        UserInfo storage user = userInfos[_pid][msg.sender];

        require(user.amount >= _amount, "!_amount");

        require(block.timestamp >= user.depositTime + intervalTime, "!intervalTime");



        updatePool(_pid);

        uint256 _reward = user.amount.mul(pool.accTokenPerShare).div(1e18).sub(user.rewardDebt);

        uint256 _rewardLp = user.amount.mul(pool.accRewardTokenPerShare).div(1e18).sub(user.rewardDebtLp);

        user.reward = _reward.add(user.reward);

        user.rewardLp = _rewardLp.add(user.rewardLp);



        user.amount = user.amount.sub(_amount);

        pool.amount = pool.amount.sub(_amount);

        user.rewardDebt = user.amount.mul(pool.accTokenPerShare).div(1e18);

        user.rewardDebtLp = user.amount.mul(pool.accRewardTokenPerShare).div(1e18);

        pool.lpToken.safeTransfer(msg.sender, _amount);

        emit Withdraw(msg.sender, _pid, _amount);

    }



    function harvest(uint256 _pid) external {

        require(_pid < poolInfos.length, "!_pid");

        PoolInfo storage pool = poolInfos[_pid];

        UserInfo storage user = userInfos[_pid][msg.sender];



        updatePool(_pid);

        uint256 _reward = user.amount.mul(pool.accTokenPerShare).div(1e18).sub(user.rewardDebt);

        uint256 _rewardLp = user.amount.mul(pool.accRewardTokenPerShare).div(1e18).sub(user.rewardDebtLp);

        _reward = _reward.add(user.reward);

        _rewardLp = _rewardLp.add(user.rewardLp);



        user.reward = 0;

        user.rewardLp = 0;

        user.rewardDebt = user.amount.mul(pool.accTokenPerShare).div(1e18);

        user.rewardDebtLp = user.amount.mul(pool.accRewardTokenPerShare).div(1e18);

        address _rewardToken = pool.rewardToken;

        safeTokenTransfer(msg.sender, _reward, _rewardToken, _rewardLp);

        emit Harvest(msg.sender, _pid, _reward, _rewardToken, _rewardLp);

    }



    function withdrawAndHarvest(uint256 _pid, uint256 _amount) external {

        require(_pid < poolInfos.length, "!_pid");

        PoolInfo storage pool = poolInfos[_pid];

        UserInfo storage user = userInfos[_pid][msg.sender];

        require(user.amount >= _amount, "!_amount");

        require(block.timestamp >= user.depositTime + intervalTime, "!intervalTime");



        updatePool(_pid);

        uint256 _reward = user.amount.mul(pool.accTokenPerShare).div(1e18).sub(user.rewardDebt);

        uint256 _rewardLp = user.amount.mul(pool.accRewardTokenPerShare).div(1e18).sub(user.rewardDebtLp);

        _reward = _reward.add(user.reward);

        _rewardLp = _rewardLp.add(user.rewardLp);



        user.reward = 0;

        user.rewardLp = 0;

        user.amount = user.amount.sub(_amount);

        pool.amount = pool.amount.sub(_amount);

        user.rewardDebt = user.amount.mul(pool.accTokenPerShare).div(1e18);

        user.rewardDebtLp = user.amount.mul(pool.accRewardTokenPerShare).div(1e18);



        address _rewardToken = pool.rewardToken;

        safeTokenTransfer(msg.sender, _reward, _rewardToken, _rewardLp);



        pool.lpToken.safeTransfer(msg.sender, _amount);

        emit Withdraw(msg.sender, _pid, _amount);

        emit Harvest(msg.sender, _pid, _reward, _rewardToken, _rewardLp);

    }



    // Withdraw without caring about rewards. EMERGENCY ONLY.

    function emergencyWithdraw(uint256 _pid) external {

        require(_pid < poolInfos.length, "!_pid");

        PoolInfo storage pool = poolInfos[_pid];

        UserInfo storage user = userInfos[_pid][msg.sender];

        require(block.timestamp >= user.depositTime + 1, "!withdraw Time"); // prevent flash loan



        user.reward = 0;

        user.rewardLp = 0;

        user.rewardDebt = 0;

        user.rewardDebtLp = 0;

        uint256 _amount = user.amount;

        user.amount = 0;

        pool.amount = pool.amount.sub(_amount);

        pool.lpToken.safeTransfer(msg.sender, _amount);

        emit EmergencyWithdraw(msg.sender, _pid, _amount);

    }



    // Safe rewardToken transfer function, just in case if rounding error causes pool to not have enough Token.

    function safeTokenTransfer(address _to, uint256 _amount, address _rewardToken, uint256 _amountLp) internal {

        if (_amount > 0) {

            uint256 _balance = rewardToken.balanceOf(address(this));

            if (_amount > _balance) {

                totalGain = totalGain.add(_balance);

                rewardToken.safeTransfer(_to, _balance);

            } else {

                totalGain = totalGain.add(_amount);

                rewardToken.safeTransfer(_to, _amount);

            }

        }

        if (_amountLp > 0) {

            uint256 _balanceOther = IERC20(_rewardToken).balanceOf(address(this));

            if (_amountLp > _balanceOther) {

                IERC20(_rewardToken).safeTransfer(_to, _balanceOther);

            } else {

                IERC20(_rewardToken).safeTransfer(_to, _amountLp);

            }

        }

    }



    function poolLength() external view returns (uint256) {

        return poolInfos.length;

    }



    function annualReward(uint256 _pid) public view returns (uint256 _annual, uint256 _annualLp){

        require(_pid < poolInfos.length, "!_pid");

        PoolInfo storage pool = poolInfos[_pid];

        // SECS_PER_YEAR  31_556_952  365.2425 days

        if (period > 0) {

            _annual = reward.mul(31556952).mul(pool.allocPoint).div(totalAllocPoint).div(period);

        }

        if (pool.period > 0) {

            _annualLp = pool.reward.mul(31556952).div(pool.period);

        }

    }



    function annualRewardPerShare(uint256 _pid) public view returns (uint256, uint256){

        require(_pid < poolInfos.length, "!_pid");

        PoolInfo storage pool = poolInfos[_pid];

        if (pool.amount == 0) {

            return (0, 0);

        }

        (uint256 _annual, uint256 _annualLp) = annualReward(_pid);

        return (_annual.mul(1e18).div(pool.amount), _annualLp.mul(1e18).div(pool.amount));

    }



    function sweep(address _token) external {

        require(msg.sender == governance, "!governance");

        require(_token != address(rewardToken), "!_token");

        uint256 length = poolInfos.length;

        for (uint256 i = 0; i < length; i++) {

            require(_token != address(poolInfos[i].lpToken), "!_token");

            require(_token != poolInfos[i].rewardToken, "!_token");

        }



        uint256 _balance = IERC20(_token).balanceOf(address(this));

        IERC20(_token).safeTransfer(governance, _balance);

    }



    function sweepLpToken(uint256 _pid) external {

        require(msg.sender == governance, "!governance");

        require(_pid < poolInfos.length, "!_pid");

        PoolInfo storage pool = poolInfos[_pid];

        IERC20 _token = pool.lpToken;



        uint256 _balance = _token.balanceOf(address(this));

        uint256 _amount = _balance.sub(pool.amount);

        _token.safeTransfer(governance, _amount);

    }



    function sweepGuardian(address _token) external {

        require(msg.sender == guardian, "!guardian");

        require(block.timestamp > effectTime, "!effectTime");



        uint256 _balance = IERC20(_token).balanceOf(address(this));

        IERC20(_token).safeTransfer(governance, _balance);

    }



}