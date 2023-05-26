import GUI.Lab3;
class Scheme3 extends Scheme3And4Base {
	private var lab:Lab3;
		
	public function Scheme3(lab:Lab3) {
		super(lab);
		this.chainPattern = new Array(ID.Boiler, ID.Heater, ID.Chamber, ID.Valve, ID.Chamber, ID.Condenser);
		this.AdditionalEquipmentNumber = 2;
	}

// Соединение и проверка корректности схемы
	private function checkAdditionalEquipment():Void {
		checkTank();
		checkGlass();
	}
	
	private function checkTank():Void {
		var tanks:Array = this.getEquipmentById(ID.Tank);
		
		if(tanks.length == 0)
			throw new Error(Strings.ErrorNoTank);
		
		//assume that after the scheme checking 
		//we have one condenser in the scheme
		var condenser = this.getEquipmentById(ID.Condenser)[0];
		var right_connected = false;
		for(var i in tanks) { 
			right_connected = condenser.getTiledArea().tileX - tanks[i].getTiledArea().tileWidth == tanks[i].getTiledArea().tileX
							  && condenser.getTiledArea().tileY + 2 == tanks[i].getTiledArea().tileY;
			if(right_connected)
				break;
		}
		if(!right_connected)
			throw new Error(Strings.ErrorWrongTankConnection);
	}

// Проверка наличия всех требуемых приборов
	public function checkInstruments():Void {
		var ok:Boolean = getEquipmentById(ID.Chamber)[0].allInstrumentsInstalled() 
					  && getEquipmentById(ID.Chamber)[1].allInstrumentsInstalled()
					  && getEquipmentById(ID.Condenser)[0].allInstrumentsInstalled();
		if(!ok) throw new Error(Strings.ErrorNotEnoughInstruments);
	}

// Расстановка показаний 
	public function fillSchemeParams() {
		resetAllSockets();
		
		//Get params table
		var table = ParametersTableLab3.getVariant();	
		
		// Add to table absolute pressures
		table.P1 = Utils.relPressureToAbsolute(table.p1, table.B);
		table.P2 = Utils.relPressureToAbsolute(table.p2, table.B);
		
		var boiler = this.chain[0];
		boiler.fillParams(null, table); //here info from table
		
		var i = new SocketChainIterator(boiler.getSocket(0));
		while(!i.endOfChain()) {
			i.getEquipment().fillParams(i.getIn(), table);
			i.next();
		}
		getEquipmentById(ID.Condenser)[0].fillWaterParams(table);
		getEquipmentById(ID.Tank)[0].setMassFlow(table.Gw);
		getEquipmentById(ID.Glass)[0].setMassFlow(table.G);
		this.lab.getBarometer().showMeasurement(table.B);
	}
	
	public function gatherMeasurements():Array {
		var r = new Object();
		/* Barometer */
		r.B = this.lab.getBarometer().getB();
		/* Chambers */
		var ch1 = getEquipmentById(ID.Chamber)[0];
		var ch2 = getEquipmentById(ID.Chamber)[1];
		if(ch1.getP() < ch2.getP()) {
			var tmp = ch1;
			ch1 = ch2;
			ch2 = tmp;
		}
		r.p1 = Utils.absPressureToRelative(ch1.getP(), r.B);
		r.t1 = ch1.gett();
		r.p2 = Utils.absPressureToRelative(ch2.getP(), r.B);
		r.t2 = ch2.gett();
		r.i1 = ch2.geth();
		/* Condenser */
		var cond = getEquipmentById(ID.Condenser)[0];
		r.tw1 = cond.gettw1();
		r.tw2 = cond.gettw2();
		r.tk  = cond.gettk();
		r.G   = cond.getG();
		r.Gw  = cond.getGw();
		
		return r;
	}
}