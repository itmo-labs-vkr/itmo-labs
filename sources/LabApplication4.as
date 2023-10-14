class LabApplication4 extends LabApplicationBase {
	private var lab:GUI.Lab4;
	public function LabApplication4(lab:GUI.Lab4) {
		super(lab);
	}
	private function processSpecificTurningOnErrors():Boolean {
		if(this.errorMsg == Strings.ErrorHeaterBurned) {
			this.lab.showHeaterBurning();
			return true;
		}
		return false;
	}
}