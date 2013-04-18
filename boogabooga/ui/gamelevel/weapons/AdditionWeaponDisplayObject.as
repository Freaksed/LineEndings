﻿/** AdditionWeaponDisplayObject  *	---------------------------------------------------------------------------- *  *	@desc:  *		This is the display object clip that will represent Weapon class.  *		Weapon properties ( Create classes to represent these different weapons )  *			- single lane / multiple lane  *			- shoots one direction / all directions  *			- affect flying enemies / not  *			- affect digging enemies / not  *			- projectile / close range / blocking / trap / instant  *			- one hit kill  *			- element properties ( fire, ice, poison )  *			- modifier ( can add attributes to existing weapons )  *			- area of effect on hit  *	@author:   *		Christian Widodo, [christian@avatarlabs.com]  *	---------------------------------------------------------------------------- */ 	package com.boogabooga.ui.gamelevel.weapons	{		import flash.display.Bitmap;		import flash.display.BitmapData;		import flash.display.BlendMode;		import flash.display.DisplayObject;		import flash.display.DisplayObjectContainer;		import flash.display.MovieClip;		import flash.events.Event;		import flash.events.TimerEvent;		import flash.geom.ColorTransform;		import flash.geom.Matrix;		import flash.geom.Point;		import flash.geom.Rectangle;		import flash.utils.getDefinitionByName;				import com.greensock.TweenLite;		import com.avatarlabs.utils.cache.BitmapDataManager;		import com.avatarlabs.utils.console.ConsoleBroadcaster;		import com.avatarlabs.utils.events.CustomEvent;		import com.avatarlabs.utils.loader.CustomLoader;		import com.avatarlabs.utils.UtilFunctions;		import com.avatarlabs.utils.timers.CustomTimer;		import com.avatarlabs.utils.userinterface.UILabel;		import com.desuade.partigen.emitters.Emitter;		import com.desuade.partigen.events.ParticleEvent;				//import com.gamelevel.data.*;		import com.boogabooga.data.gamelevel.AbstractGameObject;		import com.boogabooga.data.gamelevel.Weapon;		import com.boogabooga.events.GameLevelEvent;		import com.boogabooga.ui.gamelevel.AnimationDisplayObject;		import com.boogabooga.ui.gamelevel.GameLevelAttackingDisplayObject;		import com.boogabooga.ui.gamelevel.GameLevelDisplayObject;		import com.boogabooga.ui.gamelevel.weapons.WeaponDisplayObject;		import com.boogabooga.utils.GameLevelUtil;				public class AdditionWeaponDisplayObject extends WeaponDisplayObject		{						/**	Stage Instances **/			/**	End of Stage Instances **/						/** Constructor			  *	---------------------------------------------------------------------------- */				public function AdditionWeaponDisplayObject( contentClip:MovieClip=null )				{					super( contentClip );										//init();				}								/*				public function set deathParticleEmitter( e:Emitter ):void				{					trace( "set deathParticleEmitter" );										_deathParticleEmitter = e;					_deathParticleEmitter.addEventListener( ParticleEvent.DIED, handleDeathParticleEmitterDied, false, 0, true );				}				*/							/** init			  *	---------------------------------------------------------------------------- */				override public function init():void				{					//trace( "AdditionWeaponDisplayObject: init();" );										super.init();										_debug = true;										_attacking = false;					_ignoredByEnemy = true;									}							/** pause			  *	---------------------------------------------------------------------------- */				override public function pause():void				{					if( _attacking )					{						_attackTimer.pause();					}										_currentAnimationDisplayObject.pause();				}							/** unpause			  *	---------------------------------------------------------------------------- */				override public function unpause():void				{					if( _attacking )					{						_attackTimer.unpause();					}										_currentAnimationDisplayObject.unpause();				}							/** kill			  *	---------------------------------------------------------------------------- */				override public function kill():void				{					if( _debug ) ConsoleBroadcaster.broadcast( "AdditionWeaponDisplayObject", "kill();" );										_currentAnimationDisplayObject.stopAnimation();										super.kill();										_alive = false;				}							/** die			  *	---------------------------------------------------------------------------- */				override public function die():void				{					//if( _debug ) ConsoleBroadcaster.broadcast( "AdditionWeaponDisplayObject", "die();" );										if( _alive )					{						/*						_alive = false;												stopAttacking();												//TODO:						//	Play the death animation												_currentAnimationDisplayObject.stopAnimation();						_currentAnimationDisplayObject.visible = false;												dispatchEvent( new GameLevelEvent(GameLevelEvent.DIE) );						dispatchEvent( new GameLevelEvent(GameLevelEvent.REMOVE_FROM_GAME) );						*/												super.die();					}										//trace( "_tilesWatching: "+_tilesWatching );										//var i:uint;										//kill();				}							/** placedOnBoard			  *	---------------------------------------------------------------------------- *			  *	Called when WeaponDisplayObject gets added to the stage.			  *	Each weapon type is going to do different things ( either going to just stay			  *	static or actually going to start animating ).			  *	---------------------------------------------------------------------------- */				override public function placedOnBoard():void				{					if( _currentAnimationDisplayObject.animationObject.animationCount > 1 )						_currentAnimationDisplayObject.startAnimation();					else						_currentAnimationDisplayObject.showAnimation(0);										_currentAnimationDisplayObject.offsetX = _currentAnimationDisplayObject.animationObject.offset.x;					_currentAnimationDisplayObject.offsetY = _currentAnimationDisplayObject.animationObject.offset.y;									}				/*				public function triggerTrap():void				{					if( _attackingGameObject.oneDirectionOnly )					{						upAnimation_mc.startAnimation( false, 0 );						_currentAnimationDisplayObject = upAnimation_mc;					}					else					{						switch( direction )						{							case GameLevelUtil.DIRECTION_UP:								upAnimation_mc.initCanvas( false );								_currentAnimationDisplayObject = upAnimation_mc;								break;														case GameLevelUtil.DIRECTION_RIGHT:								upAnimation_mc.initCanvas( true );								_currentAnimationDisplayObject = upAnimation_mc;								break;														case GameLevelUtil.DIRECTION_DOWN:								downAnimation_mc.initCanvas( false );								_currentAnimationDisplayObject = downAnimation_mc;								break;														case GameLevelUtil.DIRECTION_LEFT:								downAnimation_mc.initCanvas( true );								_currentAnimationDisplayObject = downAnimation_mc;								break;						}												_currentAnimationDisplayObject.visible = true;						_currentAnimationDisplayObject.startAnimation( false, 0 );					}				}				*/			/** attackTargets			  *	---------------------------------------------------------------------------- *			  *	See if this object can attack one of the targets that are given.			  *	It always attacks the closest target.			  *	---------------------------------------------------------------------------- */				override public function attackTargets( targets:Vector.<GameLevelAttackingDisplayObject> ):GameLevelAttackingDisplayObject				{					return null;				}							/** canAttackTarget			  *	---------------------------------------------------------------------------- *			  *	Check to see if this object can attack the target. Override this function			  *	in the attacking object as the requirement is different for reach one.			  *	---------------------------------------------------------------------------- */				override protected function canAttackTarget( target:GameLevelDisplayObject ):Boolean				{					return false;				}							/** startAttackAnimation			  *	---------------------------------------------------------------------------- *			  *	Shows the attack animation of the displayObject. You can also do anything			  *	extra when it attacks. Separating this from attackTargets function so that			  *	extended classes can just override this function instead of overriding that 			  *	function.			  *	---------------------------------------------------------------------------- */				override public function startAttackAnimation():void				{					if( _debug ) ConsoleBroadcaster.broadcast( "AdditionWeaponDisplayObject", "startAttackAnimation();" );										//_currentAnimationDisplayObject.addEventListener( "onAnimationEnds", handleAnimationEnded, false, 0, true );					//_currentAnimationDisplayObject.addEventListener( "onAnimationEvent", handleAnimationEventFired, false, 0, true );					_currentAnimationDisplayObject.startAnimation( false );				}							/** handleAnimationEventFired			  *	---------------------------------------------------------------------------- 				override protected function handleAnimationEventFired( event:CustomEvent ):void				{					ConsoleBroadcaster.broadcast( "AdditionWeaponDisplayObject", "handleAnimationEventFired();" );										dispatchEvent( new GameLevelEvent(GameLevelEvent.TRAP_FIRE, {range:45+(_attackingGameObject.range-1)*90}) );										//if( _alive && _attackedTarget != null )					//{						//TODO:						//	Depending on the type of weapons, it will either 						//_attackedTarget.hit( _attackingGameObject, _attackingGameObject.power );						//_attackedTarget = null;												//_hasFired = true;						//trace( "shootTo: "+_attackedTarget.positionIn2D );					//}				}								protected function handleAnimationEnded( event:CustomEvent ):void				{					_currentAnimationDisplayObject.removeEventListener( "onAnimationEvent", handleAnimationEventFired );					_currentAnimationDisplayObject.removeEventListener( "onAnimationEnds", handleAnimationEnded );										dispatchEvent( new GameLevelEvent(GameLevelEvent.REMOVE_FROM_GAME) );				}				*/		}			}