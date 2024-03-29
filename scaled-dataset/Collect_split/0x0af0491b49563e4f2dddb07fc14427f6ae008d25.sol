// File: contracts/interfaces/IERC20.sol



pragma solidity ^0.5.12;





interface IERC20 {

    /*

     * Metadata

     */

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint256);



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

     * @dev Only used on BASE token

     */

    function transferFromWithFee(address sender, address recipient, uint256 amount) external returns (bool);



    /**

     * @dev Only used on BASE token

     */

    function transferWithFee(address recipient, uint256 amount) external returns (bool);



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



// File: contracts/interfaces/IUniswapExchange.sol



pragma solidity ^0.5.12;





interface IUniswapExchange {

    // Address of ERC20 token sold on this exchange

    function tokenAddress() external view returns (address token);

    // Address of Uniswap Factory

    function factoryAddress() external view returns (address factory);

    // Provide Liquidity

    function addLiquidity(uint256 min_liquidity, uint256 max_tokens, uint256 deadline) external payable returns (uint256);

    function removeLiquidity(uint256 amount, uint256 min_eth, uint256 min_tokens, uint256 deadline) external returns (uint256, uint256);

    // Get Prices

    function getEthToTokenInputPrice(uint256 eth_sold) external view returns (uint256 tokens_bought);

    function getEthToTokenOutputPrice(uint256 tokens_bought) external view returns (uint256 eth_sold);

    function getTokenToEthInputPrice(uint256 tokens_sold) external view returns (uint256 eth_bought);

    function getTokenToEthOutputPrice(uint256 eth_bought) external view returns (uint256 tokens_sold);

    // Trade ETH to ERC20

    function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline) external payable returns (uint256  tokens_bought);

    function ethToTokenTransferInput(uint256 min_tokens, uint256 deadline, address recipient) external payable returns (uint256  tokens_bought);

    function ethToTokenSwapOutput(uint256 tokens_bought, uint256 deadline) external payable returns (uint256  eth_sold);

    function ethToTokenTransferOutput(uint256 tokens_bought, uint256 deadline, address recipient) external payable returns (uint256  eth_sold);

    // Trade ERC20 to ETH

    function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline) external returns (uint256  eth_bought);

    function tokenToEthTransferInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline, address recipient) external returns (uint256  eth_bought);

    function tokenToEthSwapOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline) external returns (uint256  tokens_sold);

    function tokenToEthTransferOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline, address recipient) external returns (uint256  tokens_sold);

    // Trade ERC20 to ERC20

    function tokenToTokenSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address token_addr) external returns (uint256  tokens_bought);

    function tokenToTokenTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_bought);

    function tokenToTokenSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address token_addr) external returns (uint256  tokens_sold);

    function tokenToTokenTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_sold);

    // Trade ERC20 to Custom Pool

    function tokenToExchangeSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address exchange_addr) external returns (uint256  tokens_bought);

    function tokenToExchangeTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_bought);

    function tokenToExchangeSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address exchange_addr) external returns (uint256  tokens_sold);

    function tokenToExchangeTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_sold);

    // ERC20 comaptibility for liquidity tokens

    function transfer(address _to, uint256 _value) external returns (bool);

    function transferFrom(address _from, address _to, uint256 value) external returns (bool);

    function approve(address _spender, uint256 _value) external returns (bool);

    function allowance(address _owner, address _spender) external view returns (uint256);

    function balanceOf(address _owner) external view returns (uint256);

    function totalSupply() external view returns (uint256);

    // Never use

    function setup(address token_addr) external;

}



// File: contracts/utils/IsContract.sol



pragma solidity ^0.5.12;





library IsContract {

    function isContract(address _addr) internal view returns (bool) {

        bytes32 codehash;

        /* solium-disable-next-line */

        assembly { codehash := extcodehash(_addr) }

        return codehash != bytes32(0) && codehash != bytes32(0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470);

    }

}



// File: contracts/interfaces/IDefswapExchange.sol



pragma solidity ^0.5.12;





interface IDefswapExchange {

    function base() external view returns (IERC20);

    function token() external view returns (IERC20);

    function addLiquidity(uint256 _tokens, uint256 _maxBase) external returns (uint256);

    function removeLiquidity(uint256 _amount, uint256 _minBase, uint256 _minTokens) external returns (uint256, uint256);

    function ethToTokenSwapInput(uint256 _minTokens) external payable returns (uint256);

    function baseToTokenSwapInput(uint256 _amount, uint256 _minTokens) external returns (uint256);

