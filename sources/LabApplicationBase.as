//import Behaviours.*;
import GUI.LabBase; 
class LabApplicationBase {
	static private var Start       = 0;
	static private var Dragging    = 1;
	static private var Piping      = 2;
	static private var Elbows      = 3;
	static private var Eraser      = 4;
	static private var Instruments = 5;
	static private var TurningOn   = 6;
	static private var Running     = 7;
	//static private var Waiting 	   = 10;	
	
	private var cstate:Number;
	private var waiting:Boolean;
	private var measuring_was:Boolean;
	
	private var lab:LabBase;
	private var errorMsg:String;
	private var rpc;
	private var supervisor;
	
	public function LabApplicationBase(lab:LabBase) {
		this.cstate = Start;
		this.lab 	= lab;
		this.lab.bindMaster(this);
		this.lab.bindApplication(this);
		this.errorMsg = null;
		this.waiting = true;
		this.measuring_was = false;
		if(Config.Standalone) start();
	}
	
	public function bindRPC(rpc) {
		this.rpc = rpc;
	}
	public function setSupervisor(supervisor) {
		this.supervisor = supervisor;
	}
	
	public function getHelpTopic() {
		switch(this.cstate) {
			case Dragging:
			case Piping:
			case Elbows:
			case Eraser:
				return "assembling";
			case Instruments:
				return "instruments";
			case TurningOn:
				return "starting";
			case Running:
				return "measuring";
			default:
				return "";
		}
	}

// Выдача поведения 
	public function getBehaviour(id:Number) {
		if(!this.waiting) {
		switch(this.cstate) {
			case Start:
				break;
			case Dragging:
				if(id == ID.Condenser)
					return new Behaviours.CondenserDragging();
				if(ID.isEquipmentId(id))
					return new Behaviours.EquipmentDragging();
				break;
			case Piping:
				if(ID.isLabsId(id)) 
					return new Behaviours.LabsPiping();
				break;
			case Elbows:
				if(id == ID.Elbow)
					return new Behaviours.ElbowElbows();
				if(ID.isLabsId(id))
					return new Behaviours.LabsElbows();
				break;
			case Eraser:
				if(ID.isEquipmentId(id))
					return new Behaviours.EquipmentEraser();
				break;
			case Instruments:
				if(ID.isEquipmentId(id))
					return new Behaviours.EquipmentInstruments();
				break;
			case TurningOn:
				switch(id) {
					case ID.Boiler:
					case ID.Condenser:
					case ID.Heater:
					case ID.Compressor:
						return new Behaviours.EquipmentTurningOn();
				}
				break;
			case Running:
				if(id == ID.Valve)
					return new Behaviours.ValveRunning();
				break;
		} }
		return new Behaviours.Default();
	}

// Ф-ии изменения состояния и сопутствующих этому изменению состояния действий 
	private function start() {
		if(Config.Standalone) {
			goToAssembling();
		} else {
			askForAssemblingAttempt();
		}
	}
	private function goToAssembling() {
		this.lab.showAssemblingMsg();
		this.lab.showAssembling();
		//goToDragging();
	}
	private function goToDragging():Void {
		this.lab.showDragging();
		goToState(Dragging);
	}
	private function goToPiping():Void {
		this.lab.showPiping();
		goToState(Piping);
	}
	private function goToElbows():Void {
		this.lab.showElbows();
		goToState(Elbows);
	}
	private function goToEraser():Void {
		this.lab.showEraser();
		goToState(Eraser);
	}
	private function goToInstruments():Void {
		this.lab.showInstrumentsMsg();
		this.lab.showInstruments();		
		goToState(Instruments);
	}
	private function goToTurningOn():Void {
		this.lab.showTurningOnMsg();
		this.lab.showTurningOn();
		this.lab.getScheme().dropTurningOnLog();
		goToState(TurningOn);
	}
	private function goToRunning():Void {
		this.lab.showRunning();
		if(!Config.Standalone) sendMeasuringResult(this.lab.getScheme().gatherMeasurements());
		goToState(Running);
	}
	private function goToState(state:Number):Void {
		this.cstate = state;
		this.waiting = false;
	}
	
// Доп. ф-ии изменения состояния
	private function checkAssembling():Void {
		this.errorMsg = null;
		try {
			this.lab.getScheme().checkAndLink();
		}
		catch(e:Error) {
			this.errorMsg = e.message;
		}
		if(this.errorMsg) {
			this.lab.showAssemblingError(this.errorMsg);
		} else {
			if(Config.Standalone) {
				goToInstruments();
			} else {
				sendAssemblingResult();
			}
		}
	}
	
	private function checkInstruments():Void {
		this.errorMsg = null;
		try {
			this.lab.getScheme().checkInstruments();
		}
		catch(e:Error) {
			this.errorMsg = e.message;
		}
		if(this.errorMsg)
			this.lab.showInstrumentsError(this.errorMsg);
		else
			if(Config.Standalone)
				goToTurningOn();
			else
				sendInstrumentsResult();
	}
	
