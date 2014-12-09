/*
 * This is free software; you can redistribute it and/or modify it under the
 * terms of MIT free software license as published by the Massachusetts
 * Institute of Technology.
 *
 * Copyright 2014. Pine Studio
 */

package Modi 
{
    import flash.events.Event;

    public class ManagedMapEvent extends Event
	{
		public static const CHANGE:String = "change";

        public var owner:ManagedMap;
		public var oldObject:ManagedObject;
		public var newObject:ManagedObject;
		public var x:int;
		public var y:int;

        public function ManagedMapEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);
        }
	}
}