<script lang="ts">
	import type { MouseEventHandler } from "svelte/elements";

    export let onClick: MouseEventHandler<HTMLButtonElement>
</script>

<button class="w-full h-14 p-2 text-lg font-bold rounded-lg bg-neutral-900 shadow-inner shadow-zinc-950" on:click={onClick}>
    <slot/>
</button>