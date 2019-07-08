package com.gigateam.arcade.control;
import com.gigateam.arcade.message.InputMessage;

/**
 * ...
 * @author 
 */
class InputResample 
{
	public var key0pressed:Bool = false;
	public var key1pressed:Bool = false;
	public var key2pressed:Bool = false;
	public var key3pressed:Bool = false;
	public var key4pressed:Bool = false;
	public var key5pressed:Bool = false;
	public var key6pressed:Bool = false;
	public var key7pressed:Bool = false;
	
	public var key8pressed:Bool = false;
	public var key9pressed:Bool = false;
	public var key10pressed:Bool = false;
	public var key11pressed:Bool = false;
	public var key12pressed:Bool = false;
	public var key13pressed:Bool = false;
	public var key14pressed:Bool = false;
	public var key15pressed:Bool = false;
	
	public var floatX:Float = 0;
	public var floatY:Float = 0;
	
	public function new() 
	{
		
	}
	
	public function toMessage():InputMessage{
		var message:InputMessage = new InputMessage();
		
		message.setPressed(0, key0pressed);
		message.setPressed(1, key1pressed);
		message.setPressed(2, key2pressed);
		message.setPressed(3, key3pressed);
		message.setPressed(4, key4pressed);
		message.setPressed(5, key5pressed);
		message.setPressed(6, key6pressed);
		message.setPressed(7, key7pressed);
		
		message.setPressed(8, key8pressed);
		message.setPressed(9, key9pressed);
		message.setPressed(10, key10pressed);
		message.setPressed(11, key11pressed);
		message.setPressed(12, key12pressed);
		message.setPressed(13, key13pressed);
		message.setPressed(14, key14pressed);
		message.setPressed(15, key15pressed);
		
		message.floatX = floatX;
		message.floatY = floatY;
		
		return message;
	}
	
	public static function fromMessage(message:InputMessage):InputResample{
		var input:InputResample = new InputResample();
		
		input.key0pressed = message.getPressed(0);
		input.key1pressed = message.getPressed(1);
		input.key2pressed = message.getPressed(2);
		input.key3pressed = message.getPressed(3);
		input.key4pressed = message.getPressed(4);
		input.key5pressed = message.getPressed(5);
		input.key6pressed = message.getPressed(6);
		input.key7pressed = message.getPressed(7);
		
		input.key8pressed = message.getPressed(8);
		input.key9pressed = message.getPressed(9);
		input.key10pressed = message.getPressed(10);
		input.key11pressed = message.getPressed(11);
		input.key12pressed = message.getPressed(12);
		input.key13pressed = message.getPressed(13);
		input.key14pressed = message.getPressed(14);
		input.key15pressed = message.getPressed(15);
		
		input.floatX = message.floatX;
		input.floatY = message.floatY;
		
		return input;
	}
}