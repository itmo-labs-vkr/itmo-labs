class Strings {
	// надписи на кнопках 
	static var InstrumentsLabel = "Приборы";
	static var TurnOnLabel  = "Включить";
	static var RunLabel     = "Запустить";
	static var MeasureLabel = "Измерить";
	static var YesLabel     = "Да";
	static var NoLabel      = "Нет";
	static var StopLabel	= "Остановить";
	// надписи на кнопках секундомера
	static var StopwatchStart = "Старт";
	static var StopwatchStop  = "Стоп";
	static var StopwatchReset = "Сброс";
	// надписи на барометре
	static var BarometerUnits   = "мм рт.ст.";
	static var BarometerCaption = "Барометр";
	// единицы измерения 
	static var GlassUnits       = "мл";
	static var TankUnits        = "л";
	static var FlowmeterUnits   = "л";
	static var HeaterLosesUnits = "Вт";
	// надписи на сообщениях в начале этапов
	static var RunningCpt     = "Этап: измерение";
	static var RunningMsg 	  = "Снимите показания приборов.";
	static var AssemblingCpt  = "Этап: сборка";
	static var AssemblingMsg  = "Соберите установку из предложенных элементов.";
	static var InstrumentsCpt = "Этап: установка приборов.";
	static var InstrumentsMsg = "Установите необходимые приборы.";
	static var TurningOnCpt   = "Этап: включение установки";
	static var TurningOnMsg   = "Для включения элемента необходимо навести на него указатель и нажать левую кнопку мыши.";
	// надписи на сообщениях об окончании попыток
	static var AssemblingAttemptsOverCpt  = "";
	static var AssemblingAttemptsOverMsg  = "У Вас закончились попытки сборки установки.";
	static var InstrumentsAttemptsOverCpt = "";
 	static var InstrumentsAttemptsOverMsg = "У Вас закончились попытки установки измерительных приборов."
	static var TurningOnAttemptsOverCpt   = "";
	static var TurningOnAttemptsOverMsg   = "У Вас закончились попытки запуска установки.";
	// надписи на сообщениях об ошибках
	static var AssemblingErrorCpt  = "";
	static var InstrumentsErrorCpt = "";
	static var TurningOnErrorCpt   = "";
	static var ServerErrorCpt = "Ошибка!";
	static var ServerErrorMsg = "Ошибка связи с сервером.";
	// окончание 
	static var FinishConfirmCpt = "";
	static var FinishConfirmMsg = "Продолжить выполнение работы?";
	static var EndCpt = "";
	static var EndMsg = "Лабораторная работа завершена.";
	// окно справки
	static var HelpCpt = "Справка";
	// другие сообщения
	static var HeaterBurnedCpt = "";
	static var HeaterBurnedMsg = "Сгорел пароперегреватель!";
	
	static function EquipmentNameById(id:Number):String {
		switch(id) {
			case ID.Boiler: 	return "Парогенератор";
			case ID.Heater: 	return "Пароперегреватель";
			case ID.Chamber: 	return "Измерительная камера";
			case ID.Valve: 		return "Дроссельный вентиль";
			case ID.Condenser: 	return "Водяной конденсатор";
			case ID.Compressor: return "Компрессор";
			case ID.Flowmeter: 	return "Расходомер";
			case ID.Receiver: 	return "Ресивер";
			case ID.Tank: 		return "Измерительный бак";
			case ID.Glass: 		return "Измерительный стакан";
			case ID.Pipe: 		return "Труба";
			case ID.Elbow: 		return "Угол";
			case ID.Nozzle:		return "Сопло";
			default: 
				if(Config.Trace) trace("Bad id in Strings.EquipmentNameById!");
		}
	}
	static function InstrumentNameByClsName(cls:String):String {
		switch(cls) {
			case "Manometer": 			return "Манометр";
			case "TemperatureSensor": 	return "Датчик температуры";
			case "Wattmeter": 			return "Ваттметр";
			default:
				if(Config.Trace) trace("Bad cls in Strings.InstrumentNameByClsName!");
		}
	}
	static function TurningOnMsgById(id:Number):String {
		switch(id) {
			case ID.Boiler: 
			case ID.Heater:
			case ID.Compressor:
				return "Включить " + EquipmentNameById(id).toLowerCase();
			case ID.Condenser:
				return "Включить воду";
			default:
				if(Config.Trace) trace("Bad id in Strings.TurningOnMsgById!");
		}
	}
	
	// сообщения об ошибках
	static var ErrorLoopFound = "В схеме не должно быть замкнутых контуров.";
	static function ErrorWrongConnection(id:Number):String {
		return "Элемент '" + Strings.EquipmentNameById(id) + "' подключен неправильно.";
	}
	static var ErrorNotEnoughElements = "В схеме не хватает элементов.";
	static var ErrorNoTank = "На стенде должен быть измерительный бак.";
	static var ErrorWrongTankConnection = "Измерительный бак должен быть правильно подключен.";
	static var ErrorNoGlass = "На стенде должен быть измерительный стакан.";
	static var ErrorWrongGlassConnection = "Измерительный стакан должен быть правильно установлен.";
	static var ErrorToManyEquipment = "На стенде установлено лишнее оборудование.";
	static var ErrorNotEnoughInstruments = "Вы установили не все измерительные приборы!";
	static var ErrorHeaterBurned = "Сгорел пароперегреватель!";
	static var ErrorWrongTurningOnOrder = "Ошибка при запуске установки!";
	
	static function ErrorNo(id:Number):String {
		switch(id) {
			case ID.Boiler:     return "Нет ни одного парогенератора.";
			case ID.Compressor: return "Нет ни одного компрессора.";
			default: 
				trace("Strings.ErrorNo: not found a string for the id ("+id+")");
		}
	}
	static function ErrorMoreThanOne(id:Number):String {
		switch(id) {
			case ID.Boiler: return "Не должно быть больше одного парогенератора.";
			case ID.Compressor: return "Не должно быть больше одного компрессора.";
			default:
				trace("Strings.ErrorMoreThanOne: not found a string for the id ("+id+")");
		}
	}
}
