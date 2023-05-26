import Tiles.TiledPlane;
import Tiles.TiledPoint;
class Tiles.TiledArea
{
	private var plane:TiledPlane;
	private var _tileX;
	private var _tileY;
	private var _tileWidth;
	private var _tileHeight;
	
	public function TiledArea(plane:TiledPlane, tileX:Number, tileY:Number, tileWidth:Number, tileHeight:Number)
	{
		this.plane = plane;
		this._tileX = tileX;
		this._tileY = tileY;
		this._tileWidth  = tileWidth;
		this._tileHeight = tileHeight;
	}
	
	public function get tileX():Number
	{
		return this._tileX;
	}
	
	public function get tileY():Number
	{
		return this._tileY;
	}
	
	public function get tileWidth():Number
	{
		return this._tileWidth;
	}
	
	public function get tileHeight():Number
	{
		return this._tileHeight;
	}
	
	public function get pixelWidth():Number
	{
		return this._tileWidth * this.plane.tileSize;
	}
	
	public function get pixelHeight():Number
	{
		return this._tileHeight * this.plane.tileSize;
	}
	
	public function intersectsWith(other:TiledArea):Boolean
	{
		return other._tileX < this._tileX + this._tileWidth 
		&& other._tileY < this._tileY + this._tileHeight
		&& other._tileX + other._tileWidth > this._tileX
		&& other._tileY + other._tileHeight > this._tileY;
	}
	
	public function hasArea(other:TiledArea):Boolean
	{
		return other._tileX >= this._tileX 
		&& other._tileY >= this._tileY
		&& other._tileX + other._tileWidth  <= this._tileX + this._tileWidth
		&& other._tileY + other._tileHeight <= this._tileY + this._tileHeight;
	}
	
	public function hasPoint(point:TiledPoint):Boolean
	{
		return point.tileX >= this._tileX 
		&& point.tileY >= this._tileY
		&& point.tileX <  this._tileX + this._tileWidth
		&& point.tileY <  this._tileY + this._tileHeight;
	}
	
	public function move(tileX:Number, tileY:Number)
	{
		this._tileX = tileX;
		this._tileY = tileY;
	}
	
	public function moveToPoint(point:TiledPoint)
	{
		this._tileX = point.tileX;
		this._tileY = point.tileY;
	}
	
	public function resize(tileWidth:Number, tileHeight:Number)
	{
		this._tileWidth  = tileWidth;
		this._tileHeight = tileHeight;
	}
	
	public function getLeftTopCorner():TiledPoint
	{
		return new TiledPoint(this.plane, this._tileX, this._tileY);
	}
	
	public function copy():TiledArea
	{
		return new TiledArea(this.plane, this._tileX, this._tileY, this._tileWidth, this._tileHeight);
	}
}