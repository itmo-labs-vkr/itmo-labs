import Config;
class Graphics.Tank extends Graphics.Common.Equipment {
	private var water_bypass:MovieClip;
	private var spoiling_water:MovieClip;
	private var water:MovieClip;
	private var valve:MovieClip;
	private var levelSensor:MovieClip;
	
	//private var delta:Number;private var filling:Boolean;
	public static var volume:Number = 0.005;
	//m^3
	private var G:Number;
	private var fillingpf:Number;
	private var cfilling:Number;
	
	private var fullCoverHeight:Number;
	private var spoilingWaterFrame:Number;
	
	public function Tank() {
		this.spoilingWaterFrame = 1;
		this.fullCoverHeight = this.water.cover._height;
		reset();
	}
	
	public function setMassFlow(G:Number) {
		this.G = G;
		this.fillingpf = this.G/Config.FrameRate/1000;
		syncState();
	}
	
	public function onEnterFrame() {
		if(!this.isPaused) {
			if(this.valve._currentframe == 1 && this.cfilling < Tank.volume) this.cfilling += this.fillingpf;
			this.levelSensor.showMeasurement(this.cfilling);
		}
		syncState();
	}
	
	public function onWaterSpoiled() {
		this.getOwner().onChangeSpoilingMassFlow(this.G);
	}
	
	private function syncState() {
		// level of water
		this.water.cover._height = (Tank.volume - this.cfilling)/Tank.volume*this.fullCoverHeight;
		// splashing water visibility and position
		if(this.G > 0) showClip(this.water.splashing_water); else hideClip(this.water.splashing_water);
		this.water.splashing_water._y = this.water.cover._height+this.water.cover._y-this.water.splashing_water._height;
		// spoiling visibility 
		if(this.cfilling > Tank.volume && this.G > 0) {
			if(!this.spoiling_water._visible) {
				showClip(this.spoiling_water); 
				this.spoilingWaterFrame = 2;
				correctState();
			}
		} else hideClip(this.spoiling_water);
		// bypass water
		if(this.valve._currentframe == 2 && this.G > 0) showClip(this.water_bypass); else hideClip(this.water_bypass);
		// water stream 
		if(this.G > 0 && this.valve._currentframe == 1) showClip(this.water.stream); else hideClip(this.water.stream);
	}
	
	public function closeBypass() {
		this.valve.gotoAndStop("closed");
	}
	public function showMeasurement() {
		showClip(this.levelSensor);
	}
	public function reset() {
		this.cfilling = 0;
		setMassFlow(0);
		this.valve.gotoAndStop("opened");
		hideClip(this.levelSensor);
		pause();
	}
		
	private function pauseAll() {
		stopClip(this.water);
		this.spoilingWaterFrame = this.spoiling_water._currentframe;
		stopClip(this.spoiling_water);
		stopClip(this.water_bypass);
	}
	private function playAll() {
		playClip(this.water);
		playClip(this.water_bypass);
		this.spoiling_water.gotoAndPlay(this.spoilingWaterFrame-1);
	}
}
