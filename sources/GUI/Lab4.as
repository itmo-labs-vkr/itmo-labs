class GUI.Lab4 extends GUI.LabBase {
	private var scheme:Scheme4;
	public function Lab4() {
		super();
	}
	public function getId():Number {
		return ID.Lab4;
	}
	private function initScheme():Void {
		this.scheme = new Scheme4(this);
	}
	public function showHeaterBurning() {
		this.scheme.getEquipmentById(ID.Heater)[0].getClip().showBurning();
		this.scheme.play();
	}
	public function showMeasuring():Void {
		this.scheme.getEquipmentById(ID.Glass)[0].getClip().empty();
		this.btnControl.label = Strings.StopLabel;
	}
}