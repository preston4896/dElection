pragma solidity ^0.6.0;

import "openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";

contract Vote {

    // Voter info
    struct Voter {
        string first_name;
        string last_name;
        uint8 id;
        bool party_vote; // true = Party P; false = Party O
    }

    // Event to update front-end that a new voter has casted their vote.
    event voteCasted(uint8 id);

    // associate eth address to voter's id.
    mapping (address => uint8) public addressToVoter;

    // vote counts for each party.
    mapping (bool => uint256) public partyCount;

    // voter's list.
    Voter[] internal voters;

    function castVote(string memory first, string memory last, uint8 id, bool party) public {
        // voters can only vote once.
        require(addressToVoter[msg.sender] == 0);
        addressToVoter[msg.sender] = id;
        voters.push(Voter(first, last, id, party));
        partyCount[party]++;
        emit voteCasted(id);
    }

    // verifies the voter by their id
    modifier isRegisteredVoter(uint8 id) {
        require(addressToVoter[msg.sender] == id);
        _;
    }

    function getVote(uint8 id) public view isRegisteredVoter(id) returns (string memory) {
        for (uint i = 0; i < voters.length; i++) {
            if (voters[i].id == id) {
                return voters[i].party_vote ? "P" : "O";
            }
        }
    }

    function getPartyCount(bool inputParty) public view returns (uint256) {
        return partyCount[inputParty];
    }
}