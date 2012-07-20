package Modi 
{
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import org.as3yaml.YAML;
	
	public class YAMLSerializator implements ISerializator
	{
		
		private var _stack:Array;
		private var _data:Object;
		
		public function YAMLSerializator() 
		{
			_stack = new Array();
			_data = { };
			_stack.push(_data);
		}
		
		private function stackTop():* 
		{
			return _stack[_stack.length - 1];
		}
		
		/* INTERFACE Modi.ISerializator */
		
		public function writeString(name:String, object:String):void 
		{
			stackTop()[name] = object;
		}
		
		public function writeInt(name:String, object:int):void 
		{
			stackTop().data[name] = object;
		}
		
		public function writeUInt(name:String, object:int):void 
		{
			stackTop()[name] = object;
		}
		
		public function writeNumber(name:String, object:Number):void 
		{
			stackTop()[name] = object;
		}
		
		public function writeBoolean(name:String, object:Boolean):void 
		{
			stackTop()[name] = object;
		}
		
		public function writePoint(name:String, object:Point):void 
		{
			stackTop()[name] = "(" +  object.x.toString() + ", " + object.y.toString() + ")";
		}
		
		public function writeRectangle(name:String, object:Rectangle):void 
		{
			stackTop()[name] = "(" +	object.x.toString() + ", " + object.y.toString() + ", " + 
												object.width.toString() + ", " + object.height.toString() + ")";
		}
		
		public function pushObject(name:String, className:String):void 
		{
			var newObject:Object = { };
			stackTop()[name] = newObject;
			_stack.push(newObject);
		}
		
		public function popObject():void 
		{
			_stack.pop();
		}
		
		public function serializeData():* 
		{
			var yamlData:String = YAML.encode(_data);
			return yamlData;
		}
		
	}

}