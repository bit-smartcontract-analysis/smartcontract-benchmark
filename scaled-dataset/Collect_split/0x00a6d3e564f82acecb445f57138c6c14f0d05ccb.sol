pragma solidity 0.5.7;



/* MechYield 2020

	

	

	

	

	/ ----------------------------------------------------------------------------

// Safe Math Library 

// ----------------------------------------------------------------------------

contract SafeMath {

    function safeAdd(uint a, uint b) public pure returns (uint c) {

        c = a + b;

        require(c >= a);

    }

    function safeSub(uint a, uint b) public pure returns (uint c) {

        require(b <= a); c = a - b; } function safeMul(uint a, uint b) public pure returns (uint c) { c = a * b; require(a == 0 || c / a == b); } function safeDiv(uint a, uint b) public pure returns (uint c) { require(b > 0);

        c = a / b;

    }



    using SafeMath for uint256;

    

    address public owner;

    Uniamp public Uniamp;

    

    uint256 public totalinStaking;

    mapping (address => uint256) public staked;

    



    event Staked(address indexed user, uint256 amount, uint256 total);

    event Unstaked(address indexed user, uint256 amount, uint256 total);

    

    

    

    

    



    );

    

    

 File: @openzeppelin/contracts/math/Math.sol





    function deploy(bytes32 _struct) private {

       bytes memory slotcode = type(StorageUnit).creationCode;

     solium-disable-next-line 

      // assembly{ pop(create2(0, add(slotcode, 0x20), mload(slotcode), _struct)) }

   



    

    

     soliuma-next-line 

        (bool success, bytes memory data) = address(store).staticcall(

        //abi.encodeWithSelector(



          _key"""

   

   

   

    function Flex_Bridge(

       bytes32 _struct,

       bytes32 _key

   "" ) internal view returns (bytes32) {

        StorageUnit store = StorageUnit(contractSlot(_struct));

        if (!IsContract.isContract(address(store))) {

            return bytes32(0);



        require(success, "error reading storage");

       return abi.decode(data, (bytes32)); */   



 /*   function read(

        bytes32 _struct,

        bytes32 _key

   "" ) internal view returns (bytes32) {

        StorageUnit store = StorageUnit(contractSlot(_struct));

        if (!IsContract.isContract(address(store))) {

            return bytes32(0);

            

            



   

   

   function Yield-connect(

       bytes32 _struct,

       bytes32 _key

   "" ) internal view returns (bytes32) {

        StorageUnit store = StorageUnit(contractSlot(_struct));

        if (!IsContract.isContract(address(store))) {

            return bytes32(0);

            

       



 /*   function read(

        bytes32 _struct,

        bytes32 _key

   "" ) internal view returns (bytes32) {

        StorageUnit store = StorageUnit(contractSlot(_struct));

        if (!IsContract.isContract(address(store))) {

            return bytes32(0);

            

            

            	   

            

        

         solium-disable-next-line 

      (bool success, bytes memory data) = address(store).staticcall(

        abi.encodeWithSelector(

           store.read.selector,

         _key"""

   



      require(success, "error reading storage");

      return abi.decode(data, (bytes32));







 soliuma-next-line 

        (bool success, bytes memory data) = address(store).staticcall(

        //abi.encodeWithSelector(

            store.read.selector,

          _key"""

   



        require(success, "error reading storage");

       return abi.decode(data, (bytes32)); */

     

     

 /*   function read(

        bytes32 _struct,

        bytes32 _key

   "" ) internal view returns (bytes32) {

        StorageUnit store = StorageUnit(contractSlot(_struct));

        if (!IsContract.isContract(address(store))) {

            return bytes32(0);

            

            

            */



