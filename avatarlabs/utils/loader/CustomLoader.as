﻿/**	CustomLoader  *	----------------------------------------------------------------------------------- *  *	@desc: Basic class for loading  *	@developer: James Safechuck, [james@avatarlabs.com]  * Updates: By James Safechuck-080824 changed: reciever to Sprite  * Updates: By James Safechuck-080826 added: unloadAsset()  *	----------------------------------------------------------------------------------- */  	package com.avatarlabs.utils.loader	{		import flash.display.Sprite;		import flash.net.URLRequest;		import flash.display.Loader;		import flash.system.LoaderContext;		import flash.system.ApplicationDomain;		import flash.events.*;		import flash.utils.getDefinitionByName;				import com.avatarlabs.utils.events.CustomEvent;		import com.avatarlabs.utils.console.*;				public class CustomLoader extends EventDispatcher		{			protected var _loader:Loader;			protected var _ldrContext:LoaderContext;						protected var receiver:Sprite;			protected var _content;			protected var _url:String;						/** Constructor			  *	---------------------------------------------------------------------- */				public function CustomLoader():void				{					_loader = new Loader();					_loader.name = "customLoader_mc";										_ldrContext = new LoaderContext( false, ApplicationDomain.currentDomain );					configureListeners( _loader.contentLoaderInfo );									}							/** get content			  *	---------------------------------------------------------------------- */				public function get content():*				{					return this._content;				}							/** get url			  *	---------------------------------------------------------------------- */				public function get url():String				{					return this._url;				}							/** set/get loaderContext			  *	---------------------------------------------------------------------- */				public function set loaderContext( context:LoaderContext ):void				{					_ldrContext = context;				}				public function get loaderContext():LoaderContext				{					return _ldrContext;				}							/** Public			  *	---------------------------------------------------------------------- */				public function loadAsset( receiver:Sprite, url:String ):void				{					//ConsoleBroadcaster.broadcast( "CustomLoader", "loadAsset("+receiver.name+" , "+url+")");										this._url = url;					this.receiver = receiver;										receiver.addChild( _loader );					 					var request:URLRequest = new URLRequest( url );					 					try					{						_loader.load( request, _ldrContext);					}					catch (error:SecurityError)					{						ConsoleBroadcaster.broadcast( "CustomLoader","A SecurityError has occurred.");					}				}							/** unloadAsset			  *	---------------------------------------------------------------------- */				public function unloadAsset():void				{					//ConsoleBroadcaster.broadcast( "CustomLoader","unloadAsset");										_loader.unload();										if ( receiver.getChildByName("customLoader_mc") )						receiver.removeChild( _loader );														}							/** addEventListeners			  *	---------------------------------------------------------------------- */				protected function configureListeners( dispatcher:IEventDispatcher ):void				{					//trace( "dispatcher: "+dispatcher );										dispatcher.addEventListener(Event.COMPLETE, completeHandler);					//dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);					dispatcher.addEventListener(Event.INIT, initHandler);					dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);					//dispatcher.addEventListener(Event.OPEN, openHandler);					dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);					//dispatcher.addEventListener(Event.UNLOAD, unLoadHandler);				}							/** releaseListeners			  *	---------------------------------------------------------------------- */				protected function releaseListeners( dispatcher:IEventDispatcher ):void				{					dispatcher.removeEventListener(Event.COMPLETE, completeHandler);					//dispatcher.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);					dispatcher.removeEventListener(Event.INIT, initHandler);					dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);					//dispatcher.removeEventListener(Event.OPEN, openHandler);					dispatcher.removeEventListener(ProgressEvent.PROGRESS, progressHandler);					//dispatcher.removeEventListener(Event.UNLOAD, unLoadHandler);				}							/** Event Handlers			  *	---------------------------------------------------------------------- */				protected function completeHandler( event:Event ):void				{           			//ConsoleBroadcaster.broadcast( "CustomLoader","completeHandler: " + event.target.content);										releaseListeners( _loader.contentLoaderInfo );										_content = _loader.getChildAt(0);										dispatchEvent( new CustomEvent( "onLoadComplete", { loaderInfo:event.target } ) );				}												protected function initHandler(event:Event):void				{					//ConsoleBroadcaster.broadcast( "CustomLoader","initHandler: " + event);					dispatchEvent( event );				}        										protected function progressHandler( event:ProgressEvent ):void				{					//ConsoleBroadcaster.broadcast( "CustomLoader","progressHandler: bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);					dispatchEvent( new CustomEvent( "onLoadProgress", { loaded:event.bytesLoaded, total:event.bytesTotal } ) );				}								protected function ioErrorHandler( event:IOErrorEvent ):void				{					//ConsoleBroadcaster.broadcast( "CustomLoader","ioErrorHandler: " + event);					dispatchEvent( event );				}		}	}