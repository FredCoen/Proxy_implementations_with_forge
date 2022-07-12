// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

contract ImplementationV1 {
    uint256 public magicNumber;

    function setMagicNumber(uint256 newMagicNumber) public {
        magicNumber = newMagicNumber;
    }
}
