// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./RoundApplicationPayload.sol";
import "./interfaces/IApplicationForwarder.sol";

contract Registry {
    address public owner;
    uint256 public nextProjectID;

    mapping(address => bool) public trustedForwarders;

    // id => owner
    mapping(uint256 => address) public projects;

    constructor()  {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function createProject() external {
        uint256 id = nextProjectID++;
        projects[id] = msg.sender;
    }

    function updateForwarder(address _addr, bool _active) external onlyOwner {
        trustedForwarders[_addr] = _active;
    }

    function applyToRound(address _applicationForwarder, RoundApplicationPayload memory _payload) external {
        require(trustedForwarders[_applicationForwarder] == true, "unknown application sender");
        require(projects[_payload.projectID] == msg.sender, "not project owner");

        IApplicationForwarder(_applicationForwarder).applyToRound(_payload);
    }
}
