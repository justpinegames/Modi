/*
 * This is free software; you can redistribute it and/or modify it under the
 * terms of MIT free software license as published by the Massachusetts
 * Institute of Technology.
 *
 * Copyright 2014. Pine Studio
 */

package Modi
{
    import flash.utils.Dictionary;

    public interface IDeserializator
	{
		function get ready():Boolean;
		
		function deserializeData(data:*):void;
		
		function readString(name:String):String;

		function readInt(name:String):int;

		function readUInt(name:String):uint;

		function readNumber(name:String):Number;

		function readBoolean(name:String):Boolean;

		function readDictionary(name:String):Dictionary;

		function readArray(name:String):Array;

		function pushObject(name:String):void;

		function popObject():void;

		function pushArray(name:String):void;

		function popArray():void;

		function pushMap(name:String):void;

		function popMap():void;

		function getCurrentLength():int;

        function exists(name:String):Boolean;

        function reset():void;
	}
}