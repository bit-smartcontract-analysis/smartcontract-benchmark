pragma solidity 0.5.14;



library SafeMath {



    function add(uint256 a, uint256 b) internal pure returns (uint256) {

        uint256 c = a + b;

        require(c >= a, "SafeMath: addition overflow");

        return c;

    }



    function sub(uint256 a, uint256 b) internal pure returns (uint256) {

        require(b <= a, "SafeMath: subtraction overflow");

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

        require(b > 0, "SafeMath: division by zero");

        uint256 c = a / b;

        return c;

    }

    

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {

        require(b != 0, "SafeMath: modulo by zero");

        return a % b;

    }

}



contract TrustWay {



    event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);

    event buyLevelEvent(address indexed _user, uint _level, uint _time);

    event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);

    event lostMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);

    



    address payable public ownerWallet;



    mapping (uint => uint) public LEVEL_PRICE;

    uint REFERRER_1_LEVEL_LIMIT = 2;

    uint PERIOD_LENGTH = 64 days;

    uint RENEWAL_NOT_EARLIER = 64 days;

    

    struct UserStruct {

        bool isExist;

        uint id;

        uint referrerID;

        address[] referral;

        mapping (uint => uint) levelExpired;

    }

    

    

    mapping (address => UserStruct) public users;

    mapping (uint => address) public userList;

    uint public currUserID = 0;



   

    constructor() public {

        ownerWallet = msg.sender;

        // 0.10 - level price , 0.02 - commission for the first time entry

        LEVEL_PRICE[1] = 0.10 ether; 

        LEVEL_PRICE[2] = 0.20 ether;

        LEVEL_PRICE[3] = 0.40 ether;

        LEVEL_PRICE[4] = 0.80 ether;

        LEVEL_PRICE[5] = 1.60 ether;

        LEVEL_PRICE[6] = 3.20 ether;

        LEVEL_PRICE[7] = 6.40 ether;

        LEVEL_PRICE[8] = 12.80 ether;



        UserStruct memory userStruct;

        currUserID++;



        userStruct = UserStruct({

            isExist : true,

            id : currUserID,

            referrerID : 0,

            referral : new address[](0)

        });

        users[ownerWallet] = userStruct;

        userList[currUserID] = ownerWallet;



        users[ownerWallet].levelExpired[1] = 77777777777;

        users[ownerWallet].levelExpired[2] = 77777777777;

        users[ownerWallet].levelExpired[3] = 77777777777;

        users[ownerWallet].levelExpired[4] = 77777777777;

        users[ownerWallet].levelExpired[5] = 77777777777;

        users[ownerWallet].levelExpired[6] = 77777777777;

        users[ownerWallet].levelExpired[7] = 77777777777;

        users[ownerWallet].levelExpired[8] = 77777777777;

    }

    



    function () external payable {



        uint level;

        // User extend/buy level 1.

        if((msg.value == LEVEL_PRICE[1]) && (users[msg.sender].isExist)){  

            level = 1;

        }

        // User enters for the first time.

        else if((msg.value == LEVEL_PRICE[1]+(0.02 ether))  && !(users[msg.sender].isExist)){

            level = 1;

        }

        else if(msg.value == LEVEL_PRICE[2]){

            level = 2;

        }else if(msg.value == LEVEL_PRICE[3]){

            level = 3;

        }else if(msg.value == LEVEL_PRICE[4]){

            level = 4;

        }else if(msg.value == LEVEL_PRICE[5]){

            level = 5;

        }else if(msg.value == LEVEL_PRICE[6]){

            level = 6;

        }else if(msg.value == LEVEL_PRICE[7]){

            level = 7;

        }else if(msg.value == LEVEL_PRICE[8]){

            level = 8;

        }

        else {

            revert('Incorrect Value send');

        }



        if(users[msg.sender].isExist){

            buyLevel(level);

        } else if(level == 1) {

            uint refId = 0;

 

            address referrer = bytesToAddress(msg.data);



            if (users[referrer].isExist){

                refId = users[referrer].id;

            } else {

                revert('Incorrect referrer');

            }



            regUser(refId);

        } else {

            revert("Please buy first level for 0.10 ETH");

        }

    }

    



    function regUser(uint _referrerID) internal {



        if(users[userList[_referrerID]].referral.length >= REFERRER_1_LEVEL_LIMIT)

        {

            _referrerID = users[findFreeReferrer(userList[_referrerID])].id;

        }





        UserStruct memory userStruct;

        currUserID++;



        userStruct = UserStruct({

            isExist : true,

            id : currUserID,

            referrerID : _referrerID,

            referral : new address[](0)

        });



        users[msg.sender] = userStruct;

        userList[currUserID] = msg.sender;



        users[msg.sender].levelExpired[1] = now + PERIOD_LENGTH;



        users[userList[_referrerID]].referral.push(msg.sender);



        payForLevel(1, msg.sender,true); // User enters fisrt time, so commission fee will be deducted.



        emit regLevelEvent(msg.sender, userList[_referrerID], now);

    }



    function buyLevel(uint _level) internal {

        

        require(users[msg.sender].levelExpired[_level] < now + RENEWAL_NOT_EARLIER, 'The level has already been extended for a long time. Try later');



        if(_level == 1){

            users[msg.sender].levelExpired[1] += PERIOD_LENGTH;

        } else {

            for(uint l =_level-1; l>0; l-- ){

                require(users[msg.sender].levelExpired[l] >= now, 'Buy the previous level');

            }



            if(users[msg.sender].levelExpired[_level] == 0){

                users[msg.sender].levelExpired[_level] = now + PERIOD_LENGTH;

            } else {

                users[msg.sender].levelExpired[_level] += PERIOD_LENGTH;

            }

        }

        payForLevel(_level, msg.sender,false);

        emit buyLevelEvent(msg.sender, _level, now);

    }



    function payForLevel(uint _level, address _user,bool _feeStatus) internal {

        

        address referrer = getUserReferrer(_user, _level);



        if(!users[referrer].isExist){

            referrer = userList[1];

        }



        if(users[referrer].levelExpired[_level] >= now ){

            require(address(uint160(referrer)).send(LEVEL_PRICE[_level]), "referrer transfer failed");

            // Fee for first time

            if(_feeStatus){

                require(ownerWallet.send((0.02 ether)), "fee transfer failed");

            }

            emit getMoneyForLevelEvent(referrer, msg.sender, _level, now);

        } else {

            emit lostMoneyForLevelEvent(referrer, msg.sender, _level, now);

            payForLevel(_level,referrer,_feeStatus);

        }

    }

    



    function findFreeReferrer(address _user) public view returns(address) {

        if(users[_user].referral.length < REFERRER_1_LEVEL_LIMIT){

            return _user;

        }



        address[] memory referrals = new address[](2046);

        referrals[0] = users[_user].referral[0]; 

        referrals[1] = users[_user].referral[1];



        address freeReferrer;

        bool noFreeReferrer = true;



        for(uint i =0; i<2046;i++){

            if(users[referrals[i]].referral.length == REFERRER_1_LEVEL_LIMIT){

                if(i<1022){

                    referrals[(i+1)*2] = users[referrals[i]].referral[0];

                    referrals[(i+1)*2+1] = users[referrals[i]].referral[1];

                }

            }else{

                noFreeReferrer = false;

                freeReferrer = referrals[i];

                break;

            }

        }

        require(!noFreeReferrer, 'No Free Referrer');

        return freeReferrer;



    }

    

    function getUserReferrer(address _user, uint _level) public view returns (address) {

      if (_level == 0 || _user == address(0)) {

        return _user;

      }



      return this.getUserReferrer(userList[users[_user].referrerID], _level - 1);

    }    



    function viewUserReferral(address _user) public view returns(address[] memory) {

        return users[_user].referral;

    }



    function viewUserLevelExpired(address _user, uint _level) public view returns(uint) {

        return users[_user].levelExpired[_level];

    }

        

    function bytesToAddress(bytes memory bys) private pure returns (address  addr ) {

        assembly {

            addr := mload(add(bys, 20))

        }

    }

    

}