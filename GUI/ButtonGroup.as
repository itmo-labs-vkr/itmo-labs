class GUI.ButtonGroup 
{
	private var buttons:Array;
	
	public function ButtonGroup()
	{
		this.buttons = new Array();
	}
	
	public function addFromArray(buttons:Array)
	{
		for(var i in buttons)
			this.buttons.push(buttons[i]);
	}
	
	public function unselect()
	{
		for(var i in this.buttons)
			this.buttons[i].selected = false;
	}
	
	public function hide()
	{
		for(var i in this.buttons)
			this.buttons[i].visible = false;
	}
	
	public function show()
	{
		for(var i in this.buttons)
			this.buttons[i].visible = true;
	}
}