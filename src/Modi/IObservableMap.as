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
		function addObserver(event:String, listener:Function):void;
		
		function removeObserver(event:String, listener:Function):Boolean;
		
		function allowChange(oldObject:ManagedObject, newObject:ManagedObject, x:int, y:int):Boolean;
		
		function willChange(oldObject:ManagedObject, newObject:ManagedObject, x:int, y:int):void;
		
		function wasChanged(oldObject:ManagedObject, newObject:ManagedObject, x:int, y:int):void;
	}
}