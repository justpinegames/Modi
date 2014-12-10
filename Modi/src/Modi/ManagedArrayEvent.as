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

    public class ManagedArrayEvent extends Event
	{
		public static const REMOVE:String = "remove";
		public static const ADD:String = "add";
		public static const REPLACE:String = "replace";

        public var owner:ManagedArray;
        public var index:int;
		public var object:ManagedObject;
		public var oldObject:ManagedObject;

        public function ManagedArrayEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);
        }
	}
}