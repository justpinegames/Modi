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
	
	public class ManagedArray implements IObservableArray, ISerializableObject
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
		
		private var _data:Vector.<ManagedObject>;
		private var _observers:Dictionary;
		
		public function ManagedArray() 
		{
			_data = new Vector.<ManagedObject>();
			
			_observers = new Dictionary();
			_observers[ALLOW_REMOVE] = new Array();
			_observers[WILL_REMOVE] = new Array();
			_observers[WAS_REMOVED] = new Array();
			_observers[ALLOW_ADD] = new Array();
			_observers[WILL_ADD] = new Array();
			_observers[WAS_ADDED] = new Array();
			_observers[ALLOW_REPLACE] = new Array();
			_observers[WILL_REPLACE] = new Array();
			_observers[WAS_REPLACED] = new Array();
		}
		
		public function push(object:ManagedObject):void
		{
			var index:int = _data.indexOf(object);
			
			if (!allowAdd(object, index))
			{
				return;
			}
			
			willRemove(object, index);
			
			_data.push(object);
			
			wasRemoved(object, index);
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
		
		public function get length():int
		{
			return _data.length;
		}
		
		public function toString():String
		{
			return _data.toString();
		}
		
		public function registerObserver(event:String, callback:Function):void
		{
			if (_observers[event] == undefined)
			{
				throw new Error("Event " + event + " does not exists nor can it be tracked!");
			}
			
			_observers[event].push(new IObserver(event, callback));
		}
		
		public function removeObserver(event:String, callback:Function):Boolean
		{
			if (_observers[event] == undefined)
			{
				throw new Error("Event " + event + " does not exists nor can it be tracked!");
			}
			
			var length:int = _observers[event].length;
			var observer:IObserver;
			
			for (var i:int = 0; i < length; i++)
			{
				observer = _observers[event][i];
				if (observer.callback == callback)
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
			if (_observers[ALLOW_REMOVE].length == 0)
			{
				return true;
			}
			
			var targetObservers:Array = _observers[ALLOW_REMOVE];
			var length:int = targetObservers.length;
			var observer:IObserver;
			var i:int;
			
			for (i = 0; i < length; i++)
			{
				observer = targetObservers[i];				
				var observerEvent:ArrayObserverEvent = new ArrayObserverEvent(object, ALLOW_REMOVE, index);
				var allowed:Boolean = observer.callback(observerEvent);
				
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
			if (_observers[WILL_REMOVE].length == 0)
			{
				return;
			}
			
			var targetObservers:Array = _observers[WILL_REMOVE];
			var length:int = targetObservers.length;
			var observer:IObserver;
			var i:int;
			
			for (i = 0; i < length; i++)
			{
				observer = targetObservers[i];
				var observerEvent:ArrayObserverEvent = new ArrayObserverEvent(object, WILL_REMOVE, index);
				observer.callback(observerEvent);
			}
		}
		
		public function wasRemoved(object:ManagedObject, index:int):void
		{
			/// Ako ne postoje observeri na ovaj event, izlazi van jer nema koga obavijestiti
			if (_observers[WAS_REMOVED].length == 0)
			{
				return;
			}
			
			var targetObservers:Array = _observers[WAS_REMOVED];
			var length:int = targetObservers.length;
			var observer:IObserver;
			var i:int;
			
			for (i = 0; i < length; i++)
			{
				observer = targetObservers[i];				
				var observerEvent:ArrayObserverEvent = new ArrayObserverEvent(object, WAS_REMOVED, index);
				observer.callback(observerEvent);
			}
		}
		
		public function allowAdd(object:ManagedObject, index:int):Boolean
		{
			/// Ako ne postoje observeri na ovaj event, odma vraca true
			if (_observers[ALLOW_ADD].length == 0)
			{
				return true;
			}
			
			var targetObservers:Array = _observers[ALLOW_ADD];
			var length:int = targetObservers.length;
			var observer:IObserver;
			var i:int;
			
			for (i = 0; i < length; i++)
			{
				observer = targetObservers[i];				
				var observerEvent:ArrayObserverEvent = new ArrayObserverEvent(object, ALLOW_ADD, index);
				var allowed:Boolean = observer.callback(observerEvent);
				
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
			if (_observers[WILL_ADD].length == 0)
			{
				return;
			}
			
			var targetObservers:Array = _observers[WILL_ADD];
			var length:int = targetObservers.length;
			var observer:IObserver;
			var i:int;
			
			for (i = 0; i < length; i++)
			{
				observer = targetObservers[i];
				var observerEvent:ArrayObserverEvent = new ArrayObserverEvent(object, WILL_ADD, index);
				observer.callback(observerEvent);
			}
		}
		
		public function wasAdded(object:ManagedObject, index:int):void
		{
			/// Ako ne postoje observeri na ovaj event, izlazi van jer nema koga obavijestiti
			if (_observers[WAS_ADDED].length == 0)
			{
				return;
			}
			
			var targetObservers:Array = _observers[WAS_ADDED];
			var length:int = targetObservers.length;
			var observer:IObserver;
			var i:int;
			
			for (i = 0; i < length; i++)
			{
				observer = targetObservers[i];				
				var observerEvent:ArrayObserverEvent = new ArrayObserverEvent(object, WAS_ADDED, index);
				observer.callback(observerEvent);
			}
		}
		
		public function allowReplace(oldObject:ManagedObject, newObject:ManagedObject, index:int):Boolean
		{
			/// Ako ne postoje observeri na ovaj event, odma vraca true
			if (_observers[ALLOW_REPLACE].length == 0)
			{
				return true;
			}
			
			var targetObservers:Array = _observers[ALLOW_REPLACE];
			var length:int = targetObservers.length;
			var observer:IObserver;
			var i:int;
			
			for (i = 0; i < length; i++)
			{
				observer = targetObservers[i];				
				var observerEvent:ArrayObserverEvent = new ArrayObserverEvent(newObject, ALLOW_REPLACE, index, oldObject);
				var allowed:Boolean = observer.callback(observerEvent);
				
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
			if (_observers[WILL_REPLACE].length == 0)
			{
				return;
			}
			
			var targetObservers:Array = _observers[WILL_REPLACE];
			var length:int = targetObservers.length;
			var observer:IObserver;
			var i:int;
			
			for (i = 0; i < length; i++)
			{
				observer = targetObservers[i];
				var observerEvent:ArrayObserverEvent = new ArrayObserverEvent(newObject, WILL_REPLACE, index, oldObject);
				observer.callback(observerEvent);
			}
		}
		
		public function wasReplaced(oldObject:ManagedObject, newObject:ManagedObject, index:int):void
		{
			/// Ako ne postoje observeri na ovaj event, izlazi van jer nema koga obavijestiti
			if (_observers[WAS_REPLACED].length == 0)
			{
				return;
			}
			
			var targetObservers:Array = _observers[WAS_REPLACED];
			var length:int = targetObservers.length;
			var observer:IObserver;
			var i:int;
			
			for (i = 0; i < length; i++)
			{
				observer = targetObservers[i];				
				var observerEvent:ArrayObserverEvent = new ArrayObserverEvent(newObject, WAS_REPLACED, index, oldObject);
				observer.callback(observerEvent);
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
			
			var length: int = 0;//deserializator.getLength();
				
			for (var i:int = 0; i < length; i++) 
			{
				var object:* = ManagedObject.readUnindentified(i.toString(), this, "ManagedObject", deserializator);
				this.push(object);
			}
			
		}
		
		
	}
}