//-----------------------------------------------------------------------
// <copyright file="gui_leg_quest_finishquest.nss" company="Molior RS">
// Copyright (c) Molior RS. All rights reserved.
// </copyright>
// <revision> 1 </revision>
// <lasteditedby>Austin Jensen</lasteditedby>
//-----------------------------------------------------------------------
/*

    Script:			Called then the PC clicks Finish on a quest.  This script will
					finish a quest and allow the player to get the spoils (or lose quest items)
	Version:		1.7
	Plugin Version: 2.00
	Author:			Marshall Vyper
	
	Change Log:		06/23/2011 - 1.00 MV - Initial Release
					10/12/2012 - 1.1 MV - Found bug in XP math calculation.
					10/28/2012 - 1.2 MV - Fixed bug that shouted Collections rather than Deeds
					11/07/2012 - 1.3 MV - Added support for Spawn Only On Quest NPC's
					03/12/2013 - 1.4 MV - Updated to resolve issues with checking for props and removing too many.
					08/17/2013 - 1.5 MV - Fixed bug that caused players with colors or dashes in names to fail database	
					12/27/2013 - 1.6 MV - Fixed bug where prop items were not being removed if quest finisher gave the PC the prop item to start.
					08/11/2015 - 1.7 MV - Plugins Version 2.0 - Added code for performing PC Data table consolidation					
					
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_quest_include"
#include "tb_quest_progressquest"


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main(int iQuestID, int iNPC, int iObj1, int iObj2, int iObj3, int iObj4, int iObj5, int iAdvanceNPC, int iRewardChoice, int iRewards, int iQuestType)
{
	// Get the quest finisher.
	object oNPC = GetLocalObject(OBJECT_SELF, "QNPC");
	
	// Set up some variables.
	int iLink, iNPCInNextQuest, iRewardCounter;
	string sQuestID = IntToString(iQuestID);
	string sNextQuest;

	// If I am supposed to take a prop from the PC that I gave to the PC, then check to make
	// sure the PC still has it.  Only really happens in quest tools.
	if (!LEG_QUEST_CheckInventoryProps(OBJECT_SELF, oNPC, sQuestID, iNPC, TRUE))
		return;

	// Ensure the PC has selected one of the available rewards if there are any.
	if (iRewards)
	{
		if (iRewardChoice == 0 && iRewards > 1)
		{
			LEG_COMMON_DisplayInfoBox(OBJECT_SELF, "Select a Reward.");
			return;
		}
		else if (iRewardChoice == 0 && iRewards == 1)
			iRewardChoice = 1;
	}

	// If a reward has been chosen then close the gui.
	CloseGUIScreen(OBJECT_SELF, "leg_quest_finish");

	// Quest is finished, we won't be needing this anymore:
	SetLocalInt(OBJECT_SELF, "QUEST_PreviousNPC", 0);
	
	
	// If we're a repeatable quest then we need to determine that now so we can
	// either finish the quest for good, or allow it to be restarted.
	string sTableID = LEG_COMMON_GetPC2Table(OBJECT_SELF);
	int iFinishState;
	int iRepeats = GetLocalInt(oNPC, "LEG_QUEST_Repeats_" + IntToString(GetLocalInt(OBJECT_SELF, "LEG_QuestPos")));
	int iCompletes = GetPersistentInt(OBJECT_SELF, "QuestID_" + sQuestID + "_Completes", sTableID);
	if (iRepeats == 0)
		iFinishState = 999;
	else if (iRepeats == -1)
		iFinishState = 0;
	else if (iCompletes < iRepeats)
		iFinishState = 0;
	else
		iFinishState = 999;

	// Because of the 2.0 consolidation effort, rather than go back looking for all the SQL GetTables
	// we just set oPC to OBJECT_SELF and forget about it.
	object oPC = OBJECT_SELF;
	string sTablePlayer = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
	string sTableToon = SQLEncodeSpecialChars(GetName(oPC));
	
	//Triston
	FinishQuest(oPC, "", iQuestID);
	
	// If the finish state is 0 at this point, we're allowed to repeat however, there is now an elapsed time
	// that is allowed to pass.  If the time is set to 0, then we can keep the finish state at 0, if however
	// the elapsed timer is not 0, then we need to set the quest state to 998.  Then in the openquest script,
	// we check to see if the time has passed for this quest.
	// IMPORTANT: When this timer gets checked, we will only check the LOCAL INT of the PC if the world is not
	// using Legends Persistent Time.  If Legends Persistent Time is active, we will get the stored time.
	int iTimeMins = GetLocalInt(oNPC, "LEG_QUEST_RepeatMins_" + IntToString(GetLocalInt(OBJECT_SELF, "LEG_QuestPos")));
	if (iTimeMins != 0 && iFinishState != 999)
	{
		// Store the state as 998!
		iFinishState = 998;	
		int iTimer = (iTimeMins * REAL_MINUTES) + LEG_COMMON_TimeStamp();
		SetLocalInt(OBJECT_SELF, "QuestID_" + sQuestID + "_NextRepeat", iTimer);
		SetPersistentInt(OBJECT_SELF, "QuestID_" + sQuestID + "_NextRepeat", iTimer, 0, sTableID);
	}
	
	SetLocalInt(OBJECT_SELF, "LEG_QuestPos", 0);
	
	// Add one complete to whatever we already have.
	iCompletes++;
	SetPersistentInt(OBJECT_SELF, "QuestID_" + sQuestID + "_Completes", iCompletes, 0, sTableID);
	
	// Store the data - we've finished.
	SetLocalInt(OBJECT_SELF, "QuestID_" + sQuestID + "_NPC", iFinishState);
	SetPersistentInt(OBJECT_SELF, "QuestID_" + sQuestID + "_NPC", iFinishState, 0, sTableID);

	// Clean up the objective entries.. we don't need them anymore.  As well, clean up the Locals
	DeletePersistentVariable(OBJECT_SELF, "QuestID_" + sQuestID + "_OBJ1", sTableID);
	DeletePersistentVariable(OBJECT_SELF, "QuestID_" + sQuestID + "_OBJ2", sTableID);
	DeletePersistentVariable(OBJECT_SELF, "QuestID_" + sQuestID + "_OBJ3", sTableID);
	DeletePersistentVariable(OBJECT_SELF, "QuestID_" + sQuestID + "_OBJ4", sTableID);
	DeletePersistentVariable(OBJECT_SELF, "QuestID_" + sQuestID + "_OBJ5", sTableID);
	DeletePersistentVariable(OBJECT_SELF, "QuestID_" + sQuestID + "_OBJ6", sTableID);
	DeletePersistentVariable(OBJECT_SELF, "QuestID_" + sQuestID + "_OBJ7", sTableID);
	DeletePersistentVariable(OBJECT_SELF, "QuestID_" + sQuestID + "_OBJ8", sTableID);
	DeletePersistentVariable(OBJECT_SELF, "QuestID_" + sQuestID + "_OBJ9", sTableID);
	DeletePersistentVariable(OBJECT_SELF, "QuestID_" + sQuestID + "_OBJ10", sTableID);
	SetLocalInt(OBJECT_SELF, "QuestID_" + sQuestID + "_OBJ1", 0);
	SetLocalInt(OBJECT_SELF, "QuestID_" + sQuestID + "_OBJ2", 0);
	SetLocalInt(OBJECT_SELF, "QuestID_" + sQuestID + "_OBJ3", 0);
	SetLocalInt(OBJECT_SELF, "QuestID_" + sQuestID + "_OBJ4", 0);
	SetLocalInt(OBJECT_SELF, "QuestID_" + sQuestID + "_OBJ5", 0);
	SetLocalInt(OBJECT_SELF, "QuestID_" + sQuestID + "_OBJ6", 0);
	SetLocalInt(OBJECT_SELF, "QuestID_" + sQuestID + "_OBJ7", 0);
	SetLocalInt(OBJECT_SELF, "QuestID_" + sQuestID + "_OBJ8", 0);
	SetLocalInt(OBJECT_SELF, "QuestID_" + sQuestID + "_OBJ9", 0);
	SetLocalInt(OBJECT_SELF, "QuestID_" + sQuestID + "_OBJ10", 0);
	string sPCTableName = LEG_COMMON_GetPC2Table(OBJECT_SELF);
	SQLExecDirect("DELETE FROM " + sPCTableName + " WHERE `player` = '" + sTablePlayer + "' AND `tag` = '" + sTableToon + "' AND `Name` LIKE 'QuestID_" + sQuestID + "_FLGAREA%'");	
	SQLExecDirect("DELETE FROM " + sPCTableName + " WHERE `player` = '" + sTablePlayer + "' AND `tag` = '" + sTableToon + "' AND `Name` LIKE 'QuestID_" + sQuestID + "_FLG%'");	
	SQLExecDirect("DELETE FROM " + sPCTableName + " WHERE `player` = '" + sTablePlayer + "' AND `tag` = '" + sTableToon + "' AND `Name` LIKE 'QuestID_" + sQuestID + "_TIMER%'");	
	
	// Perform a Deed annoucement if appropriate
	if (iQuestType == 2)
	{
		// Grab the title of the deed.
		SQLExecDirect("SELECT `Title` FROM `" + QUESTPREFIX + "_mainquests` WHERE `QuestID`='" + sQuestID + "'");
		SQLFetch();
		string sDeedName = SQLGetData(1);
		
		// If the Info plugin is active, then identify the crier and add this announcment
		if (GetLocalInt(GetModule(), "LEG_INFO_ACTIVE"))
		{
			AddScriptParameterString("At " + LEG_COMMON_GetTimeNon24(GetTimeHour(), LEG_COMMON_GetGameTimeMinute()) + " on " + LEG_COMMON_GetMonthName(GetCalendarMonth()) + " " + IntToString(GetCalendarDay()) + ", " + IntToString(GetCalendarYear()));
			AddScriptParameterString(GetName(OBJECT_SELF) + " has completed the " + sDeedName + " deed!");
			ExecuteScriptEnhanced("leg_info_crieradd", OBJECT_SELF);
		}
		
		// If Shout announcements for deeds are active, do that now.  (NOTE Try to get the mod to do this after testing)
		if (LEG_QUEST_DEEDSHOUTS)
		{
			string sPlayerName = GetFirstName(OBJECT_SELF) + " " + GetLastName(OBJECT_SELF);
			AssignCommand(GetModule(), SpeakString(sPlayerName + " has completed the " + sDeedName + " deed!", TALKVOLUME_SHOUT));
		}
	}	
	
	// Play a pretty quest done sound and notify the PC
	PlaySound("gui_quest_done");
	LEG_COMMON_DisplayInfoBox(OBJECT_SELF, "Quest Completed");

	// If we're using the Resting plugin, we should store the players locaton if this is not an instance.
	if (GetLocalInt(GetModule(), "LEG_WORLD_ACTIVE"))
		ExecuteScript("leg_world_savepc", OBJECT_SELF);
		
	// If the plugin is configured to save locations in this module.
	if (GetLocalInt(GetModule(), "LEG_TELE_ACTIVE"))
	{
		ExecuteScript("leg_tele_savecampsite", OBJECT_SELF);
	}		
		
	// Get the level of the quest.
	int iQuestLevel;
	SQLExecDirect("SELECT * FROM `" + QUESTPREFIX + "_questheader` WHERE `QuestID` = " + sQuestID);
	while (SQLFetch())
		iQuestLevel = StringToInt(SQLGetData(3));
	
	// If we are configured to remove a prop, let's do it now but only if we gave it to the PC.  If a previous
	// NPC gave us a prop we were supposed to remove, then we would have already in the OpenQuest script when
	// the PC advanced to our stage.  The only time this would NOT happen is if this current NPC is the finisher
	// that also gave a prop item.
	// We are finishing so we have to assume the builder removed props from the players using the Remove Prop pulldown.  
	// If they forgot this then the player will end up with a prop in their inventory after the quest.  Sorry, be more
	// careful when building your quests.  This used to be a REMOVE any and all props in the entire
	// quest but that will cause problems going forward as we try to only remove the correct amount
	// of props.
	//SQLExecDirect("SELECT * FROM `" + QUESTPREFIX + "_propitems` WHERE `QuestID` = '" + sQuestID + "';");
	string sGiveProp = "";
	int iRemoveCycle = FALSE;
	SQLExecDirect("SELECT * FROM `" + QUESTPREFIX + "_propitems` WHERE `QuestID` = '" + sQuestID + "' AND `NPCID` = '" + IntToString(iNPC) + "' ORDER BY `Action`;");
	while (SQLFetch())
	{
		string sAction = SQLGetData(2);
		string sParameter1 = SQLGetData(3);
		string sParameter2 = SQLGetData(4);
		string sParameter3 = SQLGetData(5);	
		string sParameter4 = SQLGetData(6);	
		// Look for those GIVEITEM actions - Going to comment this out and see if its still needed.
		// If a builder wants to remove a prop then they should have it in the REMOVE so a TAKEITEM
		// option can be created.  
		if (sAction == "GIVEITEM")
		{
			// If I gave the player a prop, then I'll want to be taking it back now but only if I
			// am configured to do so.
			sGiveProp = sParameter1;
		}
		
		// Look for those TAKEITEM actions for props.  I only take if I gave it.  The ORDER BY clause ensures
		// the GIVE (if any) shows up first so we can capture that.
		if (sAction == "TAKEITEM")
		{
			if (sParameter1 == "<Remove All>")
			{
				iRemoveCycle = TRUE;
			}		
			else if (sGiveProp == sParameter1)
			{
				LEG_COMMON_DestroyItems(OBJECT_SELF, sParameter1, StringToInt(sParameter2));
			}
		}
		
	}

	// If the quest finisher has a Remove all, then do it	
	if (iRemoveCycle)
	{		
		SQLExecDirect("SELECT * FROM `" + QUESTPREFIX + "_propitems` WHERE `QuestID` = '" + sQuestID + "' AND `Action` = 'GIVEITEM';");
		while (SQLFetch())
		{
			string sAction = SQLGetData(2);
			string sParameter1 = SQLGetData(3);
			string sParameter2 = SQLGetData(4);
			string sParameter3 = SQLGetData(5);	
			string sParameter4 = SQLGetData(6);	
			
			// Look for those GIVEITEM actions
			if (sAction == "GIVEITEM")
			{
				// Take all the GIVE items.
				LEG_COMMON_DestroyItems(OBJECT_SELF, sParameter1, StringToInt(sParameter2));
			}
		}						
	}			
	
	
	
	// Time to hand out the goods!
	SQLExecDirect("SELECT * FROM `" + QUESTPREFIX + "_questrewards` WHERE `QuestID` = " + sQuestID);
	while (SQLFetch())
	{
		// Grab all the reward actions for this row.
		string sAction = SQLGetData(2);
		string sParameter1 = SQLGetData(3);
		string sParameter2 = SQLGetData(4);
		string sParameter3 = SQLGetData(5);	
		string sParameter4 = SQLGetData(6);	
		
		// If we're giving XP.. hell yeah!  Then lets give it!
		if (sAction == "GIVEXP")
		{
			// Find out how much XP to give.
			int iXP = StringToInt(sParameter1);
			
			// Adjust XP reward based on level.. we don't want high level players getting too much XP from low
			// level quests so lets chop it up some.
			int iPCLevel = GetTotalLevels(OBJECT_SELF, FALSE);
			if (iPCLevel - iQuestLevel > 1)
				iXP = iXP / (iPCLevel - iQuestLevel);
			
			// Now Hand the XP over and display how much we got!
			sParameter1 = IntToString(iXP);
			GiveXPToCreature(OBJECT_SELF, iXP);
			FloatingTextStringOnCreature("<color=lightblue> " + sParameter1 + " XP Gained </color>", OBJECT_SELF, FALSE);
		}
		else if (sAction == "GIVEGOLD")
		{
			// Oh.. some gold too?  Yes please.
			GiveGoldToCreature(OBJECT_SELF, StringToInt(sParameter1));
		}
		else if (sAction == "TAKEITEM")
		{
			// Some props that we may have had to collect.. time do get rid of those.
			LEG_COMMON_DestroyItems(OBJECT_SELF, sParameter1, StringToInt(sParameter2));			
		}
		else if (sAction == "GIVEITEM")
		{
			// Time to give our selected reward out.
			iRewardCounter++;
			if (iRewardCounter == iRewardChoice)
			{
				// How many do we give?
				int iTotal = StringToInt(sParameter2);
				int iCount;
				
				// Ok, hand them over.
				LEG_COMMON_CreateItem(OBJECT_SELF, sParameter1, iTotal);
			}
		}
		else if (sAction == "GIVEFEAT")
		{
			// Lore books give feats.  Let's do that!
			int iFeat = StringToInt(sParameter1);
			
			// Actual Give Feat Code.
			FeatAdd(OBJECT_SELF, iFeat, FALSE);
			
			// Assign Ability - All our feat rewards need to be listed here.  There's no real easy way around this
			// Too bad too.
			LEG_QUEST_GiveFeat(OBJECT_SELF, iFeat);
			
			// Let them know about our new feat.
			SendMessageToPC(OBJECT_SELF, "New Feat Gained!");
		}		
		else if (sAction == "LINK")
		{
			// Are we linking to another quest?  If so, let's get ready for that.
			iLink = TRUE;
			sNextQuest = sParameter1;
			iNPCInNextQuest = StringToInt(sParameter2);
		}
	}

	// Hand out bonus XP for skill checks
	int iBonusXP = GetPersistentInt(OBJECT_SELF, "QuestID_" + sQuestID + "_BonusXP", sTableID);
	if (iBonusXP)
	{
		// Adjust XP reward based on level.. we don't want high level players getting too much XP from low
		// level quests so lets chop it up some.
		int iPCLevel = GetTotalLevels(OBJECT_SELF, FALSE);
		if (iPCLevel - iQuestLevel > 1)
			iBonusXP = iBonusXP / (iPCLevel - iQuestLevel);
		
		// Now Hand the XP over and display how much we got!
		string sParameter1 = IntToString(iBonusXP);
		GiveXPToCreature(OBJECT_SELF, iBonusXP);
		FloatingTextStringOnCreature("<color=lightblue> " + sParameter1 + " Skill Use XP Gained </color>", OBJECT_SELF, FALSE);
	}
	
	
	// Clean up extra variables when the quest is finally completed.
	if (iFinishState == 999)
	{
		DeletePersistentVariable(OBJECT_SELF, "QuestID_" + sQuestID + "_NextRepeat", sTableID);
		DeletePersistentVariable(OBJECT_SELF, "QuestID_" + sQuestID + "_Completes", sTableID);
		DeletePersistentVariable(OBJECT_SELF, "QuestID_" + sQuestID + "_Type", sTableID);
		DeletePersistentVariable(OBJECT_SELF, "QuestID_" + sQuestID + "_BonusXP", sTableID);
		DeletePersistentVariable(OBJECT_SELF, "QuestID_" + sQuestID + "_FailTime", sTableID);
		SetLocalInt(OBJECT_SELF, "QuestID_" + sQuestID + "_1_ReluctantPassed", 0);
		SetLocalInt(OBJECT_SELF, "QuestID_" + sQuestID + "_2_ReluctantPassed", 0);
		SetLocalInt(OBJECT_SELF, "QuestID_" + sQuestID + "_3_ReluctantPassed", 0);
		SetLocalInt(OBJECT_SELF, "QuestID_" + sQuestID + "_4_ReluctantPassed", 0);
		SetLocalInt(OBJECT_SELF, "QuestID_" + sQuestID + "_5_ReluctantPassed", 0);
		string sPCTableName = LEG_COMMON_GetPC2Table(OBJECT_SELF);
		SQLExecDirect("DELETE FROM " + sPCTableName + " WHERE `player` = '" + sTablePlayer + "' AND `tag` = '" + sTableToon + "' AND `Name` LIKE 'QuestID_" + sQuestID + "_%_ReluctantPassed'");
	}
	
	if (iFinishState == 998)
	{
		string sPCTableName = LEG_COMMON_GetPC2Table(OBJECT_SELF);
		SQLExecDirect("DELETE FROM " + sPCTableName + " WHERE `player` = '" + sTablePlayer + "' AND `tag` = '" + sTableToon + "' AND `Name` LIKE 'QuestID_" + sQuestID + "_%_ReluctantPassed'");
		SetLocalInt(OBJECT_SELF, "QuestID_" + sQuestID + "_1_ReluctantPassed", 0);
		SetLocalInt(OBJECT_SELF, "QuestID_" + sQuestID + "_2_ReluctantPassed", 0);
		SetLocalInt(OBJECT_SELF, "QuestID_" + sQuestID + "_3_ReluctantPassed", 0);
		SetLocalInt(OBJECT_SELF, "QuestID_" + sQuestID + "_4_ReluctantPassed", 0);
		SetLocalInt(OBJECT_SELF, "QuestID_" + sQuestID + "_5_ReluctantPassed", 0);
		DeletePersistentVariable(OBJECT_SELF, "QuestID_" + sQuestID + "_BonusXP", sTableID);
		DeletePersistentVariable(OBJECT_SELF, "QuestID_" + sQuestID + "_FailTime", sTableID);
		
		// Clean up placeable objects that will say "no more clicking for you!" because they have been saved
		// persistently.
		sPCTableName = LEG_COMMON_GetPC2Table(OBJECT_SELF);
		SQLExecDirect("DELETE FROM " + sPCTableName + " WHERE `player` = '" + sTablePlayer + "' AND `tag` = '" + sTableToon + "' AND `Name` LIKE '" + sQuestID + "_%'");
	
	}
	
	// Clean up
	SQLExecDirect("OPTIMIZE TABLE " + sTableID + ";");
	
	// We may have an info box to present.
	SQLExecDirect("SELECT * FROM `" + QUESTPREFIX + "_infoboxes` WHERE `QuestID` = '" + sQuestID + "';");
	while (SQLFetch())
	{
		string sOnType = SQLGetData(2);
		if (sOnType == "1")
		{
			string sInfoMessage = SQLGetData(3);	
			LEG_COMMON_DisplayInfoBox(OBJECT_SELF, sInfoMessage, 0, 0, 2);

		}
	}	
		
	// SAVE!
	ExportSingleCharacter(OBJECT_SELF);
			
	// If there was a LINK command in there, let's process it last.
	if (iLink && iFinishState == 999)
	{
		// First check requirements to ensure PC can actually get the offer for the linked quest.
		int iTotalQuests = GetLocalInt(oNPC, "LEG_QUEST_TotalQuests");
		int iCount;
		string sCount, sNextQuestPosition;
		for (iCount=1; iCount <= iTotalQuests; iCount++)
		{
			sQuestID = GetLocalString(oNPC, "LEG_QUEST_QuestID_" + IntToString(iCount));
			sCount = IntToString(iCount);
			if (sQuestID == sNextQuest)
				sNextQuestPosition = sCount;
		}
		
		if (LEG_QUEST_CheckQuestRequirements(OBJECT_SELF, oNPC, sNextQuestPosition))
		{
			LEG_QUEST_FireQuestGUI("leg_quest_offer", "leg_quest_offer.xml", OBJECT_SELF, iNPCInNextQuest, sNextQuest);
			SetPersistentInt(OBJECT_SELF, "QuestID_" + sNextQuest + "_" + IntToString(iNPCInNextQuest) + "_ReluctantPassed", 1, 0, sTableID);
			SetLocalInt(OBJECT_SELF, "QuestID_" + sNextQuest + "_" + IntToString(iNPCInNextQuest) + "_ReluctantPassed", 1);
		}
	}
		
	// If the PC had any henchmen for this quest, remove them.
	SetLocalInt(oNPC, "Henchman", 0);

	// If I was spawned for this PC as a result of a quest, deactivate my spawner.
	object oParent = GetLocalObject(oNPC, "SPAWN_Parent");
	string sWPTag = GetTag(oParent);
	
	// Cycle through the party.  If the party member needed to kill this mob, deactivate the spawner and
	// clear THAT person's entry from the questspawns table.
	if (GetLocalInt(oParent, "LEG_SPAWN_QuestBased") && GetLocalInt(OBJECT_SELF, sWPTag))
	{
		SetLocalInt(oParent, "LEG_SPAWN_TriggerSpawn", 1);
		SetLocalInt(OBJECT_SELF, sWPTag, 0);
		DeletePersistentVariable(OBJECT_SELF, sWPTag, QUESTPREFIX + "_questspawns");
	} 
	
	// Refresh any icons if we are using that ability.
	if (GetIsObjectValid(oNPC))
	{
		// Time to refresh OTHER NPC quest Icons that are nearby after accepting this quest.
		if (LEG_QUEST_ICONS)
		{
			object oIcon;
			object oTrap = GetNearestTrapToObject(oNPC, FALSE);
			SetTrapDisabled(oTrap);			
			float fTimer = 0.1;
			object oNextNPC = GetFirstObjectInShape(SHAPE_SPHERE, StringToFloat(ICONREFRESHRANGE), GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_CREATURE);
			while (GetIsObjectValid(oNextNPC))
			{
				// This section is there's another PC in the vicinity.  If so, I best reset my question
				// icon for them.
				if (GetIsPC(oNextNPC))
				{
					oIcon = GetLocalObject(oNPC, "MyIcon");
					DelayCommand(fTimer, LEG_QUEST_RefreshQuestIcon(oNPC, oIcon, oNextNPC));				
				}
				else
				{
					oIcon = GetLocalObject(oNextNPC, "MyIcon");
					DelayCommand(fTimer, LEG_QUEST_RefreshQuestIcon(oNextNPC, oIcon, OBJECT_SELF));
				}
				
				// Grab the next NPC.
				fTimer = fTimer + 0.1;
				oNextNPC = GetNextObjectInShape(SHAPE_SPHERE, StringToFloat(ICONREFRESHRANGE), GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_CREATURE);			
			}	
		}			
	}
}