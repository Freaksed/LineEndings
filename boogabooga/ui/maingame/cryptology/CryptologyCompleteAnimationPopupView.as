﻿/** CryptologyCompleteAnimationPopupView  *	---------------------------------------------------------------------------- *  *	@author:  *		Christian Widodo [christian@avatarlabs.com]  *	---------------------------------------------------------------------------- */ 	package com.boogabooga.ui.maingame.cryptology	{		import flash.display.Bitmap;		import flash.display.BitmapData;		import flash.display.Loader;		import flash.display.MovieClip;		import flash.events.Event;		import flash.events.EventDispatcher;		import flash.net.URLRequest;		import flash.system.ApplicationDomain;		import flash.system.LoaderContext;		import flash.text.TextField;		import flash.text.TextFieldAutoSize;				import com.avatarlabs.utils.cache.BitmapDataManager;		import com.avatarlabs.utils.console.ConsoleBroadcaster;		import com.avatarlabs.utils.events.AssetLoaderEvent;		import com.avatarlabs.utils.events.CustomEvent;		import com.avatarlabs.utils.loader.CustomLoader;		import com.avatarlabs.utils.text.TextFormatting;		import com.avatarlabs.utils.userinterface.UIButton;		import com.avatarlabs.utils.userinterface.UIScroller;		import com.avatarlabs.utils.userinterface.UISlider;				import com.boogabooga.controller.maingame.MainGameController;		import com.boogabooga.data.maingame.Village;		import com.boogabooga.data.gamelevel.AbstractGameObject;		import com.boogabooga.data.gamelevel.GameLevelDataIndex;		import com.boogabooga.data.maingame.Treasure;		import com.boogabooga.data.maingame.Cryptology;		import com.boogabooga.data.maingame.User;		import com.boogabooga.events.BoogaEvent;				public class CryptologyCompleteAnimationPopupView extends MovieClip		{			protected var _cryptology:Cryptology;						protected var _user:User;			protected var _friend:User;						/**	Stage Instances **/			public var symbolsAnimation_mc:MovieClip;			public var fbUser_mc:MovieClip;			public var friendFBUser_mc:MovieClip;			public var connect_mc:UIButton;			public var exit_mc:UIButton;			public var fullSymbol_mc:CryptologySymbol;			public var leftSymbol_mc:CryptologySymbol;			public var rightSymbol_mc:CryptologySymbol;			public var name_mc:MovieClip;			/**	End of Stage Instances **/						/** Constructor			  *	---------------------------------------------------------------------------- */				public function CryptologyCompleteAnimationPopupView()				{					init();				}								public function init():void				{					leftSymbol_mc = symbolsAnimation_mc.leftSymbol_mc;					leftSymbol_mc.showLeftSymbol();					rightSymbol_mc = symbolsAnimation_mc.rightSymbol_mc;					rightSymbol_mc.showRightSymbol();					fullSymbol_mc = symbolsAnimation_mc.fullSymbol_mc;					name_mc = symbolsAnimation_mc.name_mc;										connect_mc.addEventListener( "onClick", handleConnectClicked );					exit_mc.addEventListener( "onClick", handleExitClicked );				}								public function setCryptology( cryptology:Cryptology ):void				{					_cryptology = cryptology;										leftSymbol_mc.initItem( cryptology );					rightSymbol_mc.initItem( cryptology );					fullSymbol_mc.initItem( cryptology );					//TextFormatting.formatTextWithFontName( name_mc.label_txt, cryptology.name, "SF Fedora", false, TextFieldAutoSize.CENTER );					TextFormatting.formatTextWithFontName( name_mc.label_txt, cryptology.name, "Lithos Pro Black", false, TextFieldAutoSize.CENTER );										symbolsAnimation_mc.visible = true;				}							/** setFBUser			  *	---------------------------------------------------------------------------- */				public function setFBUser( user:User ):void				{					while( fbUser_mc.image_mc.numChildren > 0 )						fbUser_mc.image_mc.removeChildAt(0);										_user = user;										if( BitmapDataManager.getInstance().getBitmapData("UserFBProfilePic_"+user.id) == null )					{						var iconLoader:Loader = new Loader();							iconLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, handleLoadIconComplete, false, 0, true );							iconLoader.load( new URLRequest(user.fbProfilePicURL), new LoaderContext(true, ApplicationDomain.currentDomain) );					}					else					{						//fbUser_mc.image_mc.addChild( new Bitmap(BitmapDataManager.getInstance().getBitmapData("UserFBProfilePic_"+user.id).bitmapData) );						addUserImage();					}										//fbUser_mc.name_txt.text = user.firstName;					TextFormatting.formatTextWithFontName( fbUser_mc.name_txt, user.name, "Lithos Pro Black", false, TextFieldAutoSize.CENTER );				}							/** handleLoadIconComplete			  *	---------------------------------------------------------------------------- */				protected function handleLoadIconComplete( event:Event ):void				{					event.currentTarget.removeEventListener( Event.COMPLETE, handleLoadIconComplete );										var bitmapData:BitmapData = new BitmapData( event.currentTarget.content.width, event.currentTarget.content.height );						bitmapData.draw( event.currentTarget.content );										BitmapDataManager.getInstance().addBitmapData( "UserFBProfilePic_"+_user.id, bitmapData );					_user = null;										addUserImage();				}								function addUserImage():void				{					var bitmap:Bitmap = new Bitmap( BitmapDataManager.getInstance().getBitmapData("UserFBProfilePic_"+_user.id).bitmapData );						bitmap.smoothing = true;					var ratio:Number;										if( bitmap.width > bitmap.height )					{						ratio = 50 / bitmap.width;						bitmap.width = 50;						bitmap.height = bitmap.height * ratio;					}					else					{						ratio = 50 / bitmap.height;						bitmap.width = bitmap.width * ratio;						bitmap.height = 50;					}										bitmap.x = -bitmap.width/2;					bitmap.y = -bitmap.height/2;										fbUser_mc.image_mc.addChild( bitmap );				}							/** setFriendFBUser			  *	---------------------------------------------------------------------------- */				public function setFriendFBUser( user:User ):void				{					ConsoleBroadcaster.broadcast( "CryptologyCompleteAnimationPopupView", "setFriendFBUser("+user.name+");" );										while( friendFBUser_mc.image_mc.numChildren > 0 )						friendFBUser_mc.image_mc.removeChildAt(0);										_friend = user;										if( BitmapDataManager.getInstance().getBitmapData("UserFBProfilePic_"+user.id) == null )					{						var iconLoader:Loader = new Loader();							iconLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, handleLoadFriendIconComplete, false, 0, true );							iconLoader.load( new URLRequest(user.fbProfilePicURL), new LoaderContext(true, ApplicationDomain.currentDomain) );					}					else					{						//friendFBUser_mc.image_mc.addChild( new Bitmap(BitmapDataManager.getInstance().getBitmapData("UserFBProfilePic_"+user.id).bitmapData) );						addFriendImage();					}										//friendFBUser_mc.name_txt.text = user.firstName;					TextFormatting.formatTextWithFontName( friendFBUser_mc.name_txt, user.name, "Lithos Pro Black", false, TextFieldAutoSize.CENTER );				}							/** handleLoadFriendIconComplete			  *	---------------------------------------------------------------------------- */				protected function handleLoadFriendIconComplete( event:Event ):void				{					event.currentTarget.removeEventListener( Event.COMPLETE, handleLoadFriendIconComplete );										var bitmapData:BitmapData = new BitmapData( event.currentTarget.content.width, event.currentTarget.content.height );						bitmapData.draw( event.currentTarget.content );										BitmapDataManager.getInstance().addBitmapData( "UserFBProfilePic_"+_friend.id, bitmapData );										addFriendImage();				}								protected function addFriendImage():void				{					var bitmap:Bitmap = new Bitmap( BitmapDataManager.getInstance().getBitmapData("UserFBProfilePic_"+_friend.id).bitmapData );						bitmap.smoothing = true;					var ratio:Number;										if( bitmap.width > bitmap.height )					{						ratio = 50 / bitmap.width;						bitmap.width = 50;						bitmap.height = bitmap.height * ratio;					}					else					{						ratio = 50 / bitmap.height;						bitmap.width = bitmap.width * ratio;						bitmap.height = 50;					}										bitmap.x = -bitmap.width/2;					bitmap.y = -bitmap.height/2;										friendFBUser_mc.image_mc.addChild( bitmap );				}								public function show():void				{					connect_mc.visible = true;										visible = true;				}								public function hide():void				{					visible = false;										leftSymbol_mc.reset();					rightSymbol_mc.reset();					fullSymbol_mc.reset();					symbolsAnimation_mc.visible = false;					symbolsAnimation_mc.gotoAndStop(1);										dispatchEvent( new BoogaEvent(BoogaEvent.ON_POPUP_HIDE) );				}								protected function handleExitClicked( event:Event ):void				{					dispatchEvent( new BoogaEvent(BoogaEvent.ON_CRYPTOLOGY_COMPLETE_ANIMATION_POPUP_CLOSE) );										hide();				}								protected function handleConnectClicked( event:Event ):void				{					connect_mc.visible = false;					//symbolsAnimation_mc.visible = true;					symbolsAnimation_mc.gotoAndPlay(2);										MainGameController.getInstance().completeUnlockedCryptology( _cryptology.id );				}						}	}