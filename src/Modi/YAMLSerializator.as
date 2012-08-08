package Modi 
{
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import org.as3yaml.YAML;
	
	public class YAMLSerializator implements ISerializator
	{
		private const SERIALIZATOR_STATE_OBJECT:String = "SERIALIZATOR_STATE_OBJECT";
		private const SERIALIZATOR_STATE_ARRAY:String = "SERIALIZATOR_STATE_ARRAY";
		private const SERIALIZATOR_STATE_MAP:String = "SERIALIZATOR_STATE_MAP";
		
		private var _stack:Array;
		
		public function YAMLSerializator() 
		{
			_stack = new Array();
			_stack.push({data: {}, context: SERIALIZATOR_STATE_OBJECT});
		}
		
		private function stackTop():* 
		{
			return _stack[_stack.length - 1].data;
		}
		
		private function stackTopContext():String
		{
			return _stack[_stack.length - 1].context;
		}
		
		private function writeToTop(name:String, object:*):void 
		{
			if (stackTopContext() == SERIALIZATOR_STATE_OBJECT) 
			{
				stackTop()[name] = object;	
			}
			else if (stackTopContext() == SERIALIZATOR_STATE_ARRAY) 
			{
				stackTop().push(object)
			}
			else if (stackTopContext() == SERIALIZATOR_STATE_MAP) 
			{
				
			}
			else 
			{
				throw new Error("Invalid context");
			}
			
		}
		
		/* INTERFACE Modi.ISerializator */
		
		public function writeString(name:String, object:String):void 
		{
			writeToTop(name, object);
		}
		
		public function writeInt(name:String, object:int):void 
		{
			writeToTop(name, object);
		}
		
		public function writeUInt(name:String, object:int):void 
		{
			writeToTop(name, object);
		}
		
		public function writeNumber(name:String, object:Number):void 
		{
			writeToTop(name, object);
		}
		
		public function writeBoolean(name:String, object:Boolean):void 
		{
			writeToTop(name, object);
		}
		
		public function writeDictionary(name:String, object:Dictionary):void
		{
			trace("Not sure that write dictionary works...");
			writeToTop(name, object);
		}
		
		public function writeArray(name:String, object:Array):void
		{
			trace("Not sure that write array works...");	
			writeToTop(name, object);
		}
		
		public function pushArray(name:String):void
		{
			var newArray:Array = [];
			stackTop()[name] = newArray;
			_stack.push({data:newArray, context:SERIALIZATOR_STATE_OBJECT});
		}
		
		public function popArray():void
		{
			_stack.pop();
		}
		
		public function pushMap(name:String):void
		{
			trace("pushMap not implemented");
		}
		
		public function popMap():void
		{
			trace("popMap not implemented");	
		}
		
		public function pushObject(name:String):void 
		{
			var newObject:Object = {};
			stackTop()[name] = newObject;
			_stack.push({data:newObject, context:SERIALIZATOR_STATE_OBJECT});
		}
		
		public function popObject():void 
		{
			_stack.pop();
		}
		
		public function serializeData():* 
		{
			var yamlData:String = YAML.encode(stackTop());
			return yamlData;
		}
		
	}

}