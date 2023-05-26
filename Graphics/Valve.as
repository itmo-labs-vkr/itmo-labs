class Graphics.Valve extends Graphics.Common.Equipment {
	private var body:MovieClip;
	
	public function Valve()	{
		super();
		reset();
	}
	public function reset() {
		this.body.vapor.reset();
		hideClip(this.body.btnOpen);
		hideClip(this.body.btnClose);
		pause();
	}
	public function showVapor() {
		this.body.vapor.showAsVapor();
		correctState();
	}
	public function showAir() {
		this.body.vapor.showAsAir();
		correctState();
	}
	public function rotate() {
		this.body._rotation += 90;
	}
	public function showButtons() {
		showClip(this.body.btnOpen);
		showClip(this.body.btnClose);
	}
	public function enableOpenButton() {
		this.body.btnOpen.enable();
	}
	public function enableCloseButton() {
		this.body.btnClose.enable();
	}
	public function disableOpenButton() {
		this.body.btnOpen.disable();
	}
	public function disableCloseButton() {
		this.body.btnClose.disable();
	}
	public function onPressButton(p:Tiles.StagePoint):Void {
		if(this.body.btnOpen._visible) {
			if(this.body.btnOpen.hitTest(p.x, p.y, true))
				getOwner().onPressOpenButton();
			if(this.body.btnClose.hitTest(p.x, p.y, true))
				getOwner().onPressCloseButton();
		}
	}
	private function playAll() {
		playClip(this.body.vapor);
	}
	private function pauseAll() {
		stopClip(this.body.vapor);
	}
}