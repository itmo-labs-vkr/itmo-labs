class Graphics.Sensors.FlowmeterSensor extends Graphics.Sensors.SensorBase {
	private var rotor:MovieClip;
	private var label:MovieClip;
	
	private var count:Number;
	private var flow:Number; // m^3/s
	static private var maxCount:Number = 1000; // rotations
	static private var flowPerRotation:Number = 0.001 // m^3/1
	
	public function FlowmeterSensor() {
		super();
		this.label.units.text = Strings.FlowmeterUnits;
		reset();
	}
	public function showMeasurement(flow:Number) {
		this.flow = flow;
		showCurrentMeasurement();
	}
	public function onEnterFrame() {
		if(!this.pauseFlag) {
			var flowpf = 1.0/Config.FrameRate * this.flow;
			// increase and show the count
			this.count += flowpf / flowPerRotation;
			if(this.count > maxCount) 
				this.count -= maxCount;
			if(this.label._visible)
				showCurrentMeasurement();
			// rotate the rotor	
			this.rotor._rotation += flowpf / flowPerRotation * 360;
		}
	}
	public function zero() {
		this.count = 0;
		if(this.label._visible)
			showCurrentMeasurement();
	}
	private function showCurrentMeasurement() {
		var m = Math.floor(this.count*10)/10;
		super.showMeasurement(m.toString());
	}
	public function reset() {
		super.reset();
		this.rotor._rotation = 0;
		this.count = 0;
		this.flow  = 0;
	}
}
