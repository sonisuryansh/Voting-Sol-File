// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Vote{
    struct Voter {
        string name;
        uint age;
        uint voterId;
        Gender gender;
        uint voterCandidateId;
        address voterAddress;
    }

    struct Candidate{
        string name ;
        string party;
        uint age;
        Gender gender;
        uint candidateId;
        address candidateAddress;
        uint votes;
    }

    address public electionCommission;
    address public winner ;
    uint nextVoterId = 1;
    uint nextCandidateId = 1;


    uint startTime;
    uint endTime;
    bool stopVoting;


    mapping(uint => Voter) voterDetails ;
    mapping(uint => Candidate) candidateDetails ;

    enum VotingStatus {NotStarted , Inprogress, Ended}
    enum Gender {NotSpecified , Male , Female ,Other }

    constructor(){
        electionCommission = msg.sender;
    }

    modifier isVotingOver (){
        require(block.timestamp<=endTime && stopVoting ==false , "Voting time is Over");
        _;
    }

    modifier onlyCommissioner (){
        require(msg.sender==electionCommission, "Not Authurized");
        _;
    }

    modifier isValidAge(uint _age){
        require (_age >=18 , "not eligible for Voting");
        _;
    }

    function registerCandidate(string calldata _name, string calldata _party, uint _age, Gender _gender)external isValidAge(_age){

            require (isCandidateNotRegistered(msg.sender),"You are already registered");
            require (nextCandidateId<3,"Candidate Registration Full");
            require (msg.sender!= electionCommission,"Election Commission not allowed to register");

            candidateDetails[nextCandidateId]= Candidate({
                name : _name,
                party:_party,
                age:_age,
                gender:_gender,
                candidateId : nextCandidateId,
                candidateAddress:msg.sender, 
                votes :0
            });

            nextCandidateId++;
    }

    function isCandidateNotRegistered(address _person) private view returns (bool){
        for(uint i=1;i<nextCandidateId;i++){
            if(candidateDetails[i].candidateAddress==_person){
                return false;
            }
        }
        return true;
    }

    function getCandidateList() public view returns(Candidate[] memory){
        Candidate [] memory candidateList = new Candidate[](nextCandidateId-1);
        for(uint i = 0;i< candidateList.length;i++){
            candidateList[i] = candidateDetails[i+1];
        }
        return candidateList;
    }

    function isVoterNotRegistered (address _person) private view returns(bool){
        for(uint i=1;i<nextVoterId;i++){
            if(voterDetails[i].voterAddress == _person){
                return false;
            }
        }
        return true;
    }

    function registerVoter(string calldata _name, uint _age, Gender _gender) external isValidAge (_age){
        require(isVoterNotRegistered(msg.sender),"You are already Registered");
        voterDetails [nextVoterId] = Voter({
            name:_name,age : _age, voterId : nextVoterId, gender : _gender, voterCandidateId:0, voterAddress:msg.sender 
        });
        nextVoterId++;
    }


    function getVoterList() public view returns (Voter[] memory){
        uint lengthArr = nextVoterId-1;
        Voter[] memory voterList = new Voter[](lengthArr);
        for(uint i = 0 ; i<voterList.length;  i++){
            voterList[i] = voterDetails[i+1];
        }
        return voterList;
    }

    function castVote (uint _voterId, uint _candidateId) external isVotingOver(){
        require(block.timestamp>= startTime ,"Voting has not started yet");
        require(voterDetails[_voterId].voterCandidateId ==0 ,"You have already voted ");
        require(voterDetails[_voterId].voterAddress == msg.sender,"You are not authorized");
        require(_candidateId>=1 && _candidateId <3 ,"Camdidate Id is not Correct ");
        voterDetails [_voterId].voterCandidateId = _candidateId ;
        candidateDetails[_candidateId].votes++;
    }


    function setVotingPeriod(uint _startTimeDuration, uint _endTimeDuration) external onlyCommissioner(){
        require (_endTimeDuration>3600,"_endTimeDuration must be greater than 1 Hour");
        startTime = 1720799550+_startTimeDuration;
        endTime = startTime+_endTimeDuration;
    }

    function getVotingStatus() public view returns (VotingStatus){
        if(startTime == 0){
            return VotingStatus.NotStarted;
        }else if (endTime>block.timestamp && stopVoting == false){
            return VotingStatus.Inprogress;
        }else{
            return VotingStatus.Ended;
        }
    }


    function announceVotingResult() external onlyCommissioner(){
        uint max = 0;
        for(uint i = 1; i<nextCandidateId;i++){
            if(candidateDetails[i].votes>max){
                max= candidateDetails[i].votes;
                winner= candidateDetails[i].candidateAddress;
            }
        }
    }

    function emergencyStopVotin() public onlyCommissioner(){
        stopVoting = true;
    }


}