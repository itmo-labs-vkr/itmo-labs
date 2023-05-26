class Equipment.Receiver extends Equipment.EquipmentBase {
	public function Receiver(scheme:SchemeBase) {
		super(scheme);
	}
	public function getId() {
		return ID.Receiver;
	}
	public function fillParams(input:Socket, table:Object) {
		var output = getOtherSocket(input);
		output.P = input.P;
		output.h = input.h;
		output.G = input.G;
	}
}