    function baseToTokenTransferInput(uint256 _amount, uint256 _minTokens, address _recipient) external returns (uint256);

    function tokenToEthSwapInput(uint256 _amount, uint256 _minEth) external returns (uint256);

    function tokenToEthTransferInput(uint256 _amount, uint256 _minEth, address _recipient) external returns (uint256);

    function tokenToEthExchangeTransferInput(uint256 _amount, uint256 _minTokens, address _recipient, address _exchangeAddr) external returns (uint256);

    function tokenToBaseSwapInput(uint256 _amount, uint256 _minBase) external returns (uint256);

    function tokenToBaseTransferInput(uint256 _amount, uint256 _minBase, address _recipient) external returns (uint256);

    function tokenToBaseExchangeTransferInput(uint256 _amount, uint256 _minTokens, address _recipient, address _exchangeAddr) external returns (uint256);

    // Uniswap exchange compat

    function ethToTokenTransferInput(uint256 _minTokens, uint256 _deadline, address _recipient) external payable returns (uint256);

}



// File: contracts/utils/ReentrancyGuard.sol



pragma solidity ^0.5.12;





/**

 * @dev Contract module that helps prevent reentrant calls to a function.

 *

 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier

 * available, which can be applied to functions to make sure there are no nested

 * (reentrant) calls to them.

 *

 * Note that because there is a single `nonReentrant` guard, functions marked as

 * `nonReentrant` may not call one another. This can be worked around by making

 * those functions `private`, and then adding `external` `nonReentrant` entry

 * points to them.

 */

contract ReentrancyGuard {

    uint256 private _guardFlag;



    uint256 private constant FLAG_LOCK = 2;

    uint256 private constant FLAG_UNLOCK = 1;



    constructor () internal {

        // The flag starts at one to prevent changing it from zero to a non-zero

        // value, which is a more expensive operation.

        _guardFlag = FLAG_UNLOCK;

    }



    /**

     * @dev Prevents a contract from calling itself, directly or indirectly.

     * Calling a `nonReentrant` function from another `nonReentrant`

     * function is not supported. It is possible to prevent this from happening

     * by making the `nonReentrant` function external, and make it call a

     * `private` function that does the actual work.

     */

    modifier nonReentrant() {

        require(_guardFlag != FLAG_LOCK, "reentrancy-guard: reentrant call");

        _guardFlag = FLAG_LOCK;

        _;

        _guardFlag = FLAG_UNLOCK;

    }

}



// File: contracts/utils/SafeMath.sol



pragma solidity ^0.5.12;





library SafeMath {

    function add(uint256 x, uint256 y) internal pure returns (uint256) {

        uint256 z = x + y;

        require(z >= x, "safemath: add overflow");

        return z;

    }



    function sub(uint256 x, uint256 y) internal pure returns (uint256) {

        require(x >= y, "safemath: sub overflow");

        return x - y;

    }



    function mul(uint256 x, uint256 y) internal pure returns (uint256) {

        if (x == 0) {

            return 0;

        }



        uint256 z = x * y;

        require(z / x == y, "safemath: mul overflow");

        return z;

    }



    function div(uint256 x, uint256 y) internal pure returns (uint256) {

        require(y != 0, "safemath: div by zero");

        return x / y;

    }



    function divRound(uint256 x, uint256 y) internal pure returns (uint256) {

        require(y != 0, "safemath: div by zero");

        uint256 z = x / y;

        if (x % y != 0) {

            z = z + 1;

        }



        return z;

    }

}



// File: contracts/commons/ERC20.sol



pragma solidity ^0.5.12;





