//SPDX-License-Identifier: GPL -3.0
pragma solidity >=0.5.0 <0.9.0;
contract CrowdFunding{
        mapping(address=>uint) public contributors;
        address public manager;
        uint public minContribution;
        uint public deadline;
        uint public target;
        uint public raised;
        uint public noContributor;

        struct Request{
            string reason;
            uint amt;
            uint noVotes;
            bool completed;
            address recepient;
            mapping(address=>bool) voters;
        }

        mapping(uint => Request) public requests;
        uint requestID;
        constructor(uint _target,uint _deadline){
              target = _target;
              minContribution = 1 ether;
              deadline = block.timestamp + _deadline;
              manager = msg.sender;
        }

       function sendEth() public payable{
       require(block.timestamp < deadline,"The deadline has passed.");    
       require(msg.value > minContribution,"PLease pay more than minimum amount.");
       if(contributors[msg.sender]==0){
               noContributor++;
       }
       contributors[msg.sender] += msg.value;
       raised += msg.value;
       }

       function contractBalance() public view returns(uint){
           return address(this).balance;
       }

      function refund() public payable{
          require(deadline>block.timestamp && target <= raised,"Refund is not available");
          require(contributors[msg.sender]>0);
          (payable(msg.sender)).transfer(contributors[msg.sender]);
       }
        modifier onlyManager{
            require(msg.sender == manager,"Only manager is allowed to call this function");
            _;
        }
      function createRequest(string memory description,uint fundneeded,address recepient) public onlyManager{
            Request storage newRequest = requests[requestID];
            requestID++;
            newRequest.reason = description;
            newRequest.amt = fundneeded;
            newRequest.recepient = recepient;
            newRequest.completed = false;
            newRequest.noVotes = 0;
      }
      function voteRequest(uint id) public{
          require(contributors[msg.sender]>0,"You are not a contributor");
          Request storage thisRequest = requests[id];
          require(thisRequest.voters[msg.sender]==false,"You have already voted");
          thisRequest.voters[msg.sender] = true;
          thisRequest.noVotes++;
      }
      function makePayment(uint ID) public payable onlyManager{
      require(block.timestamp<deadline,"Deadline has passed");
      require(raised >= target);
      Request storage thisrequest = requests[ID];
      require(thisrequest.completed == false,"You have already completed this request");
      require(thisrequest.noVotes > (noContributor/2),"Majority didnot approve");
      (payable(thisrequest.recepient)).transfer(thisrequest.amt);
      thisrequest.completed = true;

      }  



}