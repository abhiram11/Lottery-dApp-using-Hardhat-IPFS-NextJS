// SPDX-License-Identifier: MIT

 //Steps of Lottery App
//  Participate in the lottery by paying some amount
// Pick GENUINELY RANDOM winner
// Winner selected every X minutes = completely automated
// Chainlink Oracle -> Randomness + Automated Execution using Chainlink Keeper

pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

error Lottery__NotEnoughETHEntered();

contract Lottery is VRFConsumerBaseV2 {

    //state variables = storage
    uint256 private immutable i_entranceFee;
    address payable[] private s_players;

    //events
    event participatedEvent(address indexed player);

    constructor(address vrfCoordinatorV2, uint256 entranceFee) VRFConsumerBaseV2(vrfCoordinatorV2) {
        i_entranceFee = entranceFee;
    }

    function getEntranceFee() public view returns(uint256) {
        return i_entranceFee;
    }


    function lotteryParticipate() public payable {

        if (msg.value < i_entranceFee) {
            // revert the whole transaction using error code
            // so GAS EFFICIENT instead of storing string
            revert Lottery__NotEnoughETHEntered();
        }

        s_players.push(payable(msg.sender));
        // emit and event (both have same name) when we update a dynamic array like s_players
        emit participatedEvent(msg.sender);
    }

    function getPlayer(uint256 index) public view returns(address) {
        return s_players[index];
    }

    //here we need Chainlink VRF v2 and Keepers
    // Steps: Go to chainlink, connect Metamask wallet, add Goerli Testnet and LINK
    // Create Subscription, Add funds
    // Create Consumer, add consumer contract with address = VRFv2Consumer.sol contract 

    // we call 2 txn process, so remove hackablility, manipulation, etc. if only one txn
    // 1) requestRandomWinner
    // 2) fulfillRandomWords (VRF ki method hai)

    function requestRandomWinner() external { //external are a bit cheaper than PUBLIC functions
        // called by chainlink Keepers automatically (automated)

    }

    //here, words still means numbers
    // "override" function of THIS CONTRACT <=> "virtual" function of INHERITED CONTRACT
    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal override {}

}