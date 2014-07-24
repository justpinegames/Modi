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

    public class ManagedObjectEvent extends Event
	{
        public var owner:ManagedObject;
		public var oldValue:*;
		public var newValue:*;

        public function ManagedObjectEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable)
        }
	}
}