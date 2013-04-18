﻿/** StorePackItemIcon  *	---------------------------------------------------------------------------- *  *	@author:  *		Christian Widodo [christian@avatarlabs.com]  *	---------------------------------------------------------------------------- */ 	package com.boogabooga.ui.maingame.store	{		import flash.display.Bitmap;		import flash.display.BitmapData;		import flash.display.Loader;		import flash.display.MovieClip;		import flash.events.Event;		import flash.events.EventDispatcher;		import flash.events.IOErrorEvent;		import flash.events.MouseEvent;		import flash.net.URLRequest;		import flash.system.ApplicationDomain;		import flash.system.LoaderContext;		import flash.text.TextField;		import flash.text.TextFieldAutoSize;				import com.avatarlabs.utils.cache.BitmapDataManager;		import com.avatarlabs.utils.console.ConsoleBroadcaster;		import com.avatarlabs.utils.events.CustomEvent;		import com.avatarlabs.utils.sound.SoundEffectPlayer;		import com.avatarlabs.utils.text.TextFormatting;		import com.avatarlabs.utils.userinterface.DynamicUIButton;				import com.boogabooga.data.SettingsIndex;		import com.boogabooga.data.SoundsIndex;		import com.boogabooga.data.StringsIndex;		import com.boogabooga.data.gamelevel.AbstractGameObject;		import com.boogabooga.data.gamelevel.GameLevelDataIndex;		import com.boogabooga.data.gamelevel.God;		import com.boogabooga.data.gamelevel.Weapon;		import com.boogabooga.data.maingame.Village;		import com.boogabooga.data.maingame.StorePack;				public class StorePackItemIcon extends EventDispatcher		{			protected var _contentClip:MovieClip;			protected var _item:StorePack;						protected var _buyClip:DynamicUIButton;						/**	Stage Instances **/			public var name_txt:TextField;			public var image_mc:MovieClip;			public var price_mc:MovieClip;			public var buy_mc:MovieClip;			public var background_mc:MovieClip;			/**	End of Stage Instances **/						/** Constructor			  *	---------------------------------------------------------------------------- */				public function StorePackItemIcon()				{					//init();				}								public function set contentClip( m:MovieClip ):void				{					_contentClip = m;										name_txt = _contentClip.name_txt;					name_txt.mouseEnabled = false;					image_mc = _contentClip.image_mc;					image_mc.mouseEnabled = false;					buy_mc = _contentClip.buy_mc;					background_mc = _contentClip.background_mc;					price_mc = _contentClip.price_mc;					price_mc.mouseEnabled = false;										_buyClip = new DynamicUIButton();					_buyClip.dynamicClip = buy_mc;					_buyClip.dynamicInit();				}				public function get contentClip():MovieClip { return _contentClip; }								public function get item():StorePack { return _item; }							/** init			  *	---------------------------------------------------------------------------- */				public function init():void				{					//buy_mc.visible = false;					buy_mc.mouseChildren = false;					_buyClip.addEventListener( "onClick", handleBuyClicked, false, 0, true );					_buyClip.addEventListener( "onSetFocus", handleBuyRolledOver, false, 0, true );					_buyClip.addEventListener( "onKillFocus", handleBuyRolledOut, false, 0, true );										background_mc.addEventListener( MouseEvent.ROLL_OVER, handleItemRolledOver, false, 0, true );					background_mc.addEventListener( MouseEvent.ROLL_OUT, handleItemRolledOut, false, 0, true );				}							/** reset			  *	---------------------------------------------------------------------------- */				public function reset():void				{					while( image_mc.numChildren > 0 )						image_mc.removeChildAt(0);				}								/*				public function showLockView( level:int=0 ):void				{					count_mc.visible = false;					buy_mc.visible = false;				}				*/							/** showItemView			  *	---------------------------------------------------------------------------- *			  *	Shows the item view with the icon.			  *	---------------------------------------------------------------------------- */				public function showItemView( item:StorePack ):void				{					_item = item;										_item.statistic = '';					var weapon:Weapon;					var god:God;										for( var i:int=0; i<_item.weapons.length; ++i )					{						weapon = GameLevelDataIndex.getInstance().getWeapon( _item.weapons[i].weapon_id );						_item.statistic += '\n'+_item.weapons[i].count+' '+StringsIndex.getInstance().getString(String(weapon.name));					}										for( i=0; i<_item.gods.length; ++i )					{						god = GameLevelDataIndex.getInstance().getGod( _item.gods[i].god_id );						_item.statistic += '\n'+_item.gods[i].count+' '+StringsIndex.getInstance().getString(String(god.name));					}										reset();										//trace( "item.name: "+StringsIndex.getInstance().getStringByName(String(_item.name)) );										TextFormatting.formatTextWithFontName( name_txt, StringsIndex.getInstance().getString( String(_item.name) ), "Lithos Pro Black", false, TextFieldAutoSize.CENTER );					TextFormatting.formatTextWithFontName( price_mc.label_txt, String(_item.prices[0].price), "Lithos Pro Black", false, TextFieldAutoSize.CENTER );										if( BitmapDataManager.getInstance().getBitmapData( _item.cacheIconId ) == null )					{						BitmapDataManager.getInstance().addEventListener( Event.COMPLETE, handleLoadIconComplete, false, 0, true );						BitmapDataManager.getInstance().addEventListener( IOErrorEvent.IO_ERROR, handleLoadIconError, false, 0, true );						BitmapDataManager.getInstance().loadBitmapToCache( SettingsIndex.getInstance().contentURL+_item.iconURL, _item.cacheIconId );					}					else					{						addIcon();					}					/*					var loaderContext:LoaderContext = new LoaderContext( false, ApplicationDomain.currentDomain );										var iconLoader:Loader = new Loader();						iconLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, handleLoadIconComplete );						iconLoader.load( new URLRequest(SettingsIndex.getInstance().contentURL+item.iconURL), loaderContext );					*/				}								protected function handleLoadIconComplete( event:CustomEvent ):void				{					if( event.customParameters.cacheId == _item.cacheIconId )					{						BitmapDataManager.getInstance().removeEventListener( Event.COMPLETE, handleLoadIconComplete );						BitmapDataManager.getInstance().removeEventListener( IOErrorEvent.IO_ERROR, handleLoadIconError );						addIcon();					}				}								protected function handleLoadIconError( event:CustomEvent ):void				{					if( event.customParameters.cacheId == _item.cacheIconId )					{						BitmapDataManager.getInstance().removeEventListener( Event.COMPLETE, handleLoadIconComplete );						BitmapDataManager.getInstance().removeEventListener( IOErrorEvent.IO_ERROR, handleLoadIconError );					}				}								protected function addIcon():void				{					var iconBitmap:Bitmap = new Bitmap(BitmapDataManager.getInstance().getBitmapData(_item.cacheIconId).bitmapData);						iconBitmap.width = 100;						iconBitmap.height = 100;						iconBitmap.smoothing = true;						iconBitmap.x = -50;						iconBitmap.y = -50;										image_mc.addChild( iconBitmap );				}							/** handleBuyClicked			  *	---------------------------------------------------------------------------- */				protected function handleBuyClicked( event:Event ):void				{					ConsoleBroadcaster.broadcast( "StorePackItemIcon", "handleBuyClicked();" );										SoundEffectPlayer.getInstance().playLibrarySound( "sfx_mouse_click.wav", false, "sfx_mouse_click.wav", "sfx_mouse_click.wav", SoundEffectPlayer.SOUND_PLAYER_SFX );										dispatchEvent( new CustomEvent("onBuyClick", {type:"Pack", itemId:_item.id, priceId:_item.prices[0].id}) );				}							/** handleBuyRolledOver			  *	---------------------------------------------------------------------------- */				protected function handleBuyRolledOver( event:Event ):void				{					//SoundEffectPlayer.getInstance().setVolume( SoundsIndex.getInstance().getSoundBySoundId("sfx_mouse_rollover.wav").volume, 0, "sfx_mouse_rollover.wav" );					SoundEffectPlayer.getInstance().playLibrarySound( "sfx_mouse_rollover.wav", false, "sfx_mouse_rollover.wav", "sfx_mouse_rollover.wav", SoundEffectPlayer.SOUND_PLAYER_SFX );										//dispatchEvent( new CustomEvent("onBuyRolledOver", {type:"Pack", itemId:_item.id, priceId:_item.priceId}) );				}							/** handleBuyRolledOut			  *	---------------------------------------------------------------------------- */				protected function handleBuyRolledOut( event:Event ):void				{					//dispatchEvent( new CustomEvent("onBuyRolledOut") );				}								protected function handleItemRolledOver( event:MouseEvent ):void				{					dispatchEvent( new Event("onRollOver") );				}								protected function handleItemRolledOut( event:MouseEvent ):void				{					dispatchEvent( new Event("onRollOut") );				}		}	}