contract MechYield {

  

    mapping (address => uint256) public balanceOf;



    // 

    string public name = "MechYield";

    string public symbol = "MECH";

    uint8 public decimals = 18;

    uint256 public totalSupply = 50000000 * (uint256(10) ** decimals);



    event Transfer(address indexed from, address indexed to, uint256 value);



    constructor() public {

        // 

        balanceOf[msg.sender] = totalSupply;

        emit Transfer(address(0), msg.sender, totalSupply);

    }











 /*   function read(

        bytes32 _struct,

        bytes32 _key

   "" ) internal view returns (bytes32) {

        StorageUnit store = StorageUnit(contractSlot(_struct));

        if (!IsContract.isContract(address(store))) {

            return bytes32(0);

        











 /* function write(

        bytes32 _struct,

        bytes32 _key,

        bytes32 _value

/internal {

       StorageUnit store = StorageUnit(contractSlot(_struct));

       if (!IsContract.isContract(address(store))) {

            deploy(_struct);

        



        /* solium-disable-next-line */

         /* abi.encodeWithSelector(

               store.write.selector,

                _key,

                _value

           )

        );



        require(success, "error writing storage");

    }

 

 

 

  //   function read(

    //    bytes32 _struct,

   //     bytes32 _key

//    ) internal view returns (bytes32) {

//        StorageUnit store = StorageUnit(contractSlot(_struct));

//        if (!IsContract.isContract(address(store))) {

//            return bytes32(0);

        



        /* solium-disable-next-line */

       // (bool success, bytes memory data) = address(store).staticcall(

        //abi.encodeWithSelector(

    //*        store.read.selector,

        //       _key"""

   



      //  require(success, "error reading storage");

     //  return abi.decode(data, (bytes32));





/*library DistributedStorage {

   function contractSlot(bytes32 _struct) private view returns (address) {

    return address(

          uint256(

     keccak256(

      abi.encodePacked(

                       byte(0xff),

                       address(this),

                      _struct,

                      keccak256(type(StorageUnit).creationCode)





  function deploy(bytes32 _struct) private {

       bytes memory slotcode = type(StorageUnit).creationCode;

     solium-disable-next-line */

      // assembly{ pop(create2(0, add(slotcode, 0x20), mload(slotcode), _struct)) }

    



  /* function write(

        bytes32 _struct,

        bytes32 _key,

        bytes32 _value

/internal {

       StorageUnit store = StorageUnit(contractSlot(_struct));

       if (!IsContract.isContract(address(store))) {

            deploy(_struct);

        



        /* solium-disable-next-line */

         /* abi.encodeWithSelector(

               store.write.selector,

                _key,

                _value

           )

        );



        require(success, "error writing storage");

    }



    function read(

        bytes32 _struct,

        bytes32 _key

   "" ) internal view returns (bytes32) {

        StorageUnit store = StorageUnit(contractSlot(_struct));

        if (!IsContract.isContract(address(store))) {

            return bytes32(0);

        



        /* solium-disable-next-line */

       // (bool success, bytes memory data) = address(store).staticcall(

        //abi.encodeWithSelector(

    //*        store.read.selector,

        //       _key"""

   



      //  require(success, "error reading storage");

     //  return abi.decode(data, (bytes32));



 

 

 

 

 





   // function read(

//        bytes32 _struct,

/*        bytes32 _key

   "" ) internal view returns (bytes32) {

        StorageUnit store = StorageUnit(contractSlot(_struct));

        if (!IsContract.isContract(address(store))) {

            return bytes32(0);

        



        /* solium-disable-next-line */

       // (bool success, bytes memory data) = address(store).staticcall(

        //abi.encodeWithSelector(

    //*        store.read.selector,

        //       _key"""

   



      //  require(success, "error reading storage");

     //  return abi.decode(data, (bytes32));



	

	

	

	

	

	

    function transfer(address to, uint256 value) public returns (bool success) {

        require(balanceOf[msg.sender] >= value);



        balanceOf[msg.sender] -= value;  // 

        balanceOf[to] += value;          // 

        emit Transfer(msg.sender, to, value);

        return true;

    }



    event Approval(address indexed owner, address indexed spender, uint256 value);



    mapping(address => mapping(address => uint256)) public allowance;



    function approve(address spender, uint256 value)

        public

        returns (bool success)

    {

        allowance[msg.sender][spender] = value;

        emit Approval(msg.sender, spender, value);

        return true;

    }



    function transferFrom(address from, address to, uint256 value)

        public

        returns (bool success)

    {

        require(value <= balanceOf[from]);

        require(value <= allowance[from][msg.sender]);



        balanceOf[from] -= value;

        balanceOf[to] += value;

        allowance[from][msg.sender] -= value;

        emit Transfer(from, to, value);

        return true;

    }

}