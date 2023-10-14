import GUI.LabBase;
import Equipment.*;
class SchemeBase {
	private var lab:LabBase;
	private var scheme:Array;
	private var chain:Array;
	private var equipmentCount:Number;
	private var turningOnLog:Array;
	private var rightTurningOnSeq:Array;
	private var AdditionalEquipmentNumber:Number;
	private var chainPattern:Array;
	private var keyId:Number;
	
	public function SchemeBase(lab:LabBase) {
		this.lab    = lab;
		this.scheme = new Array();
		this.equipmentCount = 0;
		this.turningOnLog = new Array();
		// overridable defaults
		this.keyId = -1;
		this.chainPattern = new Array();
		this.AdditionalEquipmentNumber = 0;
		this.rightTurningOnSeq = new Array();
	}
	
	public function item(i:Number):EquipmentBase {
		return this.scheme[i];
	}
	
	public function length():Number {
		return this.scheme.length;
	}
	
	private function lengthWithoutPipes(et:Array):Number {
		for(var i=0, c=0; i < et.length; i++) 
			if(et[i].getId() != ID.Pipe && et[i].getId() != ID.Elbow)
				c++;
		return c;
	}

// Операции с гнездами
	private function connectAllSockets():Void {	
		var os = this.scheme;
		for(var i = 0; i < os.length; i++)
			for(var j = 0; j < os[i].getSocketsNumber(); j++)
				for(var n = 0; n < os.length; n++)
					for(var m = 0; m < os[n].getSocketsNumber(); m++)
						os[i].getSocket(j).connect(os[n].getSocket(m));
	}

	private function resetAllSockets():Void {
		var os = this.scheme;
		for(var i = 0; i < os.length; i++)
			for(var j = 0; j < os[i].getSocketsNumber(); j++) 
				os[i].getSocket(j).reset();
	}
	
	private function disconnectAllSockets() {
		var os = this.scheme;
		for(var i = 0; i < os.length; i++)
			for(var j = 0; j < os[i].getSocketsNumber(); j++)
				os[i].getSocket(j).disconnect();
	}
	
	// Debug only method
	private function traceAllSockets() {
		var os = this.scheme;
		trace("");
		trace("[SOCKET TRACE]");
		for(var i = 0; i < os.length; i++) {
			trace(Strings.EquipmentNameById(os[i].getId()));
			for(var j = 0; j < os[i].getSocketsNumber(); j++) {
				trace(j + ": " + os[i].getSocket(j).isConnected() + " " + os[i].getSocket(j).debug_coords());
			}
		}
		trace("[SOCKET TRACE]");
		trace("");
	}
	
// Соединение и проверка корректности схемы
	public function checkAndLink():Void {
		//reconnect sockets
		disconnectAllSockets();
		connectAllSockets();
			traceAllSockets();
			
		linkScheme(searchKey(this.keyId));
		checkSchemeChain(this.chainPattern);
		checkAdditionalEquipment();
		checkUnnecessaryEquipment();
	}
	
	private function searchKey(keyId:Number):Object {
		var keys:Array = getEquipmentById(keyId);
		
		if(keys.length == 0)
			throw new Error(Strings.ErrorNo(keyId))
		if(keys.length > 1)
			throw new Error(Strings.ErrorMoreThanOne(keyId));
			
		return keys[0];
	}

	private function buildChainFromSocket(s:Socket):Array {
		var chain = new Array();
		var i = new SocketChainIterator(s);
		while(!i.endOfChain()) {
			if(i.getOut() == s) throw(Strings.ErrorLoopFound);
			chain.push(i.getEquipment());
			i.next();
		}
		return chain;		
	}
	
	private function linkScheme(key:Object):Void {
		var fchain = buildChainFromSocket(key.getSocket(0)); // forward chain
		var bchain = new Array(); // back chain
		if(key.getSocketsNumber() == 2) // up to two sockets are supported currenly
			var bchain = buildChainFromSocket(key.getSocket(1));
		bchain.reverse();
		bchain.push(key);
		this.chain = bchain.concat(fchain);
						
		//debug printout chain 
		if(Config.Trace) {
			trace("");
			trace("[CHAIN]");
			for(var i = 0; i < this.chain.length; i++)
				trace(Strings.EquipmentNameById(this.chain[i].getId()));
			trace("[CHAIN]");
			trace("");
		}
	}
	
	private function checkSchemeChain(pattern:Array) {
		var pattern_i:Number = 0;
		var error = false;
		for(var i = 0; i < this.chain.length; i++)
			if(this.chain[i].getId() != ID.Elbow && this.chain[i].getId() != ID.Pipe) {// exclude any pipes and elbows
				if(pattern_i == pattern.length) { 
					/* конец паттерна уже достигнут, а элемент, отличный от трубы и угла, встречен */
					error = true;
					break;
				} else {
					if(this.chain[i].getId() == pattern[pattern_i]) {
						/* элемент присутствует в образце, передвигаем итератор */
						pattern_i++;
					} else {
						error = true;
						break;
					}
				}
			}
		if(error) 
			throw new Error(Strings.ErrorWrongConnection(this.chain[i].getId()));
		//eсли конец образца не достигнут по причине окончания цепочки
		if(pattern_i < pattern.length)
			throw new Error(Strings.ErrorNotEnoughElements);
	}
	
	private function checkAdditionalEquipment():Void {
		// OVERRIDABLE
	}
	
