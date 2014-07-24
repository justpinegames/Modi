/*
 * This is free software; you can redistribute it and/or modify it under the
 * terms of MIT free software license as published by the Massachusetts
 * Institute of Technology.
 *
 * Copyright 2014. Pine Studio
 */

package Modi
{
    import flash.geom.Point;

    public class ManagedPoint extends ManagedObject
    {
        public static const ATTRIBUTES:Array = ["y", "x", ];
        public static const ATTRIBUTES_TYPES:Array = ["Number", "Number", ];

        public static const ATTRIBUTE_Y:String = "y";
        public static const ATTRIBUTE_X:String = "x";

        private var _y:Number;
        private var _x:Number;

        public function ManagedPoint()
        {
            this.registerAttributes(ATTRIBUTES, ATTRIBUTES_TYPES);

            _x = 0;
            _y = 0;
        }

        public function set y(y:Number):void { dispatchChangeEvent(ATTRIBUTE_Y, _y, _y = y); }
        public function set YDirectUnsafe(y:Number):void { _y = y; }
        public function get y():Number { return _y; }

        public function set x(x:Number):void { dispatchChangeEvent(ATTRIBUTE_X, _x, _x = x); }
        public function set XDirectUnsafe(x:Number):void { _x = x; }
        public function get x():Number { return _x; }

        public function get point():Point { return new Point(_x, _y); }

        public function equals(point:ManagedPoint):Boolean
        {
            return (_x == point.x && _y == point.y);
        }

        public function toPoint():Point
        {
            return new Point(_x, _y);
        }

        public function normalize(thickness:Number = 1):void
        {
            var point:Point = new Point(_x,  _y);
            point.normalize(thickness);

            this.x = point.x;
            this.y = point.y;
        }

        public static function distance(firstPoint:ManagedPoint, secondPoint:ManagedPoint):Number
        {
            var firstFlashPoint:Point = new Point(firstPoint.x, firstPoint.y);
            var secondFlashPoint:Point = new Point(secondPoint.x, secondPoint.y);
            var distance:Number = Point.distance(firstFlashPoint, secondFlashPoint);

            return distance;
        }

        override public function serialize(serializator:ISerializator):void
        {
            serializator.writeNumber("0", _x);
            serializator.writeNumber("1", _y);
        }

        override public function deserialize(deserializator:IDeserializator):void
        {
            _x = deserializator.readNumber("0");
            _y = deserializator.readNumber("1");
        }
    }
}