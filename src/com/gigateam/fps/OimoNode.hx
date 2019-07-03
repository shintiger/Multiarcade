package com.gigateam.fps;
import com.gigateam.arcade.ArcadeNode;
import com.gigateam.arcade.SpawnMessage;
import com.gigateam.arcade.StateMessage;
import oimo.math.Vec3;
import oimo.physics.dynamics.RigidBody;

/**
 * ...
 * @author 
 */
class OimoNode extends ArcadeNode
{
	//private var body:RigidBody;
	private var position:Vec3;
	public function new(rigidBody:RigidBody) 
	{
		//body = rigidBody;
		if (rigidBody == null){
			position = new Vec3(0, 0, 0);
		}else{
			position = rigidBody.position;
		}
		super(rigidBody);
	}
	
	override public function getSpawn():SpawnMessage{
		var spawn:SpawnMessage = new SpawnMessage();
		return spawn;
	}
	
	override public function getState():StateMessage{
		var state:StateMessage = new StateMessage();
		if(collider!=null){
			var body:RigidBody = cast collider;
			position = body.position;
		}
		
		state.x = position.x;
		state.y = position.y;
		state.z = position.z;
		return state;
	}
	
	override public function lerp(before:StateMessage, after:StateMessage, percentage:Float):Void{
		position.x = before.x + (after.x - before.x) * percentage;
		position.y = before.y + (after.y - before.y) * percentage;
		position.z = before.z + (after.z - before.z) * percentage;
	}
	
	public function x():Float{
		return position.x;
	}
	
	public function y():Float{
		return position.y;
	}
	
	public function z():Float{
		return position.z;
	}
}