class Behaviours.ValveRunning extends Behaviours.BehaviourBase {
	public function onPress(o) {
		o.onPressButton(o.getOwner().getLab().getMousePointGlobal());
	}
}