## The purpose of this repo is to showcase deploying and testing various proxy patterns with [forge](https://github.com/foundry-rs/foundry/tree/master/forge)

OZ provides plugins for both truffle and hardhat to automize proxy deployments and upgrades, as well as running security checks to prevent commong mistakes that might happen in the process. Until forge has built in logic to handle this similarly, this repo guides you through deploying and upgrading your proxies with [forge](https://github.com/foundry-rs/foundry/tree/master/forge) and highlights what you need to be wary of. It is a fork and continuation of beskay's [UUPS_Proxy](https://github.com/beskay/UUPS_Proxy) implementation, intended to have all proxy patterns implemented in a single repository.

### Covered proxies include

- [EIP-1822: UUPS](https://eips.ethereum.org/EIPS/eip-1822)
- [Transparent Proxy pattern](https://blog.openzeppelin.com/the-transparent-proxy-pattern/)

## Why proxies?

> By design, smart contracts are immutable. On the other hand, software quality heavily depends on the ability to upgrade and patch source code in order to produce iterative releases. Even though blockchain based software profits significantly from the technology’s immutability, still a certain degree of mutability is needed for bug fixing and potential product improvements. More details here: https://docs.openzeppelin.com/upgrades-plugins/1.x/proxies

## Upgrading through proxies

> The basic idea is using a proxy for upgrades. The first contract is a simple wrapper or "proxy" which users interact with directly and is in charge of forwarding transactions to and from the second contract, which contains the logic. The key concept to understand is that the logic contract can be replaced while the proxy, or the access point is never changed. More details here: https://docs.openzeppelin.com/upgrades-plugins/1.x/proxies

## Function clashing

The issue which different proxy patterns solve differently is about function clashing between the proxy and implmentation contracts. The solidity compiler prevents two functions with the same function selectors to coexist within the same contract, howwever it does not between contracts. Hence there is the risk that a call intended to be forwarded via delegatecall to the logic/implementation contract actually executes a function that happens to have the same selector in the proxy contract, leading to unforeseen consequences.

### Different approaches to solve funciton clashing

### Transaparent Proxy

The transparent proxy pattern solves this by offering a dynamic interface depending on wheather a regular user or the owner permissioned to upgrade the system is calling.

https://docs.openzeppelin.com/contracts/4.x/api/proxy#transparent_proxy

Advantages:

- Solves function clashing

Disatvantages:

- Expensive run time gas cost (SLOAD for every call to check if owner is calling and redirect accrodingly)

### UUPS Proxy

The UUPS proxy pattern solves this by not having any upgrading functions onn the proxy contract but on the implementaion itself. Meaning the proxy doesn't include any functionality besides forwarding every incoming call to the implementaion. When the upgrading function is called on the implementation the delegatecall mechanism allows that newly appointed implementation contract to be persistently stored in the proxy.

Advantages:

- Solves function clashing
- Runtime storage savings (no SLOAD on who is calling the contract)
- More flexibility with regards to upgrading functionality (can be implemented differently with every upgrade)

Disatvantages:

- Risk of forgetting to include upgrading logic in new implementation thereby making your protocol immutable

### Deployment

## Transaparent Proxy

1. Deploy your Implementation contract
2. Deploy your Proxy, point it to your Implementation contract and set the admin

Upgrading to a new version:

1. Deploy new Implementation contract, which inherits from the old version
2. Call upgradeTo(address) function on the proxy from admin

See the test file for an example.

To run the tests, clone this repo and run

```
forge test --match-path src/test/TransparentProxy.t.sol
```

## UUPSProxy

1. Deploy your Implementation contract
2. Deploy your Proxy and point it to your Implementation contract
3. Initialize your Implementation contract through your Proxy contract (!!)

If you dont call the initialize function through your Proxy, variables like the owner will be stored in the Implementation storage instead of the Proxy storage. This means this information is lost after upgrading to a new implementation.

**Note**: In the example implementation of this repository V2 of the implementation contract, inherits from the original Implementation V1 to prevent storage collisions. It introduces magic strings.

Upgrading to a new version:

1. Deploy new Implementation contract, which inherits from the old version
2. Call upgradeTo(address) function from old implementation through your proxy

See the test file for an example.

To run the tests, clone this repo and run

```
forge test --match-path src/test/UUPSProxy.t.sol
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
