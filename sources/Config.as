class Config {	
	// The Power of the boiler, kWatts
	static var BoilerW = 15;
	// Pressure difference in the condenser, Pa
	static var CondenserDeltaP = 2000;
	// The Heater power, kWatts
	static var HeaterW = 0.8; //power in kW
	// Valve pipe internal diameter, m
	static var ValveD = 0.01;
	// Valve resistance coefficient range
	static var ValveDzetaMin = 25;
	static var ValveDzetaMax = 27; 
	// Frame rate
	static var FrameRate = 12;
	static var Trace = false;
	static var Standalone = true;
}