//import Equipment.*;
class ID {
	private static var MinEquipmentId = 1;
	public static var Boiler 	 = 1;
	public static var Chamber 	 = 2;
	public static var Compressor = 3;
	public static var Condenser  = 4;
	public static var Elbow 	 = 5;
	public static var Flowmeter  = 6;
	public static var Glass 	 = 7;
	public static var Heater 	 = 8;
	public static var Pipe 		 = 9;
	public static var Receiver   = 10;
	public static var Tank 		 = 11;
	public static var Valve 	 = 12;
	public static var Nozzle	 = 13;
	private static var MaxEquipmentId = 13;
	
	private static var MinLabId = 100;
	public static var Lab3 = 100;
	public static var Lab4 = 101;
	public static var Lab6 = 102;
	private static var MaxLabId = 102;
	
	public static function isEquipmentId(id:Number):Boolean {
		return MinEquipmentId <= id && id <= MaxEquipmentId;
	}
	
	public static function isLabsId(id:Number):Boolean {
		return MinLabId <= id && id <= MaxLabId;
	}
	
	public static function clsNameToId(clsName:String):Number {
		var cls = new Array(
			"", "Boiler", "Chamber", "Compressor", "Condenser", "Elbow", 
			"Flowmeter", "Glass", "Heater", "Pipe", "Receiver", "Tank", "Valve", "Nozzle");
		for(var i = 1; i < cls.length; i++) 
			if(cls[i] == clsName) 
				return i;
		if(Config.Trace) trace("Cannot convert clsName to Id");
	}
	
	public static function createObjectById(id:Number, labId:Number, o:SchemeBase) {
		// Stupid abstract factory
		switch(id) {
			case ID.Boiler:     return new Equipment.Boiler(o); 		
			case ID.Chamber: 	return new Equipment.Chamber(o);		
			case ID.Compressor:	return new Equipment.Compressor(o); 	
			case ID.Condenser: 	
				if(labId == ID.Lab4) return new Equipment.CondenserLab4(o); else return new Equipment.Condenser(o);
			case ID.Elbow: 		return new Equipment.Elbow(o); 		
			case ID.Flowmeter: 	return new Equipment.Flowmeter(o);		
			case ID.Glass:		return new Equipment.Glass(o);			
			case ID.Heater:			
				if(labId == ID.Lab4) return new Equipment.HeaterLab4(o); else return new Equipment.Heater(o);	
			case ID.Pipe:		return new Equipment.Pipe(o);			
			case ID.Receiver:	return new Equipment.Receiver(o);		
			case ID.Tank:		return new Equipment.Tank(o);			
			case ID.Valve:		return new Equipment.Valve(o);		
			case ID.Nozzle:	    return new Equipment.Nozzle(o);
			default:
				if(Config.Trace) trace("No id found in SchemeBase.createEquipment");
		}
	}
}
	