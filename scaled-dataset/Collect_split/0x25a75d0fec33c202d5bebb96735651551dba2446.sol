/*

-- TG: https://t.me/babycramereth

-- Twitter: https://twitter.com/babycramereth

-- "Time is the bearer of all truth."

*/



// SPDX-License-Identifier: MIT                                                                           



pragma solidity 0.8.11;



abstract contract Context {

    function _msgSender() internal view virtual returns (address) {

        return msg.sender;

    }



    function _msgData() internal view virtual returns (bytes calldata) {

        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691

        return msg.data;

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

    mapping(address => uint256) private _balances;



    mapping(address => mapping(address => uint256)) private _allowances;



    uint256 private _totalSupply;



    string private _name;

    string private _symbol;



    constructor(string memory name_, string memory symbol_) {

        _name = name_;

        _symbol = symbol_;

    }



    function name() public view virtual override returns (string memory) {

        return _name;

    }



    function symbol() public view virtual override returns (string memory) {

        return _symbol;

    }



    function decimals() public view virtual override returns (uint8) {

        return 18;

    }



    function totalSupply() public view virtual override returns (uint256) {

        return _totalSupply;

    }



    function balanceOf(address account) public view virtual override returns (uint256) {

        return _balances[account];

    }



    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {

        _transfer(_msgSender(), recipient, amount);

        return true;

    }



    function allowance(address owner, address spender) public view virtual override returns (uint256) {

        return _allowances[owner][spender];

    }



    function approve(address spender, uint256 amount) public virtual override returns (bool) {

        _approve(_msgSender(), spender, amount);

        return true;

    }



    function transferFrom(

        address sender,

        address recipient,

        uint256 amount

    ) public virtual override returns (bool) {

        _transfer(sender, recipient, amount);



        uint256 currentAllowance = _allowances[sender][_msgSender()];

        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");

        unchecked {

            _approve(sender, _msgSender(), currentAllowance - amount);

        }



        return true;

    }



    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {

        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);

        return true;

    }



    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {

        uint256 currentAllowance = _allowances[_msgSender()][spender];

        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");

        unchecked {

            _approve(_msgSender(), spender, currentAllowance - subtractedValue);

        }



        return true;

    }



    function _transfer(

        address sender,

        address recipient,

        uint256 amount

    ) internal virtual {

        require(sender != address(0), "ERC20: transfer from the zero address");

        require(recipient != address(0), "ERC20: transfer to the zero address");



        uint256 senderBalance = _balances[sender];

        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");

        unchecked {

            _balances[sender] = senderBalance - amount;

        }

        _balances[recipient] += amount;



        emit Transfer(sender, recipient, amount);

    }



    function _createInitialSupply(address account, uint256 amount) internal virtual {

        require(account != address(0), "ERC20: mint to the zero address");



        _totalSupply += amount;

        _balances[account] += amount;

        emit Transfer(address(0), account, amount);

    }



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



    function renounceOwnership() external virtual onlyOwner {

        emit OwnershipTransferred(_owner, address(0));

        _owner = address(0);

    }



    function transferOwnership(address newOwner) public virtual onlyOwner {

        require(newOwner != address(0), "Ownable: new owner is the zero address");

        emit OwnershipTransferred(_owner, newOwner);

        _owner = newOwner;

    }

}



interface IDexRouter {

    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    

    function swapExactTokensForETHSupportingFeeOnTransferTokens(

        uint amountIn,

        uint amountOutMin,

        address[] calldata path,

        address to,

        uint deadline

    ) external;



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



interface IDexFactory {

    function createPair(address tokenA, address tokenB)

        external

