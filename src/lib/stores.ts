import { readable, writable, type Readable, type Writable } from "svelte/store"
import type { Signer, providers } from "ethers"

// Ethers
export const provider:  Writable<providers.Web3Provider|null> = writable(null)
export const signer:    Writable<Signer|null>                 = writable(null)
export const connected: Writable<boolean>                     = writable()

// Game
export const docks: Readable<{id: number, name:string, zone:string}[]> = readable([
    {id: 0, name: "Rotterdam", zone: "Europe"},
    {id: 1, name: "Some random NA dock", zone: "NorthAmerica"},
    {id: 2, name: "Qingdao", zone: "Asia"},
])