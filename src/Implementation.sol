// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import "openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";
import "openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";

contract Implementation is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    uint256 magicNumber;

    function initialize() public initializer {
        __Ownable_init();
    }

    function setMagicNumber(uint256 newMagicNumber) public {
        magicNumber = newMagicNumber;
    }

    function getMagicNumber() public view returns (uint256) {
        return magicNumber;
    }

    // override from UUPSUpgradeable, added onlyOwner modifier for access control
    function _authorizeUpgrade(address) internal override onlyOwner {}
}

// inherit from previous implementation contract to prevent storage collisions
contract ImplementationV2 is Implementation {
    string magicString;

    function setMagicString(string memory newMagicString) public {
        magicString = newMagicString;
    }

    function getMagicString() public view returns (string memory) {
        return magicString;
    }
}