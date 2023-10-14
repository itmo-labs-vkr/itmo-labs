/*import Equipment;
import Lab;
import flash.geom.*;
import Socket;*/
class Equipment.Pipe extends Equipment.EquipmentBase {
	public var clip:Graphics.Pipe;
	public function Pipe(scheme:SchemeBase) {
		super(scheme);
	}
	public function getId():Number {
		return ID.Pipe;
	}
	private function initSockets() {
		this.sockets = new Array(new Socket(this,null), new Socket(this,null));
	}
	private function moveSockets() {
		var area = this.getTiledArea();
		// с Pipe.getLength() надежнее
		if (isHorizontal()) {
			this.sockets[0].move(area.tileX*2, area.tileY*2+1);
			this.sockets[1].move((area.tileX+this.clip.getLength())*2, area.tileY*2+1);
		} else {
			this.sockets[0].move(area.tileX*2+1, area.tileY*2);
			this.sockets[1].move(area.tileX*2+1, (area.tileY+this.clip.getLength())*2);
		}
	}
	public function resize(newTileWidth:Number, newTileHeight:Number) {
		this.clip.resize(Math.max(newTileWidth,newTileHeight), newTileWidth > newTileHeight);
		moveSockets();
	}
	public function isHorizontal():Boolean {
		return this.clip.isHorizontal();
	}
	public function calculate(input:Socket) {
		var output = getOtherSocket(input);
		output.P = input.P;
		output.h = input.h;
		output.G = input.G;
	}
	public function fillParams(input:Socket, table:Object) {
		calculate(input);
	}
}
