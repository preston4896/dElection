var contract;

// Step 1: load web3
async function loadWeb3() {
    let web3Provider = null;

    // web3 compatible browsers
    if (window.ethereum) {
        web3Provider = window.ethereum;
        try {
            await window.ethereum.enable();
        }
        catch (error) {
            console.error("User denied account access.");
        }
    }
    
    // legacy browser
    else if (window.web3) {
        web3Provider = window.web3.currentProvider;
    }

    // no injected web3 browser, only works locally.
    else {
        web3Provider = new Web3.providers.HttpProvider("http://127.0.0.1:7545");
    }

    window.web3 = new Web3(web3Provider);
}

// Step 2: load the contract.
async function loadContract() {
    let contractInstance;
    await fetch("../../build/contracts/Vote.json")
        .then(response => response.json())
        .then(abi => {
            contractInstance = new window.web3.eth.Contract(abi);
        })
    return contractInstance;
}

async function load() {
    await loadWeb3();
    console.log(window.web3.version);
    contract = await loadContract();
    console.log("Loaded contract: ", contract);
    let count = await contract.methods.getCount().call();
    console.log("Test load getCount().",  count);
}

load();