class Graphics.Compressor extends Graphics.Common.Equipment {
	private var vapor:MovieClip;
	private var button:MovieClip;
	public function Compressor() {
		super();
		reset();
	}
	public function reset() {
		super.gotoAndStop(1);
		this.vapor.reset();
		hideClip(this.button.buttonOff);
	}
	public function showWorking() {
		this.vapor.showAsAir();
		showClip(this.button.buttonOff);
		correctState();
	}
	public function isWorking() {
		return this.vapor._visible;
	}
	private function playAll() {
		playItself();
		playClip(this.vapor);
	}
	private function pauseAll() {
		stopItself();
		stopClip(this.vapor);
	}
}
