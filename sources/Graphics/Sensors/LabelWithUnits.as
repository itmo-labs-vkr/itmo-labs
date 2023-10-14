class Graphics.Sensors.LabelWithUnits extends Graphics.Common.Clip
{
	private var label:TextField;
	private var _units:TextField;
	
	function get text():String {
		return this.label.text;
	}
	
	function set text(txt:String) {
		this.label.text = txt;
	}
	
	function set units(str:String):Void {
		this._units.text = str;
	}
}