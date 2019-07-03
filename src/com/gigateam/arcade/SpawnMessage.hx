package com.gigateam.arcade;
import com.gigateam.netagram.Message;
import com.gigateam.util.BytesStream;

/**
 * ...
 * @author 
 */
class SpawnMessage extends Message
{
	public var unspawn:Bool = false;
	public var entityId:Int = 0x7FFF;
	public function new() 
	{
		super(247);
	}
	
	override public function pack(stream:BytesStream):Void{
		super.pack(stream);
		var flags:UInt = entityId & 0x7FFF;
		flags |= unspawn?0x8000:0;
		stream.writeInt16(flags);
	}
	
	override public function unpack(stream:BytesStream, messageType:Int):Void{
		super.unpack(stream, messageType);
		var flags:UInt = stream.readInt16();
		entityId = flags & 0x7FFF;
		unspawn = (flags & 0x8000) > 0;
	}
	
	override private function measuringSize():Int{
		return super.measuringSize() + 2;
	}
	
	override public function clone():Message{
		var message:SpawnMessage = new SpawnMessage();
		message.unspawn = unspawn;
		message.entityId = entityId;
		return message;
	}
}