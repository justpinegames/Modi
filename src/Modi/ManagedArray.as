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
    import flash.utils.getDefinitionByName;

    public class ManagedArray implements IObservableArray, ISerializableObject
	{
		private var _data:Vector.<ManagedObject>;
		private var _childType:String;
		private var _observers:Dictionary;
		
		public function ManagedArray() 
		{
			_data = new Vector.<ManagedObject>();
			
			_childType = "Modi.ManagedObject";
			
			_observers = new Dictionary();
			_observers[ManagedArrayEvent.ALLOW_REMOVE] = new Vector.<IObserver>();
			_observers[ManagedArrayEvent.WILL_REMOVE] = new Vector.<IObserver>();
			_observers[ManagedArrayEvent.WAS_REMOVED] = new Vector.<IObserver>();
			_observers[ManagedArrayEvent.ALLOW_ADD] = new Vector.<IObserver>();
			_observers[ManagedArrayEvent.WILL_ADD] = new Vector.<IObserver>();
			_observers[ManagedArrayEvent.WAS_ADDED] = new Vector.<IObserver>();
			_observers[ManagedArrayEvent.ALLOW_REPLACE] = new Vector.<IObserver>();
			_observers[ManagedArrayEvent.WILL_REPLACE] = new Vector.<IObserver>();
			_observers[ManagedArrayEvent.WAS_REPLACED] = new Vector.<IObserver>();
		}
		
		public function push(object:ManagedObject):void
		{
			var index:int = _data.indexOf(object);
			
			if (!allowAdd(object, index))
			{
				return;
			}
			
			willAdd(object, index);
			
			_data.push(object);
			
			wasAdded(object, index);
		}
		
		public function pushMultiple(array:Array):void
		{
			for each (var element:ManagedObject in array)
			{
				this.push(element);
			}
		}
		
		public function pop():ManagedObject
		{
			var object:ManagedObject = null;
			var length:int = _data.length;
			
			if (length > 0)
			{
				object = _data[length - 1];
				
				if (!remove(object))
				{
					object = null;
				}
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

                if (!remove(object))
                {
                    object = null;
                }
            }

            return object;
        }

		public function remove(object:ManagedObject):Boolean
		{
			var index:int = _data.indexOf(object);
			if (index != -1)
			{
				if (!allowRemove(object, index))
				{
					return false;
				}
				
				willRemove(object, index);
				
				_data.splice(index, 1);
				
				wasRemoved(object, index);
				
				return true;
			}
			
			return false;
		}
		
		public function splice(startIndex:int, deleteCount:int):Vector.<ManagedObject>
		{
			var splicedObjects:Vector.<ManagedObject> = new Vector.<ManagedObject>();
			
			if (startIndex < _data.length && (startIndex + deleteCount) <= _data.length)
			{
				var object:ManagedObject;
				
				while (deleteCount > 0)
				{
					object = _data[startIndex];
					if (remove(object))
					{
						splicedObjects.push(object);
					}
					else
					{
						startIndex++;
					}
					
					deleteCount--;
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
			if (index == -1)
			{
				throw new Error("Object " + oldObject + " you are trying to replace is not stored in ManagedArray!");
			}
			
			return replaceObjectAt(index, newObject);
		}
		
		public function replaceObjectAt(index:int, newObject:ManagedObject):Boolean
		{
			if (index < 0 || index >= _data.length)
			{
				throw new RangeError("Index out of bounds.");
			}
			
			var oldObject:ManagedObject = _data[index];
			
			if (!allowReplace(oldObject, newObject, index))
			{
				return false;
			}
			
			willReplace(oldObject, newObject, index);
			
			_data[index] = newObject;
			
			wasReplaced(oldObject, newObject, index);
			
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
			if (index < 0 || index >= _data.length)
			{
				throw new RangeError("Index out of bounds.");
			}
			
			return _data[index];
		}

        public function get last():*
        {
            return getLastObject();
        }

        public function get first():*
        {
            if (_data.length == 0)
            {
                return null;
            }

            return _data[0];
        }

        public function getLastObject():*
        {
            if (_data.length == 0)
            {
                return null;
            }

            return _data[_data.length - 1];
        }

		public function get length():int
		{
			return _data.length;
		}
		
		public function toString():String
		{
			return _data.toString();
		}
		
		public function set childType(type:String):void
		{
			_childType = type;
		}
		
		public function addEventListener(event:String, listener:Function):void
		{
			if (_observers[event] === undefined)
			{
				throw new Error("Event " + event + " does not exist nor can it be tracked!");
			}
			
			_observers[event].push(new IObserver(event, listener));
		}
		
		public function removeEventListener(event:String, listener:Function):Boolean
		{
			if (_observers[event] === undefined)
			{
				throw new Error("Event " + event + " does not exist nor can it be tracked!");
			}
			
			var length:int = _observers[event].length;
			var observer:IObserver;
			
			for (var i:int = 0; i < length; i++)
			{
				observer = _observers[event][i];
				if (observer.listener == listener)
				{
					_observers[event].splice(i, 1);
					return true;
				}
			}
			
			return false;
		}
		
		public function allowRemove(object:ManagedObject, index:int):Boolean
		{
			/// Ako ne postoje observeri na ovaj event, odma vraca true
			if (_observers[ManagedArrayEvent.ALLOW_REMOVE].length == 0)
			{
				return true;
			}
			
			var targetObservers:Vector.<IObserver> = _observers[ManagedArrayEvent.ALLOW_REMOVE];
			var length:int = targetObservers.length;
			var observer:IObserver;
			var i:int;
			
			for (i = 0; i < length; i++)
			{
				observer = targetObservers[i];				
				var observerEvent:ManagedArrayEvent = new ManagedArrayEvent(this, object, ManagedArrayEvent.ALLOW_REMOVE, index);
				var allowed:Boolean = observer.listener(observerEvent);
				
				/// Ako ijedan observer ne dozvoljava, vraca se false
				if (!allowed)
				{
					return false;
				}
			}
			
			/// Ako su svi observeri vratili true
			return true;
		}
		
		public function willRemove(object:ManagedObject, index:int):void
		{
			/// Ako ne postoje observeri na ovaj event, izlazi van jer nema koga obavijestiti
			if (_observers[ManagedArrayEvent.WILL_REMOVE].length == 0)
			{
				return;
			}
			
			var targetObservers:Vector.<IObserver> = _observers[ManagedArrayEvent.WILL_REMOVE];
			var length:int = targetObservers.length;
			var observer:IObserver;
			var i:int;
			
			for (i = 0; i < length; i++)
			{
				observer = targetObservers[i];
				var observerEvent:ManagedArrayEvent = new ManagedArrayEvent(this, object, ManagedArrayEvent.WILL_REMOVE, index);
				observer.listener(observerEvent);
			}
		}
		
		public function wasRemoved(object:ManagedObject, index:int):void
		{
			/// Ako ne postoje observeri na ovaj event, izlazi van jer nema koga obavijestiti
			if (_observers[ManagedArrayEvent.WAS_REMOVED].length == 0)
			{
				return;
			}
			
			var targetObservers:Vector.<IObserver> = _observers[ManagedArrayEvent.WAS_REMOVED];
			var length:int = targetObservers.length;
			var observer:IObserver;
			var i:int;
			
			for (i = 0; i < length; i++)
			{
				observer = targetObservers[i];				
				var observerEvent:ManagedArrayEvent = new ManagedArrayEvent(this, object, ManagedArrayEvent.WAS_REMOVED, index);
				observer.listener(observerEvent);
			}
		}
		
		public function allowAdd(object:ManagedObject, index:int):Boolean
		{
			/// Ako ne postoje observeri na ovaj event, odma vraca true
			if (_observers[ManagedArrayEvent.ALLOW_ADD].length == 0)
			{
				return true;
			}
			
			var targetObservers:Vector.<IObserver> = _observers[ManagedArrayEvent.ALLOW_ADD];
			var length:int = targetObservers.length;
			var observer:IObserver;
			var i:int;
			
			for (i = 0; i < length; i++)
			{
				observer = targetObservers[i];				
				var observerEvent:ManagedArrayEvent = new ManagedArrayEvent(this, object, ManagedArrayEvent.ALLOW_ADD, index);
				var allowed:Boolean = observer.listener(observerEvent);
				
				/// Ako ijedan observer ne dozvoljava, vraca se false
				if (!allowed)
				{
					return false;
				}
			}
			
			/// Ako su svi observeri vratili true
			return true;
		}
		
		public function willAdd(object:ManagedObject, index:int):void
		{
			/// Ako ne postoje observeri na ovaj event, izlazi van jer nema koga obavijestiti
			if (_observers[ManagedArrayEvent.WILL_ADD].length == 0)
			{
				return;
			}
			
			var targetObservers:Vector.<IObserver> = _observers[ManagedArrayEvent.WILL_ADD];
			var length:int = targetObservers.length;
			var observer:IObserver;
			var i:int;
			
			for (i = 0; i < length; i++)
			{
				observer = targetObservers[i];
				var observerEvent:ManagedArrayEvent = new ManagedArrayEvent(this, object, ManagedArrayEvent.WILL_ADD, index);
				observer.listener(observerEvent);
			}
		}
		
		public function wasAdded(object:ManagedObject, index:int):void
		{
			/// Ako ne postoje observeri na ovaj event, izlazi van jer nema koga obavijestiti
			if (_observers[ManagedArrayEvent.WAS_ADDED].length == 0)
			{
				return;
			}
			
			var targetObservers:Vector.<IObserver> = _observers[ManagedArrayEvent.WAS_ADDED];
			var length:int = targetObservers.length;
			var observer:IObserver;
			var i:int;
			
			for (i = 0; i < length; i++)
			{
				observer = targetObservers[i];				
				var observerEvent:ManagedArrayEvent = new ManagedArrayEvent(this, object, ManagedArrayEvent.WAS_ADDED, index);
				observer.listener(observerEvent);
			}
		}
		
		public function allowReplace(oldObject:ManagedObject, newObject:ManagedObject, index:int):Boolean
		{
			/// Ako ne postoje observeri na ovaj event, odma vraca true
			if (_observers[ManagedArrayEvent.ALLOW_REPLACE].length == 0)
			{
				return true;
			}
			
			var targetObservers:Vector.<IObserver> = _observers[ManagedArrayEvent.ALLOW_REPLACE];
			var length:int = targetObservers.length;
			var observer:IObserver;
			var i:int;
			
			for (i = 0; i < length; i++)
			{
				observer = targetObservers[i];				
				var observerEvent:ManagedArrayEvent = new ManagedArrayEvent(this, newObject, ManagedArrayEvent.ALLOW_REPLACE, index, oldObject);
				var allowed:Boolean = observer.listener(observerEvent);
				
				/// Ako ijedan observer ne dozvoljava, vraca se false
				if (!allowed)
				{
					return false;
				}
			}
			
			/// Ako su svi observeri vratili true
			return true;
		}
		
		public function willReplace(oldObject:ManagedObject, newObject:ManagedObject, index:int):void
		{
			/// Ako ne postoje observeri na ovaj event, izlazi van jer nema koga obavijestiti
			if (_observers[ManagedArrayEvent.WILL_REPLACE].length == 0)
			{
				return;
			}
			
			var targetObservers:Vector.<IObserver> = _observers[ManagedArrayEvent.WILL_REPLACE];
			var length:int = targetObservers.length;
			var observer:IObserver;
			var i:int;
			
			for (i = 0; i < length; i++)
			{
				observer = targetObservers[i];
				var observerEvent:ManagedArrayEvent = new ManagedArrayEvent(this, newObject, ManagedArrayEvent.WILL_REPLACE, index, oldObject);
				observer.listener(observerEvent);
			}
		}
		
		public function wasReplaced(oldObject:ManagedObject, newObject:ManagedObject, index:int):void
		{
			/// Ako ne postoje observeri na ovaj event, izlazi van jer nema koga obavijestiti
			if (_observers[ManagedArrayEvent.WAS_REPLACED].length == 0)
			{
				return;
			}
			
			var targetObservers:Vector.<IObserver> = _observers[ManagedArrayEvent.WAS_REPLACED];
			var length:int = targetObservers.length;
			var observer:IObserver;
			var i:int;
			
			for (i = 0; i < length; i++)
			{
				observer = targetObservers[i];				
				var observerEvent:ManagedArrayEvent = new ManagedArrayEvent(this, newObject, ManagedArrayEvent.WAS_REPLACED, index, oldObject);
				observer.listener(observerEvent);
			}
		}
		
		
		public function removeAllObjects():void
		{
			while (_data.length > 0) 
			{
				this.pop();
			}
		}
		
		/* INTERFACE Modi.ISerializableObject */
		
		public function serialize(serializator:ISerializator):void 
		{
            // TODO: Remove length from serialization.
			var i:int = 0;
			serializator.writeInt("length", _data.length);
			for each (var object:* in _data) 
			{
				ManagedObject.writeUnindentified(i.toString(), object, "ManagedObject", serializator);
				i++;
			}
			
		}
		
		public function deserialize(deserializator:IDeserializator):void 
		{
			this.removeAllObjects();
			
			var length: int = deserializator.getCurrentLength();
				
			for (var i:int = 0; i < length; i++) 
			{
				var ManagedClass:Class = Class(getDefinitionByName(_childType) as Class);
				var object:ManagedObject = new ManagedClass();
				deserializator.pushObject(i.toString())
				object.deserialize(deserializator);
				deserializator.popObject();
				
				this.push(object);
			}
			
		}

        public function arrayCopy():Array
        {
            var array:Array = [];

            for (var i:int = 0; i < _data.length; i++)
            {
                array.push(_data[i]);
            }

            return array;
        }

        public function each(closure:Function):void
        {
            if (closure == null) throw new ArgumentError("Closure must not be null.");

            for (var i:int = 0; i < this.length; i++)
            {
                closure(this.objectAt(i));
            }
        }
	}
}