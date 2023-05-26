import Tiles.*;
import GUI.LabBase;
import GUI.Thumbnails.Thumbnail;

class GUI.Thumbnails.ThumbnailPanel
{
	private var lab:LabBase;
	private var area:TiledArea;
	private var thumbs:Array;
	private var enabled:Boolean;
		
	public function ThumbnailPanel(lab:LabBase, tileX:Number, tileY:Number, tileWidth:Number, tileHeight:Number) {	
		this.lab  = lab;
		this.area = this.lab.getPlane().createArea(tileX, tileY, tileWidth, tileHeight);
		this.thumbs = new Array();
		enable();
	}
	public function getLab():LabBase {
		return this.lab;
	}
	public function hide() {
		for(var i in this.thumbs)
			this.thumbs[i].hide();
	}
	public function show() {
		for(var i in this.thumbs)
			this.thumbs[i].show();
	}
	public function enable():Void {
		this.enabled = true;
	}
	public function disable():Void {
		this.enabled = false;
	}
	public function isEnabled():Boolean {
		return this.enabled;
	}
	private function shuffle() {
		for(var i = 0; i < this.thumbs.length; i++) {
			var j = Utils.randRange(0, this.thumbs.length - 1);
			var t = this.thumbs[j];
			this.thumbs[j] = this.thumbs[i];
			this.thumbs[i] = t;
		}
	}
	private function deploy():Void {
		var cursorX:Number = 0;
		var cursorY:Number = 0;
		var maxY:Number = 0;
		for(var i=0; i < this.thumbs.length; i++) {
			var thumb = this.thumbs[i];
			if(thumb.getArea().tileWidth > this.area.tileWidth) {
				if(Config.Trace) trace("Too width thumbnail");
				return;
			}
			if(cursorX + thumb.getArea().tileWidth > this.area.tileWidth) {
				//new line
				cursorX = 0;
				cursorY = maxY;
			}
				
			//append thumbnail to line
			if(cursorY + thumb.getArea().tileHeight > this.area.tileHeight) {
				if(Config.Trace) trace("Cannot deploy all thumbnails");
				return;
			}
			thumb.move(cursorX + this.area.tileX, cursorY + this.area.tileY);
			cursorX += thumb.getArea().tileWidth;
			if(cursorY + thumb.getArea().tileHeight > maxY)
				maxY = cursorY + thumb.getArea().tileHeight;
		}
	}
}