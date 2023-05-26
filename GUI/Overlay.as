import Graphics.Misc.Puddle
class GUI.Overlay extends Graphics.Common.Clip {
	private var hint;
	private var timer_id:Number;
	private var hintDelay = 500;
	private var tank_puddle:Puddle;
	private var glass_puddle:Puddle;
	public function Overlay() {
		this.hint.autoSize = true;
		hideHint();
	}
	public function showHint(hint:String) {
		this.hint.text = hint;
		this.timer_id = setInterval(this, "makeHintVisible", this.hintDelay);
	}
	public function makeHintVisible() {
		this.hint._x = (_root.width < _root._xmouse + this.hint._width)? _root._xmouse : _root._xmouse - this.hint._width;
		this.hint._y = _root._ymouse - this.hint._height - 1;
		this.hint._visible = true;
		clearInterval(this.timer_id);
	}
	public function hideHint() {
		clearInterval(this.timer_id);
		this.hint._visible = false;
	}
	public function getTankPuddle():Puddle {
		return this.tank_puddle;
	}
	public function getGlassPuddle():Puddle {
		return this.glass_puddle;
	}
}