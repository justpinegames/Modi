package Modi {
    import flash.geom.Point;

    public class ManagedPoint extends ManagedObject
    {
        private var _point:Point;

        public function ManagedPoint()
        {
            _point = new Point();

        }

        public function get point():Point
        {
            return _point;
        }

        public function get x():Number
        {
            return _point.x;
        }

        public function get y():Number
        {
            return _point.y;
        }

        /// TODO: Fixat da se omoguci pracenje kad se x i y promjenje.
        public function set x(value:Number):void
        {
            _point.x = value;
        }

        public function set y(value:Number):void
        {
            _point.y = value;
        }

        public function equals(point:ManagedPoint):Boolean
        {
            return (this.x == point.x && this.y == point.y);
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
            serializator.writeNumber("0", _point.x);
            serializator.writeNumber("1", _point.y);
        }

        override public function deserialize(deserializator:IDeserializator):void
        {
            _point.x = deserializator.readNumber("0");
            _point.y = deserializator.readNumber("1");
        }

    }
}
