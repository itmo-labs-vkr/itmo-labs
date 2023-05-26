class Graphics.Common.PuppetBase extends Graphics.Common.Clip {
	private var master:LabApplicationBase;
	private var owner;
	public function PuppetBase() {
	}
	public function bindMaster(master:LabApplicationBase):Void {
		this.master = master;
	}
	public function getMaster() {
		return this.master;
	}
	public function bindOwner(owner) {
		this.owner = owner;
	}
	public function getOwner() {
		return this.owner;
	}
	public function getId():Number {
		if(this.owner) 
			return this.owner.getId();
		return 0;
	}
	public function onMouseMove() {
		this.master.getBehaviour(getId()).onMouseMove(this);
	}
	public function onMouseDown() {
		this.master.getBehaviour(getId()).onMouseDown(this);
	}
	public function onMouseUp() {
		this.master.getBehaviour(getId()).onMouseUp(this);
	}
}