class Graphics.Sensors.Barometer extends Graphics.Sensors.SensorBase {
	private var units:TextField;
	private var caption:TextField;
	private var B:Number;
	public function Barometer() {
		this.units.text = Strings.BarometerUnits;
		this.caption.text = Strings.BarometerCaption;
		this.B = 0;
	}
	public function showMeasurement(B:Number):Void {
		this.B = B;
		super.showMeasurement(B.toString());
	}
	public function getB():Number {
		return this.B;
	}
}