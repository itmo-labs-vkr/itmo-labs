class Behaviours.Default extends Behaviours.BehaviourBase {
	/*public function onMouseMove(o) {
		trace("onMouseMove: " + o._name);
	}*/
	public function onRollOver(o) {
		o.useHandCursor = false;
	}
}