/*

    Script:			Placed on the On Enter event of a trigger, called from the Master On Death script
					for monsters, or placed on a placeable object's On Used event to display an info
					box with defined variable options.
	Version:		1.8
	Plugin Version: 2.00
	Author:			Marshall Vyper
	
	Change Log:		12/20/2010 - 1.00 MV - Initial Release
					06/24/2011 - 1.01 MV - Added support for Quest Deeds
					06/24/2011 - 1.02 MV - Added support for skills (spot/listen) on triggers
					10/16/2012 - 1.3 MV - Added support for Plugin Skill checks
					10/18/2012 - 1.4 MV - Added support for quest based triggers
					12/03/2012 - 1.5 MV - Added support for multiple box types
					06/07/2015 - 1.6 MV - Don't fire unless its a player
					08/11/2015 - 1.7 MV - Plugins Version 2.0 - Added code for performing PC Data table consolidation										
					09/26/2015 - 1.8 MV - Fixed bug where skills checks were showing on NoRepeat Triggers
*/

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_info_include"


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	
	// If the Infobox plugin is not enabled, don't do anything.
	if (GetLocalInt(GetModule(), "LEG_INFO_ACTIVE"))
	{
		// Get the player entering our trigger.
		object oPC = GetEnteringObject();
		
		// If this is invalid, try a mob killer...
		if (!GetIsObjectValid(oPC))
			oPC = GetLastUsedBy();
			
		// If this is invalid, get the last user
		if (!GetIsObjectValid(oPC))
			oPC = GetLastKiller();
		
		// If we are still invalid, just exit.
		if (!GetIsObjectValid(oPC))
			return;

		// Fire for players only.
		if (!GetIsPC(oPC))
			return;
				
		// Find out of this should even be active right now based on time of day.
		string sStartTOD = GetLocalString(OBJECT_SELF, "LEG_INFO_StartTOD");
		string sEndTOD = GetLocalString(OBJECT_SELF, "LEG_INFO_EndTOD");
		int iActive = TRUE;		
		
		// Are we a quest trigger?  This trigger will only fire once if a PC is on a quest.
		// These are ALWAYS once only and not an objective.  Just atmosphere.
		if (GetLocalInt(GetModule(), "LEG_QUEST_ACTIVE"))
		{
			string sQuestID = GetLocalString(OBJECT_SELF, "LEG_INFO_Quest");
			if (sQuestID != "")
			{
				// Looks like we are on a quest.
				int iPlayerPosition = GetLocalInt(oPC, "QuestID_" + sQuestID + "_NPC");
				if (iPlayerPosition <= 0 || iPlayerPosition == 999 || iPlayerPosition == 998)
				{
					// But the player does not currently have this quest.
					return;
				}
			}
		}	
		
		// If we don't have a setting, we just assume Active is TRUE which mean go ahead and process for now.
		// Otherwise go based on the TOD.  If a Start Time is set, then an end time must be set too or
		// we will always spawn.
		if (sStartTOD == "" || sEndTOD == "")
			iActive = TRUE;
	    else
			iActive = LEG_COMMON_CheckTOD(sStartTOD, sEndTOD);
		
		// No point in going any further if we are TRUE for spawning right now.  Return that I did NOT despawn.
		if (!iActive)
			return;		

		// Grab the unique ID of this info box in case we have to store it forever.  If it has none, then
		// exit.
		string sTrigID = GetLocalString(OBJECT_SELF, "LEG_INFO_ID");
		if (sTrigID == "")
			return;
							
		if (GetIsPC(oPC))
		{

			// If there is a spot check required, then do it now.
			int iSkillCheck = GetLocalInt(OBJECT_SELF, "LEG_INFO_SkillCheck");

			// If there is a spot check required, then do it now.
			int iSkillDC = GetLocalInt(OBJECT_SELF, "LEG_INFO_SkillDC");
			
			// Do we deactivate even if the Spot Check is failed for this PC?
			int iFailedSkillDeactivate = GetLocalInt(OBJECT_SELF, "LEG_INFO_FailedSkill");
			
			// Get the PC table for triggers		
			string sTableID = LEG_COMMON_GetPC2Table(oPC);

			// Perform the Spot/Listen check.  If we fail the check, exit now.
			if (iSkillDC)
			{
				if (!GetIsSkillSuccessful(oPC, iSkillCheck, iSkillDC, FALSE))
				{
					// If the skill was not a success, and we do NOT re-trigger, then
					// do that.
					if (iFailedSkillDeactivate && GetLocalInt(OBJECT_SELF, "LEG_INFO_OncePerPlayer"))
					{
						// Tell the PC we've activated this trigger
						SetLocalInt(oPC, "INFO_Triggered" + sTrigID, 1);
					}
					else if (iFailedSkillDeactivate && GetLocalInt(OBJECT_SELF, "LEG_INFO_NoRepeat"))
					{
						// Set so the PC won't trigger again.
						SetPersistentInt(oPC, "Info_" + sTrigID, 1, 0, sTableID);
					}
					return;
				}
			}
						
			// If this is once per reset and it's been triggered already, exit.
			if (GetLocalInt(OBJECT_SELF, "LEG_INFO_OncePerReset") && GetLocalInt(OBJECT_SELF, "INFO_Triggered"))
				return;
			
			// If this is a once per reset per player trigger then exit
			if (GetLocalInt(OBJECT_SELF, "LEG_INFO_OncePerPlayer") && GetLocalInt(oPC, "INFO_Triggered" + sTrigID))
				return;

			// If this is a unqiue trigger and it's been activated, exit.
			if (GetLocalInt(OBJECT_SELF, "LEG_INFO_Unqiue"))
			{
				if (GetPersistentInt(GetModule(), sTrigID, INFOPREFIX + "unqiuetrigs"))
					return;
			}			
				
			// Tell the info trigger we've been activated once.
			SetLocalInt(OBJECT_SELF, "INFO_Triggered", 1);
			
			// Tell the PC we've activated this trigger
			SetLocalInt(oPC, "INFO_Triggered" + sTrigID, 1);
			
			// Find out if we're supposed to repeat the text for this infobox each time a player enters it.
			int iNoRepeat = GetLocalInt(OBJECT_SELF, "LEG_INFO_NoRepeat");
			
			// Find out if we are to also display the message in the chat box.
			int iNoLocalChat = GetLocalInt(OBJECT_SELF, "LEG_INFO_NoChatBox");
			
			// Should we shout this across the server?
			int iShout = GetLocalInt(OBJECT_SELF, "LEG_INFO_ShoutChat");
			
			// What is the box type
			int iBoxType = GetLocalInt(OBJECT_SELF, "LEG_INFO_BoxType");
			
			// Should we display this for all party members?
			int iParty = GetLocalInt(OBJECT_SELF, "LEG_INFO_PartyInfo");
			
			// Get the Text of what we want to say.
			string sText = GetLocalString(OBJECT_SELF, "LEG_INFO_Text");
			
			// Collect Skill Check info for the Skill Show below.  NOTE: this script can appear on triggers OR be called from the progbar
			// script.  There are 2 different "sets" of variables for skill checks depending on if its a trigger or a progbar so that
			// each call of this doesn't trip over the other.  
			if (!iSkillDC)
			{
				iSkillCheck = GetLocalInt(OBJECT_SELF, "LEG_INFO_ProgBarSkillCheck");
				iSkillDC = GetLocalInt(OBJECT_SELF, "LEG_INFO_ProgBarSkillDC");
			}

			
			// If this is a unique once only ever trigger, then store that information.
			if (GetLocalInt(OBJECT_SELF, "LEG_INFO_Unique"))
				SetPersistentInt(GetModule(), sTrigID, 1, 0, INFOPREFIX + "unqiuetrigs");
						
			// Setup for Local Chat or Not.
			int iLocalChat = 0;
			if (!iNoLocalChat)
				iLocalChat = 1;
			
			// Set up for parties
			object oMember;
			
			// If configured to repeat, then do this (note the If Not No Repeat hehe, I did that
			// just to be a jerk haha.
			if (!iNoRepeat)
			{
				// Display Skill if its supposed to
				LEG_INFO_ShowSkillOnSuccess(oPC, iSkillCheck, iSkillDC);
				
				// Display for the PC or the Party.
				if (iParty)
				{
					// Cycle through the party and send the infobox text to each one.
					oMember = GetFirstFactionMember(oPC);
					while(GetIsObjectValid(oMember))
					{
						// Display!
						LEG_COMMON_DisplayInfoBox(oMember, sText, iLocalChat, iShout, iBoxType);
						
						// Tell the Party Member we've activated this trigger
						SetLocalInt(oMember, "INFO_Triggered" + sTrigID, 1);

						// Next Party Member
						oMember = GetNextFactionMember(oPC);
					}
				}
				else
					LEG_COMMON_DisplayInfoBox(oPC, sText, iLocalChat, iShout, iBoxType);
			}
			else
			{
				// Perform the standard check on each party member.
				if (iParty)
				{
					// Cycle through the party and send the infobox text to each one.
					oMember = GetFirstFactionMember(oPC);
					while(GetIsObjectValid(oMember))
					{
						sTableID = LEG_COMMON_GetPC2Table(oMember);
						if (!GetPersistentInt(oMember, "Info_" + sTrigID, sTableID))
						{
							// Display Skill if its supposed to
							LEG_INFO_ShowSkillOnSuccess(oPC, iSkillCheck, iSkillDC);

							// If this is a non-repeatable box, check the database to see if they have seen it before.
							LEG_COMMON_DisplayInfoBox(oMember, sText, iLocalChat, iShout, iBoxType);
							SetPersistentInt(oMember, "Info_" + sTrigID, 1, 0, sTableID);
						}
						oMember = GetNextFactionMember(oPC);
					}
				}
				else
				{
					if (!GetPersistentInt(oPC, "Info_" + sTrigID, sTableID))
					{
						// Display Skill if its supposed to
						LEG_INFO_ShowSkillOnSuccess(oPC, iSkillCheck, iSkillDC);

						// If this is a non-repeatable box, check the database to see if they have seen it before.
						LEG_COMMON_DisplayInfoBox(oPC, sText, iLocalChat, iShout, iBoxType);
						SetPersistentInt(oPC, "Info_" + sTrigID, 1, 0, sTableID);
						
						// Also a good time to check to see if the party member needed this for a Deed.
						if (GetLocalInt(GetModule(), "LEG_QUEST_ACTIVE"))
						{
							AddScriptParameterObject(oPC);
							AddScriptParameterObject(OBJECT_SELF);
							ExecuteScriptEnhanced("leg_quest_deeds", OBJECT_SELF);						
						}
					}
				}
			}
		}
	}
}