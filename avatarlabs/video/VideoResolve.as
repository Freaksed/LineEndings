﻿/**	VideoResolve  * ------------------------------------------------------------ */	package com.avatarlabs.video	{		import flash.display.MovieClip;		import flash.display.DisplayObject;		import flash.display.SimpleButton;		import flash.events.Event;		import flash.events.MouseEvent;		import flash.events.TimerEvent;		import flash.utils.Timer;				import com.avatarlabs.utils.console.ConsoleBroadcaster;		import com.avatarlabs.utils.events.CustomEvent;		import com.avatarlabs.utils.events.EventNotificationCenter;		import com.avatarlabs.utils.userinterface.PlayToRewindTo;				import com.avatarlabs.utils.userinterface.UIButton;					public class VideoResolve extends MovieClip		{			private var videoController:MovieClip;						private var _replayButton:DisplayObject;							private var _replayTimer:Timer;			private var _replayInterval:Number;			private var _useTimer:Boolean;			private var _animate:Boolean;			private var ptrt:PlayToRewindTo;								/**	Constructor	 	 * ------------------------------------------------------------ */			public function VideoResolve()			{				_replayInterval = 5000;				_useTimer = false;								this.visible =false;				_animate = true;				ptrt = new PlayToRewindTo(this);																addEventListener(Event.REMOVED_FROM_STAGE, removeAllListeners);			}					/**	set playerReference		 * ------------------------------------------------------------ */			public function set playerReference(pr:MovieClip)			{				ConsoleBroadcaster.broadcast( "VideoResolve", "playerReference(" + pr + ")");				videoController = pr;			}					/**	set replayButton		 * ------------------------------------------------------------ */			public function set replayButton(obj:DisplayObject):void			{				_replayButton = obj;				addButtonListener(obj);			}					/**	set replayInterval		 * ------------------------------------------------------------ */			public function set replayInterval(value:Number):void			{				_replayInterval = value;			}					/**	set useTimer		 * ------------------------------------------------------------ */			public function set useTimer(value:Boolean):void			{				_useTimer = value;			}					/**	get replayTimer		 * ------------------------------------------------------------ */			public function get replayTimer():Timer			{				return _replayTimer;			}					/**	set animate		 * ------------------------------------------------------------ */			public function set animate(value:Boolean):void			{				_animate = value;			}					/**	init		 * ------------------------------------------------------------ */			public function init():void			{				ConsoleBroadcaster.broadcast( "VideoResolve", "init()");								if(!videoController)					throw new Error("Please set a player reference for the video buttons controller");				else				{					_replayTimer = new Timer(_replayInterval);					_replayTimer.addEventListener(TimerEvent.TIMER, handleReplayTimer);										if(videoController.isPlaying) 					{						updateVisuals(new CustomEvent("onVideoPlay", {videoIndex:videoController.videoIndex}) );					}										addVideoControllerListeners();				}			}							/**	addButtonListeners	 * ------------------------------------------------------------ */		private function addButtonListener(obj:DisplayObject):void		{			if(obj is SimpleButton)			{				obj.addEventListener(MouseEvent.CLICK, handleOnClick);			}			else if(obj is UIButton)			{				obj.addEventListener("onClick", handleOnClick);			}		}					/**	addVideoControllerListeners		 * ------------------------------------------------------------ */			private function addVideoControllerListeners():void			{				ConsoleBroadcaster.broadcast( "VideoResolve", "addVideoControllerListeners()");								videoController.addEventListener("onVideoPlay", updateVisuals);				videoController.addEventListener("onVideoReplay", updateVisuals);				videoController.addEventListener("onVideoComplete", updateVisuals);				videoController.addEventListener("onVideoStop", updateVisuals);			}					/** removeAllListeners		  * ----------------------------------------------------------- */		  	private function removeAllListeners(event:Event = null):void			{				ConsoleBroadcaster.broadcast( "VideoResolve", "removeAllListeners()");								videoController.removeEventListener("onVideoPlay", updateVisuals);				videoController.removeEventListener("onVideoReplay", updateVisuals);				videoController.removeEventListener("onVideoComplete", updateVisuals);				videoController.removeEventListener("onVideoStop", updateVisuals);								_replayTimer.removeEventListener(TimerEvent.TIMER, handleReplayTimer);								if(_replayButton is SimpleButton)				{					_replayButton.removeEventListener(MouseEvent.CLICK, handleOnClick);				}				else if(_replayButton is UIButton)				{					_replayButton.removeEventListener("onClick", handleOnClick);				}			}									/**	onTimer		 * ------------------------------------------------------------ */			private function handleReplayTimer(event:TimerEvent):void			{				ConsoleBroadcaster.broadcast( "VideoResolve", "handleReplayTimer()");												if(visible){ alpha = 0; visible = false;}				_replayTimer.stop();								if(!videoController.isPlaying)					videoController.playVideo((videoController.videoIndex)+1, videoController.videoMuted);			}						/**	handleOnClick		 * ------------------------------------------------------------ */			private function handleOnClick(event:Event):void			{				ConsoleBroadcaster.broadcast( "VideoResolve", "handleOnClick(" + event.target.name + ")");																switch(event.target)				{					case _replayButton:						if(visible){ alpha = 0; visible = false;}						if(_replayTimer.running) _replayTimer.stop();						videoController.unmuteVideo();						videoController.restartVideo();						break;				}			}					/**	showResolve		 * ------------------------------------------------------------ */		 	public function showResolve():void			{				ConsoleBroadcaster.broadcast( "VideoResolve", "showResolve()");								if(!visible)				{ 					if(_animate)					{						ConsoleBroadcaster.broadcast( "VideoResolve", "this: " + this);						ptrt.playTo();					}					alpha = 1; 					visible = true;				}			}					/**	hideResolve		 * ------------------------------------------------------------ */		 	public function hideResolve():void			{				ConsoleBroadcaster.broadcast( "VideoResolve", "hideResolve()");								if(visible){ alpha = 0; gotoAndStop(1); visible = false;}			}						/**	updateVisuals		 * ------------------------------------------------------------ */			private function updateVisuals(event:CustomEvent):void			{				ConsoleBroadcaster.broadcast( "VideoResolve", "updateVisuals(" + event.type + ")");								ConsoleBroadcaster.broadcast( "VideoResolve", "isComplete: " + event.customParameters.isComplete);													switch(event.type)				{					case "onVideoPlay":					case "onVideoReplay":						hideResolve();						break;					case "onVideoComplete":					case "onVideoStop":						showResolve();						/*						if(videoController.hasNext && _useTimer && event.customParameters.isComplete)						{							ConsoleBroadcaster.broadcast( "VideoResolve", "...starting replay timer....");							replayTimer.start();						}						*/						break;				}			}		}	}