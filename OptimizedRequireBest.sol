// SPDX-License-Identifier: MIT

// @author - @deltartificial

pragma solidity 0.8.15;

// OPTIMIZED : 26 226 gas
contract OptimizedRequire {

    uint8 constant COOLDOWN = 0x3c;
    uint256 lastPurchaseTime = 0x1; // star with a non-zero value

    function purchaseToken() external payable {
        assembly {

            // require(msg.value == 0.1 ether);
            if iszero(
                eq(callvalue(), 0x16345785d8a0000)
            ) {
                revert(0, 0)
            }

            // require(block.timestamp > lastPurchaseTime + COOLDOWN,"cannot purchase");
            let blocktimestamp := timestamp()
            let lastPurchase := sload(lastPurchaseTime.slot)

            if gt(add(lastPurchase, COOLDOWN), blocktimestamp) {
                revert(0, "cannot purchase")
            }
            sstore(lastPurchaseTime.slot, blocktimestamp)
        }
        // mint the user a token
    }
}