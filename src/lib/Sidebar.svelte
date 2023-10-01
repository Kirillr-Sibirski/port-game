<script lang="ts">
    /* ------------------ IMPORTS ----------------- */
	// Libraries
    import { provider, signer, ports, playerPortID, docks } from "$lib/stores"
    import { ethers } from "ethers"
    import ABI from "./ABI.json"
	// Components
	import Button from "./interface/Button.svelte"
	import Dock from "./interface/Dock.svelte"

	/* ----------------- VARIABLES ---------------- */


	/* ----------------- FUNCTIONS ---------------- */
    function executeTrade() {}

    async function initializePort() {
        if ($signer === null) return;
        
        const contractAddress = '0x39BFd7EF3C5478915d183f93aF7EaAbC554b1CA0' // Replace with your contract's address
        const contractABI = ABI // Replace with your contract's ABI
        const contract = new ethers.Contract(contractAddress, contractABI, $signer)
        
        $playerPortID = 0
        // Port name
        // $ports[$playerPortID].name

        const tx = await contract.deployChildContract();
        // Wait for the transaction to be mined
        const receipt = await tx.wait();
        // You can access contract events or other information from the receipt
        console.log('Transaction receipt:', receipt);
    }

	/* ------------------ RUNTIME ----------------- */
	// onMount(() => {});
</script>

<div class="w-1/5 h-full flex flex-col p-2 gap-6 bg-zinc-900 shadow-inner shadow-neutral-950">
    <Button onClick={executeTrade}>
        <h1 class="text-neutral-950">Trade</h1>
    </Button>
    <Button onClick={initializePort}>
        <h1 class="text-neutral-950">Intialize Port</h1>
    </Button>
    <div class="w-full h-full flex flex-col gap-6 overflow-scroll">
        {#each $docks as dock}
            <Dock dock={dock}/>
        {/each}
    </div>
</div>