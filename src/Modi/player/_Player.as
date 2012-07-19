package player
{
	public class _Player extends ManagedObject
	{
		public static const ATTRIBUTE_WEAPONS:String = "weapons";
		public static const ATTRIBUTE_HEALTH:String = "health";

		public static const ATTRIBUTES:Array = ["weapons", "health", ];
		public static const ATTRIBUTES_TYPES:Array = ["String", "Number", ];
		
		public static const WEAPONS_SWORD:String = "sword";
		public static const WEAPONS_AXE:String = "axe";
		public static const WEAPONS_BOW:String = "bow";
		public static const WEAPONS_ENUM_ARRAY:Array = ["sword", "axe", "bow", ];

		
		
		
		private var _weapons:String;
		private var _health:Number;

		public function _Player()
		{
			//this.registerAttribute(ATTRIBUTE_WEAPONS);
			//this.registerAttribute(ATTRIBUTE_HEALTH);
			
			this.registerAttributes(ATTRIBUTES, ATTRIBUTES_TYPES);

			_weapons = WEAPONS_SWORD;
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

		public override function serialize(serializator:ISerializator):void
		{
			writeUnindentified("weapons", this.weapons, "String", serializator);
			writeUnindentified("health", this.health, "Number", serializator);
		}

		public override function deserialize(deserializator:IDserializator):void
		{
			this.weapons = readUnindentified("weapons", "String", deserializator);
			this.health = readUnindentified("health", "Number", deserializator);
		}

	}
}