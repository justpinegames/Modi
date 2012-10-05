/*
 * This is free software; you can redistribute it and/or modify it under the
 * terms of MIT free software license as published by the Massachusetts
 * Institute of Technology.
 *
 * Copyright 2012. Vjekoslav Krajacic, Tomislav Podhraski
 */

package Modi
{
	import org.as3yaml.YAML;
	
	public class YAMLDeserializator extends CommonDeserializator
	{
		override public function deserializeData(data:*):void
		{
			_data = YAML.decode(data);
			_stack.push( { data:_data, context:SERIALIZATOR_STATE_OBJECT } );
			_ready = true;
		}
    }
}