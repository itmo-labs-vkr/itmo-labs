class LabApplication3 extends LabApplicationBase {
	private var lab:GUI.Lab3;
	public function LabApplication3(lab:GUI.Lab3) {
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