contract ERC20 is IERC20 {

    using SafeMath for uint256;



    uint256 internal p_totalSupply;

    mapping(address => uint256) private p_balance;

    mapping(address => mapping(address => uint256)) private p_allowance;



    string private p_symbol;

    string private p_name;

    uint256 private p_decimals;



    function _setMetadata(

        string memory _symbol,

        string memory _name,

        uint256 _decimals

    ) internal {

        p_symbol = _symbol;

        p_name = _name;

        p_decimals = _decimals;

    }



    function symbol() external view returns (string memory) {

        return p_symbol;

    }



    function name() external view returns (string memory) {

        return p_name;

    }



    function decimals() external view returns (uint256) {

        return p_decimals;

    }



    function totalSupply() external view returns (uint256) {

        return p_totalSupply;

    }



    function balanceOf(address _addr) external view returns (uint256) {

        return p_balance[_addr];

    }



    function allowance(address _addr, address _spender) external view returns (uint256) {

        return p_allowance[_addr][_spender];

    }



    function approve(address _spender, uint256 _wad) external returns (bool) {

        emit Approval(msg.sender, _spender, _wad);

        p_allowance[msg.sender][_spender] = _wad;

        return true;

    }



    function transfer(address _to, uint256 _wad) external returns (bool) {

        _transfer(msg.sender, _to, _wad);

        return true;

    }



    function transferWithFee(address _to, uint256 _wad) external returns (bool) {

        _transfer(msg.sender, _to, _wad);

        return true;

    }



    function transferFrom(address _from, address _to, uint256 _wad) external returns (bool) {

        _transfer(_from, _to, _wad);

        return true;

    }



    function transferFromWithFee(address _from, address _to, uint256 _wad) external returns (bool) {

        _transfer(_from, _to, _wad);

        return true;

    }



    function _mint(

        address _to,

        uint256 _wad

    ) internal {

        p_totalSupply = p_totalSupply.add(_wad);

        p_balance[_to] = p_balance[_to].add(_wad);



        emit Transfer(address(0), _to, _wad);

    }



    function _burn(

        address _from,

        uint256 _wad

    ) internal {

        uint256 balance = p_balance[_from];

        require(balance >= _wad, "erc20: burn _from balance is not enough");

        p_balance[_from] = balance.sub(_wad);

        p_totalSupply = p_totalSupply.sub(_wad);

        emit Transfer(_from, address(0), _wad);

    }



    function _transfer(

        address _from,

        address _to,

        uint256 _wad

    ) private {

        if (msg.sender != _from) {

            uint256 t_allowance = p_allowance[_from][msg.sender];

            if (t_allowance != uint(-1)) {

                require(t_allowance >= _wad, "erc20: sender allowance is not enough");

                p_allowance[_from][msg.sender] = t_allowance.sub(_wad);

            }

        }



        uint256 fromBalance = p_balance[_from];

        require(fromBalance >= _wad, "erc20: transfer _from balance is not enough");

        p_balance[_from] = fromBalance.sub(_wad);

        p_balance[_to] = p_balance[_to].add(_wad);



        emit Transfer(_from, _to, _wad);

    }

}



// File: contracts/utils/SafeDefERC20.sol



pragma solidity ^0.5.12;





library SafeDefERC20 {

    using SafeMath for uint256;



    function safeTransfer(

        IERC20 _token,

        address _to,

        uint256 _wad

    ) internal returns (uint256) {

        uint256 prev = _token.balanceOf(address(this));



        (bool success, ) = address(_token).call(

            abi.encodeWithSelector(

                _token.transfer.selector,

                _to,

                _wad

            )

        );



        require(success, "safedeferc20: error sending tokens");

        return prev.sub(_token.balanceOf(address(this)));

    }



    function safeTransferFrom(

        IERC20 _token,

        address _from,

        address _to,

        uint256 _wad

    ) internal returns (uint256) {

        uint256 prev = _token.balanceOf(_to);



        (bool success, ) = address(_token).call(

            abi.encodeWithSelector(

                _token.transferFrom.selector,

                _from,

                _to,

                _wad

            )

        );



        require(success, "safedeferc20: error pulling tokens");

        return _token.balanceOf(_to).sub(prev);

    }

}



// File: contracts/utils/ShufUtils.sol



pragma solidity ^0.5.12;





library ShufUtils {

    using SafeMath for uint256;



    function takeFee(uint256 _a) internal pure returns (uint256) {

        if (_a == 1) {

            return 0;

        }



        uint256 fee = _a / 100;

        if (_a % 100 != 0) {

            fee = fee + 1;

        }



        return _a - (fee * 2);

    }



    function untakeFee(uint256 _a) internal pure returns (uint256) {

        if (_a == 1) {

            return 3;

        }



        uint256 aux = _a / 49;

        if (aux % 2 == 0) {

            aux = _a.add(aux);

            if (aux % 100 == 0) {

                return aux;

            } else {

                return aux.add(2);

            }

        } else {

            return _a.add(aux).add(1);

        }

    }

}



// File: contracts/DefswapExchange.sol



pragma solidity ^0.5.12;





