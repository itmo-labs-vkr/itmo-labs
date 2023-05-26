import flash.geom.Matrix;
import flash.geom.Point;
class Graphics.Common.Clip extends MovieClip {
	private var isPaused:Boolean;
	public function Clip() {
		pause();
	}
	public function play() {
		this.isPaused = false;
		playAll();
	}
	public function pause() {
		this.isPaused = true;
		pauseAll();
	}
	public function correctState() {
		if(this.isPaused)
			pauseAll();
		else
			playAll();
	}
	public function playItself() {
		super.play();
	}
	public function stopItself() {
		super.stop();
	}
	// Ф-ии для переопределения
	// проиграть и остановить вложенные клипы
	private function pauseAll() {
	}
	private function playAll() {
	}
	
	// Остановить клип и все вложенные
	private function stopClip(clip:MovieClip) {
		clip.stop();
		for (var name in clip) {
			if (typeof (clip[name]) == "movieclip") {
				stopClip(clip[name]);
			}
		}
	}
	// Проиграть клип и все вложенные
	private function playClip(clip:MovieClip) {
		clip.play();
		for (var name in clip) {
			if (typeof (clip[name]) == "movieclip") {
				playClip(clip[name]);
			}
		}
	}
	// Показать клип
	private function showClip(clip:MovieClip) {
		clip._visible = true;
	}
	// Скрыть клип
	private function hideClip(clip:MovieClip) {
		clip._visible = false;
	}
	private function isVisible(clip:MovieClip) {
		return clip._visible;
	}
}
