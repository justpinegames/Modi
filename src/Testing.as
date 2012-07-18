package  
{
	
	import flash.utils.Dictionary;
	import Modi.ArrayObserverEvent;
	import Modi.ManagedArray;
	import Modi.ManagedObject;
	import Modi.AttributeObserverEvent;
	import starling.display.Sprite;
	import starling.events.Event;
	
	import Modi.player.Player;
	import Modi.player._Player;
	
	public class Testing extends Sprite
	{
		
		public function Testing()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function addedToStageHandler(event:Event):void
		{
			var test:Dictionary = new Dictionary();
			var x:int = 2;
			var y:int = 3;
			
			test[x + "x" + y] = 100;
			
			trace(test["2x3"]);
			
		}
	}
}