import Config;
class Graphics.Glass extends Graphics.Common.Equipment {
	private var cover:MovieClip;
	private var splash:MovieClip;
	private var drops:MovieClip;
	private var levelSensor;
	//animations
	private var fullCoverHeight:Number;
	private var G:Number;         // Mass flow of the water, kg/s
	private var fillingpf:Number; // The increment of the water that is filling the glass per one frame, m^3/s
	private var cfilling:Number;  // Current filling of the glass
	public static var volume:Number = 0.0002; // The volume of the glass, m^3
	
	public function Glass() {
		this.fullCoverHeight = this.cover._height;
		setMassFlow(0);
		reset();
	}

	public function empty() {
		this.cfilling = 0;
	}
	
	public function setMassFlow(G:Number) {
		this.G = G;
		this.fillingpf = G/Config.FrameRate/1000;
		syncState();
	}
	public function getMassFlow():Number {
		return this.G;
	}
	public function showMeasurement() {
		showClip(this.levelSensor);
	}
	public function reset() {
		hideClip(this.levelSensor);
		setMassFlow(0);
		empty();
		pause();
	}
	private function pauseAll()
	{
		stopClip(this.drops);
		stopClip(this.splash);
	}
	private function playAll()
	{
		playClip(this.drops);
		playClip(this.splash);
	}
	private function onEnterFrame() {
		if (!this.isPaused) {
			if(this.cfilling < Glass.volume) this.cfilling += this.fillingpf;
			this.levelSensor.showMeasurement(this.cfilling);
		}
		syncState();
	}
	
	public function onWaterSpoiled():Void {
		if(this.splash._visible) setSpoilingMassFlow(this.G);
	}
	
	private function syncState() {
		// level of water
		this.cover._height = (Glass.volume - this.cfilling)/Glass.volume*this.fullCoverHeight;
		// drops visibility and position
		if(this.G > 0) showClip(this.drops); else { hideClip(this.drops); hideClip(this.splash); }
		this.drops._y = this.cover._height+this.cover._y;
		// splash visibility 
		if(this.cfilling > Glass.volume && this.G > 0) {
			if(!this.splash._visible) {
				showClip(this.splash); 
				this.splash.gotoAndStop("start"); 
				correctState();
			}
		} else {
			hideClip(this.splash);
			setSpoilingMassFlow(0);
		}
	}
	
	private function setSpoilingMassFlow(G:Number):Void {
		this.getOwner().onChangeSpoilingMassFlow(G);
	}
		
}
