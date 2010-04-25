package com.frankjania.wyrdlelab
{
	import flash.events.Event;
	import flash.geom.Point;
	
	import mx.controls.Alert;

	public class PlacementEvent extends Event
	{
		public var point:Point = new Point();
		public var candidateWord:CandidateWord;
		
		public static const PLACE:String = "com.frankjania.wyrdlelab.place";
		public static const TEST_FITNESS:String = "com.frankjania.wyrdlelab.testfitness";
		public static const COMPLETE:String = "com.frankjania.wyrdlelab.complete";
		
		public function PlacementEvent(type:String, candidateWord:CandidateWord=null, point:Point=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.point = point;
			this.candidateWord = candidateWord;
		}
		
//		public function set candidateWord(candidateWord:CandidateWord):void{
//			this.candidateWord = candidateWord;
//		}
		
		override public function clone():Event{
			var p:PlacementEvent = new PlacementEvent(type, candidateWord, point, bubbles, cancelable);
			p.point = point;
			return p;
		}
		
		override public function toString():String{
			return formatToString("PlacementEvent", "type", "bubbles", "cancelable", "point", "candidateWord");
		}
	}
}