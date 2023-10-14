class Graphics.Sensors.BoilerManometer extends Graphics.Sensors.SensorBase {
	private var manometer:Graphics.Sensors.Manometer;
	private var vapor:MovieClip;
	private var bars:Number;
	public function BoilerManometer() {
		super();
		reset();
	}
	//input in kPa, the instrument shows in bars
	public function showMeasurement(value:Number) {
		this.bars = Math.abs(Utils.absPressureToRelative(value, this._parent.getOwner().getLab().getBarometer().getB())/100);
		this.manometer.evalRangeFromMeasurement(this.bars);
		frameShow();
	}
	public function showVapor() {
		showClip(this.vapor);
	}
	public function reset() {
		super.reset();
		hideClip(this.vapor);
		this.manometer.reset();
	}
	// Private functions
	private function frameShow() {
		showMeasurementInt(this.bars+Utils.randRange(-1, 1)*0.01);
	}
	private function showMeasurementInt(val:Number) {
		var bars_str = (Math.round(val*100)/100).toString().substr(0, 4);
		if (bars_str.length == 1) {
			bars_str += ".00";
		}
		super.showMeasurement(bars_str);
		this.manometer.showMeasurement(val);
	}
}
