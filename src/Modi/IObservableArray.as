/*
 * This is free software; you can redistribute it and/or modify it under the
 * terms of MIT free software license as published by the Massachusetts
 * Institute of Technology.
 *
 * Copyright 2012. Vjekoslav Krajacic, Tomislav Podhraski
 */

package Modi 
{
	public interface IObservableArray
	{
		function addEventListener(event:String, listener:Function):void;
		
		function removeEventListener(event:String, listener:Function):Boolean;
		
		function allowRemove(object:ManagedObject, index:int):Boolean;
		
		function willRemove(object:ManagedObject, index:int):void;
		
		function wasRemoved(object:ManagedObject, index:int):void;
		
		function allowAdd(object:ManagedObject, index:int):Boolean;
		
		function willAdd(object:ManagedObject, index:int):void;
		
		function wasAdded(object:ManagedObject, index:int):void;
		
		function allowReplace(oldObject:ManagedObject, newObject:ManagedObject, index:int):Boolean;
		
		function willReplace(oldObject:ManagedObject, newObject:ManagedObject, index:int):void;
		
		function wasReplaced(oldObject:ManagedObject, newObject:ManagedObject, index:int):void;
	}
}