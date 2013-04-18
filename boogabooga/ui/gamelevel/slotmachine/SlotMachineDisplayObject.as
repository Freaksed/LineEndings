﻿/** SlotMachineDisplayObject  *	---------------------------------------------------------------------------- *  *	@desc:  *		This is the display object clip that will represent Enemy class.  *	@author:   *		Christian Widodo, [christian@avatarlabs.com]  *	---------------------------------------------------------------------------- */ 	package com.boogabooga.ui.gamelevel.slotmachine	{		import flash.display.Bitmap;		import flash.display.BitmapData;		import flash.display.BlendMode;		import flash.display.DisplayObject;		import flash.display.DisplayObjectContainer;		import flash.display.MovieClip;		import flash.events.Event;		import flash.events.EventDispatcher;		import flash.events.IOErrorEvent;		import flash.events.ProgressEvent;		import flash.events.MouseEvent;		import flash.geom.ColorTransform;		import flash.geom.Matrix;		import flash.geom.Point;		import flash.geom.Rectangle;		import flash.events.TimerEvent;		import flash.utils.getDefinitionByName;				import com.greensock.TweenLite;		import com.avatarlabs.utils.ArrayUtil;		import com.avatarlabs.utils.UtilFunctions;		import com.avatarlabs.utils.console.ConsoleBroadcaster;		import com.avatarlabs.utils.events.CustomEvent;		import com.avatarlabs.utils.events.EventNotificationCenter;		import com.avatarlabs.utils.loader.CustomLoader;		import com.avatarlabs.utils.sound.SoundEffectPlayer;		import com.avatarlabs.utils.timers.CustomTimer;		import org.osflash.signals.Signal;				//import com.gamelevel.data.*;		import com.boogabooga.data.gamelevel.AbstractGameObject;		import com.boogabooga.data.gamelevel.SlotMachine;		import com.boogabooga.data.gamelevel.GameLevelDataIndex;		import com.boogabooga.events.GameLevelEvent;		import com.boogabooga.ui.gamelevel.GameLevelDisplayObject;		import com.boogabooga.utils.GameLevelUtil;				public class SlotMachineDisplayObject extends EventDispatcher		{			protected var _debug:Boolean;			protected var _contentClip:MovieClip;						protected var _slotMachine:SlotMachine;			protected var _win:Boolean;			protected var _playingAnimation:Boolean;			protected var _playingHandleAnimation:Boolean;			protected var _playingSpinAnimation:Boolean;						protected var _alwaysWin:Boolean;						protected var _spinAnimation1Timer:CustomTimer;			protected var _spinAnimation2Timer:CustomTimer;			protected var _spinAnimation3Timer:CustomTimer;			protected var _gleamWaitTimer:CustomTimer;			protected var _gleamPlayTimer:CustomTimer;			protected var _blinkWaitTimer:CustomTimer;			protected var _blinkTimer:CustomTimer;						public var onSlotSpinStarted:Signal;			public var onSlotSpinEnded:Signal;						/**	Stage Instances **/			//public var winning_mc:MovieClip;			//public var reelIconsMask_mc:MovieClip;			public var reelIconContainer1_mc:MovieClip;			public var reelIconContainer2_mc:MovieClip;			public var reelIconContainer3_mc:MovieClip;			public var hitarea_mc:MovieClip;			public var spinAnimation1_mc:MovieClip;			public var spinAnimation2_mc:MovieClip;			public var spinAnimation3_mc:MovieClip;			//public var bodyFrame3_mc:MovieClip;			//public var bodyFrame2_mc:MovieClip;			//public var bodyFrame1_mc:MovieClip;			//public var woodTexture_mc:MovieClip;			//public var tophead_mc:MovieClip;			//public var jaw_mc:MovieClip;			//public var blackofmouth_mc:MovieClip;			//public var neck_mc:MovieClip;			//public var lavaglow2_mc:MovieClip;			//public var lavaglow1_mc:MovieClip;			public var handle_mc:MovieClip;			public var handleGleam_mc:MovieClip;			public var background_mc:MovieClip;			/**	End of Stage Instances **/						/** Constructor			  *	---------------------------------------------------------------------------- */				public function SlotMachineDisplayObject()				{					//init();				}								public function set contentClip( m:MovieClip ):void				{					_contentClip = m;					_contentClip.gotoAndStop(1);										reelIconContainer1_mc = _contentClip.reelIconContainer1_mc;					reelIconContainer1_mc.scaleX = reelIconContainer1_mc.scaleY = .72;					reelIconContainer2_mc = _contentClip.reelIconContainer2_mc;					reelIconContainer2_mc.scaleX = reelIconContainer2_mc.scaleY = .72;					reelIconContainer3_mc = _contentClip.reelIconContainer3_mc;					reelIconContainer3_mc.scaleX = reelIconContainer3_mc.scaleY = .72;					hitarea_mc = _contentClip.hitarea_mc;					spinAnimation1_mc = _contentClip.spinAnimation1_mc;					spinAnimation1_mc.stop();					spinAnimation2_mc = _contentClip.spinAnimation2_mc;					spinAnimation2_mc.stop();					spinAnimation3_mc = _contentClip.spinAnimation3_mc;					spinAnimation3_mc.stop();					//bodyFrame3_mc = _contentClip.bodyFrame3_mc;					//bodyFrame2_mc = _contentClip.bodyFrame2_mc;					//bodyFrame1_mc = _contentClip.bodyFrame1_mc;					//woodTexture_mc = _contentClip.woodTexture_mc;					//tophead_mc = _contentClip.tophead_mc;					//tophead_mc.stop();					//jaw_mc = _contentClip.jaw_mc;					//blackofmouth_mc = _contentClip.blackofmouth_mc;					//neck_mc = _contentClip.neck_mc;					//lavaglow1_mc = _contentClip.lavaglow1_mc;					//lavaglow2_mc = _contentClip.lavaglow2_mc;					handle_mc = _contentClip.handle_mc;					handle_mc.stop();					handleGleam_mc = handle_mc.gleam_mc;					handleGleam_mc.stop();					background_mc = _contentClip.background_mc;					background_mc.gotoAndStop(1);				}				public function get contentClip():MovieClip { return _contentClip; }								public function set slotMachine( s:SlotMachine ):void { _slotMachine = s; }				public function get slotMachine():SlotMachine { return _slotMachine; }								public function get win():Boolean { return _win; }								public function set alwaysWin( b:Boolean ):void { _alwaysWin = b; }							/** init			  *	---------------------------------------------------------------------------- *			  *	---------------------------------------------------------------------------- */				public function init():void				{					//trace( "SlotDisplayObject", "init();" );															//bodyFrame3_mc.mouseChildren = false;					//bodyFrame3_mc.mouseEnabled = false;					//bodyFrame2_mc.mouseChildren = false;					//bodyFrame2_mc.mouseEnabled = false;					//bodyFrame1_mc.mouseChildren = false;					//bodyFrame1_mc.mouseEnabled = false;					//woodTexture_mc.mouseChildren = false;					//woodTexture_mc.mouseEnabled = false;										_spinAnimation1Timer = new CustomTimer( 1000, 1 );					//_spinAnimation1Timer.addEventListener( TimerEvent.TIMER_COMPLETE, handleSpinAnimation1TimerCompleted, false, 0, true );					_spinAnimation1Timer.onTimerCompleted.add( handleSpinAnimation1TimerCompleted );										_spinAnimation2Timer = new CustomTimer( 2000, 1 );					//_spinAnimation2Timer.addEventListener( TimerEvent.TIMER_COMPLETE, handleSpinAnimation2TimerCompleted, false, 0, true );					_spinAnimation2Timer.onTimerCompleted.add( handleSpinAnimation2TimerCompleted );										_spinAnimation3Timer = new CustomTimer( 3000, 1 );					//_spinAnimation3Timer.addEventListener( TimerEvent.TIMER_COMPLETE, handleSpinAnimation3TimerCompleted, false, 0, true );					_spinAnimation3Timer.onTimerCompleted.add( handleSpinAnimation3TimerCompleted );										_gleamWaitTimer = new CustomTimer( 20000, 1 );					//_gleamWaitTimer.addEventListener( TimerEvent.TIMER, handleGleamWaitTimerCompleted, false, 0, true );					_gleamWaitTimer.onTimerCompleted.add( handleGleamWaitTimerCompleted );										_gleamPlayTimer = new CustomTimer( 4000 );					//_gleamPlayTimer.addEventListener( TimerEvent.TIMER, handleGleamPlayTimerFired, false, 0, true );					_gleamPlayTimer.onTimerFired.add( handleGleamPlayTimerFired );										_blinkWaitTimer = new CustomTimer( 60000, 1 );					//_blinkWaitTimer.addEventListener( TimerEvent.TIMER_COMPLETE, handleBlinkWaitTimerCompleted, false, 0, true );					_blinkWaitTimer.onTimerCompleted.add( handleBlinkWaitTimerCompleted );										_blinkTimer = new CustomTimer( 300, 11 );					//_blinkTimer.addEventListener( TimerEvent.TIMER, handleBlinkTimerFired, false, 0, true );					//_blinkTimer.addEventListener( TimerEvent.TIMER_COMPLETE, handleBlinkTimerCompleted, false, 0, true );					_blinkTimer.onTimerFired.add( handleBlinkTimerFired );					_blinkTimer.onTimerCompleted.add( handleBlinkTimerCompleted );										_contentClip.addEventListener( "onPlayWinAnimationComplete", handlePlayWinAnimationComplete );										onSlotSpinStarted = new Signal();					onSlotSpinEnded = new Signal( Boolean, Number );				}							/** show			  *	---------------------------------------------------------------------------- *			  *	---------------------------------------------------------------------------- */				public function show():void				{					_contentClip.visible = true;				}							/** hide			  *	---------------------------------------------------------------------------- *			  *	---------------------------------------------------------------------------- */				public function hide():void				{					_contentClip.visible = false;				}							/** start			  *	---------------------------------------------------------------------------- *			  *	---------------------------------------------------------------------------- */				public function start():void				{					_playingAnimation = false;					_playingHandleAnimation = false;					_playingSpinAnimation = false;										_alwaysWin = false;										if( _slotMachine != null )					{						removeReelIcons();						//winning_mc.label_txt.text = _slotMachine.winningModifier;												activateHandle();												reelIconContainer1_mc.addChild( new (getDefinitionByName(_slotMachine.winReelIcons[0]) as Class)() );						reelIconContainer2_mc.addChild( new (getDefinitionByName(_slotMachine.winReelIcons[0]) as Class)() );						reelIconContainer3_mc.addChild( new (getDefinitionByName(_slotMachine.winReelIcons[0]) as Class)() );					}										spinAnimation1_mc.visible = false;					spinAnimation2_mc.visible = false;					spinAnimation3_mc.visible = false;										reelIconContainer1_mc.visible = true;					reelIconContainer2_mc.visible = true;					reelIconContainer3_mc.visible = true;										_gleamWaitTimer.start();					_blinkWaitTimer.start();				}							/** pause			  *	---------------------------------------------------------------------------- *			  *	---------------------------------------------------------------------------- */				public function pause():void				{					/*					if( _playingHandleAnimation )					{						TweenLite.killTweensOf( handle_mc );					}					*/					/*					if( _playingSpinAnimation )					{						spinAnimation1_mc.stop();						spinAnimation2_mc.stop();												TweenLite.killTweensOf( spinAnimation3_mc );					}					*/										SoundEffectPlayer.getInstance().stopSound( "sfx_slot_spin.wav", "sfx_slot_spin.wav", "sfx_slot_spin.wav", SoundEffectPlayer.SOUND_PLAYER_SFX );										if( _spinAnimation1Timer.isRunning )					{						_spinAnimation1Timer.pause();						spinAnimation1_mc.stop();					}										if( _spinAnimation2Timer.isRunning )					{						_spinAnimation2Timer.pause();						spinAnimation2_mc.stop();					}										if( _spinAnimation3Timer.isRunning )					{						_spinAnimation3Timer.pause();						spinAnimation3_mc.stop();					}										if( _gleamWaitTimer.isRunning )					{						_gleamWaitTimer.pause();					}										if( _gleamPlayTimer.isRunning )					{						_gleamPlayTimer.pause();					}										if( _blinkWaitTimer.isRunning )					{						_blinkWaitTimer.pause();					}										if( _blinkTimer.isRunning )					{						_blinkTimer.pause();					}										if( _playingAnimation )					{						_contentClip.stop();						//tophead_mc.stop();						background_mc.stop();					}				}							/** unpause			  *	---------------------------------------------------------------------------- *			  *	---------------------------------------------------------------------------- */				public function unpause():void				{					/*					if( _playingHandleAnimation )					{						TweenLite.to( handle_mc, handle_mc.totalFrames-handle_mc.currentFrame, {useFrames:true, frame:13, onComplete:handleHandleAnimationComplete} );					}					*/					/*					if( _playingSpinAnimation )					{						spinAnimation1_mc.play();						spinAnimation2_mc.play();												TweenLite.to( spinAnimation3_mc, spinAnimation3_mc.totalFrames-spinAnimation3_mc.currentFrame, {useFrames:true, frame:5, onComplete:handleSpinAnimationComplete} );					}					*/										if( _spinAnimation1Timer.isRunning )					{						_spinAnimation1Timer.unpause();						spinAnimation1_mc.play();					}										if( _spinAnimation2Timer.isRunning )					{						_spinAnimation2Timer.unpause();						spinAnimation2_mc.play();					}										if( _spinAnimation3Timer.isRunning )					{						_spinAnimation3Timer.unpause();						spinAnimation3_mc.play();						SoundEffectPlayer.getInstance().playLibrarySound( "sfx_slot_spin.wav", true, "sfx_slot_spin.wav", "sfx_slot_spin.wav", SoundEffectPlayer.SOUND_PLAYER_SFX );					}										if( _gleamWaitTimer.isRunning )					{						_gleamWaitTimer.unpause();					}										if( _gleamPlayTimer.isRunning )					{						_gleamPlayTimer.unpause();					}										if( _blinkWaitTimer.isRunning )					{						_blinkWaitTimer.unpause();					}										if( _blinkTimer.isRunning )					{						_blinkTimer.unpause();					}										if( _playingAnimation )					{						_contentClip.play();						//tophead_mc.play();						background_mc.stop();					}				}							/** kill			  *	---------------------------------------------------------------------------- *			  *	---------------------------------------------------------------------------- */				public function kill():void				{					//handle_mc.removeEventListener( "onClick", handleSpinClicked );					deactivateHandle();					/*					if( _playingHandleAnimation )					{						TweenLite.killTweensOf( handle_mc );					}					*/					/*					if( _playingSpinAnimation )					{						spinAnimation1_mc.stop();						spinAnimation2_mc.stop();												TweenLite.killTweensOf( spinAnimation3_mc );					}					*/										if( _spinAnimation1Timer.isRunning )					{						_spinAnimation1Timer.stop();						spinAnimation1_mc.stop();					}										if( _spinAnimation2Timer.isRunning )					{						_spinAnimation2Timer.stop();						spinAnimation2_mc.stop();					}										if( _spinAnimation3Timer.isRunning )					{						_spinAnimation3Timer.stop();						spinAnimation3_mc.stop();					}										if( _gleamWaitTimer.isRunning )					{						_gleamWaitTimer.stop();						_gleamWaitTimer.reset();					}										if( _gleamPlayTimer.isRunning )					{						_gleamPlayTimer.stop();						_gleamPlayTimer.reset();					}										if( _blinkWaitTimer.isRunning )					{						_blinkWaitTimer.stop();						_blinkWaitTimer.reset();					}										if( _blinkTimer.isRunning )					{						_blinkTimer.stop();						_blinkTimer.reset();					}										SoundEffectPlayer.getInstance().stopSound( "sfx_slot_spin.wav", "sfx_slot_spin.wav", "sfx_slot_spin.wav", SoundEffectPlayer.SOUND_PLAYER_SFX );										if( _playingAnimation )					{						_contentClip.gotoAndStop(1);						//tophead_mc.gotoAndStop(1);						background_mc.gotoAndStop(1);						_playingAnimation = false;												SoundEffectPlayer.getInstance().stopSound( "sfx_slot_win.wav", "sfx_slot_win.wav", "sfx_slot_win.wav", SoundEffectPlayer.SOUND_PLAYER_SFX );					}				}							/** handleSpinClicked			  *	---------------------------------------------------------------------------- *			  *	---------------------------------------------------------------------------- */				protected function handleSpinClicked( event:Event ):void				{					startSpin();				}								protected function handleRolledOver( event:Event ):void				{					handle_mc.gotoAndStop(2);										_contentClip.alpha = 1;										_gleamPlayTimer.stop();										_gleamWaitTimer.stop();					_gleamWaitTimer.reset();										_blinkWaitTimer.stop();					_blinkWaitTimer.reset();										_blinkTimer.stop();					_blinkTimer.reset();				}								protected function handleRolledOut( event:Event ):void				{					handle_mc.gotoAndStop(1);										_gleamWaitTimer.start();					_blinkWaitTimer.start();				}							/** activateHandle			  *	---------------------------------------------------------------------------- */				protected function activateHandle():void				{					hitarea_mc.buttonMode = true;					hitarea_mc.addEventListener( MouseEvent.ROLL_OVER, handleRolledOver, false, 0, true );					hitarea_mc.addEventListener( MouseEvent.ROLL_OUT, handleRolledOut, false, 0, true );					hitarea_mc.addEventListener( MouseEvent.CLICK, handleSpinClicked, false, 0, true );				}							/** deactivateHandle			  *	---------------------------------------------------------------------------- */				protected function deactivateHandle():void				{					hitarea_mc.buttonMode = false;					hitarea_mc.removeEventListener( MouseEvent.ROLL_OVER, handleRolledOver );					hitarea_mc.removeEventListener( MouseEvent.ROLL_OUT, handleRolledOut );					hitarea_mc.removeEventListener( MouseEvent.CLICK, handleSpinClicked );				}							/** startSpin			  *	---------------------------------------------------------------------------- *			  *	---------------------------------------------------------------------------- */				public function startSpin():void				{					//trace( "startSpin();" );										//_gleamWaitTimer.stop();					//_gleamWaitTimer.reset();										//handle_mc.setDeactive( true );					deactivateHandle();										//_playingHandleAnimation = true;					//TweenLite.to( handle_mc, 13, {useFrames:true, frame:13, onComplete:handleHandleAnimationComplete} );										handle_mc.gotoAndStop(3);					handleHandleAnimationComplete();										SoundEffectPlayer.getInstance().playLibrarySound( "sfx_slot_pull.wav", false, "sfx_slot_pull.wav", "sfx_slot_pull.wav", SoundEffectPlayer.SOUND_PLAYER_SFX );										//dispatchEvent( new GameLevelEvent(GameLevelEvent.ON_SLOT_SPIN_STARTS) );					onSlotSpinStarted.dispatch();				}							/** removeReelIcons			  *	---------------------------------------------------------------------------- *			  *	---------------------------------------------------------------------------- */				public function removeReelIcons():void				{					while( reelIconContainer1_mc.numChildren > 0 )						reelIconContainer1_mc.removeChildAt(0);										while( reelIconContainer2_mc.numChildren > 0 )						reelIconContainer2_mc.removeChildAt(0);										while( reelIconContainer3_mc.numChildren > 0 )						reelIconContainer3_mc.removeChildAt(0);										//reelIconContainer1_mc.y = 20;					//reelIconContainer2_mc.y = 20;					//reelIconContainer3_mc.y = 20;				}							/** handleHandleanimationComplete			  *	---------------------------------------------------------------------------- */				protected function handleHandleAnimationComplete():void				{					//trace( "handleHandleAnimationComplete();" );										_playingHandleAnimation = false;										//handle_mc.gotoAndStop(1);					_gleamPlayTimer.stop();					_gleamWaitTimer.stop();					_gleamWaitTimer.reset();										_blinkTimer.stop();					_blinkWaitTimer.stop();					_blinkWaitTimer.reset();										removeReelIcons();					reelIconContainer1_mc.visible = false;					reelIconContainer2_mc.visible = false;					reelIconContainer3_mc.visible = false;										var weights:Array = new Array();					var winningProbability:int = _slotMachine.winningProbability / 10;					var possibleReelIcons:Array = _slotMachine.loseReelIcons.concat( _slotMachine.winReelIcons );					var i:int;					var reelIcon:MovieClip;										for( i=0; i<10; ++i )					{						if( i < winningProbability )							weights.push( true );						else							weights.push( false );					}										weights.sort( ArrayUtil.randomSort );										//trace( weights );										//TODO:					//	Optimize this part					if( _alwaysWin )						_win = true;					else						_win = weights[ int(Math.random()*weights.length) ];										if( _win )					{						// Won the spin						//reelIcon = new (getDefinitionByName( _slotMachine.winReelIcons[int(Math.random()*_slotMachine.winReelIcons.length)] ) as Class)();						reelIcon = new (getDefinitionByName("SlotMachine.WinReelIcon") as Class)();						//reelIcon.y = int( (reelIcon.height + 5) * i );						reelIconContainer1_mc.addChild( reelIcon );												//reelIcon = new (getDefinitionByName( _slotMachine.winReelIcons[int(Math.random()*_slotMachine.winReelIcons.length)] ) as Class)();						reelIcon = new (getDefinitionByName("SlotMachine.WinReelIcon") as Class)();						//reelIcon.y = int( (reelIcon.height + 5) * i );						reelIconContainer2_mc.addChild( reelIcon );												//reelIcon = new (getDefinitionByName( _slotMachine.winReelIcons[int(Math.random()*_slotMachine.winReelIcons.length)] ) as Class)();						reelIcon = new (getDefinitionByName("SlotMachine.WinReelIcon") as Class)();						//reelIcon.y = int( (reelIcon.height + 5) * i );						reelIconContainer3_mc.addChild( reelIcon );					}					else					{						var chickenCount:int = 0;						var reelIconId:String = "";						var randomIndex:int;						var index:int;						var randomIndexCount:int = 0;												randomIndex = int(Math.random()*possibleReelIcons.length);						index = randomIndex;						randomIndexCount = 1;						reelIconId = possibleReelIcons[randomIndex];						if( reelIconId == "SlotMachine.WinReelIcon" )							++chickenCount;												// Lose the spin						reelIcon = new (getDefinitionByName(reelIconId) as Class)();						//reelIcon.y = int( (reelIcon.height + 5) * i );						reelIconContainer1_mc.addChild( reelIcon );												randomIndex = int(Math.random()*possibleReelIcons.length);						if( index == randomIndex )							++randomIndexCount;						reelIconId = possibleReelIcons[randomIndex];						if( reelIconId == "SlotMachine.WinReelIcon" )							++chickenCount;												reelIcon = new (getDefinitionByName(reelIconId) as Class)();						//reelIcon.y = int( (reelIcon.height + 5) * i );						reelIconContainer2_mc.addChild( reelIcon );												if( chickenCount < 2 )						{							randomIndex = int(Math.random()*possibleReelIcons.length);							while( randomIndex == index && randomIndexCount >= 2 )							{								randomIndex = int(Math.random()*possibleReelIcons.length);							}														reelIconId = possibleReelIcons[randomIndex];							//if( reelIconId == "SlotMachine.WinReelIcon" )								//++chickenCount;						}						else						{							randomIndex = int(Math.random()*_slotMachine.loseReelIcons.length);							while( randomIndex == index && randomIndexCount >= 2 )							{								randomIndex = int(Math.random()*_slotMachine.loseReelIcons.length);							}														reelIconId = _slotMachine.loseReelIcons[randomIndex];						}												reelIcon = new (getDefinitionByName(reelIconId) as Class)();						//reelIcon.y = int( (reelIcon.height + 5) * i );						reelIconContainer3_mc.addChild( reelIcon );											}										_playingSpinAnimation = true;										spinAnimation1_mc.visible = true;					spinAnimation2_mc.visible = true;					spinAnimation3_mc.visible = true;					/*					spinAnimation1_mc.play();					spinAnimation2_mc.play();										TweenLite.to( spinAnimation3_mc, 5, {useFrames:true, frame:5, onComplete:handleSpinAnimationComplete} );					*/										_spinAnimation1Timer.start();					spinAnimation1_mc.play();										_spinAnimation2Timer.start();					spinAnimation2_mc.play();										_spinAnimation3Timer.start();					spinAnimation3_mc.play();										SoundEffectPlayer.getInstance().playLibrarySound( "sfx_slot_spin.wav", true, "sfx_slot_spin.wav", "sfx_slot_spin.wav", SoundEffectPlayer.SOUND_PLAYER_SFX );				}								protected function handleSpinAnimation1TimerCompleted( timer:CustomTimer ):void				{					_spinAnimation1Timer.reset();										spinAnimation1_mc.gotoAndStop(1);					spinAnimation1_mc.visible = false;										reelIconContainer1_mc.visible = true;										SoundEffectPlayer.getInstance().playLibrarySound( "sfx_slot_reel_stop_1.wav", false, "sfx_slot_reel_stop_1.wav", "sfx_slot_reel_stop_1.wav", SoundEffectPlayer.SOUND_PLAYER_SFX );				}								protected function handleSpinAnimation2TimerCompleted( timer:CustomTimer ):void				{					_spinAnimation2Timer.reset();										spinAnimation2_mc.gotoAndStop(1);					spinAnimation2_mc.visible = false;										reelIconContainer2_mc.visible = true;										SoundEffectPlayer.getInstance().playLibrarySound( "sfx_slot_reel_stop_2.wav", false, "sfx_slot_reel_stop_2.wav", "sfx_slot_reel_stop_2.wav", SoundEffectPlayer.SOUND_PLAYER_SFX );				}								protected function handleSpinAnimation3TimerCompleted( timer:CustomTimer ):void				{					_spinAnimation3Timer.reset();										spinAnimation3_mc.gotoAndStop(1);					spinAnimation3_mc.visible = false;										reelIconContainer3_mc.visible = true;										SoundEffectPlayer.getInstance().stopSound( "sfx_slot_spin.wav", "sfx_slot_spin.wav", "sfx_slot_spin.wav", SoundEffectPlayer.SOUND_PLAYER_SFX );					SoundEffectPlayer.getInstance().playLibrarySound( "sfx_slot_pull_reel_stop_3.wav", false, "sfx_slot_pull_reel_stop_3.wav", "sfx_slot_pull_reel_stop_3.wav", SoundEffectPlayer.SOUND_PLAYER_SFX );										if( _win )					{						_playingAnimation = true;						//tophead_mc.play();						_contentClip.play();						background_mc.play();												SoundEffectPlayer.getInstance().playLibrarySound( "sfx_slot_win.wav", false, "sfx_slot_win.wav", "sfx_slot_win.wav" );					}					else					{						handle_mc.gotoAndStop(1);						activateHandle();					}										_gleamWaitTimer.start();					_blinkWaitTimer.start();										//dispatchEvent( new GameLevelEvent(GameLevelEvent.ON_SLOT_SPIN_ENDS, {win:_win, value:_slotMachine.winningModifier}) );					onSlotSpinEnded.dispatch( _win, _slotMachine.winningModifier );				}							/** handleGleamPlayTimerFired			  *	---------------------------------------------------------------------------- *			  * Plays the gleam animation if user hasn't interacted with the slot machine			  *	in 15 seconds.			  *	---------------------------------------------------------------------------- */				protected function handleGleamPlayTimerFired( timer:CustomTimer ):void				{					handleGleam_mc.play();				}							/** handleGleamWaitTimerCompleted			  *	---------------------------------------------------------------------------- *			  * Plays the gleam animation if user hasn't interacted with the slot machine			  *	in 15 seconds.			  *	---------------------------------------------------------------------------- */				protected function handleGleamWaitTimerCompleted( timer:CustomTimer ):void				{					_gleamWaitTimer.reset();										handleGleam_mc.play();										_gleamPlayTimer.start();				}							/** handleBlinkWaitTimerCompleted			  *	---------------------------------------------------------------------------- *			  * When the blink wait timer completes, start the blinking of the slot machine.			  *	---------------------------------------------------------------------------- */				private function handleBlinkWaitTimerCompleted( timer:CustomTimer ):void				{					_blinkWaitTimer.stop();					_blinkWaitTimer.reset();										_blinkTimer.start();				}								private function handleBlinkTimerFired( timer:CustomTimer ):void				{					if( (_blinkTimer.currentCount& 1) == 0 )					{						_contentClip.alpha = 0;					}					else					{						_contentClip.alpha = 1;					}				}							/** handleBlinkTimerComplete			  *	---------------------------------------------------------------------------- *			  * When the blinking is done, restart the blink wait timer if user still hasn't			  *	interacted with the slot machine yet.			  *	---------------------------------------------------------------------------- */				private function handleBlinkTimerCompleted( timer:CustomTimer ):void				{					_blinkTimer.stop();					_blinkTimer.reset();										_blinkWaitTimer.start();				}							/** handleSpinAnimationComplete			  *	---------------------------------------------------------------------------- 				protected function handleSpinAnimationComplete():void				{					//trace( "handleSpinAnimationComplete();" );										_playingSpinAnimation = false;										spinAnimation1_mc.gotoAndStop(1);					spinAnimation1_mc.visible = false;					spinAnimation2_mc.gotoAndStop(1);					spinAnimation2_mc.visible = false;					spinAnimation3_mc.gotoAndStop(1);					spinAnimation3_mc.visible = false;										reelIconContainer1_mc.visible = true;					reelIconContainer2_mc.visible = true;					reelIconContainer3_mc.visible = true;										trace( "_win: "+_win );										if( _win )					{						_playingAnimation = true;						tophead_mc.play();						_contentClip.play();						//TweenLite.to( this, 48, {frame:48, onComplete:handlePlayWinAnimationComplete} );					}					else					{						activateHandle();					}										dispatchEvent( new CustomEvent("onSpinEnds", {win:_win, value:_slotMachine.winningModifier}) );									}*/							/** handlePlayWinAnimationComplete			  *	---------------------------------------------------------------------------- */				protected function handlePlayWinAnimationComplete( event:Event ):void				{					//trace( "handlePlayWinAnimationComplete();" );										activateHandle();										_playingAnimation = false;					//tophead_mc.gotoAndStop(1);					background_mc.gotoAndStop(1);					_contentClip.gotoAndStop(1);										handle_mc.gotoAndStop(1);				}		}			}