        returns (address pair);

}



contract BABYCRAMER is ERC20, Ownable {



    uint256 public maxBuyAmount;

    uint256 public maxSellAmount;

    uint256 public maxWalletAmount;



    IDexRouter public immutable uniswapV2Router;

    address public immutable uniswapV2Pair;



    bool private swapping;

    uint256 public swapTokensAtAmount;



    address public operationsAddress;

    address public TaxAddress;



    uint256 public tradingActiveBlock = 0; // 0 means trading is not active



    bool public limitsInEffect = true;

    bool public tradingActive = false;

    bool public swapEnabled = false;

    

     // Anti-bot and anti-whale mappings and variables

    mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch

    bool public transferDelayEnabled = true;



    uint256 public buyTotalFees;

    uint256 public buyOperationsFee;

    uint256 public buyLiquidityFee;

    uint256 public buyTaxFee;



    uint256 public sellTotalFees;

    uint256 public sellOperationsFee;

    uint256 public sellLiquidityFee;

    uint256 public sellTaxFee;



    uint256 public tokensForOperations;

    uint256 public tokensForLiquidity;

    uint256 public tokensForTax;

    

    /******************/



    // exlcude from fees and max transaction amount

    mapping (address => bool) private _isExcludedFromFees;

    mapping (address => bool) public _isExcludedMaxTransactionAmount;



    // store addresses that a automatic market maker pairs. Any transfer *to* these addresses

    // could be subject to a maximum transfer amount

    mapping (address => bool) public automatedMarketMakerPairs;



    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);



    event EnabledTrading();

    event RemovedLimits();



    event ExcludeFromFees(address indexed account, bool isExcluded);



    event UpdatedMaxBuyAmount(uint256 newAmount);



    event UpdatedMaxSellAmount(uint256 newAmount);



    event UpdatedMaxWalletAmount(uint256 newAmount);



    event UpdatedOperationsAddress(address indexed newWallet);



    event UpdatedTaxAddress(address indexed newWallet);



    event MaxTransactionExclusion(address _address, bool excluded);



    event SwapAndLiquify(

        uint256 tokensSwapped,

        uint256 ethReceived,

        uint256 tokensIntoLiquidity

    );



    event TransferForeignToken(address token, uint256 amount);



    constructor() ERC20( "BABYCRAMER", "BABYCRAMER") {

        

        address newOwner = msg.sender; // can leave alone if owner is deployer.

        

        IDexRouter _uniswapV2Router = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);



        _excludeFromMaxTransaction(address(_uniswapV2Router), true);

        uniswapV2Router = _uniswapV2Router;

        

