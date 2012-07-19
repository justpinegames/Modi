/*
 * This is free software; you can redistribute it and/or modify it under the
 * terms of MIT free software license as published by the Massachusetts
 * Institute of Technology.
 *
 * Copyright 2012. Vjekoslav Krajacic, Tomislav Podhraski
 */

package Modi 
{
	public interface IObservableMap 
	{
		function registerObserver(event:String, callback:Function):void;
		
		function removeObserver(event:String, callback:Function):Boolean;
		
		function allowChange(oldObject:ManagedObject, newObject:ManagedObject, x:int, y:int):Boolean;
		
		function willChange(oldObject:ManagedObject, newObject:ManagedObject, x:int, y:int):void;
		
		function hasChanged(oldObject:ManagedObject, newObject:ManagedObject, x:int, y:int):void;
	}
}