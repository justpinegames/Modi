/*
 * This is free software; you can redistribute it and/or modify it under the
 * terms of MIT free software license as published by the Massachusetts
 * Institute of Technology.
 *
 * Copyright 2012. Vjekoslav Krajacic, Tomislav Podhraski
 */

package Modi
{
	public interface IObservableObject
	{
		function addEventListener(attribute:String, event:String, listener:Function):void;
		
		function removeEventListener(attribute:String, listener:Function):Boolean;
		
		function allowChange(attribute:String, oldValue:*, newValue:*):Boolean;
		
		function willChange(attribute:String, oldValue:*, newValue:*):void;
		
		function wasChanged(attribute:String, oldValue:*, newValue:*):void;
	}
}