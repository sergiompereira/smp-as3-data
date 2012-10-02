package com.smp.data{

	/* 
	 * @example:
	 * 
	 * Warning: always use this class scoped to its client, i.e., declared as private or public var, not as a method's internal var (scoped to the method).
	 * In other words, the instance of this class must be accessed in compiled time (even if undefined - not instantiated, but not null - not declared).
	 * For this reason, the same applies to its client up to the root class. 
	 * The connection won't work if any of the variables in the encapsulation chain up to the root 
	 * is scoped to a method, instead of being typed private or public var scoped to an object accessed at compile time.
	 * 
	 * In the example bellow, SoundStatus and SoundStatusHandler must both be declared variables of their clients up to the root class.
	 * ======
	 * A sender of subscribe and publish method
	 * A receiver of onStatusChange method
	 * 
	package app {
		import com.smp.data.SwfConnector;
		import com.smp.media.sound.SoundPlayer;
		import com.smp.common.math.NumberUtils;

		import flash.events.EventDispatcher;
			
			
		public class SoundStatus extends EventDispatcher
		{

			private var _myid:Number = NumberUtils.getUnique();
			private var _player:SoundPlayer;
			private var _swfConnector:SwfConnector;
			
			public function SoundStatus(player:SoundPlayer) {
				_player = player;
				_player.addEventListener(SoundEvent.PLAY_CHANGED, onPlayChanged);
			}
			private function onPlayChanged(evt:SoundEvent):void {
				
				if (!_swfConnector) {
					_swfConnector = new SwfConnector(true,this);
					_swfConnector.connect("_canal" + _myid.toString());
					_swfConnector.send("_canalMain", "subscribe", _myid.toString());
					
				}
				_swfConnector.send("_canalMain", "publish",{status:_player.playing, id:_myid});
			}
			
			
			public function onStatusChanged(args:Object) {
				if (args.status == true && args.id != _myid) {
					_player.stop();
				}
				
			}
		}
		
	}
	* A sender of onStatusChange method
	* A receiver of subscribe and publish methods
	package app 
	{
		import com.smp.data.SwfConnector;

		public class SoundStatusHandler 
		{
			
			private var _swfConnector:SwfConnector;
			private var _channels:Array = new Array();
			
			public function SoundStatusHandler() {
						
				_swfConnector = new SwfConnector(true, this);
				_swfConnector.connect("_canalMain");
			}
			
			public function subscribe(id:String) {
				_channels.push('_canal' + id);
			}
			
			public function publish(args:Object) {
				for (var i:int = 0; i < _channels.length; i++) {
					_swfConnector.send(_channels[i], "onStatusChanged", args);
				}
			}
		}
	}
	
	*/
	
	import com.smp.common.utils.StringUtils;
	import flash.net.LocalConnection;
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.ErrorEvent;
	import flash.errors.IllegalOperationError;
	

	public class SwfConnector extends LocalConnection {
		
		private var _fncColl:Array = new Array();

		private var _verbose:Boolean;


		public function SwfConnector(verbose:Boolean = false, clientObj:Object = null) 
		{
			_verbose = verbose;
			
			if (clientObj) this.client = clientObj;
			
			addEventListener(StatusEvent.STATUS, onSendStatus, false,0,true);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError, false,0,true);
		}
		
		override public function connect (connectionName:String) : void {
			try {
				super.connect(connectionName);
			}catch (err:Error) {
				trace(err.message);
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
				}
			} else if (evt.level == "status") {
				
				dispatchEvent(new Event(Event.CONNECT));

			}
		}
		private function onSecurityError(evt:SecurityErrorEvent):void {
			if (_verbose) {
				dispatchEvent(new SecurityErrorEvent(SecurityErrorEvent.SECURITY_ERROR,false, false, "SwfConnector->onSendStatus: Connection error: " + evt.text));
			}
		}
	
	}
}