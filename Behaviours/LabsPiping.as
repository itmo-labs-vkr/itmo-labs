class Behaviours.LabsPiping extends Behaviours.BehaviourBase {
	public function onMouseDown(o) {
		o.beginPiping();
	}
	public function onMouseMove(o) {
		o.doPiping();
	}
	public function onMouseUp(o) {
		o.endPiping();
	}
}