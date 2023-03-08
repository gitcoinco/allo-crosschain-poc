// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./RoundApplicationPayload.sol";
import "./interfaces/IApplicationForwarder.sol";

contract Registry {
    address public owner;
    uint256 public nextProjectID;

    mapping(address => bool) public trustedForwarders;

    event ProjectCreated(uint256 id);

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
        emit ProjectCreated(id);
    }

    function updateForwarder(address _addr, bool _active) external onlyOwner {
        trustedForwarders[_addr] = _active;
    }

    function applyToRound(address payable _applicationForwarder, RoundApplicationPayload memory _payload) payable public {
        require(trustedForwarders[_applicationForwarder] == true, "unknown application sender");
        require(projects[_payload.projectID] == msg.sender, "not project owner");

        IApplicationForwarder(_applicationForwarder).applyToRound{value: msg.value}(_payload);
    }
}
