/*
 * This is free software; you can redistribute it and/or modify it under the
 * terms of MIT free software license as published by the Massachusetts
 * Institute of Technology.
 *
 * Copyright 2012. Vjekoslav Krajacic, Tomislav Podhraski
 */

package Modi
{
	public class ManagedValue extends ManagedObject
	{
		private var _value:*;
		
		public function ManagedValue(value:* = null)
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

        public function get booleanValue():Boolean
        {
            return Boolean(_value);
        }

	}
}