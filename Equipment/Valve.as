class Equipment.Valve extends Equipment.EquipmentBase {
	private var position:Number;
	private var clip:Graphics.Valve;
	public function Valve(scheme:SchemeBase) {
		super(scheme);
		this.position = 0; // макс. позиция - это число подвариантов в таблице параметров для 6ой лабораторной
	}
	public function getId():Number {
		return ID.Valve;
	}
	/*public function calculate(input:Socket)
	{
		var output = getOtherSocket(input);
		var water  = new Water;

		function randRange(min:Number, max:Number):Number {
    		return Math.floor(Math.random() * (max - min + 1)) + min; }
		
		var ro = water.roPh(input.P, input.h);
		var w = input.G / ro / (Math.PI * Config.ValveD*Config.ValveD / 4);
		var deltaP = randRange(Config.ValveDzetaMin, ValveDzetaMax) * ro * w*w / 2;
		
	}*/
	public function fillParams(input:Socket, table:Object) {
		var output = getOtherSocket(input);
		output.P = table.P2;
		output.h = input.h;
		output.G = input.G;
	}
	
	public function onPressOpenButton() {
		if(this.position < ParametersTableLab6.subvariantsNum - 1) {
			this.position++;
			if(this.position == ParametersTableLab6.subvariantsNum - 1)
				this.clip.disableOpenButton();
			getLab().getScheme().fillSchemeParamsSubvar(this.position); // перебить параметры в схеме
			if(!Config.Standalone) getLab().getApp().onParametersChanged();
			this.clip.enableCloseButton();
		}
	}
	public function onPressCloseButton() {
		if(this.position > 0) {
			this.position--;
			if(this.position == 0)
				this.clip.disableCloseButton();
			getLab().getScheme().fillSchemeParamsSubvar(this.position);
			if(!Config.Standalone) getLab().getApp().onParametersChanged();
			this.clip.enableOpenButton();
		}			
	}
}