package com.frankjania.wyrdlelab.collisiondetection
{
	import com.frankjania.wyrdlelab.core.Settings;
	import com.frankjania.wyrdlelab.core.Word;
	import com.frankjania.wyrdlelab.display.CloudComponent;
	import com.frankjania.wyrdlelab.strategy.PlacementStrategy;
	import com.frankjania.wyrdlelab.util.FontScaler;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	public class CollisionDetectionSystem
	{
		private static var elements:Dictionary = new Dictionary();
		private static var stage:Dictionary = new Dictionary();
				
		private static var strategy:PlacementStrategy = Settings.placementStrategy;

		public static function getElement(hash:String):CollisionDetectionElement{
			return elements[hash];
		}
		
		public static function addElementToSystem(element:CollisionDetectionElement):void{
			elements[element.getHash()] = element;
		}
		
		public static function addElementToStage(element:CollisionDetectionElement):void{
			stage[element.getHash()] = element;
		}
		
		public static function isPlaced(element:CollisionDetectionElement):Boolean{
			return stage[element.getHash()] != null;
		}
		
		public static function placeTrend(trend:Word):void{
			strategy.placeTrend(trend);
		}
		
		public static function testCollision(element:CollisionDetectionElement):Boolean{
			var r:Rectangle = element.getBounds();
			var rt:Rectangle;
			for (var hash:String in stage){
				rt = stage[hash].getBounds();
				if (rt.intersects(r)){
					return true;
				}
			}
			return false;
		}

		public static function resetStage():void{
			for each (var ele:CollisionDetectionElement in stage){
				ele.resetPoint();
			}
			stage = new Dictionary();
			
			strategy.resetStrategy();
		}
		
	}
}