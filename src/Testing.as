package  
{
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import Modi.ArrayObserverEvent;
	import Modi.ManagedArray;
	import Modi.ManagedObject;
	import Modi.ManagedMap;
	import Modi.AttributeObserverEvent;
	import Modi.MapObserverEvent;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Testing extends Sprite
	{
		
		public function Testing()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function addedToStageHandler(event:Event):void
		{
		}
	}
}