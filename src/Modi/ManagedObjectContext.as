/*
 * This is free software; you can redistribute it and/or modify it under the
 * terms of MIT free software license as published by the Massachusetts
 * Institute of Technology.
 *
 * Copyright 2012. Vjekoslav Krajacic, Tomislav Podhraski
 */

package Modi 
{
	import flash.utils.Dictionary;
	
	public class ManagedObjectContext 
	{
		private var _managedObjects:Dictionary;
		private var _idCounter:uint;
		
		public function ManagedObjectContext() 
		{
			_managedObjects = new Dictionary();
			_idCounter = 0;
		}
		
		public function addToContext(managedObject:ManagedObject):void
		{
			var id:ManagedObjectId = new ManagedObjectId("id_" + _idCounter);
			_managedObjects[id.objectId] = managedObject;
			managedObject.contextId = new ManagedObjectId(id.objectId);
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