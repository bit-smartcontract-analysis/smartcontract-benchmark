pragma solidity ^0.5.0;

pragma experimental ABIEncoderV2;

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

contract Context {

    function _msgSender() internal view  returns (address payable) {

        return msg.sender;

    }



    function _msgData() internal view  returns (bytes memory) {

        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691

        return msg.data;

    }

}



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

     * @dev Converts an `address` into `address payable`. Note that this is

     * simply a type cast: the actual underlying value is not changed.

     *

     * _Available since v2.4.0._

     */

    function toPayable(address account) internal pure returns (address payable) {

        return address(uint160(account));

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

     *

     * _Available since v2.4.0._

     */

    function sendValue(address payable recipient, uint256 amount) internal {

        require(address(this).balance >= amount, "Address: insufficient balance");



        // solhint-disable-next-line avoid-call-value

        (bool success, ) = recipient.call.value(amount)("");

        require(success, "Address: unable to send value, recipient may have reverted");

    }

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

    function mint(address recipient, uint256 amount) external returns (bool);

    function burn(uint256 amount) external returns (bool);



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

        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));

    }



    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {

        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));

    }



    function safeApprove(IERC20 token, address spender, uint256 value) internal {

        // safeApprove should only be called when setting an initial allowance,

        // or when resetting it to zero. To increase and decrease it, use

        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'

        // solhint-disable-next-line max-line-length

        require((value == 0) || (token.allowance(address(this), spender) == 0),

            "SafeERC20: approve from non-zero to non-zero allowance"

        );

        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));

    }



    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {

        uint256 newAllowance = token.allowance(address(this), spender).add(value);

        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));

    }



    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {

        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");

        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));

    }



    /**

     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement

     * on the return value: the return value is optional (but if data is returned, it must not be false).

     * @param token The token targeted by the call.

     * @param data The call data (encoded using abi.encode or one of its variants).

     */

    function callOptionalReturn(IERC20 token, bytes memory data) private {

        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since

        // we're implementing it ourselves.



        // A Solidity high level call has three parts:

        //  1. The target address is checked to verify it contains contract code

        //  2. The call itself is made, and success asserted

        //  3. The return value is decoded, which in turn checks the size of the returned data.

        // solhint-disable-next-line max-line-length

        require(address(token).isContract(), "SafeERC20: call to non-contract");



        // solhint-disable-next-line avoid-low-level-calls

        (bool success, bytes memory returndata) = address(token).call(data);

        require(success, "SafeERC20: low-level call failed");



        if (returndata.length > 0) { // Return data is optional

            // solhint-disable-next-line max-line-length

            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");

        }

    }

}

contract Ownable is Context {

    address private _owner;



    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);



    /**

     * @dev Initializes the contract setting the deployer as the initial owner.

     */

    constructor () internal {

        address msgSender = _msgSender();

        _owner = msgSender;

        emit OwnershipTransferred(address(0), msgSender);

    }



    /**

     * @dev Returns the address of the current owner.

     */

    function owner() public view returns (address) {

        return _owner;

    }



    /**

     * @dev Throws if called by any account other than the owner.

     */

    modifier onlyOwner() {

        require(_owner == _msgSender(), "Ownable: caller is not the owner");

        _;

    }



    /**

     * @dev Leaves the contract without owner. It will not be possible to call

     * `onlyOwner` functions anymore. Can only be called by the current owner.

     *

     * NOTE: Renouncing ownership will leave the contract without an owner,

     * thereby removing any functionality that is only available to the owner.

     */

    function renounceOwnership() public  onlyOwner {

        emit OwnershipTransferred(_owner, address(0));

        _owner = address(0);

    }



    /**

     * @dev Transfers ownership of the contract to a new account (`newOwner`).

     * Can only be called by the current owner.

     */

    function transferOwnership(address newOwner) public  onlyOwner {

        require(newOwner != address(0), "Ownable: new owner is the zero address");

        emit OwnershipTransferred(_owner, newOwner);

        _owner = newOwner;

    }

}







