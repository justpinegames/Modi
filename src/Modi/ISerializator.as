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
		function pushObject(name:String):void;
		function popObject():void;
		function pushArray(name:String):void;
		function popArray():void;
		function pushMap(name:String):void;
		function popMap():void;
		
		function serializeData():*;
	
	}
	
}