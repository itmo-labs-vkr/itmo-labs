class Behaviours.EquipmentDragging extends Behaviours.BehaviourBase {
	public function onPress(o) {
		if(Config.Trace) trace("event: EquipmentDragging.onPress");
		o.getOwner().startDragging();
	}
	public function onRelease(o) {
		o.getOwner().endDragging();
	}
	public function onReleaseOutside(o) {
		o.getOwner().endDragging();
	}
	public function onMouseMove(o) {
		o.getOwner().doDragging();
	}
	public function onRollOver(o) {
		o.useHandCursor = true;
	}
}
