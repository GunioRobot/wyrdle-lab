package com.frankjania.wyrdlelab.display
{
	import com.frankjania.wyrdlelab.WordList;
	import com.frankjania.wyrdlelab.collisiondetection.CollisionDetectionSystem;
	import com.frankjania.wyrdlelab.core.Settings;
	import com.frankjania.wyrdlelab.core.Word;
	import com.frankjania.wyrdlelab.util.ColorPalette;
	import com.frankjania.wyrdlelab.util.ColorScaler;
	import com.frankjania.wyrdlelab.util.FontScaler;
	import com.frankjania.wyrdlelab.util.WordStore;
	
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import mx.controls.ProgressBar;
	import mx.core.Application;
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.effects.Effect;
	import mx.effects.Move;
	import mx.effects.Zoom;
	import mx.effects.easing.Bounce;
	import mx.events.EffectEvent;
	import mx.events.FlexEvent;
	
	public class CloudComponent extends UIComponent{
        private var container:UIComponent;

		private var trendSpriteCache:Dictionary = new Dictionary();
				
		private var cloudLayoutTimer:Timer;
		
		private var currentWord:Word;
				
		public static var font:String = "Miso";
				
		public function CloudComponent():void{
			super();
			// Wait for the application to load so we know the width and height
			FlexGlobals.topLevelApplication.addEventListener( FlexEvent.APPLICATION_COMPLETE , creationCompleteHandler )
//			FlexGlobals.topLevelApplication.addEventListener( TrendsLoadedEvent.LOADED , onTrendsLoaded );

			FontScaler.setScale(20, 50, 1, 30);
//			FontScaler.setScale(20, 40, 72, 312);
			ColorPalette.add(0x003366, 0x660033, 0x336600, 0x663300);
			ColorScaler.setScale(0x99, 0x00, 8, 24);
		}
		
		public function creationCompleteHandler(event:FlexEvent):void{
  			graphics.drawRect(0,0,width,height);
//           	trendsToDate = new TwitterTrendsToDate("http://labs.digitalanalog.net/twitteryear/ytd-short.csv");
			var words:Array = 
				['alpha', 'bravo', 'charlie', 'delta', 'echo', 'foxtrot', 'golf', 'hotel', 'india', 'julia', 'kilo', 'lima', 'mike', 'november',
				 'oscar', 'papa', 'quebec', 'romeo', 'sierra', 'tango', 'uniform', 'victor', 'whiskey', 'xray', 'yankee', 'zulu']
			
			for each (var w:String in words){
				var r:int = randomRange(1,30);
				for (var i:int = 0; i < r; i++){
					WordStore.addWord(w);					
				}
			}
			
			
			onTrendsLoaded();
			
        }
        
		public function onTrendsLoaded():void{
			cloudLayoutTimer = new Timer(Settings.layout_timer_tick);
			cloudLayoutTimer.addEventListener(TimerEvent.TIMER, onCloudLayoutTimer);
			CollisionDetectionSystem.resetStage();
			WordStore.sort();
			cloudLayoutTimer.start();
			//container.graphics.lineStyle(2,0x000000);
			//container.graphics.drawCircle(0,0,20);
  		}
  
        public function onCloudLayoutTimer(event:TimerEvent):void {
        	if ( Settings.placementStrategy.layoutOneByOne() ){

	        	if ( (currentWord = WordStore.getNextWord()) != null){
					if (currentWord.cde == null){
						currentWord.generateCollisionDetectionElement();
					}
					trace("Placing: " + currentWord);
					CollisionDetectionSystem.placeTrend(currentWord);
	        		var cts:WordSprite = new WordSprite(currentWord);
	        		trendSpriteCache[currentWord.getText()] = cts;
					container.addChild(cts);
					//cts.scaleX = FontScaler.scale(currentWord.frequency);
					//cts.scaleY = FontScaler.scale(currentWord.frequency);
					cts.show();
					trace("Placed: " + currentWord);
				} else {
					cloudLayoutTimer.stop();
				}
        	}

        }
        
		private function randomRange(a:Number, b:Number):Number{
			return (Math.floor(Math.random() * (b-a)) + a);
		}
		
		override protected function createChildren():void {
		    super.createChildren();
 			container = new UIComponent()
			container.x = this.width / 2;
			container.y = this.height / 2;
			addChild(container);
       	}
        
	}
}