class Graphics.Common.Puppet extends Graphics.Common.PuppetBase {
	public function onPress() {
		this.master.getBehaviour(getId()).onPress(this);
	}
	public function onRollOver() {
		this.master.getBehaviour(getId()).onRollOver(this);
	}
	public function onRollOut() {
		this.master.getBehaviour(getId()).onRollOut(this);
	}
	public function onRelease() {
		this.master.getBehaviour(getId()).onRelease(this);
	}
	public function onReleaseOutside() {
		this.master.getBehaviour(getId()).onReleaseOutside(this);
	}
}