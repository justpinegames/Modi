package Modi 
{
	
	
	public interface ISerializableObject 
	{
		function serialize(serializator:ISerializator):void; 
		function deserialize(deserializator:IDeserializator):void;
	}
	
}