package com.smp.data{

	/* 
	_swfConnector = new SwfConnector();
	//usar _ como início dos nomes dos Canais!!
	_swfConnector.connect("_canalEu");
	_swfConnector.send("_canalOutro", "MetodoA");
	
	*/
	
	import flash.events.EventDispatcher;
	import flash.net.LocalConnection;
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.ErrorEvent;
	import flash.errors.IllegalOperationError;
	
	import com.smp.common.events.CustomEvent;
	
	

	public class SwfConnector extends EventDispatcher {

		
		public static const CONNECTION_ERROR:String = "CONNECTION_ERROR";
		public static const SEND_ERROR:String = "SEND_ERROR";
		
		protected var _localConn:LocalConnection = new LocalConnection();
		
		protected var _registeredListeners:Array = new Array();
		protected var _registeredEvents:Array = new Array();

		private var _verbose:Boolean;


		public function SwfConnector(verbose:Boolean = false) 
		{
			_verbose = verbose;
			_localConn.client = this;
			_localConn.addEventListener(StatusEvent.STATUS, onSendStatus, false,0,true);
			_localConn.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError, false,0,true);
		}
		
		/**
		 * Prepares this object to receive send() calls from another LocalConnection object
		 * and registers himself with the name  defined by connectionName.
		 * @param	connectionName
		 */
		public function connect(connectionName:String):void {
			try {
				_localConn.connect(connectionName);
			} catch (er:Error) {
				if (_verbose) {
					//throw new Error("SwfConnector -> connect: Connection error. Connection already open. "+er.message);
					dispatchEvent(new Event(CONNECTION_ERROR));
				}
			}
		}
		
		public function registerCallback(eventType:String, fnc:Function):void {
			_registeredListeners.push(fnc);
			_registeredEvents.push(eventType);
		}
		
		public function send(event:CustomEvent, channel:String):void 
		{	
			_localConn.send(channel, "receive", event);
		}
		
		public function receive(event:Object):void 
		{
			for (var i:uint = 0; i < _registeredEvents.length; i++) {
				
				if (event.type == _registeredEvents[i])
				{
					_registeredListeners[i](event.data);
										
					break;
				}
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