﻿/** TableBackgroundView  *	---------------------------------------------------------------------------- *  *	@author:  *		Christian Widodo [christian@avatarlabs.com]  *	---------------------------------------------------------------------------- */ 	package com.boogabooga.ui.maingame	{		import flash.display.MovieClip;		import flash.events.Event;		import flash.events.MouseEvent;		import flash.geom.Point;		import flash.geom.Rectangle;		import flash.text.TextField;		import flash.text.TextFieldAutoSize;		import flash.ui.Mouse;		import flash.utils.getDefinitionByName;				import com.avatarlabs.utils.UtilFunctions;		import com.avatarlabs.utils.VectorUtil;		import com.avatarlabs.utils.console.ConsoleBroadcaster;		import com.avatarlabs.utils.events.AssetLoaderEvent;		import com.avatarlabs.utils.events.CustomEvent;		import com.avatarlabs.utils.events.EventNotificationCenter;		import com.avatarlabs.utils.sound.SoundEffectPlayer;		import com.avatarlabs.utils.userinterface.DynamicUIButton;		import com.avatarlabs.utils.text.TextFormatting;				import com.boogabooga.data.SoundsIndex;		import com.boogabooga.data.StringsIndex;		import com.boogabooga.events.BoogaEvent;		import com.boogabooga.ui.maingame.AbstractContentView;		import com.boogabooga.ui.maingame.IContentView;				//import com.boogabooga.data.maingame.Cryptology;		//import com.boogabooga.data.maingame.RequestCryptology;				public class TableBackgroundView extends AbstractContentView implements IContentView		{						/**	Stage Instances **/			public var bookLight_mc:MovieClip;			public var magnifyingGlass_mc:MovieClip;			public var pencil_mc:MovieClip;			public var notepad_mc:MovieClip;			public var flicker2_mc:MovieClip;			public var candleFlame_mc:MovieClip;			public var candleOnTable_mc:MovieClip;			public var candle_mc:MovieClip;			public var compass_mc:MovieClip;			public var angleMeasure_mc:MovieClip;			public var backdrop_mc:MovieClip;			/**	End of Stage Instances **/						/** Constructor			  *	---------------------------------------------------------------------------- */				public function TableBackgroundView()				{									}								override public function set contentClip( m:MovieClip ):void				{					super.contentClip = m;										//var maskRect:Rectangle = new Rectangle( 0, 0, 760, 625 );					_contentClip.scrollRect = new Rectangle( 0, 0, 760, 625 );					_contentClip.cacheAsBitmap = true;										bookLight_mc = _contentClip.bookLight_mc;					//bookLight_mc.scrollRect = maskRect;					magnifyingGlass_mc = _contentClip.magnifyingGlass_mc;					magnifyingGlass_mc.cacheAsBitmap = true;					//magnifyingGlass_mc.scrollRect = maskRect;					pencil_mc = _contentClip.pencil_mc;					pencil_mc.cacheAsBitmap = true;					//pencil_mc.scrollRect = maskRect;					notepad_mc = _contentClip.notepad_mc;					notepad_mc.cacheAsBitmap = true;					//notepad_mc.scrollRect = maskRect;					flicker2_mc = _contentClip.flicker2_mc;					//flicker2_mc.scrollRect = maskRect;					candleFlame_mc = _contentClip.candleFlame_mc;					//candleFlame_mc.scrollRect = maskRect;					candleOnTable_mc = _contentClip.candleOnTable_mc;					candleOnTable_mc.cacheAsBitmap = true;					//candleOnTable_mc.scrollRect = maskRect;					candle_mc = _contentClip.candle_mc;					//candle_mc.scrollRect = maskRect;					compass_mc = _contentClip.compass_mc;					compass_mc.cacheAsBitmap = true;					//compass_mc.scrollRect = maskRect;					angleMeasure_mc = _contentClip.angleMeasure_mc;					angleMeasure_mc.cacheAsBitmap = true;					//angleMeasure_mc.scrollRect = maskRect;					backdrop_mc = _contentClip.backdrop_mc;					backdrop_mc.cacheAsBitmap = true;					//backdrop_mc.scrollRect = maskRect;									}								override public function init():void				{					super.init();										bookLight_mc.mouseChildren = false;					bookLight_mc.mouseEnabled = false;					magnifyingGlass_mc.mouseChildren = false;					magnifyingGlass_mc.mouseEnabled = false;					pencil_mc.mouseChildren = false;					pencil_mc.mouseEnabled = false;					notepad_mc.mouseChildren = false;					notepad_mc.mouseEnabled = false;					flicker2_mc.mouseChildren = false;					flicker2_mc.mouseEnabled = false;					candleFlame_mc.mouseChildren = false;					candleFlame_mc.mouseEnabled = false;					candleOnTable_mc.mouseChildren = false;					candleOnTable_mc.mouseEnabled = false;					candle_mc.mouseChildren = false;					candle_mc.mouseEnabled = false;					compass_mc.mouseChildren = false;					compass_mc.mouseEnabled = false;					angleMeasure_mc.mouseChildren = false;					angleMeasure_mc.mouseEnabled = false;									}							/** show			  *	---------------------------------------------------------------------------- *			  *	Shows the view.			  *	---------------------------------------------------------------------------- */				override public function show():void				{					ConsoleBroadcaster.broadcast( "TableBackgroundView", "show();" );										super.show();									}							/** viewDidAppear			  *	---------------------------------------------------------------------------- *			  *	This function is called when the view appears.			  *	---------------------------------------------------------------------------- */				override protected function viewDidAppear():void				{					bookLight_mc.play();					flicker2_mc.play();					candleFlame_mc.play();					candle_mc.play();										super.viewDidAppear();				}							/** hide			  *	---------------------------------------------------------------------------- *			  *	Hides the view.			  *	---------------------------------------------------------------------------- */				override public function hide():void				{					ConsoleBroadcaster.broadcast( "TableBackgroundView", "hide();" );										super.hide();				}							/** viewDidDisappear			  *	---------------------------------------------------------------------------- *			  *	This function is called when the view disappears.			  *	---------------------------------------------------------------------------- */				override protected function viewDidDisappear():void				{					bookLight_mc.stop();					flicker2_mc.stop();					candleFlame_mc.stop();					candle_mc.stop();										super.viewDidDisappear();				}						}	}