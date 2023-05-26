class Graphics.Chamber extends Graphics.Common.Equipment {
	private var pressureSensor:Graphics.Sensors.ChamberManometer;
	private var thermoSensor:Graphics.Sensors.ChamberTemperatureSensor;
	private var vapor:MovieClip;
	
	public function Chamber() {
		super();
		reset();
	}
	
	public function reset() {
		this.vapor.reset();
		hideClip(this.pressureSensor);
		hideClip(this.thermoSensor);
		this.pressureSensor.reset();
		this.thermoSensor.reset();
		pause();
	}
	public function resetButInstruments():Void {
		var i = isAllInstrumentsShown();
		reset();
		if(i) {
			showManometer();
			showTemperatureSensor();
		}
	}
	public function showManometer() {
		showClip(this.pressureSensor);
		correctState();
	}
	
	public function showPressureMeasurement(p:Number) {
		this.pressureSensor.showMeasurement(p);
		correctState();
	}
	
	public function showTemperatureSensor() {
		showClip(this.thermoSensor);
		correctState();
	}

	public function showTemperatureMeasurement(t:Number) {
		this.thermoSensor.showMeasurement(t);
		correctState();
	}
	
	public function isAllInstrumentsShown():Boolean {
		return this.thermoSensor._visible && this.pressureSensor._visible;
	}
	
	public function showVapor() {
		this.vapor.showAsVapor();
		this.pressureSensor.showVapor();
		correctState();
	}
	
	public function showAir() {
		this.vapor.showAsAir();
		this.pressureSensor.showAir();
		correctState();
	}
	
	public function isVapor():Boolean {
		return this.vapor.isVapor();
	}

	public function pauseAll()
	{
		stopClip(this.vapor);
		this.pressureSensor.pause();
		this.thermoSensor.pause();
	}
	
	public function playAll()
	{
		playClip(this.vapor);
		this.pressureSensor.play();
		this.thermoSensor.play();
	}
}