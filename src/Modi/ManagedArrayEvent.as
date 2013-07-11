/*
 * This is free software; you can redistribute it and/or modify it under the
 * terms of MIT free software license as published by the Massachusetts
 * Institute of Technology.
 *
 * Copyright 2012. Vjekoslav Krajacic, Tomislav Podhraski
 */

package Modi 
{
    public class ManagedArrayEvent
	{
		public static const ALLOW_REMOVE:String = "AllowRemove";
		public static const WILL_REMOVE:String = "WillRemove";
		public static const WAS_REMOVED:String = "WasRemoved";
		public static const ALLOW_ADD:String = "AllowAdd";
		public static const WILL_ADD:String = "WillAdd";
		public static const WAS_ADDED:String = "WasAdded";
		public static const ALLOW_REPLACE:String = "AllowReplace";
		public static const WILL_REPLACE:String = "WillReplace";
		public static const WAS_REPLACED:String = "WasReplaced";

        public var owner:ManagedArray;
		public var object:ManagedObject;
		public var event:String;
		public var index:int;
		public var oldObject:ManagedObject;
		
		public function ManagedArrayEvent(owner:ManagedArray, object:ManagedObject, event:String, index:int, oldObject:ManagedObject = null)
		{
            this.owner = owner;
			this.object = object;
			this.event = event;
			this.index = index;
			this.oldObject = oldObject;
		}
	}
}