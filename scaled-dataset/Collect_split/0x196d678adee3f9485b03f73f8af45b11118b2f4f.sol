// Blowfish

// https://blowfish.xyz/

// TG https://t.me/BlowfishETH

// Total supply: 1 000 000 000

// Buy tax  : 5%

// Sell tax : 5%



//SPDX-License-Identifier: UNLICENSED

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

 

    function transferFrom(

        address sender,

        address recipient,

        uint256 amount

    ) external returns (bool);

 

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(

        address indexed owner,

        address indexed spender,

        uint256 value

    );

}

 

contract Ownable is Context {

    address private _owner;

    address private _previousOwner;

    event OwnershipTransferred(

        address indexed previousOwner,

        address indexed newOwner

    );

 

    constructor() {

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

 

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {

        uint256 c = a + b;

        require(c >= a, "SafeMath: addition overflow");

        return c;

    }

 

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {

        return sub(a, b, "SafeMath: subtraction overflow");

    }

 

    function sub(

        uint256 a,

        uint256 b,

        string memory errorMessage

    ) internal pure returns (uint256) {

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

 

    function div(

        uint256 a,

        uint256 b,

        string memory errorMessage

    ) internal pure returns (uint256) {

        require(b > 0, errorMessage);

        uint256 c = a / b;

        return c;

    }

}

 

interface IUniswapV2Factory {

    function createPair(address tokenA, address tokenB)

        external

        returns (address pair);

}

 

interface IUniswapV2Router02 {

    function swapExactTokensForETHSupportingFeeOnTransferTokens(

        uint256 amountIn,

        uint256 amountOutMin,

        address[] calldata path,

        address to,

        uint256 deadline

    ) external;

 

    function factory() external pure returns (address);

 

    function WETH() external pure returns (address);

 

    function addLiquidityETH(

        address token,

        uint256 amountTokenDesired,

        uint256 amountTokenMin,

        uint256 amountETHMin,

        address to,

        uint256 deadline

    )

        external

        payable

        returns (

            uint256 amountToken,

            uint256 amountETH,

            uint256 liquidity

        );

}

 

contract Blowfish is Context, IERC20, Ownable {

 

    using SafeMath for uint256;

 

    string private constant _name = "Blowfish";

    string private constant _symbol = "Blowfish";

    uint8 private constant _decimals = 9;

 

    mapping(address => uint256) private _rOwned;

    mapping(address => uint256) private _tOwned;

    mapping(address => mapping(address => uint256)) private _allowances;

    mapping(address => bool) private _isExcludedFromFee;

    uint256 private constant MAX = ~uint256(0);



    uint256 private constant _tTotal = 1000000000 * 10**9;

    uint256 private _rTotal = (MAX - (MAX % _tTotal));

    uint256 private _tFeeTotal;

 

    uint256 private _liquidityFeeOnBuy = 0;  

    uint256 private _taxFeeOnBuy = 5;   

 

    uint256 private _liquidityFeeOnSell = 0; 

    uint256 private _taxFeeOnSell = 5;  



    uint256 private _liquidityFee = _liquidityFeeOnSell;

    uint256 private _taxFee = _taxFeeOnSell;

 

    uint256 private _previousliquidityFee = _liquidityFee;

    uint256 private _previoustaxFee = _taxFee;

 

    uint256 public totalFees;



    address payable private _marketingAddress = payable(0xdA52bc7aAD8117A6Dd94bf503d5a4Efef010F8eE);

 

    IUniswapV2Router02 public uniswapV2Router;

    address public uniswapV2Pair;

 

    bool private inSwap = false;





    uint256 public _maxTxAmount = 1000000000 * 10**9; 

    uint256 public _maxWalletSize = 1000000000 * 10**9; 

    uint256 public _swapTokensAtAmount = 8000000 * 10**9; 

 

    event MaxTxAmountUpdated(uint256 _maxTxAmount);

    modifier lockTheSwap {

        inSwap = true;

        _;

        inSwap = false;

    }

 

    constructor() {

        _rOwned[_msgSender()] = _rTotal;

 

        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//

        uniswapV2Router = _uniswapV2Router;

        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())

            .createPair(address(this), _uniswapV2Router.WETH());

 

        _isExcludedFromFee[owner()] = true;

        _isExcludedFromFee[address(this)] = true;

        _isExcludedFromFee[_marketingAddress] = true;

 

         emit Transfer(address(0), _msgSender(), _tTotal);

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

 

    function transfer(address recipient, uint256 amount)

        public

        override

        returns (bool)

    {

        _transfer(_msgSender(), recipient, amount);

        return true;

    }

 

    function allowance(address owner, address spender)

        public

        view

        override

        returns (uint256)

    {

        return _allowances[owner][spender];

    }

 

    function approve(address spender, uint256 amount)

        public

        override

        returns (bool)

    {

        _approve(_msgSender(), spender, amount);

        return true;

    }

 

    function transferFrom(

        address sender,

        address recipient,

        uint256 amount

    ) public override returns (bool) {

        _transfer(sender, recipient, amount);

        _approve(

            sender,

            _msgSender(),

            _allowances[sender][_msgSender()].sub(

                amount,

                "ERC20: transfer amount exceeds allowance"

            )

        );

        return true;

    }

 

    function tokenFromReflection(uint256 rAmount)

        private

        view

        returns (uint256)

    {

        require(

            rAmount <= _rTotal,

            "Amount must be less than total reflections"

        );

        uint256 currentRate = _getRate();

        return rAmount.div(currentRate);

    }

 

    function removeAllFee() private {

        if (_liquidityFee == 0 && _taxFee == 0) return;

 

        _previousliquidityFee = _liquidityFee;

        _previoustaxFee = _taxFee;

 

        _liquidityFee = 0;

        _taxFee = 0;

    }

 

    function restoreAllFee() private {

        _liquidityFee = _previousliquidityFee;

        _taxFee = _previoustaxFee;

    }

 

    function _approve(

        address owner,

        address spender,

        uint256 amount

    ) private {

        require(owner != address(0), "ERC20: approve from the zero address");

        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;

        emit Approval(owner, spender, amount);

    }

 

    function _transfer(

        address from,

        address to,

        uint256 amount

    ) private {

        require(from != address(0), "ERC20: transfer from the zero address");

        require(to != address(0), "ERC20: transfer to the zero address");

        require(amount > 0, "Transfer amount must be greater than zero");



        if (from != owner() && to != owner()) {

 

            require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");

 

            if(to != uniswapV2Pair) {

                require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");

            }





            uint256 contractTokenBalance = balanceOf(address(this));

            bool canSwap = contractTokenBalance >= _swapTokensAtAmount;

 

            if(contractTokenBalance >= _maxTxAmount)

            {

                contractTokenBalance = _maxTxAmount;

            }

 

            if (canSwap && !inSwap && from != uniswapV2Pair && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {

                swapTokensForEth(contractTokenBalance);

                uint256 contractETHBalance = address(this).balance;

                if (contractETHBalance > 0) {

                    sendETHToFee(address(this).balance);

                }

            }

        }

 

        bool takeFee = true;

 

        //Transfer Tokens

        if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {

            takeFee = false;

        } else {

 

            //Set Fee for Buys

            if(from == uniswapV2Pair && to != address(uniswapV2Router)) {

                _liquidityFee = _liquidityFeeOnBuy;

                _taxFee = _taxFeeOnBuy;

            }

 

            //Set Fee for Sells

            if (to == uniswapV2Pair && from != address(uniswapV2Router)) {

                _liquidityFee = _liquidityFeeOnSell;

                _taxFee = _taxFeeOnSell;

            }

 

        }

 

        _tokenTransfer(from, to, amount, takeFee);

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

        _marketingAddress.transfer(amount);

    }

 

 

    function manualswap() external {

        require( _msgSender() == _marketingAddress);

        uint256 contractBalance = balanceOf(address(this));

        swapTokensForEth(contractBalance);

    }

 

    function Sweep() external {

        require( _msgSender() == _marketingAddress);

        uint256 contractETHBalance = address(this).balance;

        sendETHToFee(contractETHBalance);

    }

 

    function _tokenTransfer(

        address sender,

        address recipient,

        uint256 amount,

        bool takeFee

    ) private {

        if (!takeFee) removeAllFee();

        _transferStandard(sender, recipient, amount);

        if (!takeFee) restoreAllFee();

    }

 

    function _transferStandard(

        address sender,

        address recipient,

        uint256 tAmount

    ) private {

        (

            uint256 rAmount,

            uint256 rTransferAmount,

            uint256 rFee,

            uint256 tTransferAmount,

            uint256 tFee,

            uint256 tMarket

        ) = _getValues(tAmount);

        _rOwned[sender] = _rOwned[sender].sub(rAmount);

        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);

        _takeMarket(tMarket);

        _reflectFee(rFee, tFee);

        emit Transfer(sender, recipient, tTransferAmount);

    }

 

    function _takeMarket(uint256 tMarket) private {

        uint256 currentRate = _getRate();

        uint256 rMarket = tMarket.mul(currentRate);

        _rOwned[address(this)] = _rOwned[address(this)].add(rMarket);

    }

 

    function _reflectFee(uint256 rFee, uint256 tFee) private {

        _rTotal = _rTotal.sub(rFee);

        _tFeeTotal = _tFeeTotal.add(tFee);

    }

 

    receive() external payable {}

 

    function _getValues(uint256 tAmount)

        private

        view

        returns (

            uint256,

            uint256,

            uint256,

            uint256,

            uint256,

            uint256

        )

    {

        (uint256 tTransferAmount, uint256 tFee, uint256 tMarket) =

            _getTValues(tAmount, _liquidityFee, _taxFee);

        uint256 currentRate = _getRate();

        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =

            _getRValues(tAmount, tFee, tMarket, currentRate);

 

        return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tMarket);

    }

 

    function _getTValues(

        uint256 tAmount,

        uint256 liquidityFee,

        uint256 taxFee

    )

        private

        pure

        returns (

            uint256,

            uint256,

            uint256

        )

    {

        uint256 tFee = tAmount.mul(liquidityFee).div(100);

        uint256 tMarket = tAmount.mul(taxFee).div(100);

        uint256 tTransferAmount = tAmount.sub(tFee).sub(tMarket);

 

        return (tTransferAmount, tFee, tMarket);

    }

 

    function _getRValues(

        uint256 tAmount,

        uint256 tFee,

        uint256 tMarket,

        uint256 currentRate

    )

        private

        pure

        returns (

            uint256,

            uint256,

            uint256

        )

    {

        uint256 rAmount = tAmount.mul(currentRate);

        uint256 rFee = tFee.mul(currentRate);

        uint256 rMarket = tMarket.mul(currentRate);

        uint256 rTransferAmount = rAmount.sub(rFee).sub(rMarket);

 

        return (rAmount, rTransferAmount, rFee);

    }

 

    function _getRate() private view returns (uint256) {

        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();

 

        return rSupply.div(tSupply);

    }

 

    function _getCurrentSupply() private view returns (uint256, uint256) {

        uint256 rSupply = _rTotal;

        uint256 tSupply = _tTotal;

        if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);

 

        return (rSupply, tSupply);

    }





    function setFees(uint256 liquidityFeeOnBuy, uint256 liquidityFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {

        _liquidityFeeOnBuy = liquidityFeeOnBuy;

        _liquidityFeeOnSell = liquidityFeeOnSell;

        _taxFeeOnBuy = taxFeeOnBuy;

        _taxFeeOnSell = taxFeeOnSell;



        totalFees = liquidityFeeOnBuy + liquidityFeeOnSell + taxFeeOnBuy + taxFeeOnSell;

        require(totalFees <= 10, "Must keep fees at 10% or less");



    }

 

    //Set minimum tokens required to swap.

    function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {

        _swapTokensAtAmount = swapTokensAtAmount;

    }

 

    //Set max buy amount 

    function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {

        _maxTxAmount = maxTxAmount;

    }



    //Set max wallet amount 

    function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {

        _maxWalletSize = maxWalletSize;

    }



    function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {

        for(uint256 i = 0; i < accounts.length; i++) {

            _isExcludedFromFee[accounts[i]] = excluded;

        }

    }

}