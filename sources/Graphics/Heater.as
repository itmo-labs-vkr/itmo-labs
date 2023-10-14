class Graphics.Heater extends Graphics.Common.Equipment {
	private var redSpiral:MovieClip;
	private var vapor:MovieClip;
	private var burning:MovieClip;
	private var button:MovieClip;
	private var burned:Boolean;
	private var wattmeter:Graphics.Sensors.Wattmeter;
	private var loses:MovieClip;
	private var thermoSensor1:MovieClip;
	private var thermoSensor2:MovieClip;
	private var zone1:MovieClip;
	private var zone2:MovieClip;
	public function Heater() {
		super();
		reset();
	}
	public function reset() {
		this.vapor.reset();
		hideClip(this.redSpiral);
		hideClip(this.burning);
		this.burning.gotoAndStop(1);
		this.burned = false;
		hideClip(this.button.buttonOff);
		hideClip(this.wattmeter);
		this.wattmeter.reset();
		hideClip(this.loses);
		hideClip(this.thermoSensor1);
		hideClip(this.thermoSensor2);
		this.thermoSensor1.reset();
		this.thermoSensor2.reset();
		pause();
	}
	public function showVapor() {
		this.vapor.showAsVapor();
		correctState();
	}
	public function showWorking() {
		showClip(this.redSpiral);
		showClip(this.button.buttonOff);
		correctState();
	}
	public function isWorking() {
		return this.redSpiral._visible;
	}
	public function showBurning() {
		showClip(this.burning);
		correctState();
	}
	public function showTemperatureSensorAt(p:Tiles.StagePoint) {
		if(this.zone1.hitTest(p.x, p.y, true))
			showClip(this.thermoSensor1);
		if(this.zone2.hitTest(p.x, p.y, true))
			showClip(this.thermoSensor2);
		correctState();
	}
	public function showTemperature1(t:Number) {
		this.thermoSensor1.showMeasurement(t);
	}
	public function showTemperature2(t:Number) {
		this.thermoSensor2.showMeasurement(t);
	}
	public function showWattmeter() {
		showClip(this.wattmeter);
		correctState();
	}
	public function resetButInstruments():Void {
		var i = isAllInstrumentsShown();
		reset();
		if(i) {
			showClip(this.thermoSensor1);
			showClip(this.thermoSensor2);
			showWattmeter();
		}
	}
	public function showMeasurement(w:Number) {
		this.wattmeter.showMeasurement(w);
		correctState();
	}
	public function isAllInstrumentsShown():Boolean {
		return this.thermoSensor1._visible && this.thermoSensor2._visible && this.wattmeter._visible;
	}
	public function showLoses(w:Number) {
		this.loses.showMeasurement(w);
		showClip(this.loses);
		correctState();
	}
	private function playAll() {
		playClip(this.vapor);
		if(!this.burned)
			playClip(this.burning);
		playClip(this.loses);
	}
	private function pauseAll() {
		stopClip(this.vapor);
		if(!this.burned)
			stopClip(this.burning);
		stopClip(this.loses);
		this.thermoSensor1.pause();
		this.thermoSensor2.pause();
	}
	private function onBurnedDown() {
		this.burned = true;
		if(this.burning._visible)
			this.getOwner().getLab().onHeaterBurned();
		this.thermoSensor1.play();
		this.thermoSensor2.play();
	}
}
