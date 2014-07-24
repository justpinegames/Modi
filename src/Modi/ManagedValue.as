/*
 * This is free software; you can redistribute it and/or modify it under the
 * terms of MIT free software license as published by the Massachusetts
 * Institute of Technology.
 *
 * Copyright 2014. Pine Studio
 */

package Modi
{
	public class ManagedValue extends ManagedObject
	{
        public static const ATTRIBUTES:Array = ["value"];
        public static const ATTRIBUTE_TYPES:Array = ["*"];

        public static const ATTRIBUTE_VALUE:String = "value";

		private var _value:*;
		
		public function ManagedValue(value:* = null)
		{
            this.registerAttributes(ATTRIBUTES, ATTRIBUTE_TYPES);

			_value = value;
		}

        public final function set value(value:*):void { dispatchChangeEvent(ATTRIBUTE_VALUE, _value, _value = value); }
        public final function get value():* { return _value; }

        public final function get booleanValue():Boolean { return Boolean(_value); }

        public final function get intValue():int { return int(_value); }

        public final function get uintValue():uint { return uint(_value); }

        public final function get numberValue():Number { return Number(_value); }

        public final function get stringValue():String { return String(_value); }
    }
}