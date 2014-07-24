/*
 * This is free software; you can redistribute it and/or modify it under the
 * terms of MIT free software license as published by the Massachusetts
 * Institute of Technology.
 *
 * Copyright 2014. Pine Studio
 */

package Modi
{
    import org.as3yaml.YAML;

    public class YAMLDeserializator extends CommonDeserializator
    {
        private var _decodedData:*;

        override public function deserializeData(data:*):void
        {
            _decodedData = YAML.decode(data);
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