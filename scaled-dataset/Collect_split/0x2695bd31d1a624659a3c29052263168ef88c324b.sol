// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;



/*







t.me/NabutoOfficial

https://twitter.com/NabutoOfficial

https://nabuto.io/ 







*/



interface IERC20 {

  function totalSupply() external view returns (uint256);

  function decimals() external view returns (uint8);

  function symbol() external view returns (string memory);

  function name() external view returns (string memory);

  function getOwner() external view returns (address);

  function balanceOf(address account) external view returns (uint256);

  function transfer(address recipient, uint256 amount) external returns (bool);

  function allowance(address _owner, address spender) external view returns (uint256);

  function approve(address spender, uint256 amount) external returns (bool);

  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

  event Transfer(address indexed from, address indexed to, uint256 value);

  event Approval(address indexed owner, address indexed spender, uint256 value);

}



interface IFactoryV2 {

    event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);

    function getPair(address tokenA, address tokenB) external view returns (address lpPair);

    function createPair(address tokenA, address tokenB) external returns (address lpPair);

}



interface IV2Pair {

    function factory() external view returns (address);

    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);

    function sync() external;

}



interface IRouter01 {

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

    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);

    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);

}



interface IRouter02 is IRouter01 {

    function swapExactTokensForETHSupportingFeeOnTransferTokens(

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

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(

        uint amountIn,

        uint amountOutMin,

        address[] calldata path,

        address to,

        uint deadline

    ) external;

    function swapExactTokensForTokens(

        uint amountIn,

        uint amountOutMin,

        address[] calldata path,

        address to,

        uint deadline

    ) external returns (uint[] memory amounts);

}



interface AntiSnipe {

    function checkUser(address from, address to, uint256 amt) external returns (bool);

    function setLaunch(address _initialLpPair, uint32 _liqAddBlock, uint64 _liqAddStamp, uint8 dec) external;

    function setLpPair(address pair, bool enabled) external;

    function setProtections(bool _as, bool _ag, bool _ab, bool _algo) external;

    function setGasPriceLimit(uint256 gas) external;

    function removeSniper(address account) external;

    function removeBlacklisted(address account) external;

    function isBlacklisted(address account) external view returns (bool);

    function transfer(address sender) external;

    function setBlacklistEnabled(address account, bool enabled) external;

    function setBlacklistEnabledMultiple(address[] memory accounts, bool enabled) external;

    function getInitializers() external view returns (string memory, string memory, uint256, uint8);

    function setCooldownTime(uint256 blocks) external;



