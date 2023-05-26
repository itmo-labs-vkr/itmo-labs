class Scheme6 extends SchemeBase {
	private var lab:GUI.Lab6;
	private var variant;
	public function Scheme6(lab:GUI.Lab6) {
		super(lab);
		this.keyId = ID.Compressor;
		this.chainPattern = new Array(ID.Compressor, ID.Receiver, ID.Chamber, ID.Nozzle, ID.Chamber, ID.Valve, ID.Flowmeter);
		this.rightTurningOnSeq.push(ID.Compressor);
		this.variant = null;
	}
	
// Проверка наличия всех требуемых приборов
	public function checkInstruments():Void {
		var ok:Boolean = getEquipmentById(ID.Chamber)[0].allInstrumentsInstalled() 
					  && getEquipmentById(ID.Chamber)[1].allInstrumentsInstalled();
		if(!ok) throw new Error(Strings.ErrorNotEnoughInstruments);
	}
// Ф-ии включения
	public function syncWithCompressor():Void {
		for(var i = 0; i < this.chain.length; i++) {
			if(this.chain[i].getId() != ID.Compressor)
				this.chain[i].getClip().showAir();
		}
	}
// Заполнение параметров
	public function fillSchemeParams() {
		this.variant = ParametersTableLab6.getVariant();	
		fillSchemeParamsSubvar(0);
	}
	public function fillSchemeParamsSubvar(sv:Number) {
		resetAllSockets();
		
		//Init params table
		var table = ParametersTableLab6.getSubvariant(this.variant, sv);
		
		// Calculation
		var k = 1.4;
		var R = 280.5;
		var f = Math.PI * table.D * table.D / 4;
		table.P1 = Utils.relPressureToAbsolute(table.p1, table.B);
		table.P2 = table.P1 * table.b;
		table.t2 = Math.pow(1/table.b,(1-k)/k)*(table.t1+273.15) - 273.15;
		table.V  = table.b > 0.528 ? 
			Math.sqrt(2*k/(k-1)*R*(table.t1+273.15)*(1-Math.pow(table.b,(k-1)/k))) * f :
			Math.sqrt(2*k/(k-1)*R*(table.t1+273.15)) * f;
			
		// Variation
		table.P1 = Utils.randVariation(table.P1, 0, 3);
		table.P2 = Utils.randVariation(table.P2, 3, 0);
		table.t2 = Utils.randVariation(table.t2, 5, 5);
		table.V  = Utils.randVariation(table.V,  3, 3);
		
		// Filling in
		var compressor = getEquipmentById(ID.Compressor)[0];
		compressor.fillParams(null, table); //here info from table
		
		var i = new SocketChainIterator(compressor.getSocket(0));
		while(!i.endOfChain()) {
			i.getEquipment().fillParams(i.getIn(), table);
			trace("sock: " + i.getIn().asText() + " " + Strings.EquipmentNameById(i.getEquipment().getId()));
			i.next();
		}
		var rec = getEquipmentById(ID.Receiver)[0].getClip();
		if(sv == 0) // полностью закрытый вентиль
			rec.showFullDischarge();
		else
			rec.showSmallDischarge();
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
		/* Flowmeter */
		var flowmeter = getEquipmentById(ID.Flowmeter)[0];
		r.V = flowmeter.getV();
		
		return r;
	}
}