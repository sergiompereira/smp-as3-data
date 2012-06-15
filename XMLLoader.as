package com.smp.data{
	import flash.events.*;
	import flash.net.*;
	
	import com.smp.data.DataLoader;
	
	public class XMLLoader extends EventDispatcher {
			
		private var _xml:XML;
		private var _loader:DataLoader;
		private var _callback:Function;
		private var _loadPercent:int;


		/**
		 * 
		 * @param	path
		 * @param	verbose
		 * @param	parametros
		 * @param	nocache
		 * @param	callback : expect a XML object as argument
		 */
		public function load(path:String, verbose:Boolean = false, params:Object=null, nocache:Boolean = true, callback:Function = null){
			
			XML.ignoreWhitespace = true;
		
			_callback = callback;
			
			//o data format em LoadVars.as defaults para Variables
			_loader = new DataLoader();
			_loader.load(path, verbose, params, "text", nocache);
			_loader.addEventListener(Event.COMPLETE, onComplete);
			_loader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, true);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError, false, 0, true);
			
			
		}
		
		private function onComplete(evt:Event):void
		{
			
			_loader.removeEventListener(Event.COMPLETE, onComplete);
			_loader.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			
			try{
				_xml = new XML(_loader.loadedData);
				dispatchEvent(new Event(Event.COMPLETE));
				
				if (_callback != null) {
					_callback(this.loadedXML);
				}
				
			}catch(err:Error){
				trace("Impossível fazer o parse :" + err.message);
				
			}
			
		}
		
		private function onProgress(evt:Event):void{
			
			dispatchEvent(evt);
			_loadPercent = _loader.loadPercent;
		}
		
		public function get loadPercent():int{
			return _loadPercent;
		}
		
		public function get loadedXML():XML{
			return _xml;
		}
		
		private function onSecurityError(evt:SecurityErrorEvent):void {
			trace("Erro de seguranca: "+evt.text);
			dispatchEvent(evt);
		}
		protected function onIOError(evt:IOErrorEvent):void {
			trace("Erro de loading: "+evt.text);
			dispatchEvent(evt);
		}
		
		
	}
}