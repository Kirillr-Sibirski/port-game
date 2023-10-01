<script lang="ts">
    /* ------------------ IMPORTS ----------------- */
	// Libraries
    import { provider, signer, ports, playerPortID, docks, contractAddress, money, level } from "$lib/stores"
    import { ethers } from "ethers"
    import ABI from "./ABI.json"
    import portABI from "./portABI.json"
	// Components
	import Button from "./interface/Button.svelte"
	import Dock from "./interface/Dock.svelte"

	/* ----------------- VARIABLES ---------------- */
    let initializing = false
    const contractABI = ABI // Replace with your contract's ABI
    var addressPort;

	/* ----------------- FUNCTIONS ---------------- */
    async function refresh() {
		if ($signer === null) return;
        
        const contract = new ethers.Contract($contractAddress, contractABI, $signer)
        const address = await $signer.getAddress();
        const portContractAddress = contract.ports(address)

        const portContract = new ethers.Contract(portContractAddress, portABI, $signer)
        const docksArray = await portContract.getAllDocks()
		const bMoney = await portContract.money()
		const bLevel = await portContract.level()
		
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

		$docks = formattedDocks
		$money = bMoney
		$level = bLevel
	}

    async function initializePort() {
        if ($signer === null) return;
        
        const contract = new ethers.Contract($contractAddress, contractABI, $signer)
        
        const portID = 0

        const tx = await contract.deployChildContract();
        initializing = true
        // Wait for the transaction to be mined
        const receipt = await tx.wait();
        if (receipt.status === 1) {
            console.log('PortContract created! Transaction was successful!');
            // You can access contract events or other information from the receipt
            console.log('Transaction receipt:', receipt);
            const address = await $signer.getAddress();
            console.log('Address: ', address);
            const portContractAddress = await contract.ports(address)
            addressPort = portContractAddress;
            console.log('Port contract address: ', portContractAddress);
            const portContract = new ethers.Contract(portContractAddress, portABI, $signer)
            console.log("Initialized port contract: ", portContract);
            // Send username, continent id, and first source
            await portContract.mint($ports[portID].name, portID, 2);
            $playerPortID = portID

            refresh()
        } else {
            console.log('Transaction failed.');
            initializing = false
        }
    }

    async function buyDock() {
        if ($signer === null) return;
        
        const contract = new ethers.Contract($contractAddress, contractABI, $signer)
        const address = await $signer.getAddress();
        console.log("!!!!! Signer address", address)
        const portContractAddress = await contract.ports(address)
        console.log("!!!!! Address Port: ", portContractAddress)

        const portContract = new ethers.Contract(portContractAddress, portABI, $signer)
        console.log("!!!! Port contract initialization: ", portContract);
        await portContract.buyDock()
        console.log(portContract)
        // Display new dock on frontend on success

        refresh()
    }

	/* ------------------ RUNTIME ----------------- */
	// onMount(() => {});
</script>

<div class="w-1/5 h-full flex flex-col p-2 gap-6 bg-zinc-900 shadow-inner shadow-neutral-950">
    {#if $playerPortID===undefined}
        <Button onClick={initializePort}>
            <h1 class="text-neutral-300 font-semibold">{initializing ? "Initializing..." : "Intialize Port"}</h1>
        </Button>
    {:else}
        <h1 class="w-full h-auto p-2 text-xl text-center text-neutral-950 font-bold rounded-lg bg-neutral-300">My Port</h1>
        <Button onClick={buyDock}><h1 class="text-neutral-300 font-semibold">Buy Dock</h1></Button>
    {/if}
    <div class="w-full h-full flex flex-col gap-6 overflow-scroll">
        {#each $docks as dock}
            <Dock dock={dock}/>
        {/each}
    </div>
</div>