// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.7.0;

// File: contracts/Ownable.sol







/// @title Ownable

/// @author Brecht Devos - <brecht@loopring.org>

/// @dev The Ownable contract has an owner address, and provides basic

///      authorization control functions, this simplifies the implementation of

///      "user permissions".

contract Ownable

{

    address public owner;



    event OwnershipTransferred(

        address indexed previousOwner,

        address indexed newOwner

    );



    /// @dev The Ownable constructor sets the original `owner` of the contract

    ///      to the sender.

    constructor()

    {

        owner = msg.sender;

    }



    /// @dev Throws if called by any account other than the owner.

    modifier onlyOwner()

    {

        require(msg.sender == owner, "UNAUTHORIZED");

        _;

    }



    /// @dev Allows the current owner to transfer control of the contract to a

    ///      new owner.

    /// @param newOwner The address to transfer ownership to.

    function transferOwnership(

        address newOwner

        )

        public

        virtual

        onlyOwner

    {

        require(newOwner != address(0), "ZERO_ADDRESS");

        emit OwnershipTransferred(owner, newOwner);

        owner = newOwner;

    }



    function renounceOwnership()

        public

        onlyOwner

    {

        emit OwnershipTransferred(owner, address(0));

        owner = address(0);

    }

}



// File: contracts/Claimable.sol









/// @title Claimable

/// @author Brecht Devos - <brecht@loopring.org>

/// @dev Extension for the Ownable contract, where the ownership needs

///      to be claimed. This allows the new owner to accept the transfer.

contract Claimable is Ownable

{

    address public pendingOwner;



    /// @dev Modifier throws if called by any account other than the pendingOwner.

    modifier onlyPendingOwner() {

        require(msg.sender == pendingOwner, "UNAUTHORIZED");

        _;

    }



    /// @dev Allows the current owner to set the pendingOwner address.

    /// @param newOwner The address to transfer ownership to.

    function transferOwnership(

        address newOwner

        )

        public

        override

        onlyOwner

    {

        require(newOwner != address(0) && newOwner != owner, "INVALID_ADDRESS");

        pendingOwner = newOwner;

    }



    /// @dev Allows the pendingOwner address to finalize the transfer.

    function claimOwnership()

        public

        onlyPendingOwner

    {

        emit OwnershipTransferred(owner, pendingOwner);

        owner = pendingOwner;

        pendingOwner = address(0);

    }

}



// File: contracts/ERC20.sol







/// @title ERC20 Token Interface

/// @dev see https://github.com/ethereum/EIPs/issues/20

/// @author Daniel Wang - <daniel@loopring.org>

abstract contract ERC20

{

    function totalSupply()

        public

        view

        virtual

        returns (uint);



    function balanceOf(

        address who

        )

        public

        view

        virtual

        returns (uint);



    function allowance(

        address owner,

        address spender

        )

        public

        view

        virtual

        returns (uint);



    function transfer(

        address to,

        uint value

        )

        public

        virtual

        returns (bool);



    function transferFrom(

        address from,

        address to,

        uint    value

        )

        public

        virtual

        returns (bool);



    function approve(

        address spender,

        uint    value

        )

        public

        virtual

        returns (bool);

}



// File: contracts/MathUint.sol







/// @title Utility Functions for uint

/// @author Daniel Wang - <daniel@loopring.org>

library MathUint

{

    function mul(

        uint a,

        uint b

        )

        internal

        pure

        returns (uint c)

    {

        c = a * b;

        require(a == 0 || c / a == b, "MUL_OVERFLOW");

    }



    function sub(

        uint a,

        uint b

        )

        internal

        pure

        returns (uint)

    {

        require(b <= a, "SUB_UNDERFLOW");

        return a - b;

    }



    function add(

        uint a,

        uint b

        )

        internal

        pure

        returns (uint c)

    {

        c = a + b;

        require(c >= a, "ADD_OVERFLOW");

    }

}



// File: contracts/BaseTokenOwnershipPlan.sol













/// @title EmployeeTokenOwnershipPlan

/// @author Freeman Zhong - <kongliang@loopring.org>

/// added at 2021-02-19

abstract contract BaseTokenOwnershipPlan is Claimable

