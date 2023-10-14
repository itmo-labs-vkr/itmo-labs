class Equipment.Nozzle extends Equipment.EquipmentBase
{
	public function Nozzle(scheme:SchemeBase) {
		super(scheme);
	}
	public function getId():Number {
		return ID.Nozzle;
	}
	public function fillParams(input:Socket, table:Object) {
		var output = getOtherSocket(input);
		output.P = table.P2;
		output.h = input.h;
		output.G = input.G;
	}
}