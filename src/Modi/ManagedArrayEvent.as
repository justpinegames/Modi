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
		public static var ALLOW_REMOVE:String = "AllowRemove";
		public static var WILL_REMOVE:String = "WillRemove";
		public static var WAS_REMOVED:String = "WasRemoved";
		public static var ALLOW_ADD:String = "AllowAdd";
		public static var WILL_ADD:String = "WillAdd";
		public static var WAS_ADDED:String = "WasAdded";
		public static var ALLOW_REPLACE:String = "AllowReplace";
		public static var WILL_REPLACE:String = "WillReplace";
		public static var WAS_REPLACED:String = "WasReplaced";

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