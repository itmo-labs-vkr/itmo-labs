class Graphics.Misc.StopwatchButton extends Graphics.Common.Clip {
	private var label;
	public function StopwatchButton() {
	}
	public function setCaption(cpt:String):Void {
		this.label.text = cpt.toUpperCase();
	}
	public function onPress():Void {
		this._parent.onButtonPress(this);
	}
}