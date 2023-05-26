import GUI.LabBase;
import GUI.Thumbnails.ThumbnailPanel;
import GUI.Thumbnails.EquipmentThumbnail;
class GUI.Thumbnails.EquipmentThumbnailPanel extends GUI.Thumbnails.ThumbnailPanel
{
	public function EquipmentThumbnailPanel(app:LabBase, classesList:Array, tileX:Number, tileY:Number, tileWidth:Number, tileHeight:Number)
	{
		super(app, tileX, tileY, tileWidth, tileHeight);
		for(var i=0; i < classesList.length; i++)
			this.thumbs.push(new EquipmentThumbnail(this, classesList[i]));
		shuffle();
		deploy();
	}
}