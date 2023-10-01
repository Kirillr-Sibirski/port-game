<script lang="ts">
	/* ------------------ IMPORTS ----------------- */
	// Libraries
	import { ports, playerPortID } from '$lib/stores';
	import { onMount } from 'svelte';
	import { CanvasStyleProps } from './common';
	// Components
	// ...

	/* ----------------- VARIABLES ---------------- */
	// Canvas props
	let canvas: HTMLCanvasElement
	let ctx: CanvasRenderingContext2D|null
	let clientWidth: number
	let clientHeight: number

	let styleProps: CanvasStyleProps
	// Nodes
	const radius = 35;

	/* ----------------- FUNCTIONS ---------------- */
	function resize() {
		console.log('resize');

		canvas.width = clientWidth;
		canvas.height = clientHeight;

		// Redraw on canvas size change
		draw();
	}

	function draw() {
		if (ctx === null) return

		console.log("Drawing")

		if (styleProps === undefined) styleProps = new CanvasStyleProps(ctx)

		function _node(x: number, y: number, r=radius, c="white", l=2, f="#1f1f1f") {
			if (ctx === null) return

			styleProps.save()
			styleProps.overload([f, c, l])

			ctx.beginPath()
			ctx.arc(x, y, r, 0, 2 * Math.PI)
			ctx.stroke()
			ctx.closePath()

			styleProps.load()
		}

		function _text(msg: string="DEFAULT", x: number, y: number, f="white", l=2) {
			if (ctx === null) return

			styleProps.save()
			ctx.fillStyle = f
			ctx.lineWidth = l

			ctx.fillText(msg, x, y)

			styleProps.load()
		}

		ctx.fillStyle = '#1f1f1f';
		ctx.strokeStyle = 'white';
		ctx.lineWidth = 1;
		ctx.font = `${Math.floor(radius/2)}px sans`;

		ctx.beginPath();

		for (let i=0; i < $ports.length; i++) {
			const port = $ports[i];

			const x = (port.position.x / 100) * clientWidth;
			const y = (port.position.y / 100) * clientHeight;
			console.log(x, y);


			// ctx.moveTo(x + radius, y);
			_node(x, y, ($playerPortID == i) ? radius + 10 : radius);
			_text(port.name, x, y + 20)
		}

		ctx.stroke();
		ctx.closePath();
	}

	/* ------------------ RUNTIME ----------------- */
	$: (clientWidth, clientHeight) => resize(); // Update canvas on resize

	onMount(() => {
		ctx = canvas.getContext("2d");

		resize();
	});
</script>

<div
	class="grow shrink overflow-auto bg-zinc-950 shadow-inner shadow-neutral-950"
	bind:clientWidth
	bind:clientHeight
>
	<canvas bind:this={canvas} />
</div>
