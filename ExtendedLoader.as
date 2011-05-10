package com.smp.data{

	import flash.errors.IOError;
	import flash.events.*;
	import flash.net.*;
	

	import com.adobe.serialization.json.JSON;
	import com.adobe.utils.XMLUtil;
	import com.adobe.xml.syndication.atom.*;

	import com.smp.data.DataLoader;
	

	public class ExtendedLoader extends DataLoader {

		//public
		public static const XMLRESPONSE:uint = 0;
		public static const JSONRESPONSE:uint = 1;
		public static const ATOMRESPONSE:uint = 2;

		
		//protected
		protected var _responseType:uint;
		protected var _xml:XML;
		protected var _atomData:Atom10;
		
		
		public function ExtendedLoader() {
			//no default constructor
		}
		
		/**
		 * Superclass method 'load' is blocked. Use 'loadFormat' instead.
		 */
		override public function load(path:String, verbose:Boolean = false, parametros:Object = null, format:String = "variables", nocache:Boolean = true):void {
			throw new Error("Superclass method 'load' is blocked. Use 'loadFormat' instead.");
		}
		
		public function loadFormat(path:String, verbose:Boolean = false, parametros:Object=null, method:String = "POST", responseType:uint = XMLRESPONSE):void {
			
			_xml = null;
			_loaderData = null;
			
			_verbose = verbose;
			_loader.dataFormat = URLLoaderDataFormat.TEXT;
			_responseType = responseType;

			loaderHandlers();
			
			_request = new URLRequest(path);

			var application:URLRequestHeader;
			switch(_responseType) {
				case XMLRESPONSE:
					application = new URLRequestHeader("Accept", "application/xml");
				break;
				case ATOMRESPONSE:
					application = new URLRequestHeader("Accept", "application/atom+xml");
				break;
				case JSONRESPONSE:
					application = new URLRequestHeader("Accept", "application/json");
				break;
			}
			var contenttype:URLRequestHeader = new URLRequestHeader("Content-Type", "application/x-www-form-urlencoded");
			//var nocache:URLRequestHeader = new URLRequestHeader("pragma", "no-cache");

			if (parametros) {
				_parametros = new URLVariables();
				for (var chave in parametros) {
					//trace(parametros[chave]);
					_parametros[chave] = parametros[chave];
				}
				_request.data = _parametros;
					
			}
			
			switch(method) {
				case "GET":
					_request.method = URLRequestMethod.GET;
					break;
				case "POST":
					_request.method = URLRequestMethod.POST;
					break;
				
			}
				
			_request.requestHeaders.push(application);
			_request.requestHeaders.push(contenttype);
			//_request.requestHeaders.push(nocache);

			try {
				_loader.load(_request);
			} catch (err:Error) {
				if(_verbose){
					trace(err.message);
				}
			}
		}
		
		override protected function onComplete(evt:Event):void {
			removeHandlers();

			try {
				if (_responseType == XMLRESPONSE) {
					_xml = new XML(evt.target.data);
					//trace(_xml)
					
					
				}else if (_responseType == JSONRESPONSE) {
					//trace(evt.target.data)
					_loaderData = JSON.decode(evt.target.data);
					
					for (var key:String in _loaderData) {
						//trace(_loaderData[key].variavel);
					}
					
				}else if(_responseType == ATOMRESPONSE){
					_xml = new XML(evt.target.data);
					_atomData = parseAtom(_xml);
				}
				
				
			} catch (error:Error) {
				//trace(error.toString());
			}
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function get XMLTree():XML{
			if(_xml != null){
				return _xml;
			}
			return null;
		}
		
		
		public function get JsonData():* {
			if(_loaderData != null){
				return _loaderData;
			}
			return null;
		}
		
		public function get AtomData():Atom10 {
			if (_atomData != null) {
				return _atomData;
			}
			return null;
		}
		
		private function parseAtom(data:XML):Atom10 {
			
			//XMLSyndicationLibrary does not validate that the data contains valid
			//XML, so you need to validate that the data is valid XML.
			//We use the XMLUtil.isValidXML API from the corelib library.
			if(!XMLUtil.isValidXML(data.toString()))
			{
				throw new IOError("XML not valid");
				return null;
			}	

			//create RSS20 instance
			var atom:Atom10 = new Atom10();

			//parse the raw rss data
			atom.parse(data.toString());
			
			return atom;

		}
		
		override public function get loadedData():* {
			if(_xml != null){
				return this.XMLTree;
			}else if (_loaderData != null) {
				return this.JsonData;
			}else if (_atomData != null) {
				return this.AtomData;
			}
			return null;
		}
		
		
		/*override protected function  onHTTPStatusEvent(evt:HTTPStatusEvent):void {
			if (_verbose) {
				trace("HTTP status code: "+evt.status);
			}
			if(evt.status == 201){
				_loader.close();
				//onComplete(new Event(Event.COMPLETE));
				trace("sucesso")
			}
		}*/
	}
}