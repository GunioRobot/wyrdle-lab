package com.frankjania.wyrdlelab.display
{
	import com.frankjania.wyrdlelab.core.Word;
	import com.frankjania.wyrdlelab.util.ColorScaler;
	import com.frankjania.wyrdlelab.util.FontScaler;
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import mx.core.UIComponent;
	
	public class WordSprite extends UIComponent
	{
		private var fmt:TextFormat = new TextFormat();
		private var txt:TextField = new TextField();
		
		private var trend:Word;
		
		public function WordSprite(trend:Word):void{
			//txt.antiAliasType = AntiAliasType.ADVANCED;
			this.configure(trend);
		}
		
		override protected function createChildren():void {
		    super.createChildren();
			addChild(txt);
		}
				
		public function configure(trend:Word):void{
  			this.visible = false;
  			this.trend = trend;
  			
			fmt.font = CloudComponent.font;
			txt.text = trend.text;
			txt.autoSize = TextFieldAutoSize.LEFT;
			
			txt.embedFonts = true;
			txt.selectable = false;
			txt.mouseEnabled = false;
			
			updateFrequency(trend);
		}

		public function updateFrequency(trend:Word):void{
			fmt.color = ColorScaler.scale(trend.frequency);
			fmt.color = 0x000000;			
			fmt.size = FontScaler.scale(trend.frequency);
  			txt.setTextFormat(fmt);
  			
  			txt.x = -1 * txt.width/2;
  			txt.y = -1 * txt.height/2;
		}
		
		public function updateColor(color:uint):void{
			fmt.color = color;
			txt.setTextFormat(fmt);
		}
		
		public function getTrend():Word{
			return trend;
		}

		public function show():void{
			this.x = trend.x;
			this.y = trend.y;
			this.visible = true;
		}
	}
}

