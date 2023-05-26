class Graphics.Condenser extends Graphics.Common.Equipment
{
	//inner clips
	private var thermoSensor1:Graphics.Sensors.CondenserTemperatureSensor;
	private var thermoSensor2:Graphics.Sensors.CondenserTemperatureSensor;
	private var thermoSensor3:Graphics.Sensors.CondenserTemperatureSensor;
	private var tank:MovieClip;
	private var pipe:MovieClip;
	private var drops:MovieClip;
	private var vapor:MovieClip;
	private var zone1:MovieClip;
	private var zone2:MovieClip;
	private var zone3:MovieClip;
	
	public function Condenser() {
		super();
		reset();
	}
	
	public function showTemperatureSensorAt(p:Tiles.StagePoint) {
		if(this.zone1.hitTest(p.x, p.y, true))
			showClip(this.thermoSensor1);
		if(this.zone2.hitTest(p.x, p.y, true))
			showClip(this.thermoSensor2);
		if(this.zone3.hitTest(p.x, p.y, true))
			showClip(this.thermoSensor3);
		correctState();
	}
	
	public function isAllInstrumentsShown():Boolean {
		return this.thermoSensor1._visible && this.thermoSensor2._visible && this.thermoSensor3._visible;
	}
	
	public function showMeasurements(t1:Number, t2:Number, t3:Number) {
		this.thermoSensor1.showMeasurement(t1);
		this.thermoSensor2.showMeasurement(t2);
		this.thermoSensor3.showMeasurement(t3);
		correctState();
	}
	
	public function showWater() {
		showClip(this.tank.water);
		showClip(this.tank.valve.opened);
		if(isVisible(this.pipe.vapor))
			showCondensation();
		correctState();
	}
	public function isWorking() {
		return this.tank.water._visible;
	}
	public function showWaterOutlet() {
		showClip(this.tank.wateroutlet);
	}
	
	public function showVapor() {
		this.pipe.vapor.showAsVapor(); 
		showClip(this.vapor);
		if(isVisible(this.tank.water)) 
			showCondensation();
		correctState();
	}
	
	private function showCondensation() {
		hideClip(this.vapor);
		showClip(this.pipe.condensation);
		showClip(this.drops);
	}
	
	public function reset()
	{
		hideClip(this.pipe.condensation);
		this.pipe.vapor.reset();
		hideClip(this.tank.water);
		hideClip(this.tank.wateroutlet);
		hideClip(this.tank.valve.opened);
		hideClip(this.vapor);
		hideClip(this.drops);
		this.thermoSensor1.reset();
		this.thermoSensor2.reset();
		this.thermoSensor3.reset();
		hideClip(this.thermoSensor1);
		hideClip(this.thermoSensor2);
		hideClip(this.thermoSensor3);
		pause();
	}
	
	public function resetButInstruments() {
		var i = isAllInstrumentsShown();
		reset();
		if(i) {
			showClip(this.thermoSensor1);
			showClip(this.thermoSensor2);
			showClip(this.thermoSensor3);
		}
	}
		
	public function isCondensation():Boolean {
		return this.pipe.condensation._visible;
	}
	
	public function pauseAll()
	{
		stopClip(this.vapor);
		stopClip(this.pipe.vapor);
		stopClip(this.pipe.condensation);
		stopClip(this.drops);
	}
	
	public function playAll()
	{
		playClip(this.vapor);
		playClip(this.pipe.vapor);
		playClip(this.pipe.condensation);
		playClip(this.drops);
	}
}