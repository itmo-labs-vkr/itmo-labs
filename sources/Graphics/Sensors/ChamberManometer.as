import Utils;
class Graphics.Sensors.ChamberManometer extends Graphics.Sensors.SensorBase {
	private var manometer:Graphics.Sensors.Manometer;
	private var bars:Number;
	private var inertia:Number = 6;
	private var vapor;
		
	public function ChamberManometer()
	{
		super();
		//this.bars = 0;
		reset();
	}
	public function showVapor() {
		this.vapor._visible = true;
	}
	public function showAir() {
		this.vapor._visible = false;
	}
	public function reset() {
		this.vapor._visible = false;
		this.manometer.reset();
		super.reset();
	}
	//input in kPa, the instrument shows in bars
	public function showMeasurement(value:Number) {
		this.bars = Math.abs(Utils.absPressureToRelative(value, this._parent.getOwner().getLab().getBarometer().getB())/ 100);
		this.manometer.evalRangeFromMeasurement(this.bars);
		frameShow();
	}
	
	private function showMeasurementInt(val:Number) {
		var bars_str = (Math.round(val * 100) / 100).toString().substr(0, 4);
		if(bars_str.length == 1) 
			bars_str += ".00";
		super.showMeasurement(bars_str);
		this.manometer.showMeasurement(val);
	}
	
	private function frameShow()
	{
		showMeasurementInt(this.bars + Utils.randRange(-1, 1) * 0.01);
	}
}