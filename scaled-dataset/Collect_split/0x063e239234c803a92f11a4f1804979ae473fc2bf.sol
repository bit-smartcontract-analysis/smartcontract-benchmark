// SPDX-License-Identifier: MIT



pragma solidity ^0.5.17;



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

        // Solidity only automatically asserts when dividing by 0

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



library Address {

    function isContract(address account) internal view returns (bool) {

        bytes32 codehash;

        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;

        // solhint-disable-next-line no-inline-assembly

        assembly { codehash := extcodehash(account) }

        return (codehash != 0x0 && codehash != accountHash);

    }

    function toPayable(address account) internal pure returns (address payable) {

        return address(uint160(account));

    }

    function sendValue(address payable recipient, uint256 amount) internal {

        require(address(this).balance >= amount, "Address: insufficient balance");



        // solhint-disable-next-line avoid-call-value

        (bool success, ) = recipient.call.value(amount)("");

        require(success, "Address: unable to send value, recipient may have reverted");

    }

}



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

        require((value == 0) || (token.allowance(address(this), spender) == 0),

            "SafeERC20: approve from non-zero to non-zero allowance"

        );

        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));

    }

    function callOptionalReturn(IERC20 token, bytes memory data) private {

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





interface cToken {

    function mint(uint mintAmount) external returns (uint);

    function redeem(uint redeemTokens) external returns (uint);

    function redeemUnderlying(uint redeemAmount) external returns (uint);

    function borrow(uint borrowAmount) external returns (uint);

    function repayBorrow(uint repayAmount) external returns (uint);

    function exchangeRateStored() external view returns (uint);

    function balanceOf(address _owner) external view returns (uint);

    function underlying() external view returns (address);

}



interface Controller {

    function vaults(address) external view returns (address);

}



interface Comptroller {

    function claimComp(address holder) external;

}



/*



 A strategy must implement the following calls;

 

 - deposit()

 - withdraw(address) must exclude any tokens used in the yield - Controller role - withdraw should return to Controller

 - withdraw(uint) - Controller | Vault role - withdraw should always return to vault

 - withdrawAll() - Controller | Vault role - withdraw should always return to vault

 - balanceOf()

 

 Where possible, strategies must remain as immutable as possible, instead of updating variables, we update the contract by linking it in the controller

 

*/



contract StrategyCompoundBasic {

    using SafeERC20 for IERC20;

    using Address for address;

    using SafeMath for uint256;

    

    address public want;

    

    Comptroller public constant compound = Comptroller(0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B); // Comptroller address for compound.finance

    

    cToken public c;

    IERC20 public underlying;



    address public governance;

    address public controller;

    

    // Claim function is not part of the template, this is additional logic to faster farm COMP instead of needing to withdraw/deposit

    function claim() public {

        compound.claimComp(address(this));

    }

    

    constructor(cToken _cToken, address _controller) public {

        governance = msg.sender;

        controller = _controller;

        c = _cToken;

        

        underlying = IERC20(_cToken.underlying());

        want = address(underlying);

    }

    

    function deposit() external {

        underlying.safeApprove(address(c), 0);

        underlying.safeApprove(address(c), underlying.balanceOf(address(this)));

        require(c.mint(underlying.balanceOf(address(this))) == 0, "COMPOUND: supply failed");

    }

    

    // Controller only function for creating additional rewards from dust

    function withdraw(IERC20 _asset) external returns (uint balance) {

        require(msg.sender == controller, "!controller");

        require(address(_asset) != address(c), "!c");

        require(address(_asset) != address(underlying), "!underlying");

        balance = _asset.balanceOf(address(this));

        _asset.safeTransfer(controller, balance);

    }

    

    // Withdraw partial funds, normally used with a vault withdrawal

    function withdraw(uint _amount) external {

        require(msg.sender == controller, "!controller");

        uint _balance = underlying.balanceOf(address(this));

        if (_balance < _amount) {

            _withdrawSome(_amount.sub(_balance));

        }

        address _vault = Controller(controller).vaults(address(underlying));

        require(_vault != address(0), "!vault"); // additional protection so we don't burn the funds

        underlying.safeTransfer(_vault, _amount);

    }

    

    // Withdraw all funds, normally used when migrating strategies

    function withdrawAll() external returns (uint balance) {

        require(msg.sender == controller, "!controller");

        _withdrawAll();

        balance = underlying.balanceOf(address(this));

        address _vault = Controller(controller).vaults(address(underlying));

        require(_vault != address(0), "!vault"); // additional protection so we don't burn the funds

        underlying.safeTransfer(_vault, balance);

    }

    

    function _withdrawAll() internal {

        uint256 amount = balanceCompound();

        if (amount > 0) {

            _withdrawSome(balanceCompoundInToken().sub(1));

        }

    }

    

    function _withdrawSome(uint256 _amount) internal {

        uint256 b = balanceCompound();

        uint256 bT = balanceCompoundInToken();

        require(bT >= _amount, "insufficient funds");

        // can have unintentional rounding errors

        uint256 amount = (b.mul(_amount)).div(bT).add(1);

        _withdrawCompound(amount);

    }

    

    function balanceOf() public view returns (uint) {

        return balanceCompoundInToken();

    }

    

    function _withdrawCompound(uint amount) internal {

        require(c.redeem(amount) == 0, "COMPOUND: withdraw failed");

    }

    

    function balanceCompoundInToken() public view returns (uint256) {

        // Mantisa 1e18 to decimals

        uint256 b = balanceCompound();

        if (b > 0) {

            b = b.mul(c.exchangeRateStored()).div(1e18);

        }

        return b;

    }

    

    function balanceCompound() public view returns (uint256) {

        return c.balanceOf(address(this));

    }

    

    function setGovernance(address _governance) external {

        require(msg.sender == governance, "!governance");

        governance = _governance;

    }

    

    function setController(address _controller) external {

        require(msg.sender == governance, "!governance");

        controller = _controller;

    }

}