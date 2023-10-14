import Graphics.Misc.StopwatchButton;
class Graphics.Misc.Stopwatch extends Graphics.Common.Clip {
	private var seconds:TextField;
	private var deciseconds:TextField;
	private var btnStart:StopwatchButton;
	private var btnStop:StopwatchButton;
	private var btnReset:StopwatchButton;
	private var time:Number;
	private var timeOffset:Number;
	private var isOn:Boolean;
	public function Stopwatch() {
		this.btnStart.setCaption(Strings.StopwatchStart);
		this.btnStop.setCaption(Strings.StopwatchStop);
		this.btnReset.setCaption(Strings.StopwatchReset);
		reset();
	}
	public function onButtonPress(btn:Object):Void {
		switch(btn) {
			case this.btnStart:
				if(!this.isOn) {
					this.isOn = true;
					this.timeOffset = getTimer();
					
					// добавлено для 6ой лабораторной работы
					var flowmeters = this._parent.getScheme().getEquipmentById(ID.Flowmeter);
					if(flowmeters[0]) flowmeters[0].zero();
				}
				break;
			case this.btnStop:
				if(this.isOn) {
					this.isOn = false;
					this.time += getTimer() - this.timeOffset;
				}
				break;
			case this.btnReset:
				reset();
				break;
		}
	}
	private function reset():Void {
		this.time = 0;
		this.timeOffset = getTimer();
		this.deciseconds.text = "0";
		this.seconds.text = "0";
	}
	public function onEnterFrame() {
		// опять извращения из-за багов флеша((
		if(this.isOn) {
			var t = this.time + getTimer() - this.timeOffset;
			this.deciseconds.text = Math.floor(t % 1000 / 100).toString();
			this.seconds.text     = (Math.floor(t / 1000)).toString(); 
		}
	}
}