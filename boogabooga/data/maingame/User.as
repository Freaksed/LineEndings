﻿/** User  *	---------------------------------------------------------------------------- *  *	@desc:  *		User data class  *	@author:   *		Christian Widodo, [christian@avatarlabs.com]  *	---------------------------------------------------------------------------- */	package com.boogabooga.data.maingame	{		import flash.events.Event;		import flash.events.EventDispatcher;		import flash.events.IOErrorEvent;		import flash.events.FullScreenEvent;		import flash.events.ProgressEvent;		import flash.external.ExternalInterface;		import flash.net.URLLoader;		import flash.net.URLRequest;		import flash.net.URLRequestMethod;		import flash.net.URLVariables;				import com.avatarlabs.utils.VectorUtil;		import com.avatarlabs.utils.events.CustomEvent;		import com.avatarlabs.utils.events.EventNotificationCenter;		import com.avatarlabs.utils.console.ConsoleBroadcaster;		import org.osflash.signals.Signal;				import com.boogabooga.data.gamelevel.*;		import com.boogabooga.data.maingame.*;				public class User extends Object		{			protected var _id:uint;			protected var _fbId:String;			protected var _fbProfilePicURL:String;			protected var _firstName:String;			protected var _lastName:String;			protected var _currentIslandId:int;			protected var _currentVillageId:int;			protected var _level:int;			protected var _adventureLevel:int;			protected var _adventureScore:Number;			protected var _nextAdventureScore:Number;			protected var _prevAdventureScore:Number;			protected var _attackSlots:int;			protected var _lastLogin:Date;			protected var _unlockedWeapons:Vector.<Weapon>;			protected var _unlockedGods:Vector.<God>;			protected var _unlockedEnemies:Vector.<Enemy>;			protected var _unlockedIslands:Vector.<Island>;			//protected var _unlockedCryptologies:Vector.<Cryptology>;			protected var _unlockedTreasures:Vector.<Treasure>;			protected var _unlockedDiggingMaps:Vector.<DiggingMap>;			protected var _gifts:Vector.<Gift>;			//protected var _requestCryptologies:Vector.<RequestCryptology>;			protected var _canRequestGiftFrom:Boolean;			protected var _locale:String;			protected var _messagesCount:int;			protected var _fbCreditsBalance:Number;			protected var _mysteryGift:Boolean;			//protected var _nonAppUserFriends:Vector.<User>;						protected var _tutorialMap:Boolean;			protected var _tutorialGameLevel:Boolean;			protected var _tutorialGameLevelDelete:Boolean;			protected var _tutorialWin:Boolean;			protected var _tutorialSlotMachine:Boolean;			protected var _tutorialJournal:Boolean;			protected var _tutorialDig:Boolean;			protected var _tutorialGift:Boolean;			protected var _tutorialLevelSetup:Boolean;			protected var _tutorialStore:Boolean;			protected var _tutorialConsumables:Boolean;			protected var _tutorialFullScreen:Boolean;			protected var _tutorialBuyChicken:Boolean;			protected var _currentTutorialStep:String;						public var onAdventureScoreUpdated:Signal;						/** Constructor			  *	---------------------------------------------------------------------- */				public function User()				{					init();				}							/** init			  *	---------------------------------------------------------------------- */				public function init():void				{					_id = 0;					_fbId = "0";					_fbProfilePicURL = "";					_firstName = "";					_lastName = "";					_lastLogin = new Date();					//_nonAppUserFriends = new Vector.<User>;										_attackSlots = 6;										_unlockedWeapons = new Vector.<Weapon>;					_unlockedGods = new Vector.<God>;					_unlockedEnemies = new Vector.<Enemy>;					_unlockedIslands = new Vector.<Island>;					//_unlockedCryptologies = new Vector.<Cryptology>;					_unlockedTreasures = new Vector.<Treasure>;					_unlockedDiggingMaps = new Vector.<DiggingMap>;					//_requestCryptologies = new Vector.<RequestCryptology>;					_gifts = new Vector.<Gift>;										onAdventureScoreUpdated = new Signal();										_canRequestGiftFrom = false;					_locale = "en_US";										_tutorialMap = false;					_tutorialGameLevel = false;					_tutorialWin = false;					_tutorialSlotMachine = false;					_tutorialJournal = false;					_tutorialDig = false;					_tutorialGift = false;					_tutorialLevelSetup = false;					_tutorialStore = false;					_tutorialConsumables = false;					_tutorialFullScreen = false;					_tutorialBuyChicken = false;				}							/** set/get id			  *	---------------------------------------------------------------------- */				public function set id( u:uint ):void { _id = u; }				public function get id():uint { return _id; }							/** set/get fbId			  *	---------------------------------------------------------------------- */				public function set fbId( n:String ):void { _fbId = n; }				public function get fbId():String { return _fbId; }							/** set/get fbProfilePicURL			  *	---------------------------------------------------------------------- */				public function set fbProfilePicURL( s:String ):void { _fbProfilePicURL = s; }				public function get fbProfilePicURL():String { return _fbProfilePicURL; }							/** set/get firstName			  *	---------------------------------------------------------------------- */				public function set firstName( s:String ):void { _firstName = s; }				public function get firstName():String { return _firstName; }							/** set/get lastName			  *	---------------------------------------------------------------------- */				public function set lastName( s:String ):void { _lastName = s; }				public function get lastName():String { return _lastName; }								public function get name():String { return _firstName+" "+_lastName; }								public function set currentIslandId( i:int ):void { _currentIslandId = i; }				public function get currentIslandId():int { return _currentIslandId; }								public function set currentVillageId( i:int ):void { _currentVillageId = i; }				public function get currentVillageId():int { return _currentVillageId; }								public function set attackSlots( i:int ):void { _attackSlots = i; }				public function get attackSlots():int { return _attackSlots; }							/** set/get lastLogin			  *	---------------------------------------------------------------------- */				public function set lastLogin( d:Date ):void { _lastLogin = d; }				public function get lastLogin():Date { return _lastLogin; }								public function set level( i:int ):void { _level = i; }				public function get level():int { return _level; }								public function set adventureLevel( i:int ):void { _adventureLevel = i; }				public function get adventureLevel():int { return _adventureLevel; }								public function set adventureScore( n:Number ):void { _adventureScore = n; onAdventureScoreUpdated.dispatch(); }				public function get adventureScore():Number { return _adventureScore; }								public function set prevAdventureScore( n:Number ):void { _prevAdventureScore = n; }				public function get prevAdventureScore():Number { return _prevAdventureScore; }								public function set nextAdventureScore( n:Number ):void { _nextAdventureScore = n; }				public function get nextAdventureScore():Number { return _nextAdventureScore; }								public function get unlockedWeapons():Vector.<Weapon> { return _unlockedWeapons; }				public function get unlockedGods():Vector.<God> { return _unlockedGods; }				public function get unlockedEnemies():Vector.<Enemy> { return _unlockedEnemies; }				public function get unlockedIslands():Vector.<Island> { return _unlockedIslands; }				//public function get unlockedCryptologies():Vector.<Cryptology> { return _unlockedCryptologies; }				public function get unlockedTreasures():Vector.<Treasure> { return _unlockedTreasures; }				public function get unlockedDiggingMaps():Vector.<DiggingMap> { return _unlockedDiggingMaps; }				public function get unlockedAttacksLength():int { return (_unlockedWeapons.length + _unlockedGods.length); }				public function get gifts():Vector.<Gift> { return _gifts; }				//public function get requestCryptologies():Vector.<RequestCryptology> { return _requestCryptologies;  }								public function set canRequestGiftFrom( b:Boolean ):void { _canRequestGiftFrom = b; }				public function get canRequestGiftFrom():Boolean { return _canRequestGiftFrom; }								public function set locale( s:String ):void { _locale = s; }				public function get locale():String { return _locale; }								public function set messagesCount( i:int ):void { _messagesCount = i; }				public function get messagesCount():int { return _messagesCount; }								public function set fbCreditsBalance( n:Number ):void { _fbCreditsBalance = n; }				public function get fbCreditsBalance():Number { return _fbCreditsBalance; }								public function set mysteryGift( b:Boolean ):void { _mysteryGift = b; }				public function get mysteryGift():Boolean { return _mysteryGift; }								//public function set nonAppUserFriends( a:Array ):void { _nonAppUserFriends = a; }				//public function get nonAppUserFriends():Vector.<User> { return _nonAppUserFriends; }								public function get commonTreasuresCount():int				{					var count:int = 0;										for( var i:int=0; i<_unlockedTreasures.length; ++i )					{						if( _unlockedTreasures[i].rarity == Treasure.RARITY_COMMON )							count += _unlockedTreasures[i].count;					}										return count;				}								public function get rareTreasuresCount():int				{					var count:int = 0;										for( var i:int=0; i<_unlockedTreasures.length; ++i )					{						if( _unlockedTreasures[i].rarity == Treasure.RARITY_RARE )							count += _unlockedTreasures[i].count;					}										return count;				}								public function get durableWeaponsCount():int				{					var count:int = 0;					for( var i:int=0; i<_unlockedWeapons.length; ++i )					{						if( !_unlockedWeapons[i].consumable && _unlockedWeapons[i].listed )							++count;					}										return count;				}								public function get consumableWeaponsCount():int				{					var count:int = 0;					for( var i:int=0; i<_unlockedWeapons.length; ++i )					{						if( _unlockedWeapons[i].consumable && _unlockedWeapons[i].listed )							++count;					}										return count;				}								public function get unlockedVillagesCount():int				{					var count:int = 0;					for( var i:int=0; i<_unlockedIslands.length; ++i )					{						count += _unlockedIslands[i].unlockedVillagesCount;					}										return count;				}								public function set tutorialMap( b:Boolean ):void { _tutorialMap = b; }				public function get tutorialMap():Boolean { return _tutorialMap; }								public function set tutorialGameLevel( b:Boolean ):void { _tutorialGameLevel = b; }				public function get tutorialGameLevel():Boolean { return _tutorialGameLevel; }								public function set tutorialGameLevelDelete( b:Boolean ):void { _tutorialGameLevelDelete = b; }				public function get tutorialGameLevelDelete():Boolean { return _tutorialGameLevelDelete; }								public function set tutorialWin( b:Boolean ):void { _tutorialWin = b; }				public function get tutorialWin():Boolean { return _tutorialWin; }								public function set tutorialSlotMachine( b:Boolean ):void { _tutorialSlotMachine = b; }				public function get tutorialSlotMachine():Boolean { return _tutorialSlotMachine; }								public function set tutorialJournal( b:Boolean ):void { _tutorialJournal = b; }				public function get tutorialJournal():Boolean { return _tutorialJournal; }								public function set tutorialDig( b:Boolean ):void { _tutorialDig = b; }				public function get tutorialDig():Boolean { return _tutorialDig; }								public function set tutorialGift( b:Boolean ):void { _tutorialGift = b; }				public function get tutorialGift():Boolean { return _tutorialGift; }								public function set tutorialLevelSetup( b:Boolean ):void { _tutorialLevelSetup = b; }				public function get tutorialLevelSetup():Boolean { return _tutorialLevelSetup; }								public function set tutorialStore( b:Boolean ):void { _tutorialStore = b; }				public function get tutorialStore():Boolean { return _tutorialStore; }								public function set tutorialConsumables( b:Boolean ):void { _tutorialConsumables = b; }				public function get tutorialConsumables():Boolean { return _tutorialConsumables; }								public function set tutorialFullScreen( b:Boolean ):void { _tutorialFullScreen = b; }				public function get tutorialFullScreen():Boolean { return _tutorialFullScreen; }								public function set tutorialBuyChicken( b:Boolean ):void { _tutorialBuyChicken = b; }				public function get tutorialBuyChicken():Boolean { return _tutorialBuyChicken; }								public function set currentTutorialStep( s:String ):void { _currentTutorialStep = s; }				public function get currentTutorialStep():String { return _currentTutorialStep; }							/** updateWeaponUseCount			  *	---------------------------------------------------------------------- */				public function updateWeaponUseCount( weapon:Weapon, useCount:int ):void				{					var weapon:Weapon = VectorUtil.find( _unlockedWeapons, weapon, "id" );					if( weapon != null )					{						weapon.useCount = useCount;					}				}							/** updateGodUseCount			  *	---------------------------------------------------------------------- */				public function updateGodUseCount( god:God, useCount:int ):void				{					var god:God = VectorUtil.find( _unlockedGods, god, "id" );					if( god != null )					{						god.useCount = useCount;					}				}							/** isItemUnlocked			  *	---------------------------------------------------------------------- */				public function isItemUnlocked( item:AbstractGameObject ):Boolean				{					if( item is Weapon )					{						//trace( "check if weapon is unlocked, "+_unlockedWeapons );						if( VectorUtil.find( _unlockedWeapons, item, "id" ) != null )							return true;					}					else if( item is God )					{						//trace( "check if god is unlocked, "+_unlockedGods );						if( VectorUtil.find( _unlockedGods, item, "id") != null )							return true;					}					else if( item is Enemy )					{						if( VectorUtil.find( _unlockedEnemies, item, "id") != null )							return true;					}					/*					else if( item is Cryptology )					{						if( VectorUtil.find( _unlockedCryptologies, item, "id") != null )							return true;					}					*/					else if( item is Treasure )					{						//trace( "finding treasure in user" );												if( VectorUtil.find( _unlockedTreasures, item, "id") != null )							return true;					}										return false;				}							/** saveDiggingMap			  *	---------------------------------------------------------------------- */				public function saveDiggingMap( diggingMap:DiggingMap ):void				{					if( VectorUtil.find(_unlockedDiggingMaps, diggingMap, "villageId") == null )					{						_unlockedDiggingMaps.push( diggingMap );					}				}				public function getDiggingMap( villageId:int ):DiggingMap				{					for( var i:int=0; i<_unlockedDiggingMaps.length; ++i )					{						if( _unlockedDiggingMaps[i].villageId == villageId )						{							return _unlockedDiggingMaps[i];						}					}										return null;				}							/** getUnlockedIsland			  *	---------------------------------------------------------------------- */				public function getUnlockedIsland( islandId:int ):Island				{					for( var i:int=0; i<_unlockedIslands.length; ++i )					{						if( _unlockedIslands[i].id == islandId )							return _unlockedIslands[i];					}										return null;				}				public function getUnlockedVillage( villageId:int ):Village				{					var i:int, j:int;					for( i=0; i<_unlockedIslands.length; ++i )					{						for( j=0; j<_unlockedIslands[i].villages.length; ++j )						{							if( _unlockedIslands[i].villages[j].id == villageId )								return _unlockedIslands[i].villages[j];						}					}										return null;				}				/*				public function getUnlockedCryptology( cryptologyId:int ):Cryptology				{					var i:int;					for( i=0; i<_unlockedCryptologies.length; ++i )					{						if( _unlockedCryptologies[i].id == cryptologyId )							return _unlockedCryptologies[i];					}										return null;				}								public function getRequestCryptology( cryptologyId:int ):Vector.<RequestCryptology>				{					var returnObjects:Vector.<RequestCryptology> = new Vector.<RequestCryptology>;					for( var i:int=0; i<_requestCryptologies.length; ++i )					{						if( _requestCryptologies[i].cryptologyId == cryptologyId )							returnObjects.push( _requestCryptologies[i] );					}										return returnObjects;				}				*/				public function getUnlockedWeapon( weaponId:int ):Weapon				{					for( var i:int=0; i<_unlockedWeapons.length; ++i )					{						if( _unlockedWeapons[i].id == weaponId )							return _unlockedWeapons[i];					}										return null;				}								public function getUnlockedGod( godId:int ):God				{					for( var i:int=0; i<_unlockedGods.length; ++i )					{						if( _unlockedGods[i].id == godId )							return _unlockedGods[i];					}										return null;				}								public function getUnlockedEnemy( enemyId:int ):Enemy				{					for( var i:int=0; i<_unlockedEnemies.length; ++i )					{						if( _unlockedEnemies[i].id == enemyId )							return _unlockedEnemies[i];					}					return null;				}								public function getUnlockedTreasure( treasureId:int ):Treasure				{					for( var i:int=0; i<_unlockedTreasures.length; ++i )					{						if( _unlockedTreasures[i].id == treasureId )							return _unlockedTreasures[i];					}					return null;				}							/** getItemForGift			  *	---------------------------------------------------------------------- */				public function getItemForGift( giftId:int ):AbstractGameObject				{					for( var i:int=0; i<_gifts.length; ++i )					{						if( _gifts[i].id == giftId )						{							if( _gifts[i].type == "Weapon" )							{								return GameLevelDataIndex.getInstance().getWeapon( _gifts[i].itemId );							}							else if( _gifts[i].type == "God" )							{								return GameLevelDataIndex.getInstance().getGod( _gifts[i].itemId );							}						}					}										return null;				}								public function updateItemStatistics():void				{					for( var i:int=0; i<_unlockedWeapons.length; ++i )					{						_unlockedWeapons[i].statistic = GameLevelDataIndex.getInstance().getWeapon( _unlockedWeapons[i].id ).statistic;					}										for( i=0; i<_unlockedEnemies.length; ++i )					{						_unlockedEnemies[i].statistic = GameLevelDataIndex.getInstance().getEnemy( _unlockedEnemies[i].id ).statistic;					}										for( i=0; i<_unlockedGods.length; ++i )					{						_unlockedGods[i].statistic = GameLevelDataIndex.getInstance().getGod( _unlockedGods[i].id ).statistic;					}									}										}			}