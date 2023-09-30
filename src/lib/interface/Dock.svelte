<script lang="ts">
	/* ------------------ IMPORTS ----------------- */
	// Libraries
	// ...
	// Components
	// ...

	/* ----------------- VARIABLES ---------------- */
    // Props
    export let name: string
    // Internal
    const sections: string[] = ["Source", "Conditions", "Expected Value"]
    const values: any[] = ["Random", "Poor", `${0}$`]

	/* ----------------- FUNCTIONS ---------------- */


	/* ------------------ RUNTIME ----------------- */
	// onMount(() => {});
</script>

<div class="w-full h-auto bg-neutral-900 shadow-md shadow-neutral-950 rounded-md">
    <h1 class="w-full h-auto p-2 pl-4 bg-neutral-300 font-bold text-xl text-neutral-950 rounded-md">{ name }</h1>
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