package com.gigateam.arcade;

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