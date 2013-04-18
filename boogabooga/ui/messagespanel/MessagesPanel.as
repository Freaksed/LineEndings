﻿/** MessagesPanel  *	---------------------------------------------------------------------------- *  *	@desc:  *		Messages panel for displaying and accepting/rejecting messages.  *	@authors:  *		Christian Widodo [christian@avatarlabs.com]  *		Brett Cook [brett@avatarlabs.com]  *	---------------------------------------------------------------------------- */ 	package com.boogabooga.ui.messagespanel	{		import flash.display.MovieClip;		import flash.events.Event;		import flash.events.EventDispatcher;		import flash.events.IOErrorEvent;		import flash.geom.Point;		import flash.geom.Rectangle;		import flash.text.TextFieldAutoSize;		import flash.utils.getDefinitionByName;		import flash.utils.getQualifiedClassName;				import com.greensock.TweenLite;		import com.avatarlabs.utils.cache.HashTable;		import com.avatarlabs.utils.console.ConsoleBroadcaster;		import com.avatarlabs.utils.events.CustomEvent;		import com.avatarlabs.utils.events.EventNotificationCenter;		import com.avatarlabs.utils.loader.CustomLoader;		import com.avatarlabs.utils.sound.SoundEffectPlayer;		import com.avatarlabs.utils.text.TextFormatting;		import com.avatarlabs.utils.userinterface.DynamicUIButton;		//import com.avatarlabs.utils.userinterface.UIButton;				//import com.boogabooga.controller.maingame.CryptologyDataController;		import com.boogabooga.controller.maingame.GiftDataController;		import com.boogabooga.controller.maingame.MessageDataController;		import com.boogabooga.controller.maingame.MainGameController;		import com.boogabooga.data.SettingsIndex;		import com.boogabooga.data.SoundsIndex;		import com.boogabooga.data.StringsIndex;		import com.boogabooga.data.gamelevel.AbstractGameObject;		//import com.boogabooga.data.maingame.Cryptology;		import com.boogabooga.data.gamelevel.GameLevelCurrentData;		import com.boogabooga.data.gamelevel.GameLevelDataIndex;		import com.boogabooga.data.gamelevel.Weapon;		import com.boogabooga.data.maingame.MainGameDataIndex;		import com.boogabooga.ui.messagespanel.MessagesPanelContentRow;				public class MessagesPanel extends EventDispatcher		{			protected var _contentClip:MovieClip;			protected var _debug:Boolean;						protected var _currentRowSelected:MessagesPanelContentRow;			//protected var _rowLightClass:Class;			//protected var _rowDarkClass:Class;			protected var _rowClass:Class;			//protected var _rowClips:Vector.<MessagesPanelContentRow>;						protected var _scrollerMessagesClip:MessagesPanelContentScroller;			protected var _exitClip:DynamicUIButton;						/**	Stage Instances **/			public var scrollerMessages_mc:MovieClip;			public var exit_mc:MovieClip;			public var background_mc:MovieClip;			public var noMessage_mc:MovieClip;			/**	End of Stage Instances **/									public static const MESSAGE_TYPE_GENERIC:int = 0;			public static const MESSAGE_TYPE_CRYPTOLOGY:int = 1;			public static const MESSAGE_TYPE_GIFT:int = 2;									/** Constructor			  *	---------------------------------------------------------------------------- */				public function MessagesPanel()				{					//init();					//start();				}								public function set contentClip( m:MovieClip ):void				{					_contentClip = m;										scrollerMessages_mc = _contentClip.scrollerMessages_mc;					exit_mc = _contentClip.exit_mc;					background_mc = _contentClip.background_mc;					noMessage_mc = _contentClip.noMessage_mc;					noMessage_mc.visible = false;										_scrollerMessagesClip = new MessagesPanelContentScroller();					_scrollerMessagesClip.dynamicClip = scrollerMessages_mc;					_scrollerMessagesClip.dynamicInit();										_exitClip = new DynamicUIButton();					_exitClip.dynamicClip = exit_mc;					_exitClip.dynamicInit();				}				public function get contentClip():MovieClip { return _contentClip; }							/** get currentItemSelected			  *	---------------------------------------------------------------------------- */				public function get currentItemSelected():AbstractGameObject { return _currentRowSelected.item; }								//public function get deleteSelected():Boolean { return _deleteSelected; }							/** init			  *	---------------------------------------------------------------------------- */				public function init():void				{					_debug = true;										//trace("init!\n");										_contentClip.mouseEnabled = false;					_contentClip.mouseChildren = true;										//_rowLightClass = getDefinitionByName("row_light") as Class;					//_rowDarkClass = getDefinitionByName("row_dark") as Class;					_rowClass = getDefinitionByName("MessagesPanel.contentrow") as Class;										_exitClip.addEventListener( "onClick", handleExitClicked, false, 0, true );					_exitClip.addEventListener( "onSetFocus", handleExitRolledOver, false, 0, true );										TextFormatting.formatTextWithFontName( noMessage_mc.label_txt, StringsIndex.getInstance().getStringByName("MESSAGES_NO_MESSAGES"), "Lithos Pro Black", false, TextFieldAutoSize.CENTER );				}							/** start			  *	---------------------------------------------------------------------------- *			  *	---------------------------------------------------------------------------- */				public function start():void				{					//scrollerMessages_mc.addEventListener( "onRowClick", handleRowClicked, false, 0, true );										//handleWeaponClicked(null);										//_deleteSelected = false;				}							/** kill			  *	---------------------------------------------------------------------------- *			  *	Kills the MessagesPanel, removes all event listeners, and remove content.			  *	---------------------------------------------------------------------------- */				public function kill():void				{					if( _debug ) ConsoleBroadcaster.broadcast( "MessagesPanel", "kill();" );										//_scrollerMessagesClip.removeEventListener( "onRowClick", handleRowClicked );					_scrollerMessagesClip.kill();										_currentRowSelected = null;					//_deleteSelected = false;				}							/** initMessages			  *	---------------------------------------------------------------------------- *			  *	Initializes the messages panel with messages, gift requests or any requests			  *	that a user has.			  *	---------------------------------------------------------------------------- */				public function initMessages( messages:Array=null, cryptologyRequests:Array=null, gifts:Array=null ):void				{					ConsoleBroadcaster.broadcast( "MessagesPanel", "initMessages("+(messages == null ? 0 : messages.length)+", "+(cryptologyRequests == null ? 0 : cryptologyRequests.length)+", "+(gifts == null ? 0 : gifts.length)+");" );										_scrollerMessagesClip.resetScroller();										var i:int;					var row:MessagesPanelContentRow;					var messageText:String;										if( (messages != null && messages.length > 0) || (gifts != null && gifts.length > 0) )					{						noMessage_mc.visible = false;						scrollerMessages_mc.visible = true;					}					else					{						noMessage_mc.visible = true;						scrollerMessages_mc.visible = false;					}										if( messages != null )					{						for( i=0; i<messages.length; ++i )						{							row = addMessage();							row.addEventListener( "onRowAccepted", handleMessageRowAccepted, false, 0, true);							row.messageId = messages[i]['id'];							row.messageType = MESSAGE_TYPE_GENERIC;							row.friendFbId = messages[i]['fb_id'];							row.friendId = messages[i]['from_user_id'];														//row.asset_url = obj['asset_url'];							if( messages[i]['fb_profile_pic_url'] && messages[i]['fb_profile_pic_url'] != '' )								row.setProfilePic( messages[i]['fb_profile_pic_url']);														//TextFormatting.formatTextWithFontName( row.date_txt, messages[i]['date_added'], "SF Fedora" );							//TextFormatting.formatTextWithFontName( row.message_txt, messages[i]['message'], "SF Fedora" );							//TextFormatting.formatTextWithFontName( row.description_txt, "", "SF Fedora" );							//TextFormatting.formatTextWithFontName( row.date_txt, messages[i]['date_added'], "Lithos Pro Black" );							TextFormatting.formatTextWithFontName( row.message_txt, messages[i]['message'], "Lithos Pro Black" );							TextFormatting.formatTextWithFontName( row.description_txt, "", "Lithos Pro Black" );														//row.date_txt.text = obj['date'];							//row.message_txt.text = obj['message'];							//row.description_txt.text = obj['info'];														row.adjustHeight();							_scrollerMessagesClip.addMenuRow( row );						}					}					/*					if( cryptologyRequests != null )					{						var cryptology:Cryptology;												for( i=0; i<cryptologyRequests.length; ++i )						{							cryptology = MainGameDataIndex.getInstance().getCryptology(cryptologyRequests[i]['cryptology_id']);														trace( "cryptology found" );							trace( "cryptology.id: "+cryptology.id );							trace( "cryptology.name: "+cryptology.name );														row = addMessage();							row.addEventListener( "onRowAccepted", handleMessageRowAccepted, false, 0, true );							row.messageId = cryptologyRequests[i]['id'];							row.messageType = MESSAGE_TYPE_CRYPTOLOGY;							row.friendFbId = cryptologyRequests[i]['fb_id'];							row.friendId = cryptologyRequests[i]['from_user_id'];							row.itemId = cryptologyRequests[i]['cryptology_id'];														if( cryptologyRequests[i]['fb_profile_pic_url'] && cryptologyRequests[i]['fb_profile_pic_url'] != '' )								row.setProfilePic( cryptologyRequests[i]['fb_profile_pic_url']);														row.setIcon( SettingsIndex.getInstance().contentURL+cryptology.iconURL );														//TextFormatting.formatTextWithFontName( row.date_txt, cryptologyRequests[i]['date_added'], "SF Fedora" );							//TextFormatting.formatTextWithFontName( row.description_txt, cryptology.name, "SF Fedora" );							TextFormatting.formatTextWithFontName( row.date_txt, cryptologyRequests[i]['date_added'], "Lithos Pro Black" );							TextFormatting.formatTextWithFontName( row.description_txt, cryptology.name, "Lithos Pro Black" );														messageText = "Please help me complete my "+cryptology.name+" cryptology symbol.";							if( MainGameController.getInstance().currentUser.getUnlockedCryptology(cryptology.id) == null )								messageText += " If you help me, you will complete the symbol too!";							else								messageText += " If you help me, you will get a free gift out of it!";														//TextFormatting.formatTextWithFontName( row.message_txt, messageText, "SF Fedora" );							TextFormatting.formatTextWithFontName( row.message_txt, messageText, "Lithos Pro Black" );													}					}					*/					if( gifts != null )					{						var gift:AbstractGameObject;						var descriptionText:String = '';												for( i=0; i<gifts.length; ++i )						{							if( gifts[i]['type'] == 'Weapon' )								gift = GameLevelDataIndex.getInstance().getWeapon(gifts[i]['item_id']);							else if( gifts[i]['type'] == 'God' )								gift = GameLevelDataIndex.getInstance().getGod(gifts[i]['item_id']);														row = addMessage();							row.addEventListener( "onRowAccepted", handleMessageRowAccepted, false, 0, true );							row.messageId = gifts[i]['id'];							row.messageType = MESSAGE_TYPE_GIFT;							row.friendFbId = gifts[i]['fb_id'];							row.friendId = gifts[i]['from_user_id'];							row.itemId = gifts[i]['item_id'];							row.gift = gifts[i];														if( gifts[i]['fb_profile_pic_url'] && gifts[i]['fb_profile_pic_url'] != '' )								row.setProfilePic( gifts[i]['fb_profile_pic_url']);														row.setIcon( gift.iconURL, gift.cacheIconId );														//TextFormatting.formatTextWithFontName( row.date_txt, gifts[i]['date_added'], "SF Fedora" );							//TextFormatting.formatTextWithFontName( row.message_txt, gifts[i]['first_name']+' '+gifts[i]['last_name']+' has sent you a gift!', "SF Fedora" );							//TextFormatting.formatTextWithFontName( row.description_txt, gift.name+'('+gifts[i]['count']+' use)', "SF Fedora" );							//TextFormatting.formatTextWithFontName( row.date_txt, gifts[i]['date_added'], "Lithos Pro Black" );							//TextFormatting.formatTextWithFontName( row.message_txt, gifts[i]['first_name']+' '+gifts[i]['last_name']+' has sent you a gift!', "Lithos Pro Black" );														if( gifts[i]['requested'] == '1' )							{								//TextFormatting.formatTextWithFontName( row.message_txt, "Please approve this gift!  I want to try out the "+gift.name+".  Approving this won't take anything away from you!", "Lithos Pro Black" );								//TextFormatting.formatTextWithFontName( row.message_txt, gifts[i]['first_name']+' '+gifts[i]['last_name']+' has requested a gift!', "Lithos Pro Black" );								TextFormatting.formatTextWithFontName( row.message_txt, StringsIndex.getInstance().getStringByName('MESSAGES_REQUEST_GIFT_HEADER'), 'Lithos Pro Black' );								descriptionText = StringsIndex.getInstance().getStringByName('MESSAGES_REQUEST_GIFT_DESCRIPTION');								descriptionText = descriptionText.replace(/(%%FIRST_NAME%%)/g, gifts[i]['first_name']).replace(/%%LAST_NAME%%/g, gifts[i]['last_name']);								descriptionText = descriptionText.replace(/%%WEAPON_NAME%%/, StringsIndex.getInstance().getString(String(gift.name)));							}							else							{								if( gifts[i]['returned_gift'] == '0' )								{									//TextFormatting.formatTextWithFontName( row.message_txt, 'Please accept my gift!  I sent you '+gifts[i]['count']+' uses of the '+gift.name+'.', "Lithos Pro Black" );									//TextFormatting.formatTextWithFontName( row.message_txt, gifts[i]['first_name']+' '+gifts[i]['last_name']+' has sent you a gift!', "Lithos Pro Black" );									TextFormatting.formatTextWithFontName( row.message_txt, StringsIndex.getInstance().getStringByName('MESSAGES_FREE_GIFT_HEADER'), 'Lithos Pro Black' );									descriptionText = StringsIndex.getInstance().getStringByName('MESSAGES_FREE_GIFT_DESCRIPTION');									descriptionText = descriptionText.replace(/(%%FIRST_NAME%%)/g, gifts[i]['first_name']).replace(/%%LAST_NAME%%/g, gifts[i]['last_name']);									descriptionText = descriptionText.replace('%%USE_NUMBER%%', gifts[i]['count']+' '+(gifts[i]['count'] > 1 ? StringsIndex.getInstance().getStringByName('USES') : StringsIndex.getInstance().getStringByName('USE')));									descriptionText = descriptionText.replace('%%WEAPON_NAME%%', StringsIndex.getInstance().getString(String(gift.name)));								}								else								{									//returned gift									//TextFormatting.formatTextWithFontName( row.message_txt, 'I returned the favor!  Please accept my gift.  I sent you '+gifts[i]['count']+' uses of the '+gift.name+'.', "Lithos Pro Black" );									//TextFormatting.formatTextWithFontName( row.message_txt, gifts[i]['first_name']+' '+gifts[i]['last_name']+' has sent you a gift back!', "Lithos Pro Black" );									TextFormatting.formatTextWithFontName( row.message_txt, StringsIndex.getInstance().getStringByName('MESSAGES_RETURN_GIFT_HEADER'), 'Lithos Pro Black' );									descriptionText = StringsIndex.getInstance().getStringByName('MESSAGES_RETURN_GIFT_DESCRIPTION');									descriptionText = descriptionText.replace(/%%FIRST_NAME%%/g, gifts[i]['first_name']).replace(/%%LAST_NAME%%/g, gifts[i]['last_name']);									descriptionText = descriptionText.replace('%%USE_NUMBER%%', gifts[i]['count']+' '+(gifts[i]['count'] > 1 ? StringsIndex.getInstance().getStringByName('USES') : StringsIndex.getInstance().getStringByName('USE')));									descriptionText = descriptionText.replace('%%WEAPON_NAME%%', StringsIndex.getInstance().getString(String(gift.name)));								}							}														row.description_txt.y = row.message_txt.y + Math.ceil(row.message_txt.height);							//TextFormatting.formatTextWithFontName( row.description_txt, StringsIndex.getInstance().getString(String(gift.name))+'('+gifts[i]['count']+' use)', "Lithos Pro Black" );							TextFormatting.formatTextWithFontName( row.description_txt, descriptionText, "Lithos Pro Black" );														row.adjustHeight();							_scrollerMessagesClip.addMenuRow( row );						}					}				}								public function addMessage():MessagesPanelContentRow				{					//trace( "addMessage();" );										var numRows:uint = _scrollerMessagesClip.getNumRows();					var row:MessagesPanelContentRow = new MessagesPanelContentRow();						row.contentClip = new _rowClass();						row.init();										//trace( "row: "+row );										if (numRows%2 == 0)						row.setLightBg();					else						row.setDarkBg();										//_scrollerMessagesClip.addMenuRow( row );					return row;				}							/** update			  *	---------------------------------------------------------------------------- *			  *	---------------------------------------------------------------------------- */				public function update():void				{					_scrollerMessagesClip.update();				}							/** reset			  *	---------------------------------------------------------------------------- *			  *	Resets the menu, button states.			  *	---------------------------------------------------------------------------- */				public function reset():void				{					if( _currentRowSelected != null )					{						_currentRowSelected = null;						//_scrollerMessagesClip.update();					}										_scrollerMessagesClip.reset();				}							/** handleMessageRowAccepted			  *	---------------------------------------------------------------------------- *			  *	---------------------------------------------------------------------------- */				protected function handleMessageRowAccepted( event:CustomEvent ):void				{					//trace("handleMessageRowAccepted");					//_currentRowSelected = event.customParameters.icon;					_currentRowSelected = event.currentTarget as MessagesPanelContentRow;										if( _currentRowSelected.messageType == MESSAGE_TYPE_GENERIC )					{						var addUnlockedMessage_mdc:MessageDataController = new MessageDataController();							addUnlockedMessage_mdc.addUnlockedMessage( MainGameController.getInstance().currentUser.id, _currentRowSelected.messageId );												//TextFormatting.formatTextWithFontName( _currentRowSelected.message_txt, "Message read!", "SF Fedora" );						TextFormatting.formatTextWithFontName( _currentRowSelected.message_txt, "Message read!", "Lithos Pro Black" );						_currentRowSelected.date_txt.text = '';						_currentRowSelected.description_txt.text = '';					}					/*					else if( _currentRowSelected.messageType == MESSAGE_TYPE_CRYPTOLOGY )					{						var acceptCryptologyRequest_cdc:CryptologyDataController = new CryptologyDataController();							acceptCryptologyRequest_cdc.acceptCryptologyRequest( _currentRowSelected.messageId );												var cryptology:Cryptology = MainGameController.getInstance().currentUser.getUnlockedCryptology(_currentRowSelected.itemId);												if( cryptology != null )						{							cryptology.canComplete = true;						}												//TextFormatting.formatTextWithFontName( _currentRowSelected.message_txt, "I helped out on symbols", "SF Fedora" );						TextFormatting.formatTextWithFontName( _currentRowSelected.message_txt, "I helped out on symbols", "Lithos Pro Black" );						_currentRowSelected.date_txt.text = '';						_currentRowSelected.description_txt.text = '';					}					*/					else if( _currentRowSelected.messageType == MESSAGE_TYPE_GIFT )					{						var acceptGift_gdc:GiftDataController = new GiftDataController();							acceptGift_gdc.acceptGift( _currentRowSelected.messageId );												var acceptedText:String = '';												if( _currentRowSelected.gift['requested'] == '1' )						{							acceptedText = StringsIndex.getInstance().getStringByName('MESSAGES_REQUEST_GIFT_ACCEPTED');						}						else						{							if( _currentRowSelected.gift['returned_gift'] == '0' )							{								acceptedText = StringsIndex.getInstance().getStringByName('MESSAGES_FREE_GIFT_ACCEPTED');								acceptedText = acceptedText.replace(/%%FIRST_NAME%%/g, _currentRowSelected.gift['first_name']);							}							else							{								acceptedText = StringsIndex.getInstance().getStringByName('MESSAGES_RETURN_GIFT_ACCEPTED');								acceptedText = acceptedText.replace(/%%FIRST_NAME%%/g, _currentRowSelected.gift['first_name']);								acceptedText = acceptedText.replace(/%%LAST_NAME%%/g, _currentRowSelected.gift['last_name']);							}						}												TextFormatting.formatTextWithFontName( _currentRowSelected.message_txt, acceptedText, 'Lithos Pro Black' );						//TextFormatting.formatTextWithFontName( _currentRowSelected.message_txt, 'Gift accepted', "SF Fedora" );						//TextFormatting.formatTextWithFontName( _currentRowSelected.message_txt, 'Gift accepted', "Lithos Pro Black" );						_currentRowSelected.date_txt.text = '';						_currentRowSelected.description_txt.text = '';					}										--MainGameController.getInstance().currentUser.messagesCount;										_scrollerMessagesClip.update();										//trace( getQualifiedClassName(_currentRowSelected.item) );										//dispatchEvent( new CustomEvent("onRowSelected") );				}							/** handleDeleteClicked			  *	---------------------------------------------------------------------------- *			  *	---------------------------------------------------------------------------- 				protected function handleDeleteClicked( event:Event ):void				{					//_deleteSelected = true;					dispatchEvent( new CustomEvent("onDeleteSelected") );				}*/			/** handleExitClicked			  *	---------------------------------------------------------------------------- *			  *	---------------------------------------------------------------------------- */				protected function handleExitClicked( event:Event ):void				{					//trace("unload");					//SoundEffectPlayer.getInstance().setVolume( SoundsIndex.getInstance().getSoundBySoundId("sfx_mouse_click.wav").volume, 0, "sfx_mouse_click.wav" );					SoundEffectPlayer.getInstance().playLibrarySound( "sfx_mouse_click.wav", false, "sfx_mouse_click.wav", "sfx_mouse_click.wav" );										dispatchEvent( new CustomEvent("onExitClicked") );				}								protected function handleExitRolledOver( event:Event ):void				{					//SoundEffectPlayer.getInstance().setVolume( SoundsIndex.getInstance().getSoundBySoundId("sfx_mouse_rollover.wav").volume, 0, "sfx_mouse_rollover.wav" );					SoundEffectPlayer.getInstance().playLibrarySound( "sfx_mouse_rollover.wav", false, "sfx_mouse_rollover.wav", "sfx_mouse_rollover.wav" );									}		}			}