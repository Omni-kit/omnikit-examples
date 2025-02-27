# **Omnikit Examples**  

This repository contains **practical examples** demonstrating how to use Omnikit for **cross-chain communication and state synchronization**.  

## **📁 Structure**  
Each example is stored in a separate folder:  

1. **StateSync-Example** – Demonstrates cross-chain state synchronization.  
2. **Interop-Example** – Shows how to transfer ERC20 tokens across chains.  

---

## **🚀 Examples Overview**  

### **1️⃣ State Sync Example (`StateSync-Example/`)**  
📌 **Goal:** Synchronize a counter’s state across multiple chains.  

**Contracts:**  
- `PrimaryCounter.sol` – Updates the counter and syncs the value across chains.  
- `Counter.sol` – Receives the update and applies the new value.  

**Key Features:**  
✅ Uses `syncStates()` to send state updates to another chain.  
✅ Validates updates with `CrossChainUtils.validateCrossDomainCallback()`.  
✅ Ensures both contracts are deployed at the **same address** across chains using `CREATE3` or [Omni Deployer](https://www.npmjs.com/package/@omni-kit/omni-deployer).  
✅ Deployment script: [`script/StateSync/DeployCounter.s.sol`](script/StateSync/DeployCounter.s.sol).  

---

### **2️⃣ Interop Example (`Interop-Example/`)**  
📌 **Goal:** Transfer ERC20 tokens across chains using Omnikit.  

**Contract:**  
- `CrossChainDisperse.sol` – Handles token transfers and ensures cross-chain execution.  

**Key Features:**  
✅ Transfers ERC20 tokens across chains via Omnikit’s `sendERC20ViaBridge()`.  
✅ Uses `_sendCrossChainMessage()` to call functions on another chain.  
✅ Supports multi-chain token distribution with `disperseTokens()`.  

---

## **📌 Getting Started**  
### **1️⃣ Install Dependencies**    
```sh
forge install
```  
### **2️⃣ Compile the Contracts**  
```sh
forge build
```  
### **3️⃣ Run Tests**  
```sh
forge test
```  
