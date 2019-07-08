package com.gigateam.arcade.message;
import com.gigateam.netagram.Message;
import com.gigateam.util.BytesStream;
import haxe.ds.Vector;

/**
 * ...
 * @author 
 */
class InputMessage extends Message
{
	private var pressedKeys:Vector<Bool> = new Vector<Bool>(16);
	public var floatX:Float = 0;
	public var floatY:Float = 0;
	public function new() 
	{
		super(245);
	}
	
	override public function pack(stream:BytesStream):Void{
		super.pack(stream);
		var keys:Int = 0;
		for (i in 0...pressedKeys.length){
			if(pressedKeys[i]){
				keys |= 1 << i;
			}
		}
		keys &= 0xffff;
		stream.writeInt16(keys);
		stream.writeDouble(floatX);
		stream.writeDouble(floatY);
	}
	
	override public function unpack(stream:BytesStream, messageType:Int):Void{
		super.unpack(stream, messageType);
		var keys:Int = stream.readInt16(); 
		for (i in 0...pressedKeys.length){
			var pressed:Bool = (keys & (1 << i)) > 0;
			pressedKeys.set(i, pressed);
		}
		floatX = stream.readDouble();
		floatY = stream.readDouble();
	}
	
	override private function measuringSize():Int{
		return super.measuringSize() + 2 + 8 + 8;
	}
	
	override public function clone():Message{
		var message:InputMessage = new InputMessage();
		message.pressedKeys = pressedKeys.copy();
		message.floatX = floatX;
		message.floatY = floatY;
		return message;
	}
	
	public function setPressed(index:Int, pressed:Bool):Void{
		pressedKeys[index] = pressed;
	}
	
	public function getPressed(index:Int):Bool{
		return pressedKeys[index];
	}
}