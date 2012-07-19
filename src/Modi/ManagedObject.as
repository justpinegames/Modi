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
	import Core.Utility;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	
	public class ManagedObject implements IObservableObject, ISerializableObject
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
		
		public function serialize(serializator:ISerializator):void 
		{
			
		}
		
		public function deserialize(deserializator:IDeserializator):void 
		{
			
		}
		
		public static function readUnindentified(name:String, type:String, deserializator:IDeserializator):* 
		{
			var toReturn:* = null;
			
			if (type == "String") 
			{
				toReturn = deserializator.readString(name);
			}
			else if (type == "int") 
			{
				toReturn = deserializator.readInt(name);
			}
			else if (type == "uint") 
			{
				toReturn = deserializator.readUInt(name);
			}
			else if (type == "Number") 
			{
				toReturn = deserializator.readNumber(name);
			}
			else if (type == "Boolean") 
			{
				toReturn = deserializator.readBoolean(name);
			}
			else if (type == "Point") 
			{
				toReturn = deserializator.readPoint(name);
			}
			else if (type == "Rectangle") 
			{
				toReturn = deserializator.readRectangle(name);
			}
			else if (type == "ManagedObject" || type == "ManagedArray" || type == "ManagedMap")
			{
				var className:String = deserializator.pushObject(name);
				var objectClass:Class = Utility.getClassFromString(className);
				var object:ManagedObject = new objectClass();
				object.deserialize(deserializator);
				toReturn = object;
				deserializator.popObject();
			}
			else 
			{
				/// ignore
			}
			
			return toReturn;
		}
		
		public static function writeUnindentified(name:String, object:*, type:String, serializator:ISerializator):Boolean 
		{
			
			var pass: Boolean = true;
			
			if (type == "String") 
			{
				serializator.writeString(name, object as String);
			}
			else if (type == "int") 
			{
				serializator.writeInt(name, object as int);
			}
			else if (type == "uint") 
			{
				serializator.writeUInt(name, object as int);
			}
			else if (type == "Number") 
			{
				serializator.writeNumber(name, object as Number);
			}
			else if (type == "Boolean") 
			{
				serializator.writeBoolean(name, object as Boolean);
			}
			else if (type == "Point") 
			{
				serializator.writePoint(name, object as Point);
			}
			else if (type == "Rectangle") 
			{
				serializator.writeRectangle(name, object as Rectangle);
			}
			else if (type == "ManagedObject" || type == "ManagedArray" || type == "ManagedMap")
			{
				serializator.pushObject(name, type);
				if (object) 
				{
					(object as ISerializableObject).serialize(serializator);
				}
				serializator.popObject();
			}
			else 
			{
				pass = false;
				/// ignore
			}
			
			return pass;
			
		}
	}
}