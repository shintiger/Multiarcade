package com.gigateam.arcade;
import com.gigateam.arcade.control.InputResample;
import com.gigateam.arcade.message.InputMessage;
import com.gigateam.netagram.Message;
import com.gigateam.netagram.NetagramEndpoint;
import com.gigateam.netagram.NetagramHost;

/**
 * ...
 * @author 
 */
class ArcadeHost extends NetagramHost
{
	private var customCallback:Message->NetagramEndpoint->Void;
	public function new(host:String, port:Int) 
	{
		super(host, port);
		
	}
	
	override public function start(interval:Int):Void{
		customCallback = callback;
		callback = receive;
		super.start(interval);
	}
	
	private function receive(message:Message, client:NetagramEndpoint):Void{
		if (Std.is(message, InputMessage)){
			var input:InputResample = InputResample.fromMessage(cast message);
			trace(input.floatX, input.floatY, input.key0pressed, input.key1pressed);
		}else{
			customCallback(message, client);
		}
	}
}