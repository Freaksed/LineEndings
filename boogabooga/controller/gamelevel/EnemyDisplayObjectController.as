﻿/** EnemyDisplayObjectController  *	---------------------------------------------------------------------------- *  *	@desc:  *		Thils class controls all the enemies that are currently on the board,  *		active or non active.  *	  *	@author:   *		Christian Widodo, [christian@avatarlabs.com]  *	---------------------------------------------------------------------------- */	package com.boogabooga.controller.gamelevel	{		import flash.display.MovieClip;		import flash.events.*;		import flash.errors.*;		import flash.geom.Point;		import flash.utils.getDefinitionByName;		import flash.utils.getQualifiedClassName;		import flash.utils.getTimer;		import flash.utils.Timer;				import com.avatarlabs.utils.ArrayUtil;		import com.avatarlabs.utils.UtilFunctions;		import com.avatarlabs.utils.VectorUtil;		import com.avatarlabs.utils.events.CustomEvent;		import com.avatarlabs.utils.events.EventNotificationCenter;		import com.avatarlabs.utils.console.ConsoleBroadcaster;		import org.osflash.signals.Signal;				import com.boogabooga.controller.gamelevel.DisplayObjectController;		import com.boogabooga.controller.maingame.MainGameController;		import com.boogabooga.data.SettingsIndex;		import com.boogabooga.data.gamelevel.God;		import com.boogabooga.data.gamelevel.Laser;		import com.boogabooga.data.gamelevel.Projectile;		import com.boogabooga.data.gamelevel.Weapon;		import com.boogabooga.events.GameLevelEvent;		import com.boogabooga.ui.gamelevel.Gameboard;		import com.boogabooga.ui.gamelevel.GameboardTile;		import com.boogabooga.ui.gamelevel.GameLevelDisplayObject;		import com.boogabooga.ui.gamelevel.enemies.*;		import com.boogabooga.ui.gamelevel.projectiles.LaserDisplayObject;		import com.boogabooga.ui.gamelevel.weapons.*;		import com.boogabooga.utils.GameLevelUtil;				public class EnemyDisplayObjectController extends DisplayObjectController		{			protected var _gameboardController:GameboardController;			protected var _weaponDisplayObjectController:WeaponDisplayObjectController;			//protected var _enemyDisplayObjects:Array;			protected var _enemyDisplayObjects:Vector.<EnemyDisplayObject>;			protected var _enemyDisplayObjectsLength:int;						public var onEnemyMovedToNextTile:Signal;			public var onEnemyMovedToNextPoint:Signal;			public var onEnemySpawnPathEnded:Signal;			public var onEnemySpawnPathReentered:Signal;			public var onEnemyPathEnded:Signal;			public var onEnemyAttackTimerFired:Signal;			public var onEnemyHit:Signal;			public var onEnemyDied:Signal;			public var onEnemyRemovedFromGame:Signal;			public var onProjectileEnemyFired:Signal;			public var onCatapultEnemyFired:Signal;			public var onLaserEnemyFired:Signal;			public var onLaserEnemyHit:Signal;			public var onLaserEnemyStopped:Signal;			public var onEggLayerEnemyLaidEgg:Signal;			public var onEggEnemyHatched:Signal;						/** Constructor			  *	---------------------------------------------------------------------------- */			 	public function EnemyDisplayObjectController()				{					init();				}								public function set gameboardController( gc:GameboardController ):void { _gameboardController = gc; }							/** set weaponDisplayObjectController			  *	---------------------------------------------------------------------------- */				public function set weaponDisplayObjectController( controller:WeaponDisplayObjectController ):void { _weaponDisplayObjectController = controller; }								public function get enemyDisplayObjects():Vector.<EnemyDisplayObject> { return _enemyDisplayObjects; }				public function get enemyDisplayObjectsLength():int { return _enemyDisplayObjectsLength; }							/** init			  *	---------------------------------------------------------------------------- */				override public function init():void				{					super.init();										_debug = true;					//_enemyDisplayObjects = new Array();					_enemyDisplayObjects = new Vector.<EnemyDisplayObject>;										onEnemyMovedToNextTile = new Signal( EnemyDisplayObject, GameboardTile );					onEnemyMovedToNextPoint = new Signal( EnemyDisplayObject );					onEnemySpawnPathEnded = new Signal( EnemyDisplayObject );					onEnemySpawnPathReentered = new Signal( EnemyDisplayObject );					onEnemyPathEnded = new Signal( EnemyDisplayObject );					onEnemyAttackTimerFired = new Signal( EnemyDisplayObject );					onEnemyHit = new Signal();					onEnemyDied = new Signal( EnemyDisplayObject );					onEnemyRemovedFromGame = new Signal( EnemyDisplayObject );					onProjectileEnemyFired = new Signal( EnemyDisplayObject, int, Point, Number );					onCatapultEnemyFired = new Signal( EnemyDisplayObject, Point, Number );					onLaserEnemyFired = new Signal( EnemyDisplayObject, int, Point, Number );					onLaserEnemyHit = new Signal( EnemyDisplayObject );					onLaserEnemyStopped = new Signal( EnemyDisplayObject, LaserDisplayObject );					onEggLayerEnemyLaidEgg = new Signal( EnemyDisplayObject, Point, int, int, int, Vector.<GameboardTile> );					onEggEnemyHatched = new Signal( EnemyDisplayObject, Point, int, int, int, Vector.<GameboardTile> );				}							/** pause			  *	---------------------------------------------------------------------------- */				override public function pause():void				{					if( _debug ) ConsoleBroadcaster.broadcast( "EnemyDisplayObjectController", "pause();" );										for( var i:uint=0; i<_enemyDisplayObjectsLength; ++i )					{						_enemyDisplayObjects[i].pause();					}				}							/** unpause			  *	---------------------------------------------------------------------------- */				override public function unpause():void				{					if( _debug ) ConsoleBroadcaster.broadcast( "EnemyDisplayObjectController", "unpause();" );										for( var i:uint=0; i<_enemyDisplayObjectsLength; ++i )					{						_enemyDisplayObjects[i].unpause();					}				}							/** kill			  *	---------------------------------------------------------------------------- */				override public function kill():void				{					if( _debug ) ConsoleBroadcaster.broadcast( "EnemyDisplayObjectController", "kill();" );										/*					for( var i:uint=0; i<_enemyDisplayObjectsLength; ++i )					{						EnemyDisplayObject(_enemyDisplayObjects[i]).kill();						_enemyDisplayObjects[i] = null;					}					*/										while( _enemyDisplayObjects.length > 0 )						removeEnemy( _enemyDisplayObjects[0] );										_enemyDisplayObjects = null;					_enemyDisplayObjectsLength = 0;										onEnemyMovedToNextTile = null;					onEnemyMovedToNextPoint = null;					onEnemySpawnPathEnded = null;					onEnemySpawnPathReentered = null;					onEnemyPathEnded = null;					onEnemyAttackTimerFired = null;					onEnemyHit = null;					onEnemyDied = null;					onEnemyRemovedFromGame = null;					onProjectileEnemyFired = null;					onCatapultEnemyFired = null;					onLaserEnemyFired = null;					onLaserEnemyHit = null;					onLaserEnemyStopped = null;					onEggLayerEnemyLaidEgg = null;					onEggEnemyHatched = null;										super.kill();				}							/** updateOnEnterFrame			  *	---------------------------------------------------------------------------- *			  *	This updates the display object on every enter frame loop.			  *	---------------------------------------------------------------------------- */				public function updateOnEnterFrame():void				{					for( var i:int=0; i<_enemyDisplayObjectsLength; ++i )					{						_enemyDisplayObjects[i].updateOnEnterFrame();					}				}							/** addEnemy			  *	---------------------------------------------------------------------------- *			  *	Adds enemy display object to stage, add all the required event listeners.			  *	---------------------------------------------------------------------------- */				public function addEnemy( displayObject:EnemyDisplayObject, customPosition:Boolean=false ):void				{					//if( _debug ) ConsoleBroadcaster.broadcast( "EnemyDisplayObjectController", "addEnemy("+displayObject+");" );										//displayObject.addEventListener( GameLevelEvent.MOVING_TO_NEXT_TILE, handleEnemyMovingToNextTile, false, 0, true );					//displayObject.addEventListener( GameLevelEvent.MOVING_TO_NEXT_POINT, handleEnemyMovingToNextPoint, false, 0, true );					//displayObject.addEventListener( GameLevelEvent.SPAWN_PATH_END, handleEnemyHitsEndOfSpawnPath, false, 0, true );					//displayObject.addEventListener( GameLevelEvent.PATH_END, handleEnemyPathEnded, false, 0, true );					//displayObject.addEventListener( GameLevelEvent.HIT, handleEnemyHit, false, 0, true );					//displayObject.addEventListener( GameLevelEvent.DIE, handleEnemyDied, false, 0, true );					//displayObject.addEventListener( GameLevelEvent.REMOVE_FROM_GAME, handleEnemyRemovedFromGame, false, 0, true );					//displayObject.addEventListener( GameLevelEvent.ATTACK_TIMER_FIRE, handleEnemyAttackTimerFired, false, 0, true );					displayObject.onMovedToNextTile.add( handleEnemyMovedToNextTile );					displayObject.onMovedToNextPoint.add( handleEnemyMovedToNextPoint );					displayObject.onSpawnPathEnded.add( handleEnemySpawnPathEnded );					displayObject.onSpawnPathReentered.add( handleEnemySpawnPathReentered );					displayObject.onPathEnded.add( handleEnemyPathEnded );					displayObject.onHit.add( handleEnemyHit );					displayObject.onDied.add( handleEnemyDied );					displayObject.onRemovedFromGame.add( handleEnemyRemovedFromGame );					displayObject.onAttackTimerFired.add( handleEnemyAttackTimerFired );										if( displayObject is ProjectileEnemyDisplayObject )					{						//displayObject.addEventListener( GameLevelEvent.PROJECTILE_FIRE, handleProjectileEnemyFired, false, 0, true );						displayObject.onProjectileFired.add( handleProjectileEnemyFired );					}					else if( displayObject is LaserEnemyDisplayObject )					{						//displayObject.addEventListener( GameLevelEvent.LASER_FIRE, handleLaserEnemyFired, false, 0, true );						//displayObject.addEventListener( GameLevelEvent.LASER_HIT, handleLaserEnemyHit, false, 0, true );						//displayObject.addEventListener( GameLevelEvent.LASER_STOP, handleLaserEnemyStopped, false, 0, true );						displayObject.onLaserFired.add( handleLaserEnemyFired );						displayObject.onLaserHit.add( handleLaserEnemyHit );						displayObject.onLaserStopped.add( handleLaserEnemyStopped );					}					else if( displayObject is CatapultEnemyDisplayObject )					{						//displayObject.addEventListener( GameLevelEvent.CATAPULT_FIRE, handleCatapultEnemyFired, false, 0, true );						displayObject.onCatapultFired.add( handleCatapultEnemyFired );					}					else if( displayObject is EggLayerEnemyDisplayObject )					{						//displayObject.addEventListener( GameLevelEvent.LAY_EGG, handleEggLayerEnemyLaidEgg, false, 0, true );						displayObject.onLaidEgg.add( handleEggLayerEnemyLaidEgg );					}					else if( displayObject is EggEnemyDisplayObject )					{						//displayObject.addEventListener( GameLevelEvent.HATCH, handleEggEnemyHatched, false, 0, true );						displayObject.onHatched.add( handleEggEnemyHatched );					}					else if( displayObject is JumpingEnemyDisplayObject )					{						//displayObject.addEventListener( GameLevelEvent.LAND, handleJumpingEnemyLanded, false, 0, true );					}										//displayObject.pathIndex = _gameboardController.attackingDisplayObjectController.getPathIndex( displayObject.currentTile );										//displayObject.altitude = -100;										_enemyDisplayObjects.push( displayObject );					_enemyDisplayObjectsLength = _enemyDisplayObjects.length;										if( SettingsIndex.getInstance().getPerformanceItemToggled(SettingsIndex.PERFORMANCE_ITEM_SHADOW) )					{						var shadowDisplayObject:GameLevelDisplayObject = new GameLevelDisplayObject();							shadowDisplayObject.contentClip = new (getDefinitionByName("EnemyDisplayObject.shadow") as Class)();							//shadowDisplayObject.inIsometricView = displayObject.inIsometricView;											displayObject.shadowDisplayObject = shadowDisplayObject;											//trace( "displayObject.currentTile: "+displayObject.currentTile );												_gameboardReference.displayLayerClip.moveClipToLayer( displayObject.shadowDisplayObject.contentClip, displayObject.currentTile.layerNumber );					}										_gameboardReference.displayLayerClip.moveClipToLayer( displayObject.contentClip, displayObject.currentTile.layerNumber );										displayObject.placedOnBoard( customPosition );									}							/** removeEnemy			  *	---------------------------------------------------------------------------- *			  *	---------------------------------------------------------------------------- */				public function removeEnemy( displayObject:EnemyDisplayObject ):void				{					//if( _debug ) ConsoleBroadcaster.broadcast( "EnemyDisplayObjectController", "removeEnemy("+displayObject+");" );										/*					for( var i:uint=0; i<_enemyDisplayObjects.length; ++i )					{						if( _enemyDisplayObjects[i] == displayObject )						{																					MovieClip(_enemyDisplayObjects[i].parent).removeChild( _enemyDisplayObjects[i] );							_enemyDisplayObjects[i] = null;							_enemyDisplayObjects.splice( i, 1 );														break;						}					}					*/										var enemyDisplayObject:EnemyDisplayObject = VectorUtil.remove( _enemyDisplayObjects, displayObject );					_enemyDisplayObjectsLength = _enemyDisplayObjects.length;										if( enemyDisplayObject != null )//&& enemyDisplayObject.alive )					{						//enemyDisplayObject.removeEventListener( GameLevelEvent.MOVING_TO_NEXT_TILE, handleEnemyMovingToNextTile );						//enemyDisplayObject.removeEventListener( GameLevelEvent.MOVING_TO_NEXT_POINT, handleEnemyMovingToNextPoint );						//enemyDisplayObject.removeEventListener( GameLevelEvent.SPAWN_PATH_END, handleEnemyHitsEndOfSpawnPath );						//enemyDisplayObject.removeEventListener( GameLevelEvent.PATH_END, handleEnemyPathEnded );						//enemyDisplayObject.removeEventListener( GameLevelEvent.HIT, handleEnemyHit );						//enemyDisplayObject.removeEventListener( GameLevelEvent.DIE, handleEnemyDied );						//enemyDisplayObject.removeEventListener( GameLevelEvent.REMOVE_FROM_GAME, handleEnemyRemovedFromGame );						//enemyDisplayObject.removeEventListener( GameLevelEvent.ATTACK_TIMER_FIRE, handleEnemyAttackTimerFired );						enemyDisplayObject.onMovedToNextTile.remove( handleEnemyMovedToNextTile );						enemyDisplayObject.onMovedToNextPoint.remove( handleEnemyMovedToNextPoint );						enemyDisplayObject.onSpawnPathEnded.remove( handleEnemySpawnPathEnded );						enemyDisplayObject.onPathEnded.remove( handleEnemyPathEnded );						enemyDisplayObject.onHit.remove( handleEnemyHit );						enemyDisplayObject.onDied.remove( handleEnemyDied );						enemyDisplayObject.onRemovedFromGame.remove( handleEnemyRemovedFromGame );						enemyDisplayObject.onAttackTimerFired.remove( handleEnemyAttackTimerFired );												if( displayObject is ProjectileEnemyDisplayObject )						{							//displayObject.removeEventListener( GameLevelEvent.PROJECTILE_FIRE, handleProjectileEnemyFired );							enemyDisplayObject.onProjectileFired.remove( handleProjectileEnemyFired );						}						else if( displayObject is LaserEnemyDisplayObject )						{							//displayObject.removeEventListener( GameLevelEvent.LASER_FIRE, handleLaserEnemyFired );							//displayObject.removeEventListener( GameLevelEvent.LASER_HIT, handleLaserEnemyHit );							//displayObject.removeEventListener( GameLevelEvent.LASER_STOP, handleLaserEnemyStopped );							enemyDisplayObject.onLaserFired.remove( handleLaserEnemyFired );							enemyDisplayObject.onLaserHit.remove( handleLaserEnemyHit );							enemyDisplayObject.onLaserStopped.remove( handleLaserEnemyStopped );						}						else if( displayObject is CatapultEnemyDisplayObject )						{							//displayObject.removeEventListener( GameLevelEvent.CATAPULT_FIRE, handleCatapultEnemyFired );							enemyDisplayObject.onCatapultFired.remove( handleCatapultEnemyFired );						}						else if( displayObject is EggLayerEnemyDisplayObject )						{							//displayObject.removeEventListener( GameLevelEvent.LAY_EGG, handleEggLayerEnemyLaidEgg );							enemyDisplayObject.onLaidEgg.remove( handleEggLayerEnemyLaidEgg );						}						else if( displayObject is EggEnemyDisplayObject )						{							//displayObject.removeEventListener( GameLevelEvent.HATCH, handleEggEnemyHatched );							enemyDisplayObject.onHatched.remove( handleEggEnemyHatched );						}						else if( displayObject is JumpingEnemyDisplayObject )						{							//displayObject.removeEventListener( GameLevelEvent.LAND, handleJumpingEnemyLanded );						}												enemyDisplayObject.contentClip.parent.removeChild( enemyDisplayObject.contentClip );												if( enemyDisplayObject.shadowDisplayObject != null )							enemyDisplayObject.shadowDisplayObject.contentClip.parent.removeChild( enemyDisplayObject.shadowDisplayObject.contentClip );												enemyDisplayObject.kill();						enemyDisplayObject = null;					}				}							/** hitEnemiesByGodAttack			  *	---------------------------------------------------------------------------- *			  *	---------------------------------------------------------------------------- */				public function hitEnemiesByGodAttack( god:God ):void				{					//if( _debug ) ConsoleBroadcaster.broadcast( "EnemyDisplayObjectController", "hitEnemiesByGodAttack();" );										//trace( _enemyDisplayObjects );										var tempArray:Vector.<EnemyDisplayObject> = _enemyDisplayObjects.concat();										for( var i:uint=0; i<tempArray.length; ++i )					{						//trace( "hitByCurrentGod ? "+tempArray[i].hitByCurrentGod );												if( !EnemyDisplayObject(tempArray[i]).hitByCurrentGod )						{							tempArray[i].hitByCurrentGod = true;							tempArray[i].hit( god, god.power, god.hasAttackProperty(GameLevelUtil.ATTACK_PROPERTY_ONE_HIT_KILL_INDEX) );						}					}										VectorUtil.removeAll( tempArray );					tempArray = null;				}							/** unflagEnemiesHitByGodAttack			  *	---------------------------------------------------------------------------- *			  *	Sets the flag that the enemies hit by current god attack to false.			  *	---------------------------------------------------------------------------- */				public function unflagEnemiesHitByGodAttack():void				{					for( var i:uint=0; i<_enemyDisplayObjectsLength; ++i )					{						_enemyDisplayObjects[i].hitByCurrentGod = false;					}				}							/** attackEnemiesInARange			  *	---------------------------------------------------------------------------- */				public function attackEnemiesInARange( point:Point, range:Number, displayObject:GameLevelDisplayObject, power:Number ):void				{					//ConsoleBroadcaster.broadcast( "EnemyDisplayObjectController", "attackEnemiesInARange();" );										// These are for the bomb weapons.					// Attack all enemies within the range										var distance:Number;					var weaponRange = range * range;										//trace( "weaponRange: "+weaponRange );										for( var i:uint=0; i<_enemyDisplayObjectsLength; ++i )					{						distance = (point.x - _enemyDisplayObjects[i].positionIn2D.x) * (point.x - _enemyDisplayObjects[i].positionIn2D.x);						distance += (point.y - _enemyDisplayObjects[i].positionIn2D.y) * (point.y - _enemyDisplayObjects[i].positionIn2D.y);						//if( _enemyDisplayObjects[i].positionIn2D.x - point.x												//trace( _enemyDisplayObjects[i].toString()+" distance "+distance );												if( distance <= weaponRange )						{							//trace( "hit" );							if( displayObject is TrapWeaponDisplayObject )							{								if( displayObject.attackingGameObject.hasAttackProperty(GameLevelUtil.ATTACK_PROPERTY_SPRING_TRAP_INDEX) )									_enemyDisplayObjects[i].hitBySpringTrap();								else									_enemyDisplayObjects[i].hit( displayObject.attackingGameObject, power, displayObject.attackingGameObject.hasAttackProperty(GameLevelUtil.ATTACK_PROPERTY_ONE_HIT_KILL_INDEX) );							}							else							{								_enemyDisplayObjects[i].hit( displayObject.attackingGameObject, power, displayObject.attackingGameObject.hasAttackProperty(GameLevelUtil.ATTACK_PROPERTY_ONE_HIT_KILL_INDEX) );							}						}					}				}							/** handleEnemyMovedToNextTile			  *	---------------------------------------------------------------------------- *			  *	---------------------------------------------------------------------------- */				protected function handleEnemyMovedToNextTile( enemyDisplayObject:EnemyDisplayObject, tile:GameboardTile ):void				{					if( enemyDisplayObject.shadowDisplayObject != null && SettingsIndex.getInstance().getPerformanceItemToggled(SettingsIndex.PERFORMANCE_ITEM_SHADOW) )						_gameboardReference.displayLayerClip.moveClipToLayer( enemyDisplayObject.shadowDisplayObject.contentClip, GameboardTile(tile).layerNumber );										_gameboardReference.displayLayerClip.moveClipToLayer( enemyDisplayObject.contentClip, GameboardTile(tile).layerNumber );										var stagePosition:Point = enemyDisplayObject.contentClip.parent.localToGlobal( new Point(enemyDisplayObject.contentClip.x, enemyDisplayObject.contentClip.y) );										if( !enemyDisplayObject.inSpawnPath )						//dispatchEvent( new GameLevelEvent(GameLevelEvent.MOVING_TO_NEXT_TILE, {enemyDisplayObject:enemyDisplayObject, tile:tile}) );						onEnemyMovedToNextTile.dispatch( enemyDisplayObject, tile );										//trace( "enemy tile: "+tile );										//_gameboardController.attackingDisplayObjectController.add										//_gameboardReference.testMarker_mc.x = stagePosition.x;					//_gameboardReference.testMarker_mc.y = stagePosition.y;										//trace( "stagePosition: "+stagePosition );				}							/** handleEnemyAttackingTile			  *	---------------------------------------------------------------------------- *			  *	---------------------------------------------------------------------------- */				protected function handleEnemyAttackingTile( event:CustomEvent ):void				{					//if( _debug ) ConsoleBroadcaster.broadcast( "EnemyDisplayObjectController", "handleEnemyAttackingTile();" );										//EnemyDisplayObject(event.currentTarget).startAttacking( _weaponDisplayObjectController.getWeaponInTile(event.customParameters.tile as GameboardTile) );				}							/** handleEnemyMovedToNextPoint			  *	---------------------------------------------------------------------------- *			  *	---------------------------------------------------------------------------- */				//protected function handleEnemyMovingToNextPoint( event:CustomEvent ):void				protected function handleEnemyMovedToNextPoint( enemyDisplayObject:EnemyDisplayObject ):void				{					//if( _debug ) ConsoleBroadcaster.broadcast( "EnemyDisplayObjectController", "handleEnemyMovingToNextPoint();" );										//dispatchEvent( new GameLevelEvent(GameLevelEvent.MOVING_TO_NEXT_POINT, {enemyDisplayObject:enemyDisplayObject}) );					onEnemyMovedToNextPoint.dispatch( enemyDisplayObject );				}								//protected function handleEnemyHitsEndOfSpawnPath( event:CustomEvent ):void				protected function handleEnemySpawnPathEnded( enemyDisplayObject:EnemyDisplayObject ):void				{					//dispatchEvent( new GameLevelEvent(GameLevelEvent.SPAWN_PATH_END, {enemyDisplayObject:enemyDisplayObject}) );					onEnemySpawnPathEnded.dispatch( enemyDisplayObject );				}								private function handleEnemySpawnPathReentered( enemyDisplayObject:EnemyDisplayObject ):void				{					onEnemySpawnPathReentered.dispatch( enemyDisplayObject );				}							/** handleEnemyPathEnded			  *	---------------------------------------------------------------------------- *			  *	---------------------------------------------------------------------------- */				protected function handleEnemyPathEnded( enemyDisplayObject:EnemyDisplayObject ):void				{					//if( _debug ) ConsoleBroadcaster.broadcast( "EnemyDisplayObjectController", "handleEnemyPathEnded();" );										//dispatchEvent( new GameLevelEvent(GameLevelEvent.PATH_END, {enemyDisplayObject:enemyDisplayObject}) );					onEnemyPathEnded.dispatch( enemyDisplayObject );				}							/** handleEnemyHit			  *	---------------------------------------------------------------------------- *			  *	---------------------------------------------------------------------------- */				protected function handleEnemyHit( enemyDisplayObject:EnemyDisplayObject ):void				{					//if( _debug ) ConsoleBroadcaster.broadcast( "EnemyDisplayObjectController", "handleEnemyHit();" );					/*					var stagePosition:Point = (event.currentTarget as EnemyDisplayObject).contentClip.parent.localToGlobal( new Point(event.currentTarget.contentClip.x, event.currentTarget.contentClip.y) );										EventNotificationCenter.getInstance().sendNotificationWithParameters( "onPlayOverlayEffect", this, 																						 {linkageId:"DamageOverlayLibrary", position:stagePosition, power:event.customParameters.power} );					*/										if( MainGameController.getInstance().currentUser.tutorialGameLevel )						//dispatchEvent( new GameLevelEvent(GameLevelEvent.HIT) );						onEnemyHit.dispatch( enemyDisplayObject );				}							/** handleEnemyDied			  *	---------------------------------------------------------------------------- *			  *	---------------------------------------------------------------------------- */				protected function handleEnemyDied( enemyDisplayObject:EnemyDisplayObject ):void				{					//if( _debug ) ConsoleBroadcaster.broadcast( "EnemyDisplayObjectController", "handleEnemyDied();" );										//_gameboardController.attackingDisplayObjectController.removeEnemy( event.currentTarget as EnemyDisplayObject );					//removeEnemy( event.currentTarget as EnemyDisplayObject );										//dispatchEvent( new GameLevelEvent(GameLevelEvent.DIE, {enemyDisplayObject:enemyDisplayObject}) );					onEnemyDied.dispatch( enemyDisplayObject );				}							/** handleEnemyRemovedFromGame			  *	---------------------------------------------------------------------------- *			  *	---------------------------------------------------------------------------- */				protected function handleEnemyRemovedFromGame( enemyDisplayObject:EnemyDisplayObject ):void				{					//if( _debug ) ConsoleBroadcaster.broadcast( "EnemyDisplayObjectController", "handleEnemyRemovedFromGame();" );										//dispatchEvent( new GameLevelEvent(GameLevelEvent.REMOVE_FROM_GAME, {enemyDisplayObject:enemyDisplayObject}) );					onEnemyRemovedFromGame.dispatch( enemyDisplayObject );				}							/** handleEnemyAttackTimerFired			  *	---------------------------------------------------------------------------- *			  *	Enemy's rate of fire cools down, now it's asking for another weapon to hit			  *	if there are any in its range.			  *	---------------------------------------------------------------------------- */				protected function handleEnemyAttackTimerFired( enemyDisplayObject:EnemyDisplayObject ):void				{					//dispatchEvent( new GameLevelEvent(GameLevelEvent.ATTACK_TIMER_FIRE, {enemyDisplayObject:enemyDisplayObject}) );					onEnemyAttackTimerFired.dispatch( enemyDisplayObject );				}							/** handleProjectileEnemyFired			  *	---------------------------------------------------------------------------- *			  *	Enemy's rate of fire cools down, now it's asking for another weapon to hit			  *	if there are any in its range.			  *	---------------------------------------------------------------------------- */				protected function handleProjectileEnemyFired( enemyDisplayObject:EnemyDisplayObject, shootTo:Point, altitude:Number ):void				{					//if( _debug ) ConsoleBroadcaster.broadcast( "EnemyDisplayObjectController", "handleProjectileEnemyFired();" );										//var projectile:Projectile = new Projectile();						//projectile.upAnimationObject = EnemyDisplayObject(event.currentTarget).attackingGameObject.additionalAttackUpAnimationObject;						//projectile.downAnimationObject = EnemyDisplayObject(event.currentTarget).attackingGameObject.additionalAttackDownAnimationObject;											//dispatchEvent( new GameLevelEvent(GameLevelEvent.PROJECTILE_FIRE, {enemyDisplayObject:enemyDisplayObject, direction:enemyDisplayObject.direction, shootTo:shootTo, altitude:altitude}) );					onProjectileEnemyFired.dispatch( enemyDisplayObject, enemyDisplayObject.direction, shootTo, altitude );				}							/** handleLaserEnemyFired			  *	---------------------------------------------------------------------------- *			  *	Enemy's rate of fire cools down, now it's asking for another weapon to hit			  *	if there are any in its range.			  *	---------------------------------------------------------------------------- */				protected function handleLaserEnemyFired( enemyDisplayObject:EnemyDisplayObject, shootTo:Point, altitude:Number=0 ):void				{					//trace( "handleLaserEnemyFired(); "+getTimer() );										//var laser:Laser = new Laser();						//laser.upAnimationObject = EnemyDisplayObject(event.currentTarget).attackingGameObject.additionalAttackUpAnimationObject;						//laser.downAnimationObject = EnemyDisplayObject(event.currentTarget).attackingGameObject.additionalAttackDownAnimationObject;										//dispatchEvent( new GameLevelEvent(GameLevelEvent.LASER_FIRE, {enemyDisplayObject:enemyDisplayObject, direction:enemyDisplayObject.direction, shootTo:shootTo, altitude:altitude}) );					onLaserEnemyFired.dispatch( enemyDisplayObject, enemyDisplayObject.direction, shootTo, altitude );				}							/** handleLaserEnemyHit			  *	---------------------------------------------------------------------------- *			  *	When the laser hits, it will look for any weapons that are not hit yet and			  *	will hit them. It doesn't attack weapons twice during this duration.			  *	---------------------------------------------------------------------------- */				protected function handleLaserEnemyHit( enemyDisplayObject:EnemyDisplayObject ):void				{					//dispatchEvent( new GameLevelEvent(GameLevelEvent.LASER_HIT, {enemyDisplayObject:enemyDisplayObject}) );					onLaserEnemyHit.dispatch( enemyDisplayObject );				}							/** handleLaserEnemyStopped			  *	---------------------------------------------------------------------------- *			  *	Enemy's laser stopped and remove it fromt he gameboard.			  *	---------------------------------------------------------------------------- */				protected function handleLaserEnemyStopped( enemyDisplayObject:EnemyDisplayObject, laserDisplayObject:LaserDisplayObject ):void				{					//trace( "handleLaserEnemyStopped();" );										//ConsoleBroadcaster.broadcast( "EnemyDisplayObjectController", "handleLaserEnemyStopped" );										//dispatchEvent( new GameLevelEvent(GameLevelEvent.LASER_STOP, {enemyDisplayObject:enemyDisplayObject, laserDisplayObject:laserDisplayObject}) );					onLaserEnemyStopped.dispatch( enemyDisplayObject, laserDisplayObject );				}								protected function handleCatapultEnemyFired( enemyDisplayObject:EnemyDisplayObject, shootTo:Point, altitude:Number ):void				{					//ConsoleBroadcaster.broadcast( "EnemyDisplayObjectController", "handleCatapultEnemyFired();" );										//dispatchEvent( new GameLevelEvent(GameLevelEvent.CATAPULT_FIRE, {enemyDisplayObject:enemyDisplayObject, shootTo:shootTo, altitude:altitude}) );					onCatapultEnemyFired.dispatch( enemyDisplayObject, shootTo, altitude );				}							/** handleEggLayerEnemyLaidEgg			  *	---------------------------------------------------------------------------- *			  *	EggLayerEnemyDisplayObject lays an egg on the path.			  *	---------------------------------------------------------------------------- */				protected function handleEggLayerEnemyLaidEgg( enemyDisplayObject:EnemyDisplayObject, position:Point, hatchlingId:int, pathIndex:int, currentIndexInPath:int, path:Vector.<GameboardTile> ):void				{					//if( _debug ) ConsoleBroadcaster.broadcast( "EnemyDisplayObjectController", "handleEggLayerEnemyLaidEgg();" );										//dispatchEvent( new GameLevelEvent(GameLevelEvent.LAY_EGG, event.customParameters) );					onEggLayerEnemyLaidEgg.dispatch( enemyDisplayObject, position, hatchlingId, pathIndex, currentIndexInPath, path );				}							/** handleEggEnemyHatched			  *	---------------------------------------------------------------------------- *			  *	EggEnemyDisplayObject hatches and spawns the hatchling enemy.			  *	---------------------------------------------------------------------------- */				protected function handleEggEnemyHatched( enemyDisplayObject:EnemyDisplayObject, position:Point, hatchlingId:int, pathIndex:int, currentIndexInPath:int, path:Vector.<GameboardTile> ):void				{					//dispatchEvent( new GameLevelEvent(GameLevelEvent.HATCH, event.customParameters) );					onEggEnemyHatched.dispatch( enemyDisplayObject, position, hatchlingId, pathIndex, currentIndexInPath, path );				}							/** handleJumpingEnemyLanded			  *	---------------------------------------------------------------------------- *			  *	JumplingEnemyDisplayObject lands after jumping.			  *	---------------------------------------------------------------------------- 				protected function handleJumpingEnemyLanded( event:CustomEvent ):void				{					dispatchEvent( new GameLevelEvent(GameLevelEvent.LAND, {enemyDisplayObject:event.currentTarget as EnemyDisplayObject}) );				}*/							/** turnOffShadow			  *	---------------------------------------------------------------------------- *			  *	Turns off the enemy's shadows			  *	---------------------------------------------------------------------------- */				public function turnOffShadow():void				{					if( !SettingsIndex.getInstance().getPerformanceItemToggled(SettingsIndex.PERFORMANCE_ITEM_SHADOW) )					{						//trace( "turning shadow off" );						for( var i:int=0; i<_enemyDisplayObjectsLength; ++i )						{							if( _enemyDisplayObjects[i].shadowDisplayObject != null )							{								_enemyDisplayObjects[i].shadowDisplayObject.contentClip.stop();								_enemyDisplayObjects[i].shadowDisplayObject.contentClip.visible = false;							}						}					}				}		}	}