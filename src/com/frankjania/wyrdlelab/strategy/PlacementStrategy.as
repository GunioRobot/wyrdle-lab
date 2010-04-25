package com.frankjania.wyrdlelab.strategy
{
	import com.frankjania.wyrdlelab.CandidateWord;
	import com.frankjania.wyrdlelab.WordLayoutCanvas;
	
	import mx.collections.ArrayCollection;
	import mx.core.Application;
	
	public class PlacementStrategy
	{
		protected var wlc:WordLayoutCanvas;
		protected var wl:ArrayCollection;

		public function initLayout(wordLayoutCanvas:WordLayoutCanvas):void{
			this.wlc = wordLayoutCanvas;
			this.wl = wordLayoutCanvas.wordList;

			for each (var w:CandidateWord in wl){
				if (!w.fixed){
					w.relayout = true;
					w.placed = false;
	            	w.visible = false;
				}
				w.setTextColor(WordLayoutCanvas.BASE_COLOR);
			}
		}

		public function placeWords(wlc:WordLayoutCanvas):void{
			initLayout(wlc);
			_placeWords();
		}
		
		public function _placeWords():void{
			
		}

		private function d(s:String, append:int=0):void{
			s += "\n";
			if (append>0) Application.application.debug.text += s;
			else Application.application.debug.text = s;
		}
	}
}