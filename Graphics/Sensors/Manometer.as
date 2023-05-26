class Graphics.Sensors.Manometer extends Graphics.Common.Clip {
	private var arrow:MovieClip;
	private var start:Number;
	private var end:Number;
	public function Manometer() {
		setRange(0,0);
	}
	public function setRange(start:Number, end:Number) {
		/* Можно установить пределы ТОЛЬКО 1 раз */
		if(this.end > 0.00001) 
			return;
		this.start = start;
		this.end   = end;
	}
	public function evalRangeFromMeasurement(m:Number):Void {
		/* часть стандартных верхних пределов для манометров МО160 */
		var stdUpperLimits = new Array(1.6, 2,5, 4., 6., 10.);
		for(var i = 0; i < stdUpperLimits.length; i++)
			if(m <= stdUpperLimits[i]) {
				setRange(0, stdUpperLimits[i]);
				return;
			}
		setRange(0, stdUpperLimits[stdUpperLimits.length - 1]);
		return;
	}
	public function showMeasurement(value:Number) {
		if (value>=this.start && value<=this.end) {
			this.arrow._rotation = 240*(value-this.start)/(this.end-this.start);
		} else if (value<this.start) {
			this.arrow._rotation = 0;
		} else {
			this.arrow._rotation = 240;
		}
	}
	public function reset() {
		showMeasurement(0);
	}
}
