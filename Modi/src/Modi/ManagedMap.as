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
    import flash.geom.Point;
    import flash.utils.Dictionary;

    public class ManagedMap extends EventDispatcher
	{
		private var _data:Dictionary;
		private var _childType:String;
		private var _xValues:Vector.<int>;
		private var _yValues:Vector.<int>;
		
		public function ManagedMap() 
		{
			_data = new Dictionary();
			
			_childType = "Modi.ManagedObject";
			
			_xValues = new Vector.<int>();
			_yValues = new Vector.<int>();
		}

		public function setObjectAt(x:int, y:int, object:ManagedObject):void
		{
			var key:String = x + "x" + y;
			var oldObject:ManagedObject = null;

			if (_data[key] !== undefined) oldObject = _data[key];

			_data[key] = object;

            var event:ManagedMapEvent = new ManagedMapEvent(ManagedMapEvent.CHANGE);
            event.owner = this;
            event.oldObject = oldObject;
            event.newObject = object;
            event.x = x;
            event.y = y;
            dispatchEvent(event);

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
		}

		public function setObjectAtPoint(point:Point, object:ManagedObject):void
		{
			setObjectAt(point.x, point.y, object);
		}

		public function removeObjectAt(x:int, y:int):void
		{
			setObjectAt(x, y, null);
		}

		public function removeObjectAtPoint(point:Point):void
		{
			removeObjectAt(point.x, point.y);
		}

		public function getObjectAt(x:int, y:int):ManagedObject
		{
			var object:ManagedObject = null;
			var key:String = x + "x" + y;

			if (_data[key] !== undefined) object = _data[key];

			return object;
		}

		public function getObjectAtPoint(position:Point):ManagedObject
		{
			return getObjectAt(position.x, position.y);
		}

		public function get maximumX():int { return _xValues.length > 0 ? _xValues[_xValues.length - 1] : 0; }
        public function get maximumY():int { return _yValues.length > 0 ? _yValues[_yValues.length - 1] : 0; }

        public function get minimumX():int { return _xValues.length > 0 ? _xValues[0] : 0; }
		public function get minimumY():int { return _yValues.length > 0 ? _yValues[0] : 0; }

		public function get width():int { return _xValues.length > 0 ? _xValues[_xValues.length - 1] - _xValues[0]: 0; }
        public function get heigth():int { return _yValues.length > 0 ? _yValues[_yValues.length - 1] - _yValues[0] : 0; }

		public function set childType(type:String):void { _childType = type; }

		private final function vectorSortBehaviour(a:Number, b:Number):int
		{
			return (a == b ? 0 : (a < b) ? -1 : 1);
		}

        // TODO: Deserialize.
	}
}