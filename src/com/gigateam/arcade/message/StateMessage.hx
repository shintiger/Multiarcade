package com.gigateam.arcade.message;
import com.gigateam.netagram.Message;
import com.gigateam.util.BytesStream;

/**
 * ...
 * @author 
 */
class StateMessage extends Message
{
	public var time:Float = -1;
	public var x:Float;
	public var y:Float;
	public var z:Float;
	public var unchanged:Bool = false;
	public var entityId:Int = 0x7FFF;
	public function new() 
	{
		super(248);
	}
	override public function pack(stream:BytesStream):Void{
		super.pack(stream);
		var flags:UInt = entityId & 0x7FFF;
		flags |= unchanged?0x8000:0;
		stream.writeInt16(flags);
		if (unchanged){
			return;
		}
		stream.writeDouble(x);
		stream.writeDouble(y);
		stream.writeDouble(z);
	}
	override public function unpack(stream:BytesStream, messageType:Int):Void{
		super.unpack(stream, messageType);
		var flags:UInt = stream.readInt16();
		entityId = flags & 0x7FFF;
		unchanged = (flags & 0x8000) > 0;
		if (unchanged){
			return;
		}
		x = stream.readDouble();
		y = stream.readDouble();
		z = stream.readDouble();
	}
	override private function measuringSize():Int{
		var parentSize:Int = super.measuringSize() + 2;
		if (unchanged){
			return parentSize;
		}
		return parentSize+24;
	}
	
	override public function clone():Message{
		var message:StateMessage = new StateMessage();
		message.entityId = entityId;
		message.unchanged = unchanged;
		message.x = x;
		message.y = y;
		message.z = z;
		
		return message;
	}
}