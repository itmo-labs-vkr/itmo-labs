class Tiles.PointBase {
	private var _x:Number;
	private var _y:Number;
	public function PointBase(x:Number, y:Number) {
		this._x = x;
		this._y = y;
	}
	public function get x():Number {
		return this._x;
	}
	public function get y():Number {
		return this._y;
	}
}
