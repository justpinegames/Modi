/*
 * This is free software; you can redistribute it and/or modify it under the
 * terms of MIT free software license as published by the Massachusetts
 * Institute of Technology.
 *
 * Copyright 2012. Vjekoslav Krajacic, Tomislav Podhraski
 */

package Modi
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	public class ManagedMap implements IObservableMap
	{
		public static var ALLOW_CHANGE:String = "AllowChange";
		public static var WILL_CHANGE:String = "WillChange";
		public static var WAS_CHANGED:String = "WasChanged";
		
		private var _data:Dictionary;
		private var _childType:String;
		private var _observers:Dictionary;
		private var _xValues:Vector.<int>;
		private var _yValues:Vector.<int>;
		
		public function ManagedMap() 
		{
			_data = new Dictionary();
			
			_childType = "Modi.ManagedObject";
			
			_observers = new Dictionary();
			_observers[ALLOW_CHANGE] = new Array();
			_observers[WILL_CHANGE] = new Array();
			_observers[WAS_CHANGED] = new Array();
			
			_xValues = new Vector.<int>();
			_yValues = new Vector.<int>();
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
		
		public function allowChange(oldObject:ManagedObject, newObject:ManagedObject, x:int, y:int):Boolean
		{
			/// Ako ne postoje observeri na ovaj event, odma vraca true
			if (_observers[ALLOW_CHANGE].length == 0)
			{
				return true;
			}
			
			var targetObservers:Array = _observers[ALLOW_CHANGE];
			var length:int = targetObservers.length;
			var observer:IObserver;
			var i:int;
			
			for (i = 0; i < length; i++)
			{
				observer = targetObservers[i];				
				var observerEvent:MapObserverEvent = new MapObserverEvent(oldObject,newObject, ALLOW_CHANGE, x, y);
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
		
		public function willChange(oldObject:ManagedObject, newObject:ManagedObject, x:int, y:int):void
		{
			/// Ako ne postoje observeri na ovaj event, izlazi van jer nema koga obavijestiti
			if (_observers[WILL_CHANGE].length == 0)
			{
				return;
			}
			
			var targetObservers:Array = _observers[WILL_CHANGE];
			var length:int = targetObservers.length;
			var observer:IObserver;
			var i:int;
			
			for (i = 0; i < length; i++)
			{
				observer = targetObservers[i];
				var observerEvent:MapObserverEvent = new MapObserverEvent(oldObject,newObject, ALLOW_CHANGE, x, y);
				observer.callback(observerEvent);
			}
		}
		
		public function wasChanged(oldObject:ManagedObject, newObject:ManagedObject, x:int, y:int):void
		{
			/// Ako ne postoje observeri na ovaj event, izlazi van jer nema koga obavijestiti
			if (_observers[WAS_CHANGED].length == 0)
			{
				return;
			}
			
			var targetObservers:Array = _observers[WAS_CHANGED];
			var length:int = targetObservers.length;
			var observer:IObserver;
			var i:int;
			
			for (i = 0; i < length; i++)
			{
				observer = targetObservers[i];				
				var observerEvent:MapObserverEvent = new MapObserverEvent(oldObject,newObject, ALLOW_CHANGE, x, y);
				observer.callback(observerEvent);
			}
		}
		
		public function setObjectAt(x:int, y:int, object:ManagedObject):Boolean
		{
			var key:String = x + "x" + y;
			var oldObject:ManagedObject = null;
			
			if (_data[key] != undefined)
			{
				oldObject = _data[key];
			}
			
			if (!allowChange(oldObject, object, x, y))
			{
				return false;
			}
			
			willChange(oldObject, object, x, y);
			
			_data[x + "x" + y] = object;
			
			wasChanged(oldObject, object, x, y);
			
			if (oldObject != null)
			{
				_xValues.splice(_xValues.indexOf(x), 1);
				_yValues.splice(_yValues.indexOf(y), 1);
			}
			
			if (object != null)
			{
				_xValues.push(x);
				_xValues.sort(vectorSortBehaviour);
				_yValues.push(y);
				_yValues.sort(vectorSortBehaviour);
			}
			
			return true;
		}
		
		public function setObjectAtPoint(position:Point, object:ManagedObject):Boolean
		{
			return setObjectAt(position.x, position.y, object);
		}
		
		public function removeObjectAt(x:int, y:int):Boolean
		{
			return setObjectAt(x, y, null);
		}
		
		public function removeObjectAtPoint(position:Point):Boolean
		{
			return removeObjectAt(position.x, position.y);
		}
		
		public function getObjectAt(x:int, y:int):ManagedObject
		{
			var object:ManagedObject = null;
			var key:String = x + "x" + y;
			
			if (_data[key] != undefined)
			{
				object = _data[key];
			}
			
			return object;
		}
		
		public function getObjectAtPoint(position:Point):ManagedObject
		{
			return getObjectAt(position.x, position.y);
		}
		
		public function get maximumX():int
		{
			var length:int = _xValues.length;
			
			if (length > 0)
			{
				return _xValues[length - 1];
			}
			
			return 0;
		}
		
		public function get maximumY():int
		{
			var length:int = _yValues.length;
			
			if (length > 0)
			{
				return _yValues[length - 1];
			}
			
			return 0;
		}
		
		public function get minimumX():int
		{
			if (_xValues.length > 0)
			{
				return _xValues[0];
			}
			
			return 0;
		}
		
		public function get minimumY():int
		{
			if (_yValues.length > 0)
			{
				return _yValues[0];
			}
			
			return 0;
		}
		
		public function get width():int
		{
			var length:int = _xValues.length;
			
			if (length > 0)
			{
				return (_xValues[length - 1] - _xValues[0]);
			}
			
			return 0;
		}
		
		public function get heigth():int
		{
			var length:int = _yValues.length;
			
			if (length > 0)
			{
				return (_yValues[length - 1] - _yValues[0]);
			}
			
			return 0;
		}
		
		public function set childType(type:String):void
		{
			_childType = type;
		}
		
		final private function vectorSortBehaviour(a:Number, b:Number):int
		{
			return (a == b ? 0 : (a < b) ? -1 : 1);
		}
		
		/// deserialize, prvo treba sve removati
	}
}