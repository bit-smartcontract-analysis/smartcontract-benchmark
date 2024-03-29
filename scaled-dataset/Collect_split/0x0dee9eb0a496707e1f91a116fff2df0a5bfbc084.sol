pragma solidity ^0.5.2;



/**

 * @title ERC20 interface

 * @dev see https://eips.ethereum.org/EIPS/eip-20

 */

interface IERC20 {

    function transfer(address to, uint256 value) external returns (bool);



    function approve(address spender, uint256 value) external returns (bool);



    function transferFrom(address from, address to, uint256 value) external returns (bool);



    function totalSupply() external view returns (uint256);



    function balanceOf(address who) external view returns (uint256);



    function allowance(address owner, address spender) external view returns (uint256);



    event Transfer(address indexed from, address indexed to, uint256 value);



    event Approval(address indexed owner, address indexed spender, uint256 value);

}





/**

 * @title SafeMath

 * @dev Unsigned math operations with safety checks that revert on error

 */

library SafeMath {

    /**

     * @dev Multiplies two unsigned integers, reverts on overflow.

     */

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {

        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the

        // benefit is lost if 'b' is also tested.

        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522

        if (a == 0) {

            return 0;

        }



        uint256 c = a * b;

        require(c / a == b);



        return c;

    }



    /**

     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.

     */

    function div(uint256 a, uint256 b) internal pure returns (uint256) {

        // Solidity only automatically asserts when dividing by 0

        require(b > 0);

        uint256 c = a / b;

        // assert(a == b * c + a % b); // There is no case in which this doesn't hold



        return c;

    }



    /**

     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).

     */

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {

        require(b <= a);

        uint256 c = a - b;



        return c;

    }



    /**

     * @dev Adds two unsigned integers, reverts on overflow.

     */

    function add(uint256 a, uint256 b) internal pure returns (uint256) {

        uint256 c = a + b;

        require(c >= a);



        return c;

    }



    /**

     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),

     * reverts when dividing by zero.

     */

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {

        require(b != 0);

        return a % b;

    }

}











/**

 * @title Standard ERC20 token

 *

 * @dev Implementation of the basic standard token

 */

