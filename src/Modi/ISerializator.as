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

    public interface ISerializator
	{
		function writeString(name:String, object:String):void;

		function writeInt(name:String, object:int):void;

		function writeUInt(name:String, object:int):void;

		function writeNumber(name:String, object:Number):void;

		function writeBoolean(name:String, object:Boolean):void;

		function writeDictionary(name:String, object:Dictionary):void;

		function writeArray(name:String, object:Array):void;

		function pushObject(name:String):void;

		function popObject():void;

		function pushArray(name:String):void;

		function popArray():void;

		function pushMap(name:String):void;

		function popMap():void;
		
		function serializeData():*;
	}
}