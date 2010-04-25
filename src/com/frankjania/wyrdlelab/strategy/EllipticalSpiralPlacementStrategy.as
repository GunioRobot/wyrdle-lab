package com.frankjania.wyrdlelab.strategy
{
	import com.frankjania.wyrdlelab.CandidateWord;
	import com.frankjania.wyrdlelab.PlacementEvent;
	
	import flash.geom.Point;
	
	import mx.core.Application;
	
	
	public class EllipticalSpiralPlacementStrategy extends PlacementStrategy
	{
		private var radiusRatio:Number = 1;
		private var angleStep:Number = 3;
		private var angle:Number = 0;
		
		private var xOffset:int = -100;
		
		public function placeOnEllipticalSpiral(w:CandidateWord, showPath:Boolean=false):void
		{
			//xOffset+=10;
			var radius:Number = 0;
			angle = Math.random() * 360;
			//angle = 0;

			//d("Start Angle: " + Math.round(angle), 1);

			do{
				var p:Point = pointOnEllipse(radius, radiusRatio, angle, xOffset);
				w.x = p.x;
				w.y = p.y;

				if (showPath){
	  				wlc.layoutSprite.graphics.lineStyle(1, w.color, 0.5);
  					wlc.layoutSprite.graphics.drawCircle(w.x,w.y,1);
				}
				
				radius += w.getBounds(w).height / 10;
				angle += angleStep;
				//xOffset += 1;
				//d("Word height("+w.word+"): " + w.getBounds(w).height, 1);

			} while (wlc.quickTestHit(w));
//			} while (wlc.newTestHit(w));
//			} while (wlc.testHit(w) && angle < 1080);
//			} while (angle < 360);

			if (showPath){
				wlc.layoutSprite.graphics.lineStyle(4, w.color, 1.0);
				wlc.layoutSprite.graphics.drawCircle(w.x,w.y,w.getBounds(w).height/3);
			}
		}
		
		public override function _placeWords():void{
			wlc.layoutSprite.graphics.clear();
			
			xOffset = 0;
//			for each (var w:CandidateWord in wl){
			for (var i:int = 0; i < wl.length; i+=1){
				var w:CandidateWord = wl[i];
				if (i < 75){
					placeOnEllipticalSpiral(w, false);
					w.placed = true;
					wlc.appendBackingStore(w);
					w.visible = true;
				} else {
					w.visible = false;
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

		public function pointOnEllipse(radius:Number, ratio:Number, angle:Number, sx:int=0, sy:int=0):Point{
			var q:Number = angle * (Math.PI/180)
			//r = Math.sqrt(r);
			var x:Number = ((radius) * ratio) * Math.cos(q) + sx;
			var y:Number = ((radius) * (1/ratio)) * Math.sin(q) + sy;
			//d("(" + Math.round(radius) + ", " + Math.round(angle) + ")" + "(" + Math.round(x) + ", " + Math.round(y) + ")", 1);
			
			return new Point(x,y);
		}


	}
}