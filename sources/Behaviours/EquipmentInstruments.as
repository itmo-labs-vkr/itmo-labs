class Behaviours.EquipmentInstruments extends Behaviours.BehaviourBase {
	public function onRollOver(o) {
		o.getOwner().getLab().attemptToInstall(o.getOwner());
		o.useHandCursor = false;
	}
}
