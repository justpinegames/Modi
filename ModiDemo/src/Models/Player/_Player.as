package Models.Player
{
	import Modi.*;

	import flash.utils.Dictionary;

	public class _Player extends ManagedObject
	{
		public static const ATTRIBUTES:Array = ["commanders", "selectedEntity", "name", "gold", "mode", ];
		public static const ATTRIBUTE_TYPES:Array = ["ManagedArray", "ManagedObjectId", "String", "Number", "String", ];

		public static const ATTRIBUTE_COMMANDERS:String = "commanders";
		public static const ATTRIBUTE_SELECTED_ENTITY:String = "selectedEntity";
		public static const ATTRIBUTE_NAME:String = "name";
		public static const ATTRIBUTE_GOLD:String = "gold";
		public static const ATTRIBUTE_MODE:String = "mode";

		public static const MODE_IDLE:String = "idle";
		public static const MODE_WALK:String = "walk";
		public static const MODE_ATTACK:String = "attack";
		public static const MODE_ENUM_ARRAY:Array = ["idle", "walk", "attack", ];

		private var _commanders:ManagedArray;
		private var _selectedEntity:ManagedObjectId;
		private var _name:String;
		private var _gold:Number;
		private var _mode:String;

		public function _Player()
		{
			this.registerAttributes(ATTRIBUTES, ATTRIBUTE_TYPES);

			_gold = 0;
			_mode = MODE_IDLE;

			_commanders = new ManagedArray();
			_commanders.childType = "Models.Player.Commander";
			_selectedEntity = new ManagedObjectId();
		}

		public final function set commanders(commanders:ManagedArray):void
		{
			if (!this.allowChange(ATTRIBUTE_COMMANDERS, _commanders, commanders))
			{
				return;
			}

			this.willChange(ATTRIBUTE_COMMANDERS, _commanders, commanders);

			var oldValue:ManagedArray = _commanders;

			_commanders = commanders;

			this.wasChanged(ATTRIBUTE_COMMANDERS, oldValue, _commanders);
		}

		public final function get commanders():ManagedArray
		{
			return _commanders;
		}

		public final function set CommandersDirectUnsafe(commanders:ManagedArray):void
		{
			_commanders = commanders;
		}

		public final function set selectedEntity(selectedEntity:ManagedObjectId):void
		{
			if (!this.allowChange(ATTRIBUTE_SELECTED_ENTITY, _selectedEntity, selectedEntity))
			{
				return;
			}

			this.willChange(ATTRIBUTE_SELECTED_ENTITY, _selectedEntity, selectedEntity);

			var oldValue:ManagedObjectId = _selectedEntity;

			_selectedEntity = selectedEntity;

			this.wasChanged(ATTRIBUTE_SELECTED_ENTITY, oldValue, _selectedEntity);
		}

		public final function get selectedEntity():ManagedObjectId
		{
			return _selectedEntity;
		}

		public final function set SelectedentityDirectUnsafe(selectedEntity:ManagedObjectId):void
		{
			_selectedEntity = selectedEntity;
		}

		public final function set name(name:String):void
		{
			if (!this.allowChange(ATTRIBUTE_NAME, _name, name))
			{
				return;
			}

			this.willChange(ATTRIBUTE_NAME, _name, name);

			var oldValue:String = _name;

			_name = name;

			this.wasChanged(ATTRIBUTE_NAME, oldValue, _name);
		}

		public final function get name():String
		{
			return _name;
		}

		public final function set NameDirectUnsafe(name:String):void
		{
			_name = name;
		}

		public final function set gold(gold:Number):void
		{
			if (!this.allowChange(ATTRIBUTE_GOLD, _gold, gold))
			{
				return;
			}

			this.willChange(ATTRIBUTE_GOLD, _gold, gold);

			var oldValue:Number = _gold;

			_gold = gold;

			this.wasChanged(ATTRIBUTE_GOLD, oldValue, _gold);
		}

		public final function get gold():Number
		{
			return _gold;
		}

		public final function set GoldDirectUnsafe(gold:Number):void
		{
			_gold = gold;
		}

		public final function set mode(mode:String):void
		{
			if (!this.allowChange(ATTRIBUTE_MODE, _mode, mode))
			{
				return;
			}

			this.willChange(ATTRIBUTE_MODE, _mode, mode);

			var oldValue:String = _mode;

			_mode = mode;

			this.wasChanged(ATTRIBUTE_MODE, oldValue, _mode);
		}

		public final function get mode():String
		{
			return _mode;
		}

		public final function set ModeDirectUnsafe(mode:String):void
		{
			_mode = mode;
		}

	}
}