package com.frankjania.wyrdlelab.core
{
	import com.frankjania.wyrdlelab.collisiondetection.CollisionDetectionElement;
	import com.frankjania.wyrdlelab.collisiondetection.CollisionDetectionSystem;
	import com.frankjania.wyrdlelab.display.CloudComponent;
	import com.frankjania.wyrdlelab.util.FontScaler;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class Word extends Object{
		
		public var frequency:Number;
		public var text:String;
		public var firstOccurance:Date;
		public var cde:CollisionDetectionElement = null;
		public var x:Number;
		public var y:Number;
		
		public function Word(text:String, frequency:Number){
			this.frequency = frequency;
			this.text = text;
		}
		
		public function hashcode():String{
			return this.text + ":" + this.frequency;
		}

		public function getText():String{
			return this.text;
		}
		
		public function toString():String{
			return text + " (" + frequency + ")  @ (" + x + ", " + y + ")";
		}
		
		public function generateCollisionDetectionElement():void{
			var cdeGeneratorSprite:Sprite = new Sprite();
			var fmt:TextFormat = new TextFormat();
			var txt:TextField = new TextField();

			fmt.font = CloudComponent.font;
			txt.text = this.text;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.embedFonts = true;
			txt.selectable = false;
			txt.mouseEnabled = false;
			
			//var div:uint = (-226*trend.frequency/23) + 265;
			//fmt.color = div*0x10000 + div*0x100 + div;
			fmt.color = 0x000000;
			fmt.size = FontScaler.scale(this.frequency);
			txt.setTextFormat(fmt);
			txt.x = -1 * txt.width/2;
			txt.y = -1 * txt.height/2;
			
			trace(this.text + " ("+ this.frequency+", " + txt.x + ", " + txt.width + ") >> " + FontScaler.scale(this.frequency));
			
			cdeGeneratorSprite.addChild(txt);
			
			var cde:CollisionDetectionElement = CollisionDetectionSystem.getElement(this.hashcode());
			if (cde == null){
				var bmp : BitmapData = new BitmapData(txt.width, txt.height, false, 0xffffff);
				bmp.draw(txt);
				
				var r:Rectangle = bmp.getColorBoundsRect(0xFFFFFFFF, fmt.color as uint);
				trace(this.text + " >> " + r);
				cde = new CollisionDetectionElement(this.hashcode(), new Rectangle(r.x - txt.width/2, r.y - txt.height/2, r.width, r.height) );
				CollisionDetectionSystem.addElementToSystem(cde);
			}
			
			cdeGeneratorSprite = null
			fmt = null;
			txt= null;

			this.cde = cde;
		}

	}
}