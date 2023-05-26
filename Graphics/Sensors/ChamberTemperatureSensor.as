class Graphics.Sensors.ChamberTemperatureSensor extends Graphics.Sensors.SensorBase {
	private var t:Number;
	private var inertia:Number = 3;
	public function ChamberTSensor() {
		super();
		this.t = 0;
	}
	public function showMeasurement(t:Number) {
		this.t = t;
		frameShow();
	}
	private function showMeasurementInt(val:Number) {
		var t_str = val.toString().substr(0, 5);
		super.showMeasurement(t_str);
	}
	private function frameShow() {
		showMeasurementInt(this.t+Utils.randRange(-2, 2)*0.1);
	}
}
