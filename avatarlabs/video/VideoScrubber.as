﻿/**	VideoScrubber  * ------------------------------------------------------------ */	package com.avatarlabs.video	{		import flash.display.MovieClip;		import flash.events.Event;		import flash.events.MouseEvent;		import flash.geom.Rectangle;				import com.avatarlabs.utils.console.ConsoleBroadcaster;		import com.avatarlabs.utils.events.CustomEvent;		import com.avatarlabs.utils.events.EventNotificationCenter;						import com.avatarlabs.utils.userinterface.UISlider;					public class VideoScrubber extends MovieClip		{			private var videoController:MovieClip;			private var _handleClip:MovieClip;			private var _progressClip:MovieClip;			private var _seekClip:MovieClip;						private var handleBounds:Rectangle;			private var startX:Number;						private var _enabled:Boolean;			private var _isDragging:Boolean;								/**	Constructor	 	 * ------------------------------------------------------------ */			public function VideoScrubber()			{				_enabled = false;				_isDragging = false;			}					/**	enable / disable		 * ------------------------------------------------------------ */		 	public function enable():void			{				ConsoleBroadcaster.broadcast( "VideoScrubber", "enable()");								_enabled = true;				this.alpha = 1;								_handleClip.useHandCursor = true;				_handleClip.buttonMode = true;								_seekClip.useHandCursor = true;				_seekClip.buttonMode = true;								_handleClip.addEventListener( MouseEvent.MOUSE_DOWN, handleStartDrag );				_seekClip.addEventListener(MouseEvent.CLICK, handleSeek);				addEventListener(Event.ENTER_FRAME, updateScrubber);			}						public function disable():void			{				ConsoleBroadcaster.broadcast( "VideoScrubber", "disable()");								_enabled = false;				this.alpha = 0.5;								_handleClip.useHandCursor = false;				_handleClip.buttonMode = false;								_seekClip.useHandCursor = false;				_seekClip.buttonMode = false;								_handleClip.removeEventListener( MouseEvent.MOUSE_DOWN, handleStartDrag );				_seekClip.removeEventListener(MouseEvent.CLICK, handleSeek);				removeEventListener(Event.ENTER_FRAME, updateScrubber);			}					/**	setters / getters		 * ------------------------------------------------------------ */			public function set playerReference(pr:MovieClip)			{				ConsoleBroadcaster.broadcast( "VideoScrubber", "playerReference(" + pr + ")");				videoController = pr;			}						public function set handleClip(mc:MovieClip):void			{				_handleClip = mc;			}						public function set progressClip(mc:MovieClip):void			{				_progressClip = mc;				_progressClip.scaleX = 0;			}						public function set seekClip(mc:MovieClip):void			{				_seekClip = mc;			}						public function setBounds( mc:MovieClip )			{								var bounds = _handleClip.getBounds( _handleClip );												handleBounds = mc.getBounds( this );								handleBounds.top 	= handleBounds.top-bounds.top; // -83				handleBounds.bottom = handleBounds.bottom-bounds.top-bounds.height; // 83				handleBounds.left	= handleBounds.left-bounds.left;				handleBounds.right 	= handleBounds.right-bounds.width-bounds.left;							}					/**	init		 * ------------------------------------------------------------ */			public function init():void			{				ConsoleBroadcaster.broadcast( "VideoScrubber", "init()");								if(!videoController)					throw new Error("Please set a player reference for the video buttons controller");				else				{					if(videoController.isPlaying) 					{						updateVisuals(new CustomEvent("onVideoPlay", {videoIndex:videoController.videoIndex}) );					}					else					{						disable();					}										addVideoControllerListeners();				}			}					/** handleStartDrag			  *	------------------------------------------------------- */				private function handleStartDrag( evt:MouseEvent ):void				{					ConsoleBroadcaster.broadcast( "VideoScrubber",  "handleDragHandle();" );										startX = evt.localX;					_isDragging = true;																				stage.addEventListener( MouseEvent.MOUSE_MOVE, dragHandle );					stage.addEventListener( MouseEvent.MOUSE_UP, handleStopDrag );				}							/** handleStopDrag			  *	------------------------------------------------------- */				private function handleStopDrag( evt:MouseEvent ):void				{					ConsoleBroadcaster.broadcast( "VideoScrubber",  "handleStopDrag();" );										_isDragging = false;										stage.removeEventListener( MouseEvent.MOUSE_MOVE, dragHandle );					stage.removeEventListener( MouseEvent.MOUSE_UP, handleStopDrag );				}							/** dragHandle			  *	------------------------------------------------------- */				private function dragHandle( evt:MouseEvent ):void				{					var difference:Number = _handleClip.x - startX;																				_handleClip.x = Math.max( Math.min( mouseX, handleBounds.right ), handleBounds.left );					var percent:Number = ((_handleClip.x-handleBounds.left) / (handleBounds.right-handleBounds.left));										if(percent < 100)					{						videoController.videoSeek(percent);					}										dispatchEvent( new CustomEvent( "onChangeValue", {percent:percent} ));				}							/** setValue			  *	------------------------------------------------------- */			  	public function setValue( v:Number ):void				{					_handleClip.x = handleBounds.left + (handleBounds.right - handleBounds.left) * v;				}							/** resetSlider			  *	------------------------------------------------------- */			  	public function resetSlider( prop:String ):void				{					_handleClip.x = handleBounds.left;				}							/**	addVideoControllerListeners			 * ------------------------------------------------------------ */				private function addVideoControllerListeners():void				{					ConsoleBroadcaster.broadcast( "VideoScrubber", "addVideoControllerListeners()");										videoController.addEventListener("onVideoPlay", updateVisuals);					videoController.addEventListener("onVideoPause", updateVisuals);					videoController.addEventListener("onVideoUnpause", updateVisuals);					videoController.addEventListener("onVideoMute", updateVisuals);					videoController.addEventListener("onVideoUnmute", updateVisuals);					videoController.addEventListener("onVideoComplete", updateVisuals);					videoController.addEventListener("onVideoReplay", updateVisuals);					videoController.addEventListener("onVideoStop", updateVisuals);				}							/**	updateVisuals			 * ------------------------------------------------------------ */				private function updateVisuals(event:CustomEvent):void				{					ConsoleBroadcaster.broadcast( "VideoScrubber", "updateVisuals(" + event.type + ")");										if(!_enabled) enable();										switch(event.type)					{						case "onVideoPlay":						case "onVideoReplay":						case "onVideoUnpause":							break;						case "onVideoPause":							break;						case "onVideoMute":							break;						case "onVideoUnmute":							break;						case "onVideoComplete":						case "onVideoStop":							disable();							break;					}				}							/**	updateScrubber			 * ------------------------------------------------------------ */			 	private function updateScrubber(event:Event):void				{					var target:Number = handleBounds.left + videoController.progress * ((handleBounds.right-handleBounds.left ));									if(!_isDragging)						_handleClip.x = target;				}							/**	handleSeek			 * ------------------------------------------------------------ */			 	private function handleSeek(event:MouseEvent):void				{					ConsoleBroadcaster.broadcast( "VideoScrubber", "handleSeek()");										var percent:Number = Math.max( 0, Math.min( _seekClip.mouseX / _seekClip.width * 100, 100))/100;										ConsoleBroadcaster.broadcast( "VideoScrubber", "percent: " + percent);					videoController.videoSeek(percent);				}		}	}