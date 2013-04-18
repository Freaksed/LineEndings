
/** FacebookFunctions
  *	---------------------------------------------------------------------------- *
  *	@desc:
  *		Main data index for the game. It's a singleton that you can access from anywhere.
  *	@author: 
  *		Christian Widodo, [christian@avatarlabs.com]
  *	---------------------------------------------------------------------------- */
	package com.boogabooga.controller
	{
		import flash.errors.*;
		import flash.events.*;
		import flash.external.ExternalInterface;
		import flash.geom.Rectangle;
		
		import com.avatarlabs.utils.events.CustomEvent;
		import com.avatarlabs.utils.events.EventNotificationCenter;
		import com.avatarlabs.utils.console.ConsoleBroadcaster;
		//import com.demonsters.debugger.MonsterDebugger;
		import com.facebook.graph.Facebook;
		
		import com.boogabooga.controller.maingame.MainGameController;
		import com.boogabooga.data.SettingsIndex;
		import com.boogabooga.data.StringsIndex;
		import com.boogabooga.data.gamelevel.AbstractGameObject;
		import com.boogabooga.data.gamelevel.God;
		import com.boogabooga.data.gamelevel.Weapon;
		import com.boogabooga.data.maingame.Cryptology;
		import com.boogabooga.data.maingame.RequestCryptology;
		import com.boogabooga.events.BoogaEvent;
		import flash.net.URLLoader;
		import flash.net.URLRequest;
		import flash.net.URLRequestMethod;
		import com.adobe.serialization.json.JSONDecoder;
		
		public class FacebookFunctions extends EventDispatcher
		{
			public var appId:Number;
			protected var _firstName:String;
			protected var _lastName:String;
			protected var _fbId:String;
			protected var _fbProfilePicURL:String;
			protected var _gender:String;
			protected var _email:String;
			protected var _birthday:String;
			protected var _timezone:String;
			protected var _locale:String;
			protected var _accessToken:String;
			protected var _currentCryptologyId:int;
			protected var _isInitialized:Boolean;
			protected var _requestItemId:int;
			protected var _giftItem:AbstractGameObject;
			
			protected var _totalRequests:int;
			protected var _requestsResult:Array;
			//public var getRequestDataResult:Array;
			
			/** Constructor
			  *	---------------------------------------------------------------------- */
				public function FacebookFunctions()
				{
					//MonsterDebugger.initialize( this );
					_isInitialized = false;
				}
				
				public function get firstName():String { return _firstName; }
				public function get lastName():String { return _lastName; }
				public function get fbId():String { return _fbId; }
				public function get fbProfilePicURL():String { return _fbProfilePicURL; }
				public function get locale():String { return _locale; }
				public function get birthday():String { return _birthday; }
				public function get gender():String { return _gender; }
				public function get email():String { return _email; }
				public function get timezone():String { return _timezone; }
				public function get isInitialized():Boolean { return _isInitialized; }
				
			/** init
			  *	---------------------------------------------------------------------- */
				public function init():void
				{
					Facebook.init( String(SettingsIndex.getInstance().appId), handleFacebookInitComplete, null, SettingsIndex.getInstance().accessToken );
					
					ExternalInterface.addCallback( "handleGetCreditsBalanceComplete", handleGetCreditsBalanceComplete );
					
				}
				
				protected function handleFacebookInitComplete( success:Object, fail:Object ):void
				{
					ConsoleBroadcaster.broadcast( "FacebookFunctions", "handleFacebookInitComplete();" );
					ConsoleBroadcaster.broadcast( "FacebookFunctions", "succes: "+success );
					ConsoleBroadcaster.broadcast( "FacebookFunctions", "fail: "+fail );
					
					_isInitialized = true;
					
					if( success != null )
						getFBUserInfo();
					else
						dispatchEvent( new BoogaEvent(BoogaEvent.LOADING_ERROR) );
				}
				
				protected function getFBUserInfo():void
				{
					ConsoleBroadcaster.broadcast( "FacebookFunctions", "getFBUserInfo();" );
					
					Facebook.api("me", handleGetFBUserInfoComplete );
				}
				
				protected function handleGetFBUserInfoComplete( result:Object, fail:Object ):void
				{
					ConsoleBroadcaster.broadcast( "FacebookFunctions", "handleGetFBUserInfoComplete();" );
					
					for( var i in result )
					{
						ConsoleBroadcaster.broadcast( "FacebookFunctions", i+": "+result[i] );
					}
					
					ConsoleBroadcaster.broadcast( "FacebookFunctions", "fail: "+fail );
					
					_firstName = result['first_name'];
					_lastName = result['last_name'];
					_fbId = result['id'];
					_locale = result['locale'].split('_')[0];
					_timezone = result['timezone'];
					
					trace( "_locale: "+_locale );
					
					//dispatchEvent( new CustomEvent("onFBLoginComplete") );
					Facebook.fqlQuery("SELECT pic_square, birthday_date, email, sex FROM user WHERE uid="+_fbId, handleGetMoreUserInfoComplete );
				}
				
				protected function handleGetMoreUserInfoComplete( result:Object, fail:Object ):void
				{
					ConsoleBroadcaster.broadcast( "FacebookFunctions", "handleGetMoreUserInfoComplete" );
					
					ConsoleBroadcaster.broadcast( "FacebookFunctions", ""+result[0] );
					
					for( var i in result[0] )
					{
						ConsoleBroadcaster.broadcast( "FacebookFunctions", i+": "+result[0][i] );
					}
					
					_fbProfilePicURL = result[0]['pic_square'];
					
					if( result[0]['birthday_date'] != null )
					{
						var birthdaySplit = result[0]['birthday_date'].split('/');
						if( birthdaySplit.length == 3 )
							_birthday = birthdaySplit[2]+'-'+birthdaySplit[0]+'-'+birthdaySplit[1];
						else
							_birthday = '0000-00-00';
					}
					else
					{
						_birthday = '0000-00-00';
					}
					
					//ConsoleBroadcaster.broadcast( "FacebookFunctions", 'birthday: '+_birthday );
					
					_email = result[0]['email'];
					_gender = result[0]['sex'];
					
					dispatchEvent( new CustomEvent("onGetUserInfoComplete", {fbProfilePicURL:_fbProfilePicURL}) );
				}
				
			/** purchaseToDigEarly
			  *	---------------------------------------------------------------------- */
				public function purchaseToDigEarly( islandId:int ):void
				{
					ConsoleBroadcaster.broadcast( "FacebookFunctions", "purchaseToDigEarly("+islandId+");" );
					
					/*
					var order_info = { "title":"Booga Booga",
						"description":"Purchase to dig early",
						//"price":"10", // Price should be passed in from database and in the php callback
						"image_url":"http://www.facebook.com/images/gifts/21.png",
						"product_url":"http://www.facebook.com/images/gifts/21.png"
					};
					*/
					var orderInfo = {};
						orderInfo.type = "DigEarly";
						orderInfo.island_id = islandId;
					
					var obj = {
						order_info: orderInfo
					};
					
					//Facebook.ui("pay", obj, onPurchaseCryptology);
					Facebook.ui("pay", obj, handlePurchaseToDigEarlyCallback );
				}
				
				protected function handlePurchaseToDigEarlyCallback( result ):void
				{
					ConsoleBroadcaster.broadcast( "FacebookFunctions", "handlePurchaseToDigEarlyCallback();" );
					
					for( var i in result )
						ConsoleBroadcaster.broadcast( "FacebookFunctions", "result."+i+": "+result[i] );
					
					ConsoleBroadcaster.broadcast( "FacebookFunctions" );
					
					if( result['order_id'] )
					{
						getFacebookCreditsBalance();
						dispatchEvent( new BoogaEvent(BoogaEvent.ON_PURCHASE_RESULT, {type:BoogaEvent.ON_PURCHASE_SUCCESS}) );
					}
					else
					{
						dispatchEvent( new BoogaEvent(BoogaEvent.ON_PURCHASE_RESULT, {type:BoogaEvent.ON_PURCHASE_FAIL}) );
					}
				}
				
			/** purchaseItem
			  *	---------------------------------------------------------------------- */
				public function purchaseItem( type:String, itemId:int, priceId:int, additionalValue:String='' ):void
				{
					var orderInfo:Object = {};
						orderInfo.type = type;
						orderInfo.item_id = itemId;
						orderInfo.price_id = priceId;
						orderInfo.locale = MainGameController.getInstance().currentUser.locale;
						orderInfo.additional_value = additionalValue;
					
					var obj = {
						order_info: orderInfo
					};
					
					Facebook.ui("pay", obj, handlePurchaseItemCallback );
				}
				
				protected function handlePurchaseItemCallback( result ):void
				{
					ConsoleBroadcaster.broadcast( "FacebookFunctions", "handlePurchaseItemCallback();" );
					
					for( var i in result )
						ConsoleBroadcaster.broadcast( "FacebookFunctions", "result."+i+": "+result[i] );
					
					if( result['order_id'] )
					{
						getFacebookCreditsBalance();
						dispatchEvent( new BoogaEvent(BoogaEvent.ON_PURCHASE_SUCCESS) );
					}
					else
					{
						dispatchEvent( new BoogaEvent(BoogaEvent.ON_PURCHASE_FAIL) );
					}
				}
				
			/** sendGiftsToFriends
			  *	---------------------------------------------------------------------- */
				public function sendGiftsToFriends( item:AbstractGameObject, excludeIds:Array ):void
				{
					//_requestItemId = item.id;
					_giftItem = item;
					
					var message:String = StringsIndex.getInstance().getStringByName('FB_SEND_GIFT_DESCRIPTION');
						message = message.replace(/%%WEAPON_NAME%%/, StringsIndex.getInstance().getString(String(item.name)));
					
					var data:Object = new Object();
						data.message = message;
						//data.filters = ["app_users"];
						data.media = {type:'image', src:SettingsIndex.getInstance().contentURL+item.iconURL};
						data.title = StringsIndex.getInstance().getStringByName('FB_SEND_GIFT_HEADER');
						data.exclude_ids = excludeIds;
					
					Facebook.ui( "apprequests", data, handleSendGiftsToFriendsRequestCallback );
				}
				
				protected function handleSendGiftsToFriendsRequestCallback( result ):void
				{
					ConsoleBroadcaster.broadcast( "FacebookFunctions", "handleSendGiftsToFriendsRequestCallback();" );
					//ConsoleBroadcaster.broadcast( "FacebookFunctions", "result: "+result );
					
					if( result != null )
					{
						for( var j in result )
							ConsoleBroadcaster.broadcast( "FacebookFunctions", "result."+j+": "+result[j] );
						
						//result.request
						//result.to
						_totalRequests = result.to.length;
						_requestsResult = new Array();
						/*
						for( var i:int=0; i<result.to.length; ++i )
						{
							//Facebook.api( "/"+result.request_ids[i]+"/", handleGetGiftRequestsCallback );
							_requestsResult.push( {id:result.request+'_'+result.to[i], from:_fbId, to:result.to} );
						}
						*/
						var giftType:String = "";
						if( _giftItem is Weapon )
							giftType = "Weapon";
						else if( _giftItem is God )
							giftType = "God";
						
						dispatchEvent( new CustomEvent("onComplete", {itemId:_giftItem.id, itemType:giftType, fromFBId:_fbId, requestId:result.request, toIds:result.to}) );
					}
					else
					{
						dispatchEvent( new CustomEvent("onCancel") );
					}
				}
				/*
				protected function handleGetGiftRequestsCallback( result, fail ):void
				{
					ConsoleBroadcaster.broadcast( "FacebookFunctions", "handleGetGiftRequestsCallback();" );
					
					ConsoleBroadcaster.broadcast( "FacebookFunctions", "data: "+result );
					ConsoleBroadcaster.broadcast( "FacebookFunctions", "result is array ? "+(result is Array) );
					ConsoleBroadcaster.broadcast( "FacebookFunctions", "result is object ? "+(result is Object) );
					
					var i, j;
					
					for( i in result )
					{
						ConsoleBroadcaster.broadcast( "FacebookFunctions", i+" - "+result[i] );
						
						if( i == 'to' )
						{
							for( j in result[i] )
							{
								ConsoleBroadcaster.broadcast( "FacebookFunctions", i+" - "+j+" - "+result[i][j] );
							}
						}
					}
					
					//getRequestDataResult.push( result );
					_requestsResult.push( result );
					
					if( _requestsResult.length == this._totalRequests )
					{
						var giftType:String = "";
						if( _giftItem is Weapon )
							giftType = "Weapon";
						else if( _giftItem is God )
							giftType = "God";
						
						dispatchEvent( new CustomEvent("onComplete", {itemId:_giftItem.id, itemType:giftType, requests:_requestsResult}) );
					}
				}
				*/
				public function requestGiftsFromFriends( item:AbstractGameObject, friendId:String ):void
				{
					_giftItem = item;
					
					var message:String = StringsIndex.getInstance().getStringByName('FB_ASK_GIFT_DESCRIPTION');
						message = message.replace(/%%WEAPON_NAME%%/, StringsIndex.getInstance().getString(String(item.name)));
					
					var data:Object = new Object();
						data.message = message;
						//data.filters = ["app_users"];
						data.media = {type:'image', src:SettingsIndex.getInstance().contentURL+item.iconURL};
						data.title = StringsIndex.getInstance().getStringByName('FB_ASK_GIFT_HEADER');
						//data.exclude_ids = excludeIds;
						data.to = friendId;
					
					Facebook.ui( "apprequests", data, handleRequestGiftsFromFriendsRequestCallback );
				}
				
				protected function handleRequestGiftsFromFriendsRequestCallback( result ):void
				{
					ConsoleBroadcaster.broadcast( "FacebookFunctions", "handleRequestGiftsFromFriendsRequestCallback();" );
					
					if( result != null )
					{
						_totalRequests = result.to.length;
						_requestsResult = new Array();
						/*
						for( var i:int=0; i<result.request_ids.length; ++i )
						{
							Facebook.api( "/"+result.request_ids[i]+"/", handleGetGiftRequestsCallback );
						}
						*/
						var giftType:String = "";
						if( _giftItem is Weapon )
							giftType = "Weapon";
						else if( _giftItem is God )
							giftType = "God";
						
						dispatchEvent( new CustomEvent("onComplete", {itemId:_giftItem.id, itemType:giftType, fromFBId:_fbId, requestId:result.request, toIds:result.to}) );
					}
					else
					{
						dispatchEvent( new CustomEvent("onCancel") );
					}
				}
				
			/** getFacebookCreditsBalance
			  *	---------------------------------------------------------------------------- *
			  *	---------------------------------------------------------------------------- */
				public function getFacebookCreditsBalance():void
				{
					/*
					var urlRequest:URLRequest = new URLRequest(SettingsIndex.getInstance().baseURL+"fb_get_balance.php");
						urlRequest.method = URLRequestMethod.POST;
						urlRequest.data = { user_id:MainGameController.getInstance().currentUser.fbId };
					
					var urlLoader:URLLoader = new URLLoader();
						urlLoader.addEventListener( Event.COMPLETE, handleGetBalanceComplete, false, 0, true );
						urlLoader.addEventListener( IOErrorEvent.IO_ERROR, handleGetBalanceError, false, 0, true );
						urlLoader.load( urlRequest );
					*/
					
					ConsoleBroadcaster.broadcast( "FacebookFunctions", "session token: "+Facebook.getAuthResponse().accessToken );
					
					//https://graph.facebook.com/oauth/access_token?client_id=YOUR_APP_ID&client_secret=YOUR_APP_SECRET&grant_type=client_credentials
					//Facebook.api(
					//Facebook.callRestAPI( "users.getStandardInfo?uids="+_fbId+"&fields=credit_balance&access_token=213784761996882|9xww9ODcIshts1QzIbsR6nFVIhU&format=json", handleGetBalance, {uids:_fbId, fields:"credit_balance", format:"json", access_token:"213784761996882|9xww9ODcIshts1QzIbsR6nFVIhU"} );
					
					ExternalInterface.call( "getCreditsBalance" );
				}
				
				protected function handleGetCreditsBalanceComplete( creditBalance:Number ):void
				{
					ConsoleBroadcaster.broadcast( "FacebookFunctions", "handleGetCreditsBalanceComplete("+creditBalance+");" );
					dispatchEvent( new BoogaEvent(BoogaEvent.ON_FACEBOOK_GET_BALANCE_COMPLETE, {balance:creditBalance}) );
				}
				
			/** addMoreFacebookCredits
			  *	---------------------------------------------------------------------------- *
			  *	---------------------------------------------------------------------------- */
				public function addMoreFacebookCredits():void
				{
					Facebook.ui( 'pay', {credits_purchase:true}, handleAddMoreFacebookCreditsComplete );
				}
				
				protected function handleAddMoreFacebookCreditsComplete( result ):void
				{
					ConsoleBroadcaster.broadcast( "FacebookFunctions", "handleAddMoreCreditsComplete();" );
					
					getFacebookCreditsBalance();
				}
				
				public function postToWall( description:String ):void
				{
					/*
					var obj = {
						method: 'feed',
						link: 'https://apps.facebook.com/boogabooga_dev/',
						picture: 'http://fbrell.com/f8.jpg',
						name: 'Booga Booga',
						description:'ADVENTURE_LEVEL_SHARE'
					}
					
					FB.ui(obj, function(response) { console.log( 'post id: '+response.post_id ); });
					*/
					
					var data:Object = new Object();
						data.link = 'https://apps.facebook.com/boogabooga/';
						data.name = 'Play Booga! Booga!';
						data.picture = SettingsIndex.getInstance().contentURL+'booga_ape_logo.png';
						data.description = description;
					
					Facebook.ui( 'feed', data, handlePostToWallComplete );
				}
				
				protected function handlePostToWallComplete( result ):void
				{
					ConsoleBroadcaster.broadcast( "FacebookFunctions", "handlePostToWallComplete();" );
					
					ConsoleBroadcaster.broadcast( "FacebookFunctions", "result: "+result );
					
					for( var i in result )
					{
						ConsoleBroadcaster.broadcast( "FacebookFunctions", "result["+i+"]: "+result[i] );
					}
					
					if( result )
					{
						ConsoleBroadcaster.broadcast( "FacebookFunctions", "posted!" );
						dispatchEvent( new BoogaEvent(BoogaEvent.ON_SHARE_COMPLETE) );
					}
					else
					{
						ConsoleBroadcaster.broadcast( "FacebookFunctions", "not posted!" );
						dispatchEvent( new BoogaEvent(BoogaEvent.ON_SHARE_CANCEL) );
					}
					//dispatchEvent( new Event() );
				}
				
				/*
				protected function handleGetBalance( response:Object, fail:Object ):void
				{
					ConsoleBroadcaster.broadcast( "FacebookFunctions", "handleGetBalance();" );
					
					for( var i in response )
						ConsoleBroadcaster.broadcast( "FacebookFunctions", "response."+i+": "+response[i] );
					
				}
				
				protected function handleGetBalanceComplete( event:Event ):void
				{
					ConsoleBroadcaster.broadcast( "FacebookFunctions", "handleGetBalanceComplete();" );
					
					ConsoleBroadcaster.broadcast( "FacebookFunctions", "balance: "+event.currentTarget.data );
					
					try
					{
						var data = new JSONDecoder(event.currentTarget.data);
						
						dispatchEvent( new BoogaEvent(BoogaEvent.ON_FACEBOOK_GET_BALANCE_COMPLETE, {balance:data[0].credit_balance}) );
					}
					catch( e:Error )
					{
						
					}
				}
				
				protected function handleGetBalanceError( event:IOErrorEvent ):void
				{
					ConsoleBroadcaster.broadcast( "FacebookFunctions", "handleGetBalanceError();" );
					
					trace( event.errorID+" -- "+event.text );
				}
				*/
			/** askFriendsForCryptology
			  *	---------------------------------------------------------------------- */
			  /*
				public function askFriendsForCryptology( cryptology:Cryptology ):void
				{
					_currentCryptologyId = cryptology.id;
					
					var data:Object = new Object();
						//data.data = { cryptologyId:cryptology.id };
						//data.data = cryptology.id;
						data.message = "Please help me with this cryptology, "+cryptology.name;
						data.filters = ["app_users"];
						data.media = {type:'image', src:SettingsIndex.getInstance().contentURL+cryptology.iconURL};
						data.title = "Help with cryptology";
						
					Facebook.ui( "apprequests", data, handleAppRequestsCallback );
				}
				
				protected function handleAppRequestsCallback( result ):void
				{
					ConsoleBroadcaster.broadcast( "CryptologyView", "handleAppRequestsCallback("+result.request_ids+");" );
					
					//ConsoleBroadcaster.broadcast( "CryptologyView", "result.request_ids.length: "+result.request_ids.length );
					
					_totalRequests = result.request_ids.length;
					
					for( var i:int=0; i<result.request_ids.length; ++i )
					{
						Facebook.api( "/"+result.request_ids[i]+"/", handleGetAppRequestDataCallback );
					}
					
					//getRequestDataResult = [];
					_requestsResult = new Array();
					
					ConsoleBroadcaster.broadcast( "CryptologyView", "api call -- "+"/?ids="+result.request_ids.join(",") );
					//Facebook.api( "/?ids="+result.request_ids.join(","), handleGetAppRequestDataCallback );
					//Facebook.api( "/"+result.request_ids[0]+"/", handleGetAppRequestDataCallback );
				}
				
				protected function handleGetAppRequestDataCallback( result, fail ):void
				{
					ConsoleBroadcaster.broadcast( "FacebookFunctions", "handleGetAppRequestDataCallback();" );
					
					ConsoleBroadcaster.broadcast( "FacebookFunctions", "data: "+result );
					ConsoleBroadcaster.broadcast( "FacebookFunctions", "result is array ? "+(result is Array) );
					ConsoleBroadcaster.broadcast( "FacebookFunctions", "result is object ? "+(result is Object) );
					
					for( var i in result )
					{
						ConsoleBroadcaster.broadcast( "FacebookFunctions", i+" - "+result[i] );
					}
					
					//getRequestDataResult.push( result );
					_requestsResult.push( result );
					
					if( _requestsResult.length == this._totalRequests )
						dispatchEvent( new CustomEvent("onComplete", {id:_requestItemId, result:_requestsResult}) );
				}
				*/
				
				
		}
		
	}