class Graphics.Sensors.CondenserTemperatureSensor extends Graphics.Sensors.SensorBase
{
	public function CondenserTemperatureSensor()
	{
		super();
	}
	
	public function showMeasurement(value:Number)
	{
		var value_str = value.toString().substr(0, 2);
		super.showMeasurement(value_str);
	}
}