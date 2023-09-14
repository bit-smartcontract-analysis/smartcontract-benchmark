// SPDX-License-Identifier: MIT



pragma solidity ^0.6.12;



    abstract contract Context {

        function _msgSender() internal view virtual returns (address payable) {

            return msg.sender;

        }

        function _msgData() internal view virtual returns (bytes memory) {

            this;

            return msg.data;

        }

    }



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

            assembly { codehash := extcodehash(account) }

            return (codehash != accountHash && codehash != 0x0);

        }

        function sendValue(address payable recipient, uint256 amount) internal {

            require(address(this).balance >= amount, "Address: insufficient balance");

            (bool success, ) = recipient.call{ value: amount }("");

            require(success, "Address: unable to send value, recipient may have reverted");

        }

        function functionCall(address target, bytes memory data) internal returns (bytes memory) {

        return functionCall(target, data, "Address: low-level call failed");

        }

        function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {

            return _functionCallWithValue(target, data, 0, errorMessage);

        }

        function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {

            return functionCallWithValue(target, data, value, "Address: low-level call with value failed");

        }

        function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {

            require(address(this).balance >= value, "Address: insufficient balance for call");

            return _functionCallWithValue(target, data, value, errorMessage);

        }

        function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {

            require(isContract(target), "Address: call to non-contract");

            (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);

            if (success) {

                return returndata;

            } else {

                if (returndata.length > 0) {

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



    contract Ownable is Context {

        address private _owner;

        address private _previousOwner;

        uint256 private _lockTime;

        event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

        constructor () internal {

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

        function geUnlockTime() public view returns (uint256) {

            return _lockTime;

        }

        function lock(uint256 time) public virtual onlyOwner {

            _previousOwner = _owner;

            _owner = address(0);

            _lockTime = now + time;

            emit OwnershipTransferred(_owner, address(0));

        }

        function unlock() public virtual {

            require(_previousOwner == msg.sender, "You don't have permission to unlock");

            require(now > _lockTime , "Contract is locked until 7 days");

            emit OwnershipTransferred(_owner, _previousOwner);

            _owner = _previousOwner;

        }

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



    contract DOKK is Context, IERC20, Ownable {

        using SafeMath for uint256;

        using Address for address;

        mapping (address => uint256) private _rOwned;

        mapping (address => uint256) private _tOwned;

        mapping (address => mapping (address => uint256)) private _allowances;

        mapping (address => bool) private _isExcludedFromFee;

        mapping (address => bool) private _isExcluded;

        address[] private _excluded;

        mapping (address => bool) private _isBlackListedBot;

        address[] private _blackListedBots;

        uint256 private constant MAX = ~uint256(0);

        uint256 private _tTotal = 1000000000000000000000;

        uint256 private _rTotal = (MAX - (MAX % _tTotal));

        uint256 private _tFeeTotal;

        string private _name = 'Dokkaebi Inu';

        string private _symbol = 'DOKK';

        uint8 private _decimals = 9;

        uint256 private _taxFee = 10; 

        uint256 private _charityFee = 10;

        uint256 private _previousTaxFee = _taxFee;

        uint256 private _previousCharityFee = _charityFee;

        address payable public _charityWalletAddress;

        address payable public _marketingWalletAddress;

        

        IUniswapV2Router02 public immutable uniswapV2Router;

        address public immutable uniswapV2Pair;

        bool inSwap = false;

        bool public swapEnabled = true;

        uint256 public _maxTxAmount = _tTotal;

        uint256 private _numOfTokensToExchangeForCharity = 1000000000000000000;

        event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);

        event SwapEnabledUpdated(bool enabled);



        modifier lockTheSwap {

            inSwap = true;

            _;

            inSwap = false;

        }

        constructor (address payable charityWalletAddress, address payable marketingWalletAddress) public {

            _charityWalletAddress = charityWalletAddress;

            _marketingWalletAddress = marketingWalletAddress;

            _rOwned[_msgSender()] = _rTotal;

            IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

            uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())

                .createPair(address(this), _uniswapV2Router.WETH());

            uniswapV2Router = _uniswapV2Router;

            _isExcludedFromFee[owner()] = true;

            _isExcludedFromFee[address(this)] = true;

            _isBlackListedBot[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;

            _blackListedBots.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));

            _isBlackListedBot[address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345)] = true;

            _blackListedBots.push(address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345));

            _isBlackListedBot[address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b)] = true;

            _blackListedBots.push(address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b));

            _isBlackListedBot[address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95)] = true;

            _blackListedBots.push(address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95));

            _isBlackListedBot[address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964)] = true;

            _blackListedBots.push(address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964));

            _isBlackListedBot[address(0xDC81a3450817A58D00f45C86d0368290088db848)] = true;

            _blackListedBots.push(address(0xDC81a3450817A58D00f45C86d0368290088db848));

            _isBlackListedBot[address(0x45fD07C63e5c316540F14b2002B085aEE78E3881)] = true;

            _blackListedBots.push(address(0x45fD07C63e5c316540F14b2002B085aEE78E3881));

            _isBlackListedBot[address(0x27F9Adb26D532a41D97e00206114e429ad58c679)] = true;

            _blackListedBots.push(address(0x27F9Adb26D532a41D97e00206114e429ad58c679));

            _isBlackListedBot[address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7)] = true;

            _blackListedBots.push(address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7));

            _isBlackListedBot[address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533)] = true;

            _blackListedBots.push(address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533));

            _isBlackListedBot[address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d)] = true;

            _blackListedBots.push(address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d));

            _isBlackListedBot[address(0x000000000000084e91743124a982076C59f10084)] = true;

            _blackListedBots.push(address(0x000000000000084e91743124a982076C59f10084));

            _isBlackListedBot[address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303)] = true;

            _blackListedBots.push(address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303));

            _isBlackListedBot[address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595)] = true;

            _blackListedBots.push(address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595));

            _isBlackListedBot[address(0x000000005804B22091aa9830E50459A15E7C9241)] = true;

            _blackListedBots.push(address(0x000000005804B22091aa9830E50459A15E7C9241));

            _isBlackListedBot[address(0xA3b0e79935815730d942A444A84d4Bd14A339553)] = true;

            _blackListedBots.push(address(0xA3b0e79935815730d942A444A84d4Bd14A339553));

            _isBlackListedBot[address(0xf6da21E95D74767009acCB145b96897aC3630BaD)] = true;

            _blackListedBots.push(address(0xf6da21E95D74767009acCB145b96897aC3630BaD));

            _isBlackListedBot[address(0x0000000000007673393729D5618DC555FD13f9aA)] = true;

            _blackListedBots.push(address(0x0000000000007673393729D5618DC555FD13f9aA));

            _isBlackListedBot[address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1)] = true;

            _blackListedBots.push(address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1));

            _isBlackListedBot[address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6)] = true;

            _blackListedBots.push(address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6));

            _isBlackListedBot[address(0x000000917de6037d52b1F0a306eeCD208405f7cd)] = true;

            _blackListedBots.push(address(0x000000917de6037d52b1F0a306eeCD208405f7cd));

            _isBlackListedBot[address(0x7100e690554B1c2FD01E8648db88bE235C1E6514)] = true;

            _blackListedBots.push(address(0x7100e690554B1c2FD01E8648db88bE235C1E6514));

            _isBlackListedBot[address(0x72b30cDc1583224381132D379A052A6B10725415)] = true;

            _blackListedBots.push(address(0x72b30cDc1583224381132D379A052A6B10725415));

            _isBlackListedBot[address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE)] = true;

            _blackListedBots.push(address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE));

            _isBlackListedBot[address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F)] = true;

            _blackListedBots.push(address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F));

            _isBlackListedBot[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;

            _blackListedBots.push(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));

            _isBlackListedBot[address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9)] = true;

            _blackListedBots.push(address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9));

            _isBlackListedBot[address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7)] = true;

            _blackListedBots.push(address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7));

            _isBlackListedBot[address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF)] = true;

            _blackListedBots.push(address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF));

            _isBlackListedBot[address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290)] = true;

            _blackListedBots.push(address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290));

            _isBlackListedBot[address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5)] = true;

            _blackListedBots.push(address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5));

            _isBlackListedBot[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;

            _blackListedBots.push(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));

            _isBlackListedBot[address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7)] = true;

            _blackListedBots.push(address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7));

            emit Transfer(address(0), _msgSender(), _tTotal);

        }

        function name() public view returns (string memory) {

            return _name;

        }

        function symbol() public view returns (string memory) {

            return _symbol;

        }

        function decimals() public view returns (uint8) {

            return _decimals;

        }

        function totalSupply() public view override returns (uint256) {

            return _tTotal;

        }

        function balanceOf(address account) public view override returns (uint256) {

            if (_isExcluded[account]) return _tOwned[account];

            return tokenFromReflection(_rOwned[account]);

        }

        function transfer(address recipient, uint256 amount) public override returns (bool) {

            _transfer(_msgSender(), recipient, amount);

            return true;

        }

        function allowance(address owner, address spender) public view override returns (uint256) {

            return _allowances[owner][spender];

        }

        function approve(address spender, uint256 amount) public override returns (bool) {

            _approve(_msgSender(), spender, amount);

            return true;

        }

        function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {

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

        function isExcluded(address account) public view returns (bool) {

            return _isExcluded[account];

        }

        function isBlackListed(address account) public view returns (bool) {

            return _isBlackListedBot[account];

        }

        function setExcludeFromFee(address account, bool excluded) external onlyOwner() {

            _isExcludedFromFee[account] = excluded;

        }

        function totalFees() public view returns (uint256) {

            return _tFeeTotal;

        }

        function deliver(uint256 tAmount) public {

            address sender = _msgSender();

            require(!_isExcluded[sender], "Excluded addresses cannot call this function");

            (uint256 rAmount,,,,,) = _getValues(tAmount);

            _rOwned[sender] = _rOwned[sender].sub(rAmount);

            _rTotal = _rTotal.sub(rAmount);

            _tFeeTotal = _tFeeTotal.add(tAmount);

        }

        function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {

            require(tAmount <= _tTotal, "Amount must be less than supply");

            if (!deductTransferFee) {

                (uint256 rAmount,,,,,) = _getValues(tAmount);

                return rAmount;

            } else {

                (,uint256 rTransferAmount,,,,) = _getValues(tAmount);

                return rTransferAmount;

            }

        }

        function tokenFromReflection(uint256 rAmount) public view returns(uint256) {

            require(rAmount <= _rTotal, "Amount must be less than total reflections");

            uint256 currentRate =  _getRate();

            return rAmount.div(currentRate);

        }

        function excludeAccount(address account) external onlyOwner() {

            require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude DEX router.');

            require(!_isExcluded[account], "Account is already excluded");

            if(_rOwned[account] > 0) {

                _tOwned[account] = tokenFromReflection(_rOwned[account]);

            }

            _isExcluded[account] = true;

            _excluded.push(account);

        }

        function includeAccount(address account) external onlyOwner() {

            require(_isExcluded[account], "Account is already excluded");

            for (uint256 i = 0; i < _excluded.length; i++) {

                if (_excluded[i] == account) {

                    _excluded[i] = _excluded[_excluded.length - 1];

                    _tOwned[account] = 0;

                    _isExcluded[account] = false;

                    _excluded.pop();

                    break;

                }

            }

        }

        function addBotToBlackList(address account) external onlyOwner() {

            require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist DEX router.');

            require(!_isBlackListedBot[account], "Account is already blacklisted");

            _isBlackListedBot[account] = true;

            _blackListedBots.push(account);

        }

        function removeBotFromBlackList(address account) external onlyOwner() {

            require(_isBlackListedBot[account], "Account is not blacklisted");

            for (uint256 i = 0; i < _blackListedBots.length; i++) {

                if (_blackListedBots[i] == account) {

                    _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];

                    _isBlackListedBot[account] = false;

                    _blackListedBots.pop();

                    break;

                }

            }

        }

        function removeAllFee() private {

            if(_taxFee == 0 && _charityFee == 0) return;

            _previousTaxFee = _taxFee;

            _previousCharityFee = _charityFee;

            _taxFee = 0;

            _charityFee = 0;

        }

        function restoreAllFee() private {

            _taxFee = _previousTaxFee;

            _charityFee = _previousCharityFee;

        }

        function isExcludedFromFee(address account) public view returns(bool) {

            return _isExcludedFromFee[account];

        }

        function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {

        _maxTxAmount = _tTotal.mul(maxTxPercent).div(

            10**2

        );

        }

        function _approve(address owner, address spender, uint256 amount) private {

            require(owner != address(0), "ERC20: approve from the zero address");

            require(spender != address(0), "ERC20: approve to the zero address");

            _allowances[owner][spender] = amount;

            emit Approval(owner, spender, amount);

        }

        function _transfer(address sender, address recipient, uint256 amount) private {

            require(sender != address(0), "ERC20: transfer from the zero address");

            require(recipient != address(0), "ERC20: transfer to the zero address");

            require(amount > 0, "Transfer amount must be greater than zero");

            require(!_isBlackListedBot[recipient], "You have no power here!");

            require(!_isBlackListedBot[msg.sender], "You have no power here!");

            if(sender != owner() && recipient != owner())

                require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");

            uint256 contractTokenBalance = balanceOf(address(this));

            if(contractTokenBalance >= _maxTxAmount)

            {

                contractTokenBalance = _maxTxAmount;

            }

            bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForCharity;

            if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {

                swapTokensForEth(contractTokenBalance);

                uint256 contractETHBalance = address(this).balance;

                if(contractETHBalance > 0) {

                    sendETHToCharity(address(this).balance);

                }

            }

            bool takeFee = true;

            if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){

                takeFee = false;

            }

            _tokenTransfer(sender,recipient,amount,takeFee);

        }

        function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{

            address[] memory path = new address[](2);

            path[0] = address(this);

            path[1] = uniswapV2Router.WETH();

            _approve(address(this), address(uniswapV2Router), tokenAmount);

            uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(

                tokenAmount,

                0,

                path,

                address(this),

                block.timestamp

            );

        }

        function sendETHToCharity(uint256 amount) private {

            _charityWalletAddress.transfer(amount.div(2));

            _marketingWalletAddress.transfer(amount.div(2));

        }

        function manualSwap() external onlyOwner() {

            uint256 contractBalance = balanceOf(address(this));

            swapTokensForEth(contractBalance);

        }

        function manualSend() external onlyOwner() {

            uint256 contractETHBalance = address(this).balance;

            sendETHToCharity(contractETHBalance);

        }

        function setSwapEnabled(bool enabled) external onlyOwner(){

            swapEnabled = enabled;

        }

        function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {

            if(!takeFee)

                removeAllFee();

            if (_isExcluded[sender] && !_isExcluded[recipient]) {

                _transferFromExcluded(sender, recipient, amount);

            } else if (!_isExcluded[sender] && _isExcluded[recipient]) {

                _transferToExcluded(sender, recipient, amount);

            } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {

                _transferStandard(sender, recipient, amount);

            } else if (_isExcluded[sender] && _isExcluded[recipient]) {

                _transferBothExcluded(sender, recipient, amount);

            } else {

                _transferStandard(sender, recipient, amount);

            }

            if(!takeFee)

                restoreAllFee();

        }

        function _transferStandard(address sender, address recipient, uint256 tAmount) private {

            (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);

            _rOwned[sender] = _rOwned[sender].sub(rAmount);

            _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 

            _takeCharity(tCharity); 

            _reflectFee(rFee, tFee);

            emit Transfer(sender, recipient, tTransferAmount);

        }

        function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {

            (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);

            _rOwned[sender] = _rOwned[sender].sub(rAmount);

            _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);

            _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);    

            _takeCharity(tCharity);           

            _reflectFee(rFee, tFee);

            emit Transfer(sender, recipient, tTransferAmount);

        }

        function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {

            (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);

            _tOwned[sender] = _tOwned[sender].sub(tAmount);

            _rOwned[sender] = _rOwned[sender].sub(rAmount);

            _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 

            _takeCharity(tCharity);   

            _reflectFee(rFee, tFee);

            emit Transfer(sender, recipient, tTransferAmount);

        }

        function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {

            (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);

            _tOwned[sender] = _tOwned[sender].sub(tAmount);

            _rOwned[sender] = _rOwned[sender].sub(rAmount);

            _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);

            _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   

            _takeCharity(tCharity);         

            _reflectFee(rFee, tFee);

            emit Transfer(sender, recipient, tTransferAmount);

        }

        function _takeCharity(uint256 tCharity) private {

            uint256 currentRate =  _getRate();

            uint256 rCharity = tCharity.mul(currentRate);

            _rOwned[address(this)] = _rOwned[address(this)].add(rCharity);

            if(_isExcluded[address(this)])

                _tOwned[address(this)] = _tOwned[address(this)].add(tCharity);

        }

        function _reflectFee(uint256 rFee, uint256 tFee) private {

            _rTotal = _rTotal.sub(rFee);

            _tFeeTotal = _tFeeTotal.add(tFee);

        }

        receive() external payable {}

        function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {

            (uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getTValues(tAmount, _taxFee, _charityFee);

            uint256 currentRate =  _getRate();

            (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);

            return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tCharity);

        }

        function _getTValues(uint256 tAmount, uint256 taxFee, uint256 charityFee) private pure returns (uint256, uint256, uint256) {

            uint256 tFee = tAmount.mul(taxFee).div(100);

            uint256 tCharity = tAmount.mul(charityFee).div(100);

            uint256 tTransferAmount = tAmount.sub(tFee).sub(tCharity);

            return (tTransferAmount, tFee, tCharity);

        }

        function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {

            uint256 rAmount = tAmount.mul(currentRate);

            uint256 rFee = tFee.mul(currentRate);

            uint256 rTransferAmount = rAmount.sub(rFee);

            return (rAmount, rTransferAmount, rFee);

        }

        function _getRate() private view returns(uint256) {

            (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();

            return rSupply.div(tSupply);

        }

        function _getCurrentSupply() private view returns(uint256, uint256) {

            uint256 rSupply = _rTotal;

            uint256 tSupply = _tTotal;      

            for (uint256 i = 0; i < _excluded.length; i++) {

                if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);

                rSupply = rSupply.sub(_rOwned[_excluded[i]]);

                tSupply = tSupply.sub(_tOwned[_excluded[i]]);

            }

            if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);

            return (rSupply, tSupply);

        }

        function _getTaxFee() private view returns(uint256) {

            return _taxFee;

        }

        function _getMaxTxAmount() private view returns(uint256) {

            return _maxTxAmount;

        }

        function _getETHBalance() public view returns(uint256 balance) {

            return address(this).balance;

        }

        function _setTaxFee(uint256 taxFee) external onlyOwner() {

            _taxFee = taxFee;

        }

        function _setCharityFee(uint256 charityFee) external onlyOwner() {

            _charityFee = charityFee;

        }

        function _setCharityWallet(address payable charityWalletAddress) external onlyOwner() {

            _charityWalletAddress = charityWalletAddress;

        }

    }