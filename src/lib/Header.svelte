<script lang="ts">
	/* ------------------ IMPORTS ----------------- */
	// Libraries
	import { provider, signer, connected, docks, ports, contractAddress } from '$lib/stores'
	import { onMount } from 'svelte'
	import { ethers } from 'ethers'
	import ABI from "./ABI.json"
    import portABI from "./portABI.json"
	// Components
	// ...

	/* ----------------- VARIABLES ---------------- */
    const contractABI = ABI // Replace with your contract's ABI

	/* ----------------- FUNCTIONS ---------------- */
	async function refresh() {
		if ($signer === null) return;
        
        const contract = new ethers.Contract($contractAddress, contractABI, $signer)
        const address = await $signer.getAddress();
        const portContractAddress = contract.ports(address)

        const portContract = new ethers.Contract(portContractAddress, portABI, $signer)
        const docksArray = await portContract.getAllDocks();
		
		const formattedDocks = docksArray.map((dock, index) => {
			// Format the data as per your requirements
			let source = dock.source === 0 ? "Random" : $ports.find((port) => port.id == dock.source)
			let conditions = "Nominal"; // Default value

			// You can add logic to determine conditions based on your requirements
			// For example, check the values of dock.level, dock.timeCreated, or dock.coolDownTime

			return {
				id: index,
				source: source,
				conditions: conditions,
			};
		});
		console.log(formattedDocks)
        // Display that trade has happened on the frontend
	}

	async function fetchProvider() {
		// Prevent unnecessary function calls
		if ($connected) return
		
		console.log('Fetching Provider: MetaMask')
		
		$provider = new ethers.providers.Web3Provider(window.ethereum)

		await $provider.send('eth_requestAccounts', [])

		$signer = $provider.getSigner()
		$connected = true

		console.log($provider, $signer)
	}

	/* ------------------ RUNTIME ----------------- */
	onMount(() => {})
</script>

<nav class="w-full h-auto flex flex-row items-center p-2 pl-4 p- gap-4 text-lg font-semibold bg-zinc-900">
	<h1 class="text-2xl font-bold">DecentPort</h1>
	<button class="w-auto h-auto p-2 pl-4 pr-4 ml-auto text-lg font-bold rounded-lg bg-transparent border-neutral-300 border-2" on:click={refresh}>
		<h2 class="text-neutral-300">Refresh</h2>
	</button>
	<button class="w-auto h-auto p-2 pl-4 pr-4 text-lg font-bold rounded-lg bg-transparent border-neutral-300 border-2" on:click={fetchProvider}>
		<h2 class={$connected ? "text-green-300" : "text-neutral-300"}>{ $connected ? "Connected" : "Connect to MetaMask" }</h2>
	</button>
</nav>