{

    using MathUint for uint;



    struct Record {

        uint lastWithdrawTime;

        uint rewarded;

        uint withdrawn;

    }



    uint    public constant vestPeriod = 2 * 365 days;

    address public constant lrcAddress = 0xBBbbCA6A901c926F240b89EacB641d8Aec7AEafD;



    uint public totalReward;

    uint public vestStart;

    mapping (address => Record) public records;



    event Withdrawal(

        address indexed transactor,

        address indexed member,

        uint            amount

    );

    event MemberAddressChanged(

        address oldAddress,

        address newAddress

    );



    function withdrawFor(address recipient)

        external

    {

        _withdraw(recipient);

    }



    function updateRecipient(address oldRecipient, address newRecipient)

        external

    {

        require(canChangeAddressFor(oldRecipient), "UNAUTHORIZED");

        require(newRecipient != address(0), "INVALID_ADDRESS");

        require(records[newRecipient].rewarded == 0, "INVALID_NEW_RECIPIENT");



        Record storage r = records[oldRecipient];

        require(r.rewarded > 0, "INVALID_OLD_RECIPIENT");



        records[newRecipient] = r;

        delete records[oldRecipient];

        emit MemberAddressChanged(oldRecipient, newRecipient);

    }



    function vested(address recipient)

        public

        view

        returns(uint)

    {

        if (block.timestamp.sub(vestStart) < vestPeriod) {

            return records[recipient].rewarded.mul(block.timestamp.sub(vestStart)) / vestPeriod;

        } else {

            return records[recipient].rewarded;

        }

    }



    function withdrawable(address recipient)

        public

        view

        returns(uint)

    {

        return vested(recipient).sub(records[recipient].withdrawn);

    }



    function _withdraw(address recipient)

        internal

    {

        uint amount = withdrawable(recipient);

        require(amount > 0, "INVALID_AMOUNT");



        Record storage r = records[recipient];

        r.lastWithdrawTime = block.timestamp;

        r.withdrawn = r.withdrawn.add(amount);



        require(ERC20(lrcAddress).transfer(recipient, amount), "transfer failed");



        emit Withdrawal(msg.sender, recipient, amount);

    }



    receive() external payable {

        require(msg.value == 0, "INVALID_VALUE");

        _withdraw(msg.sender);

    }



    function collect()

        external

        onlyOwner

    {

        require(block.timestamp > vestStart + vestPeriod + 60 days, "TOO_EARLY");

        uint amount = ERC20(lrcAddress).balanceOf(address(this));

        require(ERC20(lrcAddress).transfer(msg.sender, amount), "transfer failed");

    }



    function canChangeAddressFor(address who)

        internal

        view

        virtual

        returns (bool);

}



// File: contracts/EmployeeTokenOwnershipPlan2020.sol









/// @title EmployeeTokenOwnershipPlan

/// @author Freeman Zhong - <kongliang@loopring.org>

/// added at 2021-02-17

contract EmployeeTokenOwnershipPlan2020 is BaseTokenOwnershipPlan

