package com.gigateam.arcade;
import com.gigateam.netagram.IMessageSender;
import com.gigateam.netagram.Message;
import com.gigateam.netagram.RollingIndex;

/**
 * ...
 * @author 
 */
class ArcadeRoot extends NodeGroup
{
	private var snapshotTimeline:SnapshotTimeline;
	private var simulator:ISimulator;
	private var sender:IMessageSender;
	
	//0x7FFE is 7bits max, reserved for invalid id
	private var networkId:RollingIndex = RollingIndex.fromMax(0x7FFE);
	private var nodes:Map<Int, ArcadeNode> = new Map();
	public function new(simulator:ISimulator, sender:IMessageSender) 
	{
		this.simulator = simulator;
		this.sender = sender;
		snapshotTimeline = new SnapshotTimeline(30);
		super();
	}
	
	private function loopNode(targetNode:ArcadeNode, add:Bool):Void{
		if (Std.is(targetNode, NodeGroup)){
			var group:NodeGroup = cast targetNode;
			for (i in 0...group.numChildren()){
				var node:ArcadeNode = group.getNodeAt(i);
				if (Std.is(node, NodeGroup)){
					loopNode(cast node, add);
					continue;
				}
			}
		}else if (targetNode.serverOnly){
			return;
		}else if (add){
			networkSpawn(targetNode);
		}else{
			networkUnspawn(targetNode);
		}
	}
	
	private function networkSpawn(node:ArcadeNode):Void{
		if (node.netId >= 0){
			throw "Node already has netId";
		}
		networkId.add(1);
		while (nodes.exists(networkId.index)){
			networkId.add(1);
		}
		node.netId = networkId.index;
		nodes.set(networkId.index, node);
		
		simulator.addEntity(node.collider);
		var message:SpawnMessage = getSpawnByNode(node);
		trace("node.netId", node.netId);
		
		sender.sendImportant(message);
	}
	
	public function requestJoin(joiner:IMessageSender):Void{
		var messages:Array<Message> = [];
		for (node in nodes){
			messages.push(getSpawnByNode(node));
		}
		var message:InitializeMessage = InitializeMessage.fromMessages(messages);
		joiner.sendReliable(message);
	}
	
	public function sendSnapshot():Void{
		var messages:Array<Message> = [];
		for (node in nodes){
			var state:StateMessage = node.getState();
			if (state != null){
				state.entityId = node.netId;
				messages.push(state);
			}
		}
		var snapshot:SnapshotMessage = SnapshotMessage.fromMessages(messages);
		snapshot.time = Sys.time();
		sender.send(snapshot);
		snapshotTimeline.push(snapshot);
	}
	
	private function networkUnspawn(node:ArcadeNode):Void{
		if (!nodes.exists(node.netId)){
			throw "Node doesn't have networkId or notfound";
		}
		nodes.remove(node.netId);
		node.netId = -1;
		simulator.removeEntity(node.collider);
	}
	
	override public function bubblingAdd(node:ArcadeNode):Void{
		loopNode(node, true);
		//networkSpawn(node);
	}
	
	override public function bubblingRemove(node:ArcadeNode):Void{
		loopNode(node, false);
		//networkUnspawn(node);
	}
	
	private static function getSpawnByNode(node:ArcadeNode):SpawnMessage{
		var message:SpawnMessage = node.getSpawn();
		message.entityId = node.netId;
		return message;
	}
}