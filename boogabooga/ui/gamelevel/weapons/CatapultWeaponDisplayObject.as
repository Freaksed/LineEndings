﻿/** CatapultWeaponDisplayObject  *	---------------------------------------------------------------------------- *  *	@desc:  *		This is the display object clip that will represent Weapon class.  *		Weapon properties ( Create classes to represent these different weapons )  *			- single lane / multiple lane  *			- shoots one direction / all directions  *			- affect flying enemies / not  *			- affect digging enemies / not  *			- projectile / close range / blocking / trap / instant  *			- one hit kill  *			- element properties ( fire, ice, poison )  *			- modifier ( can add attributes to existing weapons )  *			- area of effect on hit  *	@author:   *		Christian Widodo, [christian@avatarlabs.com]  *	---------------------------------------------------------------------------- */ 	package com.boogabooga.ui.gamelevel.weapons	{		import flash.display.Bitmap;		import flash.display.BitmapData;		import flash.display.BlendMode;		import flash.display.DisplayObject;		import flash.display.DisplayObjectContainer;		import flash.display.MovieClip;		import flash.display.Sprite;		import flash.events.Event;		import flash.events.TimerEvent;		import flash.geom.ColorTransform;		import flash.geom.Matrix;		import flash.geom.Point;		import flash.geom.Rectangle;		import flash.utils.getDefinitionByName;				import com.greensock.TweenLite;		import com.avatarlabs.utils.cache.BitmapDataManager;		import com.avatarlabs.utils.console.ConsoleBroadcaster;		import com.avatarlabs.utils.events.CustomEvent;		import com.avatarlabs.utils.loader.CustomLoader;		import com.avatarlabs.utils.UtilFunctions;		import com.avatarlabs.utils.timers.CustomTimer;		import com.avatarlabs.utils.userinterface.UILabel;		import com.desuade.partigen.emitters.Emitter;		import com.desuade.partigen.events.ParticleEvent;		import org.osflash.signals.Signal;				//import com.gamelevel.data.*;		import com.boogabooga.data.gamelevel.AbstractGameObject;		import com.boogabooga.data.gamelevel.Weapon;		import com.boogabooga.events.BoogaEvent;		import com.boogabooga.events.GameLevelEvent;		import com.boogabooga.ui.gamelevel.AnimationDisplayObject;		import com.boogabooga.ui.gamelevel.GameLevelDisplayObject;		import com.boogabooga.ui.gamelevel.weapons.WeaponDisplayObject;		import com.boogabooga.utils.GameLevelUtil;				public class CatapultWeaponDisplayObject extends WeaponDisplayObject		{			//protected var _tilesWatching:Array;						//protected var _enemiesAttacked:Array;						//protected var _oldDirection:int;			//protected var _canAttackFlyer:Boolean;			//protected var _canAttackDigger:Boolean;						//protected var _attackedTarget:GameLevelAttackingDisplayObject;			//protected var _currentAnimationDisplayObject:AnimationDisplayObject;						//protected var _deathParticleEmitter:Emitter;						//protected var _hasFired:Boolean;						public var onCatapultFired:Signal;						/**	Stage Instances **/			/**	End of Stage Instances **/						/** Constructor			  *	---------------------------------------------------------------------------- */				public function CatapultWeaponDisplayObject( contentClip:MovieClip=null )				{					super( contentClip );										//init();				}								/*				public function set deathParticleEmitter( e:Emitter ):void				{					trace( "set deathParticleEmitter" );										_deathParticleEmitter = e;					_deathParticleEmitter.addEventListener( ParticleEvent.DIED, handleDeathParticleEmitterDied, false, 0, true );				}				*/							/** set/get contentClip			  *	---------------------------------------------------------------------------- */				override public function set contentClip( m:MovieClip ):void				{					super.contentClip = m;										//_upAnimationClip.addEventListener( BoogaEvent.ON_ANIMATION_EVENT, handleAnimationEventFired, false, 0, true );					//_downAnimationClip.addEventListener( BoogaEvent.ON_ANIMATION_EVENT, handleAnimationEventFired, false, 0, true );					_upAnimationClip.onAnimationEventFired.add( handleAnimationEventFired );					_downAnimationClip.onAnimationEventFired.add( handleAnimationEventFired );				}							/** set/get attackingGameObject			  *	---------------------------------------------------------------------------- 				override public function set attackingGameObject( a:AbstractGameObject ):void				{					super.attackingGameObject = a;										_attackingGameObject.upAnimationObject.customPositions[0] = GameLevelUtil.getPositionIn2D( _attackingGameObject.upAnimationObject.customPositions[0] );					_attackingGameObject.downAnimationObject.customPositions[0] = GameLevelUtil.getPositionIn2D( _attackingGameObject.downAnimationObject.customPositions[0] );				}*/							/** init			  *	---------------------------------------------------------------------------- */				override public function init():void				{					//trace( "CatapultWeaponDisplayObject: init();" );										super.init();										_debug = true;										_attacking = false;					//_hasFired = false;										onCatapultFired = new Signal( CatapultWeaponDisplayObject, Point, Number );				}							/** pause			  *	---------------------------------------------------------------------------- */				override public function pause():void				{					if( _attacking )					{						_attackTimer.pause();					}										_currentAnimationDisplayObject.pause();				}							/** unpause			  *	---------------------------------------------------------------------------- */				override public function unpause():void				{					if( _attacking )					{						_attackTimer.unpause();					}										_currentAnimationDisplayObject.unpause();				}							/** kill			  *	---------------------------------------------------------------------------- */				override public function kill():void				{					if( _debug ) ConsoleBroadcaster.broadcast( "CatapultWeaponDisplayObject", "kill();" );										//_upAnimationClip.stopAnimation();					//_upAnimationClip.removeEventListener( BoogaEvent.ON_ANIMATION_EVENT, handleAnimationEventFired );					//_upAnimationClip.kill();										//_downAnimationClip.stopAnimation();					//_downAnimationClip.removeEventListener( BoogaEvent.ON_ANIMATION_EVENT, handleAnimationEventFired );					//_downAnimationClip.kill();										_upAnimationClip.onAnimationEventFired.remove( handleAnimationEventFired );					_downAnimationClip.onAnimationEventFired.remove( handleAnimationEventFired );										//_currentAnimationDisplayObject = null;										onCatapultFired = null;										super.kill();				}							/** die			  *	---------------------------------------------------------------------------- */				override public function die():void				{					//if( _debug ) ConsoleBroadcaster.broadcast( "CatapultWeaponDisplayObject", "die();" );										if( _alive )					{						/*						_alive = false;												stopAttacking();												//TODO:						//	Play the death animation												_currentAnimationDisplayObject.stopAnimation();						_currentAnimationDisplayObject.visible = false;												dispatchEvent( new GameLevelEvent(GameLevelEvent.DIE) );						dispatchEvent( new GameLevelEvent(GameLevelEvent.REMOVE_FROM_GAME) );						*/												super.die();					}										//trace( "_tilesWatching: "+_tilesWatching );										//var i:uint;										//kill();									}							/** placedOnBoard			  *	---------------------------------------------------------------------------- *			  *	Called when WeaponDisplayObject gets added to the stage.			  *	Each weapon type is going to do different things ( either going to just stay			  *	static or actually going to start animating ).			  *	---------------------------------------------------------------------------- */				override public function placedOnBoard():void				{					_currentAnimationDisplayObject.showAnimation( 0 );					_currentAnimationDisplayObject.startIdleAnimation();				}							/** attackTargets			  *	---------------------------------------------------------------------------- *			  *	See if this object can attack one of the targets that are given.			  *	It always attacks the closest target.			  *	---------------------------------------------------------------------------- 				override public function attackTargets( targets:Array ):GameLevelAttackingDisplayObject				{					if( _alive )					{						_attackedTarget = super.attackTargets( targets );												if( _attackedTarget != null )						{							if( !_attackingGameObject.oneDirectionOnly ) showAnimation( _direction );							return _attackedTarget;						}					}										return null;				}*/							/** handleAnimationEventFired			  *	---------------------------------------------------------------------------- */				override protected function handleAnimationEventFired():void				{					ConsoleBroadcaster.broadcast( "CatapultWeaponDisplayObject", "handleAnimationEventFired();" );										if( _alive && _attackedTarget != null )					{						//TODO:						//	Depending on the type of weapons, it will either 						//_attackedTarget.hit( _attackingGameObject, _attackingGameObject.power );						//_attackedTarget = null;												//_hasFired = true;						//trace( "shootTo: "+_attackedTarget.positionIn2D );												//dispatchEvent( new GameLevelEvent(GameLevelEvent.CATAPULT_FIRE, {shootTo:_attackedTarget.positionIn2D, altitude:_attackedTarget.altitude}) );						onCatapultFired.dispatch( this, _attackedTarget.positionIn2D, _attackedTarget.altitude );					}				}						}			}