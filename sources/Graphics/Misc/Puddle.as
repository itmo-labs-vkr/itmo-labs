class Graphics.Misc.Puddle extends Graphics.Common.Clip {
	private var drops:MovieClip;
	private var startDelay = 2; // in seconds
	private var startCount:Number;
	private var m3PerStep = 0.001;
	private var count:Number;
	private var G:Number;
	private var eps = 1.e-9;
	public function Puddle() {
		super();
		reset();
	}
	public function setMassFlow(G:Number):Void {
		this.G = G;
		if(G > this.eps) {
			showClip(this.drops);
			if(!this._visible) {
				this._visible = true;
				this.play();
			}
		} else {
			hideClip(this.drops);
		}
	}
	public function moveAlongX(x:Number):Void {
		this._x = x;
	}
	public function reset() {
		this._visible = false; // every Graphics.Common.Clip is paused by default
		this.gotoAndStop(1);
		this.startCount = 0;
		this.count = 0;
		this.setMassFlow(0);
	}
	private function pauseAll() {
		stopClip(this.drops);
	}
	private function playAll() {
		playClip(this.drops);
	}
	public function onEnterFrame() {
		if(!this.isPaused && this.G > this.eps) {
			if(this.startCount < this.startDelay * Config.FrameRate) {
				this.startCount++;
				this.gotoAndStop(1);
			} else {
				if(this._currentframe < this._totalframes - 1) {
					this.count += this.G;
					if (this.count > this.m3PerStep) {
						this.gotoAndStop(this._currentframe+1);
						this.count = 0;
					}
				} else {
					this.gotoAndStop(this._currentframe);
				}
			}
		} else {
			this.gotoAndStop(this._currentframe);
		}
	}

}