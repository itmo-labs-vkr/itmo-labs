class Graphics.Sensors.Wattmeter extends Graphics.Sensors.SensorBase {
	public function Wattmeter() {
		reset();
	}
	public function showMeasurement(w:Number) {
		super.showMeasurement(w.toString());
	}
	public function reset() {
		showMeasurement(0);
	}
}