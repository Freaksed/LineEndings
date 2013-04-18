﻿/** ChooseGiftView  *	---------------------------------------------------------------------------- *  *	@author:  *		Christian Widodo [christian@avatarlabs.com]  *	---------------------------------------------------------------------------- */ 	package com.boogabooga.ui.maingame.play	{		import flash.display.Bitmap;		import flash.display.BitmapData;		import flash.display.Loader;		import flash.display.MovieClip;		import flash.events.Event;		import flash.events.EventDispatcher;		import flash.net.URLRequest;		import flash.system.ApplicationDomain;		import flash.system.LoaderContext;		import flash.text.TextField;		import flash.text.TextFieldAutoSize;		import flash.utils.getDefinitionByName;				import com.avatarlabs.utils.VectorUtil;		import com.avatarlabs.utils.cache.BitmapDataManager;		import com.avatarlabs.utils.console.ConsoleBroadcaster;		import com.avatarlabs.utils.events.CustomEvent;		import com.avatarlabs.utils.events.EventNotificationCenter;		import com.avatarlabs.utils.sound.SoundEffectPlayer;		import com.avatarlabs.utils.text.TextFormatting;		import com.avatarlabs.utils.userinterface.DynamicUIButton;		import org.osflash.signals.Signal;				import com.boogabooga.controller.maingame.MainGameController;		import com.boogabooga.data.SettingsIndex;		import com.boogabooga.data.SoundsIndex;		import com.boogabooga.data.StringsIndex;		import com.boogabooga.data.gamelevel.AbstractGameObject;		import com.boogabooga.data.gamelevel.GameLevelDataIndex;		import com.boogabooga.data.maingame.Gift;		import com.boogabooga.data.maingame.Treasure;		import com.boogabooga.data.maingame.Village;		import com.boogabooga.events.BoogaEvent;		import com.boogabooga.ui.maingame.DescriptionScroller;		import com.boogabooga.utils.GameLevelUtil;				public class ChooseGiftView extends EventDispatcher		{			protected var _contentClip:MovieClip;			//protected var _currentGiftIndex:int;			protected var _totalGifts:int;			protected var _gifts:Vector.<Gift>;			protected var _giftClips:Vector.<ChooseGiftViewRowClip>;						protected var _exitClip:DynamicUIButton;			protected var _scrollerClip:DescriptionScroller;			//protected var _prevArrowClip:DynamicUIButton;			//protected var _nextArrowClip:DynamicUIButton;			protected var _playClip:DynamicUIButton;						protected var _selectedGift:Gift;						public var onGiftSelectionDone:Signal;			public var onGiftSelectionCancelled:Signal;						/**	Stage Instances **/			public var background_mc:MovieClip;			public var exit_mc:MovieClip;			public var header_mc:MovieClip;			public var scroller_mc:MovieClip;			//public var giftName_mc:MovieClip;			//public var descriptionScroller_mc:MovieClip;			//public var itemImage_mc:MovieClip;			//public var prevArrow_mc:MovieClip;			//public var nextArrow_mc:MovieClip;			//public var person_mc:MovieClip;			public var play_mc:MovieClip;			//public var giftNumber_mc:MovieClip;			//public var elements_mc:MovieClip;			/**	End of Stage Instances **/						/** Constructor			  *	---------------------------------------------------------------------------- */				public function ChooseGiftView()				{					//init();				}								//public function get currentGiftIndex():int { return _currentGiftIndex; }								public function set contentClip( m:MovieClip ):void				{					_contentClip = m;										background_mc = _contentClip.background_mc;					exit_mc = _contentClip.exit_mc;					header_mc = _contentClip.header_mc;					scroller_mc = _contentClip.scroller_mc;					//giftName_mc = _contentClip.giftName_mc;					//descriptionScroller_mc = _contentClip.descriptionScroller_mc;					//itemImage_mc = _contentClip.itemImage_mc;					//prevArrow_mc = _contentClip.prevArrow_mc;					//nextArrow_mc = _contentClip.nextArrow_mc;					//person_mc = _contentClip.person_mc;					play_mc = _contentClip.play_mc;					//giftNumber_mc = _contentClip.giftNumber_mc;					//elements_mc = _contentClip.elements_mc;										//descriptionScroller_mc.content_mc.label_txt.autoSize = TextFieldAutoSize.LEFT;					//descriptionScroller_mc.content_mc.label_txt.styleSheet = SettingsIndex.getInstance().fontManager.getStyleSheet();										_exitClip = new DynamicUIButton();					_exitClip.dynamicClip = exit_mc;					_exitClip.dynamicInit();										//_prevArrowClip = new DynamicUIButton();					//_prevArrowClip.dynamicClip = prevArrow_mc;					//_prevArrowClip.dynamicInit();										//_nextArrowClip = new DynamicUIButton();					//_nextArrowClip.dynamicClip = nextArrow_mc;					//_nextArrowClip.dynamicInit();										_playClip = new DynamicUIButton();					_playClip.dynamicClip = play_mc;					_playClip.dynamicInit();										_scrollerClip = new DescriptionScroller();					_scrollerClip.dynamicClip = scroller_mc;					_scrollerClip.dynamicInit();									}				public function get contentClip():MovieClip { return _contentClip; }								public function get selectedGift():Gift { return _selectedGift; }							/** init			  *	---------------------------------------------------------------------------- *			  *	---------------------------------------------------------------------------- */				public function init():void				{					//TextFormatting.formatTextWithFontName( header_mc.label_txt, "Choose a gift !", "SF Fedora", false, TextFieldAutoSize.CENTER );					TextFormatting.formatTextWithFontName( header_mc.label_txt, StringsIndex.getInstance().getStringByName("GIFT_CHOOSE_GIFT"), "Lithos Pro Black", false, TextFieldAutoSize.CENTER );										_exitClip.addEventListener( "onClick", handleExitClicked, false, 0, true );					_exitClip.addEventListener( "onSetFocus", handleExitRolledOver, false, 0, true );					//_prevArrowClip.addEventListener( "onClick", handlePrevArrowClicked, false, 0, true );					//_prevArrowClip.addEventListener( "onSetFocus", handlePrevArrowRolledOver, false, 0, true );					//_nextArrowClip.addEventListener( "onClick", handleNextArrowClicked, false, 0, true );					//_nextArrowClip.addEventListener( "onSetFocus", handleNextArrowRolledOver, false, 0, true );					_playClip.addEventListener( "onClick", handlePlayClicked, false, 0, true );					_playClip.addEventListener( "onSetFocus", handlePlayRolledOver, false, 0, true );										_gifts = new Vector.<Gift>;					_giftClips = new Vector.<ChooseGiftViewRowClip>;										onGiftSelectionCancelled = new Signal();					onGiftSelectionDone = new Signal();										EventNotificationCenter.getInstance().addSignalListener( BoogaEvent.ON_LANGUAGE_CHANGED, handleLanguageChanged, this );				}							/** initGifts			  *	---------------------------------------------------------------------------- *			  *	Initializes the view with current user's gifts.			  *	---------------------------------------------------------------------------- */				public function initGifts():void				{					//_currentGiftIndex = 0;					_totalGifts = MainGameController.getInstance().currentUser.gifts.length;					_selectedGift = null;										VectorUtil.removeAll( _gifts );										var i:int, j:int;					var sameItemType:Boolean = false;										for( i=0; i<_totalGifts; ++i )					{						sameItemType = false;												for( j=0; j<_gifts.length; ++j )						{							if( _gifts[j].type == MainGameController.getInstance().currentUser.gifts[i].type && _gifts[j].item.id == MainGameController.getInstance().currentUser.gifts[i].item.id )							{								sameItemType = true;								break;							}						}												if( !sameItemType )						{							_gifts.push( MainGameController.getInstance().currentUser.gifts[i] );						}					}										_totalGifts = _gifts.length;					var giftClip:ChooseGiftViewRowClip;										for( i=0; i<_totalGifts; ++i )					{						giftClip = new ChooseGiftViewRowClip();						giftClip.contentClip = new ( getDefinitionByName('ChooseGiftView.row') as Class )();						giftClip.init();						giftClip.onCheckBoxClicked.add( handleGiftClicked );						giftClip.setGift( _gifts[i] );						giftClip.contentClip.y = 83 * i;												if( i % 2 == 0 )						{							giftClip.lightBg_mc.visible = false;							giftClip.darkBg_mc.visible = true;						}						else						{							giftClip.lightBg_mc.visible = true;							giftClip.darkBg_mc.visible = false;						}												scroller_mc.content_mc.addChild( giftClip.contentClip );						_giftClips.push( giftClip );					}										_giftClips[0].check();					_selectedGift = _giftClips[0].gift;										_scrollerClip.toggleSlider();										if( _totalGifts == 1 )					{						scroller_mc.y = 235;					}					else if( _totalGifts == 2 )					{						scroller_mc.y = 195;					}					else					{						scroller_mc.y = 155;					}										//showGift();					//toggleUI();				}							/** reset			  *	---------------------------------------------------------------------------- *			  *	---------------------------------------------------------------------------- */				public function reset():void				{					for( var i:int=0; i<_giftClips.length; ++i )					{						_giftClips[i].kill();						scroller_mc.content_mc.removeChild( _giftClips[i].contentClip );					}					VectorUtil.removeAll( _giftClips );										_scrollerClip.resetScroller();				}							/** show			  *	---------------------------------------------------------------------------- *			  *	Shows this view.			  *	---------------------------------------------------------------------------- */				public function show():void				{					_contentClip.visible = true;				}							/** hide			  *	---------------------------------------------------------------------------- *			  *	Hides this view and resets it.			  *	---------------------------------------------------------------------------- */				public function hide():void				{					_contentClip.visible = false;										reset();				}								private function handleGiftClicked( clip:ChooseGiftViewRowClip ):void				{					_selectedGift = clip.gift;										for( var i:int=0; i<_giftClips.length; ++i )					{						if( _giftClips[i] != clip )						{							_giftClips[i].uncheck();						}					}				}							/** showGift			  *	---------------------------------------------------------------------------- *			  *	Shows the current gift based on the index.			  *	---------------------------------------------------------------------------- 				protected function showGift():void				{					var gift:Gift = _gifts[_currentGiftIndex];//MainGameController.getInstance().currentUser.gifts[_currentGiftIndex];										if( gift != null )					{						reset();												//var item:AbstractGameObject = MainGameController.getInstance().currentUser.getItemForGift( gift.id );												TextFormatting.formatTextWithFontName( giftName_mc.label_txt, StringsIndex.getInstance().getString(String(gift.item.name)), "Lithos Pro Black", false, TextFieldAutoSize.LEFT );						//TextFormatting.formatTextWithFontName( _scrollerClip.content_mc.label_txt, StringsIndex.getInstance().getString(String(gift.item.description)), "Lithos Pro Black", false, TextFieldAutoSize.LEFT );						_scrollerClip.content_mc.label_txt.htmlText = '<span class="font2Default">'+StringsIndex.getInstance().getString(String(gift.item.description))+'\n'+gift.item.statistic+'</span>';						_scrollerClip.toggleSlider();												var element:MovieClip;						var elements:Array = GameLevelUtil.getItemElements( gift.item );												for( var i:int=0; i<elements.length; ++i )						{							element = new (getDefinitionByName(elements[i]) as Class)();							//element.width = 24;							//element.height = 25;							//element.x = -12;							element.y = -35 * i;							elements_mc.addChild( element );						}												TextFormatting.formatTextWithFontName( person_mc.name_txt, ("From: "+gift.fromFirstName+" "+gift.fromLastName), "Lithos Pro Black", false, TextFieldAutoSize.LEFT );												//if( _totalGifts > 1 )						//{							//TextFormatting.formatTextWithFontName( giftNumber_mc.label_txt, (_currentGiftIndex+1)+"/"+_totalGifts, "SF Fedora", false, TextFieldAutoSize.LEFT );							//TextFormatting.formatTextWithFontName( giftNumber_mc.label_txt, (_currentGiftIndex+1)+"/"+_totalGifts, "Lithos Pro Black", false, TextFieldAutoSize.LEFT );							//giftNumber_mc.visible = true;						//}						//else						//{							//giftNumber_mc.visible = false;						//}												if( BitmapDataManager.getInstance().getBitmapData("UserFBProfilePic_"+gift.fromId)== null )						{							BitmapDataManager.getInstance().addEventListener( Event.COMPLETE, handleLoadBitmapComplete );							BitmapDataManager.getInstance().loadBitmapToCache( gift.fromProfilePicURL, "UserFBProfilePic_"+gift.fromId );						}						else						{							addUserImage();						}												if( BitmapDataManager.getInstance().getBitmapData(gift.item.cacheIconId) == null )						{							BitmapDataManager.getInstance().addEventListener( Event.COMPLETE, handleLoadIconComplete );							BitmapDataManager.getInstance().loadBitmapToCache( SettingsIndex.getInstance().contentURL+gift.item.iconURL, gift.item.cacheIconId );						}						else						{							addIconImage();						}																		}				}*/				/*				protected function handleLoadBitmapComplete( event:CustomEvent ):void				{					if( event.customParameters.cacheId == "UserFBProfilePic_"+_gifts[_currentGiftIndex].fromId )					{						BitmapDataManager.getInstance().removeEventListener( Event.COMPLETE, handleLoadBitmapComplete );												addUserImage();					}				}								protected function addUserImage():void				{					var bitmap:Bitmap = new Bitmap(BitmapDataManager.getInstance().getBitmapData("UserFBProfilePic_"+_gifts[_currentGiftIndex].fromId).bitmapData);						bitmap.smoothing = true;						bitmap.width = bitmap.height = 50;										person_mc.image_mc.addChild( bitmap );				}								protected function handleLoadIconComplete( event:CustomEvent ):void				{					if( event.customParameters.cacheId == "UserFBProfilePic_"+_gifts[_currentGiftIndex].item.cacheIconId )					{						BitmapDataManager.getInstance().removeEventListener( Event.COMPLETE, handleLoadIconComplete );												addIconImage();					}				}								protected function addIconImage():void				{					var bitmap:Bitmap = new Bitmap(BitmapDataManager.getInstance().getBitmapData(_gifts[_currentGiftIndex].item.cacheIconId).bitmapData);						bitmap.smoothing = true;						bitmap.width = bitmap.height = 80;						bitmap.x = bitmap.y = -40;										itemImage_mc.addChild( bitmap );				}*/							/** toggleUI			  *	---------------------------------------------------------------------------- *			  *	Toggles the previous and next buttons on/off.			  *	---------------------------------------------------------------------------- 				protected function toggleUI():void				{					if( _totalGifts == 1 )					{						//_nextArrowClip.dynamicClip.visible = false;						//_prevArrowClip.dynamicClip.visible = false;						_prevArrowClip.setDeactive();						_nextArrowClip.setDeactive();						GameLevelUtil.addDesaturatedFilterToMovieClip( _prevArrowClip.dynamicClip );						GameLevelUtil.addDesaturatedFilterToMovieClip( _nextArrowClip.dynamicClip );						_prevArrowClip.dynamicClip.alpha = .3;						_nextArrowClip.dynamicClip.alpha = .3;					}					else					{						if( _currentGiftIndex == 0 )						{							//_prevArrowClip.dynamicClip.visible = false;							_prevArrowClip.setDeactive();							GameLevelUtil.addDesaturatedFilterToMovieClip( _prevArrowClip.dynamicClip );							_prevArrowClip.dynamicClip.alpha = .3;						}						else						{							//_prevArrowClip.dynamicClip.visible = true;							_prevArrowClip.setActive();							GameLevelUtil.removeDesaturatedFilterFromMovieClip( _prevArrowClip.dynamicClip );							_prevArrowClip.dynamicClip.alpha = 1;						}												if( _currentGiftIndex == _totalGifts-1 )						{							//_nextArrowClip.dynamicClip.visible = false;							_nextArrowClip.setDeactive();							GameLevelUtil.addDesaturatedFilterToMovieClip( _nextArrowClip.dynamicClip );							_nextArrowClip.dynamicClip.alpha = .3;						}						else						{							//_nextArrowClip.dynamicClip.visible = true;							_nextArrowClip.setActive();							GameLevelUtil.removeDesaturatedFilterFromMovieClip( _nextArrowClip.dynamicClip );							_nextArrowClip.dynamicClip.alpha = 1;						}					}				}*/							/** handlePrevArrowClicked			  *	---------------------------------------------------------------------------- *			  *	Goes to the previous page.			  *	---------------------------------------------------------------------------- 				protected function handlePrevArrowClicked( event:Event ):void				{					--_currentGiftIndex;										//if( _currentGiftIndex < 0 )						//_currentGift = _totalGifts-1;										showGift();					toggleUI();										//SoundEffectPlayer.getInstance().setVolume( SoundsIndex.getInstance().getSoundBySoundId("sfx_mouse_click.wav").volume, 0, "sfx_mouse_click.wav" );					SoundEffectPlayer.getInstance().playLibrarySound( "sfx_mouse_click.wav", false, "sfx_mouse_click.wav", "sfx_mouse_click.wav" );				}								private function handlePrevArrowRolledOver( event:Event ):void				{					SoundEffectPlayer.getInstance().playLibrarySound( "sfx_mouse_rollover.wav", false, "sfx_mouse_rollover.wav", "sfx_mouse_rollover.wav" );				}*/							/** handleNextArrowClicked			  *	---------------------------------------------------------------------------- *			  *	Goes to the next page.			  *	---------------------------------------------------------------------------- 				protected function handleNextArrowClicked( event:Event ):void				{					++_currentGiftIndex;										showGift();					toggleUI();										//SoundEffectPlayer.getInstance().setVolume( SoundsIndex.getInstance().getSoundBySoundId("sfx_mouse_click.wav").volume, 0, "sfx_mouse_click.wav" );					SoundEffectPlayer.getInstance().playLibrarySound( "sfx_mouse_click.wav", false, "sfx_mouse_click.wav", "sfx_mouse_click.wav" );				}								private function handleNextArrowRolledOver( event:Event ):void				{					SoundEffectPlayer.getInstance().playLibrarySound( "sfx_mouse_rollover.wav", false, "sfx_mouse_rollover.wav", "sfx_mouse_rollover.wav" );				}*/								protected function handleExitClicked( event:Event ):void				{					//SoundEffectPlayer.getInstance().setVolume( SoundsIndex.getInstance().getSoundBySoundId("sfx_mouse_click.wav").volume, 0, "sfx_mouse_click.wav" );					SoundEffectPlayer.getInstance().playLibrarySound( "sfx_mouse_click.wav", false, "sfx_mouse_click.wav", "sfx_mouse_click.wav" );										//dispatchEvent( new BoogaEvent(BoogaEvent.GIFT_SELECTION_CANCEL) );					onGiftSelectionCancelled.dispatch();				}								private function handleExitRolledOver( event:Event ):void				{					SoundEffectPlayer.getInstance().playLibrarySound( "sfx_mouse_rollover.wav", false, "sfx_mouse_rollover.wav", "sfx_mouse_rollover.wav" );				}								protected function handlePlayClicked( event:Event ):void				{					//SoundEffectPlayer.getInstance().setVolume( SoundsIndex.getInstance().getSoundBySoundId("sfx_mouse_click.wav").volume, 0, "sfx_mouse_click.wav" );					SoundEffectPlayer.getInstance().playLibrarySound( "sfx_mouse_click.wav", false, "sfx_mouse_click.wav", "sfx_mouse_click.wav" );										//dispatchEvent( new BoogaEvent(BoogaEvent.GIFT_SELECTION_DONE) );					onGiftSelectionDone.dispatch();				}								private function handlePlayRolledOver( event:Event ):void				{					SoundEffectPlayer.getInstance().playLibrarySound( "sfx_mouse_rollover.wav", false, "sfx_mouse_rollover.wav", "sfx_mouse_rollover.wav" );				}							/** handleLanguageChanged			  *	---------------------------------------------------------------------------- *			  *	When a language is changed, update the text accordingly.			  *	---------------------------------------------------------------------------- */				protected function handleLanguageChanged( customParameters:Object ):void				{					TextFormatting.formatTextWithFontName( header_mc.label_txt, StringsIndex.getInstance().getStringByName("GIFT_CHOOSE_GIFT"), "Lithos Pro Black", false, TextFieldAutoSize.CENTER );									}						}	}