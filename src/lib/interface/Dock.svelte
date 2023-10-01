<script lang="ts">
	/* ------------------ IMPORTS ----------------- */
	// Libraries
    import { provider, signer, ports, playerPortID, docks, contractAddress } from "$lib/stores"
    import portABI from ".././portABI.json"
	import type { Dock } from "$lib/common"
    import { ethers } from "ethers"
    import ABI from ".././ABI.json"
	// Components
	import Button from "./Button.svelte"

	/* ----------------- VARIABLES ---------------- */
    // Props
    export let dock: Dock
    // Internal
    const sections: string[] = ["Source", "Conditions", "Expected Value"]
    const values: any[] = [dock.source, dock.conditions, "XX$"]

	/* ----------------- FUNCTIONS ---------------- */
    const contractABI = ABI
    
    async function executeTrade() {
        if ($signer === null) return;
        
        const contract = new ethers.Contract($contractAddress, contractABI, $signer)
        const address = await $signer.getAddress();
        const portContractAddress = contract.ports(address)

        const portContract = new ethers.Contract(portContractAddress, portABI, $signer)
        await portContract.trade(dock.id);
        // Display that trade has happened on the frontend
    }

    async function upgradeDock() {
        if ($signer === null) return;
        
        const contract = new ethers.Contract($contractAddress, contractABI, $signer)
        const address = await $signer.getAddress();
        const portContractAddress = contract.ports(address)

        const portContract = new ethers.Contract(portContractAddress, portABI, $signer)
        await portContract.upgradeDock(dock.id);
        // Display upgraded dock on frontend on success
    }

	/* ------------------ RUNTIME ----------------- */
	// onMount(() => {});
</script>

<div class="w-full h-auto bg-neutral-900 shadow-md shadow-neutral-950 rounded-md">
    
    <h1 class="w-full h-auto p-2 pl-4 bg-neutral-300 font-bold text-xl text-neutral-950 rounded-md">{ `Dock #${dock.id}` }</h1>
    <Button onClick={executeTrade}><h1 class="text-neutral-950">Trade</h1></Button>
    <Button onClick={upgradeDock}><h1 class="text-neutral-950">Upgrade</h1></Button>
    <div class="text-lg">
        <table class="pt-3 p-2 flex flex-col gap-2">
            {#each sections as section, i}
                <tr class="flex flex-row">
                    <td>{`${section}:`}</td>
                    <td class="ml-auto">{values[i]}</td>
                </tr>
            {/each}
        </table>
    </div>
</div>