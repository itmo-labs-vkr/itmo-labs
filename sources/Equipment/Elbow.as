/*import Equipment;
import Lab;
import Socket;
import flash.geom.*;*/

class Equipment.Elbow extends Equipment.EquipmentBase
{
	private var cursor:Boolean;
	private var clip:Graphics.Elbow;
	
	public function Elbow(scheme:SchemeBase) {
		super(scheme);
	}
	
	public function getId():Number {
		return ID.Elbow;
	}

	public function calculate(input:Socket):Void {
		var output = getOtherSocket(input);
		output.P = input.P;
		output.h = input.h;
		output.G = input.G;
	}
	
	public function fillParams(input:Socket, table:Object):Void {
		calculate(input);
	}
	public function markAsCursor():Void {
		this.cursor = true;
	}
	public function isCursor():Boolean { 
		return this.cursor;
	}
	public function rotate():Void {
		this.clip.rotate();
		moveSockets();
		trace("Sockets:");
		for(var i = 0; i < this.sockets.length; i++)
			trace(this.sockets[i].debug_coords());
	}
}