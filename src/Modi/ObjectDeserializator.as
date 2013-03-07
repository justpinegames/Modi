/**
 * Created with IntelliJ IDEA.
 * User: Tomislav
 * Date: 7.3.13.
 * Time: 15:14
 * To change this template use File | Settings | File Templates.
 */
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
