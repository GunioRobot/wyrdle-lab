package com.frankjania.wyrdlelab
{
	import com.frankjania.wyrdlelab.strategy.*;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.containers.Canvas;
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.effects.TweenEffect;
	import mx.effects.Zoom;
	import mx.effects.easing.Bounce;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	import mx.managers.DragManager;

	public class WordLayoutCanvas extends Canvas
	{
		public static const COLLISION_COLOR:uint = 0xFF93660;
		public static const BASE_COLOR:uint = 0x000000;
		public static const TEST_COLOR:uint = 0xCC6633;


		private var gridStep:int = 30;
		private var gridColor:uint = 0x9F9FF9;
		private var spriteGridColor:uint = 0xF99FF9;
		private var gridAlpha:Number = 0.2;
		private var gridMinorThickness:uint = 1;
		private var gridMajorThickness:uint = 3;
		
		private var boundingBoxThickness:uint = 3;
		private var boundingBoxColor:uint = 0xF99F9F;
		private var boundingBoxAlpha:Number = 1.0;

		private var wordCanvasBD:BitmapData;
		private var candidateWordBD:BitmapData;
		
		public var candidateWord:CandidateWord;
		
		public var wordList:ArrayCollection = new ArrayCollection();
		
		[Bindable]
		public var animateProgress:Boolean = true;
		
		public var layoutSprite:UIComponent;
		public var containerSprite:UIComponent;
		
		private var placementStrategy:PlacementStrategy;
		
		private var lastGood:Point = new Point();
		
		private var minTestableWordHeight:int = 30;
		private var glowFilter:GlowFilter;
		
		public var startPlacementTime:Date;
		public var startHitTestTime:Date;
		public var hitTestTimeTotal:Number = 0;
		public var hitTestTotal:Number = 0;

		public var startNewHitTestTime:Date;
		
		public var colorPickers:Array = new Array();
		
		public function WordLayoutCanvas()
		{
			super();
			Application.application.addEventListener( FlexEvent.APPLICATION_COMPLETE , creationCompleteHandler )
			addEventListener(PlacementEvent.COMPLETE, placementCompleteEventHandler );
		}
		
		
		private function drawBoundingBox(clearIt:Boolean=false):void {
			with (layoutSprite.graphics){
				if (clearIt) clear();
				lineStyle(boundingBoxThickness, boundingBoxColor, boundingBoxAlpha);
				drawRect(
					layoutSprite.getBounds(layoutSprite).x,
					layoutSprite.getBounds(layoutSprite).y,
					layoutSprite.getBounds(layoutSprite).width,
					layoutSprite.getBounds(layoutSprite).height
				);
				lineStyle();
			}
		}
		
		private function drawGrid():void {
			with(graphics){
				clear();
				//var r:Rectangle = this.getBounds(this);
				lineStyle(gridMinorThickness, gridColor, gridAlpha);

				for (var i:int = width/2; i < width; i +=gridStep){
					if ( i == width/2 ){
						lineStyle(gridMajorThickness, gridColor, gridAlpha);
						moveTo(i, 0)
						lineTo(i, height);
					} else{
						lineStyle(gridMinorThickness, gridColor, gridAlpha);
						moveTo(i, 0)
						lineTo(i, height);
						moveTo(width - i, 0)
						lineTo(width - i, height);
					}
				}
				
				for (var j:int = height/2; j < height; j += gridStep){
					if ( j == height/2 ){
						lineStyle(gridMajorThickness, gridColor, gridAlpha);
						moveTo(0, j)
						lineTo(width, j);
					} else{
						lineStyle(gridMinorThickness, gridColor, gridAlpha);
						moveTo(0, j)
						lineTo(width, j);
						moveTo(0, height - j)
						lineTo(width, height - j);
					}
				}
				lineStyle();
			}
		}
		
		private function drawSpriteGrid():void {
			with(layoutSprite.graphics){
				//clear();
				var r:Rectangle = layoutSprite.getBounds(layoutSprite);
				lineStyle(gridMinorThickness, spriteGridColor, gridAlpha);

				var xzero:Number = r.right - r.width/2;
				var yzero:Number = r.bottom - r.height/2;

				lineStyle(gridMajorThickness, spriteGridColor, 1.0);
				moveTo(xzero, r.y)
				lineTo(xzero, r.bottom);

				moveTo(r.x, yzero)
				lineTo(r.right, yzero);

				drawRect(
					-15,
					-15,
					30,
					30
				);
				lineStyle();
			}
//			with(containerSprite.graphics){
//				lineStyle(gridMajorThickness, TEST_COLOR, 1.0);
//				drawRect(
//					-15,
//					-15,
//					30,
//					30
//				);
//				
//			}
		}
		
		public function toggleWords(b:Boolean):void{
			for each (var w:CandidateWord in wordList){
				w.candidateWordTF.visible = b;
				if (!b){
		  			//w.graphics.lineStyle(2, w.color, 1.0);
	  				//w.graphics.drawCircle(0,0,2);
				} else {
					w.graphics.clear();
				}
			}
		}

		private function placementCompleteEventHandler( e:PlacementEvent ):void {
			//layoutSprite.graphics.clear();
			//drawBoundingBox();
			//drawSpriteGrid();
			var p:Number = 0;
			for each (var w:CandidateWord in wordList){
				if (w.relayout){
					//resetWordEffectParameters(w);
				//	w.visible = true;
					//getWordEffect(w, ++p).play();
					w.relayout = false;
				}
			}
			
//			d("Layout time: " + (new Date().valueOf() - startPlacementTime.valueOf()) + "ms");
//			d("Avg attempts: " + Math.round(placementStrategy.totalPlacementAttempts/wordList.length) 
//				+ " (" + placementStrategy.totalPlacementAttempts +  "/" + wordList.length + ")", 1);
//			d("Avg HT Time: " + (hitTestTimeTotal/hitTestTotal) + " (" + hitTestTimeTotal +  "/" + hitTestTotal + ")", 1);
			
			colorWords();
			
			var r:Rectangle = layoutSprite.getBounds(layoutSprite);
			var xzero:Number = r.right - r.width/2;
			var yzero:Number = r.bottom - r.height/2;
			
			//recenter
			layoutSprite.x = -xzero;
			layoutSprite.y = -yzero;
			
			// scale it
			var bbwsf:Number = width/layoutSprite.getBounds(layoutSprite).width;
			var bbhsf:Number = height/layoutSprite.getBounds(layoutSprite).height;
			var zcf:Number = Math.min(bbwsf, bbhsf);

			containerSprite.scaleX = zcf;
			containerSprite.scaleY = zcf;

//			startNewHitTestTime = new Date();
//			for (var i:int = 0; i<1000; i++){
//				wordList[3].x = Math.random() * 150;
//				wordList[3].y = Math.random() * 150;
//				newTestHit(wordList[3]);
//			}
//			var f:Number = new Date().valueOf() - startNewHitTestTime.valueOf();
			
			//d("1000 New Hit Tests in " + f + "ms @ " + f/1000);
			
//			startNewHitTestTime = new Date();
//			for (var j:int = 0; j<1000; j++){
//				wordList[3].x = Math.random() * 150;
//				wordList[3].y = Math.random() * 150;
//				testHit(wordList[3]);
//			}
//			f = new Date().valueOf() - startNewHitTestTime.valueOf();
			
			//d("1000 Old Hit Tests in " + f + "ms @ " + f/1000, 1);
									
		}
		

		public function colorWords():void{
			var p:Number = 0;
			for each (var w:CandidateWord in wordList){
				w.setTextColor(colorPickers[p++%colorPickers.length].value);
				w.finalColor = w.color;
			}
			
		}

		private function creationCompleteHandler( event:FlexEvent ) : void
		{
			addEventListener(DragEvent.DRAG_ENTER, dragEnterHandler);
			addEventListener(DragEvent.DRAG_DROP, dragDropHandler );
			addEventListener(DragEvent.DRAG_OVER, dragOverHandler );

			createLayoutSprite();
			initBackingStore();
			drawGrid();
			
			colorPickers.push(Application.application.color1);
			colorPickers.push(Application.application.color2);
			colorPickers.push(Application.application.color3);
			colorPickers.push(Application.application.color4);
			
			glowFilter = new GlowFilter(0x0000ff, 1, 3, 3, 255, 2);
			
		}
		
		private function createLayoutSprite():void{
			containerSprite = new UIComponent();
			this.addChild(containerSprite);
			containerSprite.x = width/2;
			containerSprite.y = height/2;
			
			layoutSprite = new UIComponent();
			containerSprite.addChild(layoutSprite);
		}
		
		public function initBackingStore():void
		{
			wordCanvasBD = new BitmapData(width, height, true, 0x00000000);
			candidateWordBD = new BitmapData(width, height, true, 0x00000000);
		}
		
		public function onCandidateMouseMove( event:MouseEvent ):void
        {
			var m:Matrix = new Matrix();
			m.rotate(candidateWord.rotation * Math.PI / 180);

        	var p:Point = m.transformPoint(candidateWord.clickedAt);
			var g:Point = layoutSprite.globalToLocal(new Point(event.stageX-p.x, event.stageY-p.y));

	      	candidateWord.x = g.x;
	       	candidateWord.y = g.y;
        	drawBoundingBox(true);

			//d("> " + event);
			candidateWord.placed = false;
    		if ( newTestHit(candidateWord, true) ){
    			candidateWord.setTextColor(COLLISION_COLOR);
    			d(">>>>>>Hit<<<<<<<");
			} else {
    			candidateWord.setTextColor(candidateWord.finalColor);
    			d("----	No hit-----");
			}
			candidateWord.placed = true;
			event.updateAfterEvent();

        }
        private function dragOverHandler(event:DragEvent):void
        {
           DragManager.showFeedback(DragManager.MOVE);
        }
        
		private function dragEnterHandler(event:DragEvent):void
		{
			DragManager.acceptDragDrop(Canvas(event.currentTarget));
        }

        private function dragDropHandler(event:DragEvent):void {
			var items:Array = event.dragSource.dataForFormat("items") as Array;

            for (var i:Number = 0; i < items.length; i++) { 
            	var c:CandidateWord = new CandidateWord(items[i].word, items[i].count, items[i].fontSize, this);
            	var g:Point = layoutSprite.globalToLocal(new Point(event.stageX, event.stageY));
            	c.x = g.x;
            	c.y = g.y;
            	c.fixed = true;
            	c.placed = true;
                appendBackingStore(c);
                addWord(c);
            	c.visible = true;
            	resetWordEffectParameters(c);
                drawBoundingBox();
				//getWordEffect(c, 1).play();
				
            }

//			with (Application.application.wlcdebug.graphics){
//				beginBitmapFill(wordCanvasBD);
//				drawRect(0,0,800,600);
//				endFill();
//			}

        }
		
		public function addWord(w:CandidateWord):void
		{
			wordList.addItem(w);
			w.visible = false;
			layoutSprite.addChild(w);
		}
		
		private function getWordEffect(c:CandidateWord, positionInList:Number):TweenEffect{
 			var f:Zoom = new Zoom(c);
		    f.zoomWidthFrom=0.01;
		    f.zoomWidthTo=1.0;
		    f.zoomHeightFrom=0.01;
		    f.zoomHeightTo=1.0;
			f.easingFunction = Bounce.easeOut;
			f.startDelay = positionInList*20;
			f.duration = 1000;
			return f;
		}
		
		private function resetWordEffectParameters(c:CandidateWord):void{
			c.scaleX = 0.01;
			c.scaleY = 0.01;
		}
		
		public function loadWordList():void{
			//wordList.removeAll();
			this.removeAllChildren();
			createLayoutSprite();
			Application.application.wordList.loadWords();
			Application.application.wordList.countWords(null);
		}

		public function refresh():void{
			hitTestTotal = 0;
			hitTestTimeTotal = 0;
			
			var wl:WordList = Application.application.wordList;

			var sorter:Sort = new Sort();
			sorter.fields = [new SortField("count",true,true,true), new SortField("word",true)];
			wl.sort = sorter;
			wl.refresh();

			clearBackingStore();
			
            for (var i:Number = 0; i < wl.length; i++) {
            	var c:CandidateWord = new CandidateWord(wl[i].word, wl[i].count, wl[i].fontSize, this);
	           	addWord(c);
	           	if (c.fixed){
	           		appendBackingStore(c);
	           	}
			}
			wl.removeAll();

			colorWords();
			
			placementStrategy = new EllipticalSpiralPlacementStrategy();
			//placementStrategy = new RandomWithoutOverlapPlacementStrategy();
			startPlacementTime = new Date();
			placementStrategy.placeWords(this);
			
//			with (Application.application.wlcdebug.graphics){
//				beginBitmapFill(wordCanvasBD);
//				drawRect(0,0,800,600);
//				endFill();
//			}

		}
	
		private function clearBackingStore():void{
			wordCanvasBD.fillRect(wordCanvasBD.rect, 0)
		}

		public function appendBackingStore(candidate:CandidateWord):void{
			placeWordOnBackingStore(candidate);
		}
		
		public function recreateBackingStore(candidate:CandidateWord=null):void{
			clearBackingStore();

			for each (var c:CandidateWord in wordList){
				if ( (c != candidate) && (c.placed) ){
					placeWordOnBackingStore(c);
				}
			}
		}
		
		private function placeWordOnBackingStore(c:CandidateWord):void{
			var m:Matrix;
			m = rotationMatrix(c);

			if (c.border.height < minTestableWordHeight){
				drawBlockInstead(c, wordCanvasBD, m);
			} else {
//				var g:GlowFilter = new GlowFilter(0x0000ff, 1, 5, 5, 255, 2);
//				c.filters=[g];
				wordCanvasBD.draw(c, m);
//				c.filters=[];
			} 
		}

		public function drawBlockInstead(c:CandidateWord, bd:BitmapData, m:Matrix):void{
			var s:Shape = new Shape();
			//s.graphics.drawRect(-c.border.width/2+1, -c.border.height/2+1 , c.border.width -1, c.border.height -1);
			var r:Rectangle = c.getBounds(c);
			r.inflate(-2,-2);
			c.graphics.beginFill(c.color);
			c.graphics.drawRect(r.x, r.y, r.width, r.height);
			c.graphics.endFill();
			//bd.draw(s, m);
			
			bd.draw(c, m);
			
			c.graphics.clear();
		}
		
		public function rotationMatrix(c:CandidateWord):Matrix{
			var cos:Number = Math.cos(c.rotation * Math.PI / 180);
			var sin:Number = Math.sin(c.rotation * Math.PI / 180);
			return new Matrix(cos, sin, -sin, cos, c.x+width/2, c.y+height/2);
//			return new Matrix(cos, sin, -sin, cos, -c.getBounds(c).width/2, -c.getBounds(c).height/2);
		}
		
		public function relayoutOverlappedWords(c:CandidateWord):void{
//			for each (var w:CandidateWord in wordList){
//				w.setTextColor(BASE_COLOR);
//				if (w.getRect(this).intersects(c.getRect(this))){
//					recreateBackingStore(w);
//					if (testHit(w)){
//						w.relayout = true;
//						w.setTextColor(COLLISION_COLOR);
//					} else {
//					}
//				}
//			}
//			
//			c.relayout = false;
//			placementStrategy.placeWords(this);
//			c.fixed = false;

		}
		
		public function enableMouseForWord(c:CandidateWord):void{
			for each (var w:CandidateWord in wordList){
				if (c == null){
					w.mouseEnabled = true;
				} else {
					w.mouseEnabled = false;
				}
				//d(w + ": " + w.mouseEnabled, 1);
			}
			if (c != null){
				c.mouseEnabled = true;
			}
			//d(c + ": " + c.mouseEnabled, 1);
		}
		
		public function testHit(c:CandidateWord):Boolean
		{
			hitTestTotal++;
			startHitTestTime = new Date();
			
//			if (Math.random() > 0.999) return false;
//			else return true;
			
			var cBounds:Rectangle = new Rectangle(0, 0, 800, 600);
			var r:Rectangle = new Rectangle(
				c.getBounds(this).x,
				c.getBounds(this).y,
				c.getBounds(this).width,
				c.getBounds(this).height
			);
			
			if (!cBounds.containsRect(r) ){
				//return true;
			}

            candidateWordBD.fillRect(candidateWordBD.rect, 0);

			var m:Matrix = rotationMatrix(c);

			if (c.border.height < minTestableWordHeight){
				drawBlockInstead(c, candidateWordBD, m);
			} else { 
				candidateWordBD.draw(c, m);
			}
			
//			with (Application.application.wlcdebug.graphics){
//				beginBitmapFill(candidateWordBD);
//				drawRect(0,0,800,600);
//				endFill();
//				beginBitmapFill(wordCanvasBD);
//				drawRect(0,0,800,600);
//				endFill();
//			}
			
			
			//candidateWordBD.compare(wordCanvasBD);
           	//hitTestTimeTotal += new Date().valueOf() - startHitTestTime.valueOf();
			//return false;
            if (wordCanvasBD.hitTest(new Point(), 0xFF, candidateWordBD, new Point(), 0xFF)) {
            	hitTestTimeTotal += new Date().valueOf() - startHitTestTime.valueOf();
				return true;
            } else {
            	hitTestTimeTotal += new Date().valueOf() - startHitTestTime.valueOf();
				return false;
            }
			
		}
		
		public function newTestHit(c:CandidateWord, debug:Boolean=false):Boolean{
			var qWordCanvasBD:BitmapData;
			var qCandidWordBD:BitmapData;

			var r:Rectangle = c.getBounds(this);
			r.inflate(20,20);
			qWordCanvasBD = new BitmapData(r.width, r.height, true, 0x00000000);
			qCandidWordBD = new BitmapData(r.width, r.height, true, 0x00000000);

			c.visible = true;
			
			var m:Matrix;
			var cos:Number = Math.cos(c.rotation * Math.PI / 180);
			var sin:Number = Math.sin(c.rotation * Math.PI / 180);
			m = new Matrix(cos, sin, -sin, cos, r.width/2, r.height/2);
//			qCandidWordBD.draw(c, m);
			
			if (c.border.height < minTestableWordHeight){
				drawBlockInstead(c, qCandidWordBD, m);
			} else { 
				qCandidWordBD.draw(c, m);
			}

			var rt:Rectangle;
			for each (var ct:CandidateWord in wordList){
				rt = ct.getBounds(this);
				if (ct.placed && rt.intersects(r)){
					cos = Math.cos(ct.rotation * Math.PI / 180);
					sin = Math.sin(ct.rotation * Math.PI / 180);
					m = new Matrix(cos, sin, -sin, cos, ct.x - c.x + r.width/2, ct.y - c.y + r.height/2);

					if (ct.border.height < minTestableWordHeight){
						drawBlockInstead(ct, qWordCanvasBD, m);
					} else { 
						//ct.filters=[glowFilter];
						qWordCanvasBD.draw(ct, m);
						//ct.filters=[];
					}



				}
			}
			
			if (debug) {
				with (Application.application.wlcdebug.graphics){
					clear();
					beginBitmapFill(qWordCanvasBD);
					drawRect(0, 0, r.width, r.height);
					endFill();
					beginBitmapFill(qCandidWordBD);
					drawRect(0, 0, r.width, r.height);
					endFill();
					
					lineStyle(gridMinorThickness, gridColor, 1.0);
					drawRect(
						0, 0, r.width, r.height
					);
	
				}
			}

            if (qWordCanvasBD.hitTest(new Point(), 0xFF, qCandidWordBD, new Point(), 0xFF)) {
            	//d("OVERLAP");
				return true;
            } else {
            	//d("No Overlap");
    			return false;
            }

		}

		private function d(s:String, append:int=0):void{
			s += "\n";
			if (append>0) Application.application.debug.text += s;
			else Application.application.debug.text = s;
		}
		
		public function quickTestHit(c:CandidateWord, debug:Boolean=false):Boolean{
			var r:Rectangle = c.getBounds(this);
			//r.inflate(20,20);

			c.visible = true;
			
			var rt:Rectangle;
			for each (var ct:CandidateWord in wordList){
				rt = ct.getBounds(this);
				if (ct.placed && rt.intersects(r)){
					return true;
				}
			}
			return false;
		}
	}
}