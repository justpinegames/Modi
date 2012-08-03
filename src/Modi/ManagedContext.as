/*
 * This is free software; you can redistribute it and/or modify it under the
 * terms of MIT free software license as published by the Massachusetts
 * Institute of Technology.
 *
 * Copyright 2012. Vjekoslav Krajacic, Tomislav Podhraski
 */

package Modi 
{
	import Core.Assert;
	import flash.utils.Dictionary;
	
	public class ManagedContext 
	{
		private var _managedObjects:Dictionary;
		private var _idCounter:uint;
		
		public function ManagedContext() 
		{
			_managedObjects = new Dictionary();
			_idCounter = 0;
		}
		
		public function addToContext(managedObject:ManagedObject):void
		{
			var id:String = "id_" + _idCounter;
			_managedObjects[id] = managedObject;
			managedObject.contextId = new ManagedObjectId(id);
			_idCounter++;
		}
		
		public function removeFromContext(id:ManagedObjectId):void
		{
			Assert(_managedObjects[id.objectId], "ManagedObject with " + id.objectId + " does not exist!");
			_managedObjects[id.objectId] = null;
		}
		
		public function getManagedObjectById(id:ManagedObjectId):ManagedObject
		{
			var managedObject:ManagedObject = _managedObjects[id.objectId];
			//Assert(managedObject, "ManagedObject with " + id + " does not exist!");
			
			return managedObject;
		}
		
		public function createManagedObject(ObjectClass:Class):*
		{
			var object:* = new ObjectClass();
			this.addToContext(object);
			return object;
		}
		
	}
}