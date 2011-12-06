package com.smp.data
{
	import flash.net.SharedObject;
	
	public class  FlashCookie
	{
	
		public static function readVar(cookieName:String, cookieVar:String, path:String = "/"):* 
		{	
			
			var flashCookie = SharedObject.getLocal(cookieName, path);
			if (flashCookie.data[cookieVar]) {
				return flashCookie.data[cookieVar];
			}
			
			return false;
		}
		
		public static function createVar(cookieName:String, cookieVar:String, cookieVarValue:*= null, path:String = "/"):Boolean 
		{
			var flashCookie = SharedObject.getLocal(cookieName, path);
			if (flashCookie.data[cookieVar]) 
			{
				return false;
			}else if (cookieVarValue)
			{
				flashCookie.data[cookieVar] = cookieVarValue;
				return true;
				
			}else {
				return true;
			}
			
			return false;
		}
		
		public static function updateVar(cookieName:String, cookieVar:String, cookieVarValue:*, path:String = "/"):Boolean 
		{
			var flashCookie:SharedObject = SharedObject.getLocal(cookieName, path);
			if (flashCookie.data[cookieVar]) 
			{
				flashCookie.data[cookieVar] = cookieVarValue;
				try{
					flashCookie.flush();
					return true;
				}catch (err:Error) {
					//ignore
					//look for Cookbook pg 413 to implement handlers
					return false;
				}
			}
			
			return false;
		}
		
		public static function deleteVar(cookieName:String, cookieVar:String, path:String = "/"):Boolean 
		{
			var flashCookie:SharedObject = SharedObject.getLocal(cookieName, path);
			
			if (flashCookie.data[cookieVar]) 
			{
				delete flashCookie.data[cookieVar];
				return true;
			}
			
			return false;
		}
		
		public static function deleteCookie(cookieName:String, path:String = "/"):void
		{
			var flashCookie:SharedObject = SharedObject.getLocal(cookieName, path);
			flashCookie.clear();
		}
		
	}
	
}