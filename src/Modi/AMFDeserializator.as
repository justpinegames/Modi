/*
 * This is free software; you can redistribute it and/or modify it under the
 * terms of MIT free software license as published by the Massachusetts
 * Institute of Technology.
 *
 * Copyright 2013. Just Pine Games
 */

package Modi
{
    import flash.utils.ByteArray;

    public class AMFDeserializator extends CommonDeserializator
    {
        private var _decodedData:*;

        override public function deserializeData(data:*):void
        {
            _decodedData = (data as ByteArray).readObject();
            _data = _decodedData;
            _stack.push( { data:_decodedData, context:SERIALIZATOR_STATE_OBJECT } );
            _ready = true;
        }

        override public function reset():void
        {
            super.reset();

            _data = _decodedData;
            _stack.push( { data:_decodedData, context:SERIALIZATOR_STATE_OBJECT } );
            _ready = true;
        }
    }
}
