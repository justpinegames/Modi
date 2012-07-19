package Modi 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public interface IDeserializator 
	{
		
		function deserializeData(data:*):void;
		
		function readString(name:String):String;
		function readInt(name:String):int;
		function readUInt(name:String):uint;
		function readNumber(name:String):Number;
		function readBoolean(name:String):Boolean;
		function readPoint(name:String):Point;
		function readRectangle(name:String):Rectangle;
		function pushObject(name:String):String;
		function popObject():void;

	}
	
}