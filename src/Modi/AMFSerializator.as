/*
 * This is free software; you can redistribute it and/or modify it under the
 * terms of MIT free software license as published by the Massachusetts
 * Institute of Technology.
 *
 * Copyright 2014. Pine Studio
 */

package Modi
{
    import flash.utils.ByteArray;

    public class AMFSerializator extends CommonSerializator
    {
        override public function serializeData():*
        {
            var finalValue:* = stackTop();

            var bytes:ByteArray = new ByteArray();
            bytes.writeObject(finalValue);

            return bytes;
        }
    }
}
