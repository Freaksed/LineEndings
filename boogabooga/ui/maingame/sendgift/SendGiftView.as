﻿/** SendGiftView  *	---------------------------------------------------------------------------- *  *	@author:  *		Christian Widodo [christian@avatarlabs.com]  *	---------------------------------------------------------------------------- */ 	package com.boogabooga.ui.maingame.sendgift	{		import flash.display.MovieClip;		import flash.events.Event;				import com.avatarlabs.utils.console.ConsoleBroadcaster;		import com.avatarlabs.utils.events.CustomEvent;		import com.avatarlabs.utils.events.EventNotificationCenter;		import com.greensock.TweenLite;				import com.boogabooga.controller.gamelevel.GameLevelDataController;		import com.boogabooga.controller.maingame.IslandDataController;		import com.boogabooga.controller.maingame.MainGameController;		import com.boogabooga.data.gamelevel.AbstractGameObject;		import com.boogabooga.data.gamelevel.DiggingMap;		import com.boogabooga.data.gamelevel.DiggingSpots;		import com.boogabooga.data.gamelevel.GameLevelDataIndex;		import com.boogabooga.data.gamelevel.God;		import com.boogabooga.data.gamelevel.Weapon;		import com.boogabooga.data.maingame.Village;		import com.boogabooga.events.BoogaEvent;		import com.boogabooga.ui.maingame.AbstractContentView;		import com.boogabooga.ui.maingame.IContentView;		import com.boogabooga.ui.maingame.LoadingAssetView;		import com.boogabooga.ui.maingame.gameboard.GameboardView;		import com.boogabooga.ui.maingame.islandselection.IslandSelectionView;		import com.boogabooga.utils.GameLevelUtil;				public class SendGiftView extends AbstractContentView implements IContentView		{			protected var _loadingAssetViewClip:LoadingAssetView;						protected var _sendGiftPickerClip:SendGiftPicker;			protected var _sendGiftConfirmationViewClip:SendGiftConfirmationView;						/**	Stage Instances **/			public var blackBackground_mc:MovieClip;			public var sendGiftPicker_mc:MovieClip;			public var confirmation_mc:MovieClip;			/**	End of Stage Instances **/						/** Constructor			  *	---------------------------------------------------------------------------- */				public function SendGiftView()				{									}								override public function set contentClip( m:MovieClip ):void				{					super.contentClip = m;										blackBackground_mc = _contentClip.blackBackground_mc;					blackBackground_mc.cacheAsBitmap = true;					sendGiftPicker_mc = _contentClip.sendGiftPicker_mc;					confirmation_mc = _contentClip.confirmation_mc;										_sendGiftPickerClip = new SendGiftPicker();					_sendGiftPickerClip.dynamicClip = sendGiftPicker_mc;					_sendGiftPickerClip.dynamicInit();										_sendGiftConfirmationViewClip = new SendGiftConfirmationView();					_sendGiftConfirmationViewClip.contentClip = confirmation_mc;					_sendGiftConfirmationViewClip.init();					_sendGiftConfirmationViewClip.hide();				}								public function set loadingAssetViewClip( clip:LoadingAssetView ):void { _loadingAssetViewClip = clip; }								override public function init():void				{					ConsoleBroadcaster.broadcast( "SendGiftView", "init();" );										super.init();										//EventNotificationCenter.getInstance().addSignalListener( BoogaEvent.ON_LANGUAGE_CHANGED, handleLanguageChanged, this );										//_sendGiftPickerClip.addEventListener( BoogaEvent.GIFT_SELECTION_CANCEL, handleGiftSelectionCancel );					//_sendGiftPickerClip.addEventListener( BoogaEvent.GIFT_SELECTION_DONE, handleGiftSelectionDone );					_sendGiftPickerClip.onGiftSelectionCancel.add( handleGiftSelectionCancel );					_sendGiftPickerClip.onGiftRequestCancel.add( handleGiftRequestCancel );					_sendGiftPickerClip.onGiftRequestSent.add( handleGiftSelectionDone );					_sendGiftPickerClip.onRequestInProgress.add( handleRequestInProgress );										_sendGiftConfirmationViewClip.onExitClicked.add( handleSendGiftConfirmationViewExitClicked );					_sendGiftConfirmationViewClip.onReplayClicked.add( handleSendGiftConfirmationViewReplayClicked );				}							/** show			  *	---------------------------------------------------------------------------- *			  *	Selects the next 3 weapon/gods that user hasn't unlocked yet. If unlocked			  *	items are less than 3, then include the latest items user has unlocked.			  *	---------------------------------------------------------------------------- */				override public function show():void				{					ConsoleBroadcaster.broadcast( "SendGiftView", "show();" );					/*					var items:Vector.<AbstractGameObject> = new Vector.<AbstractGameObject>;					var weapons:Vector.<Weapon> = new Vector.<Weapon>;					var gods:Vector.<God> = new Vector.<God>;					var itemCount:int = GameLevelDataIndex.getInstance().weaponsCount;					var i:int, j:int;										for( i=0; i<itemCount; ++i )					{						if( GameLevelDataIndex.getInstance().weapons[i].consumable && !GameLevelDataIndex.getInstance().weapons[i].hasAttackProperty(GameLevelUtil.ATTACK_PROPERTY_ADDITION_INDEX) && MainGameController.getInstance().currentUser.level < GameLevelDataIndex.getInstance().weapons[i].availableOnLevel )							weapons.push( GameLevelDataIndex.getInstance().weapons[i] );												if( weapons.length >= 3 )							break;					}										itemCount = GameLevelDataIndex.getInstance().godsCount;					for( i=0; i<itemCount; ++i )					{						if( GameLevelDataIndex.getInstance().gods[i].consumable && MainGameController.getInstance().currentUser.level < GameLevelDataIndex.getInstance().gods[i].availableOnLevel )							gods.push( GameLevelDataIndex.getInstance().gods[i] );												if( gods.length >= 3 )							break;					}										i = 0;					j = 0;					while( items.length < 3 )					{						if( i >= weapons.length && j >= gods.length )						{							break;						}						else if ( i >= weapons.length )						{							items.push( gods[j] );							++j;						}						else if( j >= gods.length )						{							items.push( weapons[i] );							++i;						}						else						{							if( weapons[i].availableOnLevel < gods[j].availableOnLevel )							{								items.push( weapons[i] );								++i;							}							else							{								items.push( gods[j] );								++j;							}						}					}										if( items.length < 3 )					{						itemCount = GameLevelDataIndex.getInstance().weaponsCount;												for( i=itemCount-1; i>0; ++i )						{							if( GameLevelDataIndex.getInstance().weapons[i].consumable && MainGameController.getInstance().currentUser.level >= GameLevelDataIndex.getInstance().weapons[i].availableOnLevel )							{								items.splice( 0, 0, GameLevelDataIndex.getInstance().weapons[i] );							}						}					}					*/					_sendGiftPickerClip.initGifts();					_sendGiftPickerClip.show();										//items = null;										TweenLite.from( _contentClip, .5, {y:"-500"} );										super.show();									}							/** hide			  *	---------------------------------------------------------------------------- */				override public function hide():void				{					ConsoleBroadcaster.broadcast( "SendGiftView", "hide();" );										//TweenLite.to( _contentClip, .5, {y:"-500"} );										super.hide();										_sendGiftPickerClip.hide();					_sendGiftConfirmationViewClip.hide();										dispatchEvent( new BoogaEvent(BoogaEvent.ON_POPUP_HIDE) );				}							/** handleGiftSelectionCancel			  *	---------------------------------------------------------------------------- *			  *	---------------------------------------------------------------------------- */				protected function handleGiftSelectionCancel():void				{					//ConsoleBroadcaster.broadcast( "SendGiftView", "handleGiftSelectionCancel();" );										hide();										//dispatchEvent( new BoogaEvent(BoogaEvent.ON_POPUP_HIDE) );				}							/** handleGiftSelectionDone			  *	---------------------------------------------------------------------------- *			  *	---------------------------------------------------------------------------- */				protected function handleGiftSelectionDone( requestsLength:int ):void				{					ConsoleBroadcaster.broadcast( "SendGiftView", "handleGiftSelectionDone();" );										//GameLevelCurrentData.getInstance().gift = MainGameController.getInstance().currentUser.gifts[_sendGiftPickerClip.currentGiftIndex];										//hide();					_sendGiftPickerClip.hide();					_sendGiftConfirmationViewClip.show( requestsLength > 1 );										_loadingAssetViewClip.hideLoadingProgress();										//dispatchEvent( new BoogaEvent(BoogaEvent.ON_POPUP_HIDE) );				}								protected function handleGiftRequestCancel():void				{					_loadingAssetViewClip.hideLoadingProgress();				}								protected function handleRequestInProgress():void				{					_loadingAssetViewClip.showLoadingProgress();				}								private function handleSendGiftConfirmationViewExitClicked():void				{					hide();				}								private function handleSendGiftConfirmationViewReplayClicked():void				{					_sendGiftConfirmationViewClip.hide();										_sendGiftPickerClip.initGifts();					_sendGiftPickerClip.show();				}							/** handleLanguageChanged			  *	---------------------------------------------------------------------------- *			  *	Updates the texts when the language is changed.			  *	---------------------------------------------------------------------------- 				private function handleLanguageChanged( event:CustomEvent ):void				{					trace( "SendGiftView -- handleLanguageChanged();" );														}*/						}	}