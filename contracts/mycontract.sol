// SPDX-License-Identifier: UNLICENSED

// DO NOT MODIFY BELOW THIS
pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract Splitwise {
// DO NOT MODIFY ABOVE THIS

// ADD YOUR CONTRACT CODE BELOW
    mapping(address => mapping(address => uint32)) public table;

    function add_IOU(address creditor, uint32 amount, address[] calldata cycle) public{
        //Find the smallest amount on the path
        if (cycle.length == 0) {
            table[msg.sender][creditor] += amount;
            return;
        }

        uint32 min_amount = amount;
        for (uint i = 0; i < cycle.length - 1; i++) {
            uint32 n = table[cycle[i]][cycle[i + 1]];
            if (n < min_amount) {
                min_amount = n;
            }
        }

        // // reduce all values on the path by min_amount
        for (uint32 i = 0; i < cycle.length - 1; i++) {
            table[cycle[i]][cycle[i + 1]] -= min_amount;
        }
        amount -= min_amount;
        table[msg.sender][creditor] += amount;
    }

    // Returns the amount that the debtor owes the creditor.
    // debtor 欠 creditor 钱
    function lookup(address debtor, address creditor) public view returns (uint) {
        return table[debtor][creditor];
    }


}
