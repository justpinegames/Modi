package 
{
    import Models.Player.Player;
    import Models.Player._Player;

    import Modi.ManagedObjectContext;
    import Modi.ManagedObjectEvent;
    import Modi.YAMLDeserializator;
    import Modi.YAMLSerializator;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;

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
            /// Creating Player through ManagedObjectContext.
            var player:Player = managedObjectContext.createManagedObject(Player);
            player.name = "Burek";
            /// Fetching Player from ManagedObjectContext.
            var playerCopy:Player = managedObjectContext.getManagedObjectById(player.contextId) as Player;

            trace(playerCopy.name); /// Burek

            /// Using YAMLSerializator to serialize player.
            var serializator:YAMLSerializator = new YAMLSerializator();
            player.serialize(serializator);

            /// Destination on a local disc where player data will be stored.
            var path:String = "/../ModiDemo/src/PlayerData.yaml";
            var destination:String = new File(File.applicationDirectory.nativePath + path).nativePath;

            /// Saving serialized data to a local disc.
            var stream:FileStream = new FileStream();
            stream.open(new File(destination), FileMode.WRITE);
            stream.writeUTFBytes(serializator.serializeData());
            stream.close();

            /// Creating a new Player.
            player = managedObjectContext.createManagedObject(Player);

            /// Loading serialized data from a local disc.
            stream.open(new File(destination), FileMode.READ);
            var data:String = stream.readUTFBytes(stream.bytesAvailable);
            stream.close();

            /// Using YAMLDeserializator to deserialize player.
            var deserializator:YAMLDeserializator = new YAMLDeserializator();
            deserializator.deserializeData(data);
            player.deserialize(deserializator);

            trace(player.name); /// Burek

            /// Adding event listener to attribute name.
            player.addEventListener(_Player.ATTRIBUTE_NAME, ManagedObjectEvent.WAS_CHANGED, nameWasChanged);
            player.name = "Sirnica";
		}

        private function nameWasChanged(e:ManagedObjectEvent):void
        {
            trace(e.attribute); /// name
            trace(e.event); /// WasChanged
            trace(e.newValue); /// Sirnica
            trace(e.oldValue); /// Burek
            trace(e.owner); /// [object Player]
        }
	}
}