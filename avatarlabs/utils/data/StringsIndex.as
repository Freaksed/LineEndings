﻿/** StringsIndex  *	----------------------------------------------------------------------------------- *  *	@desc:  *	@developer: Aaron Buchanan, [aaron@avatarlabs.com]  *				Christian Widodo, [christian@avatarlabs.com]  *	----------------------------------------------------------------------------------- */	package com.avatarlabs.presentations.data	{		import com.avatarlabs.utils.console.ConsoleBroadcaster;				import com.avatarlabs.presentations.data.*;				public class StringsIndex		{			private static var instance:StringsIndex;						public var strings:Array;						/**	constructor			  *	--------------------------------------------------------------------------- */				public function StringsIndex()				{					if ( !instance )					{						strings = [];					}				}								public static function getInstance():StringsIndex				{					if( instance==null ) instance = new StringsIndex();					return instance;				}						/**	addSetting / getSetting			  *	--------------------------------------------------------------------------------- */				public function addString( id:String, value ):void				{					ConsoleBroadcaster.broadcast( "StringsIndex", "addString( "+id+", "+value+" );");										strings[ id ] = value;				}								public function getString( id:String )				{					ConsoleBroadcaster.broadcast( "StringsIndex", "getString( "+id+"): "+strings[ id ]);										var result = strings[ id ];										if( result == undefined )						ConsoleBroadcaster.broadcast( "StringsIndex", "!Error @ getSetting() » no indexed data for key: " + id );										return strings[ id ];				}					}	}