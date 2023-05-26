class Graphics.Sensors.GlassLevel extends Graphics.Common.Clip {
	private var label:TextField;
	private var units:TextField;
	public function GlassLevel() {
		this.units.text = Strings.GlassUnits;
	}

	public function showMeasurement(value:Number)
	{
		var value_str = Math.floor(value * 1000000).toString().substr(0,3);
		this.label.text = value_str;
	}
}