	private function checkTurningOn():Void {
		this.errorMsg = null;
		try {
			this.lab.getScheme().checkTurningOn();
		}
		catch(e:Error) {
			this.errorMsg = e.message;
		}
		if(processSpecificTurningOnErrors()) {
		} else {
			if(this.errorMsg) {
				this.lab.showTurningOnError(this.errorMsg);
			} else {		
				if(Config.Standalone) {
					goToRunning();
				} else {
					sendTurningOnResult();
				}
			}
		}
	}
	
	private function processSpecificTurningOnErrors():Boolean {
		return false;
	}
	
	private function doMeasuringOrStop():Void {
		if(!this.measuring_was) {
			this.lab.showMeasuring();
			this.measuring_was = true;
		} else 
			this.lab.showFinishConfirm();
	}

// Внешние сообщения
	public function onDraggingQuery() {
		if(isAssembling() || this.cstate == Start) 
			goToDragging();
		else
			if(Config.Trace) trace("Dragging state is unreachable!");
	}
	public function onPipingQuery() {
		if(isAssembling())
			goToPiping();
		else
			if(Config.Trace) trace("Piping state is unreachable!");
	}
	public function onElbowsQuery() {
		if(isAssembling())
			goToElbows();
		else
			if(Config.Trace) trace("Elbows state is unreachable!");
	}
	public function onEraserQuery() {
		if(isAssembling())
			goToEraser();
		else
			if(Config.Trace) trace("Eraser state is unreachable!"); 
	}
	public function onErrorShown() {
		switch(this.cstate) {
			case Dragging:
			case Piping:
			case Elbows:
			case Eraser:
				if(Config.Standalone)
					goToAssembling();
				else
					sendAssemblingResult();
				break;
			case Instruments:
				if(Config.Standalone)
					goToInstruments();
				else
					sendInstrumentsResult();
				break;
			case TurningOn:
				turningOnErrorShown();
				break;
		}
	}
	private function turningOnErrorShown() {
		this.lab.getScheme().resetButInstruments();
		if(Config.Standalone) {
			goToTurningOn();
		} else {
			sendTurningOnResult();
        }
	}
	public function onNextStage() {
		this.waiting = true;
		switch(this.cstate) {
			case Dragging:
			case Piping:
			case Elbows:
			case Eraser:
				checkAssembling();
				break;
			case Instruments:
				checkInstruments();
				break;
			case TurningOn:
				checkTurningOn();
				break;
			case Running:
				doMeasuringOrStop();
				break;
		}
	}

	public function onRemoteCallComplete(name, success, result) {
		if(success && result.error == "false") {
			switch(name) {
				case "assembling_attempt":
					if(result.attempt_got == "true") {
						goToAssembling();
 					} else {
						this.lab.showAssemblingAttemptsOver();
					}
				break;
				
				case "assembling_result":
					if(!this.errorMsg) {
						askForInstrumentsAttempt();
					} else {
						askForAssemblingAttempt();
					}
				break;
				
				case "instruments_attempt":
					if(result.attempt_got == "true")
						goToInstruments();
					else 
						this.lab.showInstrumentsAttemptsOver();
				break;
				
				case "instruments_result":
					if(!this.errorMsg)
						askForStartingAttempt();
					else
						askForInstrumentsAttempt();
				break;
				
				case "starting_attempt":
					if(result.attempt_got == "true") {
						goToTurningOn();
					} else {
						this.lab.showTurningOnAttemptsOver();
                                        }
				break;
				
				case "starting_result":
					if(!this.errorMsg) {
						goToRunning();
					} else {
						askForStartingAttempt();
					}
				break;
			}
		} else {
			this.lab.showServerError();
		}
	}
	
	public function onEnd() {
		this.supervisor.goToLogin();
	}
	
	public function onParametersChanged() {
		sendMeasuringResult(this.lab.getScheme().gatherMeasurements());
	}
	
// Предикаты состояния
	private function isAssembling():Boolean {
		switch(this.cstate) {
			case Dragging:
			case Piping:
			case Elbows:
			case Eraser:
				return true;
		}
		return false;
	}

// Работа с сервером
	//функции отправки результатов этапов
	private function sendAssemblingResult() {
		sendResult("assembling_result");
	}
	
	private function sendInstrumentsResult() {
		sendResult("instruments_result");
	}
	
	private function sendTurningOnResult() {
		sendResult("starting_result");
	}
	
	private function sendMeasuringResult(measurements:Object) {
		//goToWaiting();
		this.rpc.callProcedure("measuring_result", measurements, this);
	}
	
	//оболочки для вызовов удаленных процедур для запросов попыток
	private function askForAssemblingAttempt() {
		askForAttempt("assembling_attempt");
	}
	
	private function askForInstrumentsAttempt() {
		askForAttempt("instruments_attempt");
	}
	
	private function askForStartingAttempt() {
		askForAttempt("starting_attempt");
	}
	
	// обобщенные ф-ии
	private function sendResult(pn:String):Void {
		//goToWaiting();
		this.rpc.callProcedure(pn, {is_right: (this.errorMsg ? "false" : "true"), error_message: this.errorMsg}, this);
	}
	
	private function askForAttempt(pn:String):Void {
		//goToWaiting();
		this.rpc.callProcedure(pn, Object(), this);
	}
}