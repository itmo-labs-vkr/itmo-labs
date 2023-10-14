import GUI.LabBase;
import Equipment.EquipmentBase;
import GUI.Thumbnails.Thumbnail;
import GUI.Thumbnails.EquipmentThumbnailPanel;
class GUI.Thumbnails.EquipmentThumbnail extends GUI.Thumbnails.Thumbnail
{
	private var currentEquipment:EquipmentBase;
	
	public function EquipmentThumbnail(panel:EquipmentThumbnailPanel, cls:String) {
		super(panel, cls, 0.5);
	}
 	public function onPress() {
		if(this.panel.isEnabled()) {
			this.panel.getLab().hideHint();
			if(Config.Trace) trace("event: EquipmentThumbnail.onPress");
			var equipment = this.panel.getLab().getScheme().createEquipment(this.className);
			equipment.moveToPoint(this.area.getLeftTopCorner());
			equipment.markAsJustCreated();
			equipment.getClip().onPress();
			this.currentEquipment = equipment;
		}
	}
	public function onRelease() {
		if(this.panel.isEnabled()) {
			this.currentEquipment.getClip().onRelease();
		}
	}
	public function onReleaseOutside() {
		if(this.panel.isEnabled()) {
			this.currentEquipment.getClip().onReleaseOutside();
		}
	}
	public function onRollOver() {
		if(this.panel.isEnabled()) {
			this.thumb.useHandCursor = true;
			this.panel.getLab().showHint(Strings.EquipmentNameById(ID.clsNameToId(this.className)));
		} else
			this.thumb.useHandCursor = false;
	}
	public function onRollOut() {
		this.thumb.useHandCursor = false;
		this.panel.getLab().hideHint();
	}
}