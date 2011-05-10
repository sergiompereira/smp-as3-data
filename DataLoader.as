package com.smp.data {
	
	import flash.events.*;
	import flash.net.*;

	public class DataLoader extends EventDispatcher {


		//protected
		protected var _loader:URLLoader = new URLLoader();
		protected var _request:URLRequest;
		protected var _params:URLVariables;
		protected var _loaderData:*;
		protected var _verbose:Boolean = false;
		
		//private
		private var _loadProgress:String = "";
		private var _bytesLoaded:Number = 0;
		private var _bytesTotal:Number = 0;
		private var _loadPercent:int;


		public function DataLoader() {
			//no default constructor
		}
		
		public function load(path:String, verbose:Boolean = false, params:Object=null, format:String = "variables", nocache:Boolean = true):void {
			
			_verbose = verbose;
			_loader.dataFormat = format;
			//permitidos
			//"text", "variables" ou "binary"
			
			loaderHandlers();
			
			if (nocache) {
				var numero:Number = Math.round(999999 * Math.random());
				if (path.indexOf("?") >0) {
					_request = new URLRequest(path + "&nocache="+numero);
				}else{
					_request = new URLRequest(path + "?nocache=" + numero);
				}
			}else{
				_request = new URLRequest(path);
			}
			
			if (params) {
				_params = new URLVariables();
				for (var chave in params) {
					//trace(parametros[chave]);
					_params[chave] = params[chave];
				}
				_request.data = _params;
				_request.method = URLRequestMethod.POST;

			}
			try {
				_loader.load(_request);
			} catch (err:Error) {
				trace(err.message);
			}
		}
		
		protected function loaderHandlers():void {
			_loader.addEventListener(Event.OPEN, onOpen, false,0);
			_loader.addEventListener(ProgressEvent.PROGRESS, onProgress, false, 0, true);
			_loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatusEvent, false, 0, true);
			_loader.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, true);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError, false, 0, true);
		}
		
		private function onOpen(evt:Event):void {
			if (_verbose) {
				trace("Loading started");
			}
		}
		private function onProgress(evt:ProgressEvent):void {
			dispatchEvent(evt);

			_loadPercent = Math.round((evt.bytesLoaded/evt.bytesTotal)*100);
			_bytesLoaded = evt.bytesLoaded;
			_bytesTotal = evt.bytesTotal;
			_loadProgress = (loadPercent + " : " + _bytesLoaded + " -> " + _bytesTotal);
			//trace(_loadProgress)
		}
		public function get progressString():String {
			return _loadProgress;
		}
		public function get loadPercent():int {
			return _loadPercent;
		}
		public function get progressBytesArray():Array {
			return [_bytesLoaded,_bytesTotal];
		}
		protected function onComplete(evt:Event):void {
			removeHandlers();
			_loaderData = evt.target.data;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		protected function removeHandlers():void{
			_loader.removeEventListener(Event.OPEN, onOpen);
			_loader.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			_loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatusEvent);
			_loader.removeEventListener(Event.COMPLETE, onComplete);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);

		}
		
		public function get loadedData():* {
			return _loaderData;
		}
		protected function onHTTPStatusEvent(evt:HTTPStatusEvent):void {
			if (_verbose) {
				trace("HTTP status code: "+evt.status);
			}

		}
		private function onSecurityError(evt:SecurityErrorEvent):void {
			if (_verbose) {
				trace("Erro de seguranca: "+evt.text);
			}
		}
		protected function onIOError(evt:IOErrorEvent):void {
			if (_verbose) {
				trace("Erro de loading: "+evt.text);
			}
			dispatchEvent(evt);
		}
	}
}