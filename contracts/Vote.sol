pragma solidity >= 0.4.0 < 0.8.0;

import "openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";

contract Vote {

    // Voter info
    struct Voter {
        string first_name;
        string last_name;
        uint id;
        bool party_vote; // true = Party P; false = Party O
    }

    // Event to update the front-end to show that a new voter has casted their vote.
    event voteCasted(uint id);

    // associate eth address to voter's id.
    mapping (uint => address) private voterToAddress;

    // vote counts for each party.
    mapping (bool => uint256) private partyCount;

    // voter's list.
    Voter[] internal voters;

    function castVote(string memory first, string memory last, uint id, bool party) public {
        // voters can only vote once.
        require(voterToAddress[id] == address(0));
        voterToAddress[id] = msg.sender;
        voters.push(Voter(first, last, id, party));
        partyCount[party]++;
        emit voteCasted(id);
    }

    // verifies the voter by their id
    modifier isRegisteredVoter(uint id) {
        require(voterToAddress[id] == msg.sender);
        _;
    }

    function getVote(uint id) public view isRegisteredVoter(id) returns (string memory) {
        for (uint i = 0; i < voters.length; i++) {
            if (voters[i].id == id) {
                return voters[i].party_vote ? "P" : "O";
            }
        }
    }

    function getCount(bool party) public view returns (uint256) {
        return partyCount[party];
    }

    function getVoterAddress(uint id) public view isRegisteredVoter(id) returns (address) {
        return voterToAddress[id];
    }
}