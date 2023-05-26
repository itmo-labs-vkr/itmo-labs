class Behaviours.ElbowElbows extends Behaviours.BehaviourBase {
	public function onPress(o) {
		if (!o.getOwner().isCursor()) {
			o.getOwner().rotate();
		}
	}
	public function onRollOver(o) {
		if (!o.getOwner().isCursor()) {
			o.showArrows();
		}
	}
	public function onRollOut(o) {
		if (!o.getOwner().isCursor()) {
			o.hideArrows();
		}
	}
}
