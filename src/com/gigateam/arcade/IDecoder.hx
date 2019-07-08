package com.gigateam.arcade;
import com.gigateam.arcade.message.SpawnMessage;

/**
 * @author 
 */
interface IDecoder 
{
	function createNodeByMessage(message:SpawnMessage):ArcadeNode;
}