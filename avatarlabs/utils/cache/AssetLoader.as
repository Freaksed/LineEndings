﻿/** AssetLoader  *	---------------------------------------------------------------------------- *  *	@desc:  *		Responsible for storing data  *	@developer: Christian Widodo, [christian@avatarlabs.com]  *	---------------------------------------------------------------------------- */	package com.avatarlabs.utils.cache	{		import flash.events.*;		import flash.errors.*;		import flash.system.ApplicationDomain;		import flash.system.Security;		import flash.system.SecurityDomain;		import flash.system.LoaderContext;				import com.hydrotik.queueloader.QueueLoader;		import com.hydrotik.queueloader.QueueLoaderEvent;		import com.hydrotik.queueloader.QueueLoaderConst;		import com.avatarlabs.utils.cache.AssetsIndex;		import com.avatarlabs.utils.console.ConsoleBroadcaster;		import com.avatarlabs.utils.events.AssetLoaderEvent;		import com.avatarlabs.utils.events.AssetLoaderEvent;		import com.avatarlabs.utils.events.EventNotificationCenter;				public class AssetLoader extends EventDispatcher		{			private var _debug:Boolean;			private var _autoKill:Boolean;						//private var _cml:CompositeMassLoader;			private var _queueLoader:QueueLoader;						/** Constructor			  *	---------------------------------------------------------------------- */				public function AssetLoader()				{					_debug = true;					_autoKill = false;				}								public function set autoKill( b:Boolean ):void { _autoKill = b; }								public function get queueLoader():QueueLoader { return _queueLoader; }				public function get isLoading():Boolean { return _queueLoader ? _queueLoader.isLoading() : false; }							/** addAssetToLoad			  *	---------------------------------------------------------------------- */				public function addAssetToLoad( id:String, assetURL:String ):void				{					//if( _debug )					//	ConsoleBroadcaster.broadcast( "AssetLoader", "AssetsIndex.getInstance().isAssetLoaded("+id+"): "+AssetsIndex.getInstance().isAssetLoaded(id) );										if( AssetsIndex.getInstance().isAssetLoaded(id) != true && AssetsIndex.getInstance().isAssetLoading(id) != true )					{						if( !_queueLoader )						{							_queueLoader = new QueueLoader( true, new LoaderContext(false, ApplicationDomain.currentDomain), true, "AssetLoader" );							_queueLoader.addEventListener( QueueLoaderEvent.QUEUE_START, handleQueueStart );							_queueLoader.addEventListener( QueueLoaderEvent.QUEUE_PROGRESS, handleQueueProgress );							_queueLoader.addEventListener( QueueLoaderEvent.QUEUE_COMPLETE, handleQueueComplete );							_queueLoader.addEventListener( QueueLoaderEvent.ITEM_START, handleItemStart );							_queueLoader.addEventListener( QueueLoaderEvent.ITEM_PROGRESS, handleItemProgress );							_queueLoader.addEventListener( QueueLoaderEvent.ITEM_COMPLETE, handleItemComplete );							_queueLoader.addEventListener( QueueLoaderEvent.ITEM_ERROR, handleItemError );							_queueLoader.addEventListener( QueueLoaderEvent.ITEM_HTTP_STATUS, handleItemHTTPStatus );						}												_queueLoader.addItem( assetURL, null, {title:id} );												AssetsIndex.getInstance().addLoadingAsset(id);												if( _debug ) ConsoleBroadcaster.broadcast( "AssetLoader", "loading asset with id "+id );					}					else					{						//if( _debug )						//	ConsoleBroadcaster.broadcast( "AssetLoader", "asset with id "+id+" is already loaded or is loading" );					}									}							/** startLoadAssets			  *	---------------------------------------------------------------------- */				public function startLoadAssets():void				{					if( _debug ) ConsoleBroadcaster.broadcast( "AssetLoader", "startLoadAssets();" );										//trace( "_queueLoader: "+_queueLoader );										if( _queueLoader )					{						trace( "_queueLoader item length: "+_queueLoader.getQueuedItems().length );												if( _queueLoader.getQueuedItems().length > 0 )						{							_queueLoader.execute();						}						else						{							//trace('queueLoader.length:' + _queueLoader.getQueuedItems().length ) 													dispatchEvent( new AssetLoaderEvent(AssetLoaderEvent.COMPLETE) );						}					}					else					{						dispatchEvent( new AssetLoaderEvent(AssetLoaderEvent.COMPLETE) );					}				}							/** handleQueueStart			  *	---------------------------------------------------------------------- */				private function handleQueueStart( event:QueueLoaderEvent ):void				{					if( _debug ) ConsoleBroadcaster.broadcast( "AssetLoader", "handleQueueStart();" );										dispatchEvent( new AssetLoaderEvent(AssetLoaderEvent.START) );				}							/** handleQueueProgress			  *	---------------------------------------------------------------------- */				private function handleQueueProgress( event:QueueLoaderEvent ):void				{					//if( _debug ) ConsoleBroadcaster.broadcast( "AssetLoader", "handleQueueProgress("+event.queuepercentage+");" );										dispatchEvent( new AssetLoaderEvent(AssetLoaderEvent.PROGRESS, event.bytesLoaded, event.bytesTotal, event.queuepercentage) );				}							/** handleQueueComplete			  *	---------------------------------------------------------------------- */				private function handleQueueComplete( event:QueueLoaderEvent ):void				{					if( _debug ) ConsoleBroadcaster.broadcast( "AssetLoader", "handleQueueComplete();" );										if( _queueLoader.getQueuedItems().length > 0 )					{						//There are items that are not laoded properly, do something here!												dispatchEvent( new AssetLoaderEvent(AssetLoaderEvent.ERROR) );					}					else					{						//ConsoleBroadcaster.broadcast( "AssetLoader", "onComplete!" );												_queueLoader.dispose();												if( _autoKill )						{							_queueLoader.removeEventListener( QueueLoaderEvent.QUEUE_START, handleQueueStart );							_queueLoader.removeEventListener( QueueLoaderEvent.QUEUE_PROGRESS, handleQueueProgress );							_queueLoader.removeEventListener( QueueLoaderEvent.QUEUE_COMPLETE, handleQueueComplete );							_queueLoader.removeEventListener( QueueLoaderEvent.ITEM_START, handleItemStart );							_queueLoader.removeEventListener( QueueLoaderEvent.ITEM_PROGRESS, handleItemProgress );							_queueLoader.removeEventListener( QueueLoaderEvent.ITEM_COMPLETE, handleItemComplete );							_queueLoader.removeEventListener( QueueLoaderEvent.ITEM_ERROR, handleItemError );							_queueLoader.removeEventListener( QueueLoaderEvent.ITEM_HTTP_STATUS, handleItemHTTPStatus );							_queueLoader = null;						}												dispatchEvent( new AssetLoaderEvent(AssetLoaderEvent.COMPLETE) );					}				}							/** handleItemStart			  *	---------------------------------------------------------------------- */				private function handleItemStart( event:QueueLoaderEvent ):void				{									}							/** handleItemProgress			  *	---------------------------------------------------------------------- */				private function handleItemProgress( event:QueueLoaderEvent ):void				{									}							/** handleItemComplete			  *	---------------------------------------------------------------------- */				private function handleItemComplete( event:QueueLoaderEvent ):void				{					if( _debug ) ConsoleBroadcaster.broadcast( "AssetLoader", "handleItemComplete();" );										AssetsIndex.getInstance().removeLoadingAsset( event.title );					AssetsIndex.getInstance().addLoadedAsset( event.title );										dispatchEvent( new AssetLoaderEvent(AssetLoaderEvent.ITEM_COMPLETE, 0, 0, event.queuepercentage, {content:event.content, id:event.title, fileType:event.fileType}) );				}							/** handleItemError			  *	---------------------------------------------------------------------- */				private function handleItemError( event:QueueLoaderEvent ):void				{					if( _debug ) ConsoleBroadcaster.broadcast( "AssetLoader", "handleItemError("+event.title+", "+event.message+");" );										//trace( event.message );										dispatchEvent( new AssetLoaderEvent(AssetLoaderEvent.ERROR, 0, 0, event.queuepercentage, {id:event.title, message:event.message}) );				}							/** handleItemHTTPStatus			  *	---------------------------------------------------------------------- */				private function handleItemHTTPStatus( event:QueueLoaderEvent ):void				{					if( _debug ) ConsoleBroadcaster.broadcast( "AssetLoader", "handleItemHTTPStatus("+event.message+");" );										//dispatchEvent( new AssetLoaderEvent(AssetLoaderEvent.ERROR, 0, 0, event.queuepercentage, {id:event.title, message:event.message}) );				}						}			}