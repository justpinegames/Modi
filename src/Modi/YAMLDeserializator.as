package Modi
{
	import org.as3yaml.YAML;
	
	public class YAMLDeserializator implements IDeserializator
	{
		private const SERIALIZATOR_STATE_OBJECT:String = "SERIALIZATOR_STATE_OBJECT";
		private const SERIALIZATOR_STATE_ARRAY:String = "SERIALIZATOR_STATE_ARRAY";
		private const SERIALIZATOR_STATE_MAP:String = "SERIALIZATOR_STATE_MAP";
		
		private var _stack:Array;
		private var _data:Object;
		
		public function YAMLDeserializator()
		{
			_data = null;
			_stack = new Array;
		}
		
		private function stackTop():* 
		{
			return _stack[_stack.length - 1].data;
		}
		
		private function stackTopContext():String
		{
			return _stack[_stack.length - 1].context;
		}
		
		private function readFromTop(name:String):*
		{
			if (stackTopContext() == SERIALIZATOR_STATE_OBJECT) 
			{
				return stackTop()[name];
			}
			else if (stackTopContext() == SERIALIZATOR_STATE_ARRAY) 
			{
				return stackTop()[int(name)];
			}
			else if (stackTopContext() == SERIALIZATOR_STATE_MAP) 
			{
				
			}
			else 
			{
				throw new Error("Invalid context");
			}
			
		}
		
		/* INTERFACE Modi.IDeserializator */
		
		public function deserializeData(data:*):void 
		{
			_data = YAML.decode(data);
			_stack.push( { data:_data, context:SERIALIZATOR_STATE_OBJECT } );
		}
		
		public function readString(name:String):String 
		{
			return readFromTop(name) as String;
		}
		
		public function readInt(name:String):int 
		{
			return readFromTop(name) as int;
		}
		
		public function readUInt(name:String):uint 
		{
			return readFromTop(name) as uint;
		}
		
		public function readNumber(name:String):Number 
		{
			return readFromTop(name) as Number;
		}
		
		public function readBoolean(name:String):Boolean 
		{
			return readFromTop(name) as Boolean;
		}
		
		public function pushObject(name:String):void 
		{
			var object:Object = stackTop()[name];
			_stack.push({data:object, context:SERIALIZATOR_STATE_OBJECT});
		}
		
		public function popObject():void 
		{
			_stack.pop();
		}
		
		public function pushArray(name:String):void 
		{
			var array:Array = stackTop()[name];
			_stack.push({data:array, context:SERIALIZATOR_STATE_ARRAY});
		}
		
		public function popArray():void 
		{
			_stack.pop();
		}
		
		public function pushMap(name:String):void 
		{
			
		}
		
		public function popMap():void 
		{
			
		}
		
		public function getCurrentLength():int 
		{
			if (stackTopContext() == SERIALIZATOR_STATE_ARRAY) 
			{
				return stackTop().length;
			}
			else 
			{
				throw new Error("current state is not an array")
			}
		}
	
	}

}