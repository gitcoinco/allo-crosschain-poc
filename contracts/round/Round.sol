// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Round {

    mapping(string => string) public applications;

    mapping(address => bool) public trustedReceivers;

    // update trusted reciever for each cross chain protocol
    function setTrustedReciever(address trustedReciverAddress) public {
        trustedReceivers[trustedReciverAddress] = true;
    }

    // apply to round via trusted reciever or assume registry and round are on same chain
    function applyToRound(string calldata id) external {

        require(trustedReceivers[msg.sender], "not trusted reciever");
        
        applications[id] = "PENDING";
        
    }

}
