# State Sync Example  

This example demonstrates how to sync state across chains using **Omnikit**.  

## 📌 Overview  
- `PrimaryCounter.sol` updates and syncs state across chains.  
- `Counter.sol` receives state updates and validates cross-chain callbacks.  

## 🛠 How It Works  
1. `PrimaryCounter.sol` updates `number` and calls `syncStates` to propagate changes.  
2. `Counter.sol` receives updates and validates them with `CrossChainUtils.validateCrossDomainCallback()`.  

## 📜 Smart Contracts  
- **PrimaryCounter.sol**: Sends state updates to other chains.  
- **Counter.sol**: Receives updates and updates its state accordingly.  
