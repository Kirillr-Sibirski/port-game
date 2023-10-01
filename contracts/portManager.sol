// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./portNFT.sol";

contract PortManager {
    mapping(address => address) public ports;

    // Function to deploy the child contract
    function deployChildContract() public returns (PortNFT) {
        PortNFT newChildContract = new PortNFT(msg.sender);
        ports[msg.sender] = address(newChildContract);
        return newChildContract;
    }
}
