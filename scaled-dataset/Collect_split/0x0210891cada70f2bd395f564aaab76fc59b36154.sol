pragma solidity 0.5.11;

pragma experimental ABIEncoderV2;



/**

 * @title Ownable

 * @dev The Ownable contract has an owner address, and provides basic authorization control

 * functions, this simplifies the implementation of "user permissions".

 */

contract Ownable {

    address public owner;





    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);





    /**

     * @dev The Ownable constructor sets the original `owner` of the contract to the sender

     * account.

     */

    constructor() public {

        owner = msg.sender;

    }



    /**

     * @dev Throws if called by any account other than the owner.

     */

    modifier onlyOwner() {

        require(msg.sender == owner);

        _;

    }



    /**

     * @dev Allows the current owner to transfer control of the contract to a newOwner.

     * @param newOwner The address to transfer ownership to.

     */

    function transferOwnership(address newOwner) public onlyOwner {

        require(newOwner != address(0));

        emit OwnershipTransferred(owner, newOwner);

        owner = newOwner;

    }



}

contract ERC20BasicInterface {

    function totalSupply() public view returns (uint256);



    function balanceOf(address who) public view returns (uint256);



    function transfer(address to, uint256 value) public returns (bool);



    function transferFrom(address from, address to, uint256 value) public returns (bool);



    event Transfer(address indexed from, address indexed to, uint256 value);



    uint8 public decimals;

}

contract GachaDrop is Ownable {

    struct Drop {

        string name;

        uint periodToPlay;

        address erc20Need;

        uint256 requireErc20;

        mapping(address => uint) timeTrackUser;

        uint countCallTime;

    }

    mapping(string => Drop) public Drops;

    string[] public DropNames;

    event _random(address _from, uint _ticket, string _drop, uint _countCallTime);

    event _changePeriodToPlay(string _drop, uint _period);



    constructor() public {

        Drops['tomorrowprice'].name = 'tomorrowprice';

        Drops['tomorrowprice'].periodToPlay = 0;

        Drops['tomorrowprice'].erc20Need = 0x6B175474E89094C44Da98b954EedeAC495271d0F;

        Drops['tomorrowprice'].requireErc20 = 0;

        DropNames.push('tomorrowprice');

    }

    function getDropNames() public view returns(string[] memory) {

        return DropNames;

    }

    function getTimeTrackUser(string memory _drop, address _player) public view returns(uint _periodToPlay, uint _timeTrackUser, uint _countCallTime) {

        return (Drops[_drop].periodToPlay, Drops[_drop].timeTrackUser[_player], Drops[_drop].countCallTime);

    }

    function getAward(string memory _drop) public {

        require(isValidToPlay(_drop));

        Drops[_drop].timeTrackUser[msg.sender] = block.timestamp;

        Drops[_drop].countCallTime = Drops[_drop].countCallTime + 1;

        emit _random(msg.sender, block.timestamp, Drops[_drop].name, Drops[_drop].countCallTime);

    }



    function isValidToPlay(string memory _drop) public view returns (bool){

        ERC20BasicInterface erc20 = ERC20BasicInterface(Drops[_drop].erc20Need);

        return Drops[_drop].periodToPlay <= now - Drops[_drop].timeTrackUser[msg.sender]

        && erc20.balanceOf(msg.sender) >= Drops[_drop].requireErc20;

    }

    function changePeriodToPlay(string memory _drop, uint _period, address _erc20Need, uint256 _requireErc20) onlyOwner public{



        if(Drops[_drop].periodToPlay == 0) {

            DropNames.push(_drop);

            Drops[_drop].name = _drop;

        }



        Drops[_drop].periodToPlay = _period;

        Drops[_drop].erc20Need = _erc20Need;

        Drops[_drop].requireErc20 = _requireErc20;

        emit _changePeriodToPlay(_drop, _period);

    }



}