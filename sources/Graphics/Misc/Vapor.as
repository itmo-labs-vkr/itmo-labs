class Graphics.Misc.Vapor extends Graphics.Common.Clip {
	private var back:MovieClip;
	public function Vapor() {
		super();
		reset();
	}
	public function showAsVapor() {
		this._visible = true;
		this.back._visible = true;
	}
	public function showAsAir() {
		this._visible      = true;
		this.back._visible = false;
	}
	public function reset() {
		this._visible      = false;
		this.back._visible = true;
	}
	public function isVapor():Boolean {
		return this.back._visible;
	}
}