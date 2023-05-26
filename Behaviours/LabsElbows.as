import GUI.LabBase;
class Behaviours.LabsElbows extends Behaviours.BehaviourBase {
	public function onMouseMove(o) {
		o.moveElbowPointer();
	}
	public function onMouseDown(o) {
		if(Config.Trace) trace("event: LabsElbows.onMouseDown");
		o.doElbow();
	}
}