// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "../Transparent_Proxy/ImplementationV1.sol";
import "../Transparent_Proxy/ImplementationV2.sol";
import "../Transparent_Proxy/TransparentProxy.sol";
import "forge-std/Vm.sol";

contract ImplementationV1Test is DSTest {
    ImplementationV1 implV1;
    TransparentProxy proxy;
    Vm vm = Vm(HEVM_ADDRESS);
    address user = address(1);
    address admin = address(this);

    function setUp() public {
        // deploy logic contract
        implV1 = new ImplementationV1();
        // deploy proxy contract and point it to implementation and set the admin
        proxy = new TransparentProxy(address(implV1), admin, "");
    }

    function testAdminCallToImplementationReverts() public {
        vm.expectRevert(
            "TransparentUpgradeableProxy: admin cannot fallback to proxy target"
        );

        ImplementationV1(address(proxy)).setMagicNumber(42);
    }

    function testUserCallToImplementationSucceeds() public {
        vm.startPrank(user, user);
        ImplementationV1(address(proxy)).setMagicNumber(42);

        // magic number should be 42
        uint256 magicNumber = ImplementationV1(address(proxy)).magicNumber();
        assertEq(magicNumber, 42);
    }
}

contract ImplementationV2Test is DSTest {
    ImplementationV1 implV1;
    ImplementationV2 implV2;
    TransparentProxy proxy;
    Vm vm = Vm(HEVM_ADDRESS);
    address user = address(1);
    address admin = address(this);

    function setUp() public {
        // old logic contract
        implV1 = new ImplementationV1();
        // deploy proxy contract and point it to implementation and set admin
        proxy = new TransparentProxy(address(implV1), admin, "");
        // set magic number via old impl contract for testing purposes
        vm.prank(user, user);
        ImplementationV1(address(proxy)).setMagicNumber(42);
        // deploy new logic contract
        implV2 = new ImplementationV2();
        // update proxy to new implementation contract
        proxy.upgradeTo(address(implV2));
    }

    function testMagicNumber() public {
        vm.prank(user, user);
        // proxy points to implV2, but magic value set via implV1 should still be valid, since storage from proxy contract is read
        uint256 magicNumber = ImplementationV1(address(proxy)).magicNumber();

        assertEq(magicNumber, 42);
    }

    function testMagicString() public {
        vm.startPrank(user, user);
        ImplementationV2(address(proxy)).setMagicString("Test");

        // magic string should be "Test"
        string memory magicString = ImplementationV2(address(proxy))
            .magicString();

        assertEq(magicString, "Test");
    }
}
