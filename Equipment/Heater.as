class Equipment.Heater extends Equipment.EquipmentBase {
	private var clip:Graphics.Heater;
	private var t1:Number;
	private var t2:Number;
	private var W:Number;
	private var Wl:Number;
	public function Heater(scheme:SchemeBase) {
		super(scheme);
	}
	public function getId():Number {
		return ID.Heater;
	}
	/*public function calculate(input:Socket) {
		var output = getOtherSocket(input);
		
		output.P = input.P;
		output.h = input.h + W / input.G;
		output.G = input.G;
	}*/
	public function fillParams(input:Socket, table:Object) {
		// Works as an ideal pipe in this case
		var output = getOtherSocket(input);
		output.P = input.P;
		output.h = input.h;
		output.G = input.G;
		if(table.W) {
			this.clip.showMeasurement(table.W);
			this.clip.showLoses(table.Wl);
			this.W  = table.W;
			this.Wl = table.Wl;
			if(input == getSocket(1)) { // Поток снизу вверх
				this.clip.showTemperature1(table.t1);
				this.clip.showTemperature2(table.t2);
				this.t1 = table.t1;
				this.t2 = table.t2;
			} else {
				this.clip.showTemperature1(table.t2);
				this.clip.showTemperature2(table.t1);
				this.t1 = table.t2;
				this.t2 = table.t1;
			}
		}
	}
	public function turnOn() {
		if(this.clip.isWorking())
			return;
		this.clip.showWorking();
		this.scheme.logTurningOn(getId());
	}
	public function isTurnedOn():Boolean {
		return this.clip.isWorking();
	}
	public function gett1():Number {
		return this.t1;
	}
	public function gett2():Number {
		return this.t2;
	}
	public function getW():Number {
		return this.W;
	}
	public function getWl():Number {
		return this.Wl;
	}
	public function getP():Number {
		return getSocket(0).P;
	}
}