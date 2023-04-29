//SPDX-License-Identifier: unLicense
pragma solidity >= 0.5.0 <0.9.0;
contract shareholding{
        address public chairperson;
        uint companyshares;
        uint stakepercent;
        uint shareprice;
        uint sharealloted;
        mapping(address => uint) public shareholders;
        mapping(uint => proposal) public proposals;
        struct proposal{
            string name;
            mapping(address =>bool) holderinagreement;
            uint sharesinagreement;
            bool passed;
        }
        constructor(uint totalshares,uint cpsharepercent,uint sharevalue,uint stakelimit) {
            require(stakelimit<=10,"individual stake cannot be more than 10 percent");
            chairperson = msg.sender;
            companyshares = totalshares;
            shareprice = sharevalue;
            stakepercent = stakelimit;
            require(25 <= cpsharepercent && cpsharepercent <= 50,"Minimum stake and Maximum stake for the chairperson is set to 25 and 50 percent respectively.");
            shareholders[msg.sender] = (cpsharepercent*totalshares)/100;
        }

        modifier onlyChairperson{
            require(msg.sender == chairperson);
            _;
        }
        uint proposalID;
        function buyShares(uint sharequantity) public payable{
        require(msg.sender != chairperson);
         require(sharealloted<(companyshares*45/100),"All the shares available to promoters have been alloted.");
         require(shareholders[msg.sender]<=(stakepercent*companyshares/100),"You cannot buy more stake in the company.");
         require(msg.value == shareprice*sharequantity,"Please pay the appropriate amount.");
         shareholders[msg.sender] +=sharequantity;
         sharealloted += sharequantity;
        }
        function createProposal(string memory _name) public onlyChairperson{
        proposal storage newProposal = proposals[proposalID];
        newProposal.name = _name;
        newProposal.passed = false;
        proposalID++;
        }
        function vote(uint ID) public{
            require(proposals[ID].holderinagreement[msg.sender] == false,"You have already voted.");
            proposals[ID].holderinagreement[msg.sender] == true;
            proposals[ID].sharesinagreement += shareholders[msg.sender];
        }

       function result(uint ID) public onlyChairperson returns(bool results){
            if(proposals[ID].sharesinagreement>(companyshares*50/100)){
                proposals[ID].passed = true;
                return proposals[ID].passed;
            }
            else return proposals[ID].passed;
       }

}