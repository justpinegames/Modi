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
        }

        public function set y(y:Number):void
        {
            if (!this.allowChange(ATTRIBUTE_Y, this._y, y))
            {
                return;
            }

            this.willChange(ATTRIBUTE_Y, this._y, y);

            var oldState:Number = this._y;

            this._y = y;

            this.wasChanged(ATTRIBUTE_Y, oldState, y);
        }

        public function get y():Number
        {
            return this._y;
        }

        public function set YDirectUnsafe(y:Number):void
        {
            this._y = y;
        }

        public function set x(x:Number):void
        {
            if (!this.allowChange(ATTRIBUTE_X, this._x, x))
            {
                return;
            }

            this.willChange(ATTRIBUTE_X, this._x, x);

            var oldState:Number = this._x;

            this._x = x;

            this.wasChanged(ATTRIBUTE_X, oldState, x);
        }

        public function get x():Number
        {
            return this._x;
        }

        public function get point():Point
        {
            return new Point(_x, _y);
        }

        public function set XDirectUnsafe(x:Number):void
        {
            this._x = x;
        }

        public function equals(point:ManagedPoint):Boolean
        {
            return (_x == point.x && _y == point.y);
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