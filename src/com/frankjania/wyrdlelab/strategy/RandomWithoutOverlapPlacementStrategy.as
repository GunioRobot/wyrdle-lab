package com.frankjania.wyrdlelab.strategy
{
	import com.frankjania.wyrdlelab.CandidateWord;
	import com.frankjania.wyrdlelab.PlacementEvent;
	import com.frankjania.wyrdlelab.WordLayoutCanvas;
	
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.core.Application;
	
	
	public class RandomWithoutOverlapPlacementStrategy extends PlacementStrategy
	{
		[Bindable]
		public static var maxUncle:int = 100;
		private var uncle:int = maxUncle;
		
		private var lowestUncle:int = maxUncle;
		
		private var wordCounter:int = 0;
		
		private var ellipseScaler:Number = 0;
		private var ellipseSteps:Number = 10;
		
		private var radiusXEnd:Number = 300;
		private var radiusYEnd:Number = 200;
		
		private static const UNCLE_COLOR:uint = 0x3399CC;

		public var totalPlacementAttempts:int = 0;
		
		public function placeAtRandomWithoutOverlap(w:CandidateWord):void
		{
			totalPlacementAttempts++;
			//var p:Point = randomEllipse(radiusXEnd, radiusYEnd, wordCounter, wordCounter);
			var p:Point = randomEllipse(radiusXEnd, radiusYEnd, 0, 0);
			//var p:Point = randomEllipse(wlc.layoutSprite.getBounds(wlc).width/2, wlc.layoutSprite.getBounds(wlc).height/2, 0, 0);
			//var p:Point = randomEllipse(wlc.layoutSprite.getBounds(wlc).width*3/4, wlc.layoutSprite.getBounds(wlc).height*3/4, 0, 0);
//			var wdt:int = (wlc.layoutSprite.getBounds(wlc).width/2) > 100 ? (wlc.layoutSprite.getBounds(wlc).width/2) : 100;
//			var hgt:int = (wlc.layoutSprite.getBounds(wlc).height/2) > 75 ? (wlc.layoutSprite.getBounds(wlc).height/2) : 75;
//			var p:Point = randomEllipse(
//				wdt,hgt,
//				0, 0);
			w.x = p.x;
			w.y = p.y;
			if ( wlc.testHit(w) ){
				w.setTextColor(WordLayoutCanvas.COLLISION_COLOR);
				uncle--;
				checkForNext(w);
			} else {
				w.setTextColor(WordLayoutCanvas.BASE_COLOR);
				lowestUncle = Math.min(lowestUncle, uncle);
				uncle = maxUncle;
				//uncle = wordCounter;
				w.placed = true;
			}
		}
		
//		private function traverseBox(w:CandidateWord):void{
//			for (var i:int = -wlc.width/2; i < wlc.width/2; i++){
//				for (var j:int = -wlc.width/2; j < wlc.width/2; j++){
//					w.x = i;
//					w.y = j;
//					wlc.testHit(w);
//				}
//			}
//		}

		private function checkForNext(w:CandidateWord):void
		{
			if (uncle <= 0) {
				w.setTextColor(UNCLE_COLOR);
				uncle = maxUncle;
				
//				var p:Point = 
//					randomEllipse(
//						wlc.layoutSprite.getBounds(wlc).width/2 + 3*w.width, 
//						wlc.layoutSprite.getBounds(wlc).height/2 + 3*w.height, 
//						wlc.layoutSprite.getBounds(wlc).width/2,
//						wlc.layoutSprite.getBounds(wlc).height/2);
//				if ( wlc.testHit(w) ) w.setTextColor(WordLayoutCanvas.COLLISION_COLOR);

				var p:Point = randomEllipse(wlc.layoutSprite.getBounds(wlc).width/2, wlc.layoutSprite.getBounds(wlc).height/2, 0, 0);
				w.x = p.x;
				w.y = p.y;

				while (!wlc.getBounds(wlc).containsRect(w.getBounds(wlc))) {
					p = randomEllipse(wlc.layoutSprite.getBounds(wlc).width/2, wlc.layoutSprite.getBounds(wlc).height/2, 0, 0);
					w.x = p.x;
					w.y = p.y;
				}
		

				w.placed = true;
			} else {
				placeAtRandomWithoutOverlap(w);
			}
		}
		

		public override function _placeWords():void{
			for each (var w:CandidateWord in wl){
				wordCounter++;
//				if ( (wl[0] == w) && w.relayout){
//					w.x = 0;
//					w.y = 0;
//					//traverseBox(w);
//					w.placed = true;
//					wlc.appendBackingStore(w);
//				} else 
				if (!w.fixed && w.relayout){
					//if (Math.random() > .75 ) w.rotation = 90;
					placeAtRandomWithoutOverlap(w);
					wlc.appendBackingStore(w);
				} else {
					w.placed = true;
					wlc.appendBackingStore(w);
				}
				//d(w + ": " + wlc.layoutSprite.getBounds(wlc), 1);
			}
			
			var p:PlacementEvent = new PlacementEvent(PlacementEvent.COMPLETE);
			wlc.dispatchEvent(p);
		}

		private function d(s:String, append:int=0):void{
			s += "\n";
			if (append>0) Application.application.debug.text += s;
			else Application.application.debug.text = s;
		}


//		private function random(min:int=-400, max:int=400):Number{
//			return ( Math.round(Math.random()*(max-min) + min) );
//		}

//		private static function randomEllipse(rx:int, ry:int):Point{
//			var ox:Number;
//			var oy:Number;
//			do {
//				ox = (Math.random()*2 - 1)*rx;
//				oy = (Math.random()*2 - 1)*ry;
//			} while (ox*ox/(rx*rx) + oy*oy/(ry*ry) > 1)
//			
//			return new Point(ox,oy);
//		}

		public static function randomEllipse(rx:int, ry:int, sx:int=0, sy:int=0):Point{
			var q:Number = Math.random() * (Math.PI * 2)
			var r:Number = Math.sqrt(Math.random());
			var x:Number = ((rx-sx) * r) * Math.cos(q) + (sx) * Math.cos(q);
			var y:Number = ((ry-sy) * r) * Math.sin(q) + (sy) * Math.sin(q);
			
			return new Point(x,y);
		}


	}
}