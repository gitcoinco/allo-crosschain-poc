// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "../RoundApplicationPayload.sol";

interface IApplicationForwarder {
    function applyToRound(RoundApplicationPayload memory payload) payable external;
}
