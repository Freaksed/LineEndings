﻿/** IslandSelectionNextExpedition  *	---------------------------------------------------------------------------- *  *	@author:  *		Christian Widodo [christian@avatarlabs.com]  *	---------------------------------------------------------------------------- */ 	package com.boogabooga.ui.maingame.islandselection	{		import flash.display.MovieClip;		import flash.events.Event;		import flash.events.EventDispatcher;		import flash.events.TimerEvent;		import flash.text.TextField;		import flash.text.TextFieldAutoSize;				import com.avatarlabs.utils.console.ConsoleBroadcaster;		import com.avatarlabs.utils.datatypes.DataTypeOperations;		import com.avatarlabs.utils.events.CustomEvent;		import com.avatarlabs.utils.events.EventNotificationCenter;		import com.avatarlabs.utils.navigation.UINavigation;		import com.avatarlabs.utils.navigation.UINavigationButton;		import com.avatarlabs.utils.sound.SoundEffectPlayer;		import com.avatarlabs.utils.text.TextFormatting;		import com.avatarlabs.utils.timers.CountDown;		import com.avatarlabs.utils.userinterface.DynamicUIButton;				import com.boogabooga.controller.gamelevel.GameLevelDataController;		import com.boogabooga.controller.maingame.MainGameController;		import com.boogabooga.data.SoundsIndex;		import com.boogabooga.data.StringsIndex;		import com.boogabooga.data.gamelevel.DiggingMap;		import com.boogabooga.data.gamelevel.DiggingSpots;		import com.boogabooga.data.gamelevel.GameLevelDataIndex;		import com.boogabooga.data.maingame.Village;		import com.boogabooga.events.BoogaEvent;		import com.boogabooga.ui.maingame.AbstractContentView;		import com.boogabooga.ui.maingame.IContentView;		import com.boogabooga.ui.maingame.LoadingAssetView;		import com.boogabooga.ui.maingame.islandselection.IslandSelectionView;				public class IslandSelectionNextExpedition extends EventDispatcher		{			protected var _contentClip:MovieClip;			protected var _countDown:CountDown;						protected var _purchaseClip:DynamicUIButton;						/**	Stage Instances **/			public var label_txt:TextField;			public var purchase_mc:MovieClip;			/**	End of Stage Instances **/						/** Constructor			  *	---------------------------------------------------------------------------- */				public function IslandSelectionNextExpedition()				{					//init();				}								public function set contentClip( m:MovieClip ):void				{					_contentClip = m;										label_txt = _contentClip.label_txt;					purchase_mc = _contentClip.purchase_mc;										_purchaseClip = new DynamicUIButton();					_purchaseClip.dynamicClip = purchase_mc;					_purchaseClip.dynamicInit();				}				public function get contentClip():MovieClip { return _contentClip; }								/*				public function get countDown():CountDown				{					if( _countDown == null )					{						_countDown = new CountDown();						_countDown.addEventListener( "onChange", handleCountDownChanged, false, 0, true );						_countDown.addEventListener( "onStop", handleCountDownStopped, false, 0, true );						_countDown.delay = 600;					}										return _countDown;				}				*/							/** init			  *	---------------------------------------------------------------------------- *			  *	---------------------------------------------------------------------------- */				public function init():void				{					_purchaseClip.addEventListener( "onClick", handlePurchaseClicked, false, 0, true );					_purchaseClip.addEventListener( "onSetFocus", handlePurchaseRolledOver, false, 0, true );					_purchaseClip.addEventListener( "onKillFocus", handlePurchaseRolledOut, false, 0, true );				}							/** show			  *	---------------------------------------------------------------------------- *			  *	---------------------------------------------------------------------------- */				public function show( startTime:Number, nextTime:Number ):void				{					if( _countDown == null )					{						_countDown = new CountDown();						_countDown.addEventListener( "onChange", handleCountDownChanged, false, 0, true );						_countDown.addEventListener( "onStop", handleCountDownStopped, false, 0, true );						_countDown.delay = 1000;					}										_countDown.startTime = startTime;					_countDown.addTargetTime( nextTime );					_countDown.startCountDown();										label_txt.text = "";										_contentClip.visible = true;				}							/** hide			  *	---------------------------------------------------------------------------- *			  *	---------------------------------------------------------------------------- */				public function hide():void				{					if( _countDown != null )						_countDown.stopCountDown();										_contentClip.visible = false;				}							/** handleCountDownChanged			  *	---------------------------------------------------------------------------- *			  *	This event is fired when the countdown timer ticks.			  *	---------------------------------------------------------------------------- */				protected function handleCountDownChanged( event:CustomEvent ):void				{					//trace( "handleCountDownChanged("+event.customParameters.remainingTime+");" );										MainGameController.getInstance().currentServerUnixTime += _countDown.delay;										//trace( "currentServerUnixTime: "+MainGameController.getInstance().currentServerUnixTime );										//TextFormatting.formatTextWithFontName( label_txt, "NEXT DIG EXPEDITION IN "+DataTypeOperations.convertSecondsToTimeString(event.customParameters.remainingTime/1000), "SF Fedora", false, TextFieldAutoSize.CENTER );					var time:String = DataTypeOperations.convertSecondsToTimeString(event.customParameters.remainingTime/1000);						time = time.substr( 0, time.length-3 );					TextFormatting.formatTextWithFontName( label_txt, StringsIndex.getInstance().getStringByName("ARCHEOLOGIES_NEXT_DIG_EXPEDITION_IN")+"_"+time, "Lithos Pro Black", false, TextFieldAutoSize.RIGHT );				}							/** handleCountDownStopped			  *	---------------------------------------------------------------------------- *			  *	---------------------------------------------------------------------------- */				protected function handleCountDownStopped( event:CustomEvent ):void				{					MainGameController.getInstance().currentServerUnixTime += _countDown.delay*2;										dispatchEvent( new BoogaEvent(BoogaEvent.ON_ARCHEOLOGY_DIG_TIME_EXPIRED) );				}							/** start			  *	---------------------------------------------------------------------------- *			  *	---------------------------------------------------------------------------- */				protected function handlePurchaseClicked( event:Event ):void				{					//SoundEffectPlayer.getInstance().setVolume( SoundsIndex.getInstance().getSoundBySoundId("sfx_mouse_click.wav").volume, 0, "sfx_mouse_click.wav" );					SoundEffectPlayer.getInstance().playLibrarySound( "sfx_mouse_click.wav", false, "sfx_mouse_click.wav", "sfx_mouse_click.wav" );										dispatchEvent( new BoogaEvent(BoogaEvent.ON_ARCHEOLOGY_DIG_EARLY) );				}								protected function handlePurchaseRolledOver( event:Event ):void				{					//SoundEffectPlayer.getInstance().setVolume( SoundsIndex.getInstance().getSoundBySoundId("sfx_mouse_rollover.wav").volume, 0, "sfx_mouse_rollover.wav" );					SoundEffectPlayer.getInstance().playLibrarySound( "sfx_mouse_rollover.wav", false, "sfx_mouse_rollover.wav", "sfx_mouse_rollover.wav" );				}								protected function handlePurchaseRolledOut( event:Event ):void				{									}							/** handleLanguageChanged			  *	---------------------------------------------------------------------------- *			  *	When a language is changed, update the text accordingly.			  *	---------------------------------------------------------------------------- */				protected function handleLanguageChanged( event:CustomEvent ):void				{					TextFormatting.formatTextWithFontName( label_txt, StringsIndex.getInstance().getStringByName("ARCHEOLOGIES_NEXT_DIG_EXPEDITION_IN")+"_"+DataTypeOperations.convertSecondsToTimeString(event.customParameters.remainingTime/1000), "Lithos Pro Black", false, TextFieldAutoSize.CENTER );									}						}	}