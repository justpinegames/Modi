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
	
	public class ManagedMap implements IObservableCollection
	{
		public static var ALLOW_REMOVE:String = "AllowRemove";
		public static var WILL_REMOVE:String = "WillRemove";
		public static var HAS_REMOVED:String = "HasRemoved";
		public static var ALLOW_ADD:String = "AllowAdd";
		public static var WILL_ADD:String = "WillAdd";
		public static var HAS_ADDED:String = "HasAdded";
		
		private var _data:Dictionary;
		private var _observers:Dictionary;
		private var _xValues:Vector.<int>;
		private var _yValues:Vector.<int>;
		
		public function ManagedMap() 
		{
			_data = new Dictionary();
			
			_observers = new Dictionary();
			_observers[ALLOW_REMOVE] = new Array();
			_observers[WILL_REMOVE] = new Array();
			_observers[HAS_REMOVED] = new Array();
			_observers[ALLOW_ADD] = new Array();
			_observers[WILL_ADD] = new Array();
			_observers[HAS_ADDED] = new Array();
			
			_xValues = new Vector.<int>();
			_yValues = new Vector.<int>();
		}
		
		function registerObserver(event:String, callback:Function):void
		{
			if (_observers[event] == undefined)
			{
				throw new Error("Event " + event + " does not exists nor can it be tracked!");
			}
			
			_observers[event].push(new IObserver(event, callback));
		}
		
		function removeObserver(event:String, callback:Function):Boolean
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
		
		function allowRemove(object:ManagedObject, index:int):Boolean
		{
			return false;
		}
		
		function willRemove(object:ManagedObject, index:int):void
		{
			
		}
		
		function hasRemoved(object:ManagedObject, index:int):void
		{
			
		}
		
		function allowAdd(object:ManagedObject, index:int):Boolean
		{
			return false;
		}
		
		function willAdd(object:ManagedObject, index:int):void
		{
			
		}
		
		function hasAdded(object:ManagedObject, index:int):void
		{
			
		}
		
		public function setObjectAt(object:ManagedObject, x:int, y:int):void
		{
			var key:String = x + "x" + y;
			
			if (_data[key] == undefined)
			{
				
			}
			
			_data[x + "x" + y] = object;
			
			if (object != null)
			{
				_xValues.push(x);
				_xValues.sort(vectorSortBehaviour);
				_yValues.push(y);
				_yValues.sort(vectorSortBehaviour);
			}
			else
			{
				_xValues.splice(_xValues.indexOf(x), 1);
				_yValues.splice(_yValues.indexOf(y), 1);
			}
		}
		
		public function setObjectAtPoint(object:ManagedObject, position:Point):void
		{
			setObjectAt(object, position.x, position.y);
		}
		
		public function removeObjectAt(object:ManagedObject, x:int, y:int):void
		{
			setObjectAt(null, x, y);
		}
		
		public function removeObjectAtPoint(object:ManagedObject, position:Point):void
		{
			removeObjectAt(object, position.x, position.y);
		}
		
		public function getObjectAt(x:int, y:int):ManagedObject
		{
			return null;
		}
		
		public function getObjectAtPoint(position:Point):ManagedObject
		{
			return null;
		}
		
		public function get maximumX():int
		{
			return 0;
		}
		
		public function get maximumY():int
		{
			return 0;
		}
		
		public function get minimumX():int
		{
			return 0;
		}
		
		public function get minimumY():int
		{
			return 0;
		}
		
		public function get width():int
		{
			return 0;
		}
		
		public function get heigth():int
		{
			return 0;
		}
		
		final private function vectorSortBehaviour(a:Number, b:Number):int
		{
			return (a == b ? 0 : (a < b) ? -1 : 1);
		}
	}
}