class Graphics.Boiler extends Graphics.Common.Equipment {
	// Внутренние клипы
	private var silentWater:MovieClip;
	private var boiling:MovieClip;
	private var redSpiral:MovieClip;
	private var button:MovieClip;
	private var manometer:Graphics.Sensors.BoilerManometer;
	public function Boiler() {
		super();
		reset();
	}
	public function reset() {
		showClip(this.silentWater);
		hideClip(this.redSpiral);
		hideClip(this.button.buttonOff);
		hideClip(this.boiling);
		hideClip(this.manometer);
		this.manometer.reset();
		pause();
	}
	public function resetButInstruments():Void {
		var m = this.manometer._visible;
		reset();
		if(m) showManometer();
	}
	public function showWorking() {
		hideClip(this.silentWater);
		showClip(this.button.buttonOff);
		showClip(this.redSpiral);
		showClip(this.boiling);
		this.manometer.showVapor();
		correctState();
	}
	public function isWorking() {
		return this.redSpiral._visible;
	}
	public function showManometer() {
		showClip(this.manometer);
		correctState();
	}
	public function showMeasurement(p:Number) {
		this.manometer.showMeasurement(p);
		correctState();
	}
	public function isAllInstrumentsShown():Boolean {
		return this.manometer._visible;
	}
	public function isButtonOn():Boolean {
		return this.button.buttonOff._visible;
	}
	private function playAll() {
		playClip(this.redSpiral);
		playClip(this.boiling);
		this.manometer.play();
	}
	private function pauseAll() {
		stopClip(this.redSpiral);
		stopClip(this.boiling);
		this.manometer.pause();
	}
}
