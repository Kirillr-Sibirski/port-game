interface Port {
    id: number
    name: string,
    position: {x: number, y: number},
    coordinate: {lat: number, lon: number},
}

interface Dock {
    id: number,
    source: number,
    conditions: "Nominal"|"Degraded"|"Poor",
}

class CanvasStyleProps {
    ctx: CanvasRenderingContext2D
    saved: boolean = false
    fillStyle?
    strokeStyle?
    lineWidth?

    constructor(ctx: CanvasRenderingContext2D) {
        this.ctx = ctx
    }

    public load() {
        this._load()
    }

    public save() {
        this._save()
    }

    public overload(array: any[]) {
        this._overload(array)
    }

    private _load() {
        if (!this.saved) return
        
        this.ctx.fillStyle = this.fillStyle
        this.ctx.strokeStyle = this.strokeStyle
        this.ctx.lineWidth = this.lineWidth
        
        this.saved = false
    }

    private _save() {
        this.fillStyle = this.ctx.fillStyle
        this.strokeStyle = this.ctx.strokeStyle
        this.lineWidth = this.ctx.lineWidth

        this.saved = true
    }

    private _overload(array: any[]) {
        this._save();

        [this.fillStyle, this.strokeStyle, this.lineWidth] = array
    }
}

export { CanvasStyleProps }
export type { Port, Dock }
