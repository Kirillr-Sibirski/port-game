<script>
  import "../app.css"; // Permit usage of TailwindCSS throughout the project
  import Header from "$lib/Header.svelte";
</script>

<div class="w-screen h-screen flex flex-col">
  <Header />
  <slot />
</div>
