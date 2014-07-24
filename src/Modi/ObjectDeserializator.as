/*
 * This is free software; you can redistribute it and/or modify it under the
 * terms of MIT free software license as published by the Massachusetts
 * Institute of Technology.
 *
 * Copyright 2014. Pine Studio
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
