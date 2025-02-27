# Interoperability Example

This example showcases cross-chain ERC20 token transfers using **Omnikit**.

## 📌 Overview

- **CrossChainDisperse.sol** enables seamless ERC20 token transfers across different chains.

## 🛠 How It Works

1. **transferERC20TokensToSingleChain()**

   - Transfers ERC20 tokens to multiple recipients on the same or a different chain.
   - Uses `CrossChainUtils.sendERC20ViaBridge()` for cross-chain transfers.
   - Sends a cross-chain message using `_sendCrossChainMessage()`, which delivers the necessary data to execute the function call on the destination chain."\*\*

2. **receiveERC20Tokens()**
   - Receives tokens on the destination chain and distributes them to recipients.
   - Uses `CrossChainUtils.validateCrossDomainCallback()` to verify the transaction.
