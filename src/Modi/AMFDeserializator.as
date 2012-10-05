package Modi
{

    import flash.utils.ByteArray;

    public class AMFDeserializator extends CommonDeserializator
    {
        override public function deserializeData(data:*):void
        {
            _data = (data as ByteArray).readObject();
            _stack.push( { data:_data, context:SERIALIZATOR_STATE_OBJECT } );
            _ready = true;
        }
    }
}
