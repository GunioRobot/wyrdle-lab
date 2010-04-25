package com.frankjania.wyrdlelab.strategy
{
	import com.frankjania.wyrdlelab.CandidateWord;
	import com.frankjania.wyrdlelab.PlacementEvent;
	
	import flash.geom.Point;
	
	import mx.core.Application;
	
	
	public class RandomPlacementStrategy extends PlacementStrategy
	{
		private var radiusXEnd:Number = 300;
		private var radiusYEnd:Number = 200;
		
		public function placeAtRandom(w:CandidateWord):void
		{
			var p:Point = randomEllipse(radiusXEnd, radiusYEnd, 0, 0);
			w.x = p.x;
			w.y = p.y;
		}
		
		public override function _placeWords():void{
			
			for each (var w:CandidateWord in wl){
				if (!w.fixed && w.relayout){
					//if (Math.random() > .75 ) w.rotation = 90;
					placeAtRandom(w);
					wlc.appendBackingStore(w);
				} else {
					w.placed = true;
					wlc.appendBackingStore(w);
				}
			}
			
			var p:PlacementEvent = new PlacementEvent(PlacementEvent.COMPLETE);
			wlc.dispatchEvent(p);
		}

		private function d(s:String, append:int=0):void{
			s += "\n";
			if (append>0) Application.application.debug.text += s;
			else Application.application.debug.text = s;
		}

		public static function randomEllipse(rx:int, ry:int, sx:int=0, sy:int=0):Point{
			var q:Number = Math.random() * (Math.PI * 2)
			var r:Number = Math.sqrt(Math.random());
			var x:Number = ((rx-sx) * r) * Math.cos(q) + (sx) * Math.cos(q);
			var y:Number = ((ry-sy) * r) * Math.sin(q) + (sy) * Math.sin(q);
			
			return new Point(x,y);
		}


	}
}