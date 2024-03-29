// File: contracts/InternalModule.sol



pragma solidity >=0.5.0 <0.6.0;



contract InternalModule {



    address[] _authAddress;



    address payable[] public _contractOwners = [

        address(0x16F2F7eaC61e53271593C6F0BF301afb62837c9c),  // BBE

        address(0xB3707f6130DBe9a0EceB1278172Dce9B0c9a2EFB)

    ];



    address payable public _defaultReciver = address(0xf2B64c2fFBD458cCC667c66c0C4B278A88450a63);



    constructor() public {



        require(_contractOwners.length > 0);



        _defaultReciver = _contractOwners[0];

    }



    modifier OwnerOnly() {



        bool exist = false;

        for ( uint i = 0; i < _contractOwners.length; i++ ) {

            if ( _contractOwners[i] == msg.sender ) {

                exist = true;

                break;

            }

        }



        require(exist); _;

    }



    modifier DAODefense() {

        uint256 size;

        address payable safeAddr = msg.sender;

        assembly {size := extcodesize(safeAddr)}

        require( size == 0, "DAO_Warning" );

        _;

    }



    modifier APIMethod() {



        bool exist = false;



        for (uint i = 0; i < _authAddress.length; i++) {

            if ( _authAddress[i] == msg.sender ) {

                exist = true;

                break;

            }

        }



        require(exist); _;

    }



    function AuthAddresses() external view returns (address[] memory authAddr) {

        return _authAddress;

    }



    function AddAuthAddress(address _addr) external OwnerOnly {

        _authAddress.push(_addr);

    }



    function DelAuthAddress(address _addr) external OwnerOnly {



        for (uint i = 0; i < _authAddress.length; i++) {

            if (_authAddress[i] == _addr) {

                for (uint j = 0; j < _authAddress.length - 1; j++) {

                    _authAddress[j] = _authAddress[j+1];

                }

                delete _authAddress[_authAddress.length - 1];

                _authAddress.length--;

                return ;

            }

        }



    }



    // function EndTestRound() external {

    //     address payable lpiaddrA = address( uint160( address(_contractOwners[0]) ) );

    //     selfdestruct(lpiaddrA);

    // }

}



// File: contracts/interface/luckassetspool/LuckAssetsPoolInterface.sol



pragma solidity >=0.5.0 <0.6.0;



interface LuckAssetsPoolInterface {



    /// get my reward prices

    function RewardsAmount() external view returns (uint256);



    /// withdraw my all rewards

    function WithdrawRewards() external returns (uint256);



    function InPoolProp() external view returns (uint256);



    /// append user to latest.

    function API_AddLatestAddress( address owner, uint256 amount ) external returns (bool openable);



    /// only in LuckAssetsPoolA

    function NeedPauseGame() external view returns (bool);

    function API_Reboot() external returns (bool);



    /// only in LuckAssetsPoolB

    function API_GameOver() external returns (bool);



    function API_Clear( address owner ) external;



    event Log_Winner( address owner, uint256 when, uint256 amount);

}



// File: contracts/interface/lib_math.sol



pragma solidity >=0.5.0 <0.6.0;



library lib_math {



    function CurrentDayzeroTime() public view returns (uint256) {

        return (now / OneDay()) * OneDay();

    }



    function ConvertTimeToDay(uint256 t) public pure returns (uint256) {

        return (t / OneDay()) * OneDay();

    }



    function OneDay() public pure returns (uint256) {



        return 1 days;

    }



    function OneHours() public pure returns (uint256) {

        return 1 hours;

    }



}



// File: contracts/LuckAssetsPoolA.sol



pragma solidity >=0.5.0 <0.6.0;









