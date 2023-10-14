class Graphics.Nozzle extends Graphics.Common.Equipment {
	private var vapor:MovieClip;
	public function Nozzle()	{
		super();
		reset();
	}
	public function reset() {
		this.vapor.reset();
		pause();
	}
	public function showAir() {
		this.vapor.showAsAir();
		correctState();
	}
	private function playAll() {
		playClip(this.vapor);
	}
	private function pauseAll() {
		stopClip(this.vapor);
	}
}