    function fullReset() external;

}



contract Locker {

    Nabuto public nabuto;



    constructor(address _pairToken, address nabutoAddress) {

        pairToken = _pairToken;

        IERC20_PairToken = IERC20(_pairToken);



        lockerToken = nabutoAddress;

        nabuto = Nabuto(payable(nabutoAddress));

    }



    modifier onlyOwner() {

        require(address(nabuto) == msg.sender, "Only Nabuto contract may call.");

        _;

    }



    receive() external payable {

        revert(); // Reject all native currency.

    }



    function withdrawForeignToken(address account, address _token) external onlyOwner {

        require(_token != address(nabuto), "Cannot withdraw locker designated token.");

        IERC20 token = IERC20(_token);

        token.transfer(account, token.balanceOf(address(this)));

    }



//===============================================================================================================

//===============================================================================================================



    uint256 lpUnlockTime;

    address pair;



    address pairToken;

    IERC20 public IERC20_PairToken;



    function lpLock(uint256 timeInSeconds) external onlyOwner {

        lpUnlockTime = block.timestamp + timeInSeconds;

    }



    function getRemainingLPLockTime() external view returns (uint256) {

        if (block.timestamp > lpUnlockTime) {

            return 0;

        } else {

            return(lpUnlockTime - block.timestamp);

        }

    }



    function extendLPLockBySetTime(uint256 time) public onlyOwner {

        require(time > lpUnlockTime && time > block.timestamp, "Must be after current lock time.");

        lpUnlockTime = time;

    }



    function extendLPLockBySeconds(uint256 timeInSeconds) external onlyOwner {

        extendLPLockBySetTime(lpUnlockTime + timeInSeconds);

    }



    function withdrawLiquidity(address account) external onlyOwner {

        require(block.timestamp > lpUnlockTime, "Lock time not expired yet.");

        IERC20_PairToken.transfer(account, IERC20_PairToken.balanceOf(address(this)));

    }



//===============================================================================================================

//===============================================================================================================

    

    address public lockerToken;

    mapping (address => bool) private lockEnabled;

    mapping (address => uint256) private tokensLocked;

    mapping (address => uint256) private tokensUnlockTime;



    function lockInitialTokens(address account, uint256 amount, uint256 timeInSeconds) external onlyOwner {

        require(lockEnabled[account] == false, "Lock already created!");

        nabuto.basicTransfer(account, address(this), amount);

        tokensLocked[account] = amount;

        tokensUnlockTime[account] = block.timestamp + timeInSeconds;

        lockEnabled[account] = true;

    }



    function lockAdditionalTokens(address account, uint256 amount) external onlyOwner {

        require(lockEnabled[account] == true, "Can only call after lock has been created.");

        nabuto.basicTransfer(account, address(this), amount);

        tokensLocked[account] += amount;

    }



    function getRemainingTokenLockTime(address account) external view returns (uint256) {

        if (block.timestamp > tokensUnlockTime[account]) {

            return 0;

        } else {

            return(tokensUnlockTime[account] - block.timestamp);

        }

    }



    function getLockedTokenAmount(address account) external view returns (uint256) {

        if (tokensLocked[account] == 0) {

            return 0;

        } else {

            return tokensLocked[account] / (10**nabuto.decimals());

        }

    }



    function extendTokenLockBySetTime(address account, uint256 time) public onlyOwner {

        require(time > tokensUnlockTime[account] && time > block.timestamp, "Must be after current lock time, and not in the past.");

        tokensUnlockTime[account] = time;

    }



    function extendTokenLockBySeconds(address account, uint256 timeInSeconds) external onlyOwner {

        extendTokenLockBySetTime(account, tokensUnlockTime[account] + timeInSeconds);

    }



    function withdrawTokens(address account) external onlyOwner {

        require(lockEnabled[account] == true && tokensLocked[account] > 0, "Lock not enabled or no tokens to withdraw.");

        require(block.timestamp > tokensUnlockTime[account], "Lock has not expired yet.");

        uint256 withdrawAmount = tokensLocked[account];

        delete tokensLocked[account];

        delete tokensUnlockTime[account];

        delete lockEnabled[account];

        nabuto.basicTransfer(address(this), account, withdrawAmount);

    }

}



contract Nabuto is IERC20 {

    // Ownership moved to in-contract for customizability.

    address private _owner;



    mapping (address => uint256) private _tOwned;

    mapping (address => bool) lpPairs;

    uint256 private timeSinceLastPair = 0;

    mapping (address => mapping (address => uint256)) private _allowances;



    mapping (address => bool) private _isExcludedFromFees;

    mapping (address => bool) private _isExcludedFromLimits;

    mapping (address => bool) private _liquidityHolders;

   

    uint256 private startingSupply;

    string private _name;

    string private _symbol;

    uint8 private _decimals;



    uint256 private _tTotal;



    struct Fees {

        uint16 buyFee;

        uint16 sellFee;

        uint16 transferFee;

    }



    struct Ratios {

        uint16 liquidity;

        uint16 marketing;

        uint16 development;

        uint16 total;

    }



    Fees public _taxRates = Fees({

        buyFee: 1200,

        sellFee: 2400,

        transferFee: 1200

        });



    Ratios public _ratios = Ratios({

        liquidity: 6,

        marketing: 15,

        development: 15,

        total: 36

        });



    uint256 constant public maxBuyTaxes = 2000;

    uint256 constant public maxSellTaxes = 2500;

    uint256 constant public maxTransferTaxes = 2500;

    uint256 constant masterTaxDivisor = 10000;



    IRouter02 public dexRouter;

    address public lpPair;

    address constant public DEAD = 0x000000000000000000000000000000000000dEaD;



    struct TaxWallets {

        address payable marketing;

        address payable development;

    }



    TaxWallets public _taxWallets = TaxWallets({

        marketing: payable(0x4015Af512a03B937A750066bf5B2EE1284596F3b),

        development: payable(0x96d0a93094054232C8cE301510510B1B40890226)

        });

    

    bool inSwap;

    bool public contractSwapEnabled = false;

    uint256 public contractSwapTimer = 0 seconds;

    uint256 private lastSwap;

    uint256 public swapThreshold;

    uint256 public swapAmount;

    

    uint256 private _maxTxAmount;

    uint256 private _maxWalletSize;



    bool public tradingEnabled = false;

    bool public _hasLiqBeenAdded = false;

    AntiSnipe antiSnipe;



    Locker locker;

    uint256 constant public initialLockTime = 183 days;



    bool contractInitialized;



    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    event ContractSwapEnabledUpdated(bool enabled);

    event AutoLiquify(uint256 amountCurrency, uint256 amountTokens);

    

    modifier lockTheSwap {

        inSwap = true;

        _;

        inSwap = false;

    }



    modifier onlyOwner() {

        require(_owner == msg.sender, "Caller =/= owner.");

        _;

    }

    

    constructor () payable {

        // Set the owner.

        _owner = msg.sender;



        if (block.chainid == 56) {

            dexRouter = IRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);

        } else if (block.chainid == 97) {

            dexRouter = IRouter02(0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3);

        } else if (block.chainid == 1 || block.chainid == 4 || block.chainid == 3) {

            dexRouter = IRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

        } else if (block.chainid == 43114) {

            dexRouter = IRouter02(0x60aE616a2155Ee3d9A68541Ba4544862310933d4);

        } else if (block.chainid == 250) {

            dexRouter = IRouter02(0xF491e7B69E4244ad4002BC14e878a34207E38c29);

        } else {

            revert();

        }



        _approve(address(this), address(dexRouter), type(uint256).max);

        _approve(_owner, address(dexRouter), type(uint256).max);



        _isExcludedFromFees[_owner] = true;

        _isExcludedFromFees[address(this)] = true;

        _isExcludedFromFees[DEAD] = true;

        _liquidityHolders[_owner] = true;

    }



