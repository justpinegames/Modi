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

    public class YAMLSerializator extends CommonSerializator
    {
        override public function serializeData():*
        {
            var finalValue:* = stackTop();

            var yamlData:String = YAML.encode(finalValue);
            return yamlData;
        }
    }
}