// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import "openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";
import "openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";

contract ImplementationV1 is
    Initializable,
    UUPSUpgradeable,
    OwnableUpgradeable
{
    uint256 public magicNumber;

    function initialize() public initializer {
        __Ownable_init();
    }

    function setMagicNumber(uint256 newMagicNumber) public {
        magicNumber = newMagicNumber;
    }

    /**
     * @dev override from UUPSUpgradeable, added onlyOwner modifier for access control. Called by
     * {upgradeTo} and {upgradeToAndCall}.
     *
     */
    function _authorizeUpgrade(address) internal override onlyOwner {}
}
