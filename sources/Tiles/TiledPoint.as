import Tiles.TiledPlane;
import Tiles.StagePoint;
class Tiles.TiledPoint
{
	private var plane:TiledPlane;
	private var _tileX:Number;
	private var _tileY:Number;
	
	public function TiledPoint(plane:TiledPlane, tileX:Number, tileY:Number)
	{
		this.plane  = plane;
		this._tileX = tileX;
		this._tileY = tileY;
	}
	
	public function get tileX():Number
	{
		return this._tileX;
	}
	
	public function get tileY():Number
	{
		return this._tileY;
	}
	
	public function move(tileX:Number, tileY:Number)
	{
		this._tileX = tileX;
		this._tileY = tileY;
	}
	
	public function toStagePoint():StagePoint
	{
		return new StagePoint(
			this._tileX * this.plane.tileSize + this.plane.x,
			this._tileY * this.plane.tileSize + this.plane.y);
	}
	
	public function fromStagePoint(point:StagePoint)
	{
		this._tileX = Math.floor((point.x - this.plane.x) / this.plane.tileSize);
		this._tileY = Math.floor((point.y - this.plane.y) / this.plane.tileSize);
	}
	
	public function fromNearestStagePoint(point:StagePoint) {
		this._tileX = Math.round((point.x - this.plane.x) / this.plane.tileSize);
		this._tileY = Math.round((point.y - this.plane.y) / this.plane.tileSize);
	}
	
	public function isEqual(other:TiledPoint):Boolean
	{
		return this.plane == other.plane 
		&& this._tileX == other._tileX
		&& this._tileY == other._tileY;
	}
}