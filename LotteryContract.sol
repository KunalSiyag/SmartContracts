//SPDX-License-Identifier: GPL -3.0
pragma solidity >=0.5.0 <0.9.0;

contract Lottery{
     address public master;
     address payable[] public participants;
      
      constructor(){
              master = msg.sender;
      }
     receive() external payable {
         require(msg.value == 1 ether);
         participants.push(payable(msg.sender));
     }
     function getBalance() public view returns(uint){
           require(msg.sender == master);
           return address(this).balance;
     }
     function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));
     }
     function selectWinner() public {
         require(msg.sender == master);
         require(participants.length >= 3);
         participants[random()/(participants.length)].transfer(getBalance());
     }


}