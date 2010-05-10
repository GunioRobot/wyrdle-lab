package com.frankjania.wyrdlelab.strategy
{
	import com.frankjania.wyrdlelab.core.Word;
	
	import flash.geom.Point;
	
	public class FastInlinePlacementStrategy extends PlacementStrategy
	{
		private var yaxis:Number = -275;
		private var yaxisStep:Number = 10;
		private static var xaxis:Number = 0;
		private static var xaxisStep:Number = 1;
		private static var placementHeight:Number = -275;
		
		override public function resetStrategy():void{
			yaxis = -275;
			placementHeight = -275;
		}		

		override public function placeTrendWithStrategy(trend:Word):void{
			trend.cde.setPoint( new Point(xaxis, placementHeight) );
			placementHeight += trend.cde.getBounds().height;
		}
		
	}
}