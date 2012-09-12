Modi
====================

[Introduction post](http://justpinegames.com/blog/2012/09/introducing-modi/)

Modi is a model library that was inspired by [Core Data](CoreData" href="http://en.wikipedia.org/wiki/Core_Data) framework on MacOS. Core principle is seperating data from code. Model definitions are stored as [YAML](http://en.wikipedia.org/wiki/YAML) text files and are easy to read and maintain. Using simple Python script, data is transformed into Actionscript classes that are easy to monitor.

Requirements
--------------------
[Python 2.7.3](http://python.org/)
[as3yaml](http://code.google.com/p/as3yaml/)
[PyYAML](http://pyyaml.org/wiki/PyYAML)

ModiDemo example
--------------------

ModiDemo/src/Player.yaml

    Player:
        name: String
        commanders: ManagedArray<Commander>
        gold:
            type: Number
            default: 0
        selectedEntity: ManagedObjectId
        mode:
            values: [idle, walk, attack] #Enum.
            default: idle

Call to a python script inside of command line
            
    Modi.py ModiDemo/src/Player.yaml -o ModiDemo/src -p Models.Player

[Created source code](https://github.com/justpinegames/Modi)

Utilities
--------------------

ManagedObjectContext

    var managedObjectContext:ManagedObjectContext = new ManagedObjectContext();
    var player:Player = managedObjectContext.createManagedObject(Player);
    player.name = "Burek";
    var playerCopy:Player = managedObjectContext.getManagedObjectById(player.contextId) as Player;

    trace(playerCopy.name); /// Burek

YAMLSerializator

    var serializator:YAMLSerializator = new YAMLSerializator();
    player.serialize(serializator);

    var stream:FileStream = new FileStream();
    stream.open(new File(destination), FileMode.WRITE);
    stream.writeUTFBytes(serializator.serializeData());
    stream.close();

YAMLDeserializator

    var stream:FileStream = new FileStream();
    stream.open(new File(destination), FileMode.READ);
    var data:String = stream.readUTFBytes(stream.bytesAvailable);
    stream.close();

    var deserializator:YAMLDeserializator = new YAMLDeserializator();
    deserializator.deserializeData(data);
    player.deserialize(deserializator);

Using event listeners

    player.addEventListener(_Player.ATTRIBUTE_NAME, ManagedObjectEvent.WAS_CHANGED, nameWasChanged);
    player.name = "Sirnica";

    function nameWasChanged(e:ManagedObjectEvent):void
    {
        trace(e.attribute); /// name
        trace(e.event); /// WasChanged
        trace(e.newValue); /// Sirnica
        trace(e.oldValue); /// Burek
        trace(e.owner); /// [object Player]
    }