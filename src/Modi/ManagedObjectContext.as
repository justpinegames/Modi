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
			var id:ManagedObjectId = new ManagedObjectId("id" + _idCounter);
			_managedObjects[id.objectId] = managedObject;
			managedObject.contextId = id;
			_idCounter++;
		}
		
		public function removeFromContext(id:ManagedObjectId):void
		{
			Assert(_managedObjects[id.objectId], "ManagedObject with " + id.objectId + " does not exist!");
			_managedObjects[id.objectId] = null;
		}
		
		public function getManagedObjectById(id:ManagedObjectId):ManagedObject
		{
            if (!id)
            {
                return null;
            }

			var managedObject:ManagedObject = _managedObjects[id.objectId];
			
			return managedObject;
		}
		
		public function createManagedObject(ObjectClass:Class):*
		{
			var object:* = new ObjectClass();
			this.addToContext(object);
			return object;
		}

        private function addToContextWithId(managedObject:ManagedObject, id:ManagedObjectId):void
        {
            _managedObjects[id.objectId] = managedObject;
        }

        private function deserializeIds(base:ManagedObject):void
        {
            if (base.contextId)
            {
                _idCounter = Math.max(_idCounter, base.contextId.extractIndex() + 1);
                addToContextWithId(base, base.contextId);
            }

            for each (var attributeName:String in base.registeredAttributes)
            {
                var attribute:* = base[attributeName];

                if (attribute is ManagedArray)
                {
                    var managedArray:ManagedArray = attribute as ManagedArray;
                    for (var index:int = 0; index < managedArray.length; index++)
                    {
                        var managedObjectFromArray:ManagedObject = managedArray.objectAt(index);
                        deserializeIds(managedObjectFromArray);
                    }
                }
                else if (attribute is ManagedObject)
                {
                    var managedObject:ManagedObject = attribute as ManagedObject;
                    deserializeIds(managedObject);
                }
                else if (attribute is ManagedMap)
                {
                    throw new Error("Managed map deserialization in context is currently not supported.");
                }
                else
                {
                    // Do nothing, other parts should not be counted in managed object context.
                }
            }
        }

        public function resetContext():void
        {
            _managedObjects = new Dictionary();
            _idCounter = 0;
        }

        public function deserialize(data: *, deserializator:IDeserializator, target:ManagedObject):*
        {
            resetContext();
            deserializator.deserializeData(data);
            target.deserialize(deserializator);
            deserializeIds(target);
        }
	}
}