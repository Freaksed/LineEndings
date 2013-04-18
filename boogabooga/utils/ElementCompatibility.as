﻿/** ElementCompatibility  *	---------------------------------------------------------------------------- *  *	@desc:  *		Util class for GameLevel  *	@author:   *		Christian Widodo, [christian@avatarlabs.com]  *	---------------------------------------------------------------------------- */ 	package com.boogabooga.utils	{		import flash.display.MovieClip;		import flash.events.EventDispatcher;		import flash.filters.ColorMatrixFilter;		import flash.geom.Point;				import com.avatarlabs.utils.ArrayUtil;		import com.avatarlabs.utils.cache.HashTable;		import com.avatarlabs.utils.cache.BitmapDataManager;		import com.boogabooga.data.SoundsIndex;		import com.boogabooga.data.gamelevel.AbstractGameObject;		import com.boogabooga.data.gamelevel.AnimationObject;		import com.boogabooga.data.gamelevel.DiggingMap;		import com.boogabooga.data.gamelevel.Enemy;		import com.boogabooga.data.gamelevel.EnvironmentObject;		import com.boogabooga.data.gamelevel.GameLevel;		import com.boogabooga.data.gamelevel.GameLevelDataIndex;		import com.boogabooga.data.gamelevel.God;		import com.boogabooga.data.gamelevel.Weapon;		import com.boogabooga.data.gamelevel.Villager;		import com.boogabooga.data.maingame.*;		import com.boogabooga.ui.gamelevel.GameboardTile;				public class ElementCompatibility extends Object		{			//_elements.push( {element:ATTACK_PROPERTY_FIRE_INDEX, elementAgainst:ATTACK_PROPERTY_ICE_INDEX, protection:ATTACK_PROPERTY_PROTECTION_FROM_FIRE_INDEX, strongAgainst:ATTACK_PROPERTY_STRONG_AGAINST_FIRE_INDEX, weakAgainst:ATTACK_PROPERTY_WEAK_AGAINST_ICE_INDEX} );			private var _element:int;			private var _against:int;			private var _protection:int;			private var _strongAgainst:int;			private var _weakAgainst:int;			private var _strongPowerMultiplier:int;						/** Constructor			  *	---------------------------------------------------------------------------- */				public function ElementCompatibility( element:int, against:int, protection:int, strongAgainst:int, weakAgainst:int, strongPowerMultiplier:int=2 )				{					_element = element;					_against = against;					_protection = protection;					_strongAgainst = strongAgainst;					_weakAgainst = weakAgainst;					_strongPowerMultiplier = strongPowerMultiplier;				}								public function get element():int { return _element; }				public function get against():int { return _against; }				public function get protection():int { return _protection; }				public function get strongAgainst():int { return _strongAgainst; }				public function get weakAgainst():int { return _weakAgainst; }				public function get strongPowerMultiplier():int { return _strongPowerMultiplier; }						}			}