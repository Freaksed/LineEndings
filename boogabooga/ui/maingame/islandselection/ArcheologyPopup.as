﻿/** ArcheologyPopup  *	---------------------------------------------------------------------------- *  *	@author:  *		Christian Widodo [christian@avatarlabs.com]  *	---------------------------------------------------------------------------- */ 	package com.boogabooga.ui.maingame.islandselection	{		import flash.display.Bitmap;		import flash.display.MovieClip;		import flash.events.Event;		import flash.events.EventDispatcher;		import flash.events.MouseEvent;		import flash.geom.Point;		import flash.geom.Rectangle;		import flash.text.TextField;		import flash.text.TextFieldAutoSize;		import flash.utils.getDefinitionByName;				import com.avatarlabs.utils.cache.BitmapDataManager;		import com.avatarlabs.utils.console.ConsoleBroadcaster;		import com.avatarlabs.utils.events.AssetLoaderEvent;		import com.avatarlabs.utils.events.EventNotificationCenter;		import com.avatarlabs.utils.events.CustomEvent;		import com.avatarlabs.utils.sound.SoundEffectPlayer;		import com.avatarlabs.utils.text.TextFormatting;		import com.avatarlabs.utils.userinterface.DynamicUIButton;				import com.boogabooga.controller.maingame.MainGameController;		import com.boogabooga.data.SoundsIndex;		import com.boogabooga.data.StringsIndex;		import com.boogabooga.data.maingame.Village;		import com.boogabooga.data.gamelevel.AbstractGameObject;		import com.boogabooga.data.gamelevel.GameLevelDataIndex;		import com.boogabooga.data.maingame.Cryptology;		import com.boogabooga.data.maingame.Treasure;		import com.boogabooga.events.BoogaEvent;		//import com.boogabooga.ui.maingame.cryptology.CryptologySymbol;				public class ArcheologyPopup extends EventDispatcher		{			protected var _contentClip:MovieClip;			protected var _item:AbstractGameObject;			protected var _bounds:Rectangle;						protected var _digClip:DynamicUIButton;			protected var _digEarlyClip:DynamicUIButton;			protected var _exitClip:DynamicUIButton;						protected var _completeView:Boolean;			protected var _isContentVisible:Boolean;						/**	Stage Instances **/			public var header_mc:MovieClip;			public var commonTreasureCount_txt:TextField;			public var rareTreasureCount_txt:TextField;			public var dig_mc:MovieClip;			public var digEarly_mc:MovieClip;			public var backgroundTopRight_mc:MovieClip;			public var backgroundTopLeft_mc:MovieClip;			public var backgroundBottomRight_mc:MovieClip;			public var backgroundBottomLeft_mc:MovieClip;			public var incomplete_mc:MovieClip;			public var complete_mc:MovieClip;			public var exit_mc:MovieClip;			/**	End of Stage Instances **/						/** Constructor			  *	---------------------------------------------------------------------------- */				public function ArcheologyPopup()				{					//init();				}								public function set contentClip( m:MovieClip ):void				{					_contentClip = m;										header_mc = _contentClip.header_mc;					commonTreasureCount_txt = _contentClip.commonTreasureCount_txt;					rareTreasureCount_txt = _contentClip.rareTreasureCount_txt;					dig_mc = _contentClip.dig_mc;					dig_mc.cacheAsBitmap = true;					digEarly_mc = _contentClip.digEarly_mc;					digEarly_mc.cacheAsBitmap = true;					backgroundTopRight_mc = _contentClip.backgroundTopRight_mc;					backgroundTopRight_mc.cacheAsBitmap = true;					backgroundTopLeft_mc = _contentClip.backgroundTopLeft_mc;					backgroundTopLeft_mc.cacheAsBitmap = true;					backgroundBottomRight_mc = _contentClip.backgroundBottomRight_mc;					backgroundBottomRight_mc.cacheAsBitmap = true;					backgroundBottomLeft_mc = _contentClip.backgroundBottomLeft_mc;					backgroundBottomLeft_mc.cacheAsBitmap = true;					incomplete_mc = _contentClip.incomplete_mc;					complete_mc = _contentClip.complete_mc;					exit_mc = _contentClip.exit_mc;					exit_mc.cacheAsBitmap = true;										_digClip = new DynamicUIButton();					_digClip.dynamicClip = dig_mc;					_digClip.dynamicInit();										_digEarlyClip = new DynamicUIButton();					_digEarlyClip.dynamicClip = digEarly_mc;					_digEarlyClip.dynamicInit();										_exitClip = new DynamicUIButton();					_exitClip.dynamicClip = exit_mc;					_exitClip.dynamicInit();				}				public function get contentClip():MovieClip { return _contentClip; }								public function get completeView():Boolean { return _completeView; }				public function get isContentVisible():Boolean { return _isContentVisible; }							/** init			  *	---------------------------------------------------------------------------- */				public function init():void				{					backgroundTopLeft_mc.visible = false;					backgroundBottomRight_mc.visible = false;					backgroundBottomLeft_mc.visible = false;										_completeView = false;										_bounds = _contentClip.getBounds( _contentClip );										_contentClip.addEventListener( MouseEvent.ROLL_OUT, handleRolledOut, false, 0, true );										_digEarlyClip.addEventListener( "onClick", handleDigEarlyClicked, false, 0, true );					_digEarlyClip.addEventListener( "onSetFocus", handleDigEarlyRolledOver, false, 0, true );					_digEarlyClip.addEventListener( "onKillFocus", handleDigEarlyRolledOut, false, 0, true );					_digClip.addEventListener( "onClick", handleDigClicked, false, 0, true );					_digClip.addEventListener( "onSetFocus", handleDigRolledOver, false, 0, true );					_digClip.addEventListener( "onKillFocus", handleDigRolledOut, false, 0, true );					_exitClip.addEventListener( "onClick", handleExitClicked, false, 0, true );					_exitClip.addEventListener( "onSetFocus", handleExitRolledOver, false, 0, true );										showIncompleteView();				}							/** showCompleteView			  *	---------------------------------------------------------------------------- */				public function showCompleteView():void				{					complete_mc.visible = true;					incomplete_mc.visible = false;										_completeView = true;										rareTreasureCount_txt = complete_mc.rareTreasureCount_txt;					commonTreasureCount_txt = complete_mc.commonTreasureCount_txt;										_digClip.dynamicClip.visible = false;					_digEarlyClip.dynamicClip.visible = false;				}							/** showIncompleteView			  *	---------------------------------------------------------------------------- */				public function showIncompleteView( canDig:Boolean=true ):void				{					complete_mc.visible = false;					incomplete_mc.visible = true;										_completeView = false;										rareTreasureCount_txt = incomplete_mc.rareTreasureCount_txt;					commonTreasureCount_txt = incomplete_mc.commonTreasureCount_txt;										if( canDig )					{						_digClip.dynamicClip.visible = true;						_digEarlyClip.dynamicClip.visible = false;					}					else					{						_digClip.dynamicClip.visible = false;						_digEarlyClip.dynamicClip.visible = true;					}				}							/** show			  *	---------------------------------------------------------------------------- */				public function show():void				{					_contentClip.visible = true;					_isContentVisible = true;										//startCheckingBound();				}							/** hide			  *	---------------------------------------------------------------------------- */				public function hide():void				{					//stopCheckingBound();										_contentClip.visible = false;					_isContentVisible = false;										dispatchEvent( new BoogaEvent(BoogaEvent.ON_POPUP_HIDE) );				}							/** setHeader			  *	---------------------------------------------------------------------------- */				public function setHeader( text:String ):void				{					//TextFormatting.formatTextWithFontName( header_mc.label_txt, text, "SF Fedora", false, TextFieldAutoSize.CENTER );					TextFormatting.formatTextWithFontName( header_mc.label_txt, text, "Lithos Pro Black", false, TextFieldAutoSize.CENTER );				}							/** setTreasures			  *	---------------------------------------------------------------------------- */				public function setTreasures( currentCommon:int, maxCommon:int, currentRare:int, maxRare:int ):void				{					//TextFormatting.formatTextWithFontName( commonTreasureCount_txt, currentCommon+"/"+maxCommon, "SF Fedora" );					//TextFormatting.formatTextWithFontName( rareTreasureCount_txt, currentRare+"/"+maxRare, "SF Fedora" );					TextFormatting.formatTextWithFontName( commonTreasureCount_txt, currentCommon+"/"+maxCommon, "Lithos Pro Black" );					TextFormatting.formatTextWithFontName( rareTreasureCount_txt, currentRare+"/"+maxRare, "Lithos Pro Black" );										if( currentCommon == maxCommon && currentRare == maxRare )						_digClip.dynamicClip.visible = false;					else						_digClip.dynamicClip.visible = true;				}							/** handleRolledOut			  *	---------------------------------------------------------------------------- */				protected function handleRolledOut( event:MouseEvent ):void				{					if( _contentClip.visible )					{						//dispatchEvent( new BoogaEvent(BoogaEvent.ISLAND_SELECTION_POPUP_ROLLED_OUT) );					}				}							/** startCheckingBound			  *	---------------------------------------------------------------------------- */				protected function startCheckingBound():void				{					_contentClip.stage.addEventListener( MouseEvent.MOUSE_MOVE, handleMouseMoved, false, 0, true );				}							/** stopCheckingBound			  *	---------------------------------------------------------------------------- */				protected function stopCheckingBound():void				{					_contentClip.stage.removeEventListener( MouseEvent.MOUSE_MOVE, handleMouseMoved );				}							/** handleMouseMoved			  *	---------------------------------------------------------------------------- *			  *	Checks to see if mouse is out of the boundary of the popup. If so, close it.			  *	---------------------------------------------------------------------------- */				protected function handleMouseMoved( event:MouseEvent ):void				{					var localPosition:Point = _contentClip.globalToLocal( new Point(event.stageX, event.stageY) );										//trace( "x: "+localPosition.x+", y:"+localPosition.y );					//trace( "bounds.top: "+_bounds.top+", bottom: "+_bounds.bottom+", left: "+_bounds.left+", right: "+_bounds.right );										if( localPosition.x < _bounds.left || localPosition.x > _bounds.right || localPosition.y < _bounds.top || localPosition.y > _bounds.bottom )					{						hide();						//trace( "supposed to hide now" );					}				}							/** handleDigClicked			  *	---------------------------------------------------------------------------- */				protected function handleDigClicked( event:Event ):void				{					//SoundEffectPlayer.getInstance().setVolume( SoundsIndex.getInstance().getSoundBySoundId("sfx_mouse_click.wav").volume, 0, "sfx_mouse_click.wav" );					SoundEffectPlayer.getInstance().playLibrarySound( "sfx_mouse_click.wav", false, "sfx_mouse_click.wav", "sfx_mouse_click.wav" );										dispatchEvent( new BoogaEvent(BoogaEvent.ON_ARCHEOLOGY_DIG) );				}							/** handleDigRolledOver			  *	---------------------------------------------------------------------------- */				protected function handleDigRolledOver( event:Event ):void				{					//SoundEffectPlayer.getInstance().setVolume( SoundsIndex.getInstance().getSoundBySoundId("sfx_mouse_rollover.wav").volume, 0, "sfx_mouse_rollover.wav" );					SoundEffectPlayer.getInstance().playLibrarySound( "sfx_mouse_rollover.wav", false, "sfx_mouse_rollover.wav", "sfx_mouse_rollover.wav" );										EventNotificationCenter.getInstance().sendSignal( BoogaEvent.ON_TEXT_HOVER_SHOW, this, {clip:_digClip.dynamicClip, text:StringsIndex.getInstance().getStringByName("DIG_DIG")} );				}							/** handleDigRolledOut			  *	---------------------------------------------------------------------------- */				protected function handleDigRolledOut( event:Event ):void				{					EventNotificationCenter.getInstance().sendSignal( BoogaEvent.ON_TEXT_HOVER_HIDE, this );				}							/** handleDigEarlyClicked			  *	---------------------------------------------------------------------------- */				protected function handleDigEarlyClicked( event:Event ):void				{					//SoundEffectPlayer.getInstance().setVolume( SoundsIndex.getInstance().getSoundBySoundId("sfx_mouse_click.wav").volume, 0, "sfx_mouse_click.wav" );					SoundEffectPlayer.getInstance().playLibrarySound( "sfx_mouse_click.wav", false, "sfx_mouse_click.wav", "sfx_mouse_click.wav" );										dispatchEvent( new BoogaEvent(BoogaEvent.ON_ARCHEOLOGY_DIG_EARLY) );				}							/** handleDigEarlyRolledOver			  *	---------------------------------------------------------------------------- */				protected function handleDigEarlyRolledOver( event:Event ):void				{					//SoundEffectPlayer.getInstance().setVolume( SoundsIndex.getInstance().getSoundBySoundId("sfx_mouse_rollover.wav").volume, 0, "sfx_mouse_rollover.wav" );					SoundEffectPlayer.getInstance().playLibrarySound( "sfx_mouse_rollover.wav", false, "sfx_mouse_rollover.wav", "sfx_mouse_rollover.wav" );										EventNotificationCenter.getInstance().sendSignal( BoogaEvent.ON_TEXT_HOVER_SHOW, this, {clip:_digEarlyClip.dynamicClip, text:StringsIndex.getInstance().getStringByName("DIG_DIG")} );				}							/** handleDigEarlyRolledOut			  *	---------------------------------------------------------------------------- */				protected function handleDigEarlyRolledOut( event:Event ):void				{					EventNotificationCenter.getInstance().sendSignal( BoogaEvent.ON_TEXT_HOVER_HIDE, this );				}							/** handleExitClicked			  *	---------------------------------------------------------------------------- */				protected function handleExitClicked( event:Event ):void				{					//SoundEffectPlayer.getInstance().setVolume( SoundsIndex.getInstance().getSoundBySoundId("sfx_mouse_click.wav").volume, 0, "sfx_mouse_click.wav" );					SoundEffectPlayer.getInstance().playLibrarySound( "sfx_mouse_click.wav", false, "sfx_mouse_click.wav", "sfx_mouse_click.wav" );										hide();				}							/** handleExitRolledOver			  *	---------------------------------------------------------------------------- */				protected function handleExitRolledOver( event:Event ):void				{					//SoundEffectPlayer.getInstance().setVolume( SoundsIndex.getInstance().getSoundBySoundId("sfx_mouse_rollover.wav").volume, 0, "sfx_mouse_rollover.wav" );					SoundEffectPlayer.getInstance().playLibrarySound( "sfx_mouse_rollover.wav", false, "sfx_mouse_rollover.wav", "sfx_mouse_rollover.wav" );				}		}	}