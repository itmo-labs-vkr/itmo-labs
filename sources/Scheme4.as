class Scheme4 extends Scheme3And4Base {
	private var lab:GUI.Lab4;
	public function Scheme4(lab:GUI.Lab4) {
		super(lab);
		this.chainPattern = new Array(ID.Boiler, ID.Heater, ID.Valve, ID.Condenser);
		this.AdditionalEquipmentNumber = 1;
	}

// Соединение и проверка корректности схемы
	private function checkAdditionalEquipment():Void {
		checkGlass();
	}
	
// Проверка наличия всех требуемых приборов
	public function checkInstruments():Void {
		var ok:Boolean = getEquipmentById(ID.Heater)[0].allInstrumentsInstalled() 
					  && getEquipmentById(ID.Boiler)[0].allInstrumentsInstalled();
		if(!ok) throw new Error(Strings.ErrorNotEnoughInstruments);
	}

// Ф-ии записи и проверки последовательности включения оборудования
			
// Расстановка показаний 
	public function fillSchemeParams() {
		resetAllSockets();
		
		if(Config.Trace) trace("Filling parameters");
		
		//Get params table
		var table = ParametersTableLab4.getVariant();
		
		/* Pressure conversion */
		table.P1 = Utils.relPressureToAbsolute(table.p1, table.B);
		
		var boiler = this.chain[0];
		boiler.fillParams(null, table); //here info from table
		
		var i = new SocketChainIterator(boiler.getSocket(0));
		while(!i.endOfChain()) {
			i.getEquipment().fillParams(i.getIn(), table);
			i.next();
		}
		getEquipmentById(ID.Glass)[0].setMassFlow(table.G);
		this.lab.getBarometer().showMeasurement(table.B);
	}
	
	public function gatherMeasurements():Array {
		var r = new Object();
		/* Barometer */
		r.B = this.lab.getBarometer().getB();
		/* Heater */
		var heater = getEquipmentById(ID.Heater)[0];
		r.p1 = Utils.absPressureToRelative(heater.getP(), r.B);
		r.t1 = heater.gett1();
		r.t2 = heater.gett2();
		r.W  = heater.getW();
		r.Wl = heater.getWl();
		/* Condenser */
		var glass = getEquipmentById(ID.Glass)[0];
		r.G = glass.getG();
				
		return r;
	}
}