package com.gigateam.arcade;
import hx.concurrent.lock.RLock;

/**
 * ...
 * @author 
 */
class NodeGroup extends ArcadeNode
{
	private var lock:RLock = new RLock();
	private var children:Array<ArcadeNode> = [];
	public function new() 
	{
		super(null);
	}
	
	public function addNode(node:ArcadeNode):Void{
		lock.acquire();
		var index:Int = children.indexOf(node);
		if (index >= 0){
			lock.release();
			return;
		}
		node.parent = this;
		children.push(node);
		bubblingAdd(node);
		lock.release();
	}
	
	public function removeNode(node:ArcadeNode):Void{
		lock.acquire();
		var index:Int = children.indexOf(node);
		if (index < 0){
			lock.release();
			throw "Node not exists";
		}
		bubblingRemove(node);
		node.parent = null;
		children.splice(index, 1);
		lock.release();
	}
	
	public function getNodeAt(index:Int):ArcadeNode{
		return children[index];
	}
	
	public function bubblingAdd(node:ArcadeNode):Void{
		if (parent != null){
			parent.bubblingAdd(node);
		}
	}
	
	public function bubblingRemove(node:ArcadeNode):Void{
		if (parent != null){
			parent.bubblingRemove(node);
		}
	}
	
	public function numChildren():Int{
		return children.length;
	}
	
	public function each(callback:ArcadeNode-> Void):Void{
		lock.acquire();
		for (node in children){
			callback(node);
		}
		lock.release();
	}
}