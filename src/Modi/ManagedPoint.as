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
