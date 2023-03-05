// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import { AxelarExecutable } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/executable/AxelarExecutable.sol';
import { IAxelarGateway } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGateway.sol';
import { Round } from '../Round.sol';

contract AxelartrustedForwarder is AxelarExecutable {

    Round round;

    // TODO: make this a mapping of trusted forwarders
    string public trustedForwarder;

    address public trustedGateway;

    constructor(address gateway_) AxelarExecutable(gateway_) {
        trustedGateway = gateway_;
    }

    function init (
        address round_,
        string calldata trustedForwarder_
    ) public {
        round = Round(round_);
        trustedForwarder = trustedForwarder_;
    }

    function _execute(
        string calldata sourceChain_,
        string calldata sourceAddress_, // trustedForwarder
        bytes calldata payload_
    ) internal override {

        require(
            keccak256(abi.encodePacked(trustedForwarder)) ==
            keccak256(abi.encodePacked(sourceAddress_)),
            "not trusted forwarder"
        );

        (string memory id) = abi.decode(payload_, (string));

        require(msg.sender == trustedGateway, "not trusted gateway");

        round.applyToRound(id);

    }

}