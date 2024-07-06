## Testing contracts written in old Solidity versions with Foundry

The following step by step shows how to test a contract written in Solidity versions not compatible with Foundry's standard library.

1. Add the following entry to `foundry.toml`:
```toml
fs_permissions = [
  { access = "read", path = "./out/Contract.sol"},
]
```
Where `Contract.sol` is the name of the file under the directory `./src/` that will be tested.

2. Use the following sample code to deploy the contract in your test files:
```solidity
bytes memory targetCode = vm.getCode("out/Contract.sol/Contract.json");
address addr;

assembly {
    addr := create(0, add(targetCode, 32), targetCode)
}
```

3. Define an interface to access the contract methods
```solidity
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {VmSafe} from "forge-std/Vm.sol";

contract ContractTest is Test {
    IContract internal target;

    function setUp() public {
        bytes memory targetCode = vm.getCode("out/Contract.sol/Contract.json");
        address addr;

        assembly {
            addr := create(0, add(targetCode, 32), targetCode)
        }

        target = IContract(addr);
    }

    function test_stuff() public {
        target.doStuff();

        assertEq(target.getStuff(), 100);
    }
}

interface IContract {
    function doStuff() external;
    function getStuff() external view returns (uint256);
}
```

## Examples
- [Testing MakerDAO Vat wards](./test/Vat.t.sol) `pragma solidity ^0.6.12;`
- [Testing exploit script for Ethernaut AlienCodex](./test/AlienCodex.t.sol) `pragma solidity ^0.5.0;`
