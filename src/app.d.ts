// See https://kit.svelte.dev/docs/types#app
// for information about these interfaces
import type { providers } from "ethers"

declare global {
	namespace App {
		
	}
	interface Window {
		ethereum: providers.ExternalProvider | providers.JsonRpcFetchFunc
	}
}

export { };
