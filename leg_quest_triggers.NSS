/*

    Script:			This script is called on Quest Triggers usually associated with the Explore a Place
					type objective.
	Version:		1.2
	Plugin Version: 2.00
	Author:			Marshall Vyper
	
	Change Log:		06/23/2011 - 1.00 MV - Initial Release
					12/22/2012 - 1.1 MV - Added support for Inactive Objective Rule
					08/11/2015 - 1.2 MV - Plugins Version 2.0 - Added code for performing PC Data table consolidation	
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_quest_include"


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	// Get the PC that's entering me.. Oh that sounds dirty hehe.
	object oPC = GetEnteringObject();
	string sTriggerName = GetName(OBJECT_SELF);

	// If the Quest plugin isn't active, just exit.
	if (!GetLocalInt(GetModule(), "LEG_QUEST_ACTIVE"))
		return;
				
	if (GetIsPC(oPC))
	{
		// Looks a PC just hit me.  Better check for quests.
		int iTotalQuests = GetLocalInt(OBJECT_SELF, "LEG_QUEST_TotalQuests");
		int iCount, iNeeds, iPCHas;
		string sQuestID, sQuestCounter;
		string sTableID = LEG_COMMON_GetPC2Table(oPC);
	
		// Start cycling through the quests this trigger offers.
		for (iCount = 1; iCount <= iTotalQuests; iCount++)
		{
			SetLocalObject(oPC, "QNPC", OBJECT_SELF);
			sQuestCounter = IntToString(iCount);
			sQuestID = GetLocalString(OBJECT_SELF, "LEG_QUEST_QuestID_" + sQuestCounter);
			int iObjective = GetLocalInt(OBJECT_SELF, "LEG_QUEST_IsObjective_" + sQuestCounter);
			int iNPCObjective = GetLocalInt(OBJECT_SELF, "LEG_QUEST_ObjectiveFor_" + sQuestCounter);
			int iAdvanceNPC = GetLocalInt(OBJECT_SELF, "LEG_QUEST_NPCAdvance_" + sQuestCounter);			
		
			// Is the player on the quest and are they on this step?
			int iPlayerNPC = GetLocalInt(oPC, "QuestID_" + sQuestID + "_NPC");				
			int iPlayerOBJCount = GetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ" + IntToString(iObjective));
			if (iPlayerNPC == iNPCObjective)
			{
				// Is my Objective Owner reluctant and has the PC gotten passed that little issue?
				//int iReluctance = GetLocalInt(OBJECT_SELF, "LEG_QUEST_Reluctant_" + IntToString(iObjective));
				int iReluctantPassed = GetLocalInt(oPC, "QuestID_" + sQuestID + "_" + IntToString(iNPCObjective) + "_ReluctantPassed");
				
				if (iReluctantPassed == 0)
					return;
			
				// If this objective is currently active and available for a PC to perform
				if (LEG_QUEST_GetOBJ(oPC, sQuestID, iNPCObjective, iObjective, "OBJInactive") == "1")
				{
						return;
				}
						
				// You were supposed to complete this objective before your timer ran out!
				if (!LEG_QUEST_CheckTimerForCredit(sQuestID, oPC, iNPCObjective, iObjective))
					return;
		
				// So what are we doing today?  Some exploring?  Ok.  If the PC needs to explore this
				// trigger, lets check and do what we have to do.
				if (GetLocalString(OBJECT_SELF, "LEG_QUEST_Action_" + sQuestCounter) == "Explore")
				{
					// See how many of me the PC needs.  Usually 1.
					iNeeds = GetLocalInt(OBJECT_SELF, "LEG_QUEST_PCNeeds_" + sQuestCounter);
					if (iNeeds == 0)
						iNeeds = 1;
					iPCHas = iPlayerOBJCount;
					if (iNeeds > iPCHas)
					{
						// Now the PC has one more than they had before!
						iPCHas++;
						
						// Looks like the PC needs me.  Let's display some information.  For Quest Type 1 which
						// is Lore Book type quests, we don't put the word "Discovered" in front.  But for other
						// type quests we do.  Meh, design decision, maybe we'll change this some day.  The TEXT
						// we use for the discovery comes from the NAME field of the tigger.
						string sTriggerText;
						int iQuestType = GetLocalInt(oPC, "QuestID_" + sQuestID + "_Type");
						int iForceNameOnly = GetLocalInt(OBJECT_SELF, "LEG_QUEST_ForceName_" + sQuestCounter);
						
						// See if there is an alternate message configured to display.								
						string sAltMessage = GetLocalString(OBJECT_SELF, "LEG_QUEST_AltMessage_" + sQuestCounter);
						
						if (sAltMessage != "")
						{
							sTriggerText = sAltMessage;	
						}
						else
						{
							
							if (iQuestType == 1 || iForceNameOnly)
								sTriggerText = sTriggerName;
							else
								sTriggerText = "Discovered " + sTriggerName + ".";
						}
						
						// Perform the display.
						LEG_COMMON_DisplayInfoBox(oPC, sTriggerText);
						
						// Save and give credit.
						SetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ" + IntToString(iObjective), 1);
						SetPersistentInt(oPC, "QuestID_" + sQuestID + "_OBJ" + IntToString(iObjective), 1, 0, sTableID);
						
						// Apply any Objective Rules
						int iMyFlagID = GetLocalInt(OBJECT_SELF, "LEG_QUEST_SE_MyFlag_" + sQuestCounter);	
						LEG_QUEST_ApplyObjectiveRules(oPC, sQuestID, iNPCObjective, iObjective, iMyFlagID);
						
						// Play a pretty sound.
						AssignCommand(oPC, PlaySound("gui_journaladd"));

						// So we just got credit for a quest objective.  What if this is a timer objective?  
						// For now, all we need to do is start up a timer.
						int iTimerDuration = GetLocalInt(OBJECT_SELF, "LEG_INFO_TimerBarDuration_" + sQuestID);
						if (iTimerDuration > 0)
						{
							SetLocalInt(oPC, "LEG_INFO_TimerBarDuration", iTimerDuration);
							SetLocalString(oPC, "LEG_INFO_ProgBarTimerFailScript", "leg_quest_objtimerfail");
							SetLocalString(oPC, "LEG_INFO_TimerBarQuestID", sQuestID);
							SetLocalInt(oPC, "LEG_INFO_TimerBarNPC", iNPCObjective);
							SetLocalInt(oPC, "LEG_INFO_TimerBarNPCOBJ", iObjective);
							SetPersistentInt(oPC, "QuestID_" + sQuestID + "_TIMERMOB" + IntToString(iNPCObjective), 1, 0, sTableID);
							SetPersistentInt(oPC, "QuestID_" + sQuestID + "_TIMERMOBOBJ" + IntToString(iObjective), 1, 0, sTableID);
							DeletePersistentVariable(oPC, "QuestID_" + sQuestID + "_MOBTIMERFAILED" + IntToString(iNPCObjective), sTableID);
							DeletePersistentVariable(oPC, "QuestID_" + sQuestID + "_MOBOBJTIMERFAILED" + IntToString(iObjective), sTableID);
							ExecuteScript("leg_info_timerbar", oPC);
						}												
						
						// Is there a timer bar running for this quest and NPC?  If so, store that we did this objective in case we have to remove it later.
						if (GetLocalInt(oPC, "LEG_INFO_TimerBarNPC") == iNPCObjective && GetLocalString(oPC, "LEG_INFO_TimerBarQuestID") == sQuestID)
							SetPersistentInt(oPC, "QuestID_" + sQuestID + "_TIMEROBJDONE" + IntToString(iObjective), iPCHas, 0, sTableID);
						
						// If using the Quest Icon configuration, refresh anyone that's nearby that may need to be.
						if (LEG_QUEST_ICONS)
						{
							float fTimer = 0.1;
							object oIcon;
							object oNextNPC = GetFirstObjectInShape(SHAPE_SPHERE, StringToFloat(ICONREFRESHRANGE), GetLocation(oPC), FALSE, OBJECT_TYPE_CREATURE);
							while (GetIsObjectValid(oNextNPC))
							{
								oIcon = GetLocalObject(oNextNPC, "MyIcon");
								DelayCommand(fTimer, LEG_QUEST_RefreshQuestIcon(oNextNPC, oIcon, oPC));				
								fTimer = fTimer + 0.1;
								oNextNPC = GetNextObjectInShape(SHAPE_SPHERE, StringToFloat(ICONREFRESHRANGE), GetLocation(oPC), FALSE, OBJECT_TYPE_CREATURE);			
							}	
						}

						// We need to check and see if this is a Lorebook Quest and if this Looted Item
						// will advance it and pop-up the GUI
						if (iQuestType == 1 && iPCHas >= iNeeds)
						{
							// This is a lore book and we have completed a Kill objective
							// Pop up the continue GUI if there is another NPC to be had.
							// Otherwise pop up the finish GUI
							int iQuestFinisher = GetLocalInt(OBJECT_SELF, "LEG_QUEST_Finisher_" + sQuestCounter);
							iCount = iTotalQuests;
							if (iQuestFinisher)
							{
								LEG_QUEST_FireQuestGUI("leg_quest_finish", "leg_quest_finish.xml", oPC, iPlayerNPC, sQuestID);
							}
							else
							{
								LEG_QUEST_FireQuestGUI("leg_quest_continue", "leg_quest_continue.xml", oPC, iAdvanceNPC, sQuestID, iAdvanceNPC);
								SetPersistentInt(oPC, "QuestID_" + sQuestID + "_" + IntToString(iAdvanceNPC) + "_ReluctantPassed", 1, 0, sTableID);
								SetLocalInt(oPC, "QuestID_" + sQuestID + "_" + IntToString(iAdvanceNPC) + "_ReluctantPassed", 1);
							}
						}
					}
				}
			}
		}
	}
}