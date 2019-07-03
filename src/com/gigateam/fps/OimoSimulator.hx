package com.gigateam.fps;
import com.gigateam.arcade.ISimulator;
import oimo.physics.dynamics.RigidBody;
import oimo.physics.dynamics.World;

/**
 * ...
 * @author 
 */
class OimoSimulator extends World implements ISimulator
{

	public function new() 
	{
		super(60);
		gravity.y *= 0.1;
	}
	public function addEntity(entity:Dynamic):Void{ 
		if (!Std.is(entity, RigidBody)){
			throw "Only accept RigidBody";
		}
		var body:RigidBody = cast entity;
		//numContacts
		//trace(body.parent);
		addRigidBody(body);
	}
	public function removeEntity(entity:Dynamic):Void{
		if (!Std.is(entity, RigidBody)){
			throw "Only accept RigidBody";
		}
		var body:RigidBody = cast entity;
		removeRigidBody(body);
	}
	
	override public function step():Void{
		super.step();
		if (collisionResult.numContactInfos>0){
			//trace("collisionResult.numContactInfos", collisionResult.numContactInfos);
		}
	}
}