package classes
{
	import Modi.IDeserializator;
	import Modi.ISerializator;
	import Modi.ManagedObject;
	import Modi.ManagedArray;
	import Modi.ManagedMap;

	public class _Player extends ManagedObject
	{
		public static const ATTRIBUTES:Array = ["units", "weapons", "health", "super", ];
		public static const ATTRIBUTES_TYPES:Array = ["ManagedArray", "String", "Number", "ManagedObject", ];

		public static const ATTRIBUTE_UNITS:String = "units";
		public static const ATTRIBUTE_WEAPONS:String = "weapons";
		public static const ATTRIBUTE_HEALTH:String = "health";
		public static const ATTRIBUTE_SUPER:String = "super";

		public static const WEAPONS_SWORD:String = "sword";
		public static const WEAPONS_AXE:String = "axe";
		public static const WEAPONS_BOW:String = "bow";
		public static const WEAPONS_ENUM_ARRAY:Array = ["sword", "axe", "bow", ];

		private var _units:ManagedArray;
		private var _weapons:String;
		private var _health:Number;

		public function _Player()
		{
			this.registerAttributes(ATTRIBUTES, ATTRIBUTES_TYPES);

			this._weapons = WEAPONS_SWORD;

			this._units = new ManagedArray;
		}

		public function set units(units:ManagedArray):void
		{
			if (!this.allowChange(ATTRIBUTE_UNITS, this._units, units))
			{
				return;
			}

			this.willChange(ATTRIBUTE_UNITS, this._units, units)

			this._units = units;

			this.hasChanged(ATTRIBUTE_UNITS, this._units, units)
		}

		public function get units():ManagedArray
		{
			return this._units;
		}

		public function set UnitsDirectUnsafe(units:ManagedArray):void
		{
			this._units = units;
		}

		public function set weapons(weapons:String):void
		{
			if (!this.allowChange(ATTRIBUTE_WEAPONS, this._weapons, weapons))
			{
				return;
			}

			this.willChange(ATTRIBUTE_WEAPONS, this._weapons, weapons)

			this._weapons = weapons;

			this.hasChanged(ATTRIBUTE_WEAPONS, this._weapons, weapons)
		}

		public function get weapons():String
		{
			return this._weapons;
		}

		public function set WeaponsDirectUnsafe(weapons:String):void
		{
			this._weapons = weapons;
		}

		public function set health(health:Number):void
		{
			if (!this.allowChange(ATTRIBUTE_HEALTH, this._health, health))
			{
				return;
			}

			this.willChange(ATTRIBUTE_HEALTH, this._health, health)

			this._health = health;

			this.hasChanged(ATTRIBUTE_HEALTH, this._health, health)
		}

		public function get health():Number
		{
			return this._health;
		}

		public function set HealthDirectUnsafe(health:Number):void
		{
			this._health = health;
		}

		public function set super(super:ManagedObject):void
		{
			if (!this.allowChange(ATTRIBUTE_SUPER, this._super, super))
			{
				return;
			}

			this.willChange(ATTRIBUTE_SUPER, this._super, super)

			this._super = super;

			this.hasChanged(ATTRIBUTE_SUPER, this._super, super)
		}

		public function get super():ManagedObject
		{
			return this._super;
		}

		public function set SuperDirectUnsafe(super:ManagedObject):void
		{
			this._super = super;
		}

		public override function serialize(serializator:ISerializator):void
		{
			writeUnindentified("units", this.units, "ManagedArray", serializator);
			writeUnindentified("weapons", this.weapons, "String", serializator);
			writeUnindentified("health", this.health, "Number", serializator);
			writeUnindentified("super", this.super, "ManagedObject", serializator);
		}

		public override function deserialize(deserializator:IDeserializator):void
		{
			this.units = readUnindentified("units", "ManagedArray", deserializator);
			this.weapons = readUnindentified("weapons", "String", deserializator);
			this.health = readUnindentified("health", "Number", deserializator);
			this.super = readUnindentified("super", "ManagedObject", deserializator);
		}

	}
}