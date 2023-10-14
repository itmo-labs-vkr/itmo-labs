import Tiles.*;
import GUI.Thumbnails.ThumbnailBase;
import GUI.Thumbnails.ThumbnailPanel;
class GUI.Thumbnails.Thumbnail
{
	private var thumb;
	private var area:TiledArea;
	private var className:String;
	private var panel:ThumbnailPanel;
	private static var instCount:Number = 0;
		
	public function Thumbnail(panel:ThumbnailPanel, cls:String, scale:Number) {
		this.panel = panel;
		this.className = cls;
		this.thumb = this.panel.getLab().attachMovie("ThumbnailBase", "thumbus" + instCount++, this.panel.getLab().getNextHighestDepth());
		this.thumb.init(this, cls, scale);
		this.area = this.panel.getLab().getPlane().createAreaFromClip(this.thumb.getClip());
		this.area.resize(this.area.tileWidth + 1, this.area.tileHeight + 1);
	}

	public function move(tileX:Number, tileY:Number):Void {
		var tiled_point = this.panel.getLab().getPlane().createPoint(tileX, tileY);
		this.area.moveToPoint(tiled_point);
		var point = tiled_point.toStagePoint();
		this.thumb._x = point.x;
		this.thumb._y = point.y;
	}
	
	public function getArea():TiledArea {
		return this.area;
	}
	
	public function hide():Void {
		this.thumb._visible = false;
	}
	
	public function show():Void {
		this.thumb._visible = true;
	}
	//dummies that are needed for consistency
	public function onPress(){}
	public function onRelease(){}
	public function onReleaseOutside(){}
	public function onRollOver(){}
	public function onRollOut(){}
	public function onMouseMove(){}
}