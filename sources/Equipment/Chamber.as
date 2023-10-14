class Equipment.Chamber extends Equipment.EquipmentBase {
	private var clip:Graphics.Chamber;
	private var t:Number;
	public function Chamber(scheme:SchemeBase) {
		super(scheme);
	}
	public function getId():Number {
		return ID.Chamber;
	}
	public function installInstrument(name:String) {
		switch(name) {
			case "Manometer":
				this.clip.showManometer();
				break;
			case "TemperatureSensor":
				this.clip.showTemperatureSensor();
				break;
		}
	}
	//calculation
	public function calculate(input:Socket) {
		var output = getOtherSocket(input);
		output.P = input.P;
		output.h = input.h;
		output.G = input.G;
	}
	
	public function fillParams(input:Socket, table:Object) {
		calculate(input);
		this.clip.showPressureMeasurement(input.P);
		if(this.clip.isVapor()) 
			// Лабораторная №3, с паром, можем и посчитать
			this.clip.showTemperatureMeasurement(input.T);
		else {
			// Давления расставлены правильно, по ним ставим температуры. 
			this.t = input.P == table.P1 ? table.t1 : table.t2;
			this.clip.showTemperatureMeasurement(this.t);
		}
	}
	
	public function getP():Number {
		return getSocket(0).P;
	}
	
	public function gett():Number {
		return this.t ? this.t : getSocket(0).T;
	}
	
	public function geth():Number {
		return getSocket(0).h;
	}
}