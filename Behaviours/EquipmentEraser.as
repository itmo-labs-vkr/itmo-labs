class Behaviours.EquipmentEraser extends Behaviours.BehaviourBase {
	public function onPress(o) {
		o._parent.getScheme().deleteEquipment(o.getOwner());
	}
	public function onRollOver(o) {
		o.showRedCross();
	}
	public function onRollOut(o) {
		o.hideRedCross();		
	}
}
