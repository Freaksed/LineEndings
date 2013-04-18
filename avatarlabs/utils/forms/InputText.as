﻿/**	InputText  *	--------------------------------------------------------- *  *	@desc:  *		an input text field class that will let users define  *		custom error message, custom textfield color  *	--------------------------------------------------------- *  *	@developer:	Christian Widodo [christian@avatarlabs.com]  *	--------------------------------------------------------- */    	package com.avatarlabs.utils.forms	{		import flash.display.MovieClip;		import flash.events.*;		import flash.text.TextField;				import com.avatarlabs.utils.console.ConsoleBroadcaster;				public class InputText extends MovieClip		{			protected var _defaultLabel:String;			protected var _errorLabel:String;						protected var _defaultColor:uint;			protected var _onBlurColor:uint;			protected var _errorColor:uint;						protected var _inputText:TextField;						protected var _focus:Boolean;			protected var _isInit:Boolean;						/**	Constructor			  *	---------------------------------------------------------- */				public function InputText()				{					init();				}								public function init():void				{					focusRect = false;				}								public function setTextField( t:TextField )				{					//ConsoleBroadcaster.broadcast( "InputText", "setTextField("+t+");" );										_inputText = t;										_defaultLabel = _inputText.text;					_errorLabel = _inputText.text;										_inputText.addEventListener( FocusEvent.FOCUS_IN, handleOnFocus );					_inputText.addEventListener( FocusEvent.FOCUS_OUT, handleOnBlur );					_inputText.addEventListener( Event.CHANGE, handleOnChange );										_defaultColor = _inputText.textColor;					_errorColor = _inputText.textColor;										dispatchEvent( new Event("onInit") );										_isInit = true;				}								public function get isInit():Boolean				{					return _isInit;				}							/**	setDefaultLabel			  *	---------------------------------------------------------- */				public function setDefaultLabel( l:String ):void				{					//ConsoleBroadcaster.broadcast( "InputText", "setDefaultLabel("+l+");" );										_defaultLabel = l;										_inputText.text = _defaultLabel;				}							/**	setErrorLabel			  *	---------------------------------------------------------- */				public function setErrorLabel( l:String ):void				{					//ConsoleBroadcaster.broadcast( "InputText", "setErrorLabel("+l+");" );										_errorLabel = l;				}							/**	setDefaultColor			  *	---------------------------------------------------------- */				public function setDefaultColor( c:uint ):void				{					//ConsoleBroadcaster.broadcast( "InputText", "setDefaultColor("+c+");" );										_defaultColor = c;				}							/**	setErrorColor			  *	---------------------------------------------------------- */				public function setErrorColor( c:uint ):void				{					//ConsoleBroadcaster.broadcast( "InputText", "setErrorColor("+c+");" );										_errorColor = c;				}							/**	setOnBlurColor			  *	---------------------------------------------------------- */				public function setOnBlurColor( c:uint ):void				{					//ConsoleBroadcaster.broadcast( "InputText", "setOnBlurColor("+c+");" );										_onBlurColor = c;				}							/**	handleOnFocus			  *	---------------------------------------------------------- */				public function handleOnFocus( event:FocusEvent ):void				{					//ConsoleBroadcaster.broadcast( "InputText", "handleOnFocus();" );										_focus = true;										_inputText.textColor = _defaultColor;										if ( _inputText.text == _defaultLabel || _inputText.text == _errorLabel )					{						_inputText.text = "";					}										dispatchEvent( event );				}							/**	handleOnBlur			  *	---------------------------------------------------------- */				public function handleOnBlur( event:FocusEvent ):void				{					//ConsoleBroadcaster.broadcast( "InputText", "handleOnBlur();" );										_focus = false;										if ( _inputText.text == "" )					{						_inputText.textColor = _errorColor;						_inputText.text = _errorLabel;					}					else					{						_inputText.textColor = _onBlurColor;					}										dispatchEvent( event );				}							/**	handleOnChange			  *	---------------------------------------------------------- */				public function handleOnChange( event:Event ):void				{					//ConsoleBroadcaster.broadcast( "InputText", "handleOnChange();" );										dispatchEvent( event );				}							/**	isValid			  *	returns false if text is the same as _defaultLabel or _errorLabel			  *	returns true otherwise			  *	---------------------------------------------------------- */				public function isValid():Boolean				{					//ConsoleBroadcaster.broadcast( "InputText", "isValid();" );										if ( _inputText.text == _defaultLabel || _inputText.text == _errorLabel )						return false;					else						return true;				}							/**	getValue			  *	returns the value in the textfield			  *	---------------------------------------------------------- */				public function getValue():String				{					//ConsoleBroadcaster.broadcast( "InputText", "getValue();" );										return _inputText.text;				}								public function setValue( _t:String ):void				{					//ConsoleBroadcaster.broadcast( "InputText", "setValue();" );										_inputText.text = _t;				}							/**	reset			  *	resets field to default label			  *	---------------------------------------------------------- */				public function reset():void				{					//ConsoleBroadcaster.broadcast( "InputText", "reset();" );										_inputText.textColor = _defaultColor;					_inputText.text = _defaultLabel;				}							/**	isFocus			  *	returns whether the text field is in focus or not			  *	---------------------------------------------------------- */				public function isFocus():Boolean				{					return _focus;				}							/**	showError			  *	shows error text			  *	---------------------------------------------------------- */				public function showError():void				{					_inputText.textColor = _errorColor;					_inputText.text = _errorLabel;				}		}	}