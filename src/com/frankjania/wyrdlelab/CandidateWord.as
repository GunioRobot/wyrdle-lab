package com.frankjania.wyrdlelab
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import mx.core.UIComponent;

	public class CandidateWord extends UIComponent
	{
		public var candidateWordTF:TextField;
		private var wlc:WordLayoutCanvas;

		private var fmt:TextFormat;
		private var isActive:Boolean;
		public var color:uint = WordLayoutCanvas.BASE_COLOR;
		public var finalColor:uint;
		
		public var border:Rectangle;
		public var word:String;
		public var clickedAt:Point;
		public var count:Number;

		public var fixed:Boolean = false;
		public var placed:Boolean = false;
		public var relayout:Boolean = true;
		
		public function CandidateWord(word:String, count:Number, fontSize:Number, wlc:WordLayoutCanvas)
		{
			this.wlc = wlc;
			this.word = word;
			this.count = count;
  			
			fmt = new TextFormat();
  			fmt.font = "Teen";
			fmt.color = color;
			fmt.size = fontSize;
			
			doubleClickEnabled = true;
			
            addEventListener( MouseEvent.MOUSE_DOWN, onCandidateMouseDown );
			addEventListener( MouseEvent.MOUSE_UP, onCandidateMouseUp );
            addEventListener( MouseEvent.DOUBLE_CLICK, onCandidateDoubleClick );
//            addEventListener( MouseEvent.ROLL_OVER, onRollover);
//            addEventListener( MouseEvent.ROLL_OUT, onRollout);

			candidateWordTF = new TextField();
			candidateWordTF.text = word;
			candidateWordTF.autoSize = TextFieldAutoSize.LEFT;
			candidateWordTF.setTextFormat(fmt);
			candidateWordTF.embedFonts = true;
			candidateWordTF.selectable = false;
			candidateWordTF.mouseEnabled = false;

  			addChild(candidateWordTF);
  			candidateWordTF.x += -1 * candidateWordTF.width/2;
  			candidateWordTF.y += -1 * candidateWordTF.height/2;
  			
  			border = candidateWordTF.getBounds(this);
        	
		}
		
		public function setTextColor(color:uint):void{
			this.color = color;
			fmt.color = color;
			candidateWordTF.setTextFormat(fmt);
		}

        private function onCandidateDoubleClick( e:MouseEvent ):void
        {
        	rotation += 90;
        	wlc.recreateBackingStore();
        }
        
        private function onCandidateMouseDown( event:MouseEvent ):void
        {
        	wlc.enableMouseForWord(this);
			clickedAt = new Point(event.localX, event.localY);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, wlc.onCandidateMouseMove );
            isActive = true;

			wlc.candidateWord = this;
            wlc.recreateBackingStore(this);
        }

        private function onCandidateMouseUp( event:MouseEvent ):void
        {
			clickedAt = null;
            isActive = false;
            fixed = true;

            stage.removeEventListener( MouseEvent.MOUSE_MOVE, wlc.onCandidateMouseMove );
			wlc.candidateWord = null;

            wlc.relayoutOverlappedWords(this);

            wlc.recreateBackingStore();
        	wlc.enableMouseForWord(null);
        }

		override public function toString():String{
			return word;
		}
	}
}