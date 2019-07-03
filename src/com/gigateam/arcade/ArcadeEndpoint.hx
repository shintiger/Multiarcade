package com.gigateam.arcade;
import com.gigateam.netagram.Channel;
import com.gigateam.netagram.Message;
import com.gigateam.netagram.SwitchlessEndpoint;
import sys.net.Address;
import sys.net.Socket;
import sys.net.UdpSocket;

/**
 * ...
 * @author Tiger
 */
class ArcadeEndpoint extends SwitchlessEndpoint
{
	private var messageBuffer:Array<Message> = [];
	public function new(sock:UdpSocket, addr:Address) 
	{
		super(sock, addr);
	}
	override public function subscribe(channel:Channel):Void{
		super.subscribe(channel);
	}
}