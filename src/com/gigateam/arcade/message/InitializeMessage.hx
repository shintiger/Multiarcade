package com.gigateam.arcade.message;
import com.gigateam.arcade.message.SpawnMessage;
import com.gigateam.netagram.Message;
import com.gigateam.netagram.MessageUtil;
import com.gigateam.util.BytesStream;

/**
 * ...
 * @author 
 */
class InitializeMessage extends Message
{
	private var spawnMessages:Array<Message>;
	public function new() 
	{
		super(249);
	}
	
	override public function pack(stream:BytesStream):Void{
		super.pack(stream);
		MessageUtil.packMessages(stream, spawnMessages);
	}
	
	override public function unpack(stream:BytesStream, messageType:Int):Void{
		super.unpack(stream, messageType);
		spawnMessages = MessageUtil.unpackMessages(stream, factory, sentTime);
	}
	
	override private function measuringSize():Int{
		return super.measuringSize() + MessageUtil.measureSizes(spawnMessages);
	}
	
	public function each(callback:SpawnMessage-> Void):Void{
		for (message in spawnMessages){
			var spawn:SpawnMessage = cast message;
			callback(spawn);
		}
	}
	
	public static function fromMessages(messages:Array<Message>):InitializeMessage{
		var initializeMessage:InitializeMessage = new InitializeMessage();
		initializeMessage.spawnMessages = messages;
		return initializeMessage;
	}
}