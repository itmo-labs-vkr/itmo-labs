class Graphics.Sensors.HeaterLoses extends Graphics.Sensors.SensorBase {
	public function HeaterLoses() {
		super();
		this.label.units = Strings.HeaterLosesUnits;
	}
	public function showMeasurement(w:Number) {
		super.showMeasurement(w.toString());
	}
}