package Modi 
{
	public class ManagedValue extends ManagedObject
	{
		private var _value:*;
		
		public function ManagedValue(value:*) 
		{
			_value = value;
		}
		
		public function get value():* 
		{
			return _value;
		}
		
		public function set value(value:*):void 
		{
			_value = value;
		}
		
	}

}