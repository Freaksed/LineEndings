﻿/** AssetsIndex  *	---------------------------------------------------------------------------- *  *	@desc:  *		A singleton class that tracks which assets have been loaded, which  *		assets are loading.  *	@author:   *		Christian Widodo, [christian@avatarlabs.com]  *	---------------------------------------------------------------------------- */	package com.avatarlabs.utils.cache	{		import flash.display.BitmapData;		import flash.display.MovieClip;		import flash.events.*;		import flash.errors.*;		import flash.geom.Rectangle;		import flash.geom.Matrix;				import com.avatarlabs.utils.cache.BitmapDataManager;		import com.avatarlabs.utils.cache.BitmapDataObject;		import com.avatarlabs.utils.console.ConsoleBroadcaster;		import com.avatarlabs.utils.events.CustomEvent;		import com.avatarlabs.utils.events.EventNotificationCenter;		import com.avatarlabs.utils.loader.CustomLoader;						public class AssetsIndex extends EventDispatcher		{			private static var _instance:AssetsIndex;						private var _loadedAssets:Array;			//private var _loadedAssetsCount:int;			private var _loadingAssets:Array;						private var _bitmapDataManager:BitmapDataManager;						/** Constructor			  *	---------------------------------------------------------------------- */				public function AssetsIndex()				{					_loadedAssets = new Array();					//_loadedAssetsCount = 0;										_loadingAssets = new Array();										_bitmapDataManager = new BitmapDataManager();					_bitmapDataManager.addEventListener( "onClearBitmap", handleBitmapDataManagerClearBitmap, false, 0, true );				}							/** reset			  *	---------------------------------------------------------------------- */				public static function reset():void				{					_instance = null;				}							/** getInstance			  *	---------------------------------------------------------------------- */				public static function getInstance():AssetsIndex				{					if( _instance==null ) _instance = new AssetsIndex();					return _instance;				}							/** bitmapDataManager			  *	---------------------------------------------------------------------- */				public function get bitmapDataManager():BitmapDataManager				{					return _bitmapDataManager;				}							/** loadedAssets			  *	---------------------------------------------------------------------- */				public function addLoadedAsset( id:String ):void				{					//_loadedAssets[o.id] = true;					//this._loadedAssetsCount++;										_loadedAssets[ id ] = true;					//_loadedAssetsCount++;					/*					var tempClip:MovieClip = new (getDefinitionByName("inst_accountingfirm") as Class)();						tempClip.scaleX = tempClip.scaleY = scale;					var tempClipBound:Rectangle = tempClip.getBounds(tempClip);					var tempClipMatrix:Matrix = tempClip.transform.matrix;						tempClipMatrix.tx -= tempClipBound.x * tempClip.scaleX;						tempClipMatrix.ty -= tempClipBound.y * tempClip.scaleY;						//tempClipMatrix.a = 1/scale;						//tempClipMatrix.d = 1/scale;										trace( tempClipBound.width );					trace( tempClip.width );					trace( tempClipBound.x );					trace( tempClipBound.y );										var bitmapData:BitmapData = new BitmapData( tempClip.width, tempClip.height, true, 0x000000 );						bitmapData.draw( tempClip, tempClipMatrix, null, null, null, true );										bitmapDataManager.addBitmapData( "inst_accountingfirm", bitmapData, tempClipMatrix.tx, tempClipMatrix.ty );					bitmapData.dispose();					*/					/*					var tempClip:MovieClip = new (getDefinitionByName(id) as Class)();						tempClip.scaleX = tempClip.scaleY = 3;										var tempClipBound:Rectangle = tempClip.getBounds(tempClip);										var tempClipMatrix:Matrix = tempClip.transform.matrix;						tempClipMatrix.tx -= tempClipBound.x * tempClip.scaleX;						tempClipMatrix.ty -= tempClipBound.y * tempClip.scaleY;										var bitmapData:BitmapData = new BitmapData( tempClip.width, tempClip.height, true, 0x000000 );						bitmapData.draw( tempClip, tempClipMatrix );										_bitmapDataManager.addBitmapData( id, bitmapData, tempClipMatrix.tx, tempClipMatrix.ty );					bitmapData.dispose();					*/				}				public function removeLoadedAsset( id:String ):void				{					if( _loadedAssets[id] != undefined )						delete _loadedAssets[id];				}				public function isAssetLoaded( id:String ):Boolean				{					if( _loadedAssets[id] == true )						return true;										return false;				}							/** loadingAsset			  *	---------------------------------------------------------------------- */				public function addLoadingAsset( id:String ):void				{					_loadingAssets[ id ] = true;				}				public function isAssetLoading( id:String ):Boolean				{					if( _loadingAssets[ id ] == true )						return true;										return false;				}				public function removeLoadingAsset( id:String ):void				{					delete _loadingAssets[ id ];				}											/** handleBitmapDataManagerClearBitmap			  *	---------------------------------------------------------------------- */				private function handleBitmapDataManagerClearBitmap( event:CustomEvent ):void				{					//_loadedAssets[event.customParameters.id] = false;					removeLoadedAsset( event.customParameters.id );				}		}			}