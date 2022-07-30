![](cover.png)

**A set of challenges to hack implementations of DeFi in Ethereum.**
Featuring flash loans, price oracles, governance, NFTs, lending pools, smart contract wallets, timelocks, and more!

Created by [@tinchoabbate](https://twitter.com/tinchoabbate)

## Levels

### **1 - Unstoppable [ X ]**

    There's a lending pool with a million DVT tokens in balance, offering flash loans for free.
    If only there was a way to attack and stop the pool from offering flash loans...
    You start with 100 DVT tokens in balance.

[Article with detailed explanation](https://medium.com/@juanxaviervalverde/damn-vulnerable-defi-unstoppable-level-1-solution-a1a31a632996)

### **2 - Naive receiver [ X ]**

    There's a lending pool offering quite expensive flash loans of Ether, which has 1000 ETH in balance.
    You also see that a user has deployed a contract with 10 ETH in balance, capable of interacting with the lending pool and receiveing flash loans of ETH.
    Drain all ETH funds from the user's contract. Doing it in a single transaction is a big plus ;)

[Article with detailed explanation](https://medium.com/@juanxaviervalverde/damn-vulnerable-defi-naive-receiver-level-2-solution-17d6a4763c7b)

### **3 - Truster [ X ]**

    More and more lending pools are offering flash loans. In this case, a new pool has launched that is offering flash loans of DVT tokens for free.
    Currently the pool has 1 million DVT tokens in balance. And you have nothing.
    But don't worry, you might be able to take them all from the pool. In a single transaction.

[Article with detailed explanation](https://medium.com/@juanxaviervalverde/damn-vulnerable-defi-truster-level-3-solution-3a08d34ad07b)

### **4 - Side entrance [ X ]**

    A surprisingly simple lending pool allows anyone to deposit ETH, and withdraw it at any point in time.
    This very simple lending pool has 1000 ETH in balance already, and is offering free flash loans using the deposited ETH to promote their system.
    You must take all ETH from the lending pool.

[Article with detailed explanation](https://medium.com/@juanxaviervalverde/damn-vulnerable-defi-side-entrance-level-4-solution-8d76d4d629e1)

### **5 - The rewarder [ X ]**

    There's a pool offering rewards in tokens every 5 days for those who deposit their DVT tokens into it.
    Alice, Bob, Charlie and David have already deposited some DVT tokens, and have won their rewards!
    You don't have any DVT tokens. But in the upcoming round, you must claim most rewards for yourself.
    Oh, by the way, rumours say a new pool has just landed on mainnet. Isn't it offering DVT tokens in flash loans?

[Article with detailed explanation](https://medium.com/@juanxaviervalverde/damn-vulnerable-defi-the-rewarder-level-5-solution-b0b94079cce1)

### **6 - Selfie [ X ]**

    A new cool lending pool has launched! It's now offering flash loans of DVT tokens.
    Wow, and it even includes a really fancy governance mechanism to control it.
    What could go wrong, right ?
    You start with no DVT tokens in balance, and the pool has 1.5 million. Your objective: take them all.

[Article with detailed explanation]()

### **7 - Compromised [ X ]**

    While poking around a web service of one of the most popular DeFi projects in the space, you get a somewhat strange response from their server. This is a snippet:

> HTTP/2 200 OK  
> content-type: text/html  
> content-language: en  
> vary: Accept-Encoding  
> server: cloudflare
>
> 4d 48 68 6a 4e 6a 63 34 5a 57 59 78 59 57 45 30 4e 54 5a 6b 59 54 59 31 59 7a 5a 6d 59 7a 55 34 4e 6a 46 6b 4e 44 51 34 4f 54 4a 6a 5a 47 5a 68 59 7a 42 6a 4e 6d 4d 34 59 7a 49 31 4e 6a 42 69 5a 6a 42 6a 4f 57 5a 69 59 32 52 68 5a 54 4a 6d 4e 44 63 7a 4e 57 45 35
>
> 4d 48 67 79 4d 44 67 79 4e 44 4a 6a 4e 44 42 68 59 32 52 6d 59 54 6c 6c 5a 44 67 34 4f 57 55 32 4f 44 56 6a 4d 6a 4d 31 4e 44 64 68 59 32 4a 6c 5a 44 6c 69 5a 57 5a 6a 4e 6a 41 7a 4e 7a 46 6c 4f 54 67 33 4e 57 5a 69 59 32 51 33 4d 7a 59 7a 4e 44 42 69 59 6a 51 34

    A related on-chain exchange is selling (absurdly overpriced) collectibles called "DVNFT", now at 999 ETH each.
    This price is fetched from an on-chain oracle, and is based on three trusted reporters:
    - 0xA73209FB1a42495120166736362A1DfA9F95A105
    - 0xe92401A4d3af5E446d93D11EEc806b1462b39D15
    - 0x81A5D6E50C214044bE44cA0CB057fe119097850c
    Starting with only 0.1 ETH in balance, you must steal all ETH available in the exchange.

[Article with detailed explanation]()

### **8 - Puppet [ X ]**

    There's a huge lending pool borrowing Damn Valuable Tokens (DVTs), where you first need to deposit twice the borrow amount in ETH as collateral. The pool currently has 100000 DVTs in liquidity.
    There's a DVT market opened in an Uniswap v1 exchange, currently with 10 ETH and 10 DVT in liquidity.
    Starting with 25 ETH and 1000 DVTs in balance, you must steal all tokens from the lending pool.

[Article with detailed explanation]()

### **9 - Puppet v2 [ X ]**

    The developers of the last lending pool are saying that they've learned the lesson. And just released a new version!
    Now they're using a Uniswap v2 exchange as a price oracle, along with the recommended utility libraries. That should be enough.
    You start with 20 ETH and 10000 DVT tokens in balance. The new lending pool has a million DVT tokens in balance. You know what to do ;)

[Article with detailed explanation]()

### **10 - Free rider [ ]**

    A new marketplace of Damn Valuable NFTs has been released! There's been an initial mint of 6 NFTs, which are available for sale in the marketplace. Each one at 15 ETH.
    A buyer has shared with you a secret alpha: the marketplace is vulnerable and all tokens can be taken. Yet the buyer doesn't know how to do it. So it's offering a payout of 45 ETH for whoever is willing to take the NFTs out and send them their way.
    You want to build some rep with this buyer, so you've agreed with the plan.
    Sadly you only have 0.5 ETH in balance. If only there was a place where you could get free ETH, at least for an instant.

[Article with detailed explanation]()

### **11 - Backdoor [ ]**

    To incentivize the creation of more secure wallets in their team, someone has deployed a registry of Gnosis Safe wallets. When someone in the team deploys and registers a wallet, they will earn 10 DVT tokens.
    To make sure everything is safe and sound, the registry tightly integrates with the legitimate Gnosis Safe Proxy Factory, and has some additional safety checks.
    Currently there are four people registered as beneficiaries: Alice, Bob, Charlie and David. The registry has 40 DVT tokens in balance to be distributed among them.
    Your goal is to take all funds from the registry. In a single transaction.

[Article with detailed explanation]()

### **12 - Climber [ ]**

    There's a secure vault contract guarding 10 million DVT tokens. The vault is upgradeable, following the UUPS pattern.
    The owner of the vault, currently a timelock contract, can withdraw a very limited amount of tokens every 15 days.
    On the vault there's an additional role with powers to sweep all tokens in case of an emergency.
    On the timelock, only an account with a "Proposer" role can schedule actions that can be executed 1 hour later.
    Your goal is to empty the vault.

[Article with detailed explanation]()

### **13 - Safe Miners [ ]**

    Somebody has sent +2 million DVT tokens to 0x79658d35aB5c38B6b988C23D02e0410A380B8D5c. But the address is empty, isn't it?
    To pass this challenge, you have to take all tokens out.
    You may need to use prior knowledge, safely.

[Article with detailed explanation]()

## Play

Visit [damnvulnerabledefi.xyz](https://damnvulnerabledefi.xyz)

## Disclaimer

All Solidity code, practices and patterns in this repository are DAMN VULNERABLE and for educational purposes only.

DO NOT USE IN PRODUCTION.