contract DefswapExchange is IDefswapExchange, ERC20, ReentrancyGuard {

    using SafeDefERC20 for IERC20;

    using SafeMath for uint256;



    IERC20 private p_base;

    IERC20 private p_token;

    IUniswapExchange private p_uniswap;



    string private constant SYMBOL_PREFIX = "SHUF-";

    string private constant NAME_SUFIX = " - defswap.io pooled";

    uint256 private constant DECIMALS = 18;



    event AddLiquidity(

        address indexed _provider,

        uint256 _baseAmount,

        uint256 _tokenAmount,

        uint256 _minted

    );



    event RemoveLiquidity(

        address indexed _provider,

        uint256 _baseAmount,

        uint256 _tokenAmount,

        uint256 _burned,

        uint256 _type

    );



    event TokenPurchase(

        address indexed _buyer,

        uint256 _baseSold,

        uint256 _tokensBought,

        uint256 _baseReserve,

        uint256 _tokenReserve,

        address _recipient

    );



    event BasePurchase(

        address indexed _buyer,

        uint256 _tokensSold,

        uint256 _baseBought,

        uint256 _tokenReserve,

        uint256 _baseReserve,

        address _recipient

    );



    constructor(IERC20 _base, IERC20 _token, IUniswapExchange _uniswap) public {

        require(_uniswap.tokenAddress() == address(_base), "defswap: uniswap token doesn't match");

        require(address(_base) != address(_token), "defswap: token and base can't be the same");



        p_base = _base;

        p_token = _token;

        p_uniswap = _uniswap;



        approveUniswap();

        buildMetadata();

    }



    function approveUniswap() public nonReentrant {

        p_base.approve(

            address(p_uniswap),

            uint(-1)

        );

    }



    function buildMetadata() public nonReentrant {

        address token = address(p_token);

        require(gasleft() >= 402000, "defswap: gasleft build metadata is not enough");



        (

            bool successName,

            bytes memory name

        ) = token.staticcall(

            abi.encodeWithSelector(p_token.name.selector)

        );



        (

            bool successSymbol,

            bytes memory symbol

        ) = token.staticcall(

            abi.encodeWithSelector(p_token.symbol.selector)

        );



        _setMetadata(

            string(abi.encodePacked(SYMBOL_PREFIX, successSymbol ? abi.decode(symbol, (string)) : "???")),

            string(abi.encodePacked(successName ? abi.decode(name, (string)) : "Unknown", NAME_SUFIX)),

            DECIMALS

        );

    }



    function base() external view returns (IERC20) {

        return p_base;

    }



    function token() external view returns (IERC20) {

        return p_token;

    }



    function uniswap() external view returns (IUniswapExchange) {

        return p_uniswap;

    }



    function addLiquidity(

        uint256 _tokens,

        uint256 _maxBase

    ) external nonReentrant returns (uint256 minted) {

        IERC20 t_token = p_token;

        IERC20 t_base = p_base;



        // Pull tokens and store them in pool

        // received stores the real amount of received tokens

        uint256 received = t_token.safeTransferFrom(msg.sender, address(this), _tokens);

        require(received != 0, "defswap: pull zero tokens is not allowed");



        uint256 baseReceived;

        uint256 t_totalSupply = p_totalSupply;



        // Check if this is the first pool

        if (t_totalSupply == 0) {

            // Pull all _maxBase and mint received

            require(t_base.transferFrom(msg.sender, address(this), _maxBase), "defswap: error pulling base tokens");

            baseReceived = ShufUtils.takeFee(_maxBase);

            minted = baseReceived;

        } else {

            // Calculate required pull, following current pool rate

            uint256 tokenReserve = t_token.balanceOf(address(this)).sub(received);

            uint256 baseReserve = t_base.balanceOf(address(this));

            uint256 requiredPull = received.mul(baseReserve).divRound(tokenReserve);



            // Pull tokens after untaking fee

            baseReceived = t_base.safeTransferFrom(msg.sender, address(this), ShufUtils.untakeFee(requiredPull));

            require(baseReceived <= _maxBase, "defswap: _maxBase is below of pulled required");

            require(baseReceived >= requiredPull, "defswap: pulled base is not enough");



            // Mint proportional tokens

            minted = baseReceived.mul(t_totalSupply).div(baseReserve);

        }



        // Mint tokens and event

        emit AddLiquidity(msg.sender, baseReceived, received, minted);

        _mint(msg.sender, minted);

    }



    function removeLiquidity(

        uint256 _amount,

        uint256 _minBase,

        uint256 _minTokens

    ) external nonReentrant returns (

        uint256 baseAmount,

        uint256 tokenAmount

    ) {

        // Load totalSupply and check that it's not zero

        uint256 t_totalSupply = p_totalSupply;

        require(t_totalSupply != 0, "defswap: pool is empty");



        // Load token contracts

        IERC20 t_token = p_token;

        IERC20 t_base = p_base;



        // Load token reserves

        uint256 tokenReserve = t_token.balanceOf(address(this));

        uint256 baseReserve = t_base.balanceOf(address(this));



        // Calculate base and tokens to withdraw

        baseAmount = _amount.mul(baseReserve) / t_totalSupply;

        tokenAmount = _amount.mul(tokenReserve) / t_totalSupply;



        // Emit event and remove burn tokens from sender

        emit RemoveLiquidity(msg.sender, baseAmount, tokenAmount, _amount, 0);

        _burn(msg.sender, _amount);



        // Check if taken base if above _minBase

        require(baseAmount >= _minBase, "defswap: baseAmount is below _minBase");



        // Transfer tokens and base

        require(t_token.safeTransfer(msg.sender, tokenAmount) >= _minTokens, "defswap: tokenAmount is below _minTokens");

        t_base.transferWithFee(msg.sender, baseAmount); // t_base is trusted

    }



    function removeBaseLiquidity(

        uint256 _amount,

        uint256 _minBase

    ) external nonReentrant returns (

        uint256 baseAmount

    ) {

        // Load totalSupply and check that it's not zero

        uint256 t_totalSupply = p_totalSupply;

        require(t_totalSupply != 0, "defswap: pool is empty");



        // Load token contract

        IERC20 t_base = p_base;



        // Load base reserve

        uint256 baseReserve = t_base.balanceOf(address(this));



        // Calculate base to withdraw

        baseAmount = _amount.mul(baseReserve) / t_totalSupply;



        // Burn tokens and emit event

        // it burns the full _amount

        emit RemoveLiquidity(msg.sender, baseAmount, 0, _amount, 1);

        _burn(msg.sender, _amount);



        // Check if withdraw base is above _minBase and transfer tokens

        require(baseAmount >= _minBase, "defswap: baseAmount is below _minBase");

        t_base.transferWithFee(msg.sender, baseAmount); // t_base is trusted

    }



    function removeTokenLiquidity(

        uint256 _amount,

        uint256 _minTokens

    ) external nonReentrant returns (

        uint256 tokenAmount

    ) {

        // Load totalSupply and check that it's not zero

        uint256 t_totalSupply = p_totalSupply;

        require(t_totalSupply != 0, "defswap: pool is empty");



        // Load token contract

        IERC20 t_token = p_token;



        // Load token reserve

        uint256 tokenReserve = t_token.balanceOf(address(this));



        // Calculate token to withdraw

        tokenAmount = _amount.mul(tokenReserve) / t_totalSupply;



        // Burn tokens and emit event

        // it burns the full _amount

        emit RemoveLiquidity(msg.sender, 0, tokenAmount, _amount, 2);

        _burn(msg.sender, _amount);



        // Transfer tokens and check if withdrawn amount is above _minTokens

        require(t_token.safeTransfer(msg.sender, tokenAmount) >= _minTokens, "defswap: tokenAmount is below _minTokens");

    }



    function getBaseToTokenPrice(uint256 _baseSold) external view returns (uint256 tokensBought) {

        tokensBought = _getInputPrice(

            _baseSold,

            p_base.balanceOf(address(this)),

            p_token.balanceOf(address(this))

        );

    }



    function getTokenToBasePrice(uint256 _tokenSold) external view returns (uint256 baseBought) {

        baseBought = _getInputPrice(

            _tokenSold,

            p_token.balanceOf(address(this)),

            p_base.balanceOf(address(this))

        );

    }



    function ethToTokenSwapInput(

        uint256 _minTokens

    ) external nonReentrant payable returns (uint256 bought) {

        // Trade ETH -> BASE, only if msg.value is not zero

        uint256 baseBought = msg.value != 0 ? ShufUtils.takeFee(

            p_uniswap.ethToTokenSwapInput.value(msg.value)(1, uint(-1))

        ) : 0;



        // Trade BASE -> TOKEN, and transfer to sender

        bought = _baseToToken(

            p_base,     // Base address

            p_token,    // Token address

            baseBought, // Base bought on trade ETH -> BASE

            _minTokens, // Min base to receive

            msg.sender, // Origin of the trade

            msg.sender  // Recipient of the tokens

        );

    }



    // Uniswap exchange compat

    function ethToTokenTransferInput(

        uint256 _minTokens,

        uint256 _deadline,

        address _recipient

    ) external nonReentrant payable returns (uint256 bought) {

        // Check if _deadile was exceeded

        require(_deadline >= block.timestamp, "defswap: expired transaction");



        // Trade ETH -> BASE, only if msg.value is not zero

        uint256 baseBought = msg.value != 0 ? ShufUtils.takeFee(

            p_uniswap.ethToTokenSwapInput.value(msg.value)(1, uint(-1))

        ) : 0;



        // Trade BASE -> TOKEN, and transfer to _recipient

        bought = _baseToToken(

            p_base,     // Base address

            p_token,    // Token address

            baseBought, // Base bought on trade ETH -> BASE

            _minTokens, // Min base to receive

            msg.sender, // Origin of the trade

            _recipient  // Recipient of the tokens

        );

    }



    function baseToTokenSwapInput(

        uint256 _amount,

        uint256 _minTokens

    ) external nonReentrant returns (uint256 bought) {

        // Load base contract

        IERC20 t_base = p_base;



        // Transfer base from msg.sender to this

        t_base.transferFromWithFee(msg.sender, address(this), _amount);

        // real received has to take into account the transfer fee

        uint256 received = ShufUtils.takeFee(_amount);



        // Trade BASE -> TOKEN, and transfer to msg.sender

        bought = _baseToToken(

            t_base,     // Base address (already loaded)

            p_token,    // Token address

            received,   // Base received from msg.sender

            _minTokens, // Min tokens to buy

            msg.sender, // Origin of the trade

            msg.sender  // Recipient of the tokens

        );

    }



    function baseToTokenTransferInput(

        uint256 _amount,

        uint256 _minTokens,

        address _recipient

    ) external nonReentrant returns (uint256 bought) {

        // Load base contract

        IERC20 t_base = p_base;



        // Transfer base from msg.sender to this

        t_base.transferFromWithFee(msg.sender, address(this), _amount);

        // real received has to take into account the transfer fee

        uint256 received = ShufUtils.takeFee(_amount);



        // Trade BASE -> TOKEN, and transfer to msg.sender

        bought = _baseToToken(

            t_base,     // Base address (already loaded)

            p_token,    // Token address

            received,   // Base received from msg.sender

            _minTokens, // Min tokens to buy

            msg.sender, // Origin of the trade

            _recipient  // Recipient of the tokens

        );

    }



    function tokenToEthSwapInput(

        uint256 _amount,

        uint256 _minEth

    ) external nonReentrant returns (uint256 bought) {

        // Load token contract from storage

        IERC20 t_token = p_token;



        // Transfer tokens from sender to this

        // and store the real amount of received tokens

        uint256 received = t_token.safeTransferFrom(msg.sender, address(this), _amount);



        // Convert TOKEN -> BASE and send base to this

        // to later be converted into ETH

        uint256 baseBought = ShufUtils.takeFee(

            _tokenToBase(

                p_base,       // Base address (already loaded)

                t_token,      // Token address (already loaded)

                received,     // Received tokens from msg.sender

                0,            // Min base to buy (zero, will check the final result)

                msg.sender,   // Origin of the trade

                address(this) // Recipent of the base (self)

            )

        );



        // Convert BASE -> ETH if baseBought is not zero

        bought = baseBought != 0 ? p_uniswap.tokenToEthTransferInput(

            baseBought, // Base amount to convert

            1,          // Min ETH to buy (1, will check later using require)

            uint(-1),   // Trade expiration (never)

            msg.sender  // Recipent of the ETH

        ) : 0;



        // Check if bought ETH is above _minEth

        require(bought >= _minEth, "defswap: eth bought is below _minEth");

    }



    function tokenToEthTransferInput(

        uint256 _amount,

        uint256 _minEth,

        address _recipient

    ) external nonReentrant returns (uint256 bought) {

        // Load token contract from storage

        IERC20 t_token = p_token;



        // Transfer tokens from sender to this

        // and store the real amount of received tokens

        uint256 received = t_token.safeTransferFrom(msg.sender, address(this), _amount);



        // Convert TOKEN -> BASE and send base to this

        // to later be converted into ETH

        uint256 baseBought = ShufUtils.takeFee(

            _tokenToBase(

                p_base,       // Base address (already loaded)

                t_token,      // Token address (already loaded)

                received,     // Received tokens from msg.sender

                0,            // Min base to buy (zero, will check the final result)

                msg.sender,   // Origin of the trade

                address(this) // Recipent of the base (self)

            )

        );



        // Convert BASE -> ETH if baseBought is not zero

        bought = baseBought != 0 ? p_uniswap.tokenToEthTransferInput(

            baseBought, // Base amount to convert

            1,          // Min ETH to buy (1, will check later using require)

            uint(-1),   // Trade expiration (never)

            _recipient  // Recipent of the ETH

        ) : 0;



        // Check if bought ETH is above _minEth

        require(bought >= _minEth, "defswap: eth bought is below _minEth");

    }



    function tokenToEthExchangeTransferInput(

        uint256 _amount,

        uint256 _minTokens,

        address _recipient,

        address _exchangeAddr

    ) external nonReentrant returns (uint256 bought) {

        // Load token contract from storage

        IERC20 t_token = p_token;



        // Transfer tokens from sender to this

        // and store the real amount of received tokens

        uint256 received = t_token.safeTransferFrom(msg.sender, address(this), _amount);



        // Convert TOKEN -> BASE and send base to this

        // to later be converted into ETH

        uint256 baseBought = ShufUtils.takeFee(

            _tokenToBase(

                p_base,       // Base address (already loaded)

                t_token,      // Token address (already loaded)

                received,     // Received tokens from msg.sender

                0,            // Min base to buy (zero, will check the final result)

                msg.sender,   // Origin of the trade

                address(this) // Recipent of the base (self)

            )

        );



        // Convert BASE -> ETH if baseBought is not zero

        // and transfer to self

        uint256 ethBought = baseBought != 0 ? p_uniswap.tokenToEthSwapInput(

            baseBought, // Base amount to sell

            1,          // Min ETH to buy (1, will be check later)

            uint(-1)    // Trade expiration (never)

        ) : 0;



        // Convert ETH -> TOKEN if ethBought is not zero

        bought = ethBought != 0 ? IUniswapExchange(_exchangeAddr).ethToTokenTransferInput.value(

            ethBought   // ETH to sell

        )(

            1,          // Min token buy (1, will check later)

            uint(-1),   // Trade expiration (never)

            _recipient  // Recipient of the tokens

        ) : 0;



        // Check if bought tokens is above _minTokens

        // _exchangeAddr is considered trusted and it may never have transfered

        // the ETH to the _recipient, this code trusts the return value of _exchangeAddr.ethToTokenTransferInput

        require(bought >= _minTokens, "defswap: tokens bought is below _minTokens");

    }



    function tokenToBaseSwapInput(

        uint256 _amount,

        uint256 _minBase

    ) external nonReentrant returns (uint256 bought) {

        // Load token contract from storage

        IERC20 t_token = p_token;



        // Transfer tokens from sender to this

        // and store the real amount of received tokens

        uint256 received = t_token.safeTransferFrom(msg.sender, address(this), _amount);



        // Convert TOKEN -> BASE and send base to msg.sender

        bought = _tokenToBase(

            p_base,     // Base address (already loaded)

            t_token,    // Token address (already loaded)

            received,   // Tokens to sell (received from msg.sender)

            _minBase,   // Min base to buy

            msg.sender, // Origin of the trade

            msg.sender  // Recipient of the base

        );

    }



    function tokenToBaseTransferInput(

        uint256 _amount,

        uint256 _minBase,

        address _recipient

    ) external nonReentrant returns (uint256 bought) {

        // Load token contract from storage

        IERC20 t_token = p_token;



        // Transfer tokens from sender to this

        // and store the real amount of received tokens

        uint256 received = t_token.safeTransferFrom(msg.sender, address(this), _amount);



        // Convert TOKEN -> BASE and send base to _recipient

        bought = _tokenToBase(

            p_base,     // Base address (already loaded)

            t_token,    // Token address (already loaded)

            received,   // Tokens to sell (received from msg.sender)

            _minBase,   // Min base to buy

            msg.sender, // Origin of the trade

            _recipient  // Recipient of the base

        );

    }



    function tokenToBaseExchangeTransferInput(

        uint256 _amount,

        uint256 _minTokens,

        address _recipient,

        address _exchangeAddr

    ) external nonReentrant returns (uint256 bought) {

        // _exchangeAddr can't be uniswap

        // because that would remove the Uniswap approve made during the exchange creation

        require(_exchangeAddr != address(p_uniswap), "defswap: _exchange can't be Uniswap");



        // Load contracts from storage

        IERC20 t_token = p_token;

        IERC20 t_base = p_base;



        // Transfer tokens from sender to this

        // and store the real amount of received tokens

        uint256 received = t_token.safeTransferFrom(msg.sender, address(this), _amount);



        // Load token and base reserves

        uint256 tokenReserve = t_token.balanceOf(address(this)).sub(received);

        uint256 baseReserve = t_base.balanceOf(address(this));



        // Calculate baseBought, the trade it's not executed to avoid charging the transfer fee twice

        // this represents TOKEN_A -> BASE

        uint256 baseBought = _getInputPrice(received, tokenReserve, baseReserve);

        emit BasePurchase(msg.sender, received, baseBought, tokenReserve, baseReserve, _exchangeAddr);



        // Trade BASE -> TOKEN_B, using base baseBought with TOKEN_A

        // the exchange is approve to withdraw `baseBought` and the approve is removed after

        // the trade, _exchangeAddr can't exploit the temporal reserve ratio because of the reentrancy lock

        t_base.approve(_exchangeAddr, baseBought);

        bought = IDefswapExchange(_exchangeAddr).baseToTokenTransferInput(

            baseBought, // BASE tokens to sell

            _minTokens, // Min TOKEN_B to buy

            _recipient  // Recipeint of token b

        );



        // Always remove the approve after the trade

        t_base.approve(_exchangeAddr, 0);

    }



    function _getInputPrice(

        uint256 _inputAmount,

        uint256 _inputReserve,

        uint256 _outputReserve

    ) private pure returns (uint256) {

        require(_inputReserve != 0 && _outputReserve != 0, "defswap: one reserve is empty");

        uint256 inputAmountWithFee = _inputAmount.mul(997);

        uint256 numerator = inputAmountWithFee.mul(_outputReserve);

        uint256 denominator = _inputReserve.mul(1000).add(inputAmountWithFee);

        return numerator / denominator;

    }



    function _baseToToken(

        IERC20 t_base,

        IERC20 t_token,

        uint256 _amount,

        uint256 _minTokens,

        address _buyer,

        address _recipient

    ) private returns (uint256 tokensBought) {

        // Load base and token reserves

        uint256 tokenReserve = t_token.balanceOf(address(this));

        uint256 baseReserve = t_base.balanceOf(address(this)).sub(_amount);



        // Calculate tokens bought

        tokensBought = _getInputPrice(_amount, baseReserve, tokenReserve);



        // Check if tokens bought is above _minTokens and execute transfer

        require(tokensBought >= _minTokens, "defswap: bought tokens below _minTokens");

        require(t_token.safeTransfer(_recipient, tokensBought) != 0 || tokensBought == 0, "defswap: error sending tokens");



        emit TokenPurchase(_buyer, _amount, tokensBought, baseReserve, tokenReserve, _recipient);

    }



    function _tokenToBase(

        IERC20 t_base,

        IERC20 t_token,

        uint256 _amount,

        uint256 _minBase,

        address _buyer,

        address _recipient

    ) private returns (uint256 baseBought) {

        // Load base and token reserves

        uint256 tokenReserve = t_token.balanceOf(address(this)).sub(_amount);

        uint256 baseReserve = t_base.balanceOf(address(this));



        // Calculate base bought

        baseBought = _getInputPrice(_amount, tokenReserve, baseReserve);



        // Check if base bought is above _minBase and execute transfer

        require(baseBought >= _minBase, "defswap: bought base below _minBase");

        t_base.transferWithFee(_recipient, baseBought);



        emit BasePurchase(_buyer, _amount, baseBought, tokenReserve, baseReserve, _recipient);

    }



    function() external payable {

        // Revert if an EOA send's ETH

        require(msg.sender != tx.origin, "defswap: ETH rejected");

    }

}



