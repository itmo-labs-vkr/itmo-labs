import Tiles.*;
import flash.geom.Transform;
import flash.geom.Point;
import flash.geom.Matrix;
import Graphics.Common.Clip;
import Graphics.Common.Equipment;
class Equipment.EquipmentBase
{
	public var justCreated:Boolean = false;
	private var redCross:Clip;
	
	//TiledObject properties
	private var lab;
	
	private var clip:Equipment;
	private var trans:Transform;
	private var scheme:SchemeBase;
	
	//dragging starting mouse position
	private var dragging:Boolean;
	private var first_click:LocalPoint;
	private var start_point:TiledPoint;
	private var coloured:Boolean = false;
	
	//depth
	static private var maxDepth:Number = 1;
	
	//sockets
	private var sockets:Array;
	
	public function EquipmentBase(scheme:SchemeBase) {
		this.scheme   = scheme;
		this.dragging = false;
		this.trans    = null;
	}
	
	public function getClip() {
		return this.clip;
	}
	
	public function bindClip(clip:Equipment) {
		this.clip = clip;
		this.trans = new Transform(this.clip);
		this.lab = this.clip._parent;
		initSockets();
	}
	
	public function getId():Number {
		return -1;
	}
	
	public function installInstrument(name:String) {
		// overridable
	}
	public function allInstrumentsInstalled():Boolean {
		return this.clip.isAllInstrumentsShown();
	}

	//sockets support
	private function initSockets() {
		this.sockets = new Array();
		getSockets(this.clip, this.sockets);
		moveSockets();
	}
	
	private function getSockets(clip:MovieClip, arr:Array) {
		for(var i = 0; clip["socket"+i]; i++)
			arr.push(new Socket(this, clip["socket"+i]));
		for(var pn in clip) {
			if(pn.indexOf("socket", 0)!=0 && typeof(clip[pn])=="movieclip")
				getSockets(clip[pn],arr);
		}
	}
	
	public function ptInAncestorSpace(anc:MovieClip, clip:MovieClip, pt:Point):Point {
		var cpt = pt;
		var ccl = clip;
		do {
			cpt = ccl._parent.transform.matrix.transformPoint(cpt);
			ccl = ccl._parent;
		} while(ccl != anc && ccl._parent != null);
		if(ccl._parent == null && Config.Trace) trace("ptInAncestorSpace: reached the top of the movies tree");
		return cpt;
	}
	
	private function moveSockets() {
		for(var i = 0; i < this.sockets.length; i++) {
			var s = this.sockets[i];
			var m = s.getMark();
			var ltpt = ptInAncestorSpace(this.clip, m, new Point(m._x, m._y));
			var rbpt = ptInAncestorSpace(this.clip, m, new Point(m._x + m._width, m._y + m._height));
			if(ltpt.x - rbpt.x > 5 || ltpt.y - rbpt.y > 5) {
				var tmp = ltpt;
				ltpt = rbpt;
				rbpt = tmp;
			}
			var tpt = this.lab.getPlane().createNearestTPFromSP(new StagePoint(ltpt.x, ltpt.y));
			s.move(
				tpt.tileX*2 + Math.round(Math.abs(ltpt.x - rbpt.x)/this.getTileSize()),
				tpt.tileY*2 + Math.round(Math.abs(ltpt.y - rbpt.y)/this.getTileSize()));
		}
	}
	
	public function getSocket(i:Number) {
		return this.sockets[i];
	}
	
	public function getSocketsNumber() {
		return this.sockets.length;
	}
	
	public function getOtherSocket(sock:Socket) {
		for(var i = 0; i < this.sockets.length; i++)
			if(this.sockets[i] != sock)
				return this.sockets[i];
		return null;
	}

	//dragging functions 
	public function startDragging():Void {
		if(!this.dragging) {
			this.first_click = new LocalPoint(this.clip, this.clip._xmouse,this.clip._ymouse);
			this.start_point = getTiledArea().getLeftTopCorner();
			this.dragging = true;
			if(Config.Trace) trace("Equipment dragging started!");
		}
	}
	
