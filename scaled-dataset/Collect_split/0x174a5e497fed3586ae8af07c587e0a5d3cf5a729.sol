/**

 *Submitted for verification at Etherscan.io on 2019-09-09

 * BEB dapp for www.betbeb.com

*/

pragma solidity^0.4.24;  

interface tokenTransfer {

    function transfer(address receiver, uint amount);

    function transferFrom(address _from, address _to, uint256 _value);

    function balanceOf(address receiver) returns(uint256);

}



contract Ownable {

  address public owner;

 

    function Ownable () public {

        owner = msg.sender;

    }

 

    modifier onlyOwner {

        require (msg.sender == owner);

        _;

    }

 

    /**

     * @param  newOwner address

     */

    function transferOwnership(address newOwner) onlyOwner public {

        if (newOwner != address(0)) {

        owner = newOwner;

      }

    }

}



contract bebBUY is Ownable{

tokenTransfer public bebTokenTransfer; //代币 

    uint8 decimals = 18;

    uint256 bebethex=7000;//eth-beb

    uint256 BEBmax;

    mapping(address=>uint256)public bebOf;

    function bebBUY(address _tokenAddress){

         bebTokenTransfer = tokenTransfer(_tokenAddress);

     }

     function querBalance()public view returns(uint256){

         return this.balance;

     }

    //buyBeb-eth

    function buyBeb(address _addr) payable public {

        uint256 amount = msg.value;

        uint256 _transfer=amount*bebethex;

        bebOf[_addr]+=_transfer;

        require(bebOf[_addr]<=BEBmax,"Limited purchase of ICO smart contract");

        bebTokenTransfer.transfer(msg.sender,_transfer);  

    }

    function getTokenBalance() public view returns(uint256){

         return bebTokenTransfer.balanceOf(address(this));

    }

    function ETHwithdrawal(uint256 amount) payable  onlyOwner {

       uint256 _amount=amount* 10 ** 18;

       require(this.balance>=_amount,"Insufficient contract balance");

      owner.transfer(_amount);

    }

    function setBEBex(uint256 _value,uint256 _BEBMAX)onlyOwner{

        bebethex=_value;

        BEBmax=_BEBMAX* 10 ** 18;

    }

    function ()payable{

        

    }

}