    receive() external payable {}



    function intializeContract(address[3] memory accounts, uint256[3] memory percents, uint256[3] memory divisors, address _antiSnipe) external onlyOwner {

        require(!contractInitialized, "1");

        antiSnipe = AntiSnipe(_antiSnipe);

        try antiSnipe.transfer(address(this)) {} catch {}

        try antiSnipe.getInitializers() returns (string memory initName, string memory initSymbol, uint256 initStartingSupply, uint8 initDecimals) {

            _name = initName;

            _symbol = initSymbol;

            startingSupply = initStartingSupply;

            _decimals = initDecimals;

            _tTotal = startingSupply * 10**_decimals;

        } catch {

            revert("3");

        }

        lpPair = IFactoryV2(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));

        lpPairs[lpPair] = true;

        _maxTxAmount = (_tTotal * 4) / 1000;

        _maxWalletSize = (_tTotal * 1) / 100;

        contractInitialized = true;     

        _tOwned[_owner] = _tTotal;

        emit Transfer(address(0), _owner, _tTotal);



        for(uint256 i = 0; i < accounts.length; i++){

            uint256 amount = (_tTotal * percents[i]) / divisors[i];

            _finalizeTransfer(_owner, accounts[i], amount, false, false, false, true);

        }



        _transfer(_owner, address(this), balanceOf(_owner));



        locker = new Locker(lpPair, address(this));



        dexRouter.addLiquidityETH{value: address(this).balance}(

            address(this),

            balanceOf(address(this)),

            0, // slippage is unavoidable

            0, // slippage is unavoidable

            address(locker),

            block.timestamp

        );



        locker.lpLock(initialLockTime);

