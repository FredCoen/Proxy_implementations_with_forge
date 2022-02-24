# UUPS Proxy

Manual implementation of the Universal Upgradeable Proxy Standard (UUPS) without using OpenZeppelin's Upgrade Plugin.

[Foundry](https://github.com/gakonst/foundry) is used as dev environment.

## What is an UUPS Proxy?

> The original proxies included in OpenZeppelin followed the https://blog.openzeppelin.com/the-transparent-proxy-pattern/[Transparent Proxy Pattern]. While this pattern is still provided, our recommendation is now shifting towards UUPS proxies, which are both lightweight and versatile. The name UUPS comes from https://eips.ethereum.org/EIPS/eip-1822[EIP1822], which first documented the pattern.

> While both of these share the same interface for upgrades, in UUPS proxies the upgrade is handled by the implementation, and can eventually be removed. Transparent proxies, on the other hand, include the upgrade and admin logic in the proxy itself. This means {TransparentUpgradeableProxy} is more expensive to deploy than what is possible with UUPS proxies.

> UUPS proxies are implemented using an {ERC1967Proxy}. Note that this proxy is not by itself upgradeable. It is the role of the implementation to include, alongside the contract's logic, all the code necessary to update the implementation's address that is stored at a specific slot in the proxy's storage space. This is where the {UUPSUpgradeable} contract comes in. Inheriting from it (and overriding the {xref-UUPSUpgradeable-\_authorizeUpgrade-address-}[`_authorizeUpgrade`] function with the relevant access control mechanism) will turn your contract into a UUPS compliant implementation.

(Text copied from [here](https://github.com/OpenZeppelin/openzeppelin-contracts-upgradeable/tree/master/contracts/proxy))

## Contracts

### UUPSProxy

Proxy contract, inherits from ERC1967Proxy. Delegates all calls to the implementation contract.

### Implementation

Implementation contract, upgradeability is given via UUPSUpgradeable.
Allows setting a magic number.

### ImplementationV2

Version 2 of the implementation contract, inherits from the original Implementation to prevent storage collisions.
Introduces magic strings.

## Deployment

1. Deploy your Implementation contract
2. Deploy your Proxy and point it to your Implementation contract
3. Initialize your Implementation contract through your Proxy contract (!!)

If you dont call the initialize function through your Proxy, variables like the owner will be stored in the Implementation storage instead of the Proxy storage. This means this information is lost after upgrading to a new implementation.

Upgrading to a new version:

1. Deploy new Implementation contract, which inherits from the old version
2. Call upgradeTo(address) function from old implementation through your proxy

See the test file for an example.

To run the tests, clone this repo and run

```
forge test
```

## More Info

### General

- [EIP-1822: UUPS](https://eips.ethereum.org/EIPS/eip-1822)
- [Proxy Upgrade Pattern](https://docs.openzeppelin.com/upgrades-plugins/1.x/proxies)
- [Writing Upgradeable Contracts](https://docs.openzeppelin.com/upgrades-plugins/1.x/writing-upgradeable)
- [Contract storage on inheritance](https://forum.openzeppelin.com/t/what-happens-with-contract-storage-on-contract-inheritance/677)
- [UUPS Proxy workshop](https://blog.openzeppelin.com/workshop-recap-deploying-more-efficient-upgradeable-contracts/)

### Contracts

- [Proxies Overview](https://docs.openzeppelin.com/contracts/3.x/api/proxy#UpgradeableProxy)
- [openzeppelin-contracts](https://github.com/OpenZeppelin/openzeppelin-contracts/tree/master/contracts)
- [openzeppelin-contracts-upgradeable](https://github.com/OpenZeppelin/openzeppelin-contracts-upgradeable/tree/master/contracts)
