﻿/**	Form  *	--------------------------------------------------------- *  *	@desc:  *		holds form elements and gathers data from elements  *		  *	--------------------------------------------------------- *  *	@developer:	James Safechuck [james@avatarlabs.com]  *	--------------------------------------------------------- */	package com.avatarlabs.utils.forms	{		import flash.display.MovieClip;		import flash.events.*;				import com.avatarlabs.utils.console.ConsoleBroadcaster;				public class CustomForm extends MovieClip		{			private var formElements:Array;								/**	Constructor		  *	----------------------------------------------------- */			public function CustomForm():void			{				formElements = new Array();			}					/**	Constructor		  *	----------------------------------------------------- */		  	public function addFormElement( e ):void			{				ConsoleBroadcaster.broadcast( "CustomForm", "addFormElement("+e+");" );								formElements.push( e );			}					/**	checkValid		  *	----------------------------------------------------- */		  	public function checkValid():Boolean			{				ConsoleBroadcaster.broadcast( "CustomForm", "checkValid()" );								var i:int = 0;								while( i < formElements.length )				{					if( formElements[i].isValid() )					{						i++;					}					else					{						return false;					}				}								return true;			}					/**	submitData		  *	----------------------------------------------------- */		  	public function submitData():void			{				ConsoleBroadcaster.broadcast( "CustomForm", "submitData()" );								if( checkValid() )				{					// send the data										trace( "inputs are valid" );				}				else				{					// do something					trace( "inputs are invalid" );				}			}						/**	reset		  *	resets field to default label		  *	---------------------------------------------------------- */			public function resetFields():void			{				ConsoleBroadcaster.broadcast( "CustomForm", "resetFields();" );								for ( var i=0; i<formElements.length; i++ )				{					formElements[i].reset();				}			}		}	}