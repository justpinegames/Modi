/*
 * This is free software; you can redistribute it and/or modify it under the
 * terms of MIT free software license as published by the Massachusetts
 * Institute of Technology.
 *
 * Copyright 2012. Vjekoslav Krajacic, Tomislav Podhraski
 */

package Modi 
{
    public class ManagedMapEvent
	{
		public static const ALLOW_CHANGE:String = "AllowChange";
		public static const WILL_CHANGE:String = "WillChange";
		public static const WAS_CHANGED:String = "WasChanged";

        public var owner:ManagedMap;
		public var oldObject:ManagedObject;
		public var newObject:ManagedObject;
		public var event:String;
		public var x:int;
		public var y:int;
		
		public function ManagedMapEvent(owner:ManagedMap, oldObject:ManagedObject, newObject:ManagedObject, event:String, x:int, y:int)
		{
            this.owner = owner;
			this.oldObject = oldObject;
			this.newObject = newObject;
			this.event = event;
			this.x = x;
			this.y = y;
		}
	}
}