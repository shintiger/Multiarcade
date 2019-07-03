package com.gigateam.arcade;
import hx.concurrent.lock.RLock;

/**
 * ...
 * @author 
 */
class ArcadeFormer extends NodeGroup implements IDecoder
{
	public var accessLock:RLock = new RLock();
	private var added:Array<ArcadeNode> = [];
	private var removed:Array<ArcadeNode> = [];
	private var pendingRemove:Array<ArcadeNode> = [];
	private var universalBaseId:Int = 0;
	private var snapshotTimeline:SnapshotTimeline;
	private var remoteStartTime:Float = -1;
	private var remoteLastTime:Float = -1;
	private var localStartTime:Float = -1;
	private var localLastTime:Float = -1;
	private var decoder:IDecoder;
	private var nodeAlive:Float = 1;
	public function new() 
	{
		this.decoder = this;
		snapshotTimeline = new SnapshotTimeline(30);
		super();
	}
	
	public function readSpawn(spawn:SpawnMessage):Void{
		trace("reading spawn", spawn.entityId);
		var node:ArcadeNode = getNodeByNetId(spawn.entityId);
		if (node == null){
			node = decoder.createNodeByMessage(spawn);
			node.netId = spawn.entityId;
			addNode(node);
		}
	}
	
	override public function addNode(node:ArcadeNode):Void{
		added.push(node);
		super.addNode(node);
	}
	
	override public function removeNode(node:ArcadeNode):Void{
		removed.push(node);
		super.removeNode(node);
	}
	
	public function fetchAdded():Void{
		for (node in added){
			onAdd(node);
		}
		added = [];
	}
	
	public function fetchRemoved():Void{
		for (node in added){
			onRemove(node);
		}
		removed = [];
	}
	
	public function onAdd(node:ArcadeNode):Void{}
	
	public function onRemove(node:ArcadeNode):Void{}
	
	public function readSnapshot(snapshot:SnapshotMessage):Void{
		var localTime:Float = Sys.time();
		var debugStr:String = "";
		var remoteDelta:Float = snapshot.sentTime - remoteStartTime;
		if (localStartTime < 0){
			localStartTime = localTime;
			remoteStartTime = snapshot.sentTime;
			
			localLastTime = localStartTime;
			remoteLastTime = remoteStartTime;
			
			remoteDelta = 0;
			debugStr += "reset start time\n";
		}else{
			debugStr += "normal\n";
		}
		if (snapshot.sentTime < remoteLastTime){
			trace("discarding");
			//Discard old snapshot
			//trace(remoteLastTime, snapshot.sentTime);
			return;
		}else{
			var localDelta:Float = localTime-localStartTime;
			remoteLastTime = snapshot.sentTime;
			localLastTime = localTime;
			
			if (localDelta < remoteDelta){
				debugStr += "snapshot.sentTime: "+Std.string(snapshot.sentTime)+"\n";
				debugStr += "update start time from [" + Std.string(localStartTime) + "] to [" + Std.string(localTime-remoteDelta) + "] (remoteDelta:"+Std.string(remoteDelta)+")\n";
				//This is the lowest latency packet
				localStartTime = localTime-remoteDelta;
			}else{
				debugStr += "normal start time\n";
			}
			
		}
		snapshot.time = localStartTime+remoteDelta;
		
		if (snapshot.time == 65536 || snapshot.time==0){
			trace(debugStr);
		}
		//var last:SnapshotMessage = snapshotTimeline.last();
		if (snapshotTimeline.push(snapshot)){
			/*
			last.each(function(state:StateMessage):Void{
				if (snapshot.getStateByNetId(state.entityId) == null){
					var node:ArcadeNode = getNodeByNetId(state.entityId);
					node.removeTime = localTime+nodeAlive;
					pendingRemove.push(node);
				}
			});
			*/
			for (node in children){
				if (snapshot.getStateByNetId(node.netId) == null && node.removeTime<0){
					node.removeTime = localTime+nodeAlive;
					pendingRemove.push(node);
				}
			}
		}
		
		//Remove timedout node
		var i:Int = 0;
		while (i<pendingRemove.length){
			if (localTime >= pendingRemove[i].removeTime){
				var toRemove:ArcadeNode = pendingRemove[i];
				pendingRemove.remove(toRemove);
				removeNode(toRemove);
				break;
			}
			i += 1;
		}
	}
	
	public function interpolate(time:Float):Void{
		snapshotTimeline.lerp(time, function(before:SnapshotMessage, after:SnapshotMessage, percentage:Float):Void{
			after.each(function(afterState:StateMessage):Void{
				var beforeState:StateMessage = before.getStateByNetId(afterState.entityId);
				var node:ArcadeNode = getNodeByNetId(afterState.entityId);
				if (beforeState == null || node==null){
					return;
				}
				node.lerp(beforeState, afterState, percentage);
			});
		});
	}
	
	public function createNodeByMessage(message:SpawnMessage):ArcadeNode{
		var node:ArcadeNode = new ArcadeNode(null);
		return node;
	}
	
	public function getNodeByNetId(netId:Int):ArcadeNode{
		for (i in 0...numChildren()){
			if (children[i].netId == netId){
				return children[i];
			}
		}
		return null;
	}
	
	public function updateChildren():Void{
		lock.acquire();
		for (node in children){
			//handler.onItemUpdate(node);
			onItemUpdate(node);
		}
		lock.release();
	}
	
	public function onItemUpdate(node:ArcadeNode):Void{}
}