import { readable, writable, type Readable, type Writable } from "svelte/store"
import type { Signer, providers } from "ethers"
import type { Port, Dock } from "./common"

// Ethers
export const provider:  Writable<providers.Web3Provider|null> = writable(null)
export const signer:    Writable<Signer|null>                 = writable(null)
export const connected: Writable<boolean>                     = writable()

// Game
export const ports: Readable<Port[]> = readable([
    {id:0, name: "Center",         position: {x: 50, y: 50}, coordinate: {lat: 1, lon: 1}},
    {id:1, name: "Random Port #1", position: {x: 10, y: 10}, coordinate: {lat: 1, lon: 1}},
    {id:2, name: "Random Port #2", position: {x: 10, y: 70}, coordinate: {lat: 1, lon: 1}},
    {id:3, name: "Random Port #3", position: {x: 70, y: 5},  coordinate: {lat: 1, lon: 1}},
    {id:4, name: "Random Port #4", position: {x: 45, y: 27}, coordinate: {lat: 1, lon: 1}},
])

export const playerPortID: Writable<number|null> = writable(0)
export const docks:  Writable<Dock[]>            = writable([])
export const range:  Writable<number>            = writable(10)