	private function checkUnnecessaryEquipment() {
		if(lengthWithoutPipes(this.chain) + AdditionalEquipmentNumber < lengthWithoutPipes(this.scheme)) {
			throw new Error(Strings.ErrorToManyEquipment);
		}
	}

// Проверка наличия всех требуемых приборов
	public function checkInstruments():Void {
		if(Config.Trace) trace("SchemeBase.checkInstruments should be overriden!");
	}

// Ф-ии записи и проверки последовательности включения оборудования
	public function dropTurningOnLog() {
		this.turningOnLog = new Array();
	}
	public function logTurningOn(id:Number) {
		this.turningOnLog.push(id);
	}
	public function checkTurningOn() {
		if(Config.Trace) {
			trace("");
			trace("[TURNINGON]");
			for(var i=0; i<this.turningOnLog.length;i++)
				trace(Strings.EquipmentNameById(this.turningOnLog[i]));
			trace("[TURNINGON]");
			trace("");
		}
		
		var diff = checkTurningOnSequence(this.rightTurningOnSeq);
		checkTurningOnSpecial();
		if(diff) throw new Error(Strings.ErrorWrongTurningOnOrder);
	}
	private function checkTurningOnSpecial() {
		if(Config.Trace) trace("SchemeBase.checkTurningOnSpecial should be overriden!");
	}
	private function checkTurningOnSequence(right_seq:Array) {
		var diff = false;
		if(this.turningOnLog.length != right_seq.length)
			diff = true;
		else
			for(var i=0; i<this.turningOnLog.length;i++)
				if(this.turningOnLog[i] != right_seq[i]) {
					diff = true;
					break;
				}
		return diff;
	}
	private function turningOnOrder(id:Number):Number {
		for(var i in this.turningOnLog) {
			if(this.turningOnLog[i] == id)
				return i;
		}
		return -1;
	}

// Запуск и остановка анимации
	public function play():Void {
		for(var i in this.scheme) 
			this.scheme[i].getClip().play();
	}
	public function pause():Void {
		for(var i in this.scheme) 
			this.scheme[i].getClip().pause();
	}
	public function resetButInstruments():Void {
		for(var i in this.scheme)
			this.scheme[i].getClip().resetButInstruments();
	}
	
// Расстановка показаний 
	public function fillSchemeParams() {
		if(Config.Trace) trace("SchemeBase.fillSchemeParams should be overriden!");
	}

	/*function calculateScheme()
	{
		resetAllSockets();
		
		var current_equipment, in_sock;
		var boiler = this.scheme[0];
		var boiler_sock = boiler.getSocket(0);
		var Patm = boiler_sock.P;
		var P = Patm;
		
		do
		{
			trace("Iteration begin:");
			
			boiler.calculate(null); //the boiler has no input socket
		
			//debug print------------------------- 
			trace("Out: " + boiler_sock.asText());
			trace("");
			//------------------------------------
		
			var out_sock = boiler_sock;
			while(out_sock.isConnected())
			{
				in_sock = out_sock.getConnectedSocket();
				current_equipment = in_sock.getOwner();
				out_sock = current_equipment.getOtherSocket(in_sock);
			
				//Calculate the output of the current equipment
				current_equipment.calculate(in_sock);
				if(out_sock.P < 0)
					break;			
				
				//debug print----------------------
				trace("In: " + in_sock.asText());
				trace("Out: " + out_sock.asText());
				trace("");
				//--------------------------------- 
			}
			
			var dP = boiler_sock.P - out_sock.P;
			P = Patm + dP;
		} while(Math.abs(out_sock.P - Patm) > 1);
		
		trace("Boiler pressure: " + boiler_sock.P);
		
		Alert.show(Water.iter_Ts + " " + Water.iter_P + " " + Water.iter_h + " " +
					Water.iter_hsv + " " +
					Water.iter_hsl + " " +
					Water.iter_r + " " +
					Water.iter_rol + " " +
					Water.iter_rov + " " +
					Water.iter_roPh + " " +
					Water.iter_find_ro + " " +
					Water.iter_find_T);
		
		this.app.getEquipmentByType("Condenser")[0].calculateWater();
	}
	*/
	
	public function gatherMeasurements():Array {
		if(Config.Trace) trace("SchemeBase.gatherMeasurements should be overriden!");
                return new Array();
	}
	
	public function createEquipment(clsName:String):EquipmentBase {
		var neq = null;
		neq = ID.createObjectById(ID.clsNameToId(clsName), this.lab.getId(), this);
		if(neq) {
			neq.bindClip(this.lab.attachMovie(clsName, "equipment" + this.equipmentCount++, this.lab.getNextHighestDepth()));
			neq.getClip().bindMaster(this.lab.getMaster());
			neq.getClip().bindOwner(neq);
			this.scheme.push(neq);
		}
		return neq;
	}	
	public function deleteEquipment(o:Object) {
		var di = -1;
		for(var i in this.scheme)
			if(this.scheme[i] == o) {
				di = i;
				break;
			}
		if(di >= 0) {
			this.scheme.splice(di,1);
			o.deleteClip();
		}
	}
	public function getEquipmentById(id:Number):Array {
		var e:Array = new Array();
		for(var i in this.scheme)
			if(this.scheme[i].getId() == id)
				e.push(this.scheme[i]);
		return e;
	}
}