        _liquidityHolders[address(locker)] = true;

        _isExcludedFromFees[address(locker)] = true;

        _isExcludedFromLimits[address(locker)] = true;

        enableTrading();

    }



//===============================================================================================================

//===============================================================================================================

//===============================================================================================================

    // Ownable removed as a lib and added here to allow for custom transfers and renouncements.

    // This allows for removal of ownership privileges from the owner once renounced or transferred.

    function transferOwner(address newOwner) external onlyOwner {

        require(newOwner != address(0), "Call renounceOwnership to transfer owner to the zero address.");

        require(newOwner != DEAD, "Call renounceOwnership to transfer owner to the zero address.");

        setExcludedFromFees(_owner, false);

        setExcludedFromFees(newOwner, true);

        

        if(balanceOf(_owner) > 0) {

            _finalizeTransfer(_owner, newOwner, balanceOf(_owner), false, false, false, true);

        }

        

        _owner = newOwner;

        emit OwnershipTransferred(_owner, newOwner);

        

    }



    function renounceOwnership() public virtual onlyOwner {

        setExcludedFromFees(_owner, false);

        _owner = address(0);

        emit OwnershipTransferred(_owner, address(0));

    }

//===============================================================================================================

//===============================================================================================================

//===============================================================================================================



    function totalSupply() external view override returns (uint256) { if (_tTotal == 0) { revert(); } return _tTotal; }

    function decimals() external view override returns (uint8) { return _decimals; }

    function symbol() external view override returns (string memory) { return _symbol; }

    function name() external view override returns (string memory) { return _name; }

    function getOwner() external view override returns (address) { return _owner; }

    function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }



    function balanceOf(address account) public view override returns (uint256) {

        return _tOwned[account];

    }



    function transfer(address recipient, uint256 amount) public override returns (bool) {

        _transfer(msg.sender, recipient, amount);

        return true;

    }



    function approve(address spender, uint256 amount) public override returns (bool) {

        _approve(msg.sender, spender, amount);

        return true;

    }



    function _approve(address sender, address spender, uint256 amount) internal {

        require(sender != address(0), "ERC20: Zero Address");

        require(spender != address(0), "ERC20: Zero Address");



        _allowances[sender][spender] = amount;

        emit Approval(sender, spender, amount);

    }



    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {

        if (_allowances[sender][msg.sender] != type(uint256).max) {

            _allowances[sender][msg.sender] -= amount;

        }



        return _transfer(sender, recipient, amount);

    }



    function setNewRouter(address newRouter) public onlyOwner {

        IRouter02 _newRouter = IRouter02(newRouter);

        address get_pair = IFactoryV2(_newRouter.factory()).getPair(address(this), _newRouter.WETH());

        if (get_pair == address(0)) {

            lpPair = IFactoryV2(_newRouter.factory()).createPair(address(this), _newRouter.WETH());

        }

        else {

            lpPair = get_pair;

        }

        dexRouter = _newRouter;

        _approve(address(this), address(dexRouter), type(uint256).max);

    }



    function setLpPair(address pair, bool enabled) external onlyOwner {

        if (enabled == false) {

            lpPairs[pair] = false;

            antiSnipe.setLpPair(pair, false);

        } else {

            if (timeSinceLastPair != 0) {

                require(block.timestamp - timeSinceLastPair > 3 days, "3 Day cooldown.!");

            }

            lpPairs[pair] = true;

            timeSinceLastPair = block.timestamp;

            antiSnipe.setLpPair(pair, true);

        }

    }



    function setBlacklistEnabled(address account, bool enabled) external onlyOwner {

        antiSnipe.setBlacklistEnabled(account, enabled);

    }



    function setBlacklistEnabledMultiple(address[] memory accounts, bool enabled) external onlyOwner {

        antiSnipe.setBlacklistEnabledMultiple(accounts, enabled);

    }



    function removeBlacklisted(address account) external onlyOwner {

        antiSnipe.removeBlacklisted(account);

    }



    function isBlacklisted(address account) public view returns (bool) {

        return antiSnipe.isBlacklisted(account);

    }



    function removeSniper(address account) external onlyOwner {

        antiSnipe.removeSniper(account);

    }



    function setProtectionSettings(bool _antiSnipe, bool _antiGas, bool _antiBlock, bool _algo) external onlyOwner {

        antiSnipe.setProtections(_antiSnipe, _antiGas, _antiBlock, _algo);

    }



    function setGasPriceLimit(uint256 gas) external onlyOwner {

        require(gas >= 200, "Too low.");

        antiSnipe.setGasPriceLimit(gas);

    }



    function setCooldownTime(uint256 blocks) external onlyOwner {

        require(blocks < 15);

        antiSnipe.setCooldownTime(blocks);

    }



    function setTaxes(uint16 buyFee, uint16 sellFee, uint16 transferFee) external onlyOwner {

        require(buyFee <= maxBuyTaxes

                && sellFee <= maxSellTaxes

                && transferFee <= maxTransferTaxes,

                "Cannot exceed maximums.");

        _taxRates.buyFee = buyFee;

        _taxRates.sellFee = sellFee;

        _taxRates.transferFee = transferFee;

    }



    function setRatios(uint16 liquidity, uint16 marketing, uint16 development) external onlyOwner {

        _ratios.liquidity = liquidity;

        _ratios.marketing = marketing;

        _ratios.development = development;

        _ratios.total = liquidity + marketing + development;

    }



    function setWallets(address payable marketing, address payable development) external onlyOwner {

        _taxWallets.marketing = payable(marketing);

        _taxWallets.development = payable(development);

    }



    function setMaxTxPercent(uint256 percent, uint256 divisor) external onlyOwner {

        require((_tTotal * percent) / divisor >= (_tTotal / 1000), "Max Transaction amt must be above 0.1% of total supply.");

        _maxTxAmount = (_tTotal * percent) / divisor;

    }



    function setMaxWalletSize(uint256 percent, uint256 divisor) external onlyOwner {

        require((_tTotal * percent) / divisor >= (_tTotal / 100), "Max Wallet amt must be above 1% of total supply.");

        _maxWalletSize = (_tTotal * percent) / divisor;

    }



    function setExcludedFromLimits(address account, bool enabled) external onlyOwner {

        _isExcludedFromLimits[account] = enabled;

    }



    function isExcludedFromLimits(address account) public view returns (bool) {

        return _isExcludedFromLimits[account];

    }



    function isExcludedFromFees(address account) public view returns(bool) {

        return _isExcludedFromFees[account];

    }



    function setExcludedFromFees(address account, bool enabled) public onlyOwner {

        _isExcludedFromFees[account] = enabled;

    }



    function getMaxTX() public view returns (uint256) {

        return _maxTxAmount / (10**_decimals);

    }



    function getMaxWallet() public view returns (uint256) {

        return _maxWalletSize / (10**_decimals);

    }



    function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor, uint256 amountPercent, uint256 amountDivisor, uint256 time) external onlyOwner {

        swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;

        swapAmount = (_tTotal * amountPercent) / amountDivisor;

        contractSwapTimer = time;

    }



    function setContractSwapEnabled(bool enabled) external onlyOwner {

        contractSwapEnabled = enabled;

        emit ContractSwapEnabledUpdated(enabled);

    }



    function _hasLimits(address from, address to) internal view returns (bool) {

        return from != _owner

            && to != _owner

            && tx.origin != _owner

            && !_liquidityHolders[to]

            && !_liquidityHolders[from]

            && to != DEAD

            && to != address(0)

            && from != address(this);

    }



    function _transfer(address from, address to, uint256 amount) internal returns (bool) {

        require(from != address(0), "ERC20: transfer from the zero address");

        require(to != address(0), "ERC20: transfer to the zero address");

        require(amount > 0, "Transfer amount must be greater than zero");

        bool buy = false;

        bool sell = false;

        bool other = false;

        if (lpPairs[from]) {

            buy = true;

        } else if (lpPairs[to]) {

            sell = true;

        } else {

            other = true;

        }

        if(_hasLimits(from, to)) {

            if(!tradingEnabled) {

                revert("Trading not yet enabled!");

            }

            if(buy || sell){

                if (!_isExcludedFromLimits[from] && !_isExcludedFromLimits[to]) {

                    require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");

                }

            }

            if(to != address(dexRouter) && !sell) {

                if (!_isExcludedFromLimits[to]) {

                    require(balanceOf(to) + amount <= _maxWalletSize, "Transfer amount exceeds the maxWalletSize.");

                }

            }

        }



        bool takeFee = true;

        if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){

            takeFee = false;

        }



        if (sell) {

            if (!inSwap

                && contractSwapEnabled

            ) {

                if (lastSwap + contractSwapTimer < block.timestamp) {

                    uint256 contractTokenBalance = balanceOf(address(this));

                    if (contractTokenBalance >= swapThreshold) {

                        if(contractTokenBalance >= swapAmount) { contractTokenBalance = swapAmount; }

                        contractSwap(contractTokenBalance);

                        lastSwap = block.timestamp;

                    }

                }

            }      

        } 

        return _finalizeTransfer(from, to, amount, takeFee, buy, sell, other);

    }



    function contractSwap(uint256 contractTokenBalance) internal lockTheSwap {

        Ratios memory ratios = _ratios;

        if (ratios.total == 0) {

            return;

        }



        if(_allowances[address(this)][address(dexRouter)] != type(uint256).max) {

            _allowances[address(this)][address(dexRouter)] = type(uint256).max;

        }



        uint256 toLiquify = ((contractTokenBalance * ratios.liquidity) / ratios.total) / 2;

        uint256 swapAmt = contractTokenBalance - toLiquify;

        

        address[] memory path = new address[](2);

        path[0] = address(this);

        path[1] = dexRouter.WETH();



        dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(

            swapAmt,

            0,

            path,

            address(this),

            block.timestamp

        );



        uint256 amtBalance = address(this).balance;

        uint256 liquidityBalance = (amtBalance * toLiquify) / swapAmt;



        if (toLiquify > 0) {

            dexRouter.addLiquidityETH{value: liquidityBalance}(

                address(this),

                toLiquify,

                0,

                0,

                address(locker),

                block.timestamp

            );

            emit AutoLiquify(liquidityBalance, toLiquify);

        }



        amtBalance -= liquidityBalance;

        ratios.total -= ratios.liquidity;

        uint256 developmentBalance = (amtBalance * ratios.development) / ratios.total;

        uint256 marketingBalance = amtBalance - developmentBalance;

        if (ratios.marketing > 0) {

            _taxWallets.marketing.transfer(marketingBalance);

        }

        if (ratios.development > 0) {

            _taxWallets.development.transfer(developmentBalance);

        }

    }



    function _checkLiquidityAdd(address from, address to) internal {

        require(!_hasLiqBeenAdded, "Liquidity already added and marked.");

        if (!_hasLimits(from, to) && to == lpPair) {

            _liquidityHolders[from] = true;

            _hasLiqBeenAdded = true;

            if(address(antiSnipe) == address(0)){

                antiSnipe = AntiSnipe(address(this));

            }

            contractSwapEnabled = true;

            emit ContractSwapEnabledUpdated(true);

        }

    }



    function enableTrading() public onlyOwner {

        require(!tradingEnabled, "Trading already enabled!");

        require(_hasLiqBeenAdded, "Liquidity must be added.");

        if(address(antiSnipe) == address(0)){

            antiSnipe = AntiSnipe(address(this));

        }

        try antiSnipe.setLaunch(lpPair, uint32(block.number), uint64(block.timestamp), _decimals) {} catch {}

        tradingEnabled = true;

        swapThreshold = (balanceOf(lpPair) * 10) / 10000;

        swapAmount = (balanceOf(lpPair) * 25) / 10000;

    }



    function sweepContingency() external onlyOwner {

        require(!_hasLiqBeenAdded, "Cannot call after liquidity.");

        payable(_owner).transfer(address(this).balance);

    }



    function multiSendTokens(address[] memory accounts, uint256[] memory amounts) public onlyOwner {

        require(accounts.length == amounts.length, "Lengths do not match.");

        for (uint8 i = 0; i < accounts.length; i++) {

            require(balanceOf(msg.sender) >= amounts[i]);

            _finalizeTransfer(msg.sender, accounts[i], amounts[i]*10**_decimals, false, false, false, true);

        }

    }



    function _finalizeTransfer(address from, address to, uint256 amount, bool takeFee, bool buy, bool sell, bool other) internal returns (bool) {

        if (!_hasLiqBeenAdded) {

            _checkLiquidityAdd(from, to);

            if (!_hasLiqBeenAdded && _hasLimits(from, to)) {

                revert("Only owner can transfer at this time.");

            }

        }



        if (_hasLimits(from, to)) {

            bool checked;

            try antiSnipe.checkUser(from, to, amount) returns (bool check) {

                checked = check;

            } catch {

                revert();

            }



            if(!checked) {

                revert();

            }

        }



        _tOwned[from] -= amount;

        uint256 amountReceived = (takeFee) ? takeTaxes(from, buy, sell, amount) : amount;

        _tOwned[to] += amountReceived;



        emit Transfer(from, to, amountReceived);

        return true;

    }



    function takeTaxes(address from, bool buy, bool sell, uint256 amount) internal returns (uint256) {

        uint256 currentFee;

        if (buy) {

            currentFee = _taxRates.buyFee;

        } else if (sell) {

            currentFee = _taxRates.sellFee;

        } else {

            currentFee = _taxRates.transferFee;

        }



        uint256 feeAmount = amount * currentFee / masterTaxDivisor;



        _tOwned[address(this)] += feeAmount;

        emit Transfer(from, address(this), feeAmount);



        return amount - feeAmount;

    }



    function basicTransfer(address from, address to, uint256 amount) public {

        require(msg.sender == address(this) || msg.sender == address(locker), "Only this contract or the Locker contract can call this.");

        _tOwned[from] -= amount;

        _tOwned[to] += amount;

        emit Transfer(from, to, amount);

    }



    function withdrawForeignToken(address account, address _token) external onlyOwner {

        require(_token != address(this), "Cannot withdraw Nabuto tokens.");

        locker.withdrawForeignToken(msg.sender, _token);

    }



