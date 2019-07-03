package com.gigateam.arcade;
import com.gigateam.netagram.Message;
import com.gigateam.netagram.MessageUtil;
import com.gigateam.util.BytesStream;

/**
 * ...
 * @author 
 */
class SnapshotMessage extends Message
{
	public var time:Float = -1;
	private var stateMessages:Array<Message>;
	public function new() 
	{
		super(246);
	}
	
	override public function pack(stream:BytesStream):Void{
		super.pack(stream);
		MessageUtil.packMessages(stream, stateMessages);
	}
	
	override public function unpack(stream:BytesStream, messageType:Int):Void{
		super.unpack(stream, messageType);
		if (factory == null){
			throw "MessageFactory notfound!";
		}
		stateMessages = MessageUtil.unpackMessages(stream, factory, sentTime);
		time = sentTime;
	}
	
	override private function measuringSize():Int{
		return super.measuringSize() + MessageUtil.measureSizes(stateMessages);
	}
	
	public function each(callback:StateMessage-> Void):Void{
		for (message in stateMessages){
			var state:StateMessage = cast message;
			callback(state);
		}
	}
	
	public function getStateByNetId(netId:Int):StateMessage{
		for (message in stateMessages){
			var state:StateMessage = cast message;
			if (state.entityId == netId){
				return state;
			}
		}
		return null;
	}
	
	public function numMessages():Int{
		return stateMessages.length;
	}
	
	public static function fromMessages(messages:Array<Message>):SnapshotMessage{
		var snapshot:SnapshotMessage = new SnapshotMessage();
		snapshot.stateMessages = messages;
		return snapshot;
	}
	
	override public function clone():Message{
		var message:SnapshotMessage = new SnapshotMessage();
		message.time = time;
		message.stateMessages = stateMessages;
		return message;
	}
}