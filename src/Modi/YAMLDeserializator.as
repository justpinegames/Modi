/*
 * This is free software; you can redistribute it and/or modify it under the
 * terms of MIT free software license as published by the Massachusetts
 * Institute of Technology.
 *
 * Copyright 2012. Vjekoslav Krajacic, Tomislav Podhraski
 */

package Modi
{
	import flash.utils.Dictionary;
	import org.as3yaml.YAML;
	
	public class YAMLDeserializator implements IDeserializator
	{
		private const SERIALIZATOR_STATE_OBJECT:String = "SERIALIZATOR_STATE_OBJECT";
		private const SERIALIZATOR_STATE_ARRAY:String = "SERIALIZATOR_STATE_ARRAY";
		private const SERIALIZATOR_STATE_MAP:String = "SERIALIZATOR_STATE_MAP";
		
		private var _stack:Array;
		private var _data:Object;
		private var _ready:Boolean;
		
		public function YAMLDeserializator()
		{
			_ready = false;
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
				throw new Error("ManagedMap serialization not implemented.");
			}
			else 
			{
				throw new Error("Invalid context");
			}
		}
		
		public function deserializeData(data:*):void 
		{
			_data = YAML.decode(data);
			_stack.push( { data:_data, context:SERIALIZATOR_STATE_OBJECT } );
			_ready = true;
		}
		
		public function get ready():Boolean
		{
			return _ready;
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
		
		public function readDictionary(name:String):Dictionary
		{
			var object:* = readFromTop(name);
			return object;
		}
		
		public function readArray(name:String):Array
		{
			var object:* = readFromTop(name);
			return object;
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
			throw new Error("ManagedMap is not implemented in serialization");
		}
		
		public function popMap():void 
		{
			throw new Error("ManagedMap is not implemented in serialization");
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

        public function exists(name:String):Boolean
        {
            return (name in stackTop());
        }

    }
}