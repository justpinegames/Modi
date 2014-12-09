package Models.Player
{
    import Modi.*;

    public class _Player extends ManagedObject
    {
        public static const ATTRIBUTES:Array = ["commanders","selectedEntity","name","gold","mode",];
        public static const ATTRIBUTE_TYPES:Array = ["ManagedArray","ManagedObjectId","String","Number","String",];

        public static const ATTRIBUTE_COMMANDERS:String = "commanders";
        public static const ATTRIBUTE_SELECTED_ENTITY:String = "selectedEntity";
        public static const ATTRIBUTE_NAME:String = "name";
        public static const ATTRIBUTE_GOLD:String = "gold";
        public static const ATTRIBUTE_MODE:String = "mode";

        public static const MODE_IDLE:String = "idle";
        public static const MODE_WALK:String = "walk";
        public static const MODE_ATTACK:String = "attack";
        public static const MODE_ENUM_ARRAY:Array = [MODE_IDLE, MODE_WALK, MODE_ATTACK, ];

        private var _commanders:ManagedArray;
        private var _selectedEntity:ManagedObjectId;
        private var _name:String;
        private var _gold:Number;
        private var _mode:String;

        public function _Player()
        {
            registerAttributes(ATTRIBUTES, ATTRIBUTE_TYPES);

            _commanders = new ManagedArray();
            _commanders.childType = "Models.Player.Commander";
            _selectedEntity = ManagedObjectId.UNDEFINED;
            _gold = 0;
            _mode = MODE_IDLE;
        }

        public final function set commanders(value:ManagedArray):void { dispatchChangeEvent(ATTRIBUTE_COMMANDERS, _commanders, _commanders = value); }
        public final function set commandersDirectUnsafe(value:ManagedArray):void { _commanders = value; }
        public final function get commanders():ManagedArray { return _commanders; }

        public final function set selectedEntity(value:ManagedObjectId):void { dispatchChangeEvent(ATTRIBUTE_SELECTED_ENTITY, _selectedEntity, _selectedEntity = value); }
        public final function set selectedEntityDirectUnsafe(value:ManagedObjectId):void { _selectedEntity = value; }
        public final function get selectedEntity():ManagedObjectId { return _selectedEntity; }

        public final function set name(value:String):void { dispatchChangeEvent(ATTRIBUTE_NAME, _name, _name = value); }
        public final function set nameDirectUnsafe(value:String):void { _name = value; }
        public final function get name():String { return _name; }

        public final function set gold(value:Number):void { dispatchChangeEvent(ATTRIBUTE_GOLD, _gold, _gold = value); }
        public final function set goldDirectUnsafe(value:Number):void { _gold = value; }
        public final function get gold():Number { return _gold; }

        public final function set mode(value:String):void { dispatchChangeEvent(ATTRIBUTE_MODE, _mode, _mode = value); }
        public final function set modeDirectUnsafe(value:String):void { _mode = value; }
        public final function get mode():String { return _mode; }
    }
}