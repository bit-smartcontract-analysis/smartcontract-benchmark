// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.17;



interface INFHC {

    function mintBatchTo(address to, uint256 amount, uint256 tokenIdStart) external;

    function totalSupply() external returns (uint256);

}



contract NFHCMinter {

    address constant NFHC = 0xd26440809329162f88396a14B159eCdadd0676a5;



    function mint(uint256 amount) external {

        INFHC(NFHC).mintBatchTo(msg.sender, amount, INFHC(NFHC).totalSupply());

    }

}