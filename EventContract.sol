//SPDX-License-Identifier: GPL -3.0
pragma solidity >=0.5.0 <0.9.0;
contract EventOrganise{
    struct Event{
       address organiser;
       string name;
       uint date;
       uint tktprice;
       uint tktCount;
       uint tktRemain;
    }
    mapping(uint=>Event) public events;
    mapping(address=>mapping(uint=>uint)) public tickets;
    uint eventID;
    function organiseEvent(string memory name,uint date,uint tktprice,uint tktCount) external {
     require(block.timestamp < date,"Please select a future date.");
     require(tktCount>0,"Please distribute tickets.");
     events[eventID] = Event(msg.sender,name,date,tktprice,tktCount,tktCount);
     eventID++;
    }
    function gettkt(uint ID,uint count) external payable{
     require(events[ID].date > 0,"No such event exists");
     require(events[ID].date > block.timestamp,"This event has already occured");   
     require(msg.value == events[ID].tktprice*count,"Please pay the appropriate price.");
     require(events[ID].tktRemain>=count,"Not enough tickets.");
     tickets[msg.sender][ID] += count;
     events[ID].tktRemain -= count;
    }
    
    function transfer(address from,uint ID,uint count,address to) public 
    {
     require(events[ID].date > 0,"No such event exists");
     require(events[ID].date > block.timestamp,"This event has already occured");
     require(tickets[from][ID]<=count); 
     tickets[to][ID] +=count;
     if(tickets[from][ID] == count){
          delete tickets[from][ID];  
     }
     else{
         tickets[from][ID] -= count;
     }
     
    }




}