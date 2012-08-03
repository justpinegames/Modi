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
		public static var WAS_CHANGED:String = "WasChanged";
		
		private var _attributeObservers:Dictionary;
		private var _registeredAttributes:Array;
		private var _registeredAttributesTypes:Array;
		private var _contextId:ManagedObjectId;
		
		public function ManagedObject()
		{
			_attributeObservers = new Dictionary();
			_registeredAttributes = new Array();
			_registeredAttributesTypes = new Array();
			
			_contextId = null;
		}
		
		public function set contextId(contextId:ManagedObjectId):void
		{
			_contextId = contextId;
		}
		
		public function get contextId():ManagedObjectId
		{
			return _contextId;
		}
		
		public function registerObserver(attribute:String, event:String, callback:Function):void
		{
			var index:int = _registeredAttributes.indexOf(attribute);
			if (index == -1)
			{
				throw new Error("Object " + attribute + " does not exist!");
			}
			
			if (_attributeObservers[attribute] === undefined)
			{
				_attributeObservers[attribute] = new Vector.<IObserver>();
			}
			
			_attributeObservers[attribute].push(new IObserver(event, callback));
		}
		
		public function removeObserver(attribute:String, callback:Function):Boolean
		{
			if (_attributeObservers[attribute] === undefined)
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
		
		protected function registerAttributes(attributes:Array, attributesTypes:Array):void
		{
			_registeredAttributes = attributes;
			_registeredAttributesTypes = attributesTypes;
		}
		
		public function allowChange(attribute:String, oldState:*, newState:*):Boolean
		{
			/// Ako ne postoje observeri na ovaj atribut, odma vraca true
			if (_attributeObservers[attribute] === undefined)
			{
				return true;
			}
			
			var targetObservers:Vector.<IObserver> = _attributeObservers[attribute];
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
			if (_attributeObservers[attribute] === undefined)
			{
				return;
			}
			
			var targetObservers:Vector.<IObserver> = _attributeObservers[attribute];
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
		
		public function wasChanged(attribute:String, oldState:*, newState:*):void
		{
			/// Ako ne postoje observeri na ovaj atribut, izlazi van jer nema koga obavijestiti
			if (_attributeObservers[attribute] === undefined)
			{
				return;
			}
			
			var targetObservers:Vector.<IObserver> = _attributeObservers[attribute];
			var length:int = targetObservers.length;
			var observer:IObserver;
			var i:int;
			
			for (i = 0; i < length; i++)
			{
				observer = targetObservers[i];
				if (observer.observedEvent == WAS_CHANGED)
				{
					var observerEvent:AttributeObserverEvent = new AttributeObserverEvent(attribute, WAS_CHANGED, oldState, newState);
					observer.callback(observerEvent);
				}
			}
		}
		
		public function serialize(serializator:ISerializator):void 
		{
			var lenght: int = this._registeredAttributes.length;
			for (var i: int = 0; i < lenght; i++) 
			{
				var attributeName:String = this._registeredAttributes[i];
				var attributeType:String = this._registeredAttributesTypes[i];
				
				writeUnindentified(attributeName, this[attributeName], attributeType, serializator);
			}
		}
		
		public function deserialize(deserializator:IDeserializator):void 
		{
			var lenght: int = this._registeredAttributes.length;
			for (var i: int = 0; i < lenght; i++) 
			{
				var attributeName:String = this._registeredAttributes[i];
				var attributeType:String = this._registeredAttributesTypes[i];
				
				readUnindentified(attributeName, this, attributeType, deserializator);
			}
		}
		
		public static function readUnindentified(name:String, object:*, type:String, deserializator:IDeserializator):Boolean
		{
			var pass: Boolean = true;
			
			if (type == "String") 
			{
				object[name] = deserializator.readString(name);
			}
			else if (type == "int") 
			{
				object[name] = deserializator.readInt(name);
			}
			else if (type == "uint") 
			{
				object[name] = deserializator.readUInt(name);
			}
			else if (type == "Number") 
			{
				object[name] = deserializator.readNumber(name);
			}
			else if (type == "Boolean") 
			{
				object[name] = deserializator.readBoolean(name);
			}
			else if (type == "ManagedArray")
			{
				deserializator.pushArray(name);
				(object[name] as ManagedArray).deserialize(deserializator);
				deserializator.popArray();
			}
			else if (type == "ManagedMap")
			{
				
				trace("managed map not implemented for deserialization");
				/*
				var className:String = deserializator.pushMap(name);
				(object as ManagedMap).deserialize(deserializator);
				deserializator.popMap();
				*/
			}
			else /// object
			{
				var objectClass:Class = Utility.getClassFromString(type);
				var newObject:ManagedObject = new objectClass();
				
				if (newObject is ManagedObject)
				{
					object.deserialize(deserializator);
					object[name] = newObject;
					deserializator.popObject();
				}
				else 
				{
					/// ignore
					pass = false;
				}
			}
			
			return pass;
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
			else if (type == "ManagedArray")
			{
				serializator.pushArray(name);
				if (object) 
				{
					(object as ISerializableObject).serialize(serializator);
				}
				serializator.popArray();
			}
			else if (type == "ManagedMap")
			{
				/// push map
				trace("map serialization not yet implemented");
			}
			else 
			{
				if (type == "ManagedObject" || object is ManagedObject)
				{
					serializator.pushObject(name);
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
			}
			
			return pass;
			
		}
	}
}