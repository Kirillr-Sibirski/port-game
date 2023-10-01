<script lang="ts">
	/* ------------------ IMPORTS ----------------- */
	// Libraries
	import { ports, playerPortID, docks } from '$lib/stores';
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
		if (ctx === undefined || ctx === null) return;
		if (styleProps === undefined) styleProps = new CanvasStyleProps(ctx);

		function _node(x: number, y: number, r=radius, c="white", l=2, f="#1f1f1f") {
			if (ctx === null) return

			styleProps.save()
			ctx.strokeStyle = c
			ctx.fillStyle = f
			ctx.lineWidth = l

			ctx.beginPath()
			ctx.arc(x, y, r, 0, 2 * Math.PI)
			ctx.stroke()
			ctx.fill()
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

		function _line(x1, y1, x2, y2, s="white", l=2) {
			if (ctx === null) return

			styleProps.save()
			ctx.strokeStyle = s
			ctx.lineWidth = l
			
			ctx.beginPath()
			ctx.moveTo(x1, y1)
			ctx.lineTo(x2, y2)
			ctx.stroke()
			ctx.closePath()

			styleProps.load()
		}

		ctx.clearRect(0, 0, clientWidth, clientHeight)

		ctx.fillStyle = '#1f1f1f';
		ctx.strokeStyle = 'white';
		ctx.lineWidth = 1;
		ctx.font = `${Math.floor(radius/2)}px Roboto`;

		// Set 'own' port variables
		let sx, sy, sport
		if ($playerPortID != null) {
			sport = $ports.find((port) => port.id == $playerPortID)
			console.log("player port", sport)

			sx = (sport.position.x / 100) * clientWidth
			sy = (sport.position.y / 100) * clientHeight
		}

		// If no port initialized, do not draw connections
		if ($playerPortID != null) {
			for (let i=0; i < $ports.length; i++) {
				const port = $ports[i];
				if (port.id == sport.id) continue;
				
				const x = (port.position.x / 100) * clientWidth;
				const y = (port.position.y / 100) * clientHeight;
				const color = ($docks.find(dock => dock.source.id == port.id)) ? "white" : "grey"

				_line(sx, sy, x, y, color)
			}
		}

		// Draw nodes for each port
		for (let i=0; i < $ports.length; i++) {
			console.log($ports, $ports[i])
			const port = $ports[i];

			const x = (port.position.x / 100) * clientWidth;
			const y = (port.position.y / 100) * clientHeight;
			let r = radius

			if (sport != null && port.id === sport.id) {
				r += 10
				_node(sx, sy, r, "green", 4)
			} else {
				_node(x, y)
			}

			const msg = port.name
			const width = ctx.measureText(msg).width
			_text(`${port.name}`, x-width/2, y+r+15)
		}
	}

	/* ------------------ RUNTIME ----------------- */
	$: (clientWidth, clientHeight) => resize() // Update canvas on resize
	$: $ports, $playerPortID, draw()

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
