package com.smp.data{


	import flash.events.*;

	import ascb.util.StringUtilities;


	public class DataValidation {

		public static const specialChars = new Array('.',':',',',';','!','?','&','#','%','*','+','-','_','=','"','\'','»','«','(',')','[',']','\\','/','\n','\t','\r','\f',' ');
		
		public static function isEmail(inputtxt:String):Boolean {
			var _inputtxt = StringUtilities.trim(inputtxt);

			if (inputtxt.indexOf(" ")>0) {
				return false;
			}
			//bust the email apart into what comes before the @ and what comes after 
			var emailArray:Array = inputtxt.split("@");
			//make sure there's exactly one @ symbol
			//also make sure there's at least one character before and after the @
			if (emailArray.length != 2 || emailArray[0].length == 0 || emailArray[1].length == 0) {
				return false;
			}
			//bust apart the stuff after the @ apart on any . characters 
			var postArray:Array = emailArray[1].split(".");
			//make sure there's at least one . after the @
			if (postArray.length<2) {
				return false;
			}
			//bust apart the stuff before the @ apart on any . characters 
			var usernameArray:Array = emailArray[0].split(".");
			//make sure there's at least one character after the last.
			if (usernameArray.length>1) {
				if (usernameArray[usernameArray.length-1]=="") {
					return false;
				}
			}
			//make sure there's at least 1 character in in each segment before, between and after each . 
			for (var i:Number = 0; i<postArray.length; i++) {
				if (postArray[i].length<1) {
					return false;
				}
			}
			var domainArray = [",",":",";","+"];
			for (var k:Number = 0; k<postArray.length; k++) {
				for (var l:Number = 0; l<domainArray.length; l++) {
					if (postArray[k].indexOf(domainArray[l])>0) {
						return false;
					}
				}
			}
			//get what is left after the last .
			var suffix = postArray[postArray.length-1];
			//make sure that the segment at the end is either 2 or 6 characters
			if (suffix.length<2 || suffix.length>6) {
				return false;
			}
			//make sure that the segment at the end doesn't contain invalid characters
			var extArray = ["0","1","2","3","4","5","6","7","8","9","@","-","_","."];
			for (var j:Number = 0; j<extArray.length; j++) {
				if (suffix.indexOf(extArray[j])>0) {
					return false;
				}
			}
			//it passed all tests, it's a valid email 
			return true;

		}
		public static function isEmpty(inputtxt:String):Boolean {
			var _inputtxt = StringUtilities.trim(inputtxt);
			if (_inputtxt == "") {
				return true;
			} else {
				return false;
			}
		}
		//verifica se existem certos termos num input. Fornecer esses termos numa string separados por vírgulas.
		public static function hasWords(inputtxt:String, words:String):Boolean {

			var _inputtxt = StringUtilities.trim(inputtxt).toLowerCase();
			var _words:Array = words.split(",");
			var _wordindex:int;
			var _present:int = -1;
			
			//para cada palavra a restringir
			for (var i:uint = 0; i < _words.length; i++) {
				//reset dos valores para cada nova palavra
				_present = -1;
				_wordindex = _inputtxt.indexOf(_words[i]);
				
				//se a palavra existe (ou melhor, se existe a sequência de caracteres)
				if (_wordindex >= 0) {
					
					//verifica se a palavra coincide com o texto (não existem outros caracteres)
					if (_inputtxt.length == _words[i].length) {
						return true;
					}
					
					//verifica se a sequência está isolada por caracteres especiais (se não faz parte de uma palavra maior)
					//verifica à esquerda se é o início do texto
					if (_wordindex == 0) {
						_present+=1;
					}
					//verifica à direita se é o fim do texto
					if (_wordindex + _words[i].length == _inputtxt.length) {
						
						_present+=1;
					}
					
					for (var j:uint = 0; j < InputValidation.specialChars.length; j++) {
						//verifica à esquerda
						if (_inputtxt.charAt(_wordindex - 1) == InputValidation.specialChars[j]) {
							
							//detectado à esquerda
							_present+=1;
						}
						//verifica à direita
						if (_inputtxt.charAt(_wordindex + _words[i].length) == InputValidation.specialChars[j]) {
							
							//detectado à direita
							_present+=1;
						}
						
						//se foi detectado um caracter especial tanto à esquerda como à direita, 
						//então a sequência de caracteres é uma palavra isoalada
						if (_present == 1) {
							return true;
						}
					}
					
				}
			}
			return false;
		}
		public static function isNumber(original:String):* {
			
			original = StringUtilities.trim(original);
			//[e] num número é interpretado como expoente de 10
			if(original.search("e") >= 0){
				return false;
			}else {
				return Number(original);
			}
			return false;
		}
		
		public static function isNumberRegExp(original:String):Boolean {
			
			original = StringUtilities.trim(original);
			var reg:RegExp = /^[+\-]?\d*$/;
			if (!reg.test(original)) {
				return false;
			}
			
			return true;
		}
	}
}