<script lang="ts">
	import type { MouseEventHandler } from "svelte/elements";

    export let onClick: MouseEventHandler<HTMLButtonElement>
</script>

<button class="w-full h-auto p-2 text-xl rounded-lg bg-transparent border-neutral-300 border-2" on:click={onClick}>
    <slot/>
</button>