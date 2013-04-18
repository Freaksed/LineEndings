﻿/** GameboardMenu  *	---------------------------------------------------------------------------- *  *	@desc:  *		Gameboard Menu class that will contain the weapons, and other things  *		that users can place on the board. This will ideally be the bottom menu  *		in the gameplay.  *	@author:  *		Christian Widodo [christian@avatarlabs.com]  *	---------------------------------------------------------------------------- */ 	package com.boogabooga.ui.gamelevel.gameboardmenu	{		import flash.display.MovieClip;		import flash.events.Event;		import flash.events.EventDispatcher;		import flash.events.IOErrorEvent;		import flash.events.MouseEvent;		import flash.events.TimerEvent;		import flash.geom.Point;		import flash.geom.Rectangle;		import flash.utils.getDefinitionByName;		import flash.utils.getQualifiedClassName;		import flash.utils.Timer;				import com.greensock.TweenLite;		import com.avatarlabs.utils.cache.HashTable;		import com.avatarlabs.utils.console.ConsoleBroadcaster;		import com.avatarlabs.utils.events.CustomEvent;		import com.avatarlabs.utils.events.EventNotificationCenter;		import com.avatarlabs.utils.loader.CustomLoader;		import com.avatarlabs.utils.sound.SoundEffectPlayer;		import com.avatarlabs.utils.text.TextFormatting;		import com.avatarlabs.utils.userinterface.DynamicUIButton;		import org.osflash.signals.Signal;				import com.boogabooga.data.gamelevel.AbstractGameObject;		import com.boogabooga.data.gamelevel.GameLevelCurrentData;		import com.boogabooga.data.gamelevel.GameLevelDataIndex;		import com.boogabooga.data.gamelevel.God;		import com.boogabooga.data.gamelevel.Weapon;		import com.boogabooga.events.BoogaEvent;		import com.boogabooga.events.GameLevelEvent;		import com.boogabooga.ui.gamelevel.Gameboard;		import com.boogabooga.ui.gamelevel.GameLevelDisplayObject;		import com.boogabooga.ui.gamelevel.gameboardmenu.GameboardMenuContentIcon;				public class GameboardMenu extends EventDispatcher		{			protected var _debug:Boolean;			protected var _contentClip:MovieClip;						protected var _currentIconSelected:GameboardMenuContentIcon;			protected var _deleteSelected:Boolean;						protected var _currentMenuView:uint;						protected var _deleteClip:DynamicUIButton;			protected var _scrollerWeaponsClip:GameboardMenuContentScroller;						private var _purchaseEffectPlayDelayTimer:Timer;						public var onInsufficientChicken:Signal;			public var onMenuIconSelected:Signal;			public var onMenuDeleteSelected:Signal;						public static const MENU_VIEW_WEAPONS:uint = 0;			public static const MENU_VIEW_GODS:uint = 1;						/**	Stage Instances **/			public var scrollerWeapons_mc:MovieClip;			public var delete_mc:MovieClip;			public var background_mc:MovieClip;			public var backgroundWide_mc:MovieClip;			public var purchaseEffect_mc:MovieClip;			//public var slotBackground1_mc:MovieClip;			//public var slotBackground2_mc:MovieClip;			/**	End of Stage Instances **/						/** Constructor			  *	---------------------------------------------------------------------------- */				public function GameboardMenu()				{					//init();				}							/** set/get contentClip			  *	---------------------------------------------------------------------------- */				public function set contentClip( m:MovieClip ):void				{					_contentClip = m;										scrollerWeapons_mc = _contentClip.scrollerWeapons_mc;					delete_mc = _contentClip.delete_mc;					background_mc = _contentClip.background_mc;					background_mc.cacheAsBitmap = true;					background_mc.mouseEnabled = false;					backgroundWide_mc = _contentClip.backgroundWide_mc;					backgroundWide_mc.cacheAsBitmap = true;					backgroundWide_mc.mouseEnabled = false;					purchaseEffect_mc = _contentClip.purchaseEffect_mc;					purchaseEffect_mc.mouseChildren = false;					purchaseEffect_mc.mouseEnabled = false;					purchaseEffect_mc.stop();					//slotBackground1_mc = _contentClip.slotBackground1_mc;					//slotBackground1_mc.cacheAsBitmap = true;					//slotBackground2_mc = _contentClip.slotBackground2_mc;					//slotBackground2_mc.cacheAsBitmap = true;				}				public function get contentClip():MovieClip { return _contentClip; }							/** get currentItemSelected			  *	---------------------------------------------------------------------------- */				public function get currentItemSelected():AbstractGameObject { return _currentIconSelected.item; }				public function get currentIconSelected():GameboardMenuContentIcon { return _currentIconSelected; }								public function get deleteSelected():Boolean { return _deleteSelected; }							/** init			  *	---------------------------------------------------------------------------- */				public function init():void				{					_debug = true;										_purchaseEffectPlayDelayTimer = new Timer( 200, 1 );					_purchaseEffectPlayDelayTimer.addEventListener( TimerEvent.TIMER_COMPLETE, handlePurchaseEffectPlayDelayTimerCompleted, false, 0, true );										_contentClip.mouseEnabled = false;					_contentClip.mouseChildren = true;										_deleteClip = new DynamicUIButton();					_deleteClip.dynamicClip = delete_mc;					_deleteClip.dynamicInit();					delete_mc.mouseChildren = false;										_scrollerWeaponsClip = new GameboardMenuContentScroller();					_scrollerWeaponsClip.dynamicClip = scrollerWeapons_mc;					_scrollerWeaponsClip.dynamicInit();										onInsufficientChicken = new Signal();					onMenuIconSelected = new Signal();					onMenuDeleteSelected = new Signal();				}								private function handlePurchaseEffectPlayDelayTimerCompleted( event:TimerEvent ):void				{					_purchaseEffectPlayDelayTimer.reset();										purchaseEffect_mc.gotoAndPlay(1);					purchaseEffect_mc.shine_mc.gotoAndPlay(1);										SoundEffectPlayer.getInstance().playLibrarySound( "sfx_weapon_purchase.mp3", false, "sfx_weapon_purchase.mp3", "sfx_weapon_purchase.mp3", SoundEffectPlayer.SOUND_PLAYER_SFX );				}							/** show			  *	---------------------------------------------------------------------------- */				public function show():void				{					_contentClip.alpha = 0;					_contentClip.visible = true;										TweenLite.to( _contentClip, .25, {alpha:1} );										EventNotificationCenter.getInstance().addEventListener( BoogaEvent.ON_PURCHASE_SUCCESS, handlePurchaseItemSuccess );				}							/** hide			  *	---------------------------------------------------------------------------- */				public function hide():void				{					_contentClip.visible = false;										EventNotificationCenter.getInstance().removeEventListener( BoogaEvent.ON_PURCHASE_SUCCESS, handlePurchaseItemSuccess );				}							/** start			  *	---------------------------------------------------------------------------- *			  *	---------------------------------------------------------------------------- */				public function start():void				{					var icon:GameboardMenuContentIcon;					var i:uint;										//for( i=0; i<GameLevelDataIndex.getInstance().weaponsCount; ++i )					for( i=0; i<GameLevelDataIndex.getInstance().maxWeaponSlots; ++i )					{						if( i >= GameLevelCurrentData.getInstance().selectedAttacks.length )						{							//TODO:							//	Show the lock item on the remaining of the slots?							icon = new GameboardMenuContentIcon();							icon.contentClip = new (getDefinitionByName("GameboardMenu.contentIcon") as Class)();							icon.init();							icon.showLock();														_scrollerWeaponsClip.addMenuIcon( icon );						}						else						{							if( GameLevelCurrentData.getInstance().selectedAttacks[i].consumable )							{								icon = new GameboardMenuContentIconConsumable();								icon.contentClip = new (getDefinitionByName("GameboardMenu.contentIconConsumable") as Class)();								icon.init();							}							else							{								icon = new GameboardMenuContentIcon();								icon.contentClip = new (getDefinitionByName("GameboardMenu.contentIcon") as Class)();								icon.init();							}														//icon.item = Weapon(GameLevelDataIndex.getInstance().weapons[i]);							icon.item = GameLevelCurrentData.getInstance().selectedAttacks[i];														//trace( "attack is Weapon: "+(GameLevelCurrentData.getInstance().selectedAttacks[i] is Weapon) );							//trace( "attack is God: "+(GameLevelCurrentData.getInstance().selectedAttacks[i] is God) );														_scrollerWeaponsClip.addMenuIcon( icon );						}					}										//_deleteClip.addEventListener( "onClick", handleDeleteClicked, false, 0, true );					_deleteClip.dynamicClip.addEventListener( MouseEvent.MOUSE_DOWN, handleDeleteMouseDown, false, 0, true );										//_scrollerWeaponsClip.addEventListener( GameLevelEvent.ON_MENU_ICON_SELECTED, handleIconClicked, false, 0, true );					//_scrollerWeaponsClip.addEventListener( GameLevelEvent.ON_MENU_ICON_MOUSE_DOWN, handleIconMouseDown, false, 0, true );					_scrollerWeaponsClip.onMenuIconSelected.add( handleIconSelected );										//handleWeaponClicked(null);										updateMenu();										_deleteSelected = false;				}							/** kill			  *	---------------------------------------------------------------------------- *			  *	Kills the GameboardMenu, removes all event listeners, and remove content.			  *	---------------------------------------------------------------------------- */				public function kill():void				{					if( _debug ) ConsoleBroadcaster.broadcast( "GameboardMenu", "kill();" );										//_deleteClip.removeEventListener( "onClick", handleDeleteClicked );					_deleteClip.dynamicClip.removeEventListener( MouseEvent.MOUSE_DOWN, handleDeleteMouseDown );										//_scrollerWeaponsClip.removeEventListener( GameLevelEvent.ON_MENU_ICON_SELECTED, handleIconClicked );					//_scrollerWeaponsClip.removeEventListener( GameLevelEvent.ON_MENU_ICON_MOUSE_DOWN, handleIconMouseDown );					_scrollerWeaponsClip.onMenuIconSelected.remove( handleIconSelected );					_scrollerWeaponsClip.kill();										_currentIconSelected = null;					_deleteSelected = false;				}							/** updateMenu			  *	---------------------------------------------------------------------------- *			  *	---------------------------------------------------------------------------- */				public function updateMenu():void				{					_scrollerWeaponsClip.updateMenu( GameLevelCurrentData.getInstance().chickenCount );				}							/** resetMenu			  *	---------------------------------------------------------------------------- *			  *	Resets the menu, button states.			  *	---------------------------------------------------------------------------- */				public function resetMenu():void				{					if( _currentIconSelected != null )					{						_currentIconSelected = null;						//_scrollerWeaponsClip.resetMenu();						_scrollerWeaponsClip.updateMenu( GameLevelCurrentData.getInstance().chickenCount );					}										if( _deleteSelected )					{						_deleteClip.setActive( true );						_deleteSelected = false;					}				}							/** handleIconSelected			  *	---------------------------------------------------------------------------- *			  *	---------------------------------------------------------------------------- */				protected function handleIconSelected( icon:GameboardMenuContentIcon ):void				{					//trace( "handleIconSelected();" );					//trace( "active: "+event.currentTarget.active );										if( !icon.active )					{						SoundEffectPlayer.getInstance().playLibrarySound( "buzzer.wav", false, "buzzer.wav", "buzzer.wav", SoundEffectPlayer.SOUND_PLAYER_SFX );												//trace( "invalid weapon to choose" );						if( icon.item.consumable )						{							icon.playInsufficientAmount();						}						else						{							//dispatchEvent( new GameLevelEvent(GameLevelEvent.ON_CHICKEN_INSUFFICIENT) );							onInsufficientChicken.dispatch();						}						return;					}										if( _currentIconSelected != icon )					{						SoundEffectPlayer.getInstance().playLibrarySound( "sfx_mouse_click.wav", false, "sfx_mouse_click.wav", "sfx_mouse_click.wav" );												//_currentIconSelected = event.customParameters.icon;						_currentIconSelected = icon;												//trace( getQualifiedClassName(_currentIconSelected.item) );												//dispatchEvent( new GameLevelEvent(GameLevelEvent.ON_MENU_ICON_SELECTED) );						onMenuIconSelected.dispatch();					}				}				/*				protected function handleIconMouseDown( event:GameLevelEvent ):void				{					//trace( "active: "+event.customParameters.icon.active );										if( !event.customParameters.icon.active )					{						SoundEffectPlayer.getInstance().playLibrarySound( "buzzer.wav", false, "buzzer.wav", "buzzer.wav", SoundEffectPlayer.SOUND_PLAYER_SFX );												//trace( "invalid weapon to choose" );						if( event.customParameters.icon.item.consumable )						{							event.customParameters.icon.playInsufficientAmount();						}						else						{							//dispatchEvent( new GameLevelEvent(GameLevelEvent.ON_CHICKEN_INSUFFICIENT) );							onInsufficientChicken.dispatch();						}						return;					}										_currentIconSelected = event.customParameters.icon as GameboardMenuContentIcon;										dispatchEvent( new GameLevelEvent(GameLevelEvent.ON_MENU_ICON_MOUSE_DOWN) );				}*/							/** handleDeleteClicked			  *	---------------------------------------------------------------------------- *			  *	---------------------------------------------------------------------------- 				protected function handleDeleteClicked( event:Event ):void				{					_deleteSelected = true;					_deleteClip.setDeactive( true );										//dispatchEvent( new GameLevelEvent(GameLevelEvent.ON_MENU_DELETE_SELECTED) );				}*/							/** handleDeleteClicked			  *	---------------------------------------------------------------------------- *			  *	---------------------------------------------------------------------------- */				protected function handleDeleteMouseDown( event:MouseEvent ):void				{					_deleteSelected = true;					_deleteClip.setDeactive( true );										//dispatchEvent( new GameLevelEvent(GameLevelEvent.ON_MENU_DELETE_SELECTED) );					onMenuDeleteSelected.dispatch();				}								public function getGameboardMenuIcon( index:int=0 ):GameboardMenuContentIcon				{					return _scrollerWeaponsClip.menuIcons[index];				}								protected function handlePurchaseItemSuccess( event:CustomEvent ):void				{					ConsoleBroadcaster.broadcast( "GameboardMenu", "handlePurchaseItemSuccess();" );										if( event.customParameters.from == "PlayView" )					{						var updatedMenuIcon:GameboardMenuContentIcon = _scrollerWeaponsClip.updateConsumableCount();												ConsoleBroadcaster.broadcast( "GameboardMenu", "updatedMenuIcon: "+updatedMenuIcon );												if( updatedMenuIcon != null )						{							_purchaseEffectPlayDelayTimer.stop();							_purchaseEffectPlayDelayTimer.reset();														ConsoleBroadcaster.broadcast( "x: "+updatedMenuIcon.contentClip.x );							purchaseEffect_mc.x = updatedMenuIcon.contentClip.x + 23;							purchaseEffect_mc.y = 37;														_purchaseEffectPlayDelayTimer.start();						}					}				}								public function playPurchaseEffectForChicken():void				{					purchaseEffect_mc.x = 35;					purchaseEffect_mc.y = -5;										_purchaseEffectPlayDelayTimer.start();				}		}			}