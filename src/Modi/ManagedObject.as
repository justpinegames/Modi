/*
 * This is free software; you can redistribute it and/or modify it under the
 * terms of MIT free software license as published by the Massachusetts
 * Institute of Technology.
 *
 * Copyright 2012. Vjekoslav Krajacic, Tomislav Podhraski
 */

package Modi
{
	import flash.utils.Dictionary;
	
	public class ManagedObject implements IObservableObject
	{
		public static var ALLOW_CHANGE:String = "AllowChange";
		public static var WILL_CHANGE:String = "WillChange";
		public static var HAS_CHANGED:String = "HasChanged";
		
		private var _registeredAttributes:Array;
		private var _attributeObservers:Array;
		
		public function ManagedObject()
		{
			_attributeObservers = new Array();
			_registeredAttributes = new Array();
		}
		
		public function registerObserver(attribute:String, event:String, callback:Function):void
		{
			var index:int = _registeredAttributes.indexOf(attribute);
			if (index == -1)
			{
				throw new Error("Object " + attribute + " does not exist");
			}
			
			if (_attributeObservers[attribute] == undefined)
			{
				_attributeObservers[attribute] = new Array();
			}
			
			_attributeObservers[attribute].push(new IObserver(event, callback));
		}
		
		public function removeObserver(attribute:String, callback:Function):Boolean
		{
			if (_attributeObservers[attribute] == undefined)
			{
				throw new Error("Object " + attribute + " does not exist or it is not being observed!");
			}
			
			var length:int = _attributeObservers[attribute].length;
			var observer:IObserver;
			
			for (var i:int = 0; i < length; i++)
			{
				observer = _attributeObservers[attribute][i];
				if (observer.callback == callback)
				{
					_attributeObservers[attribute].splice(i, 1);
					return true;
				}
			}
			
			return false;
		}
		
		protected function registerAttribute(attribute:String):void
		{
			_registeredAttributes.push(attribute);
		}
		
		public function allowChange(attribute:String, oldState:*, newState:*):Boolean
		{
			/// Ako ne postoje observeri na ovaj atribut, odma vraca true
			if (_attributeObservers[attribute] == undefined)
			{
				return true;
			}
			
			var targetObservers:Array = _attributeObservers[attribute];
			var length:int = targetObservers.length;
			var observer:IObserver;
			var i:int;
			
			for (i = 0; i < length; i++)
			{
				observer = targetObservers[i];
				if (observer.observedEvent == ALLOW_CHANGE)
				{
					var observerEvent:AttributeObserverEvent = new AttributeObserverEvent(attribute, ALLOW_CHANGE, oldState, newState);
					var allowed:Boolean = observer.callback(observerEvent);
					
					/// Ako ijedan observer ne dozvoljava, vraca se false
					if (!allowed)
					{
						return false;
					}
				}
			}
			
			/// Ako su svi observeri vratili true
			return true;
		}
		
		public function willChange(attribute:String, oldState:*, newState:*):void
		{
			/// Ako ne postoje observeri na ovaj atribut, izlazi van jer nema koga obavijestiti
			if (_attributeObservers[attribute] == undefined)
			{
				return;
			}
			
			var targetObservers:Array = _attributeObservers[attribute];
			var length:int = targetObservers.length;
			var observer:IObserver;
			var i:int;
			
			for (i = 0; i < length; i++)
			{
				observer = targetObservers[i];
				if (observer.observedEvent == WILL_CHANGE)
				{
					var observerEvent:AttributeObserverEvent = new AttributeObserverEvent(attribute, WILL_CHANGE, oldState, newState);
					observer.callback(observerEvent);
				}
			}
		}
		
		public function hasChanged(attribute:String, oldState:*, newState:*):void
		{
			/// Ako ne postoje observeri na ovaj atribut, izlazi van jer nema koga obavijestiti
			if (_attributeObservers[attribute] == undefined)
			{
				return;
			}
			
			var targetObservers:Array = _attributeObservers[attribute];
			var length:int = targetObservers.length;
			var observer:IObserver;
			var i:int;
			
			for (i = 0; i < length; i++)
			{
				observer = targetObservers[i];
				if (observer.observedEvent == HAS_CHANGED)
				{
					var observerEvent:AttributeObserverEvent = new AttributeObserverEvent(attribute, HAS_CHANGED, oldState, newState);
					observer.callback(observerEvent);
				}
			}
		}
	}
}