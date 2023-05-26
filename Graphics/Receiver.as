class Graphics.Receiver extends Graphics.Common.Equipment {
	private var vapor:MovieClip;
	private var smallDischarge:MovieClip;
	private var fullDischarge:MovieClip;
	public function Receiver() {
		super();
		reset();
	}
	public function reset() {
		this.vapor.reset();
		hideClip(this.smallDischarge);
		hideClip(this.fullDischarge);
		pause();
	}
	public function showAir() {
		this.vapor.showAsAir();
		correctState();
	}
	public function showSmallDischarge() {
		hideClip(this.fullDischarge);
		showClip(this.smallDischarge);
		correctState();
	}
	public function showFullDischarge() {
		hideClip(this.smallDischarge);
		showClip(this.fullDischarge);
		correctState();
	}
	private function playAll() {
		playClip(this.vapor);
		playClip(this.smallDischarge);
		playClip(this.fullDischarge);
	}
	private function pauseAll() {
		stopClip(this.vapor);
		stopClip(this.smallDischarge);
		stopClip(this.fullDischarge);
	}
}