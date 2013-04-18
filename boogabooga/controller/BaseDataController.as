
/** BaseDataController
  *	---------------------------------------------------------------------------- *
  *	@desc:
  *		Base class for the controllers to load data from the server.
  *	@author: 
  *		Christian Widodo, [christian@avatarlabs.com]
  *	---------------------------------------------------------------------------- */
	package com.boogabooga.controller
	{
		import flash.events.Event;
		import flash.events.EventDispatcher;
		import flash.events.IOErrorEvent;
		import flash.events.FullScreenEvent;
		import flash.events.ProgressEvent;
		import flash.external.ExternalInterface;
		import flash.net.URLLoader;
		import flash.net.URLRequest;
		import flash.net.URLRequestMethod;
		import flash.net.URLVariables;
		
		import com.adobe.serialization.json.JSONDecoder;
		import com.adobe.serialization.json.JSONEncoder;
		import com.avatarlabs.utils.events.CustomEvent;
		import com.avatarlabs.utils.events.EventNotificationCenter;
		import com.avatarlabs.utils.console.ConsoleBroadcaster;
		
		import com.boogabooga.data.SettingsIndex;
		import flash.net.NetConnection;
		import flash.net.Responder;
		import flash.events.NetStatusEvent;
		import flash.events.SecurityErrorEvent;
		
		public class BaseDataController extends EventDispatcher
		{
			protected var _debug:Boolean = false;
			protected var _baseURL:String;
			
			protected var _gateway:String;
			protected var _connection:NetConnection;
			protected var _connectionResponder:Responder;
			
			/** Constructor
			  *	---------------------------------------------------------------------- */
				public function BaseDataController()
				{
					init();
				}
				
			/** init
			  *	---------------------------------------------------------------------- */
				public function init():void
				{
					//DEV LINK
					_baseURL = SettingsIndex.getInstance().baseURL;
					_gateway = SettingsIndex.getInstance().baseURL+"amfphp/gateway.php";
				}
				
			/** loadDataFromServer
			  *	---------------------------------------------------------------------- */
				protected function loadDataFromServer( url:String, data:URLVariables, method:String, onComplete:Function=null, onIOError:Function=null ):void
				{
					//trace( "onComplete: "+onComplete );
					
					var urlRequest:URLRequest = new URLRequest(url);
						urlRequest.data = data;
						urlRequest.method = method;
					
					var urlLoader:URLLoader = new URLLoader();
					
					if( onIOError != null )
						urlLoader.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
					
					if( onComplete != null )
						urlLoader.addEventListener( Event.COMPLETE, onComplete );
					
					urlLoader.load( urlRequest );
					
				}
				
		}
		
	}