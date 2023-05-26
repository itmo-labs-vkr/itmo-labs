class Graphics.Common.Equipment extends Graphics.Common.Puppet {
	private var redCross:MovieClip;
	public function showRedCross() {
		// It's bad, but the size of a pipe clip depends on presence of the cross
		var area = this.getOwner().getTiledArea();
		this.redCross = this.attachMovie("DeletingCross", "curossu", this.getNextHighestDepth());
		this.redCross._x = area.pixelWidth/2;
		this.redCross._y = area.pixelHeight/2;
	}
	public function hideRedCross() {
		this.redCross.removeMovieClip();
	}
	public function resetButInstruments():Void {
		reset();
	}
	public function isAllInstrumentsShown():Boolean {
		return false;
	}
	public function reset():Void {
	}
}