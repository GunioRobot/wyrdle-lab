package com.frankjania.wyrdlelab
{
	import com.adobe.serialization.json.JSON;
	
	import mx.core.Application;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public class TwitterTrendLoader
	{
		public var twitterTrends:Array = new Array();
		
		public function TwitterTrendLoader()
		{
			var s:HTTPService = new HTTPService();
			s.url = "http://digitalanalog.net/twitterproxy/dailytrends.py";
			s.addEventListener(ResultEvent.RESULT, onJSONLoad);
			s.send();

//			d("Loading: http://search.twitter.com/trends/daily.json");
//			
//			var urlLoader: URLLoader = new URLLoader();
//			urlLoader.addEventListener(Event.COMPLETE, onJSONLoad);
//			urlLoader.load(new  URLRequest("http://search.twitter.com/trends/daily.json"));

		}
		
		private function onJSONLoad(event:ResultEvent):void
		{
			var rawData:String = String(event.result);

			var obj:Object = JSON.decode(rawData);
//			d("Object: " + obj["trends"], 1);

			
//			{"as_of":1255365922,
//			"trends":{"2009-10-12 16:45:22":
//				[{"name":"#musicmonday","query":"#musicmonday"},{"name":"#ruleofrelationships","query":"#ruleofrelationships"},{"name":"Happy Columbus Day","query":"\"Happy Columbus Day\" OR \"Columbus Day\""},{"name":"Happy Thanksgiving","query":"\"Happy Thanksgiving\" OR Thanksgiving"},{"name":"#rulesofrelationship","query":"#rulesofrelationship"},{"name":"#MM","query":"#MM"},{"name":"Halloween","query":"Halloween"},{"name":"Paranormal Activity","query":"\"Paranormal Activity\""},{"name":"Justin Bieber","query":"\"Justin Bieber\""},{"name":"New Michael Jackson","query":"\"New Michael Jackson\" OR \"Michael Jackson\""}]
//				}}
			
			var trends:Object = obj["trends"];
//			d("Trends: " + trends, 1);
			
			for(var trendDate:String in trends){
				var trendList:Object = trends[trendDate];
				
				for(var j:int=0; j < trendList.length; j++){
					twitterTrends.push(trendList[j]["name"]);
				}
			}

			for(var i:int=0; i < twitterTrends.length; i++){
				//d("Trend: " + twitterTrends[i], 1);
				Application.application.wordList.addWord(twitterTrends[i]);
				
			}

			Application.application.wordList.countWords(null);

		}
		
		private function d(s:String, append:int=0):void{
			s += "\n";
			if (append>0) Application.application.debug.text += s;
			else Application.application.debug.text = s;
		}

	}
}