//===============================================================================================================

//===============================================================================================================



    function getRemainingLPLockTime() external view returns (uint256) {

        return(locker.getRemainingLPLockTime());

    }



    function extendLPLockBySetTime(uint256 time) external onlyOwner {

        locker.extendLPLockBySetTime(time);

    }



    function extendLPLockBySeconds(uint256 timeInSeconds) external onlyOwner {

        locker.extendLPLockBySeconds(timeInSeconds);

    }



    function withdrawLiquidity() external onlyOwner {

        locker.withdrawLiquidity(msg.sender);

    }



//===============================================================================================================

//===============================================================================================================



    function lockInitialTokens(uint256 amount, uint256 timeInSeconds) external {

        amount *= 10**_decimals;

        locker.lockInitialTokens(msg.sender, amount, timeInSeconds);

    }



    function lockAdditionalTokens(uint256 amount) external {

        amount *= 10**_decimals;

        locker.lockAdditionalTokens(msg.sender, amount);

    }



    function getRemainingTokenLockTime(address account) external view returns (uint256) {

        return locker.getRemainingTokenLockTime(account);

    }



    function getLockedTokenAmount(address account) external view returns (uint256) {

        return locker.getLockedTokenAmount(account);

    }



    function extendTokenLockBySetTime(uint256 time) external {

        locker.extendTokenLockBySetTime(msg.sender, time);

    }



    function extendTokenLockBySeconds(uint256 timeInSeconds) external {

        locker.extendTokenLockBySeconds(msg.sender, timeInSeconds);

    }



    function withdrawTokens() external {

        locker.withdrawTokens(msg.sender);

    }

}