class Behaviours.EquipmentTurningOn extends Behaviours.BehaviourBase {
	public function onPress(o) {
		o.getOwner().getLab().hideHint();
		o.getOwner().turnOn();
	}
	public function onRollOver(o) {
		if(!o.getOwner().isTurnedOn()) {
			o.useHandCursor = true;
			o.getOwner().getLab().showHint(Strings.TurningOnMsgById(o.getOwner().getId()));
		} else {
			o.useHandCursor = false;
		}
	}
	public function onRollOut(o) {
		o.useHandCursor = false;
		o.getOwner().getLab().hideHint();
	}
}