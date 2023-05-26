class Scheme3And4Base extends SchemeBase {
	public function Scheme3And4Base(lab:GUI.LabBase) {
		super(lab);
		this.keyId = ID.Boiler;
		this.rightTurningOnSeq = new Array(ID.Condenser, ID.Boiler, ID.Heater);
	}
	
// Соединение и проверка корректности схемы
	private function checkGlass():Void {
		var glasses:Array = this.getEquipmentById(ID.Glass);
		
		if(glasses.length == 0)
			throw new Error(Strings.ErrorNoGlass);
		
		//assume that after the scheme checking 
		//we have one condenser in the scheme
		var condenser = this.getEquipmentById(ID.Condenser)[0];
		var right_connected = false;
		for(var i in glasses) { 
			right_connected = condenser.getTiledArea().tileX + 2 == glasses[i].getTiledArea().tileX
							  && condenser.getTiledArea().tileY + condenser.getTiledArea().tileHeight <= glasses[i].getTiledArea().tileY;
			if(right_connected)
				break;
		}
		if(!right_connected)
			throw new Error(Strings.ErrorWrongGlassConnection);
	}
	
// Ф-ии записи и проверки последовательности включения оборудования
	public function syncWithBoiler() {
		for(var i=1; i<this.chain.length; i++) { 
			this.chain[i].getClip().showVapor();
		}
		if(getEquipmentById(ID.Condenser)[0].isCondensation())
			getEquipmentById(ID.Glass)[0].getClip().setMassFlow(0.000001);
	}
	public function syncWithCondenser() {
		getEquipmentById(ID.Tank)[0].getClip().setMassFlow(1);
		if(getEquipmentById(ID.Condenser)[0].isCondensation())
			getEquipmentById(ID.Glass)[0].getClip().setMassFlow(0.000001);
	}
	private function checkTurningOnSpecial() {
		//проверка первоочередности пароперегревателя
		if(turningOnOrder(ID.Heater) > -1 /* Если пароперегреватель включен */) {
			if(turningOnOrder(ID.Boiler) == -1 /* и парогенератор не включен */
			|| turningOnOrder(ID.Heater) < turningOnOrder(ID.Boiler) /* или включен позже */)
				throw new Error(Strings.ErrorHeaterBurned); /* то пароперегреватель сгорел */
		}
	}
}