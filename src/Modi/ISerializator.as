package Modi 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public interface ISerializator 
	{
		
		function writeString(name:String, object:String):void;
		function writeInt(name:String, object:int):void;
		function writeUInt(name:String, object:int):void;
		function writeNumber(name:String, object:Number):void;
		function writeBoolean(name:String, object:Boolean):void;
		function writePoint(name:String, object:Point):void;
		function writeRectangle(name:String, object:Rectangle):void;
		function pushObject(name:String, className:String):void;
		function popObject():void;
		
		function serializeData():*;
	
	}
	
}