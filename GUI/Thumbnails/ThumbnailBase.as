import GUI.Thumbnails.Thumbnail;
class GUI.Thumbnails.ThumbnailBase extends Graphics.Common.Clip
{
	private var host:Thumbnail = null;
	private var clip:MovieClip;
	
	public function init(host:Thumbnail, cls:String, scale:Number) {
		this.host = host;
		this.clip = this.attachMovie(cls, "clippus" , this.getNextHighestDepth());
		this.clip._xscale = scale * 100;
		this.clip._yscale = scale * 100;
	}
	public function getClip():MovieClip {
		return this.clip;
	}
	public function onPress() {
		if(this.host)
			this.host.onPress();
	}
	public function onRelease() {
		if(this.host)
			this.host.onRelease();
	}
	public function onReleaseOutside() {
		if(this.host)
			this.host.onReleaseOutside();
	}
	public function onRollOver() {
		if(this.host)
			this.host.onRollOver();
	}
	public function onRollOut() {
		if(this.host)
			this.host.onRollOut();
	}
	public function onMouseMove() {
		if(this.host)
			this.host.onMouseMove();
	}
}