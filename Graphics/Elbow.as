class Graphics.Elbow extends Graphics.Common.Equipment
{
	private var pipe:MovieClip;
	private var arrows:MovieClip;
	
	public function Elbow() {
		super();
		reset();
	}
	public function reset() {
		this.pipe.vapor.reset();
		hideClip(this.arrows);
		pause();
	}
	public function showVapor() {
		this.pipe.vapor.showAsVapor();
		correctState();
	}
	public function showAir() {
		this.pipe.vapor.showAsAir();
		correctState();
	}
	public function showArrows() {
		showClip(this.arrows);
	}
	public function hideArrows() {
		hideClip(this.arrows);
	}
	public function rotate() {
		this.pipe._rotation += 90;
	}
	public function pauseAll() {
		stopClip(this.pipe.vapor);
	}
	public function playAll() {
		playClip(this.pipe.vapor);
	}
}