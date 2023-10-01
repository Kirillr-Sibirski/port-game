import { readable, writable, type Readable, type Writable } from "svelte/store"
import type { Signer, providers } from "ethers"
import type { Port, Dock } from "./common"

// Ethers
export const provider:  Writable<providers.Web3Provider|null> = writable(null)
export const signer:    Writable<Signer|null>                 = writable(null)
export const connected: Writable<boolean>                     = writable()

export const contractAddress : Readable<string> = readable("0xA81807c8d684C75B9Aef5312324510A90fa51b7e")

// Game
export const ports: Readable<Port[]> = readable([
    {id:0, name: "Rotterdam",         position: {x: 50, y: 50}, coordinate: {lat: 1, lon: 1}},
    {id:1, name: "New York", position: {x: 10, y: 10}, coordinate: {lat: 1, lon: 1}},
    {id:2, name: "Santos", position: {x: 10, y: 70}, coordinate: {lat: 1, lon: 1}},
    {id:3, name: "Shanghai", position: {x: 70, y: 85},  coordinate: {lat: 1, lon: 1}},
    {id:4, name: "Barcelona", position: {x: 45, y: 27}, coordinate: {lat: 1, lon: 1}},
])

export const playerPortID: Writable<number> = writable()
export const docks:        Writable<Dock[]> = writable([])
export const money:        Writable<number> = writable(0)
export const level:        Writable<number> = writable(0)
// export const range:        Writable<number> = writable(10)
