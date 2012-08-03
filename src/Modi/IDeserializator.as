package Modi 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public interface IDeserializator 
	{
		
		function get ready():Boolean;
		
		function deserializeData(data:*):void;
		
		function readString(name:String):String;
		function readInt(name:String):int;
		function readUInt(name:String):uint;
		function readNumber(name:String):Number;
		function readBoolean(name:String):Boolean;
		function pushObject(name:String):void;
		function popObject():void;
		function pushArray(name:String):void;
		function popArray():void;
		function pushMap(name:String):void;
		function popMap():void;

		function getCurrentLength():int;
		
	}
	
}