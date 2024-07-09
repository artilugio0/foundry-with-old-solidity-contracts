// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {VmSafe} from "forge-std/Vm.sol";

contract VatTest is Test {
    IVat internal vat;

    function setUp() public {
        bytes memory targetCode = vm.getCode("out/vat.sol/Vat.json");
        address addr;

        assembly {
            addr := create(0, add(targetCode, 32), mload(targetCode))
        }

        vat = IVat(addr);
    }

    function test_deployerIsWard() public {
        assertEq(vat.wards(address(this)), 1);
    }

    function test_notDeployerIsNotWardByDefault() public {
        VmSafe.Wallet memory someWallet = vm.createWallet("someWallet");

        assertEq(vat.wards(someWallet.addr), 0);
    }

    function test_relyAddsWard() public {
        VmSafe.Wallet memory someWallet = vm.createWallet("someWallet");

        vat.rely(someWallet.addr);
        assertEq(vat.wards(someWallet.addr), 1);
    }
}

interface IVat {
    function wards(address) external view returns (uint256);
    function rely(address) external;
}
