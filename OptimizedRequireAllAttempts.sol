// SPDX-License-Identifier: MIT

// @author - @deltartificial

pragma solidity 0.8.15;


// NON-OPTIMIZED : 43 392 gas
contract Require {
    uint256 constant COOLDOWN = 1 minutes;
    uint256 lastPurchaseTime;

    function purchaseToken() external payable {
        require(
            msg.value == 0.1 ether &&
                block.timestamp > lastPurchaseTime + COOLDOWN,
            "cannot purchase"
        );
        lastPurchaseTime = block.timestamp;
        // mint the user a token
    }
}

// OPTIMIZED : 26 292 gas
contract OptimizedRequire1 {

    uint8 constant COOLDOWN = 60;
    uint256 lastPurchaseTime = 1; // star with a non-zero value

    function purchaseToken() external payable {
        require(
            msg.value == 0.1 ether &&
                block.timestamp > lastPurchaseTime + COOLDOWN,
            "cannot purchase"
        );
        lastPurchaseTime = block.timestamp;
        // mint the user a token
    }
}

// OPTIMIZED : 26 284 gas
contract OptimizedRequire2 {

    uint8 constant COOLDOWN = 60;
    uint256 lastPurchaseTime = 1; // star with a non-zero value

    function purchaseToken() external payable {
        require(msg.value == 0.1 ether);
        require(block.timestamp > lastPurchaseTime + COOLDOWN,"cannot purchase");
        lastPurchaseTime = block.timestamp;
        // mint the user a token
    }
}

// OPTIMIZED : 26 226 gas
contract OptimizedRequire3 {

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
