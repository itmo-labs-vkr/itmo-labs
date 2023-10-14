class Equipment.Compressor extends Equipment.EquipmentBase {
	private var clip:Graphics.Compressor;
	public function Compressor(scheme:SchemeBase) {
		super(scheme);
	}
	public function getId():Number {
		return ID.Compressor;
	}
	public function turnOn():Void {
		if(this.clip.isWorking())
			return;
		this.clip.showWorking();
		if(getLab().getScheme().syncWithCompressor)
			getLab().getScheme().syncWithCompressor();
		this.scheme.logTurningOn(getId());
	}
	public function isTurnedOn():Boolean {
		return this.clip.isWorking();
	}
	public function fillParams(input:Socket, table:Object) {
		var output = getSocket(0);
		output.P = table.P1;
		output.h = 10;
		output.G = 10;
	}
}