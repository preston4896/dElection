const Vote = artifacts.require("Vote");

contract("Vote", (accounts) => {
    let votes;
    let expectedId = 9696;
    let preston;
    
    // initialize the contract instance.
    before(async () => {
        votes = await Vote.deployed();
    })

    describe("Preston is going to cast a vote with his address.", async() => {
        before("Casting vote using accounts[0].", async() => {
            await votes.castVote("Preston", "Ong", expectedId, true, {from: accounts[0]});
            preston = accounts[0];
        })

        it("can fetch the correct ID by address", async() => {
            let returnedID = await votes.getVoterId(expectedId);
            assert.equal(returnedID, expectedId, "ID should match.");
        })

        it("should only show one vote.", async() => {
            let returnedCount = await votes.getCount(true);
            assert.equal(returnedCount, 1, "There should only be one vote.");
        })

        it("should show the correct party.", async() => {
            let returnedVote = await votes.getVote(expectedId);
            assert.equal(returnedVote, "P", "Preston voted for the Premocratic Party.");
        })
    })
})