	public function doDragging():Void {
		if(this.dragging) {	
			var in_area = this.justCreated ? this.lab.getMainArea() : this.lab.getWorkArea(); 
			var mouse_pos:StagePoint = this.lab.getMousePoint();
			var new_point = new StagePoint(
							mouse_pos.x - this.first_click.x,
							mouse_pos.y - this.first_click.y);
			var new_tpoint:TiledPoint = this.lab.getPlane().createPointFromStagePoint(new_point);
			
			//move point
			var dest_point:TiledPoint = getTiledArea().getLeftTopCorner();
		
			//test for fitting to 'in_area'
			var area:TiledArea = getTiledArea().copy();
			area.move(new_tpoint.tileX, 0);
			if(in_area.hasArea(area))
				dest_point.move(new_tpoint.tileX, dest_point.tileY);
			area.move(0, new_tpoint.tileY);
			if(in_area.hasArea(area))
				dest_point.move(dest_point.tileX, new_tpoint.tileY);
		
			//move if the destination point isn't equal to the current position
			if(!dest_point.isEqual(getTiledArea().getLeftTopCorner())) {
				moveToPoint(dest_point); 
				var ie:Array = intersectedEquipment();
				if(ie.length > 0) {
					putToFrontOf(ie);
					this.redColoured = true;
				} else
					this.redColoured = false;
			}
		}
	}
	
	private function endDragging()
	{	
		if(this.justCreated && (!this.lab.getWorkArea().hasArea(this.getTiledArea()) || this.coloured))
			this.scheme.deleteEquipment(this);
		if(this.coloured) {
			this.moveToPoint(this.start_point);
			this.redColoured = false;
		}
		this.justCreated = false;
		this.dragging = false;
	}
	
	public function moveToPoint(point:TiledPoint) {
		var pnt = point.toStagePoint();
		this.clip._x = pnt.x;
		this.clip._y = pnt.y;
		moveSockets();
	}
	
	public function move(tileX:Number, tileY:Number) {
		moveToPoint(this.lab.getPlane().createPoint(tileX, tileY));
	}
	
	public function set redColoured(value:Boolean) {	
		var ct = this.trans.colorTransform;
		if(value) {
			ct.blueMultiplier = 0;
			ct.greenMultiplier = 0;
		}
		else {
			ct.blueMultiplier = 1;
			ct.greenMultiplier = 1;
		}
		this.trans.colorTransform = ct;
		this.coloured = value;
	}
	
	public function get redColoured():Boolean {
		return this.coloured;
	}
	
	public function markAsJustCreated():Void {
		this.justCreated = true;
	}
	
	public function getTiledArea() {
		return this.lab.getPlane().createAreaFromClip(this.clip);
	}
	
	public function getTileHeight() {
		return getTiledArea().tileHeight;
	}
	
	public function getTileX() {
		return getTiledArea().tileX;
	}
	
	public function getTileY() {
		return getTiledArea().tileY;
	}
	
	public function getTileSize() {
		return this.lab.getPlane().tileSize;
	}
	
	public function intersectedEquipment():Array {
		var r:Array = new Array();
		for(var i = 0; i < this.lab.getScheme().length(); i++) {
			var et = this.lab.getScheme().item(i);
			if( et.getTiledArea().intersectsWith(getTiledArea()) && et != this)
				r.push(et);
		}
		return r;
	}
	
	public function putToFrontOf(equipment:Array) {
		var max_depth:Number = this.clip.getDepth();
		var max_depth_i:Number = -1;
		for(var i in equipment) {
			var depth = equipment[i].clip.getDepth();
			if(depth > max_depth) {
				max_depth = depth;
				max_depth_i = i;
			}
		}
		if(max_depth_i >= 0)
			this.clip.swapDepths(equipment[i].clip);
	}
	
	private function deleteClip():Void {
		this.clip.removeMovieClip();
	}
	
	public function getLab() {
		return this.lab;
	}
}