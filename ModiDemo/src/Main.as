package 
{
    import Models.Player.Player;
    import Models.Player._Player;

    import Modi.ManagedObjectContext;
    import Modi.ManagedObjectEvent;

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
            var managedObjectContext:ManagedObjectContext = new ManagedObjectContext();
            var player:Player = managedObjectContext.createManagedObject(Player);
            var playerCopy:Player = managedObjectContext.getManagedObjectById(player.contextId) as Player;

            trace(player.contextId == playerCopy.contextId);

            player.name = "Burek";
            player.addEventListener(_Player.ATTRIBUTE_NAME, ManagedObjectEvent.WAS_CHANGED, nameWasChanged);
            player.name = "Sirnica";
		}

        private function nameWasChanged(e:ManagedObjectEvent):void
        {
            trace(e.attribute); // name
            trace(e.event); // WasChanged
            trace(e.newValue); // Sirnica
            trace(e.oldValue); // Burek
            trace(e.owner); // [object Player]
        }
	}
}