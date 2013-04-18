﻿/** UICheckBox *	---------------------------------------------------------------------------- * *	@dev:	Christian W [christian@avatarlabs.com] *	@desc:	Manages sections/parts of the instruction *	---------------------------------------------------------------------------- */ 	package com.avatarlabs.utils.userinterface	{		import flash.display.MovieClip;		import flash.events.*;		import flash.text.TextField;		import flash.text.TextFieldAutoSize;		import flash.text.TextFormat;				import com.avatarlabs.utils.console.ConsoleBroadcaster;		import com.avatarlabs.utils.events.CustomEvent;		import com.avatarlabs.utils.events.EventNotificationCenter;				public class UICheckBox extends MovieClip		{			protected var _dynamicClip:MovieClip;			protected var _markerClip:MovieClip;			protected var _checked:Boolean;						/** Constructor			  *	-------------------------------------------------------------- */				public function UICheckBox()				{					init();				}								public function init():void				{					_dynamicClip = this;										_checked = false;										_dynamicClip.buttonMode = true;					_dynamicClip.addEventListener( MouseEvent.CLICK, handleClicked, false, 0, true );					_dynamicClip.addEventListener( MouseEvent.ROLL_OVER, handleRolledOver, false, 0, true );					_dynamicClip.addEventListener( MouseEvent.ROLL_OUT, handleRolledOut, false, 0, true );				}								public function kill():void				{					_dynamicClip.removeEventListener( MouseEvent.CLICK, handleClicked );					_dynamicClip.removeEventListener( MouseEvent.ROLL_OVER, handleRolledOver );					_dynamicClip.removeEventListener( MouseEvent.ROLL_OUT, handleRolledOut );				}								public function set markerClip( mc:MovieClip ):void { _markerClip = mc; _markerClip.visible = _checked; }				public function get checked():Boolean { return _checked; }				public function set checked( b:Boolean )				{					_checked = b;										if( _checked )					{						_markerClip.visible = true;					}					else					{						_markerClip.visible = false;					}				}								protected function handleClicked( event:MouseEvent ):void				{					checked = !_checked;										dispatchEvent( new CustomEvent("onClick") );					dispatchEvent( new CustomEvent("onKillFocus") );				}								protected function handleRolledOver( event:MouseEvent ):void				{					dispatchEvent( new CustomEvent("onSetFocus") );				}								protected function handleRolledOut( event:MouseEvent ):void				{					dispatchEvent( new CustomEvent("onKillFocus") );				}								public function setActive():void				{					_dynamicClip.buttonMode = true;					!_dynamicClip.hasEventListener(MouseEvent.CLICK) ? _dynamicClip.addEventListener( MouseEvent.CLICK, handleClicked, false, 0, true ) : null;					!_dynamicClip.hasEventListener(MouseEvent.ROLL_OVER) ? _dynamicClip.addEventListener( MouseEvent.ROLL_OVER, handleRolledOver, false, 0, true ) : null;					!_dynamicClip.hasEventListener(MouseEvent.ROLL_OUT) ? _dynamicClip.addEventListener( MouseEvent.ROLL_OUT, handleRolledOut, false, 0, true ) : null;				}								public function setDeactive():void				{					_dynamicClip.buttonMode = false;					_dynamicClip.hasEventListener(MouseEvent.CLICK) ? _dynamicClip.removeEventListener( MouseEvent.CLICK, handleClicked ) : null;					_dynamicClip.hasEventListener(MouseEvent.ROLL_OVER) ? _dynamicClip.removeEventListener( MouseEvent.ROLL_OVER, handleRolledOver ) : null;					_dynamicClip.hasEventListener(MouseEvent.ROLL_OUT) ? _dynamicClip.removeEventListener( MouseEvent.ROLL_OUT, handleRolledOut ) : null;				}		}			}