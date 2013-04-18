﻿/** CryptologyPopup  *	---------------------------------------------------------------------------- *  *	@author:  *		Christian Widodo [christian@avatarlabs.com]  *	---------------------------------------------------------------------------- */ 	package com.boogabooga.ui.maingame.islandselection	{		import flash.display.Bitmap;		import flash.display.MovieClip;		import flash.events.Event;		import flash.events.EventDispatcher;		import flash.events.MouseEvent;		import flash.text.TextField;		import flash.text.TextFieldAutoSize;		import flash.utils.getDefinitionByName;				import com.avatarlabs.utils.cache.BitmapDataManager;		import com.avatarlabs.utils.console.ConsoleBroadcaster;		import com.avatarlabs.utils.events.AssetLoaderEvent;		import com.avatarlabs.utils.events.CustomEvent;		import com.avatarlabs.utils.text.TextFormatting;		import com.avatarlabs.utils.userinterface.UIButton;		import com.avatarlabs.utils.userinterface.UIScroller;		import com.avatarlabs.utils.userinterface.UISlider;				import com.boogabooga.controller.maingame.MainGameController;		import com.boogabooga.data.maingame.Village;		import com.boogabooga.data.gamelevel.AbstractGameObject;		import com.boogabooga.data.gamelevel.GameLevelDataIndex;		import com.boogabooga.data.maingame.Cryptology;		import com.boogabooga.data.maingame.Treasure;		import com.boogabooga.ui.maingame.cryptology.CryptologySymbol;		import com.boogabooga.events.BoogaEvent;		import flash.geom.Rectangle;		import flash.geom.Point;				public class CryptologyPopup extends MovieClip		{			protected var _item:AbstractGameObject;			protected var _bounds:Rectangle;						/**	Stage Instances **/			public var header_mc:MovieClip;			public var play_mc:UIButton;			public var playAgain_mc:UIButton;			public var gameLevel_mc:MovieClip;			public var backgroundTopRight_mc:MovieClip;			public var backgroundTopLeft_mc:MovieClip;			public var backgroundBottomRight_mc:MovieClip;			public var backgroundBottomLeft_mc:MovieClip;			/**	End of Stage Instances **/						/** Constructor			  *	---------------------------------------------------------------------------- */				public function CryptologyPopup()				{					init();				}							/** init			  *	---------------------------------------------------------------------------- */				public function init():void				{					backgroundTopLeft_mc.visible = false;					backgroundBottomRight_mc.visible = false;					backgroundBottomLeft_mc.visible = false;										_bounds = this.getBounds( this );									}							/** show			  *	---------------------------------------------------------------------------- */				public function show():void				{					visible = true;										startCheckingBound();				}							/** hide			  *	---------------------------------------------------------------------------- */				public function hide():void				{					stopCheckingBound();										visible = false;				}							/** setHeader			  *	---------------------------------------------------------------------------- */				public function setHeader( text:String ):void				{					//TextFormatting.formatTextWithFontName( header_mc.label_txt, text, "SF Fedora", false, TextFieldAutoSize.CENTER );					TextFormatting.formatTextWithFontName( header_mc.label_txt, text, "Lithos Pro Black", false, TextFieldAutoSize.CENTER );				}							/** startCheckingBound			  *	---------------------------------------------------------------------------- */				protected function startCheckingBound():void				{					stage.addEventListener( MouseEvent.MOUSE_MOVE, handleMouseMoved, false, 0, true );				}								protected function stopCheckingBound():void				{					stage.removeEventListener( MouseEvent.MOUSE_MOVE, handleMouseMoved );				}							/** handleMouseMoved			  *	---------------------------------------------------------------------------- *			  *	Checks to see if mouse is out of the boundary of the popup. If so, close it.			  *	---------------------------------------------------------------------------- */				protected function handleMouseMoved( event:MouseEvent ):void				{					var localPosition:Point = this.globalToLocal( new Point(event.stageX, event.stageY) );										//trace( "x: "+localPosition.x+", y:"+localPosition.y );					//trace( "bounds.top: "+_bounds.top+", bottom: "+_bounds.bottom+", left: "+_bounds.left+", right: "+_bounds.right );										if( localPosition.x < _bounds.left || localPosition.x > _bounds.right || localPosition.y < _bounds.top || localPosition.y > _bounds.bottom )					{						hide();						//trace( "supposed to hide now" );					}				}						}	}