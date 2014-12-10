/*
 * This is free software; you can redistribute it and/or modify it under the
 * terms of MIT free software license as published by the Massachusetts
 * Institute of Technology.
 *
 * Copyright 2014. Pine Studio
 */

package Modi
{
    import flash.events.EventDispatcher;
    import flash.utils.getDefinitionByName;

    public class ManagedArray extends EventDispatcher implements ISerializableObject
	{
		private var _data:Vector.<ManagedObject>;
		private var _childType:String;
		
		public function ManagedArray() 
		{
			_data = new Vector.<ManagedObject>();
			
			_childType = "Modi.ManagedObject";
		}

        private function dispatchManagedArrayEvent(type:String, index:int, object:ManagedObject, oldObject:ManagedObject = null):void
        {
            var event:ManagedArrayEvent = new ManagedArrayEvent(type);
            event.owner = this;
            event.index = index;
            event.object = object;
            event.oldObject = oldObject;
            dispatchEvent(event);
        }

        public function push(object:ManagedObject):void
        {
            var index:int = _data.length;
            _data.push(object);
            dispatchManagedArrayEvent(ManagedArrayEvent.ADD, index, object);
        }

        public function pushUnsafe(object:ManagedObject):void
        {
            _data.push(object);
        }

		public function pushMultiple(array:Array):void
		{
			for each (var element:ManagedObject in array) { push(element); }
        }

        public function pushMultipleUnsafe(array:Array):void
        {
            for each (var element:ManagedObject in array) { pushUnsafe(element); }
        }

		public function pop():ManagedObject
		{
			var object:ManagedObject = null;
			var length:int = _data.length;
			
			if (length > 0)
			{
				object = _data[length - 1];

				if (!remove(object)) object = null;
			}
			
			return object;
		}

        public function popUnsafe():ManagedObject
        {
            var object:ManagedObject = null;
            var length:int = _data.length;

            if (length > 0)
            {
                object = _data[length - 1];
                removeUnsafe(object);
            }

            return object;
        }

        public function shift():ManagedObject
        {
            var object:ManagedObject = null;
            var length:int = _data.length;

            if (length > 0)
            {
                object = _data[0];

                if (!remove(object)) object = null;
            }

            return object;
        }

        public function shiftUnsafe():ManagedObject
        {
            var object:ManagedObject = null;
            var length:int = _data.length;

            if (length > 0)
            {
                object = _data[0];
                removeUnsafe(object);
            }

            return object;
        }

		public function remove(object:ManagedObject):Boolean
		{
			var index:int = _data.indexOf(object);
			if (index != -1)
			{
				_data.splice(index, 1);

                dispatchManagedArrayEvent(ManagedArrayEvent.REMOVE, index, object);
				
				return true;
			}
			
			return false;
		}

        public function removeUnsafe(object:ManagedObject):Boolean
        {
            var index:int = _data.indexOf(object);
            if (index != -1)
            {
                _data.splice(index, 1);
                return true;
            }

            return false;
        }

		public function splice(startIndex:int, deleteCount:int):Vector.<ManagedObject>
		{
			var splicedObjects:Vector.<ManagedObject> = new Vector.<ManagedObject>();
			
			if (startIndex < _data.length && (startIndex + deleteCount) <= _data.length)
			{
				while ((deleteCount--) > 0)
				{
                    var object:ManagedObject = _data[startIndex];
					if (remove(object)) splicedObjects.push(object);
					else                startIndex++;
				}
			}
			else
			{
				throw new RangeError("startIndex and deleteCount arguments specify an index to be deleted that's outside the ManagedArray's bounds.");
			}
			
			return splicedObjects;
		}

        public function spliceUnsafe(startIndex:int, deleteCount:int):Vector.<ManagedObject>
        {
            var splicedObjects:Vector.<ManagedObject> = new Vector.<ManagedObject>();

            if (startIndex < _data.length && (startIndex + deleteCount) <= _data.length)
            {
                var object:ManagedObject;

                while ((deleteCount--) > 0)
                {
                    object = _data[startIndex];
                    removeUnsafe(object);
                    splicedObjects.push(object);
                }
            }
            else
            {
                throw new RangeError("startIndex and deleteCount arguments specify an index to be deleted that's outside the ManagedArray's bounds.");
            }

            return splicedObjects;
        }

		public function replaceObject(oldObject:ManagedObject, newObject:ManagedObject):Boolean
		{
			var index:int = _data.indexOf(oldObject);
			if (index == -1) throw new Error("Object " + oldObject + " you are trying to replace is not stored in ManagedArray!");

            return replaceObjectAt(index, newObject);
		}

        public function replaceObjectUnsafe(oldObject:ManagedObject, newObject:ManagedObject):Boolean
        {
            var index:int = _data.indexOf(oldObject);
            if (index == -1) throw new Error("Object " + oldObject + " you are trying to replace is not stored in ManagedArray!");

            return replaceObjectAtUnsafe(index, newObject);
        }

		public function replaceObjectAt(index:int, newObject:ManagedObject):Boolean
		{
			if (index < 0 || index >= _data.length) throw new RangeError("Index out of bounds.");
			
			var oldObject:ManagedObject = _data[index];
			
			_data[index] = newObject;

            dispatchManagedArrayEvent(ManagedArrayEvent.REPLACE, index, newObject, oldObject);
			
			return true;
		}

        public function replaceObjectAtUnsafe(index:int, newObject:ManagedObject):Boolean
        {
            if (index < 0 || index >= _data.length) throw new RangeError("Index out of bounds.");

            _data[index] = newObject;

            return true;
        }
		
		public function indexOf(searchElement:ManagedObject, fromIndex:int = 0):int
		{
			return _data.indexOf(searchElement, fromIndex);
		}

        public function contains(element:ManagedObject):Boolean
        {
            return indexOf(element) != -1;
        }
		
		public function lastIndexOf(searchElement:ManagedObject, fromIndex:int = 0x7fffffff):int
		{
			return _data.lastIndexOf(searchElement, fromIndex);
		}
		
		public function objectAt(index:int):*
		{
			if (index < 0 || index >= _data.length) throw new RangeError("Index out of bounds.");
			return _data[index];
		}

        public function get last():* { return _data.length == 0 ? null : _data[_data.length - 1]; }

        public function get first():* { return _data.length == 0 ? null : _data[0]; }

        public function get length():int { return _data.length; }
		
		public override function toString():String { return _data.toString(); }
		
		public function set childType(type:String):void { _childType = type; }

		public function removeAllObjects():void
		{
			while (_data.length > 0) { pop(); }
        }

        public function removeAllObjectsUnsafe():void
        {
            while (_data.length > 0) { popUnsafe(); }
        }

		/* INTERFACE Modi.ISerializableObject */
		
		public function serialize(serializator:ISerializator):void 
		{
            // TODO: Remove length from serialization.
			var i:int = 0;
			serializator.writeInt("length", _data.length);
			for each (var object:* in _data) 
			{
                var type:String = object is ManagedObjectId ? "ManagedObjectId" : "ManagedObject";
				ManagedObject.writeUnindentified(i.toString(), object, type, serializator);
				i++;
			}
		}
		
		public function deserialize(deserializator:IDeserializator):void 
		{
			removeAllObjects();
			
			var length: int = deserializator.getCurrentLength();
				
			for (var i:int = 0; i < length; i++) 
			{
				var ManagedClass:Class = Class(getDefinitionByName(_childType) as Class);
				var object:ManagedObject = new ManagedClass();

                if (object is ManagedObjectId)
                {
                    object = new ManagedObjectId(deserializator.readString(i.toString()));
                }
                else
                {
                    deserializator.pushObject(i.toString())
                    object.deserialize(deserializator);
                    deserializator.popObject();
                }

				push(object);
			}
		}

        public function arrayCopy():Array
        {
            var array:Array = [];
            for (var i:int = 0; i < _data.length; i++) { array.push(_data[i]); }
            return array;
        }

        public function each(closure:Function):void
        {
            if (closure == null) throw new ArgumentError("Closure must not be null.");

            for (var i:int = 0; i < this.length; i++) { closure(_data[i]); }
        }

        public function clone():ManagedArray
        {
            var array:ManagedArray = new ManagedArray();
            array._childType = _childType;
            array._data = _data.concat();
            return array;
        }
    }
}