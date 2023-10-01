<script lang="ts">
	import type { MouseEventHandler } from "svelte/elements";

    export let onClick: MouseEventHandler<HTMLButtonElement>
</script>

<button class="w-full h-14 p-2 text-xl text-neutral-950 font-bold rounded-lg bg-neutral-300" on:click={onClick}>
    <slot/>
</button>