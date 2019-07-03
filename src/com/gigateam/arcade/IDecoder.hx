package com.gigateam.arcade;

/**
 * @author 
 */
interface IDecoder 
{
	function createNodeByMessage(message:SpawnMessage):ArcadeNode;
}