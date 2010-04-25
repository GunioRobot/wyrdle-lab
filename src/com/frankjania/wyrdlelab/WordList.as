package com.frankjania.wyrdlelab
{
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	public class WordList extends ArrayCollection
	{
		private var map:Dictionary = new Dictionary();
		private var avgFontSize:int = 12;
		private var maxFontSize:int = 127;
		private var maxCount:Number = 0;
		private var minCount:Number = Number.MAX_VALUE;
		
		public function WordList(source:Array = null)
		{
			super(source);
		}
		
		public function addWord(word:String, count:Number=0):void{
			if (map[word] == null){
				map[word] = 0;
			}
			
			if (count > 0) {
				map[word] += count;
			} else {
				map[word]++;
			}

			maxCount = Math.max(maxCount, map[word]);

		}
		
		public function getCount(word:String):Number{
			return map[word];
		}
		
		public function countWords(text:String):void{
			getMinimumCount();

			var fontScalingFactor:Number = 1;
			//if (avgFontSize / averageWordCount() > 1){
			fontScalingFactor = avgFontSize / averageWordCount();
			//}
			
			var i:int = 0;
			// List all of the words and counts
			// in the datagrid-bindable arraycollection
			var nMaxCount:Number = maxCount/minCount;
			for (var k:String in map){
				var fs:Number;

				// Contract the range if font will be larger than maxFontSize
				if ( nMaxCount > maxFontSize ){
					fs = getContractedRangeValue(maxCount, map[k]);
				} else if ( nMaxCount*fontScalingFactor > maxFontSize ) {
					fs = getContractedRangeValue(nMaxCount*fontScalingFactor, map[k]*fontScalingFactor/minCount);
				} else {
					fs = Math.ceil( fontScalingFactor*map[k]/minCount );
				}
				//if (i++ < 30)
					this.addItem({word:k, count:map[k], normalized:map[k]/minCount, fontSize:fs});
			}
		}
		
		private function getContractedRangeValue(max:Number, i:Number):Number{
			return Math.round( 
					((maxFontSize-1)/(max-1))*i + ((max-1)-(maxFontSize-1))/(max-1) );
		}
		
		private function getMinimumCount():void{
			for (var k:String in map){
				minCount = Math.min(minCount,map[k]);
			}
		}
		
		private function averageWordCount():Number{
			var totalCount:int = 0;
			var totalElements:int = 0;
			for (var k:String in map){
				totalCount += map[k]/minCount;
				totalElements++;
			}
			return totalCount/totalElements;
		}
		
		
		private function random(min:int=5, max:int=20):Number{
			return ( Math.round(Math.random()*(max-min) + min) );
		}
		
		private function randomWordCount(i:int):Number{
			var lambda:Number = .4;
			//return Math.round(lambda*Math.pow(Math.E, -1*(lambda)*i));
			//return Math.round(lambda*Math.pow(Math.E, -1*(lambda)*i));
			return Math.round(20*lambda*Math.pow(Math.E, -1*(lambda)*i))+1;
			//return 1;
		}
		
		private function seedRandomWords():void{
			for(var i:int=0; i < 100; i++){
				var l:int = 2 + Math.round(Math.random()*4);
				var s:String = String.fromCharCode(random(65,90));
				for(var j:int=0; j < l; j++){
					s += String.fromCharCode(random(98,122));
				}
				addWord(s, randomWordCount(i));
			}
//			addWord("alpha", 300);
//			addWord("beta", 150);
//			addWord("gamma", 1);

			countWords(null);
		}
		
		public function clearWords():void{
			this.removeAll();
			maxCount = 0;
			minCount = Number.MAX_VALUE;
			map = new Dictionary();
		}
		
		private function loadTwitterTrends():void{
			var ttl:TwitterTrendLoader = new TwitterTrendLoader();
		}
		
		public function loadWords():void{
			clearWords();
			// Add the words
			loadTwitterTrends();
			//seedRandomWords();
			
		}
	}
}