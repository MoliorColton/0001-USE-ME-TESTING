/*

    Script:			This script is used to call up a Progress GUI.  It will be placed in the OnUsed event of
					a placeable object typically.
	Version:		1.6
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		12/20/2010 - 1.00 MV - Initial Release
					06/22/2011 - 1.01 MV - Added support so multiple players can't activate.  Also included support to allow
										   follow up script to de-activate the active flag.
					07/07/2011 - 1.02 MV - Added support for an item to be equipped in weapon slot to activate progbar.	
					09/13/2012 - 1.2 MV - Added support for a progbar with a Cancel button.
					09/18/2012 - 1.3 MV - Added support for progress bar failed skill check script
					11/14/2012 - 1.4 MV - Added support for visual effects and custom animations
					05/24/2014 - 1.5 MV - Really?  I forgot to actually script the part about removing items since v1.90?  Wow.  Dumbass.  Wrote Code.  Added SE Flag
					05/24/2014 - 1.6 MV - Fixed bug where SE was calling wrong script.
*/

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_info_include"


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// PRIVATE FUNCTION DECLARATIONS
// /////////////////////////////////////////////////////////////////////////////////////////////////////


// ///////////////////////////////////////////////////////////////////////////
// Private function required to support a Delay Command that will perform
// a skill check and if successful perform the follow up script or notify.
// int iSkillCheck				- The Skill to check.
// object oPC					- Player we are interacting with
// string sFollowScript			- Name of the script we're going to fire.
//	Returns: N/A
void LEG_INFO_PROGBAR_SkillCheck(int iSkillCheck, object oPC, string sFollowScript, string sFailScript);


// ///////////////////////////////////////////////////////////////////////////
// Private function required to support a Delay Command that will perform
// a flag set if active and configured.
// int iSetSEFlag				- The Flag to set
//	Returns: N/A
void LEG_INFO_PROGBAR_SEFlags(int iSetSEFlag);


// ///////////////////////////////////////////////////////////////////////////
// Private function required to support a Delay Command that will remove
// an inventory item.  Because COMMON returns a string, it won't work
// in Delay Command so we have to do this.
// object oPC					- Player we are interacting with
// string sItem					- Tag of Item to remove
// int iQty						- The quantity to remove.
//	Returns: N/A
void LEG_INFO_PROGBAR_DestroyItems(object oPC, string sItem, int iQty);

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// PRIVATE FUNCTIONS
// /////////////////////////////////////////////////////////////////////////////////////////////////////



// //////////////////////////////////////////////////
// LEG_INFO_PROGBAR_DestroyItems
// //////////////////////////////////////////////////
void LEG_INFO_PROGBAR_DestroyItems(object oPC, string sItem, int iQty)
{
	LEG_COMMON_DestroyItems(oPC, sItem, iQty);
}


// //////////////////////////////////////////////////
// LEG_INFO_PROGBAR_SEFlags
// //////////////////////////////////////////////////
void LEG_INFO_PROGBAR_SEFlags(int iSetSEFlag)
{
	if (GetLocalInt(GetModule(), "LEG_QUEST_ACTIVE"))
	{
		AddScriptParameterInt(iSetSEFlag);
		ExecuteScriptEnhanced("leg_quest_se_setflag", OBJECT_SELF);
	}
}

// //////////////////////////////////////////////////
// LEG_INFO_PROGBAR_SkillCheck
// //////////////////////////////////////////////////
void LEG_INFO_PROGBAR_SkillCheck(int iSkillCheck, object oPC, string sFollowScript, string sFailScript)
{
	// If there is, get the remaining information we'll need.
	int iSkillDC = GetLocalInt(OBJECT_SELF, "LEG_INFO_ProgBarSkillDC");
	string sSkillFailMsg = GetLocalString(OBJECT_SELF, "LEG_INFO_ProgBarFailMsg");
	string sInfoText = GetLocalString(OBJECT_SELF, "LEG_INFO_Text");
	int iShowSkill = GetLocalInt(OBJECT_SELF, "LEG_INFO_ProgBarSkillShow");
	int iRemoveItem = GetLocalInt(OBJECT_SELF, "LEG_INFO_RemoveItem");
	string sInvItem = GetLocalString(OBJECT_SELF, "LEG_INFO_ProgBarInvItem");
	string sItemCheck = GetLocalString(OBJECT_SELF, "LEG_INFO_ProgBarItem");
	string sGiveItem = GetLocalString(OBJECT_SELF, "LEG_INFO_ProgBarGiveItem");
	int iSetSEFlag = GetLocalInt(OBJECT_SELF, "LEG_INFO_SetSEFlag");
	int iTimerDuration = GetLocalInt(OBJECT_SELF, "LEG_INFO_TimerBarDuration");

	// Roll to see if we are successful or not.
	if (GetIsSkillSuccessful(oPC, iSkillCheck, iSkillDC, iShowSkill))
	{
		if (sFollowScript != "")
		{
			DelayCommand(0.5, LEG_COMMON_ExecuteScript(sFollowScript, OBJECT_SELF, oPC));
			if (sInfoText != "")
				ExecuteScript("leg_info_trigger", OBJECT_SELF);
		}	
		else if (sInfoText != "")
			ExecuteScript("leg_info_trigger", OBJECT_SELF);
	
		if (iTimerDuration > 0)
		{
			ExecuteScript("leg_info_timerbar", OBJECT_SELF);
		}

				
		// Set area flags once the progress bar is complete.
		LEG_INFO_PROGBAR_SEFlags(iSetSEFlag);
					
				
		if (iRemoveItem)
		{
			if (sInvItem != "" || sItemCheck != "")
			{
				LEG_INFO_PROGBAR_DestroyItems(oPC, sItemCheck, 1);
				LEG_INFO_PROGBAR_DestroyItems(oPC, sInvItem, 1);
			}
		}
		
		// If we're supposed to give an item
		if (sGiveItem != "")
		{
			LEG_COMMON_CreateItem(oPC, sGiveItem, 1);	
		}
		
		
					
	}
	else
	{
		// If we failed, then delay the amount of time the progress bar
		// will be displayed and then fire the failure message.
		// Well, we better de-activate it.
		SetLocalInt(OBJECT_SELF, "LEG_INFO_IsActive", 0);
		DelayCommand(0.5, LEG_COMMON_DisplayInfoBox(oPC, sSkillFailMsg));
		if (sFailScript != "")
		{
			DelayCommand(0.5, ExecuteScript(sFailScript, OBJECT_SELF));
		}	
	}
}




// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	// If this was called by the Craft Plugin for Skinning, we need to pull the PC out.
	object oPC = GetLocalObject(OBJECT_SELF, "CRAFT_User");
	if (!GetIsObjectValid(oPC))
	{
		// Try and get the PC that used this
		oPC = GetLastUsedBy();	
	
		// Or Entered this
		if (!GetIsObjectValid(oPC))
			oPC = GetEnteringObject();
	}
	
	if (GetIsPC(oPC))
	{
		// Get the plugin Active and the PC valid
		if (GetLocalInt(GetModule(), "LEG_INFO_ACTIVE") && GetIsObjectValid(oPC))
		{
			// See if this Info Prog Bar is already in use or active.
			if (GetLocalInt(OBJECT_SELF, "LEG_INFO_IsActive"))
				LEG_COMMON_DisplayInfoBox(oPC, "Please Wait");
			else
			{
				// Well, we better activate it.
				SetLocalInt(OBJECT_SELF, "LEG_INFO_IsActive", 1);
			
				// Get the options for the Progress Bar
				string sTitle = GetLocalString(OBJECT_SELF, "LEG_INFO_ProgBarTitle");
				string sFollowScript = GetLocalString(OBJECT_SELF, "LEG_INFO_ProgBarCallScript");
				string sFailScript = GetLocalString(OBJECT_SELF, "LEG_INFO_ProgBarFailScript");
				string sInfoText = GetLocalString(OBJECT_SELF, "LEG_INFO_Text");
				int iDuration = GetLocalInt(OBJECT_SELF, "LEG_INFO_ProgBarDuration");
				int iTimerDuration = GetLocalInt(OBJECT_SELF, "LEG_INFO_TimerBarDuration");
				int iCommandable = GetLocalInt(OBJECT_SELF, "LEG_INFO_ProgBarCommandable");
				int iUseObjectName = GetLocalInt(OBJECT_SELF, "LEG_INFO_ProgBarUseName");
				int iSkillCheck = GetLocalInt(OBJECT_SELF, "LEG_INFO_ProgBarSkillCheck");
				int iCanCancel = GetLocalInt(OBJECT_SELF, "LEG_INFO_CanCancel");
				string sItemCheck = GetLocalString(OBJECT_SELF, "LEG_INFO_ProgBarItem");
				object oWeaponOnPlayer = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
				string sAnimation = GetLocalString(OBJECT_SELF, "LEG_INFO_ProgBarAnimation");
				int iVisual = GetLocalInt(OBJECT_SELF, "LEG_INFO_ProgBarVisual");
				int iVisualOnPC = GetLocalInt(OBJECT_SELF, "LEG_INFO_ProgBarVisualOnPC");
				int iSetSEFlag = GetLocalInt(OBJECT_SELF, "LEG_INFO_SetSEFlag");
				int iRemoveItem = GetLocalInt(OBJECT_SELF, "LEG_INFO_RemoveItem");
				string sInvItem = GetLocalString(OBJECT_SELF, "LEG_INFO_ProgBarInvItem");
				string sGiveItem = GetLocalString(OBJECT_SELF, "LEG_INFO_ProgBarGiveItem");
							
				object oTarget = OBJECT_SELF;
				if (iVisualOnPC)
					oTarget = oPC;
					
				if (sAnimation == "")
					sAnimation = "kneeltalk";
					
				// If this Progbar requires and item equipped, then check for it.
				if (sItemCheck != "")
				{
				    if (GetTag(oWeaponOnPlayer) != sItemCheck)
				    {
						// Nope, you don't have the proper item equipped.
						LEG_COMMON_DisplayInfoBox(oPC, "YOU MUST EQUIP THE PROPER ITEM FIRST");	
						SetLocalInt(OBJECT_SELF, "LEG_INFO_IsActive", 0);
						return;
					}
				}
				
				// If this Progbar requires an item in inventory, then check for it.
				if (sInvItem != "")
				{
					if (LEG_COMMON_GetInventoryItemByTag(oPC, sInvItem) == OBJECT_INVALID)
					{
						// Nope, you don't have the proper item.
						LEG_COMMON_DisplayInfoBox(oPC, "YOU MUST HAVE THE PROPER ITEM FIRST");	
						SetLocalInt(OBJECT_SELF, "LEG_INFO_IsActive", 0);
						return;
					}									
				}			
				
				// If the crafting plugin is enabled, then check for crafting sounds.
				if (GetLocalInt(GetModule(), "LEG_CRAFT_ACTIVE"))
				{
					ExecuteScript("leg_craft_playsounds", OBJECT_SELF);
				}
				
				
				// If the Object Name should be appended to the title.
				if (iUseObjectName)
					sTitle = sTitle + " " + GetName(OBJECT_SELF);
				
				// If we're going to have the follow up script make us not active anymore.
				if (!GetLocalInt(OBJECT_SELF, "LEG_INFO_FollowUpDeactivate"))
					DelayCommand(IntToFloat(iDuration), SetLocalInt(OBJECT_SELF, "LEG_INFO_IsActive", 0));
				
				// If there is a skill check
				if (iSkillCheck)
				{
					LEG_COMMON_ProgBar(oPC, iDuration, sTitle, iVisual, ANIMATION_LOOPING_KNEELIDLE, iCommandable, iCanCancel, sAnimation, 1, iDuration, "", 0, 0, oTarget);
					DelayCommand(IntToFloat(iDuration) + 0.5, LEG_INFO_PROGBAR_SkillCheck(iSkillCheck, oPC, sFollowScript, sFailScript));
				}
				else
				{
					// No skill required so just fire the GUI
					LEG_COMMON_ProgBar(oPC, iDuration, sTitle, iVisual, ANIMATION_LOOPING_KNEELIDLE, iCommandable, iCanCancel, sAnimation, 1, iDuration, "", 0, 0, oTarget);
					
					// Fire the followup Script
					if (sFollowScript != "")
					{
						DelayCommand(IntToFloat(iDuration) + 0.5, LEG_COMMON_ExecuteScript(sFollowScript, OBJECT_SELF, oPC));
						if (sInfoText != "")
							DelayCommand(IntToFloat(iDuration) + 0.5, ExecuteScript("leg_info_trigger", OBJECT_SELF));
					}
					else if (sInfoText != "")
						DelayCommand(IntToFloat(iDuration) + 0.5, ExecuteScript("leg_info_trigger", OBJECT_SELF));
					
					if (iTimerDuration > 0)
					{
						// Normally we'd run this timer bar on the object that has the variables but it can happen that the object could be destroyed
						// if say the player left the area and it was despawned. If that happens, the timer bar would hang so we transfer what we need
						// to the player and forget about the object running the script on the player instead.
						SetLocalInt(oPC, "LEG_INFO_TimerBarDuration", iTimerDuration);
						SetLocalString(oPC, "LEG_INFO_ProgBarTimerFailScript", GetLocalString(OBJECT_SELF, "LEG_INFO_ProgBarTimerFailScript"));

						DelayCommand(IntToFloat(iDuration) + 0.5, ExecuteScript("leg_info_timerbar", oPC));
					}
					
					// What happens if the timer bar that's running ON the placeable when the placeable is destroyed?
					DestroyObject(OBJECT_SELF, 30.0);
					
					// Set area flags once the progress bar is complete.
					DelayCommand(IntToFloat(iDuration) + 0.5, LEG_INFO_PROGBAR_SEFlags(iSetSEFlag));
					
					// Remove any item that is in inventory or hand if checkbox for removal is on.
					if (iRemoveItem)
					{
						if (sInvItem != "" || sItemCheck != "")
						{
							DelayCommand(IntToFloat(iDuration) + 0.5, LEG_INFO_PROGBAR_DestroyItems(oPC, sItemCheck, 1));
							DelayCommand(IntToFloat(iDuration) + 0.5, LEG_INFO_PROGBAR_DestroyItems(oPC, sInvItem, 1));
						}
					}
					
					// If we're supposed to give an item
					if (sGiveItem != "")
					{
						LEG_COMMON_CreateItem(oPC, sGiveItem, 1);	
					}
				}
			}
		}
	}
}