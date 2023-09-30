<script lang="ts">
	/* ------------------ IMPORTS ----------------- */
	// Libraries
	import { provider, signer, connected } from '$lib/stores'
	import { onMount } from 'svelte'
	import { ethers } from 'ethers'
	// Components
	// ...

	/* ----------------- VARIABLES ---------------- */


	/* ----------------- FUNCTIONS ---------------- */
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

<nav class="w-full h-16 flex flex-row items-center p-2 pl-4 p- gap-4 text-lg font-semibold bg-zinc-900">
	<h1 class="text-2xl font-bold">DecentPort</h1>
	<button class="w-auto h-14 p-2 pl-4 pr-4 ml-auto text-lg font-bold rounded-lg bg-neutral-300" on:click={fetchProvider}>
		<h2 class={$connected ? "text-green-500" : "text-neutral-950"}>{ $connected ? "Connected" : "Connect to MetaMask" }</h2>
	</button>
</nav>
