/*
 * This is free software; you can redistribute it and/or modify it under the
 * terms of MIT free software license as published by the Massachusetts
 * Institute of Technology.
 *
 * Copyright 2012. Vjekoslav Krajacic, Tomislav Podhraski
 */

package Modi 
{
	public class ArrayObserverEvent 
	{
		public var object:ManagedObject;
		public var event:String;
		public var index:int;
		public var oldObject:ManagedObject;
		
		public function ArrayObserverEvent(object:ManagedObject, event:String, index:int, oldObject:ManagedObject = null) 
		{
			this.object = object;
			this.event = event;
			this.index = index;
			this.oldObject = oldObject;
		}
	}
}