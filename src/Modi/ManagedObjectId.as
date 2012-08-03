/*
 * This is free software; you can redistribute it and/or modify it under the
 * terms of MIT free software license as published by the Massachusetts
 * Institute of Technology.
 *
 * Copyright 2012. Vjekoslav Krajacic, Tomislav Podhraski
 */

package Modi 
{
	import Modi.ManagedObject;
	
	public class ManagedObjectId extends ManagedObject 
	{
		private var _objectId:String;
		
		public function ManagedObjectId(objectId:String = "")
		{
			_objectId = objectId;
		}
		
		public function get objectId():String
		{
			return _objectId;
		}
	}
}