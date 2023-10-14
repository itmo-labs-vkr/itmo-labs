import GUI.LabBase;
import GUI.Thumbnails.ThumbnailPanel;
import GUI.Thumbnails.InstrumentalThumbnail;
class GUI.Thumbnails.InstrumentalThumbnailPanel extends GUI.Thumbnails.ThumbnailPanel
{
	public function InstrumentalThumbnailPanel(app:LabBase, classesList:Array, tileX:Number, tileY:Number, tileWidth:Number, tileHeight:Number)
	{
		super(app, tileX, tileY, tileWidth, tileHeight);
		for(var i in classesList)
			this.thumbs.push(new InstrumentalThumbnail(this, classesList[i]));
		shuffle();
		deploy();
	}
}