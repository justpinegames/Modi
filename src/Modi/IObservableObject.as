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
		function registerObserver(attribute:String, event:String, callback:Function):void;
		
		function removeObserver(attribute:String, callback:Function):Boolean;
		
		function allowChange(attribute:String, oldState:*, newState:*):Boolean;
		
		function willChange(attribute:String, oldState:*, newState:*):void;
		
		function hasChanged(attribute:String, oldState:*, newState:*):void;
	}
}