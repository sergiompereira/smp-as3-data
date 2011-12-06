package com.smp.data{

	/* 
	_swfConnector = new SwfConnector();
	_swfConnector.setMetodos(FuncaoLocal);
	//usar _ como início dos nomes dos Canais!!
	_swfConnector.connect("_canalEu");
	_swfConnector.send("_canalOutro", "MetodoA");
	
	*/
	
	import flash.net.LocalConnection;
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.ErrorEvent;
	import flash.errors.IllegalOperationError;
	

	public class SwfConnector extends LocalConnection {

		public static const CONNECTION_ERROR:String = "CONNECTION_ERROR";
		public static const SEND_ERROR:String = "SEND_ERROR";
		
		private var _fnc1:Function;
		private var _fnc2:Function;
		private var _fnc3:Function;
		private var _fnc4:Function;
		private var _fnc5:Function;

		private var _verbose:Boolean;


		public function SwfConnector(verbose:Boolean = false) 
		{
			_verbose = verbose;
			addEventListener(StatusEvent.STATUS, onSendStatus, false,0,true);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError, false,0,true);
		}
		override public function connect(connectionName:String):void {
			try {
				super.connect(connectionName);
			} catch (er:Error) {
				if (_verbose) {
					//throw new Error("SwfConnector -> connect: Connection error. Connection already open. "+er.message);
					dispatchEvent(new Event(CONNECTION_ERROR));

				}
			}
		}
		
		/**
		 * Up to 5 custom methods available!
		 * 
		 * @param	fnc1
		 * @param	fnc2
		 * @param	fnc3
		 * @param	fnc4
		 * @param	fnc5
		 */
		public function setMethods(fnc1:Function, fnc2:Function = null, fnc3:Function = null, fnc4:Function = null, fnc5:Function = null):void {


			_fnc1 = fnc1;
			_fnc2 = fnc2;
			_fnc3 = fnc3;
			_fnc4 = fnc4;
			_fnc5 = fnc5;

		}
		public function MetodoA(arg:Object = null):void {
			
			if (_fnc1 == null) {
				throw new IllegalOperationError("Method not defined. Use setMethods");
			} else {
				
				_fnc1(arg);
			}
		}
		public function MetodoB(arg:Object = null):void {
			if (_fnc2 == null) {
				throw new IllegalOperationError("Method not defined. Use setMethods");
			} else {
				_fnc2(arg);
			}
		}
		public function MetodoC(arg:Object = null):void {
			if (_fnc3 == null) {
				throw new IllegalOperationError("Method not defined. Use setMethods");
			} else {
				_fnc3(arg);
			}
		}
		public function MetodoD(arg:Object = null):void {
			if (_fnc4 == null) {
				throw new IllegalOperationError("Method not defined. Use setMethods");
			} else {
				_fnc4(arg);
			}
		}
		public function MetodoE(arg:Object = null):void {
			if (_fnc5 == null) {
				throw new IllegalOperationError("Method not defined. Use setMethods");
			} else {
				_fnc5(arg);
			}
		}
		
		/**
		 * 
		 * @param	evt
		 * If _verbose, make sure you define a listener for the ErrorEvent
		 * Unlike common events, the error event dispatch an unhandled 2044 error if no listener is defined.
		 */
		private function onSendStatus(evt:StatusEvent):void {
			if (evt.level == "error") {
				if (_verbose) {
					trace("SwfConnector->onSendStatus: Connection error: " + evt.code);
					dispatchEvent(new Event(SEND_ERROR));
				}
			} else if (evt.level == "status") {
				
				dispatchEvent(new Event(Event.CONNECT));

			}
		}
		private function onSecurityError(evt:SecurityErrorEvent):void {
			if (_verbose) {
				trace("SwfConnector->onSecurityError: Security Error "+ evt.text);
				dispatchEvent(new SecurityErrorEvent(SecurityErrorEvent.SECURITY_ERROR,false, false, "SwfConnector->onSendStatus: Connection error: " + evt.text));
			}
		}
	
	}
}