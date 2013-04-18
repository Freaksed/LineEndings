﻿/** BitmapDataManager *	---------------------------------------------------------------------------- */ 	package com.avatarlabs.utils.cache	{		import flash.display.BitmapData;		import flash.display.Loader;		import flash.display.LoaderInfo;		import flash.events.Event;		import flash.events.EventDispatcher;		import flash.events.IOErrorEvent;		import flash.net.URLRequest;		import flash.system.ApplicationDomain;		import flash.system.LoaderContext;		import flash.system.System;				import com.avatarlabs.utils.console.ConsoleBroadcaster;				import com.avatarlabs.utils.cache.BitmapDataObject;		import com.avatarlabs.utils.events.CustomEvent;				public class BitmapDataManager extends EventDispatcher		{			private static var _instance:BitmapDataManager;						protected var _bitmaps:Array;			protected var _bitmapsCount:uint;						protected var _loadingBitmaps:Array;						/** Constructor			  *	---------------------------------------------------------------------------- */				public function BitmapDataManager()				{					init();				}							/** reset			  *	---------------------------------------------------------------------- */				public static function reset():void				{					_instance = null;				}							/** getInstance			  *	---------------------------------------------------------------------- */				public static function getInstance():BitmapDataManager				{					if( _instance==null ) _instance = new BitmapDataManager();					return _instance;				}							/** get bitmapsCount			  *	---------------------------------------------------------------------------- */				public function get bitmapsCount():uint				{					return _bitmapsCount;				}							/** init			  *	---------------------------------------------------------------------------- */				public function init()				{					_bitmaps = new Array();					_bitmapsCount = 0;										_loadingBitmaps = new Array();				}							/** addBitmapData			  *	---------------------------------------------------------------------------- */				public function addBitmapData( id:String, bitmapData:BitmapData, overwrite:Boolean=false ):void				{					//trace( "System.totalMemory: "+System.totalMemory );										if( _bitmaps[id] == undefined || overwrite )					{						//_bitmaps[id] = bitmapData.clone();						_bitmaps[id] = new BitmapDataObject( id, bitmapData, overwrite );					}										//trace( "System.totalMemory: "+System.totalMemory );				}							/** getBitmapData			  *	---------------------------------------------------------------------------- */				public function getBitmapData( id:String ):BitmapDataObject				{					if( _bitmaps[id] != undefined )						return _bitmaps[id];										return null;				}							/** clearCache			  *	---------------------------------------------------------------------------- */				public function clearCache():void				{					for( var i in _bitmaps )					{						BitmapDataObject(_bitmaps[i]).destroy();						_bitmaps[i] = null;						dispatchEvent( new CustomEvent("onClearBitmap", {id:i}) );					}										_bitmaps = new Array();										_bitmapsCount = 0;				}							/** loadBitmapToCache			  *	---------------------------------------------------------------------------- *			  *	Loads bitmap data and caches it in the system.			  *	---------------------------------------------------------------------------- */				public function loadBitmapToCache( url:String, cacheId:String ):void				{					_loadingBitmaps.push( {url:url, cacheId:cacheId} );										var bitmapLoader:Loader = new Loader();						bitmapLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, handleLoadBitmapComplete, false, 0, true );						bitmapLoader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, handleLoadBitmapError, false, 0, true );						bitmapLoader.load( new URLRequest(url), new LoaderContext(true, ApplicationDomain.currentDomain) );				}								protected function handleLoadBitmapComplete( event:Event ):void				{					event.currentTarget.removeEventListener( Event.COMPLETE, handleLoadBitmapComplete );					event.currentTarget.removeEventListener( IOErrorEvent.IO_ERROR, handleLoadBitmapError );										var obj:Object;										for( var i:int=0; i<_loadingBitmaps.length; ++i )					{						if( LoaderInfo(event.currentTarget).url.search(_loadingBitmaps[i].url) >= 0 )						{							var bitmapData:BitmapData = new BitmapData( event.currentTarget.content.width, event.currentTarget.content.height, true, 0x00FFFFFF );								bitmapData.draw( event.currentTarget.content );															addBitmapData( _loadingBitmaps[i].cacheId, bitmapData );														obj = _loadingBitmaps[i];							_loadingBitmaps.splice( i, 1 );							break;						}					}										//trace( "cacheId: "+obj.cacheId );					//trace( "url: "+obj.url );										dispatchEvent( new CustomEvent(Event.COMPLETE, obj) );				}								protected function handleLoadBitmapError( event:IOErrorEvent ):void				{					event.currentTarget.removeEventListener( Event.COMPLETE, handleLoadBitmapComplete );					event.currentTarget.removeEventListener( IOErrorEvent.IO_ERROR, handleLoadBitmapError );										var obj:Object;										for( var i:int=0; i<_loadingBitmaps.length; ++i )					{						if( _loadingBitmaps[i].url == LoaderInfo(event.currentTarget).url )						{							obj = _loadingBitmaps[i];							_loadingBitmaps.splice( i, 1 );							break;						}					}										dispatchEvent( new CustomEvent(IOErrorEvent.IO_ERROR, obj) );				}		}			}