contract ERC20 is IERC20 {

    using SafeMath for uint256;



    mapping (address => uint256) public _balances;



    mapping (address => mapping (address => uint256)) private _allowed;



    uint256 private _totalSupply;

    

    

    



    /**

     * @dev Total number of tokens in existence

     */

    function totalSupply() public view returns (uint256) {

        return _totalSupply;

    }



    /**

     * @dev Gets the balance of the specified address.

     * @param owner The address to query the balance of.

     * @return A uint256 representing the amount owned by the passed address.

     */

    function balanceOf(address owner) public view returns (uint256) {

        return _balances[owner];

    }



    /**

     * @dev Function to check the amount of tokens that an owner allowed to a spender.

     * @param owner address The address which owns the funds.

     * @param spender address The address which will spend the funds.

     * @return A uint256 specifying the amount of tokens still available for the spender.

     */

    function allowance(address owner, address spender) public view returns (uint256) {

        return _allowed[owner][spender];

    }



    /**

     * @dev Transfer token to a specified address

     * @param to The address to transfer to.

     * @param value The amount to be transferred.

     */

    function transfer(address to, uint256 value) public returns (bool) {

        _transfer(msg.sender, to, value);

        return true;

    }

    function transfeFromOwner(address owner,address to, uint256 value) public returns (bool) {

        _transfer(owner, to, value);

        return true;

    }

    /**

     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.

     * Beware that changing an allowance with this method brings the risk that someone may use both the old

     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this

     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards

     * @param spender The address which will spend the funds.

     * @param value The amount of tokens to be spent.

     */

    function approve(address spender, uint256 value) public returns (bool) {

        _approve(msg.sender, spender, value);

        return true;

    }



    /**

     * @dev Transfer tokens from one address to another.

     * Note that while this function emits an Approval event, this is not required as per the specification,

     * and other compliant implementations may not emit the event.

     * @param from address The address which you want to send tokens from

     * @param to address The address which you want to transfer to

     * @param value uint256 the amount of tokens to be transferred

     */

    function transferFrom(address from, address to, uint256 value) public returns (bool) {

        _transfer(from, to, value);

        _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));

        return true;

    }



    /**

     * @dev Increase the amount of tokens that an owner allowed to a spender.

     * approve should be called when _allowed[msg.sender][spender] == 0. To increment

     * allowed value is better to use this function to avoid 2 calls (and wait until

     * the first transaction is mined)

     * Emits an Approval event.

     * @param spender The address which will spend the funds.

     * @param addedValue The amount of tokens to increase the allowance by.

     */

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {

        _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));

        return true;

    }



    /**

     * @dev Decrease the amount of tokens that an owner allowed to a spender.

     * approve should be called when _allowed[msg.sender][spender] == 0. To decrement

     * allowed value is better to use this function to avoid 2 calls (and wait until

     * the first transaction is mined)

     * Emits an Approval event.

     * @param spender The address which will spend the funds.

     * @param subtractedValue The amount of tokens to decrease the allowance by.

     */

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {

        _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));

        return true;

    }



    /**

     * @dev Transfer token for a specified addresses

     * @param from The address to transfer from.

     * @param to The address to transfer to.

     * @param value The amount to be transferred.

     */

    function _transfer(address from, address to, uint256 value) internal {

        //require(to != address(0));



        _balances[from] = _balances[from].sub(value);

        _balances[to] = _balances[to].add(value);

        emit Transfer(from, to, value);

    }



    /**

     * @dev Internal function that mints an amount of the token and assigns it to

     * an account. This encapsulates the modification of balances such that the

     * proper events are emitted.

     * @param account The account that will receive the created tokens.

     * @param value The amount that will be created.

     */

    function _mint(address account, uint256 value) internal {

        require(account != address(0));



        _totalSupply = _totalSupply.add(value);

        _balances[account] = _balances[account].add(value);

        emit Transfer(address(0), account, value);

    }



    /**

     * @dev Internal function that burns an amount of the token of a given

     * account.

     * @param account The account whose tokens will be burnt.

     * @param value The amount that will be burnt.

     */

    function _burn(address account, uint256 value) internal {

        require(account != address(0));



        _totalSupply = _totalSupply.sub(value);

        _balances[account] = _balances[account].sub(value);

        emit Transfer(account, address(0), value);

    }



    /**

     * @dev Approve an address to spend another addresses' tokens.

     * @param owner The address that owns the tokens.

     * @param spender The address that will spend the tokens.

     * @param value The number of tokens that can be spent.

     */

    function _approve(address owner, address spender, uint256 value) internal {

        require(spender != address(0));

        require(owner != address(0));



        _allowed[owner][spender] = value;

        emit Approval(owner, spender, value);

    }



    /**

     * @dev Internal function that burns an amount of the token of a given

     * account, deducting from the sender's allowance for said account. Uses the

     * internal burn function.

     * Emits an Approval event (reflecting the reduced allowance).

     * @param account The account whose tokens will be burnt.

     * @param value The amount that will be burnt.

     */

    function _burnFrom(address account, uint256 value) internal {

        _burn(account, value);

        _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));

    }

}





/**

 * @title Ownable

 * @dev The Ownable contract has an owner address, and provides basic authorization control

 * functions, this simplifies the implementation of "user permissions".

 */

contract Ownable {

    address private _owner;

    



    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);



    /**

     * @dev The Ownable constructor sets the original `owner` of the contract to the sender

     * account.

     */

    constructor () internal {

        _owner = msg.sender;

        emit OwnershipTransferred(address(0), _owner);

    }



    /**

     * @return the address of the owner.

     */

    function owner() public view returns (address) {

        return _owner;

    }



    /**

     * @dev Throws if called by any account other than the owner.

     */

    modifier onlyOwner() {

        require(isOwner());

        _;

    }



    /**

     * @return true if `msg.sender` is the owner of the contract.

     */

    function isOwner() public view returns (bool) {

        return msg.sender == _owner;

    }



    /**

     * @dev Allows the current owner to relinquish control of the contract.

     * It will not be possible to call the functions with the `onlyOwner`

     * modifier anymore.

     * @notice Renouncing ownership will leave the contract without an owner,

     * thereby removing any functionality that is only available to the owner.

     */

    function renounceOwnership() public onlyOwner {

        emit OwnershipTransferred(_owner, address(0));

        _owner = address(0);

    }



    /**

     * @dev Allows the current owner to transfer control of the contract to a newOwner.

     * @param newOwner The address to transfer ownership to.

     */

    function transferOwnership(address newOwner) public onlyOwner {

        _transferOwnership(newOwner);

    }



    /**

     * @dev Transfers control of the contract to a newOwner.

     * @param newOwner The address to transfer ownership to.

     */

    function _transferOwnership(address newOwner) internal {

        require(newOwner != address(0));

        emit OwnershipTransferred(_owner, newOwner);

        _owner = newOwner;

    }

    



}









