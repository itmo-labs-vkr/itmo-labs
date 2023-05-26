class GUI.Lab6 extends GUI.LabBase {
	private var scheme:Scheme6;
	public function Lab6() {
		super();
	}
	public function getId():Number {
		return ID.Lab6;
	}
	private function initScheme():Void {
		this.scheme = new Scheme6(this);
	}
	public function showMeasuring():Void {
		showFinishConfirm();
	}
	public function showRunningSpecial() {
		with(this.scheme.getEquipmentById(ID.Valve)[0].getClip()) {
			showButtons();
			disableCloseButton();
			enableOpenButton();
		}
		this.btnControl.label = Strings.StopLabel;
	}
}