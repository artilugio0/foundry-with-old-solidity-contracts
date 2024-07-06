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

## Examples
- [Testing MakerDAO Vat wards](./test/Vat.t.sol) `pragma solidity ^0.6.12;`
- [Testing exploit script for Ethernaut AlienCodex](./test/AlienCodex.t.sol) `pragma solidity ^0.5.0;`
