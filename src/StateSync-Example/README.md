# **State Sync Example**

This example demonstrates how to **sync state across different blockchain networks** using **Omnikit’s `syncStates` function**.

---

## **📌 Overview**

In a multi-chain environment, sometimes a contract on **one chain** needs to update a contract on **another chain**. This example shows how to **synchronize a counter’s state** across chains.

- **`PrimaryCounter.sol`** (source chain): Updates and **broadcasts** the new value to other chains.
- **`Counter.sol`** (destination chain): **Receives** and applies the update while verifying the source.

✅ **Both contracts are deployed at the same address on different chains** using `CREATE3`.  
✅ You can also use the **Omni-Deployer package** for deployment: [`@omni-kit/omni-deployer`](https://www.npmjs.com/package/@omni-kit/omni-deployer).  
✅ Check the **deployment script** in: `script/StateSync/DeployCounter.s.sol`.

---

## **🛠 How It Works (Step-by-Step)**

### **1️⃣ PrimaryCounter updates the state and triggers syncStates**

- When `setNumber(newNumber)` is called:
  - It updates the `number` variable in **PrimaryCounter**.
  - It prepares the message using `abi.encodeCall(this.setNumber, (newNumber))`.
  - It specifies **which chain(s) should receive the update** (`chainIds` array).
  - Calls `syncStates(message, chainIds)`, which sends this message across the chains.

### **2️⃣ The message is sent to the destination chain**

- `syncStates()` **sends** the encoded message to the specified chain(s).

### **3️⃣ Counter receives the update and applies it**

- When the message arrives, `Counter.sol` **automatically executes `setNumber(newNumber)`**.
- Before applying the update, it calls `CrossChainUtils.validateCrossDomainCallback()` to verify that the request came from an authorized source.

### **4️⃣ The number is updated on Counter.sol**

- The `number` variable in `Counter.sol` is **updated with the new value** received from `PrimaryCounter.sol`.

---

## **📜 Smart Contracts & Functions**

### **📝 `PrimaryCounter.sol` (Source Chain)**

| Function                                                      | Purpose                                                           |
| ------------------------------------------------------------- | ----------------------------------------------------------------- |
| `setNumber(uint256 newNumber)`                                | Updates number and calls `syncStates` to send it to other chains. |
| `syncStates(bytes memory message, uint256[] memory chainIds)` | Sends the state update to the specified chain(s).                 |

### **📝 `Counter.sol` (Destination Chain)**

| Function                                        | Purpose                                                            |
| ----------------------------------------------- | ------------------------------------------------------------------ |
| `setNumber(uint256 newNumber)`                  | Receives and applies the state update.                             |
| `CrossChainUtils.validateCrossDomainCallback()` | Ensures the request is valid and originates from `PrimaryCounter`. |

---

## **🚀 Example Flow**

1. **On Chain A:**

   - `PrimaryCounter.setNumber(100);`
   - Calls `syncStates`, sending `100` to Chain B.

2. **On Chain B:**
   - `Counter.sol` receives the update.
   - `validateCrossDomainCallback()` ensures it’s from `PrimaryCounter`.
   - `number` is updated to `100`.

Now, the `number` variable is **synchronized across both chains**!
