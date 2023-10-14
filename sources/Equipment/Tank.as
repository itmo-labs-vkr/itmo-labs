class Equipment.Tank extends Equipment.EquipmentBase {
	private var clip:Graphics.Tank;
	public function Tank(scheme:SchemeBase) {
		super(scheme);
	}
	public function getId():Number {
		return ID.Tank;
	}
	public function setMassFlow(g:Number):Void {
		this.clip.setMassFlow(g);
		this.clip.showMeasurement();
	}
	public function onChangeSpoilingMassFlow(G:Number):Void {
		var work_area = this.lab.getWorkArea();
		if(getTileY() + getTileHeight() < work_area.tileY + work_area.tileHeight) {
			var puddle = this.lab.getTankPuddle();
			puddle.moveAlongX((getTileX() + 1)*getTileSize() + this.lab.getPlane().x);
			puddle.setMassFlow(G);
		}
	}
}
