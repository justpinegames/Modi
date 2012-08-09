package 
{
import flash.display.Sprite;
import flash.events.Event;

public class Main extends Sprite
	{

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

		}
	}
}