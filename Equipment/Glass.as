class Equipment.Glass extends Equipment.EquipmentBase {
	private var clip:Graphics.Glass;
	public function Glass(scheme:SchemeBase) {
		super(scheme);
	}
	public function getId():Number {
		return ID.Glass;
	}
	public function setMassFlow(g:Number):Void {
		this.clip.setMassFlow(g);
		this.clip.showMeasurement();
	}
	public function getG():Number {
		return this.clip.getMassFlow();
	}
	public function onChangeSpoilingMassFlow(G:Number):Void {
		var work_area = this.lab.getWorkArea();
		if(getTileY() + getTileHeight() < work_area.tileY + work_area.tileHeight) {
			var puddle = this.lab.getGlassPuddle();
			puddle.moveAlongX((getTileX() + 3)*getTileSize() + this.lab.getPlane().x);
			puddle.setMassFlow(G);
		}
	}
}
