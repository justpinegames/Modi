Modi
====================

Modi is a model library that was inspired by [Core Data](http://en.wikipedia.org/wiki/Core_Data) framework on MacOS. Core principle is seperating data from code. Model definitions are stored as [YAML](http://en.wikipedia.org/wiki/YAML) text files and are easy to read and maintain. Using simple Python script, data is transformed into Actionscript classes that are easy to monitor.

Requirements
--------------------
* [Python 2.7.3](http://python.org/)
* [as3yaml](http://code.google.com/p/as3yaml/)
* [PyYAML](http://pyyaml.org/wiki/PyYAML)
* [jinja2](https://pypi.python.org/pypi/Jinja2)

Demo example
--------------------

Demo/src/Player.yaml

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

Call to a python script inside of a command line
            
    Modi.py Demo/src/Player.yaml -o Demo/src -p Models.Player

[Created source code](https://github.com/justpinegames/Modi/tree/master/Demo/src/Models/Player)

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

    player.addEventListener(_Player.ATTRIBUTE_NAME, onNameChange);
    player.name = "Sirnica";

    function onNameChange(e:ManagedObjectEvent):void
    {
        trace(e.type); /// name
        trace(e.newValue); /// Sirnica
        trace(e.oldValue); /// Burek
        trace(e.owner); /// [object Player]
    }