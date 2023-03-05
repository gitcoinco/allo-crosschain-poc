// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import { AxelarExecutable } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/executable/AxelarExecutable.sol';
import { IAxelarGasService } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGasService.sol';
import "../interfaces/IApplicationForwarder.sol";
import "../RoundApplicationPayload.sol";

contract AxelarApplicationSender is IApplicationForwarder, AxelarExecutable {
    address projectRegistry;
    IAxelarGasService public immutable gasService;

    constructor(address _projectRegistry, address _gateway, address _gasReceiver) AxelarExecutable(_gateway) {
        projectRegistry = _projectRegistry;
        gasService = IAxelarGasService(_gasReceiver);
    }

    function applyToRound(RoundApplicationPayload memory _payload) payable external {
        require(msg.sender == projectRegistry, "only the project registry can call applyToRound");

        bytes memory data = abi.encode(_payload.value);
        if (msg.value > 0) {
            gasService.payNativeGasForContractCall{ value: msg.value }(
                address(this),
                _payload.destinationChain,
                _payload.destinationAddress,
                data,
                msg.sender
            );
        }

        gateway.callContract(_payload.destinationChain, _payload.destinationAddress, data);
    }
}
