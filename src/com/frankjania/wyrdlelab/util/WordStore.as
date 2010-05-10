package com.frankjania.wyrdlelab.util
{
	import com.frankjania.wyrdlelab.core.Word;
	
	import flash.utils.Dictionary;
	
	public class WordStore
	{
		private static var wordset:Dictionary = new Dictionary();
		public static var wordarray:Array = new Array();
		
		private static var iterationCounter:int = 0;
		
		public static function addWord(w:String):void{
			if (wordset[w] == null){
				var we:Word = new Word(w,1);
				wordarray.push(we);
				wordset[w] = we;
			} else {
				wordset[w].frequency += 1;
			}
		}
		
		public static function getWord(w:String):Word{
			return wordset[w];
		}
		
		public static function contains(w:String):Boolean{
			if (wordset[w] == null) return false;
			return true;
		}
		
		public static function traceTopWords():void{
			wordarray.sort(sortOnOccurance);
			var count:Number = 0;
			for each (var w:Word in wordarray){
				trace("<"+count+++"> " + w.getText() + " ("+w.frequency+") : ");
			}
		}
		
		public static function getNextWord():Word{
			if (iterationCounter < wordarray.length){
				return wordarray[iterationCounter++];
			} else {
				return null;
			}
			
		}
		
		public static function sort(type:String = "Frequency"):void{
			if (type == "Frequency"){
				wordarray.sort(sortOnFrequency);
			} else if (type == "Occurance"){
				wordarray.sort(sortOnOccurance);
			}
		}

		public static function sortOnOccurance(a:Word, b:Word):Number {
	        return a.firstOccurance.time < b.firstOccurance.time ? -1 : 1;
		}

		public static function sortOnFrequency(a:Word, b:Word):Number {
	        return a.frequency < b.frequency ? 1 : -1;
		}

	}
}