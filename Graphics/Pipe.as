class Graphics.Pipe extends Graphics.Common.Equipment {
	private var pieces:Array;
	private var length:Number;
	private var is_horizontal:Boolean;
	private var vapor_on:Boolean;
	private var air:Boolean;
	
	public function Pipe() {
		this.pieces = new Array();
		reset();
		resize(1, false);
	}
	public function getLength():Number {
		return this.length;
	}
	private function regen() {
		for (var i = 0; i<this.pieces.length; i++) {
			this.pieces[i].removeMovieClip();
		}
		this.pieces = new Array();
		for (var i = 0; i<this.length; i++) {
			var new_piece = this.attachMovie("PipePiece","piece"+i, this.getNextHighestDepth());
			var sz = 10;
			new_piece._x = (!isHorizontal() ? sz/2 : (i+0.5)*sz);
			new_piece._y = (!isHorizontal() ? (i+0.5)*sz : sz/2);
			new_piece._rotation = (!isHorizontal() ? 0 : 90);
			this.pieces.push(new_piece);
		}
	}
	public function resize(new_length:Number, horizontal:Boolean) {
		if(new_length < 0)
			return;
		this.length        = Math.round(new_length);
		this.is_horizontal = horizontal;
		regen();
	}
	public function isHorizontal():Boolean {
		return this.is_horizontal;
	}
	public function showVapor() {
		this.vapor_on = true;
		this.air = false;
		this.pieces[0].vapor._visible = false;
	}
	public function showAir() {
		this.vapor_on = true;
		this.air = true;
		this.pieces[0].vapor._visible = false;
	}
	public function onEnterFrame() {
		if(this.vapor_on) { 
			if(!this.pieces[0].vapor._visible) {
				showVaporIn();
			}
		} else 
			if(this.pieces[0].vapor._visible) {
				hideVaporIn();
			}
	}
	private function showVaporIn() {
		// если есть, чем менять состояние.
		if(!this.pieces[0].vapor.showAsAir)	
			return;
		for(var i = 0; i < this.pieces.length; i++) {
			if(this.air)
				this.pieces[i].vapor.showAsAir();
			else
				this.pieces[i].vapor.showAsVapor();
		}
		correctState();
	}
	private function hideVaporIn() {
		for (var i = 0; i<this.pieces.length; i++) {
			this.pieces[i].vapor.reset();
		}
		correctState();
	}
	public function reset() {
		this.vapor_on = false;
		this.air = false;
		showVaporIn();
		pause();
	}
	public function pauseAll() {
		for (var i = 0; i<this.pieces.length; i++)
			stopClip(this.pieces[i].vapor);
	}
	public function playAll() {
		for (var i = 0; i<this.pieces.length; i++)
			playClip(this.pieces[i].vapor);
	}
}