// File: contracts/DefswapFactory.sol



pragma solidity ^0.5.12;





contract DefswapFactory {

    using IsContract for address;



    IUniswapExchange public uniswap;

    IERC20 public base;



    event CreatedExchange(address indexed _token, address indexed _exchange);



    address[] private p_tokens;

    mapping(address => address) public tokenToExchange;

    mapping(address => address) public exchangeToToken;



    constructor(IERC20 _base, IUniswapExchange _uniswap) public {

        require(_uniswap.tokenAddress() == address(_base), "defswap-factory: uniswap token doesn't match");



        base = _base;

        uniswap = _uniswap;

    }



    function getToken(uint256 _i) external view returns (address) {

        require(_i < p_tokens.length, "defswap-factory: array out of bounds");

        return p_tokens[_i];

    }



    function getExchange(uint256 _i) external view returns (address) {

        require(_i < p_tokens.length, "defswap-factory: array out of bounds");

        return tokenToExchange[p_tokens[_i]];

    }



    function createExchange(address _token) external returns (address exchange) {

        require(tokenToExchange[_token] == address(0), "defswap-factory: exchange already exists");

        require(_token.isContract(), "defswap-factory: _token has to be a contract");



        exchange = address(

            new DefswapExchange(

                base,

                IERC20(_token),

                uniswap

            )

        );



        emit CreatedExchange(_token, exchange);



        tokenToExchange[_token] = exchange;

        exchangeToToken[exchange] = _token;

        p_tokens.push(_token);

    }

}