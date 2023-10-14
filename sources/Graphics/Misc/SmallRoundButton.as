class Graphics.Misc.SmallRoundButton extends Graphics.Common.Clip {
	public function SmallRoundButton() {
		enable();
	}
	public function enable():Void {
		gotoAndStop("enabled");
	}
	public function disable():Void {
		gotoAndStop("disabled");
	}
	public function onPress() {
		trace("press!");
	}
}