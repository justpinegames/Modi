/*
 * This is free software; you can redistribute it and/or modify it under the
 * terms of MIT free software license as published by the Massachusetts
 * Institute of Technology.
 *
 * Copyright 2014. Pine Studio
 */

package Modi 
{
    public class ManagedObjectId extends ManagedObject
    {
        public static var UNDEFINED:ManagedObjectId = new ManagedObjectId();

        private var _objectId:String;

        public function ManagedObjectId(objectId:String = "none")
        {
            _objectId = objectId;
        }

        public function get objectId():String { return _objectId; }

        public function extractIndex():int
        {
            var id: int = -1;
            if (_objectId.indexOf("id") == 0) id = int(_objectId.substr(2));
            else                              trace("Id is possibly malformed:", _objectId);
            return id;
        }

        public function isConcrete():Boolean
        {
            return _objectId != "none" && _objectId != "";
        }

        public function equals(other:ManagedObjectId):Boolean
        {
            return _objectId == other.objectId;
        }
    }
}