        uniswapV2Pair = IDexFactory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());

        _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);

 

        uint256 totalSupply = 1 * 1e9 * 1e18;

        

        maxBuyAmount = totalSupply * 3 / 1000; //3,000,000

        maxSellAmount = totalSupply * 3 / 1000; //3,000,000

        maxWalletAmount = totalSupply * 3 / 1000; // 3,000,000

        swapTokensAtAmount = totalSupply * 25 / 100000; // 0.025% swap amount // This is how many tokens is needed within contract to activate swap



        buyOperationsFee = 0;

        buyLiquidityFee = 1;

        buyTaxFee = 0;

        buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTaxFee;



        sellOperationsFee = 2;

        sellLiquidityFee = 3;

        sellTaxFee = 0;

        sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTaxFee;



        _excludeFromMaxTransaction(newOwner, true);

        _excludeFromMaxTransaction(address(this), true);

        _excludeFromMaxTransaction(address(0xdead), true);



        excludeFromFees(newOwner, true);

        excludeFromFees(address(this), true);

        excludeFromFees(address(0xdead), true);



        operationsAddress = address(0x6A8B62180B2499f1Cc1A763DBEcE1FaC4Ebe2E20); // change this address to wallet u want for operations   

        TaxAddress = address(0x6A8B62180B2499f1Cc1A763DBEcE1FaC4Ebe2E20);  // change this address to the one for tax 

        

        _createInitialSupply(newOwner, totalSupply);

        transferOwnership(newOwner);

    }



    receive() external payable {}



    // once enabled, can never be turned off

    function enableTrading() external onlyOwner {

        require(!tradingActive, "Cannot reenable trading");

        tradingActive = true;

        swapEnabled = true;

        tradingActiveBlock = block.number;

        emit EnabledTrading();

    }

    

    // remove limits after token is stable

    function removeLimits() external onlyOwner {

        limitsInEffect = false;

        transferDelayEnabled = false;

        emit RemovedLimits();

    }

    

   

    // disable Transfer delay - cannot be reenabled

    function disableTransferDelay() external onlyOwner {

        transferDelayEnabled = false;

    }

    

    function updateMaxBuyAmount(uint256 newNum) external onlyOwner {

        require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set max buy amount lower than 0.1%");

        maxBuyAmount = newNum * (10**18);

        emit UpdatedMaxBuyAmount(maxBuyAmount);

    }

    

    function updateMaxSellAmount(uint256 newNum) external onlyOwner {

        require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set max sell amount lower than 0.1%");

        maxSellAmount = newNum * (10**18);

        emit UpdatedMaxSellAmount(maxSellAmount);

    }



    function updateMaxWalletAmount(uint256 newNum) external onlyOwner {

        require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");

        maxWalletAmount = newNum * (10**18);

        emit UpdatedMaxWalletAmount(maxWalletAmount);

    }



    // change the minimum amount of tokens to sell from fees

    function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {

        require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");

        require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");

        swapTokensAtAmount = newAmount;

    }

    

    function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {

        _isExcludedMaxTransactionAmount[updAds] = isExcluded;

        emit MaxTransactionExclusion(updAds, isExcluded);

    }



    

    function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {

        if(!isEx){

            require(updAds != uniswapV2Pair, "Cannot remove uniswap pair from max txn");

        }

        _isExcludedMaxTransactionAmount[updAds] = isEx;

    }



    function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {

        require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");



        _setAutomatedMarketMakerPair(pair, value);

    }



    function _setAutomatedMarketMakerPair(address pair, bool value) private {

        automatedMarketMakerPairs[pair] = value;

        

        _excludeFromMaxTransaction(pair, value);



        emit SetAutomatedMarketMakerPair(pair, value);

    }



    function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _TaxFee) external onlyOwner {

        buyOperationsFee = _operationsFee;

        buyLiquidityFee = _liquidityFee;

        buyTaxFee = _TaxFee;

        buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTaxFee;

        require(buyTotalFees <= 15, "Must keep fees at 15% or less");

    }



    function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _TaxFee) external onlyOwner {

        sellOperationsFee = _operationsFee;

        sellLiquidityFee = _liquidityFee;

        sellTaxFee = _TaxFee;

        sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTaxFee;

        require(sellTotalFees <= 20, "Must keep fees at 20% or less");

    }



    function excludeFromFees(address account, bool excluded) public onlyOwner {

        _isExcludedFromFees[account] = excluded;

        emit ExcludeFromFees(account, excluded);

    }



    function _transfer(address from, address to, uint256 amount) internal override {



        require(from != address(0), "ERC20: transfer from the zero address");

        require(to != address(0), "ERC20: transfer to the zero address");

        require(amount > 0, "amount must be greater than 0");

        

        

        if(limitsInEffect){

            if (from != owner() && to != owner() && to != address(0) && to != address(0xdead)){

                if(!tradingActive){

                    require(_isExcludedMaxTransactionAmount[from] || _isExcludedMaxTransactionAmount[to], "Trading is not active.");

                }

                

                // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  

                if (transferDelayEnabled){

                    if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)){

                        require(_holderLastTransferTimestamp[tx.origin] < block.number - 4 && _holderLastTransferTimestamp[to] < block.number - 4, "_transfer:: Transfer Delay enabled.  Try again later.");

                        _holderLastTransferTimestamp[tx.origin] = block.number;

                        _holderLastTransferTimestamp[to] = block.number;

                    }

                }

                 

                //when buy

                if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {

                        require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");

                        require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");

                } 

                //when sell

                else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {

                        require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");

                } 

                else if (!_isExcludedMaxTransactionAmount[to] && !_isExcludedMaxTransactionAmount[from]){

                    require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");

                }

            }

        }



        uint256 contractTokenBalance = balanceOf(address(this));

        

        bool canSwap = contractTokenBalance >= swapTokensAtAmount;



        if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {

            swapping = true;



            swapBack();



            swapping = false;

        }



        bool takeFee = true;

        // if any account belongs to _isExcludedFromFee account then remove the fee

        if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {

            takeFee = false;

        }

        

        uint256 fees = 0;

        uint256 penaltyAmount = 0;

        // only take fees on buys/sells, do not take on wallet transfers

        if(takeFee){

            // bot/sniper penalty.  Tokens get transferred to marketing wallet to allow potential refund.

            if(tradingActiveBlock >= block.number + 1 && automatedMarketMakerPairs[from]){

                penaltyAmount = amount * 99 / 100;

                super._transfer(from, operationsAddress, penaltyAmount);

            }

            // on sell

            else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){

                fees = amount * sellTotalFees /100;

                tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;

                tokensForOperations += fees * sellOperationsFee / sellTotalFees;

                tokensForTax += fees * sellTaxFee / sellTotalFees;

            }

            // on buy

            else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {

                fees = amount * buyTotalFees / 100;

                tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;

                tokensForOperations += fees * buyOperationsFee / buyTotalFees;

                tokensForTax += fees * buyTaxFee / buyTotalFees;

            }

            

            if(fees > 0){    

                super._transfer(from, address(this), fees);

            }

            

            amount -= fees + penaltyAmount;

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

            address(0xdead),

            block.timestamp

        );

    }



    function swapBack() private {

        uint256 contractBalance = balanceOf(address(this));

        uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForTax;

        

        if(contractBalance == 0 || totalTokensToSwap == 0) {return;}



        if(contractBalance > swapTokensAtAmount * 10){

            contractBalance = swapTokensAtAmount * 10;

        }



        bool success;

        

        // Halve the amount of liquidity tokens

        uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;

        

        swapTokensForEth(contractBalance - liquidityTokens); 

        

        uint256 ethBalance = address(this).balance;

        uint256 ethForLiquidity = ethBalance;



        uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));

        uint256 ethForTax = ethBalance * tokensForTax / (totalTokensToSwap - (tokensForLiquidity/2));



        ethForLiquidity -= ethForOperations + ethForTax;

            

        tokensForLiquidity = 0;

        tokensForOperations = 0;

        tokensForTax = 0;

        

        if(liquidityTokens > 0 && ethForLiquidity > 0){

            addLiquidity(liquidityTokens, ethForLiquidity);

        }



        (success,) = address(TaxAddress).call{value: ethForTax}("");



        (success,) = address(operationsAddress).call{value: address(this).balance}("");

    }



    function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {

        require(_token != address(0), "_token address cannot be 0");

        require(_token != address(this), "Can't withdraw native tokens");

        uint256 _contractBalance = IERC20(_token).balanceOf(address(this));

        _sent = IERC20(_token).transfer(_to, _contractBalance);

        emit TransferForeignToken(_token, _contractBalance);

    }



    // withdraw ETH if stuck or someone sends to the address

    function withdrawStuckETH() external onlyOwner {

        bool success;

        (success,) = address(msg.sender).call{value: address(this).balance}("");

    }



    function setOperationsAddress(address _operationsAddress) external onlyOwner {

        require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");

        operationsAddress = payable(_operationsAddress);

        emit UpdatedOperationsAddress(_operationsAddress);

    }



    function setTaxAddress(address _TaxAddress) external onlyOwner {

        require(_TaxAddress != address(0), "_TaxAddress address cannot be 0");

        TaxAddress = payable(_TaxAddress);

        emit UpdatedTaxAddress(_TaxAddress);

    }

}