package com.gigateam.arcade;
import com.gigateam.arcade.message.SpawnMessage;
import com.gigateam.arcade.message.StateMessage;

/**
 * ...
 * @author 
 */
 
class ArcadeNode 
{
	public var removeTime:Float = -1;
	public var collider:Dynamic;
	public var serverOnly:Bool = false;
	public var netId:Int = -1;
	public var visible:Bool = false;
	private var parent:NodeGroup;
	public function new(collider:Dynamic) 
	{
		this.collider = collider;
		this.serverOnly = false;
	}
	
	public function getSpawn():SpawnMessage{
		throw "You should override this function to return a custom message.";
		return null;
	}
	
	public function getState():StateMessage{
		throw "You should override this function to return a custom message.";
		return null;
	}
	
	public function lerp(before:StateMessage, after:StateMessage, percentage:Float):Void{
		throw "You should override this function to make a custom interpolation.";
	}
}