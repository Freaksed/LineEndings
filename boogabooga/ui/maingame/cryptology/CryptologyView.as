﻿/** CryptologyView  *	---------------------------------------------------------------------------- *  *	@author:  *		Christian Widodo [christian@avatarlabs.com]  *	---------------------------------------------------------------------------- */ 	package com.boogabooga.ui.maingame.cryptology	{		import flash.display.MovieClip;		import flash.events.Event;				import com.avatarlabs.utils.VectorUtil;		import com.avatarlabs.utils.console.ConsoleBroadcaster;		import com.avatarlabs.utils.events.CustomEvent;		import com.avatarlabs.utils.navigation.UINavigation;		import com.avatarlabs.utils.navigation.UINavigationButton;		//import com.facebook.graph.Facebook;				import com.boogabooga.controller.maingame.CryptologyDataController;		import com.boogabooga.controller.maingame.MainGameController;		import com.boogabooga.data.maingame.*;		import com.boogabooga.events.BoogaEvent;		import com.boogabooga.ui.maingame.AbstractContentView;		import com.boogabooga.ui.maingame.IContentView;		import com.boogabooga.ui.maingame.LoadingAssetView;		import com.boogabooga.ui.maingame.islandselection.IslandSelectionIcon;		import com.boogabooga.ui.maingame.islandselection.IslandSelectionView;				public class CryptologyView extends AbstractContentView implements IContentView		{			protected var _loadingAssetViewClip:LoadingAssetView;			protected var _islandSelectionViewClip:IslandSelectionView;			protected var _currentVillage:Village;						protected var _loadingData:Boolean;						/**	Stage Instances **/			public var incompletePopup_mc:CryptologyIncompletePopupView;			public var askFriendPopup_mc:CryptologyAskFriendPopupView;			public var completeAnimationPopup_mc:CryptologyCompleteAnimationPopupView;			/**	End of Stage Instances **/						/** Constructor			  *	---------------------------------------------------------------------------- */				public function CryptologyView()				{									}								public function set islandSelectionViewClip( clip:IslandSelectionView ):void				{					_islandSelectionViewClip = clip;					_islandSelectionViewClip.addEventListener( BoogaEvent.ISLAND_SELECTION_CRYPTOLOGY_ICON_ROLLED_OVER, handleIconRolledOver );					_islandSelectionViewClip.addEventListener( BoogaEvent.ISLAND_SELECTION_CRYPTOLOGY_ICON_CLICK, handleIconClicked );				}				public function set loadingAssetViewClip( clip:LoadingAssetView ):void { _loadingAssetViewClip = clip; }								override public function init():void				{					super.init();										_loadingData = false;										incompletePopup_mc.visible = false;					incompletePopup_mc.addEventListener( BoogaEvent.ON_CRYPTOLOGY_ASK_FRIENDS, handleAskFriends );					incompletePopup_mc.addEventListener( BoogaEvent.ON_POPUP_HIDE, handlePopupHid );										askFriendPopup_mc.visible = false;										completeAnimationPopup_mc.visible = false;					completeAnimationPopup_mc.addEventListener( BoogaEvent.ON_CRYPTOLOGY_COMPLETE_ANIMATION_POPUP_CLOSE, handleCompleteAnimationPopupClosed );					completeAnimationPopup_mc.addEventListener( BoogaEvent.ON_POPUP_HIDE, handlePopupHid );				}							/** show			  *	---------------------------------------------------------------------------- */				override public function show():void				{					super.show();										//_islandSelectionViewClip.showCryptologyView();										_loadingAssetViewClip.showLoadingProgress();										var getLatestCryptology_cdc:CryptologyDataController = new CryptologyDataController();						getLatestCryptology_cdc.addEventListener( "onComplete", handleGetLatestCryptologyComplete );						getLatestCryptology_cdc.addEventListener( "onError", handleGetLatestCryptologyError );						getLatestCryptology_cdc.getLatestCryptology( MainGameController.getInstance().currentUser.id );				}							/** hide			  *	---------------------------------------------------------------------------- */				override public function hide():void				{					super.hide();				}								protected function handleGetLatestCryptologyComplete( event:CustomEvent ):void				{					event.currentTarget.removeEventListener( "onComplete", handleGetLatestCryptologyComplete );					event.currentTarget.removeEventListener( "onError", handleGetLatestCryptologyError );					/*					VectorUtil.removeAll( MainGameController.getInstance().currentUser.unlockedCryptologies );					//VectorUtil.removeAll( MainGameController.getInstance().currentUser.requestCryptologies );										var i:int;					var unlockedCryptologies:Array = event.customParameters.unlockedCryptologies;					var cryptology:Cryptology;					if( unlockedCryptologies != null )					{						for( i=0; i<unlockedCryptologies.length; ++i )						{							if( MainGameDataIndex.getInstance().getCryptology( unlockedCryptologies[i].cryptology_id ) != null )							{								cryptology = MainGameDataIndex.getInstance().getCryptology( unlockedCryptologies[i].cryptology_id ).clone();								cryptology.fullToken = unlockedCryptologies[i].full_token == "1";								cryptology.canComplete = unlockedCryptologies[i].can_complete == "1";								cryptology.friendId = unlockedCryptologies[i].friend_id;								cryptology.friendFirstName = unlockedCryptologies[i].friend_first_name;								cryptology.friendLastName = unlockedCryptologies[i].friend_last_name;								cryptology.friendFbProfilePicURL = unlockedCryptologies[i].friend_fb_profile_pic_url;								//trace( "id: "+cryptology.id );								//trace( "cryptology.fullToken: "+cryptology.fullToken );								//trace( "unlockedCryptology.full_token: "+unlockedCryptologies[i].full_token );								MainGameController.getInstance().currentUser.unlockedCryptologies.push( cryptology );								cryptology = null;							}						}					}					*/					/*					var requestCryptologies:Array = event.customParameters.requestCryptologies;					var requestCryptology:RequestCryptology;					if( requestCryptologies != null )					{						for( i=0; i<requestCryptologies.length; ++i )						{							requestCryptology = new RequestCryptology();							requestCryptology.id = requestCryptologies[i].id;							requestCryptology.cryptologyId = requestCryptologies[i].cryptology_id;							requestCryptology.fbRequestId = requestCryptologies[i].fb_request_id;							requestCryptology.valid = requestCryptologies[i].valid == "1";							requestCryptology.completed = requestCryptologies[i].completed == "1";							requestCryptology.accepted = requestCryptologies[i].accepted == "1";														if( requestCryptologies[i].from_user_id == MainGameController.getInstance().currentUser.id )							{								trace( "a RequestCryptology from currentUser to user "+requestCryptologies[i].to_user_id );								requestCryptology.fromUser = MainGameController.getInstance().currentUser;								requestCryptology.toUser = new User();								requestCryptology.toUser.id = requestCryptologies[i].to_user_id;								requestCryptology.toUser.fbId = requestCryptologies[i].fb_id;								requestCryptology.toUser.firstName = requestCryptologies[i].first_name;								requestCryptology.toUser.lastName = requestCryptologies[i].last_name;								requestCryptology.toUser.fbProfilePicURL = requestCryptologies[i].fb_profile_pic_url;							}							else							{								trace( "a RequestCryptology from user "+requestCryptologies[i].from_user_id+" to currentUser" );								requestCryptology.toUser = MainGameController.getInstance().currentUser;								requestCryptology.fromUser = new User();								requestCryptology.fromUser.id = requestCryptologies[i].from_user_id;								requestCryptology.fromUser.fbId = requestCryptologies[i].fb_id;								requestCryptology.fromUser.firstName = requestCryptologies[i].first_name;								requestCryptology.fromUser.lastName = requestCryptologies[i].last_name;								requestCryptology.fromUser.fbProfilePicURL = requestCryptologies[i].fb_profile_pic_url;							}														requestCryptology.valid = requestCryptologies[i].valid == "1";							MainGameController.getInstance().currentUser.requestCryptologies.push( requestCryptology );						}					}					*/					_loadingAssetViewClip.hideLoadingProgress();					//_islandSelectionViewClip.showCryptologyView();				}								protected function handleGetLatestCryptologyError( event:CustomEvent ):void				{					event.currentTarget.removeEventListener( "onComplete", handleGetLatestCryptologyComplete );					event.currentTarget.removeEventListener( "onError", handleGetLatestCryptologyError );				}								protected function handleIconRolledOver( event:BoogaEvent ):void				{									}								protected function handleIconClicked( event:BoogaEvent ):void				{					_currentVillage = event.customParameters.village;					/*					if( event.customParameters.cryptologyIconType == IslandSelectionIcon.ICON_TYPE_AVAILABLE )					{						//show incomplete popup view						//incompletePopup_mc.setFBUser( MainGameController.getInstance().currentUser.firstName, MainGameController.getInstance().currentUser.fbProfilePicURL );						incompletePopup_mc.setFBUser( MainGameController.getInstance().currentUser );						incompletePopup_mc.setCryptology( MainGameController.getInstance().currentUser.getUnlockedCryptology(_currentVillage.cryptologyId) );						incompletePopup_mc.show();					}					else if( event.customParameters.cryptologyIconType == IslandSelectionIcon.ICON_TYPE_ACTION )					{						//show the combining action						var friend:User = new User();							friend.id = cryptology.friendId;							friend.firstName = cryptology.friendFirstName;							friend.lastName = cryptology.friendLastName;							friend.fbProfilePicURL = cryptology.friendFbProfilePicURL;												var cryptology:Cryptology = MainGameController.getInstance().currentUser.getUnlockedCryptology(_currentVillage.cryptologyId);						completeAnimationPopup_mc.setFBUser( MainGameController.getInstance().currentUser );						completeAnimationPopup_mc.setFriendFBUser( friend );												//trace( MainGameController.getInstance().currentUser.getRequestCryptology(_currentVillage.cryptologyId) );												//if( MainGameController.getInstance().currentUser.getRequestCryptology(_currentVillage.cryptologyId).length > 0 )							//completeAnimationPopup_mc.setFriendFBUser( MainGameController.getInstance().currentUser.getRequestCryptology(_currentVillage.cryptologyId)[0].toUser );												completeAnimationPopup_mc.setCryptology( cryptology );												completeAnimationPopup_mc.show();					}					*/				}								protected function handleAskFriends( event:BoogaEvent ):void				{					//incompletePopup_mc.hide();										var getFriendsWhoPlayGame_cdc:CryptologyDataController = new CryptologyDataController();						getFriendsWhoPlayGame_cdc.addEventListener( "onComplete", handleGetFriendsWhoPlayGameComplete );						getFriendsWhoPlayGame_cdc.addEventListener( "onError", handleGetFriendsWhoPlayGameError );						getFriendsWhoPlayGame_cdc.getFriendsWhoPlayGame( MainGameController.getInstance().currentUser.fbId );										//askFriendPopup_mc.show();				}								protected function handleGetFriendsWhoPlayGameComplete( event:CustomEvent ):void				{					event.currentTarget.removeEventListener( "onComplete", handleGetFriendsWhoPlayGameComplete );					event.currentTarget.removeEventListener( "onError", handleGetFriendsWhoPlayGameError );					/*					if( event.customParameters.friends == 0 )					{						ConsoleBroadcaster.broadcast( "no friend with cryptology, invite your friends" );												askFriendPopup_mc.show();					}					else					{						//MainGameController.getInstance().facebookFunctions.askFriendsForCryptology( MainGameController.getInstance().currentUser.getUnlockedCryptology(_currentVillage.cryptologyId) );						MainGameController.getInstance().addEventListener( "onComplete", handleAskFriendsForCryptologyComplete );						MainGameController.getInstance().addEventListener( "onError", handleAskFriendsForCryptologyError );						MainGameController.getInstance().askFriendsForCryptology( MainGameController.getInstance().currentUser.getUnlockedCryptology(_currentVillage.cryptologyId) );					}					*/				}								protected function handleGetFriendsWhoPlayGameError( event:CustomEvent ):void				{					event.currentTarget.removeEventListener( "onComplete", handleGetFriendsWhoPlayGameComplete );					event.currentTarget.removeEventListener( "onError", handleGetFriendsWhoPlayGameError );										//TODO:					//	Do something when there is an error here..				}								protected function handleAskFriendsForCryptologyComplete( event:CustomEvent ):void				{					ConsoleBroadcaster.broadcast( "CryptologyView", "handleAskFriendsForCryptologyComplete();" );					MainGameController.getInstance().removeEventListener( "onComplete", handleAskFriendsForCryptologyComplete );					MainGameController.getInstance().removeEventListener( "onError", handleAskFriendsForCryptologyError );										dispatchEvent( new CustomEvent("onComplete") );				}								protected function handleAskFriendsForCryptologyError( event:CustomEvent ):void				{					ConsoleBroadcaster.broadcast( "CryptologyView", "handleAskFriendsForCryptologyError();" );										MainGameController.getInstance().removeEventListener( "onComplete", handleAskFriendsForCryptologyComplete );					MainGameController.getInstance().removeEventListener( "onError", handleAskFriendsForCryptologyError );				}								protected function handleCompleteAnimationPopupClosed( event:BoogaEvent ):void				{					//_islandSelectionViewClip.showCryptologyView();				}								protected function handlePopupHid( event:BoogaEvent ):void				{					//dispatchEvent( new BoogaEvent(BoogaEvent.ON_POPUP_HIDE) );					_islandSelectionViewClip.showMagnifyingGlassMouseCursor();				}		}	}