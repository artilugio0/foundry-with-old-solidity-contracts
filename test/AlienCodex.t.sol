// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {VmSafe} from "forge-std/Vm.sol";
import {IAlienCodex, exploit} from "../script/AlienCodexExploit.s.sol";

contract AlienCodexTest is Test {
    IAlienCodex internal target;

    function setUp() public {
        VmSafe.Wallet memory deployer = vm.createWallet("deployer");

        bytes memory targetCode = vm.getCode("out/AlienCodex.sol/AlienCodex.json");
        address addr;

        vm.prank(deployer.addr);
        assembly {
            addr := create(0, add(targetCode, 32), targetCode)
        }
        vm.stopPrank();

        target = IAlienCodex(addr);
    }

    function test_exploit() public {
        exploit(target, address(this));
        assertEq(target.owner(), address(this));
    }
}
