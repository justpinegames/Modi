package 
{
	import Modi.*;

	import flash.utils.Dictionary;

	public class _Test extends ManagedObject
	{
		public static const ATTRIBUTES:Array = ["attributttt", "atribut", ];
		public static const ATTRIBUTES_TYPES:Array = ["String", "int", ];

		public static const ATTRIBUTE_ATTRIBUTTTT:String = "attributttt";
		public static const ATTRIBUTE_ATRIBUT:String = "atribut";

		public static const ATTRIBUTTTT_DSADS:String = "dsads";
		public static const ATTRIBUTTTT_DSADS:String = "dsads";
		public static const ATTRIBUTTTT_ENUM_ARRAY:Array = ["dsads", "dsads", ];

		private var _attributttt:String;
		private var _atribut:int;

		public function _Test()
		{
			this.registerAttributes(ATTRIBUTES, ATTRIBUTES_TYPES);

			this._attributttt = ATTRIBUTTTT_DSADS;
			this._atribut = 10;

		}

		public final function set attributttt(attributttt:String):void
		{
			if (!this.allowChange(ATTRIBUTE_ATTRIBUTTTT, this._attributttt, attributttt))
			{
				return;
			}

			this.willChange(ATTRIBUTE_ATTRIBUTTTT, this._attributttt, attributttt);

			var oldState:String = this._attributttt;

			this._attributttt = attributttt;

			this.wasChanged(ATTRIBUTE_ATTRIBUTTTT, oldState, attributttt);
		}

		public final function get attributttt():String
		{
			return this._attributttt;
		}

		public final function set AttributtttDirectUnsafe(attributttt:String):void
		{
			this._attributttt = attributttt;
		}

		public final function set atribut(atribut:int):void
		{
			if (!this.allowChange(ATTRIBUTE_ATRIBUT, this._atribut, atribut))
			{
				return;
			}

			this.willChange(ATTRIBUTE_ATRIBUT, this._atribut, atribut);

			var oldState:int = this._atribut;

			this._atribut = atribut;

			this.wasChanged(ATTRIBUTE_ATRIBUT, oldState, atribut);
		}

		public final function get atribut():int
		{
			return this._atribut;
		}

		public final function set AtributDirectUnsafe(atribut:int):void
		{
			this._atribut = atribut;
		}

	}
}