class Equipment.Condenser extends Equipment.EquipmentBase
{
	//static private var D:Number = 0.01; //internal pipe diameter, m
	//static private var dzeta:Number = 1;
	//static private var DeltaP:Number = Config.CondenserDeltaP;
	
	private var clip:Graphics.Condenser;
	
	public var tw1:Number;
	public var tw2:Number;
	public var tkd:Number;
	
	public var Gw:Number;
	
	public function Condenser(scheme:SchemeBase) {
		super(scheme);		
	}
	public function getId():Number {
		return ID.Condenser;
	}
	public function installInstrument(name:String) {
		switch(name) {
			case "TemperatureSensor":
				this.clip.showTemperatureSensorAt(getLab().getMousePointGlobal());
				break;
		}
	}
	public function turnOn() {
		if(this.clip.isWorking())
			return;
		this.clip.showWater();
		if(getLab().getId() == ID.Lab4)
			this.clip.showWaterOutlet();
		if(getLab().getScheme().syncWithCondenser)
			getLab().getScheme().syncWithCondenser();
		this.scheme.logTurningOn(getId());
	}
	public function isTurnedOn():Boolean {
		return this.clip.isWorking();
	}
	
	public function isCondensation():Boolean {
		return this.clip.isCondensation();
	}
	
	//calculate 
	/*public function calculate(input:Socket)
	{
		var output = getOtherSocket(input);
		var water  = new Water;
		
		//var ro = water.roPh(input.P, input.h);
		//var w = input.G / ro / (Math.PI * D*D / 4);
		//var deltaP = dzeta * ro * w*w / 2;
		output.P = input.P - Condenser.DeltaP / 1000;
		output.h = input.h;
		output.G = input.G;
	}*/
	
	public function fillParams(input:Socket, table:Object) {
		var output = getOtherSocket(input);
		output.P = 101.2;
		output.h = input.h;
		output.G = input.G;
	}
	
	public function gettk():Number {
		return this.tkd;
	}
	public function gettw1():Number {
		return this.tw1;
	}
	public function gettw2():Number {
		return this.tw2;
	}
	public function getG():Number {
		return getSocket(0).G;
	}
	public function getGw():Number {
		return this.Gw;
	}
	
	/*public function calculateWater()
	{
		var water = new Water();
		var Gkd  = this.getSocket(0).G;
		var h_in = this.getSocket(0).h;
		this.tw1 = randRange(6, 14);
		this.tkd = this.tw1;
		var ro_kd = water.rol(101.2, this.tkd);
		var h_out = water.h(ro_kd, this.tkd);
		
		this.Gw = Tank.volume * 1000 / (Glass.volume * ro_kd * randRange(5, 7) / 10 / Gkd);
		this.tw2 = this.tw1 + (h_in - h_out)*Gkd / (this.Gw * Water.Cp);
	}*/
	
	public function fillWaterParams(table:Object) {
		this.tw1 = table.tw1;
		this.tw2 = table.tw2;
		this.tkd = this.tw1;
		this.Gw  = table.Gw;
		this.clip.showMeasurements(this.tw2, this.tw1, this.tkd);
	}
}