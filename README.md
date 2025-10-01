Blockchain Voting Smart Contract

This project implements a secure and transparent voting system using Ethereum smart contracts (Solidity). It ensures that each registered voter can cast only one vote, and results are counted automatically on-chain.

Features

Voter Registration – Each voter is registered with details like name, age, gender, voterId, and wallet address.

Candidate Registration – Candidates are registered with party name, age, gender, and candidateId.

Secure Voting – A voter can vote only once, and their choice is permanently recorded on the blockchain.

Vote Counting – The contract keeps track of votes for each candidate.

Transparency – All data is publicly accessible on-chain, preventing fraud or manipulation.

Contract Structure
Structs

Voter

struct Voter {
    string name;
    uint age;
    uint voterId;
    Gender gender;
    uint voterCandidateId;
    address voterAddress;
}


Candidate

struct Candidate {
    string name;
    string party;
    uint age;
    Gender gender;
    uint candidateId;
}

Enums

enum Gender { male, female, other }
Functions

addVoter(string memory _name, uint _age, uint _voterId, Gender _gender, address _voterAddress) → Register a new voter

addCandidate(string memory _name, string memory _party, uint _age, Gender _gender) → Register a new candidate

vote(uint _voterId, uint _candidateId) → Cast a vote for a candidate

getVotes(uint _candidateId) → Get the vote count of a candidate

getCandidateList() → View all candidates
