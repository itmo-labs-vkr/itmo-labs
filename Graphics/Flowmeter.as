class Graphics.Flowmeter extends Graphics.Common.Equipment {
	private var sensor:Graphics.Sensors.FlowmeterSensor;
	private var vapor:MovieClip;
	public function Flowmeter() {
		super();
		
		reset();
	}
	public function reset() {
		this.sensor.reset();
		this.vapor.reset();
		pause();
	}
	public function showMeasurement(flow:Number) {
		this.sensor.showMeasurement(flow);
		correctState();
	}
	public function showAir() {
		this.vapor.showAsAir();
		correctState();
	}
	public function zero() {
		this.sensor.zero();
	}
	private function playAll() {
		this.sensor.play();
		playClip(this.vapor);
	}
	private function pauseAll() {
		this.sensor.pause();
		stopClip(this.vapor);
	}
}