class Graphics.Sensors.TankLevel extends Graphics.Common.Clip {
	private var label:TextField;
	private var units:TextField;
	public function TankLevel() {
		this.label._visible = true;
		this.units.text = Strings.TankUnits;
	}
	
	public function showMeasurement(value:Number)
	{
		var value_str = (value * 1000).toString().substr(0, 3);
		this.label.text = value_str;
	}
}