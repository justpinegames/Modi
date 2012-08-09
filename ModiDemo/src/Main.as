package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import starling.core.Starling;
	
	public class Main extends Sprite 
	{
		private var starling:Starling;
		
		public function Main():void 
		{
			if (stage)
			{
				init();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			}
		}
		
		private function init(e:Event = null):void
		{
			starling = new Starling(Testing, stage);
			starling.start();
		}
	}
}