contract GraRewardPool is Ownable {

    using SafeMath for uint256;

    using SafeERC20 for IERC20;

    



    struct UserInfo {

        uint256 Gratotalreward;

        uint256 rewarded; 

        uint256 amount;

        uint256 GrarewardDebt;

        uint256 Grapending;

        uint256 BLWrewardDebt;

        uint256 BLWpending;

    }



    struct PoolInfo {

        IERC20 token;

        uint256 startBlock;

        uint256 endBlock;

        uint256 GraPerBlock;

        uint256 BLWPerBlock;

        uint256 lastRewardBlock;

        uint256 accGraPerShare;

        uint256 accBLWPerShare;

        uint256 totalStake;

    }

    uint256 public lockperiod;

    uint256 public startrelease;

    IERC20 public Gratoken;

    IERC20 public BLWtoken;

 

    PoolInfo[] public poolinfo;



    mapping (uint256 => mapping (address => UserInfo)) public users;



    event Deposit(address indexed user,uint256 amount);

    event Withdraw(address indexed user,uint256 amount);

    event ReclaimStakingReward(address user, uint256 amount);

    event Set(uint256 pid, uint256 allocPoint, bool withUpdate);

    constructor(IERC20 _Gratoken, IERC20 _BLWtoken, uint256 _lockperiod, uint256 _startrelease) public { 

        Gratoken = _Gratoken;

        BLWtoken = _BLWtoken;

        lockperiod = _lockperiod;

        startrelease = _startrelease;

    }



    function setparms(uint256 _lockperiod, uint256 _startrelease) public onlyOwner{

        lockperiod = _lockperiod;

        startrelease = _startrelease;

        

    }

    modifier validatePool(uint256 _pid) {

        require(_pid < poolinfo.length, " pool exists?");

        _;

    }





    function getpool() view public returns(PoolInfo[] memory){

        return poolinfo;

    }



    //添加pool池

    function addPool(IERC20 _token, uint256 _startblock, uint256 _endblock, uint256 _GraPerBlock, uint256 _BLWPerBlock, bool _withUpdate) public onlyOwner {

        for (uint i = 0; i < poolinfo.length; ++i) {

            require(address(poolinfo[i].token) != address(_token), "pool already exist");

        }

        if (_withUpdate) {

            massUpdatePools();

        }

        uint256 lastRewardBlock = block.number > _startblock ? block.number : _startblock;

        poolinfo.push(PoolInfo({

            token: _token,

            startBlock: _startblock,

            endBlock: _endblock,

            GraPerBlock: _GraPerBlock,

            BLWPerBlock: _BLWPerBlock,

            lastRewardBlock: lastRewardBlock,

            accGraPerShare: 0,

            accBLWPerShare: 0,

            totalStake: 0

        }));

    }

  

    

    function getMultiplier(PoolInfo storage pool) internal view returns (uint256) {

        if (block.number <= pool.lastRewardBlock) {

            return 0;

        }

        uint256 from = pool.lastRewardBlock;

        uint256 to = block.number < pool.endBlock ? block.number : pool.endBlock;

        if (from >= to) {

            return 0;

        }

        return to.sub(from);

              

    }



    function massUpdatePools() public {

        uint256 length = poolinfo.length;

        for (uint256 pid = 0; pid < length; pid++) {

            updatePool(pid);

        }

    }



    function updatePool(uint256 _pid) public validatePool(_pid) {

        

        PoolInfo storage pool = poolinfo[_pid];

        if (block.number <= pool.lastRewardBlock || pool.lastRewardBlock > pool.endBlock) { 

            return;

        }



        uint256 totalStake = pool.totalStake;

        if (totalStake == 0) {

            pool.lastRewardBlock = block.number <= pool.endBlock ? block.number : pool.endBlock;

            return;

        }



        uint256 multiplier = getMultiplier(pool);

        uint256 GraReward = multiplier.mul(pool.GraPerBlock);

        uint256 BLWReward = multiplier.mul(pool.BLWPerBlock);

        pool.accGraPerShare = pool.accGraPerShare.add(GraReward.mul(1e18).div(totalStake));

        pool.accBLWPerShare = pool.accBLWPerShare.add(BLWReward.mul(1e18).div(totalStake));

        pool.lastRewardBlock = block.number < pool.endBlock ? block.number : pool.endBlock;

    }





    function pendingGra(uint256 _pid, address _user) public view validatePool(_pid) returns (uint256)  {

        PoolInfo storage pool = poolinfo[_pid];

        UserInfo storage user = users[_pid][_user];

        uint256 accGraPerShare = pool.accGraPerShare;



        uint256 totalStake = pool.totalStake;

        if (block.number > pool.lastRewardBlock && totalStake > 0) {

            uint256 multiplier = getMultiplier(pool);

            uint256 GraReward = multiplier.mul(pool.GraPerBlock);

            accGraPerShare = accGraPerShare.add(GraReward.mul(1e18).div(totalStake));

        

        }

        return user.Grapending.add(user.amount.mul(accGraPerShare).div(1e18)).sub(user.GrarewardDebt);

    }

    function pendingBLW(uint256 _pid, address _user) public view validatePool(_pid) returns (uint256)  {

        PoolInfo storage pool = poolinfo[_pid];

        UserInfo storage user = users[_pid][_user];

        uint256 accBLWPerShare = pool.accBLWPerShare;



        uint256 totalStake = pool.totalStake;

        if (block.number > pool.lastRewardBlock && totalStake > 0) {

            uint256 multiplier = getMultiplier(pool);

            uint256 BLWReward = multiplier.mul(pool.BLWPerBlock);

            accBLWPerShare = accBLWPerShare.add(BLWReward.mul(1e18).div(totalStake));

        

        }

        return user.BLWpending.add(user.amount.mul(accBLWPerShare).div(1e18)).sub(user.BLWrewardDebt);

    }

    //抵押

    function deposit(uint256 _pid, uint256 _amount) public validatePool(_pid){

        PoolInfo storage pool = poolinfo[_pid];

        UserInfo storage user = users[_pid][msg.sender];

        updatePool(_pid);

        if (user.amount > 0) { 

            uint256 Grapending = user.amount.mul(pool.accGraPerShare).div(1e18).sub(user.GrarewardDebt);

            uint256 BLWpending = user.amount.mul(pool.accBLWPerShare).div(1e18).sub(user.BLWrewardDebt);

            user.Grapending = user.Grapending.add(Grapending);

            user.Gratotalreward = user.Gratotalreward.add(Grapending);

            user.BLWpending = user.BLWpending.add(BLWpending);

        }

        pool.token.safeTransferFrom(address(msg.sender), address(this), _amount);

        pool.totalStake = pool.totalStake.add(_amount);

        user.amount = user.amount.add(_amount);

        user.GrarewardDebt = user.amount.mul(pool.accGraPerShare).div(1e18);

        user.BLWrewardDebt = user.amount.mul(pool.accBLWPerShare).div(1e18);

        emit Deposit(msg.sender, _amount);

    }





    //提取抵押

    function withdraw(uint256 _pid, uint256 _amount) public validatePool(_pid){

        PoolInfo storage pool = poolinfo[_pid];

        UserInfo storage user = users[_pid][msg.sender];

        require(block.number >= pool.endBlock, "withdraw time not reached");

        require(user.amount >= _amount, "withdraw: insufficient balance");

        updatePool(_pid);

        uint256 Grapending = user.amount.mul(pool.accGraPerShare).div(1e18).sub(user.GrarewardDebt);

        uint256 BLWpending = user.amount.mul(pool.accBLWPerShare).div(1e18).sub(user.BLWrewardDebt);

        if (Grapending > 0 || BLWpending > 0) {

            user.Gratotalreward = user.Gratotalreward.add(Grapending);

            user.Grapending = user.Grapending.add(Grapending);

            user.BLWpending = user.BLWpending.add(BLWpending);

        }

        user.amount = user.amount.sub(_amount);

        user.GrarewardDebt = user.amount.mul(pool.accGraPerShare).div(1e18);

        user.BLWrewardDebt = user.amount.mul(pool.accBLWPerShare).div(1e18);

        pool.token.safeTransfer(msg.sender, _amount);

        pool.totalStake = pool.totalStake.sub(_amount);

        emit Withdraw(msg.sender,_amount);

        }



    function reclaimBLWStakingReward(uint256 _pid) public validatePool(_pid) {

        PoolInfo storage pool = poolinfo[_pid];

        UserInfo storage user = users[_pid][msg.sender];

        updatePool(_pid);

        uint256 BLWpending = user.BLWpending.add(user.amount.mul(pool.accBLWPerShare).div(1e18).sub(user.BLWrewardDebt));

        if (BLWpending > 0) {

            safeBLWTransfer(msg.sender, BLWpending);

        }

        user.BLWpending = 0;

        user.BLWrewardDebt = user.amount.mul(pool.accBLWPerShare).div(1e18);

        emit ReclaimStakingReward(msg.sender, BLWpending);

    }



    function reclaimGraStakingReward(uint256 _pid) public validatePool(_pid){

        PoolInfo storage pool = poolinfo[_pid];

        UserInfo storage user = users[_pid][msg.sender];

        updatePool(_pid);

        uint256 Grapending = user.amount.mul(pool.accGraPerShare).div(1e18).sub(user.GrarewardDebt);

        if (Grapending > 0) {

            user.Grapending = user.Grapending.add(Grapending);

            user.Gratotalreward = user.Gratotalreward.add(Grapending);   

        }

        uint256 time = block.timestamp.sub(startrelease).div(86400);

        if (time < lockperiod) {

            if (user.Gratotalreward.mul(time).div(lockperiod) > user.rewarded){

                uint256 amount = user.Gratotalreward.mul(time).div(lockperiod).sub(user.rewarded);

                safegraTransfer(msg.sender, amount);

                user.rewarded = user.rewarded.add(amount);

                user.Grapending = user.Grapending.sub(amount);

                emit ReclaimStakingReward(msg.sender, amount);

            }

        }else{

            uint256 amount = user.Gratotalreward > user.rewarded ? user.Gratotalreward.sub(user.rewarded) : 0;

            safegraTransfer(msg.sender, amount);

            user.rewarded = user.rewarded.add(amount);

            user.Grapending = user.Grapending.sub(amount);

            emit ReclaimStakingReward(msg.sender, amount);

        }

        

        user.GrarewardDebt = user.amount.mul(pool.accGraPerShare).div(1e18);

        

    }



    function getGraclaimamount(uint256 _pid, address _user) view public returns(uint256){

        PoolInfo storage pool = poolinfo[_pid];

        UserInfo storage user = users[_pid][_user];

        uint256 accGraPerShare = pool.accGraPerShare;



        uint256 totalStake = pool.totalStake;

        if (block.number > pool.lastRewardBlock && totalStake > 0) {

            uint256 multiplier = getMultiplier(pool);

            uint256 GraReward = multiplier.mul(pool.GraPerBlock);

            accGraPerShare = accGraPerShare.add(GraReward.mul(1e18).div(totalStake));

        }

        if (block.timestamp <= startrelease){

            return 0;

        }



        uint256 Gratotalreward = user.Gratotalreward.add(user.amount.mul(accGraPerShare).div(1e18).sub(user.GrarewardDebt));



        uint256 time = block.timestamp.sub(startrelease).div(86400);



        uint256 amount = Gratotalreward.mul(time).div(lockperiod);



        if (user.rewarded ==  Gratotalreward || Gratotalreward == 0 || amount <= user.rewarded) {

            return 0;

        }

        

        if (time < lockperiod) {

            return amount.sub(user.rewarded);

        }else{

            return Gratotalreward > user.rewarded ? Gratotalreward.sub(user.rewarded) : 0;

        }

    }



    function safegraTransfer(address _to, uint256 _amount) internal {

        uint256 GraBalance = Gratoken.balanceOf(address(this));

        if (_amount > GraBalance) {

            Gratoken.transfer(_to, GraBalance);

        } else {

            Gratoken.transfer(_to, _amount);

        }

    }

    function safeBLWTransfer(address _to, uint256 _amount) internal {

        uint256 BLWBalance = BLWtoken.balanceOf(address(this));

        if (_amount > BLWBalance) {

            BLWtoken.transfer(_to, BLWBalance);

        } else {

            BLWtoken.transfer(_to, _amount);

        }

    }

}