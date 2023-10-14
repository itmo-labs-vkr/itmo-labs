class Equipment.Boiler extends Equipment.EquipmentBase {
	private var clip:Graphics.Boiler;
	public function Boiler(scheme:SchemeBase) {
		super(scheme);
	}
	public function getId():Number {
		return ID.Boiler;
	}
	/*public function calculate(input:Socket) {
		var output = getSocket(0);
		var water = new Water();
		//the pressure in the boiler is set by external calculating procedure
		output.G = Config.BoilerW/water.r(output.P);
		output.h = water.hsv(output.P);
	}*/
	public function fillParams(input:Socket, table:Object) {
		var output = getSocket(0);
		output.G = table.G;
		output.h = table.h1;
		// Note!!! It's not correct!
		output.P = table.P1;
		this.clip.showMeasurement(output.P);
	}
	public function installInstrument(name:String) {
		switch (name) {
		case "Manometer" :
			this.clip.showManometer();
			break;
		}
	}
	public function turnOn() {
		if(this.clip.isWorking())
			return;
		this.clip.showWorking();
		// dynamic typing
		if(getLab().getScheme().syncWithBoiler)
			getLab().getScheme().syncWithBoiler();
		this.scheme.logTurningOn(getId());
	}
	public function isTurnedOn():Boolean {
		return this.clip.isWorking();
	}
}
