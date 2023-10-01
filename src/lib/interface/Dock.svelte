<script lang="ts">
	/* ------------------ IMPORTS ----------------- */
	// Libraries
	import type { Dock } from "$lib/common"
	// Components
	// ...

	/* ----------------- VARIABLES ---------------- */
    // Props
    export let dock: Dock
    // Internal
    const sections: string[] = ["Source", "Conditions", "Expected Value"]
    const values: any[] = [dock.source, dock.conditions, "XX$"]

	/* ----------------- FUNCTIONS ---------------- */


	/* ------------------ RUNTIME ----------------- */
	// onMount(() => {});
</script>

<div class="w-full h-auto bg-neutral-900 shadow-md shadow-neutral-950 rounded-md">
    <h1 class="w-full h-auto p-2 pl-4 bg-neutral-300 font-bold text-xl text-neutral-950 rounded-md">{ `Dock #${dock.id}` }</h1>
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