package com.gigateam.arcade;

/**
 * ...
 * @author 
 */
class SnapshotTimeline 
{
	private var snapshots:Array<SnapshotMessage> = [];
	private var maxSnapshots:Int;
	public function new(max:Int) 
	{
		maxSnapshots = max;
	}
	
	public function push(snapshot:SnapshotMessage):Bool{
		var lastSnapshot:SnapshotMessage = last();
		if (lastSnapshot!=null){
			if (lastSnapshot.time > snapshot.time){
				//Snapshots should be in-ordered;
				trace("in-order", lastSnapshot.time, snapshot.time);
				return false;
			}
			if (snapshots.length >= maxSnapshots){
				snapshots.shift();
			}
		}
		snapshots.push(snapshot);
		return true;
	}
	
	public function last():SnapshotMessage{
		if (snapshots.length == 0){
			return null;
		}
		return snapshots[snapshots.length - 1];
	}
	
	public function lerp(time:Float, callback:SnapshotMessage-> SnapshotMessage-> Float->Void):Void{
		var snapshotBefore:SnapshotMessage = null;
		var snapshotAfter:SnapshotMessage = null;
		//trace("start------------------------");
		for (i in 0...snapshots.length){
			//trace(time, snapshots[i].time);
			if (time < snapshots[i].time){
				snapshotAfter = snapshots[i];
				break;
			}
			snapshotBefore = snapshots[i];
		}
		var percent:Float = 0;
		/*
		if (snapshotBefore == null || snapshotAfter == null){
			if (snapshotBefore == null && snapshotAfter == null){
				//trace("both", snapshots.length, firstSnapshotTime(), lastSnapshotTime(), time);
			}else if (snapshotBefore == null ){
				//trace("before", snapshots.length, firstSnapshotTime(), time);
			}else{
				//trace("after", snapshots.length, lastSnapshotTime(), time);
			}
			
		}else{
			//trace("regular");
		}
		*/
		if (snapshotBefore == null && snapshotAfter == null){
			return;
			//throw "Snapshots are null";
		}else if (snapshotBefore == null){
			snapshotBefore = snapshotAfter;
			percent = 1;
		}else if (snapshotAfter == null){
			snapshotAfter = snapshotBefore;
			percent = 0;
		}else{
			percent = (time-snapshotBefore.time) / (snapshotAfter.time-snapshotBefore.time);
		}
		callback(snapshotBefore, snapshotAfter, percent);
	}
	
	public function lastSnapshotTime():Float{
		if (snapshots.length == 0){
			return -1;
		}
		return last().time;
	}
	
	public function firstSnapshotTime():Float{
		if (snapshots.length == 0){
			return -1;
		}
		return snapshots[0].time;
	}
}