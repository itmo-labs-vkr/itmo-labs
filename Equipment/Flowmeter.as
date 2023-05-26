class Equipment.Flowmeter extends Equipment.EquipmentBase {
	private var clip:Graphics.Flowmeter;
	private var V:Number;
	public function Flowmeter(scheme:SchemeBase) {
		super(scheme);
	}
	public function getId():Number {
		return ID.Flowmeter;
	}
	public function fillParams(input:Socket, table:Object) {
		var output = getOtherSocket(input);
		output.P = input.P;
		output.h = input.h;
		output.G = input.G;
		this.clip.showMeasurement(table.V);
		this.V = table.V;
	}
	public function getV():Number {
		return this.V;
	}
	public function zero() {
		trace("Обнуление");
		this.clip.zero();
	}
}