import Equipment.EquipmentBase;
class Socket {
	private var x:Number;
	private var y:Number;
	private var connectedTo:Socket;
	private var owner:EquipmentBase;
	private var mark:MovieClip;
	//flow state 
	private var _P:Number;
	private var _h:Number;
	private var _G:Number;
	private var _t:Number;
	public function Socket(owner:EquipmentBase, mark:MovieClip) {
		this.owner = owner;
		this.mark  = mark;
		disconnect();
		reset();
	}
	public function reset() {
		//barometric pressure, kPa
		this._P = 101.2;
		//vapor flow, kg/s
		this._h = 0;
		this._G = 0;
		this._t = -273.15;
	}
	public function move(x:Number, y:Number) {
		if (x != this.x || y != this.y) {
			disconnect();
		}
		this.x = x;
		this.y = y;
	}
	public function connect(other:Socket):Boolean {
		if (this.x == other.x && this.y == other.y && this.owner != other.owner) {
			this.connectedTo = other;
			other.connectedTo = this;
			return true;
		}
		return false;
	}
	public function disconnect() {
		if (this.connectedTo != null) {
			this.connectedTo.connectedTo = null;
			this.connectedTo = null;
		}
	}
	public function isConnected():Boolean {
		if (this.connectedTo == null) {
			return false;
		}
		return true;
	}
	// General getters
	public function getConnectedSocket() {
		return this.connectedTo;
	}
	public function getOwner() {
		return this.owner;
	}
	public function getMark():MovieClip {
		return this.mark;
	}
	// Flow state setters
	public function set P(P:Number) {
		this._P = P;
		if (isConnected()) {
			this.connectedTo._P = P;
		}
	}
	public function set h(h:Number) {
		this._h = h;
		if (isConnected()) {
			this.connectedTo._h = h;
		}
	}
	public function set G(G:Number) {
		this._G = G;
		if (isConnected()) {
			this.connectedTo._G = G;
		}
	}
	public function set T(t:Number) {
		this._t = t;
		if (isConnected()) {
			this.connectedTo._t = t;
		}
	}
	// Flow state getters
	public function get P():Number {
		return this._P;
	}
	public function get h():Number {
		return this._h;
	}
	public function get G():Number {
		return this._G;
	}
	public function get T():Number {
		if (Math.abs(this._t+273.15)<1e-6) {
			var water = new Water();
			var ro = water.roPh(this._P, this._h);
			this._t = water.getLastT();
		}
		return this._t;
	}
	//Debug only functions
	function asText() {
		return "P: "+this._P+"; h: "+this._h+"; G: "+this._G;
	}
	function debug_coords():String {
		return "["+this.x+";"+this.y+"]";
	}
}
