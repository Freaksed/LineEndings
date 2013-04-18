﻿/** SettingsIndex  *	----------------------------------------------------------------------------------- *  *	@desc:  *	@developer: Aaron Buchanan, [aaron@avatarlabs.com]  *				Christian Widodo, [christian@avatarlabs.com]  *	----------------------------------------------------------------------------------- */	package com.avatarlabs.utils.data	{		import com.avatarlabs.utils.console.ConsoleBroadcaster;				import com.avatarlabs.utils.data.*;				public class SettingsIndex		{			private static var instance:SettingsIndex;						public var settings:Array;						/**	constructor			  *	--------------------------------------------------------------------------- */				public function SettingsIndex()				{					if ( !instance )					{						settings = [];					}				}								public static function getInstance():SettingsIndex				{					if( instance==null ) instance = new SettingsIndex();					return instance;				}						/**	addSetting / getSetting			  *	--------------------------------------------------------------------------------- */				public function addSetting( id:String, value ):void				{					ConsoleBroadcaster.broadcast( "AssetLoader", "addSetting( "+id+", "+value+" );");										settings[ id ] = value;				}								public function getSetting( id:String )				{					ConsoleBroadcaster.broadcast( "AssetLoader", "getSetting( "+id+"): "+settings[ id ]);										var result = settings[ id ];										if( result == undefined )						ConsoleBroadcaster.broadcast( "AssetLoader", "!Error @ getSetting() » no indexed data for key: " + id );										return settings[ id ];				}					}	}