{

    using MathUint for uint;



    constructor()

    {

        owner = 0x96f16FdB8Cd37C02DEeb7025C1C7618E1bB34d97;



        address payable[45] memory _members = [

            0xFF6f7B2afdd33671503705098dd3c4c26a0F0705,

            0xF5E2359644f61cDeEcFbD068294EB0d2ff7Dc706,

            0xf493af7DFd0e47869Aac4770B2221a259CA77Ac8,

            0xf21e66578372Ea62BCb0D1cDfC070f231CF56898,

            0xEBE85822e75D2B4716e228818B54154E4AfFD202,

            0xeB4c50dF06cEb2Ea700ea127eA589A99a3aAe1Ec,

            0xe0807d8E14F2BCbF3Cc58637259CCF3fDd1D3ce5,

            0xDB5C4078eC50Ad4Cdc47F4597a377528B1d7bcdB,

            0xD984D096B4bF9DCF5fd75D9cBaf052D00EBe74c4,

            0xd3725C997B580E36707f73880aC006B6757b5009,

            0xBe4C1cb10C2Be76798c4186ADbbC34356b358b52,

            0xbd860737F32b7a43e197370606f7eb32c5caD347,

            0xBc5F996840118B580C4452440351b601862c5672,

            0xad05c57e06a80b8EC92383b3e10Fea0E2b4e571D,

            0xaBad5427278F99c9b9393Cc46FDb0Cb4CB6C33f5,

            0xa817c7a0690F17029b756b2EedAA089E0C94c900,

            0xa26cFCeCb07e401547be07eEe26E6FD608f77d1a,

            0x933650184994CFce9D64A9F3Ed14F1Fd017fF89A,

            0x87adb1BEa935649E607f615F41ae8f4cA96566fa,

            0x813C12326A0E8C2aC91d584f025E50072CDb4467,

            0x7F81D533B2ea31BE2591d89394ADD9A12499ff17,

            0x7F6Dd0c1BeB26CFf8ABA5B020E78D7C0Ed54B8Cc,

            0x7b3B1F252169Ff83E3E91106230c36bE672aFdE3,

            0x7809D08edBBBC401c430e5D3862a1Fdfcb8094A2,

            0x7414eA41bd1844f61e8990b209a1Dc301489baa9,

            0x7154a02BA6eEaB9300D056e25f3EEA3481680f87,

            0x6D0228303D0608CACc8a262deA95932DCAc12c8D,

            0x6b1029C9AE8Aa5EEA9e045E8ba3C93d380D5BDDa,

            0x650EACf9AD1576680f1af6eC6cC598A484d796Ad,

            0x5a03a928b332EC269f68684A8e9c1881b4Da5f3d,

            0x55634e271BCa62dDFb9B5f7eae19f3Ae94Fb96b7,

            0x4c381276F4847255C675Eab90c3409FA2fce68bC,

            0x4bA63ac57b45087d03Abfd8E98987705Fa56B1ab,

            0x49c268e3F2119fCf71f70dF987432689dd4145Ad,

            0x41cDd7034AD6b2a5d24397189802048E97b6532D,

            0x33CDbeB3e060bf6973e28492BE3D469C05D32786,

            0x2a791a837D70E6D6e35073Dd61a9Af878Ac231A5,

            0x24C08921717bf5C0029e2b8013B70f1D203cCDac,

            0x2234C96681E9533FDfD122baCBBc634EfbafA0F0,

            0x21870650F40Fe8249DECc96525249a43829E9A32,

            0x1F28F10176F89F4E9985873B84d14e75751BB3D1,

            0x11a8632b5089c6a061760F0b03285e2cC1388E36,

            0x10Bd72a6AfbF8860ec90f7aeCdB8e937a758f351,

            0x07A7191de1BA70dBe875F12e744B020416a5712b,

            0x067eceAd820BC54805A2412B06946b184d11CB4b

        ];



        uint80[45] memory _amounts = [

            187520 ether,

            500053 ether,

            384004 ether,

            538180 ether,

            340060 ether,

            433972 ether,

            530065 ether,

            482910 ether,

            308310 ether,

            398740 ether,

            120010 ether,

            750079 ether,

            31254 ether,

            667795 ether,

            824272 ether,

            750079 ether,

            435961 ether,

            459366 ether,

            750083 ether,

            453078 ether,

            775175 ether,

            500972 ether,

            375040 ether,

            425292 ether,

            692576 ether,

            180661 ether,

            797479 ether,

            517196 ether,

            475260 ether,

            730172 ether,

            549381 ether,

            150834 ether,

            501058 ether,

            1076356 ether,

            145641 ether,

            519363 ether,

            573806 ether,

            162000 ether,

            539577 ether,

            330598 ether,

            470891 ether,

            398740 ether,

            561055 ether,

            221724 ether,

            485991 ether

        ];



        uint _totalReward = 21502629 ether;

        vestStart = block.timestamp;



        for (uint i = 0; i < _members.length; i++) {

            require(records[_members[i]].rewarded == 0, "DUPLICATED_MEMBER");



            Record memory record = Record(block.timestamp, _amounts[i], 0);

            records[_members[i]] = record;

            totalReward = totalReward.add(_amounts[i]);

        }

        require(_totalReward == totalReward, "VALUE_MISMATCH");

    }



    function canChangeAddressFor(address who)

        internal

        view

        override

        returns (bool) {

        return msg.sender == who;

    }



}