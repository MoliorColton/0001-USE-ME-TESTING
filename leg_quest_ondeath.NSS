/*

    Script:			What happens when we're using the quest plugin and something dies!  Plenty!
	Version:		1.5
	Plugin Version: 2.00
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		06/23/2011 - 1.00 MV - Initial Release
					11/22/2012 - 1.1 MV - Added support for Inactive Objective Rule
					05/22/2015 - 1.2 MV - Fixed bug that caused Reset to use delay of Spawn Point activation to de-activate.
					07/24/2015 - 1.3 MV - Added support for special loot bags
					07/26/2015 - 1.4 MV - Added support for OFF Flags
					08/11/2015 - 1.5 MV - Plugins Version 2.0 - Added code for performing PC Data table consolidation					
					
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_quest_se_include"


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// LOCAL FUNCTIONS
// /////////////////////////////////////////////////////////////////////////////////////////////////////
int LEG_QUEST_ONDEATH_IsNeeded(object oPC)
{
	int iTotalQuests = GetLocalInt(OBJECT_SELF, "LEG_QUEST_TotalQuests");
	int iCount;
	string sQuestCounter, sQuestID;
	for (iCount = 1; iCount <= iTotalQuests; iCount++)
	{
		sQuestCounter = IntToString(iCount);
		sQuestID = GetLocalString(OBJECT_SELF, "LEG_QUEST_QuestID_" + sQuestCounter);
		int iObjective = GetLocalInt(OBJECT_SELF, "LEG_QUEST_IsObjective_" + sQuestCounter);
		int iNPCObjective = GetLocalInt(OBJECT_SELF, "LEG_QUEST_ObjectiveFor_" + sQuestCounter);		
		
		string sMyAction = GetLocalString(OBJECT_SELF, "LEG_QUEST_Action_" + sQuestCounter);
		if (sMyAction == "Drop")
		{
			object oMember = GetFirstFactionMember(oPC, TRUE);
			while (GetIsObjectValid(oMember))
			{
				if (GetArea(oMember) == GetArea(OBJECT_SELF))
				{
					int iPlayerNPC = GetLocalInt(oMember, "QuestID_" + sQuestID + "_NPC");				
					int iPlayerOBJCount = GetLocalInt(oMember, "QuestID_" + sQuestID + "_OBJ" + IntToString(iObjective));
					if (iPlayerNPC == iNPCObjective)
					{
						int iNeeds = GetLocalInt(OBJECT_SELF, "LEG_QUEST_PCNeeds_" + sQuestCounter);
						int iPCHas = iPlayerOBJCount;
						if (iNeeds > iPCHas)
							return 1;
					}	
				}
				oMember = GetNextFactionMember(oPC, TRUE);
			}
		}
	}
	return 0;
}



object LEG_QUEST_ONDEATH_SpawnBodyBagCheck(object oBodyBag, object oPC)
{
	string sBodyBagRef = GetLocalString(OBJECT_SELF, "LEG_BodyBag");
	
	// Set a default body bag if one isn't configured.
	if (sBodyBagRef == "" || sBodyBagRef == "leg_quest_remains1")
		sBodyBagRef = "leg_quest_remains1";
	else
	{
		sBodyBagRef = "leg_quest_remainsspec1";
	}	
	if (!GetIsObjectValid(oBodyBag))
	{
		// Check to see if we should do this.
		if (LEG_QUEST_ONDEATH_IsNeeded(oPC) == 0)
			return OBJECT_INVALID;
	
		// Looks like we didn't spawn a standard body bag from the LOOT plugin, so let's create one now.
		int iDeSpawnMins = GetLocalInt(OBJECT_SELF, "LEG_BodyBag_Mins");
		if (!iDeSpawnMins)
			iDeSpawnMins = 2;
		
		// Determine a location just a little ways off from the corpse so we don't overlap
		// with a loot bag should there be one.
		float fAngle, fRadiusX, fRadiusY, fRadius, fFacing;
		vector vRadius, vSpawnVector;
		location lSpawnSite;		
		vSpawnVector = GetPosition(OBJECT_SELF);
		fAngle = IntToFloat(Random(361));
		fRadius = IntToFloat(Random(FloatToInt(0.05)) + 1);
		fRadiusX = fRadius * cos(fAngle);
		fRadiusY = fRadius * sin(fAngle);
		vRadius = Vector(fRadiusX, fRadiusY);
		fFacing = GetFacing(OBJECT_SELF);
		lSpawnSite = Location(GetArea(OBJECT_SELF), vSpawnVector + vRadius, fFacing);
				
		// Now spawn me!
		oBodyBag = CreateObject(OBJECT_TYPE_PLACEABLE, sBodyBagRef, lSpawnSite);
		DestroyObject(oBodyBag, 60.0 * IntToFloat(iDeSpawnMins), FALSE);
		
		//Loot Effects on them
		//if (sBodyBagRef == "leg_quest_remainsspec1")
		//{
			int iEffect = GetNum2DARows("visualeffects") + 64;
			LEG_COMMON_VisualEffect(iEffect, oBodyBag, OBJECT_INVALID, -1.0);
		//}
	}
	
	return oBodyBag;
}



// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	// Who was I?
	string sMobName = GetName(OBJECT_SELF);
	
	// Oh crap, I was an escort and now I R dead.  Notify all players in the area that is currently ON my quest.
	if (GetLocalInt(OBJECT_SELF, "OnEscort"))
	{
		// First we collect some details about of escort.
		object oPC = GetLocalObject(OBJECT_SELF, "MyEscort");	
		object oMember = GetFirstFactionMember(oPC);
		string sQuestID = GetLocalString(OBJECT_SELF, "MyEscort_Quest");
		int iNPC = GetLocalInt(OBJECT_SELF, "LEG_QUEST_NPCID_1");
		
		// Cycle through our party members that are in the area.
    	while(oMember != OBJECT_INVALID)
    	{
	        if (GetIsPC(oMember) && GetArea(oMember) == GetArea(oPC))
        	{
				// Is the player on the quest and are they on this step?
				int iPlayerNPC = GetLocalInt(oMember, "QuestID_" + sQuestID + "_NPC");				
				int iPlayerOBJCount = GetLocalInt(oMember, "QuestID_" + sQuestID + "_OBJ1");
				
				if (iPlayerNPC == iNPC)
				{
					// Let them know our escort died.
					LEG_COMMON_DisplayInfoBox(oMember, "Quest failed, " + sMobName + " has died!");
					PlaySound("gui_journaladd");
				}
			}
			
			// Grab the next party member.
			oMember = GetNextFactionMember(oPC);
		}	
	}
	

	// If I died and I am a reward for a quest or spawned as a result of a quest, then de-activate my spawner.  Only thing that
	// will mess this up is if someone else kills the mob instead of me.  If this happens, I need to go talk to the quest
	// giver again, hit the continue button to re-activate it.  Get everyone in the winners party and see if anyone in it
	// spawned this, if so, deactivate it.  If another PC came along who was not on the quest did it, it will remain
	// active.  If 2 PC's in diff parties needed it, as long as one of them are not in the area at the time, this will
	// still work.  The only way this fails and a "continue" is required is if 2 PC's, both on same quest, both in
	// same area when the mob dies for one of them.
	object oParent = GetLocalObject(OBJECT_SELF, "SPAWN_Parent");
	object oPC = GetLocalObject(OBJECT_SELF, "XP_Winner");
	string sWPTag = GetTag(oParent);

	// A good time to check to see if the party member needed this for a Deed.
	AddScriptParameterObject(oPC);
	AddScriptParameterObject(OBJECT_SELF);
	ExecuteScriptEnhanced("leg_quest_deeds", OBJECT_SELF);	

			
	// Cycle through the party.  If the party member needed to kill this mob, deactivate the spawner and
	// clear THAT person's entry from the questspawns table.
	object oMember = GetFirstFactionMember(oPC, TRUE);
	while(oMember != OBJECT_INVALID)
   	{
        if (GetIsPC(oMember) && GetArea(oMember) == GetArea(oPC))
       	{
			if (GetLocalInt(oParent, "LEG_SPAWN_QuestBased") && GetLocalInt(oMember, sWPTag))
			{
				SetLocalInt(oParent, "LEG_SPAWN_TriggerSpawn", 1);
				SetLocalInt(oMember, sWPTag, 0);
				DeletePersistentVariable(oMember, sWPTag, QUESTPREFIX + "_questspawns");
			}
		}
		
		// I just died!  Is there any Special Effect flags I should turn on and check the party's pre-reqs.  If one of them has it, turn it on.
		int iHasReqs = LEG_QUEST_REQ_HasReqs(oMember, OBJECT_SELF);
		if (iHasReqs)
		{	
			int iMyOffFlagID = LEG_QUEST_SER_GetFlagID(OBJECT_SELF, "OffDeath");
			LEG_QUEST_SER_SetFlag(GetArea(OBJECT_SELF), LEG_QUEST_SER_GetFlagID(OBJECT_SELF, "Death"));
			LEG_QUEST_SER_SetFlag(GetArea(OBJECT_SELF), iMyOffFlagID, 1);
			object oSEMan = GetNearestObjectByTag("legquestheartbeat", OBJECT_SELF);
			LEG_QUEST_SE_DeactivateActiveFlag(oSEMan, iMyOffFlagID);
			ExecuteScript("leg_quest_se_hb", oSEMan);
		}
		oMember = GetNextFactionMember(oPC, TRUE);
	}
	
	// Find out if I had any quests which are configured on the MOB blueprint, not the SPAWN waypoint or anything else.
	int iTotalQuests = GetLocalInt(OBJECT_SELF, "LEG_QUEST_TotalQuests");
	int iCount, iNeeds, iPCHas, iLootCreate = FALSE;
	string sQuestID, sQuestCounter;
	
	// Move along to quest based objects.  By now, the critter should have spawned a placeable object to loot, otherwise
	// we are not using the QUEST plugin in at all because the quest plugin requires a spawned placeable.  If there is none,
	// which could have been created by the LOOT plugin, then we need to create one.
	object oBodyBag = GetLocalObject(OBJECT_SELF, "LEG_BODYBAG");

	// First thing we do is cycle through the MOB's quests.	
	for (iCount = 1; iCount <= iTotalQuests; iCount++)
	{
		// Get who we are.
		sQuestCounter = IntToString(iCount);
		string sQuestID = GetLocalString(OBJECT_SELF, "LEG_QUEST_QuestID_" + sQuestCounter);
		int iObjective = GetLocalInt(OBJECT_SELF, "LEG_QUEST_IsObjective_" + sQuestCounter);
		int iNPCObjective = GetLocalInt(OBJECT_SELF, "LEG_QUEST_ObjectiveFor_" + sQuestCounter);

		// Find out if we are a DROP type mob because if so, we need to pass on the variables from the body
		// to the body bag.  We do this because the bodybag isn't always around like a normal placeable.
		// Once we're done this, it behaves like a normal quest placeable.
		if (GetLocalString(OBJECT_SELF, "LEG_QUEST_Action_" + sQuestCounter) == "Drop")
		{
			// Check for an existing bodybag (if none exits, create one).
			oBodyBag = LEG_QUEST_ONDEATH_SpawnBodyBagCheck(oBodyBag, oPC);
			
			// If its a valid loot bag then assign its vars.
			if(GetIsObjectValid(oBodyBag))
			{
				SetLocalInt(oBodyBag, "LEG_QUEST_TotalQuests", iTotalQuests);
				SetLocalString(oBodyBag, "LEG_QUEST_QuestID_" + sQuestCounter, GetLocalString(OBJECT_SELF, "LEG_QUEST_QuestID_" + sQuestCounter));
				SetLocalInt(oBodyBag, "LEG_QUEST_IsObjective_" + sQuestCounter, iObjective);
				SetLocalInt(oBodyBag, "LEG_QUEST_ObjectiveFor_" + sQuestCounter, iNPCObjective);		
				SetLocalString(oBodyBag, "LEG_QUEST_Item_" + sQuestCounter, GetLocalString(OBJECT_SELF, "LEG_QUEST_Item_" + sQuestCounter));
				SetLocalString(oBodyBag, "LEG_QUEST_FakePlaceable_" + sQuestCounter, GetLocalString(OBJECT_SELF, "LEG_QUEST_FakePlaceable_" + sQuestCounter));
				SetLocalInt(oBodyBag, "LEG_QUEST_MinQty_" + sQuestCounter, GetLocalInt(OBJECT_SELF, "LEG_QUEST_MinQty_" + sQuestCounter));
				SetLocalInt(oBodyBag, "LEG_QUEST_MaxQty_" + sQuestCounter, GetLocalInt(OBJECT_SELF, "LEG_QUEST_MaxQty_" + sQuestCounter));
				SetLocalInt(oBodyBag, "LEG_QUEST_Chance_" + sQuestCounter, GetLocalInt(OBJECT_SELF, "LEG_QUEST_Chance_" + sQuestCounter));
				SetLocalInt(oBodyBag, "LEG_QUEST_PCNeeds_" + sQuestCounter, GetLocalInt(OBJECT_SELF, "LEG_QUEST_PCNeeds_" + sQuestCounter));
				SetLocalInt(oBodyBag, "LEG_QUEST_NPCAdvance_" + sQuestCounter, GetLocalInt(OBJECT_SELF, "LEG_QUEST_NPCAdvance_" + sQuestCounter));
				SetLocalObject(oBodyBag, "LEG_KillWinner", oPC);
				SetLocalString(oBodyBag, "LEG_QUEST_Action_" + sQuestCounter, "Searching");
				SetLocalInt(oBodyBag, "LEG_QUEST_Finisher_" + sQuestCounter, GetLocalInt(OBJECT_SELF, "LEG_QUEST_Finisher_" + sQuestCounter));
				SetLocalInt(oBodyBag, "LEG_QUEST_UseTime", GetLocalInt(OBJECT_SELF, "LEG_QUEST_UseTime"));
				SetLocalInt(oBodyBag, "LEG_QUEST_SE_MyFlag_" + sQuestCounter, GetLocalInt(OBJECT_SELF, "LEG_QUEST_SE_MyFlag_" + sQuestCounter));
				SetLocalString(oBodyBag, "LEG_QUEST_AltProgBar_" + sQuestCounter, GetLocalString(OBJECT_SELF, "LEG_QUEST_AltProgBar_" + sQuestCounter));
				SetLocalInt(oBodyBag, "LEG_INFO_TimerBarDuration_" + sQuestID, GetLocalInt(OBJECT_SELF, "LEG_INFO_TimerBarDuration_" + sQuestID));
				SetLocalInt(oBodyBag, "LEG_QUEST_TimerRequired_" + sQuestID, GetLocalInt(OBJECT_SELF, "LEG_QUEST_TimerRequired_" + sQuestID));
				SetLocalInt(oBodyBag, "LEG_QUEST_TimerOff_" + sQuestID, GetLocalInt(OBJECT_SELF, "LEG_QUEST_TimerOff_" + sQuestID));
				SetLocalInt(oBodyBag, "LEG_QUEST_TimerSEFail_" + sQuestCounter, GetLocalInt(OBJECT_SELF, "LEG_QUEST_TimerSEFail_" + sQuestCounter));
				
				// Set this variable so the placeable script knows whether or not to add this placeable
				// to the persistent database.  We don't want to fill the database with loot placeables from
				// mob deaths.
				SetLocalInt(oBodyBag, "MOBDeath", TRUE);
			}
		}
		else if (GetLocalString(OBJECT_SELF, "LEG_QUEST_Action_" + sQuestCounter) == "Kill")
		{
			// If a Kill type quest, give the Kill to the entire party.  There's no need to deal with a bodybag in this case.	
			oMember = GetFirstFactionMember(oPC);
	    	while(oMember != OBJECT_INVALID)
	    	{
		        if (GetIsPC(oMember))
	        	{
					// Is the player on the quest and are they on this step?
					int iPlayerNPC = GetLocalInt(oMember, "QuestID_" + sQuestID + "_NPC");				
					int iPlayerOBJCount = GetLocalInt(oMember, "QuestID_" + sQuestID + "_OBJ" + IntToString(iObjective));
					if (iPlayerNPC == iNPCObjective)
					{
						// If this objective is currently active and available for a PC to perform
						if (LEG_QUEST_GetOBJ(oPC, sQuestID, iNPCObjective, iObjective, "OBJInactive") != "1")
						{
							// You were supposed to complete this objective before your timer ran out!
							if (!LEG_QUEST_CheckTimerForCredit(sQuestID, oPC, iNPCObjective, iObjective))
								return;
												
							iNeeds = GetLocalInt(OBJECT_SELF, "LEG_QUEST_PCNeeds_" + sQuestCounter);
							iPCHas = iPlayerOBJCount;
	
							// Does the party member need this?
							if (iNeeds > iPCHas)
							{
								// Looks like they do so lets inform them.
								object oIcon;
								iPCHas++;
								
								// See if there is an alternate message configured to display.								
								string sAltMessage = GetLocalString(OBJECT_SELF, "LEG_QUEST_AltMessage_" + sQuestCounter);
								if (sAltMessage != "")
								{
									LEG_COMMON_DisplayInfoBox(oMember, sAltMessage);
								}
								else
								{
									LEG_COMMON_DisplayInfoBox(oMember, "Defeated " + sMobName + " (" + IntToString(iPCHas) + "/" + IntToString(iNeeds) + ")");
								}
								
								
								// Store this fact.							
								SetLocalInt(oMember, "QuestID_" + sQuestID + "_OBJ" + IntToString(iObjective), iPCHas);
								string sTableID = LEG_COMMON_GetPC2Table(oMember);
								SetPersistentInt(oMember, "QuestID_" + sQuestID + "_OBJ" + IntToString(iObjective), iPCHas, 0, sTableID);
								
								// So we just got credit for a quest objective.  What if this is a timer objective?  
								// For now, all we need to do is start up a timer.
								int iTimerDuration = GetLocalInt(OBJECT_SELF, "LEG_INFO_TimerBarDuration_" + sQuestID);
								if (iTimerDuration > 0)
								{
									SetLocalInt(oMember, "LEG_INFO_TimerBarDuration", iTimerDuration);
									SetLocalString(oMember, "LEG_INFO_ProgBarTimerFailScript", "leg_quest_objtimerfail");
									SetLocalString(oMember, "LEG_INFO_TimerBarQuestID", sQuestID);
									SetLocalInt(oMember, "LEG_INFO_TimerBarNPC", iNPCObjective);
									SetLocalInt(oMember, "LEG_INFO_TimerBarNPCOBJ", iObjective);
									SetPersistentInt(oMember, "QuestID_" + sQuestID + "_TIMERMOB" + IntToString(iNPCObjective), 1, 0, sTableID);
									SetPersistentInt(oMember, "QuestID_" + sQuestID + "_TIMERMOBOBJ" + IntToString(iObjective), 1, 0, sTableID);
									DeletePersistentVariable(oMember, "QuestID_" + sQuestID + "_MOBTIMERFAILED" + IntToString(iNPCObjective), sTableID);
									DeletePersistentVariable(oMember, "QuestID_" + sQuestID + "_MOBOBJTIMERFAILED" + IntToString(iObjective), sTableID);
									ExecuteScript("leg_info_timerbar", oMember);
								}	
														
								// Apply any Objective Rules
								int iMyFlagID = LEG_QUEST_SER_GetFlagID(OBJECT_SELF, "Death");
								LEG_QUEST_ApplyObjectiveRules(oMember, sQuestID, iNPCObjective, iObjective, iMyFlagID);
	
								// Play a pretty sound
								PlaySound("gui_journaladd");
								
								// Is there a timer bar running for this quest and NPC?  If so, store that we did this objective in case we have to remove it later.
								if (GetLocalInt(oMember, "LEG_INFO_TimerBarNPC") == iNPCObjective && GetLocalString(oMember, "LEG_INFO_TimerBarQuestID") == sQuestID)
									SetPersistentInt(oMember, "QuestID_" + sQuestID + "_TIMEROBJDONE" + IntToString(iObjective), iPCHas, 0, sTableID);
								
								// If this is the last one for the player, then advance the quest NPC if the
								// variable is set.
								int iAdvanceNPC = GetLocalInt(OBJECT_SELF, "LEG_QUEST_NPCAdvance_" + sQuestCounter);
								if (iAdvanceNPC && iPCHas == iNeeds)
								{
									// Looks like we have a winner.  Let's advance to the Next NPC and clear all objectives.
									SetLocalInt(oMember, "QuestID_" + sQuestID + "_NPC", iAdvanceNPC);
									SetPersistentInt(oMember, "QuestID_" + sQuestID + "_NPC", iAdvanceNPC, 0, sTableID);
							
									// Clear all objectives for this member.
									LEG_QUEST_ClearObjectives(oMember, sQuestID, sTableID);
								}	
								
								// If this is a lorebook objective we need to find out if its the last one
								// of if there is a next step to the lore book and popup the appropriate gui.
								int iQuestType = GetLocalInt(oMember, "QuestID_" + sQuestID + "_Type");
								if (iQuestType == 1 && iPCHas >= iNeeds)
								{
									// This is a lore book and we have completed a Kill objective
									// Pop up the continue GUI if there is another NPC to be had.
									// Otherwise pop up the finish GUI
									int iQuestFinisher = GetLocalInt(OBJECT_SELF, "LEG_QUEST_Finisher_" + sQuestCounter);
									iCount = iTotalQuests;
									if (iQuestFinisher)
										LEG_QUEST_FireQuestGUI("leg_quest_finish", "leg_quest_finish.xml", oMember, iPlayerNPC, sQuestID);
									else
									{
										LEG_QUEST_FireQuestGUI("leg_quest_continue", "leg_quest_continue.xml", oMember, iAdvanceNPC, sQuestID, iAdvanceNPC);
										SetPersistentInt(oPC, "QuestID_" + sQuestID + "_" + IntToString(iAdvanceNPC) + "_ReluctantPassed", 1, 0, sTableID);
										SetLocalInt(oPC, "QuestID_" + sQuestID + "_" + IntToString(iAdvanceNPC) + "_ReluctantPassed", 1);
									}
										
								}
	
								// Check for Icons that may need to be refreshed.
								if (LEG_QUEST_ICONS)
								{
									float fTimer = 0.1;
									object oIcon;
									object oNextNPC = GetFirstObjectInShape(SHAPE_SPHERE, StringToFloat(ICONREFRESHRANGE), GetLocation(oMember), FALSE, OBJECT_TYPE_CREATURE);
									while (GetIsObjectValid(oNextNPC))
									{
										oIcon = GetLocalObject(oNextNPC, "MyIcon");
										DelayCommand(fTimer, LEG_QUEST_RefreshQuestIcon(oNextNPC, oIcon, oMember));				
										fTimer = fTimer + 0.1;
										oNextNPC = GetNextObjectInShape(SHAPE_SPHERE, StringToFloat(ICONREFRESHRANGE), GetLocation(oMember), FALSE, OBJECT_TYPE_CREATURE);			
									}	
								}
							}
						}
					}
				}
				// Grab the next party member.
				oMember = GetNextFactionMember(oPC);
			}
		}
	}			
	
	// Discovered that we use MOBDeath on the mob itself (not just the loot bag).  When using the Use Item, Get Item on a mob, we're actually checking the corpse
	// for this variable and if it doesn't have it, we store its location persistently.  Basically, this is a bug fix.
	SetLocalInt(OBJECT_SELF, "MOBDeath", TRUE);		
	
}