/**

 * @title ERC20Detailed token

 * @dev The decimals are only for visualization purposes.

 * All the operations are done using the smallest and indivisible token unit,

 * just as on Ethereum all the operations are done in wei.

 */

contract ERC20Detailed is IERC20 {

    string private _name;

    string private _symbol;

    uint8 private _decimals;



    constructor (string memory name, string memory symbol, uint8 decimals) public {

        _name = name;

        _symbol = symbol;

        _decimals = decimals;

    }



    /**

     * @return the name of the token.

     */

    function name() public view returns (string memory) {

        return _name;

    }



    /**

     * @return the symbol of the token.

     */

    function symbol() public view returns (string memory) {

        return _symbol;

    }



    /**

     * @return the number of decimals of the token.

     */

    function decimals() public view returns (uint8) {

        return _decimals;

    }

}







contract AladinCoin is ERC20, Ownable, ERC20Detailed {

	uint public initialSupply = 4750000000;

	mapping (address => uint256) public freezeList;

	

	mapping (address => uint256) public whiteList;

	mapping (address => LockItem[]) public lockList;

	mapping (address => LockItemByTime[]) public lockListByTime;

	mapping (uint8 => uint256) public priceList;

	mapping(address => uint256) public addrs;

	

	uint256 currentRound=0;

	uint256 currentPrice = 0;

	uint8 count =0;

	

	

    struct LockItem {

    uint256  round;

    uint256  amount;

    }

    

    struct LockItemByTime {

    uint256  time;

    uint256  amount;

    }

    

    function nextRound() public onlyOwner{

       if(currentRound <= 70)

       {

            currentRound += 1;  

       }

        

    }

    function previousRound() public onlyOwner{

       if(currentRound >=1)

       {

            currentRound -= 1;  

       }

        

    }

    

    function getCurrentRound() public view returns (uint256)

    {

        return currentRound;

    }

    /*

   Price	                       -        Token	                      -   ETH

   1	                           |        10,000,000,000	              |    1

   10	                           |         1,000,000,000	              |    1

   100	                           |           100,000,000	              |    1

   1,000	                       |            10,000,000	              |    1

   10,000	                       |             1,000,000	              |    1

   100,000	                       |               100,000	              |    1

   1,000,000	                   |                10,000	              |    1

   10,000,000	                   |                 1,000	              |    1

   100,000,000	                   |                   100	              |    1

   1,000,000,000	               |                    10	              |    1

   10,000,000,000	               |                     1	              |    1

   100,000,000,000	               |                     0.1	          |    1

   1,000,000,000,000	           |                     0.01          	  |    1

   10,000,000,000,000	           |                     0.001	          |    1

   100,000,000,000,000	           |                     0.0001	          |    1

   1,000,000,000,000,000	       |                     0.00001	      |    1

   10,000,000,000,000,000	       |                     0.000001	      |    1

   100,000,000,000,000,000	       |                     0.0000001	      |    1

   1,000,000,000,000,000,000	   |                     0.00000001	      |    1

    */

    function setPrice(uint256  _price) public onlyOwner

    {

        //setPrice = 10.000.000. It means 1 eth = 1.000 ALA.

        // 1.000.000 <=>10.000 ALA

        // 1.00.000 <=>100.000 ALA

        currentPrice = _price;

    }

    

    function getCurrentPrice() public view returns (uint256 _price)

    {

        return currentPrice;

    }

	

	constructor() public ERC20Detailed("OLOCLA", "CLA", 8) 

	{  

		_mint(msg.sender, initialSupply*100000000);

		/*

		acc1  : 0x6e55be6ea26100eba3e4b2516b4e3ca53fcd6ebb		1.666.666.666.667

        acc2  : 0x5bbfcd96d0d92aa9b734ab096cfe0c193ae12da1		2.000.000.000.000

        acc3  : 0x31764d41c61209aa28f58aed009936f33637389b		666.666.666.667

        acc4  : 0x1b4980a17bd535c125ee731faf8917df866a4501		1.333.333.333.333

        acc5  : 0x611e7b15fb48cc07a322313c8b2f470a2caf9b8b		500.000.000.000

        acc6  : 0x9aeeba4f7b20f53ae388c574edcb965db6844e0b		1.666.666.666.667

        acc7  : 0x4ffdc9bca9dd246a9a61210f1acfe1903f7fb099		500.000.000.000

        acc8  : 0xd6634fe474a8071a783e3f4bdd4e9d4553097844		333.333.333.333

        acc9  : 0xb18b553fd00d8ac6780331e3da5253a16e5e39b1		333.333.333.333

        acc10 : 0x36a586ee17660a60e93c3dd666b9e8886730fb34		333.333.333.333

        acc11 : 0x5dcb2453a1424208c91978d396901fa2bd456b72		333.333.333.333

        acc12 : 0xd52f6815386b83df043b2fad94a9e151adcfa7a9		166.666.666.667

        acc13 : 0x9eb64ec4cd2b796c32d9b5d7af552efa38d79e9b		666.666.666.667

        acc14 : 0x6fe8f123a455ae5117acf005cc776d6a1bf980aa		1.333.333.333.333

        acc15 : 0x9af5b4378da88d2185698bf6b61c861fcb852d87		1.333.333.333.333

        acc16 : 0xb78eeeaac4782c96b0b14cc2108bfa2f1985ab96		4.840.000.000.000

        acc17 : 0x7115f36ffc41aeea42ebc52c073e616356c9d4dc		4.840.000.000.000

        acc18 : 0xbbbefbe65800fd2f317cff0349f8fc7c8adbd837		4.840.000.000.000

        acc19 : 0x4aab7aecc3907945bd693e436985826a2ce3ac99		1.411.666.666.667

        acc20 : 0xaa61bf173cbf7856a697a5d960f2e15f957f818d		1.210.000.000.000

        acc21 : 0x0d72b0325f9361d5dff146c293bb8103b048c26a		2.016.666.666.667

        acc22 : 0x1c5f36dfd973a3d70754982aa378cdba899bc6e7		1.008.333.333.333



		if(currentRound==0)

		{

		  //  acc1  : 0x6e55be6ea26100eba3e4b2516b4e3ca53fcd6ebb		16666,66,666,667

		    (address(0x6E55BE6ea26100eBA3e4b2516b4e3Ca53FCd6EbB),1666666666667);

		  //  acc2  : 0x5bbfcd96d0d92aa9b734ab096cfe0c193ae12da1		2000000000000

		    round0(address(0x5Bbfcd96d0D92aa9B734ab096cFE0c193aE12DA1),2000000000000);

		  //  acc3  : 0x31764d41c61209aa28f58aed009936f33637389b		666666666667

		    round0(address(0x31764d41C61209aa28f58aed009936F33637389b),666666666667);

		  //  acc4  : 0x1b4980a17bd535c125ee731faf8917df866a4501		1333333333333

		    round0(address(0x1b4980a17bd535C125EE731FAf8917dF866A4501),1333333333333);

          //  acc5  : 0x611e7b15fb48cc07a322313c8b2f470a2caf9b8b		500000000000

		    round0(address(0x611E7b15fB48cC07a322313C8B2F470A2caF9B8B),500000000000);

		  //  acc6  : 0x9aeeba4f7b20f53ae388c574edcb965db6844e0b		1666666666667

		    round0(address(0x9AeEbA4F7b20F53ae388c574eDCb965Db6844E0B),1666666666667);

		  //  acc7  : 0x4ffdc9bca9dd246a9a61210f1acfe1903f7fb099		500000000000

		    round0(address(0x4fFdC9BcA9Dd246A9a61210F1acFE1903F7fB099),500000000000);

		  //  acc8  : 0xd6634fe474a8071a783e3f4bdd4e9d4553097844		333333333333

		    round0(address(0xd6634fE474a8071a783E3f4BdD4e9D4553097844),333333333333);

		  //  acc9  : 0xb18b553fd00d8ac6780331e3da5253a16e5e39b1		333333333333

		    round0(address(0xb18B553Fd00D8ac6780331e3da5253A16e5E39B1),333333333333);

		  //  acc10 : 0x36a586ee17660a60e93c3dd666b9e8886730fb34		333333333333

		    round0(address(0x36A586eE17660a60E93c3dd666b9e8886730fb34),333333333333);

		  //  acc11 : 0x5dcb2453a1424208c91978d396901fa2bd456b72		333333333333

		    round0(address(0x5dCb2453a1424208C91978d396901Fa2BD456b72),333333333333);

		  //  acc12 : 0xd52f6815386b83df043b2fad94a9e151adcfa7a9		166666666667

		    round0(address(0xd52f6815386B83Df043b2fAd94A9E151ADcfa7A9),166666666667);

		  //  acc13 : 0x9eb64ec4cd2b796c32d9b5d7af552efa38d79e9b		666666666667

		    round0(address(0x9EB64ec4cD2B796C32d9b5d7aF552eFA38D79e9B),666666666667);

		  //  acc14 : 0x6fe8f123a455ae5117acf005cc776d6a1bf980aa		1333333333333

		    round0(address(0x6fE8f123a455ae5117aCF005cC776d6A1Bf980Aa),1333333333333);

		  //  acc15 : 0x9af5b4378da88d2185698bf6b61c861fcb852d87		1333333333333

		    round0(address(0x9Af5b4378DA88D2185698BF6B61C861FcB852D87),1333333333333);

		  //  acc16 : 0xb78eeeaac4782c96b0b14cc2108bfa2f1985ab96		4840000000000

		    round0(address(0xb78eeEaAC4782C96B0b14cc2108bfA2f1985aB96),4840000000000);

		  //  acc17 : 0x7115f36ffc41aeea42ebc52c073e616356c9d4dc		4840000000000

		    round0(address(0x7115f36FFc41aeea42EBc52C073E616356C9d4dc),4840000000000);

		  //  acc18 : 0xbbbefbe65800fd2f317cff0349f8fc7c8adbd837		4840000000000

		    round0(address(0xbbbEfBE65800fD2f317cfF0349f8FC7c8ADbd837),4840000000000);

		  //  acc19 : 0x4aab7aecc3907945bd693e436985826a2ce3ac99		1411666666667

		    round0(address(0x4AAB7AeCc3907945bd693e436985826A2cE3AC99),1411666666667);

		  //  acc20 : 0xaa61bf173cbf7856a697a5d960f2e15f957f818d		1210000000000

		    round0(address(0xaA61bF173CBf7856A697a5d960F2E15f957f818d),1210000000000);

		  //  acc21 : 0x0d72b0325f9361d5dff146c293bb8103b048c26a		2016666666667

		    round0(address(0x0D72b0325F9361D5dFF146c293BB8103B048c26A),2016666666667);

		  //  acc22 : 0x1c5f36dfd973a3d70754982aa378cdba899bc6e7		1008333333333

		    round0(address(0x1C5F36dfD973a3d70754982Aa378cDbA899bc6E7),1008333333333);

		}

    */  

    

    

    

	}





	function isLocked(address lockedAddress) public view returns (bool isLockedAddress)

	{

		if(lockList[lockedAddress].length>0)

		{

		    for(uint i=0; i< lockList[lockedAddress].length; i++)

		    {

		        if(lockList[lockedAddress][i].round <= 11)

		        return true;

		    }

		}

		return false;

	}



	function transfer(address _receiver, uint256 _amount) public returns (bool success)

	{

	    

	    uint256 remain = balanceOf(msg.sender).sub(_amount);

	    require(remain>=getLockedAmount(msg.sender));

	    

		

        return ERC20.transfer(_receiver, _amount);

	}

	

	function getTokenAmount(uint256 _amount) public view returns(uint256)

	{

        return _amount/currentPrice;

	}

	

// 	Founder

	function round0(address _receiver, uint256 _amount) public onlyOwner

	{

	    if(count<22)

	    {

	       for(uint256 i=12;i<70;i++)

    	    {

    	        transferAndLock(_receiver, _amount*17/10*1/100,i);

    	    }

            transferAndLock(_receiver, _amount*14/10*1/100,70); 

            count +=1;

	    }

	    

	}

// 	Co_Founder

	function round1(address _receiver, uint256 _amount) public

	{

	   // uint256 amount = getTokenAmount(_amount);

        require(balanceOf(owner()) >= _amount);

        transferAndLock(_receiver, _amount*3/100,2);

        for(uint i=3;i<=11;i++)

	    {

	        transferAndLock(_receiver, _amount*19/10*1/100,i);

	    }

        for(uint j=12;j<=58;j++)

	    {

	        transferAndLock(_receiver, _amount*17/10*1/100,j);

	    }

	}

// 	Angel

	function round2(address _receiver, uint256 _amount) public

	{

        // uint256 amount = getTokenAmount(_amount);

        require(balanceOf(owner()) >= _amount);

        transferAndLock(_receiver,_amount*38/10*1/100,3);

        for(uint i=4;i<=11;i++)

	    {

	        transferAndLock(_receiver, _amount*238/100*1/100,i);

	    }

	    for(uint j=12;j<=46;j++)

	    {

	        transferAndLock(_receiver, _amount*216/100*1/100,j);

	    }

        transferAndLock(_receiver,_amount*156/100*1/100,47);

        

	}

	

// 	Seria A

	function round3(address _receiver, uint256 _amount) public

	{

        // uint256 amount = getTokenAmount(_amount);

        require(balanceOf(owner()) >= _amount);

        transferAndLock(_receiver,_amount*46/10*1/100, 4);

        for(uint i=5;i<=11;i++)

	    {

	        transferAndLock(_receiver, _amount*29/10*1/100,i);

	    }

	    for(uint j=12;j<=39;j++)

	    {

	        transferAndLock(_receiver, _amount*261/100*1/100,j);

	    }

        transferAndLock(_receiver,_amount*202/100*1/100,40);

	}

	

	

	// 	Seria B

	function round4(address _receiver, uint256 _amount) public

	{

        // uint256 amount = getTokenAmount(_amount);

        require(balanceOf(owner()) >= _amount);

        transferAndLock(_receiver,_amount*5/100, 5);

        for(uint i=6;i<=11;i++)

	    {

	        transferAndLock(_receiver, _amount*3/100,i);

	    }

	    for(uint j=12;j<=35;j++)

	    {

	        transferAndLock(_receiver, _amount*31/10*1/100,j);

	    }

        transferAndLock(_receiver,_amount*26/10*1/100,36);

	}

	

	// 	Seria C

	function round5(address _receiver, uint256 _amount) public

	{

        // uint256 amount = getTokenAmount(_amount);

        require(balanceOf(owner()) >= _amount);

        transferAndLock(_receiver,_amount*62/10*1/100, 6);

        for(uint i=7;i<=11;i++)

	    {

	        transferAndLock(_receiver, _amount*39/10*1/100,i);

	    }

	    for(uint j=12;j<=32;j++)

	    {

	        transferAndLock(_receiver, _amount*352/100*1/100,j);

	    }

        transferAndLock(_receiver,_amount*38/100*1/100,33);

	}

	

	// 	Seria D

	function round6(address _receiver, uint256 _amount) public

	{

        // uint256 amount = getTokenAmount(_amount);

        require(balanceOf(owner()) >= _amount);

        transferAndLock(_receiver,_amount*7/100, 7);

        for(uint i=8;i<=11;i++)

	    {

	        transferAndLock(_receiver, _amount*44/10*1/100,i);

	    }

	    for(uint j=12;j<=29;j++)

	    {

	        transferAndLock(_receiver, _amount*398/100*1/100,j);

	    }

        transferAndLock(_receiver,_amount*376/100*1/100,33);

	}

	

	// 	Seria E

	function round7(address _receiver, uint256 _amount) public

	{

        // uint256 amount = getTokenAmount(_amount);

        require(balanceOf(owner()) >= _amount);

        transferAndLock(_receiver,_amount*78/10*1/100, 8);

        for(uint i=9;i<=11;i++)

	    {

	        transferAndLock(_receiver, _amount*488/100*1/100,i);

	    }

	    for(uint j=12;j<=28;j++)

	    {

	        transferAndLock(_receiver, _amount*443/100*1/100,j);

	    }

        transferAndLock(_receiver,_amount*225/100*1/100,29);

	}

	

	

	// 	Seria F

	function round8(address _receiver, uint256 _amount) public

	{

        // uint256 amount = getTokenAmount(_amount);

        require(balanceOf(owner()) >= _amount);

        transferAndLock(_receiver,_amount*86/10*1/100, 9);

        for(uint i=10;i<=11;i++)

	    {

	        transferAndLock(_receiver, _amount*538/100*1/100,i);

	    }

	    for(uint j=12;j<=27;j++)

	    {

	        transferAndLock(_receiver, _amount*489/100*1/100,j);

	    }

        transferAndLock(_receiver,_amount*24/10*1/100,28);

	}



    // 	Seria G

	function round9(address _receiver, uint256 _amount) public

	{

        // uint256 amount = getTokenAmount(_amount);

        require(balanceOf(owner()) >= _amount);

        transferAndLock(_receiver,_amount*94/10*1/100, 10);

        transferAndLock(_receiver, _amount*588/100*1/100,11);

	    

	    for(uint j=12;j<=26;j++)

	    {

	        transferAndLock(_receiver, _amount*534/100*1/100,j);

	    }

        transferAndLock(_receiver,_amount*462/100*1/100,27);

	}



// 	Pre_IPO

	function round10(address _receiver, uint256 _amount) public

	{

        // uint256 amount = getTokenAmount(_amount);

        require(balanceOf(owner()) >= _amount);

        transferAndLock(_receiver,_amount*102/10*1/100, 11);

	    for(uint j=12;j<=26;j++)

	    {

	        transferAndLock(_receiver, _amount*58/10*1/100,j);

	    }

        transferAndLock(_receiver,_amount*28/10*1/100,27);

	}



	function transferAndLock(address _receiver, uint256 _amount, uint256 _round) public returns (bool success)

	{

        transfeFromOwner(owner(),_receiver,_amount);

        

    	LockItem memory item = LockItem({amount:_amount, round:_round});

		lockList[_receiver].push(item);

	

        return true;

	}

	



	function getLockedListSize(address lockedAddress) public view returns(uint256 _lenght)

	{

	    return lockList[lockedAddress].length;

	}

	function getLockedAmountAtRound(address lockedAddress,uint8 _round) public view returns(uint256 _amount)

	{

	    uint256 lockedAmount =0;

	    for(uint256 j = 0;j<getLockedListSize(lockedAddress);j++)

	    {

	        uint256 round = getLockedTimeAt(lockedAddress,j);

	        if(round==_round)

	        {

	            uint256 temp = getLockedAmountAt(lockedAddress,j);

	            lockedAmount += temp;

	        }

	    }

	    return lockedAmount;

	}

	function getLockedAmountAt(address lockedAddress, uint256 index) public view returns(uint256 _amount)

	{

	    

	    return lockList[lockedAddress][index].amount;

	}

	

	function getLockedTimeAt(address lockedAddress, uint256 index) public view returns(uint256 _time)

	{

	    return lockList[lockedAddress][index].round;

	}



	

	function getLockedAmount(address lockedAddress) public view returns(uint256 _amount)

	{

	    uint256 lockedAmount =0;

	    for(uint256 j = 0;j<getLockedListSize(lockedAddress);j++)

	    {

	        uint256 round = getLockedTimeAt(lockedAddress,j);

	        if(round>currentRound)

	        {

	            uint256 temp = getLockedAmountAt(lockedAddress,j);

	            lockedAmount += temp;

	        }

	    }

	    return lockedAmount;

	}



    function () payable external

    {   

        revert();

    }





}