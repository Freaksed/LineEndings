﻿/** WaveEditorView  *	---------------------------------------------------------------------------- *  *	@desc:  *		This is the gameboard editor class used in the editor file.  *		This class provides a way for users to modify game levels.  *	@author:  *		Christian Widodo [christian@avatarlabs.com]  *	---------------------------------------------------------------------------- */ 	package com.boogabooga.ui.gameleveleditor	{		import flash.display.MovieClip;		import flash.display.StageDisplayState;		import flash.events.Event;		import flash.events.EventDispatcher;		import flash.events.FullScreenEvent;		import flash.events.IOErrorEvent;		import flash.events.MouseEvent;		import flash.events.ProgressEvent;		import flash.events.TimerEvent;		import flash.external.ExternalInterface;		import flash.geom.Point;		import flash.geom.Rectangle;		import flash.net.LocalConnection;		import flash.net.URLLoader;		import flash.net.URLRequest;		import flash.net.URLRequestMethod;		import flash.net.URLVariables;		import flash.system.System;		import flash.text.TextField;		import flash.utils.getDefinitionByName;		import flash.utils.getQualifiedClassName;		import flash.utils.Timer;				import com.greensock.TweenLite;		import com.greensock.easing.Sine;		import com.avatarlabs.utils.UtilFunctions;		import com.avatarlabs.utils.VectorUtil;		import com.avatarlabs.utils.console.ConsoleBroadcaster;		import com.avatarlabs.utils.events.CustomEvent;		import com.avatarlabs.utils.events.EventNotificationCenter;		import com.avatarlabs.utils.loader.CustomLoader;		import com.avatarlabs.utils.sound.SoundEffectPlayer;		import com.avatarlabs.utils.timers.CustomTimer;		import com.avatarlabs.utils.timers.ElapsedTime;		import com.avatarlabs.utils.userinterface.DynamicUIButton;		import com.avatarlabs.utils.userinterface.DynamicUIScroller;		import com.avatarlabs.utils.userinterface.DynamicUISlider;				import com.boogabooga.controller.gamelevel.GameboardController;		import com.boogabooga.controller.gamelevel.WeaponDisplayObjectController;		import com.boogabooga.data.gamelevel.GameLevelDataIndex;		import com.boogabooga.ui.gamelevel.Gameboard;		import com.boogabooga.ui.gamelevel.GameboardTile;		import com.boogabooga.ui.gamelevel.GameLevelDisplayLayer;		import com.boogabooga.data.gamelevel.GameLevel;		import com.boogabooga.data.gamelevel.WaveZone;						public class WaveEditorView extends EventDispatcher		{			protected var _contentClip:MovieClip;						protected var _waveZones:Vector.<WaveZone>;			protected var _waveZoneClips:Vector.<WaveZoneClip>;			protected var _waveZoneClipClass:Class;						protected var _waveEditorViewScrollerClip:DynamicUIScroller;			protected var _closeClip:DynamicUIButton;						/**	Stage Instances **/			public var waveEditorViewScroller_mc:MovieClip;			public var close_mc:MovieClip;			/**	End of Stage Instances **/						/** Constructor			  *	---------------------------------------------------------------------------- */				public function WaveEditorView()				{					//init();				}								public function set contentClip( m:MovieClip ):void				{					_contentClip = m;										waveEditorViewScroller_mc = _contentClip.waveEditorViewScroller_mc;					close_mc = _contentClip.close_mc;					close_mc.mouseChildren = false;										var sliderClip:DynamicUISlider = new DynamicUISlider();						sliderClip.dynamicClip = waveEditorViewScroller_mc.slider_mc;						sliderClip.dynamicInit();						sliderClip.setProperty( "y" );						sliderClip.setHandle( waveEditorViewScroller_mc.slider_mc.handle_mc );						sliderClip.setBounds( waveEditorViewScroller_mc.slider_mc.bound_mc );										_waveEditorViewScrollerClip = new DynamicUIScroller();					_waveEditorViewScrollerClip.dynamicClip = waveEditorViewScroller_mc;					_waveEditorViewScrollerClip.dynamicInit();					_waveEditorViewScrollerClip.setProperty( "y" );					_waveEditorViewScrollerClip.setSlider( sliderClip );					_waveEditorViewScrollerClip.setContent( waveEditorViewScroller_mc.content_mc );					_waveEditorViewScrollerClip.setMask( waveEditorViewScroller_mc.mask_mc );										_closeClip = new DynamicUIButton();					_closeClip.dynamicClip = close_mc;					_closeClip.dynamicInit();				}				public function get contentClip():MovieClip { return _contentClip; }								public function set waveZones( w:Vector.<WaveZone> ):void				{					_waveZones = w;										for( var i:int=_waveZones.length; i<3; ++i )					{						_waveZones.push( new WaveZone() );					}										for( i=0; i<_waveZones.length; ++i )					{						_waveZones[i].name = "WaveZone"+(i+1);						_waveZoneClips[i].waveZone = _waveZones[i];					}				}				public function get waveZones():Vector.<WaveZone>				{					for( var i:int=0; i<_waveZoneClips.length; ++i )					{						_waveZones[i] = _waveZoneClips[i].waveZone;						_waveZones[i].name = "WaveZone"+(i+1);					}										return _waveZones;				}							/** init			  *	---------------------------------------------------------------------------- */				public function init():void				{					_waveZones = new Vector.<WaveZone>;					_waveZoneClips = new Vector.<WaveZoneClip>;										_waveZoneClipClass = getDefinitionByName("WaveZoneClipLibrary") as Class;										_closeClip.addEventListener( "onClick", handleCloseClicked, false, 0, true );										var waveZoneClip:WaveZoneClip;					var lastWaveZoneClip:WaveZoneClip;										for( var i:int=0; i<3; ++i )					{						waveZoneClip = new WaveZoneClip();						waveZoneClip.contentClip = new _waveZoneClipClass();						waveZoneClip.init();						waveZoneClip.x = 0;						waveZoneClip.y = i == 0 ? 0 : lastWaveZoneClip.y + lastWaveZoneClip.bounds_mc.height + 10;						waveZoneClip.header_mc.label_txt.text = "WAVE ZONE "+(i+1);						waveZoneClip.addEventListener( "onWaveAdded", handleWaveAdded, false, 0, true );						waveZoneClip.addEventListener( "onWaveDeleted", handleWaveDeleted, false, 0, true );												_waveEditorViewScrollerClip.dynamicClip.content_mc.addChildAt( waveZoneClip.contentClip, 0 );												lastWaveZoneClip = waveZoneClip;												_waveZoneClips.push( waveZoneClip );					}										_waveEditorViewScrollerClip.toggleSlider();				}							/** reset			  *	---------------------------------------------------------------------------- */				public function reset():void				{					for( var i:int=0; i<_waveZoneClips.length; i++ )					{						_waveZoneClips[i].reset();												_waveZoneClips[i].x = 0;						_waveZoneClips[i].y = i == 0 ? 0 : _waveZoneClips[i-1].y + _waveZoneClips[i-1].bounds_mc.height + 10;					}										_waveZones = new Vector.<WaveZone>;										_waveEditorViewScrollerClip.resetScroller();					_waveEditorViewScrollerClip.toggleSlider();				}								public function show():void				{					_contentClip.visible = true;				}								public function hide():void				{					_contentClip.visible = false;										for( var i:int=0; i<_waveZoneClips.length; i++ )					{						_waveZoneClips[i].waves;					}										dispatchEvent( new CustomEvent("onWaveZonesSaved") );										_waveEditorViewScrollerClip.resetScroller();				}							/** handleCloseClicked			  *	---------------------------------------------------------------------------- *			  *	Closes WaveEditorView and saves current data			  *	---------------------------------------------------------------------------- */				protected function handleCloseClicked( event:Event ):void				{					hide();				}							/** handleWaveAdded			  *	---------------------------------------------------------------------------- */				protected function handleWaveAdded( event:CustomEvent ):void				{					//ConsoleBroadcaster.broadcast( "WaveEditorView", "handleWaveAdded();" );										repositionContent();				}							/** handleWaveAdded			  *	---------------------------------------------------------------------------- */				protected function handleWaveDeleted( event:CustomEvent ):void				{					repositionContent();				}							/** repositionContent			  *	---------------------------------------------------------------------------- *			  *	Repositions wave zone clips.			  *	---------------------------------------------------------------------------- */				protected function repositionContent():void				{					for( var i:int=1; i<_waveZoneClips.length; i++ )					{						_waveZoneClips[i].y = _waveZoneClips[i-1].y + _waveZoneClips[i-1].bounds_mc.height + 10;					}										//trace( _waveZoneClips[0].height );					//trace( "scroller_mc.content_mc.height: "+MovieClip(scroller_mc).content_mc.height );										_waveEditorViewScrollerClip.toggleSlider();				}						}	}