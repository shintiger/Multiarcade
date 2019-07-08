package com.gigateam.arcade;
import com.gigateam.arcade.control.InputResample;
import com.gigateam.arcade.message.InitializeMessage;
import com.gigateam.arcade.message.SnapshotMessage;
import com.gigateam.arcade.message.SpawnMessage;
import com.gigateam.netagram.Message;
import com.gigateam.netagram.MessageFactory;
import com.gigateam.netagram.Netagram;
import sys.net.Host;

/**
 * ...
 * @author 
 */
class ArcadeClient extends Netagram
{
	public var lerp:Float = 0.1;
	public var onUpdate:Void->Void;
	private var former:ArcadeFormer;
	private var customOnMessage:Message-> Void;
	private var synchronized:Bool = false;
	private var messageBuffer:Array<Message> = [];
	public function new(host:Host, port:Int, factory:MessageFactory, former:ArcadeFormer) 
	{
		this.former = former;
		super(host, port, factory);
	}
	
	public function received(message:Message):Void{
		if (!synchronized){
			if (Std.is(message, InitializeMessage)){
				trace("Initializing");
				process(message);
				if (messageBuffer.length > 0){
					for (oldMessage in messageBuffer){
						process(oldMessage);
					}
					messageBuffer = [];
				}
				synchronized = true;
			}else{
				messageBuffer.push(message);
			}
			return;
		}
		process(message);
	}
	
	private function process(message:Message):Void{
		former.accessLock.acquire();
		
		if (Std.is(message, InitializeMessage)){
			var init:InitializeMessage = cast message;
			init.each(function(spawn:SpawnMessage):Void{
				former.readSpawn(spawn);
			});
		}else if (Std.is(message, SnapshotMessage)){
			var snapshot:SnapshotMessage = cast message;
			former.readSnapshot(snapshot);
		}else if (Std.is(message, SpawnMessage)){
			var spawn:SpawnMessage = cast message;
			former.readSpawn(spawn);
		}else{
			if(customOnMessage!=null){
				customOnMessage(message);
			}else{
				handler.onMessage(message);
			}
		}
		
		former.accessLock.release();
	}
	
	override public function start():Void{
		//customOnMessage = callback;
		if (onMessage != null){
			customOnMessage = onMessage;
		}
		onMessage = received;
		super.start();
	}
	
	public function handleUpdate():Void{
		//former.accessLock.acquire();
		former.accessLock.acquire();
		
		former.fetchAdded();
		former.fetchRemoved();
		former.interpolate(Sys.time() - lerp);
		if (onUpdate != null){
			onUpdate();
		}
		former.updateChildren();
		former.accessLock.release();
		//former.accessLock.release();
	}
	
	public function commit(input:InputResample):Void{
		sendImportant(input.toMessage());
	}
}