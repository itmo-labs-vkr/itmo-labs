class Tiles.LocalPoint extends Tiles.PointBase {
	private var clip:MovieClip;
	public function LocalPoint(clip:MovieClip, x:Number, y:Number) {
		super(x, y);
		this.clip = clip;
	}
}
