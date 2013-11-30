package Modi
{
    public class ObjectDeserializator extends CommonDeserializator
    {
        override public function deserializeData(data:*):void
        {
            _data = data;
            _stack.push( { data:_data, context:SERIALIZATOR_STATE_OBJECT } );
            _ready = true;
        }
    }
}
