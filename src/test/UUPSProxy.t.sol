// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "../UUPS_Proxy/ImplementationV1.sol";
import "../UUPS_Proxy/ImplementationV2.sol";
import "../UUPS_Proxy/UUPSProxy.sol";

contract ImplementationV1Test is DSTest {
    ImplementationV1 implV1;
    UUPSProxy proxy;

    function setUp() public {
        // deploy logic contract
        implV1 = new ImplementationV1();
        // deploy proxy contract and point it to implementation
        proxy = new UUPSProxy(address(implV1), "");
        // initialize implementation contract
        address(proxy).call(abi.encodeWithSignature("initialize()"));
    }

    function testInitialize() public {
        (bool s, bytes memory returnedData) = address(proxy).call(
            abi.encodeWithSignature("owner()")
        );
        address owner = abi.decode(returnedData, (address));

        // owner should be this contract
        assertEq(owner, address(this));
    }

    function testMagicNumber() public {
        address(proxy).call(
            abi.encodeWithSignature("setMagicNumber(uint256)", 42)
        );

        // magic number should be 42
        (bool a, bytes memory data) = address(proxy).call(
            abi.encodeWithSignature("magicNumber()")
        );
        assertEq(abi.decode(data, (uint256)), 42);
    }
}

contract ImplementationV2Test is DSTest {
    ImplementationV1 implV1;
    ImplementationV2 implV2;
    UUPSProxy proxy;

    function setUp() public {
        // old logic contract
        implV1 = new ImplementationV1();
        // deploy proxy contract and point it to implementation
        proxy = new UUPSProxy(address(implV1), "");
        // initialize implementation contract
        address(proxy).call(abi.encodeWithSignature("initialize()"));
        // set magic number via old impl contract for testing purposes
        address(proxy).call(
            abi.encodeWithSignature("setMagicNumber(uint256)", 42)
        );
        // deploy new logic contract
        implV2 = new ImplementationV2();
        // update proxy to new implementation contract
        (bool a, bytes memory data) = address(proxy).call(
            abi.encodeWithSignature("upgradeTo(address)", address(implV2))
        );
    }

    function testMagicNumber() public {
        // proxy points to implV2, but magic value set via impl should still be valid, since storage from proxy contract is read
        (bool a, bytes memory data) = address(proxy).call(
            abi.encodeWithSignature("magicNumber()")
        );
        assertEq(abi.decode(data, (uint256)), 42);
    }

    function testMagicString() public {
        address(proxy).call(
            abi.encodeWithSignature("setMagicString(string)", "Test")
        );

        // magic string should be "Test"
        (bool a, bytes memory data) = address(proxy).call(
            abi.encodeWithSignature("magicString()")
        );
        assertEq(abi.decode(data, (string)), "Test");
    }
}
