package com.smp.data
{
	
	import flash.events.Event;
	
	import com.smp.data.ExtendedLoader;
	
	
	public class  StaticLoader
	{
		public static function xml(path:String, callback:Function, params:Object = null, method:String = "POST", verbose:Boolean = false):void
		{
			if (callback == null) {
				throw new ArgumentError("StaticLoader->xml: callback required.");
			}
			var loader:ExtendedLoader = new ExtendedLoader();
			loader.load(path, verbose, params, method, ExtendedLoader.XMLRESPONSE);
			loader.addEventListener(Event.COMPLETE, onDataReady);
			
			function onDataReady(evt:Event):void {
				callback(loader.XMLTree);
			}
		}
		
		public static function json(path:String, callback:Function, params:Object = null, method:String = "POST", verbose:Boolean = false):void
		{
			if (callback == null) {
				throw new ArgumentError("StaticLoader->json: callback required.");
			}
			var loader:ExtendedLoader = new ExtendedLoader();
			loader.load(path, verbose, params, method, ExtendedLoader.JSONRESPONSE);
			loader.addEventListener(Event.COMPLETE, onDataReady);
			
			function onDataReady(evt:Event):void {
				callback(loader.JsonData);
			}
		}
		
		public static function atom(path:String, callback:Function, params:Object = null, method:String = "POST", verbose:Boolean = false):void
		{
			if (callback == null) {
				throw new ArgumentError("StaticLoader->atom: callback required.");
			}
			var loader:ExtendedLoader = new ExtendedLoader();
			loader.load(path, verbose, params, method, ExtendedLoader.ATOMRESPONSE);
			loader.addEventListener(Event.COMPLETE, onDataReady);
			
			function onDataReady(evt:Event):void {
				callback(loader.AtomData);
			}
		}
	}
	
}