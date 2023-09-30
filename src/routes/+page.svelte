<script lang="ts">
	/* ------------------ IMPORTS ----------------- */
	// Libraries
	import { onMount } from 'svelte';
	import { ethers } from 'ethers';
	// Components
	import Button from '$lib/interface/Button.svelte';

	/* ----------------- VARIABLES ---------------- */
	let signer: ethers.Signer;
	let provider: ethers.providers.Web3Provider;

	/* ----------------- FUNCTIONS ---------------- */
	async function fetchProvider() {
		console.log('Run')

		provider = new ethers.providers.Web3Provider(window.ethereum);

		await provider.send('eth_requestAccounts', []);

		signer = provider.getSigner();

		console.log(provider, signer);
	}

	/* ------------------ RUNTIME ----------------- */
	onMount(() => {});
</script>

<div class="w-full h-full flex flex-row">
	<div class="w-1/5 h-full flex flex-col p-2 bg-zinc-900 shadow-inner shadow-neutral-950">
		<Button onClick={fetchProvider}>
			<h1>Connect MetaMask</h1>
		</Button>
	</div>
	<div class="h-full w-screen grow bg-zinc-800 shadow-inner shadow-neutral-950" />
</div>
