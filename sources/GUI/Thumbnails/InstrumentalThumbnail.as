import GUI.Thumbnails.Thumbnail;
import GUI.Thumbnails.InstrumentalThumbnailPanel;
import GUI.LabBase;

class GUI.Thumbnails.InstrumentalThumbnail extends GUI.Thumbnails.Thumbnail
{
	private var sensor:MovieClip;
	
	public function InstrumentalThumbnail(panel:InstrumentalThumbnailPanel, cls:String) {
		super(panel, cls, 1);
	}
	public function onPress() {
		if(this.panel.isEnabled()) {
			this.panel.getLab().hideHint();
			this.sensor = this.panel.getLab().attachMovie(this.className, "instrument", this.panel.getLab().getNextHighestDepth());
			this.sensor._x = this.thumb._x;
			this.sensor._y = this.thumb._y;
			this.panel.getLab().startInstallTracking(this.className);
		}
	}
	public function onRelease() {
		if(this.panel.isEnabled()) {
			this.sensor.removeMovieClip();
			this.panel.getLab().stopInstallTracking();
		}
	}
	public function onReleaseOutside() {
		if(this.panel.isEnabled()) {
			this.sensor.removeMovieClip();
			this.panel.getLab().stopInstallTracking();
		}
	}
	public function onMouseMove() {
		if(this.panel.isEnabled()) {
			if(this.sensor) {
				var mp = this.panel.getLab().getMousePoint();
				this.sensor._x = mp.x;
				this.sensor._y = mp.y;
			}
		}
	}
	public function onRollOver() {
		if(this.panel.isEnabled()) {
			this.thumb.useHandCursor = true;
			this.panel.getLab().showHint(Strings.InstrumentNameByClsName(this.className));
		}
	}
	
	public function onRollOut() {
		this.panel.getLab().hideHint();
		this.thumb.useHandCursor = false;
	}
}