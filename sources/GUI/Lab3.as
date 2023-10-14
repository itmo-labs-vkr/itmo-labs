class GUI.Lab3 extends GUI.LabBase {
	private var scheme:Scheme3;
	public function Lab3() {
		super();
	}
	public function getId():Number {
		return ID.Lab3;
	}
	private function initScheme():Void {
		this.scheme = new Scheme3(this);
	}
	public function showHeaterBurning() {
		this.scheme.getEquipmentById(ID.Heater)[0].getClip().showBurning();
		this.scheme.play();
	}
	public function showMeasuring():Void {
		this.scheme.getEquipmentById(ID.Glass)[0].getClip().empty();
		this.scheme.getEquipmentById(ID.Tank)[0].getClip().closeBypass();
		this.btnControl.label = Strings.StopLabel;
	}
}