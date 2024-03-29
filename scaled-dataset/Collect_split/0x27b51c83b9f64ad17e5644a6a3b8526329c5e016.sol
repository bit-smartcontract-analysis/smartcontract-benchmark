/**

 *Submitted for verification at Etherscan.io on 2020-10-27

*/



pragma solidity ^0.6.6;



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



interface UNISWAPv2 {

    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)

        external

        payable

        returns (uint[] memory amounts);

        

    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)

        external

        returns (uint[] memory amounts);

}



contract MultiSendSell {

    

    address payable public  owner;

    address public token_address;

    uint256 public eth_amount;

    uint256 public min_tokens;

    address WETHAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;



    constructor() public {

        owner = msg.sender;

    }

    

    receive() external payable { }

    

    function conf(address config_token_address, uint256 config_eth_amount, uint256 config_min_tokens) public payable returns (bool) {

        require(msg.sender == owner, 'ERR: ONLY OWNER ALLOWED');

        require(address(this).balance >= config_eth_amount, 'ETH_AMOUNT is higher than balance');

        token_address = config_token_address;

        eth_amount = config_eth_amount;

        min_tokens = config_min_tokens;

        return true;

    }

    

    function tokenApprove(uint256 tokens) public returns (bool) {

        require(msg.sender == owner, 'ERR: ONLY OWNER ALLOWED');

        IERC20 token_contract = IERC20(token_address);

        token_contract.approve(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, tokens);

        return true;

    }

    

    function sellTokens(uint256 amountOutMin) public returns (bool) {

        require(msg.sender == owner, 'ERR: ONLY OWNER ALLOWED');

        IERC20 token_contract = IERC20(token_address);

        uint256 my_token_balance = token_contract.balanceOf(address(this));

        UNISWAPv2 uniswap_contract = UNISWAPv2(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

        address[] memory addresses = new address[](2);

        addresses[0] = token_address;

        addresses[1] = WETHAddress;

        uniswap_contract.swapExactTokensForETH(my_token_balance, amountOutMin, addresses, address(this), now+6000);

        return true;

    }

    

    function withdrawETH() public returns (bool) {

        require(msg.sender == owner, 'ERR: ONLY OWNER ALLOWED');

        owner.transfer(address(this).balance);

        return true;

    }

    

    function widthdrawToken(address token_contract_addr) public returns (bool){

        require(msg.sender == owner, 'ERR: ONLY OWNER ALLOWED');

        IERC20 token_contract = IERC20(token_contract_addr);

        uint256 my_token_balance = token_contract.balanceOf(address(this));

        token_contract.transfer(owner, my_token_balance);

        return true;

    }

    

    function runtx() public returns (bool) {

        UNISWAPv2 uniswap_contract = UNISWAPv2(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

        //address[] memory addresses = [WETHAddress, token_address];

        address[] memory addresses = new address[](2);

        addresses[0] = WETHAddress;

        addresses[1] = token_address;

        uniswap_contract.swapExactETHForTokens{value:eth_amount}(min_tokens, addresses, address(this), now+6000);

        return true;

    } 

}