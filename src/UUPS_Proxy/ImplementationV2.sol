// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "./ImplementationV1.sol";

/// @dev inherit from previous implementation contract to prevent storage collisions
contract ImplementationV2 is ImplementationV1 {
    string public magicString;

    function setMagicString(string memory newMagicString) public {
        magicString = newMagicString;
    }
}
