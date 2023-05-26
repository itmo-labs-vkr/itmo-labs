import Tiles.TiledArea;
import Tiles.TiledPoint;
import Tiles.StagePoint;
class Tiles.TiledPlane
{
	private var _tileSize:Number;
	private var _x:Number;
	private var _y:Number;
	
	public function TiledPlane(tileSize:Number, x:Number, y:Number) {
		this._tileSize = tileSize;
		this._x = x;
		this._y = y;
	}
	public function get x():Number {
		return this._x;
	}
	public function get y():Number {
		return this._y;
	}
	public function get tileSize():Number {
		return this._tileSize;
	}
	public function createArea(tileX:Number, tileY:Number, tileWidth:Number, tileHeight:Number):TiledArea {
		return new TiledArea(this, tileX, tileY, tileWidth, tileHeight);		
	}
	public function createAreaFromClip(clip:MovieClip):TiledArea {
		return new TiledArea(
			this,
			Math.round((clip._x - this._x) / this._tileSize),
			Math.round((clip._y - this._y) / this._tileSize),
			Math.round((clip.boundary?clip.boundary._width *clip._xscale/100 :clip._width ) / this._tileSize),
			Math.round((clip.boundary?clip.boundary._height*clip._yscale/100 :clip._height) / this._tileSize));
	}
	public function createPoint(tileX:Number, tileY:Number):TiledPoint {
		return new TiledPoint(this, tileX, tileY);
	}
	public function createPointFromStagePoint(point:StagePoint):TiledPoint {
		var new_point = createPoint(0, 0);
		new_point.fromStagePoint(point);
		return new_point;
	}
	public function createNearestTPFromSP(point:StagePoint):TiledPoint {
		var new_point = createPoint(0, 0);
		new_point.fromNearestStagePoint(point);
		return new_point;
	}
}