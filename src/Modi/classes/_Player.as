package classes
{
	import Modi.ManagedObject;
	import Modi.ManagedArray;
	import Modi.ManagedMap;

	public class _Player extends ManagedObject
	{
		public static const ATTRIBUTES:Array = ["units", "weapons", "health", ];
		public static const ATTRIBUTES_TYPES:Array = ["ManagedArray", "String", "Number", ];

		public static const ATTRIBUTE_UNITS:String = "units";
		public static const ATTRIBUTE_WEAPONS:String = "weapons";
		public static const ATTRIBUTE_HEALTH:String = "health";

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

			this._units = new ManagedArray();
			this._units.childType = "NekaSubklasa";
		}

		public function set units(units:ManagedArray):void
		{
			if (!this.allowChange(ATTRIBUTE_UNITS, this._units, units))
			{
				return;
			}

			this.willChange(ATTRIBUTE_UNITS, this._units, units)

			this._units = units;

			this.wasChanged(ATTRIBUTE_UNITS, this._units, units)
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

			this.wasChanged(ATTRIBUTE_WEAPONS, this._weapons, weapons)
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

			this.wasChanged(ATTRIBUTE_HEALTH, this._health, health)
		}

		public function get health():Number
		{
			return this._health;
		}

		public function set HealthDirectUnsafe(health:Number):void
		{
			this._health = health;
		}

	}
}