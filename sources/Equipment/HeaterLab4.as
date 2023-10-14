class Equipment.HeaterLab4 extends Equipment.Heater {
	public function HeaterLab4(scheme:SchemeBase) {
		super(scheme);
	}
	public function installInstrument(name:String) {
		switch(name) {
			case "TemperatureSensor":
				var p = getLab().getMousePointGlobal();
				this.clip.showTemperatureSensorAt(p);
				break;
			case "Wattmeter":
				this.clip.showWattmeter();
				break;
		}
	}
}