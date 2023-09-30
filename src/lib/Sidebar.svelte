<script lang="ts">
	import Button from "./interface/Button.svelte"
    /* ------------------ IMPORTS ----------------- */
	// Libraries
	import { docks } from "./stores"
	// Components
	import Dock from "./interface/Dock.svelte"

	/* ----------------- VARIABLES ---------------- */
    const dockIDs: number[] = [0, 2]

	/* ----------------- FUNCTIONS ---------------- */


	/* ------------------ RUNTIME ----------------- */
	// onMount(() => {});
</script>

<div class="w-1/5 h-full flex flex-col p-2 gap-6 bg-zinc-900 shadow-inner shadow-neutral-950">
    <Button onClick={() => {}}>
        <h1 class="text-xl">Trade</h1>
    </Button>
    <div class="w-full h-full flex flex-col gap-6 overflow-scroll">
        {#each dockIDs as id}
            <Dock name={$docks[id].name}/>
        {/each}
    </div>
</div>