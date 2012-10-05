package Modi
{

    import flash.utils.ByteArray;

    public class AMFSerializator extends CommonSerializator
    {
        override public function serializeData():*
        {
            var finalValue:* = this.stackTop();

            var bytes:ByteArray = new ByteArray();
            bytes.writeObject(finalValue);

            return bytes;
        }
    }
}