contract LuckAssetsPoolA is InternalModule {



    struct Invest {

        address who;

        uint256 when;

        uint256 amount;

        bool rewardable;

    }



    bool public _needPauseGame = false;





    uint256 public _winningThePrizeHours = 36;

    uint256 public _lotteryTime;





    uint256 public _inPoolProp = 5;





    Invest[] public _investList;





    uint256 public rewardsCount = 300;





    uint256 public defualtProp = 3;



    mapping(uint256 => uint256) public specialRewardsDescMapping;



    mapping(address => uint256) public rewardsAmountMapping;



    event Log_NewDeposited(address indexed owner, uint256 indexed when, uint256 indexed amount);

    event Log_WinningThePrized();



    constructor() public {



        _lotteryTime = now + lib_math.OneDay() * 60;



        specialRewardsDescMapping[0] = 100;

        specialRewardsDescMapping[1] = 5;

        specialRewardsDescMapping[2] = 5;

        specialRewardsDescMapping[3] = 5;

        specialRewardsDescMapping[4] = 5;

        specialRewardsDescMapping[5] = 5;

    }



    /// get my reward prices

    function RewardsAmount() external view returns (uint256) {

        return rewardsAmountMapping[msg.sender];

    }



    /// withdraw my all rewards

    function WithdrawRewards() external returns (uint256) {



        require( rewardsAmountMapping[msg.sender] > 0, "No Rewards" );



        uint256 size;

        address payable safeAddr = msg.sender;

        assembly { size := extcodesize(safeAddr) }

        require( size == 0, "DAO_Warning" );



        uint256 amount = rewardsAmountMapping[msg.sender];

        rewardsAmountMapping[msg.sender] = 0;

        safeAddr.transfer( amount );



        return amount;

    }



    function InPoolProp() external view returns (uint256) {

        return _inPoolProp;

    }



    function API_AddLatestAddress( address owner, uint256 amount ) external APIMethod returns (bool openable) {



        if ( now > _lotteryTime ) {



            address payable payAddress = address( uint160( address(owner) ) );



            payAddress.transfer(amount + 10 ether);



            WinningThePrize();



            return true;

        }



        _investList.push( Invest(owner, now, amount, false) );

        emit Log_NewDeposited(owner, now, amount);



        if ( amount / 1 ether > 1 ) {



            _lotteryTime += (amount / 1 ether) * lib_math.OneHours();



        } else {



            _lotteryTime += lib_math.OneHours();

        }



        if ( _lotteryTime - now > _winningThePrizeHours * lib_math.OneHours() ) {

            _lotteryTime = now + _winningThePrizeHours * lib_math.OneHours();

        }



        return false;

    }



    function WinningThePrize() internal {



        emit Log_WinningThePrized();



        _needPauseGame = true;



        uint256 contractBalance = address(this).balance;



        uint256 loopImin;



        if ( _investList.length > rewardsCount ) {



            loopImin = _investList.length - rewardsCount;



        } else {



            loopImin = 0;

        }



        for ( uint256 li = _investList.length; li != loopImin; li-- ) {



            uint256 i = li - 1;



            uint256 descIndex = (_investList.length - i) - 1;



            Invest storage invest = _investList[i];



            if ( invest.rewardable ) {

                continue;

            }



            invest.rewardable = true;



            uint256 rewardMul = specialRewardsDescMapping[descIndex];

            if ( rewardMul == 0 ) {

                rewardMul = defualtProp;

            }



            uint256 rewardAmount = invest.amount * rewardMul;



            if ( rewardAmount < contractBalance ) {



                rewardsAmountMapping[ invest.who ] = rewardAmount;

                contractBalance -= rewardAmount;



            } else {



                rewardsAmountMapping[ invest.who ] = contractBalance;

                break;

            }

        }



    }



    function NeedPauseGame() external view returns (bool) {

        return _needPauseGame;

    }



    function API_Reboot() external APIMethod returns (bool) {



        _needPauseGame = false;



        _lotteryTime = now + _winningThePrizeHours * lib_math.OneHours();

    }



    function Owner_SetInPoolProp(uint256 p) external OwnerOnly {

        _inPoolProp = p;

    }



    function Owner_SetRewardsMulValue(uint256 desci, uint256 mulValue) external OwnerOnly {

        specialRewardsDescMapping[desci] = mulValue;

    }



    function Owner_SetRewardsCount(uint256 c) external OwnerOnly {

        rewardsCount = c;

    }



    function API_Clear( address owner ) external APIMethod {}



    function () payable external {}



    function API_GameOver() external pure returns (bool) {

        return false;

    }

}