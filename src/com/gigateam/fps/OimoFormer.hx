package com.gigateam.fps;
import com.gigateam.arcade.ArcadeFormer;
import com.gigateam.arcade.ArcadeNode;
import com.gigateam.arcade.message.SpawnMessage;

/**
 * ...
 * @author 
 */
class OimoFormer extends ArcadeFormer
{

	public function new() 
	{
		super();
	}
	
	override public function createNodeByMessage(message:SpawnMessage):ArcadeNode{
		var node:OimoNode = new OimoNode(null);
		return node;
	}
}