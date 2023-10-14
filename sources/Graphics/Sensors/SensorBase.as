import Config;
class Graphics.Sensors.SensorBase extends Graphics.Common.Clip {
	private var label:Object;
	private var pauseFlag:Boolean;
	private var frameCount:Number;
	private var inertion:Number = 0.5;
	// in seconds
	public function SensorBase() {
		this.frameCount = this.inertion*Config.FrameRate;
		reset();
	}
	public function reset() {
		pause();
		this.label._visible = false;
	}
	public function showMeasurement(measurement:String) {
		this.label._visible = true;
		this.label.text = measurement;
	}
	public function onEnterFrame() {
		++frameCount;
		if (frameCount>this.inertion*Config.FrameRate) {
			frameCount = 0;
		}
		if (!this.pauseFlag) {
			if (frameCount == 0) {
				if(this.label._visible)
					frameShow();
			}
		}
	}
	// Override 
	private function frameShow() {
	}
	public function play() {
		this.pauseFlag = false;
	}
	public function pause() {
		this.pauseFlag = true;
	}
}
