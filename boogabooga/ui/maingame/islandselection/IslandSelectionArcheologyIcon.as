﻿/** IslandSelectionArcheologyIcon  *	---------------------------------------------------------------------------- *  *	@author:  *		Christian Widodo [christian@avatarlabs.com]  *	---------------------------------------------------------------------------- */ 	package com.boogabooga.ui.maingame.islandselection	{		import flash.display.MovieClip;		import flash.events.Event;		import flash.events.EventDispatcher;		import flash.text.TextField;				import com.avatarlabs.utils.events.CustomEvent;				import com.boogabooga.ui.maingame.IContentView;		import com.avatarlabs.utils.userinterface.UIButton;				public class IslandSelectionArcheologyIcon extends IslandSelectionIcon		{						/**	Stage Instances **/			/**	End of Stage Instances **/						/** Constructor			  *	---------------------------------------------------------------------------- */				public function IslandSelectionArcheologyIcon()				{					super();				}							/** dynamicInit			  *	---------------------------------------------------------------------------- */				override public function dynamicInit():void				{					super.dynamicInit();				}							/** kill			  *	---------------------------------------------------------------------------- */				override public function kill():void				{					super.kill();				}							/** handleClicked			  *	---------------------------------------------------------------------------- 				override protected function handleClicked( event:Event ):void				{					dispatchEvent( new CustomEvent("onIconClick", {village:_village}) );				}*/						}	}