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
			var map:ManagedMap = new ManagedMap();
			map.registerObserver(ManagedMap.WAS_CHANGED, mapChanged);
			map.setObjectAt(1, 3, new Player());
			map.setObjectAt(4, 3, new Player());
			
			map.removeObjectAt(1, 3);
			map.setObjectAtPoint(new Point(4, 3), null);
			
			map.setObjectAt(5, 5, null);
			
			trace(map.getObjectAt(4, 3));
			trace(map.getObjectAt(1, 3));
		}
		
		private function mapChanged(e:MapObserverEvent):void
		{
			trace("Map was changed at position: " + e.x + "x" + e.y);
			trace("Old value: " + e.oldObject + ", new value: " + e.newObject);
			trace("------------------------------------");
		}
	}
}