/*

    Script:			Main Quest Plugin Include.
	Version:		2.0
	Plugin Version: 2.00
	Author:			Marshall Vyper
	Parameters:		None

	Change Log:		12/16/2010 - 1.00 MV - Initial Build
					12/23/2011 - 1.01 MV - Bug fix to resolve duplicate retries on mob drops
					10/01/2012 - 1.1 MV - Update to use ResRef's exclusively
								        - Updated to do inventory counts
					10/11/2012 - 1.2 MV - Fixed bug with "Required Items" message showing up on perceptions.	
					10/14/2012 - 1.3 MV - Implement all Requirement checking options
					10/14/2012 - 1.4 MV - Fixed bug that would cause the "{Quest}" to show up in item rewards
					11/02/2012 - 1.5 MV - Fixed bug where PC could loot more items that they should and end up with too many.
					11/22/2012 - 1.6 MV - Added support for new Objective Rules
					03/12/2013 - 1.7 MV - Added function for prop checking when removal is required.
					01/04/2014 - 1.8 MV - Fixed bug where Extra Text on quest objectives would appear before object was complete.
					05/23/2015 - 1.9 MV - Added difficulty icons to the offer, and continue GUIs
					08/04/2015 - 1.91 MV - Fixed issue where quest spawns for placeables were not clearing from spawn table.
					08/11/2015 - 2.0 MV - Plugins Version 2.0 - Added code for performing PC Data table consolidation					

*/

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// USER CONFIGURABLE CONSTANTS
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_quest_constants"


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// SYSTEM CONSTANTS
// /////////////////////////////////////////////////////////////////////////////////////////////////////
const string COLOUR_WHITE = "<color=#FFFFFF>";        // RGB 255, 255, 255 
const string COLOUR_LIGHT_GREY = "<color=#C0C0C0>";   // RGB 192, 192, 192 
const string COLOUR_GREY = "<color=#808080>";         // RGB 128, 128, 128 
const string COLOUR_DARK_GREY = "<color=#404040>";    // RGB 64, 64, 64 
const string COLOUR_BLACK = "<color=#000000>";        // RGB 0, 0, 0 
const string COLOUR_LIGHT_RED = "<color=#FF8080>";    // RGB 255, 128, 128 
const string COLOUR_LIGHT_GREEN = "<color=#80FF80>";  // RGB 128, 255, 128 
const string COLOUR_LIGHT_BLUE = "<color=#8080FF>";   // RGB 128, 128, 255 
const string COLOUR_LIGHT_YELLOW = "<color=#FFFF80>"; // RGB 255, 255, 128 
const string COLOUR_LIGHT_PURPLE = "<color=#FF80FF>"; // RGB 255, 128, 255 
const string COLOUR_LIGHT_CYAN = "<color=#80FFFF>";   // RGB 128, 255, 255 
const string COLOUR_RED = "<color=#FF0000>";          // RGB 255, 0, 0 
const string COLOUR_GREEN = "<color=#00FF00>";        // RGB 0, 255, 0 
const string COLOUR_BLUE = "<color=#0000FF>";         // RGB 0, 0, 255 
const string COLOUR_YELLOW = "<color=#FFFF00>";       // RGB 255, 255, 0 
const string COLOUR_PURPLE = "<color=#FF00FF>";       // RGB 255, 0, 255 
const string COLOUR_CYAN =  "<color=#00FFFF>";        // RGB 0, 255, 255 
const string COLOUR_ORANGE = "<color=#FF9900>";       // RGB 255, 153, 0 
const string COLOUR_DARK_RED = "<color=#800000>";     // RGB 128, 0, 0 
const string COLOUR_DARK_GREEN = "<color=#008000>";   // RGB 0, 128, 0 
const string COLOUR_DARK_BLUE = "<color=#000080>";    // RGB 0, 0, 128 
const string COLOUR_DARK_YELLOW = "<color=#808000>";  // RGB 128, 128, 0 
const string COLOUR_DARK_PURPLE = "<color=#800080>";  // RGB 128, 0, 128 
const string COLOUR_DARK_CYAN = "<color=#008080>";    // RGB 0, 128, 128 


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_all_masterinclude"



// /////////////////////////////////////////////////////////////////////////////////////////////////////
// FUNCTION DECLARATIONS
// /////////////////////////////////////////////////////////////////////////////////////////////////////



int LEG_QUEST_CheckObjectiveInventoryItems(object oPC, string sQuestID, int iNPC, string sObjectiveType, int iNeeds, int iObjective);
string LEG_QUEST_GetOneLiner(string sNPC);
string LEG_QUEST_GetPostOneLiner(string sNPC);
int LEG_QUEST_CheckOtherObjectives(object oPC, string sQuestID, int iPlayerStep, int iSkipOBJ, int iIconRefresh = 0);
void LEG_QUEST_CompleteObjectives(object oPC, string sQuestID, int iPlayerStep, int iFullSave = 0, int iNoNextNPC = 0);
void LEG_QUEST_ClearObjectives(object oPC, string sQuestID, string sTableID);
int LEG_QUEST_CheckObjectives(object oPC, string sQuestID, int iPlayerStep, int iIconRefresh = 0);
string LEG_QUEST_RewardsText(string sRewards);
string LEG_QUEST_ChallengeColor(object oPC, int iLevel);
void LEG_QUEST_FireQuestGUI(string sGUI, string sGUIFile, object oPC, int iNPCPosition, string sQuestID, int iAdvanceNPC = 0, int iAdvanceOBJ = 0);
void LEG_QUEST_RefreshQuestIcon(object oNPC, object oMyIcon, object oPC);
void LEG_QUEST_GiveFeat(object oPC, int iFeat);
void LEG_QUEST_QuestCreditItem(string sItem, object oTarget, string sQuest = "", int iObjective = 0, int iOldCondition = 0, int iStackSize = 1, int iNotifyTarget = 1, int iPCHas = 1, int iPCNeeds = 1, string sPlaceID = "", int iAdvanceNPC = 0, int iNPCObjective = 0, string sAltMessage = "", int iMyFlagID = 0, object oObject = OBJECT_SELF);
void LEG_QUEST_QuestCreditPlaceItem(string sItem, object oTarget, string sQuestID = "", int iObjective = 0, int iOldCondition = 0, int iStackSize = 1, int iNotifyTarget = 1, int iPCHas = 1, int iPCNeeds = 1, int iEffect = 0, string sPlaceID = "", int iNPCObjective = 0, string sAltMessage = "", int iMyFlagID = 0);
void LEG_QUEST_QuestCreditDestroyPlaceable(string sItem, object oTarget, string sQuestID = "", int iObjective = 0, int iOldCondition = 0, int iStackSize = 1, int iNotifyTarget = 1, int iPCHas = 1, int iPCNeeds = 1, string sPlaceID = "", int iNPCObjective = 0, string sAltMessage = "", int iMyFlagID = 0);
void LEG_QUEST_QuestCreditExaminePlaceable(string sDiscovery, object oTarget, string sQuestID = "", int iObjective = 0, int iPCHas = 1, int iPCNeeds = 1, string sPlaceID = "", int iNPCObjective = 0, string sAltMessage = "", int iMyFlagID = 0);
void LEG_QUEST_ObjectiveCredit(string sQuestID, object oTarget, string sObjective, string sObjectiveTarget, int iPCHas, int iPCNeeds, int iObjective, string sPlaceID = "", int iNPCObjective = 0, string sAltMessage = "", int iMyFlagID = 0, object oObject = OBJECT_SELF);
int LEG_QUEST_IsAutoAdvanceNPC(string sQuestID, int iNPC);
int LEG_QUEST_CheckObjective(object oPC, string sQuestID, int iPlayerStep, int iObjective);
string LEG_QUEST_GetOBJ(object oPC, string sQuestID, int iNPC, int iObjective, string sOBJ);
void LEG_QUEST_SetOBJ(object oPC, string sQuestID, int iNPC, int iObjective, string sOBJ, string sValue);
string LEG_QUEST_GetOBJDB(object oPC, string sQuestID, int iNPC, int iObjective, string sOBJ);
void LEG_QUEST_ApplyObjectiveRules(object oTarget, string sQuestID, int iNPCObjective, int iObjective, int iMyFlagID, int iInitialize = FALSE);
void LEG_QUEST_InitializeOBJRule(object oPC, string sQuestID, string sNPC, int iObjective);
void LEG_QUEST_PartyMemberObjective(object oCompleter, object oParent, string sQuestCounter, string sTriggerText, string sOptionalItem = "");
void LEG_QUEST_SER_SetFlag(object oTarget, int iMyFlagID, int iOff = 0);
int LEG_QUEST_CheckQuestRequirements(object oPC, object oTarget, string sQuestPosition);
int LEG_QUEST_CheckTimerForCredit(string sQuestID, object oPC, int iNPCObjective, int iObjective);

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// FUNCTIONS
// /////////////////////////////////////////////////////////////////////////////////////////////////////




// //////////////////////////////////////////////////
// LEG_QUEST_GetOneLiner
// //////////////////////////////////////////////////
string LEG_QUEST_GetOneLiner(string sNPC)
{
	// Grab the NPC's oneliner out of the NPC table for quests.  Use the NPC Tag to find him which
	// is in the Main Quest table as well.
	string sOneliner;
	SQLExecDirect("SELECT * FROM `" + QUESTPREFIX + "_questnpcs` WHERE `NPCTag` = '" + sNPC + "'");
	SQLFetch();
	sOneliner = SQLGetData(2);
	return sOneliner;
}



// //////////////////////////////////////////////////
// LEG_QUEST_GetPostOneLiner
// //////////////////////////////////////////////////
string LEG_QUEST_GetPostOneLiner(string sNPC)
{
	// Grab the NPC's oneliner out of the NPC table for quests.  Use the NPC Tag to find him which
	// is in the Main Quest table as well.
	string sOneliner;
	SQLExecDirect("SELECT * FROM `" + QUESTPREFIX + "_questnpcs` WHERE `NPCTag` = '" + sNPC + "'");
	SQLFetch();
	sOneliner = SQLGetData(4);
	return sOneliner;
}


// //////////////////////////////////////////////////
// LEG_QUEST_CheckOtherObjectives
// //////////////////////////////////////////////////
int LEG_QUEST_CheckOtherObjectives(object oPC, string sQuestID, int iPlayerStep, int iSkipOBJ, int iIconRefresh = 0)
{
	// This will take the Quest passed and find out what its objectives are.  Once it has them, it will
	// compare them to what the PC has accomplished.  If the PC hasn't accomplished them then we return false.
	SQLExecDirect("SELECT * FROM `" + QUESTPREFIX + "_mainquests` AS t1, `" + QUESTPREFIX + "_questheader` AS t2 WHERE t1.`QuestID`=t2.`QuestID` AND t1.`QuestID` = " + sQuestID + " AND t1.`QuestNPC` = " + IntToString(iPlayerStep));
	SQLFetch();
	int iObjective1 = StringToInt(SQLGetData(14));
	int iObjective2 = StringToInt(SQLGetData(15));
	int iObjective3 = StringToInt(SQLGetData(16));
	int iObjective4 = StringToInt(SQLGetData(17));
	int iObjective5 = StringToInt(SQLGetData(18));
	int iObjective6 = StringToInt(SQLGetData(19));
	int iObjective7 = StringToInt(SQLGetData(20));
	int iObjective8 = StringToInt(SQLGetData(21));
	int iObjective9 = StringToInt(SQLGetData(22));
	int iObjective10 = StringToInt(SQLGetData(23));		
	int iPCObjective1 = GetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ1");
	int iPCObjective2 = GetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ2");
	int iPCObjective3 = GetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ3");
	int iPCObjective4 = GetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ4");								
	int iPCObjective5 = GetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ5");		
	int iPCObjective6 = GetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ6");		
	int iPCObjective7 = GetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ7");		
	int iPCObjective8 = GetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ8");		
	int iPCObjective9 = GetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ9");		
	int iPCObjective10 = GetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ10");			

	// Added this nastiness to confirm PC has actual inventory count of any items they're "supposed" to have
	// for those objective types that require items.
	SQLExecDirect("SELECT `ObjType1`,`ObjType2`,`ObjType3`,`ObjType4`,`ObjType5`,`ObjType6`,`ObjType7`,`ObjType8`,`ObjType9`,`ObjType10` FROM `" + QUESTPREFIX + "_objrefs` WHERE `QuestID` = " + sQuestID + " AND `QuestNPC` = " + IntToString(iPlayerStep));
	SQLFetch();
	string sObjectiveType1 = SQLGetData(1);
	string sObjectiveType2 = SQLGetData(2);
	string sObjectiveType3 = SQLGetData(3);
	string sObjectiveType4 = SQLGetData(4);
	string sObjectiveType5 = SQLGetData(5);
	string sObjectiveType6 = SQLGetData(6);
	string sObjectiveType7 = SQLGetData(7);
	string sObjectiveType8 = SQLGetData(8);
	string sObjectiveType9 = SQLGetData(9);
	string sObjectiveType10 = SQLGetData(10);
	
	int iGotItems1 = LEG_QUEST_CheckObjectiveInventoryItems(oPC, sQuestID, iPlayerStep, sObjectiveType1, iObjective1, 1);
	int iGotItems2 = LEG_QUEST_CheckObjectiveInventoryItems(oPC, sQuestID, iPlayerStep, sObjectiveType2, iObjective2, 2);
	int iGotItems3 = LEG_QUEST_CheckObjectiveInventoryItems(oPC, sQuestID, iPlayerStep, sObjectiveType3, iObjective3, 3);
	int iGotItems4 = LEG_QUEST_CheckObjectiveInventoryItems(oPC, sQuestID, iPlayerStep, sObjectiveType4, iObjective4, 4);
	int iGotItems5 = LEG_QUEST_CheckObjectiveInventoryItems(oPC, sQuestID, iPlayerStep, sObjectiveType5, iObjective5, 5);
	int iGotItems6 = LEG_QUEST_CheckObjectiveInventoryItems(oPC, sQuestID, iPlayerStep, sObjectiveType6, iObjective6, 6);
	int iGotItems7 = LEG_QUEST_CheckObjectiveInventoryItems(oPC, sQuestID, iPlayerStep, sObjectiveType7, iObjective7, 7);
	int iGotItems8 = LEG_QUEST_CheckObjectiveInventoryItems(oPC, sQuestID, iPlayerStep, sObjectiveType8, iObjective8, 8);
	int iGotItems9 = LEG_QUEST_CheckObjectiveInventoryItems(oPC, sQuestID, iPlayerStep, sObjectiveType9, iObjective9, 9);
	int iGotItems10 = LEG_QUEST_CheckObjectiveInventoryItems(oPC, sQuestID, iPlayerStep, sObjectiveType10, iObjective10, 10);
	
	// If the PC has accomplished all the objectives EXCEPT for the Special SKIP objective, return true.
	if ((iSkipOBJ != 1 && iGotItems1 == FALSE) || (iSkipOBJ != 2 && iGotItems2 == FALSE) || (iSkipOBJ != 3 && iGotItems3 == FALSE) || (iSkipOBJ != 4 && iGotItems4 == FALSE) || (iSkipOBJ != 5 && iGotItems5 == FALSE) || (iSkipOBJ != 6 && iGotItems6 == FALSE) || (iSkipOBJ != 7 && iGotItems7 == FALSE) || (iSkipOBJ != 8 && iGotItems8 == FALSE) || (iSkipOBJ != 9 && iGotItems9 == FALSE) || (iSkipOBJ != 10 && iGotItems10 == FALSE))
	{
		if (!iIconRefresh)
			SendMessageToPC(oPC, "You are missing some required items!");
		return FALSE;
	}
	
	// If the PC has accomplished all the objectives EXCEPT for the Special SKIP objective, return true.
	if ((iSkipOBJ != 1 && iPCObjective1 != iObjective1) || (iSkipOBJ != 2 && iPCObjective2 != iObjective2) || (iSkipOBJ != 3 && iPCObjective3 != iObjective3) || (iSkipOBJ != 4 && iPCObjective4 != iObjective4) || (iSkipOBJ != 5 && iPCObjective5 != iObjective5) || (iSkipOBJ != 6 && iPCObjective6 != iObjective6) || (iSkipOBJ != 7 && iPCObjective7 != iObjective7) || (iSkipOBJ != 8 && iPCObjective8 != iObjective8) || (iSkipOBJ != 9 && iPCObjective9 != iObjective9) || (iSkipOBJ != 10 && iPCObjective10 != iObjective10))
		return FALSE;
	else
		return TRUE;
}


void LEG_QUEST_UndoObjective(object oPC, int iObjective, int iNPC, string sQuestID, int iAbortQuest = 0)
{
	// In order to undo an objective, we have to clear the players local variable for the objective, the players database entry for the objective, any items 
	// they may have acquired from the objective and undo any placeable object reference for the objective.
	string sObj = IntToString(iObjective);
	SQLExecDirect("SELECT `ObjRef" + sObj + "A`, `ObjRef" + sObj + "B`, `ObjRef" + sObj + "C`, `ObjType" + sObj + "` FROM `leg_quest_objrefs` WHERE `QuestNPC` = '" + IntToString(iNPC) + "' AND `QuestID` = '" + sQuestID + "'");
	SQLFetch();
	string sRef1 = SQLGetData(1);
	string sRef2 = SQLGetData(2);
	string sRef3 = SQLGetData(3);
	string sObjType = SQLGetData(4);
	string sItem;
	string sNPC = IntToString(iNPC);
	int iQuantity, iPCHas, iNeeds;

	if (sObjType == "PutItem")
	{
		// Auto Give item to complete the PutItem Objective unless its an abort quest.
		if (iAbortQuest != 0)
		{
			// The Item in question
			sItem = sRef2;

			// How many are we talking about.
			SQLExecDirect("SELECT `Objective" + sObj + "_Qty` FROM `" + QUESTPREFIX + "_mainquests` WHERE `QuestID` = '" + sQuestID + "' AND `QuestNPC` = '" + sNPC + "'");
			SQLFetch();
			iQuantity = StringToInt(SQLGetData(1));
						
			// Get quantity we have and figure out how many we need.
			iPCHas = LEG_COMMON_GetInventoryCount(oPC, sItem);
			
			// Give the PC the items they are missing
			iNeeds = iQuantity - iPCHas;
			if (iNeeds > 0)
				LEG_COMMON_CreateItem(oPC, sItem, iNeeds);
		}
	}
	else if (sObjType == "LootPlaceable" || sObjType == "LootCreature" || sObjType == "UseItemMob" || sObjType == "UseItemPlace")
	{
		// With this, we just want to blow away any items that was looted.
		// The Item in question
		sItem = sRef2;
		
		// How many are we talking about.
		SQLExecDirect("SELECT `Objective" + sObj + "_Qty` FROM `" + QUESTPREFIX + "_mainquests` WHERE `QuestID` = '" + sQuestID + "' AND `QuestNPC` = '" + sNPC + "'");
		SQLFetch();
		iQuantity = StringToInt(SQLGetData(1));
		
		// Get rid of this many.
		LEG_COMMON_DestroyItems(oPC, sItem, iQuantity);
		
	}

	
	// Regive props if required or remove if we're aborting.
	// What are the prop items this NPC gives?
	SQLExecDirect("SELECT `Parameter1`,`Parameter2` FROM `" + QUESTPREFIX + "_propitems` WHERE `QuestID` = '" + sQuestID + "' AND `NPCID` = '" + sNPC + "' AND `Action` = 'GIVEITEM'");
	SQLFetch();
	sItem = SQLGetData(1);
	if (sItem != "")
	{
		// So the PC is supposed to have this prop and this many
		iQuantity = StringToInt(SQLGetData(2));

		if (iAbortQuest >= 1)
		{
			// Get rid of this many.
			LEG_COMMON_DestroyItems(oPC, sItem, iQuantity);
		}		
		else
		{
			// How many we have?
			iPCHas = LEG_COMMON_GetInventoryCount(oPC, sItem);
		
			// Give the PC the items they are missing
			iNeeds = iQuantity - iPCHas;
			if (iNeeds > 0)
				LEG_COMMON_CreateItem(oPC, sItem, iNeeds);
		}
	}
	
	// Reset Placables that were interacted with
	string sTablePlayer = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
	string sTableToon = SQLEncodeSpecialChars(GetName(oPC));
	string sPCTableName = LEG_COMMON_GetPC2Table(oPC);
	SQLExecDirect("DELETE FROM " + sPCTableName + " WHERE `player` = '" + sTablePlayer + "' AND `tag` = '" + sTableToon + "' AND `Name` LIKE '" + sQuestID + "_%' AND `val` = '" + sObj + "'");	
	
	// Reset player variables
	DeletePersistentVariable(oPC, "QuestID_" + sQuestID + "_OBJ" + sObj, sPCTableName);
	SetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ" + sObj, 0);

}

void LEG_QUEST_AbortQuest(object oPC, string sQuestID)
{
	// Undo all the objectives from every NPC in this quest.  This will clean up any items the player may have, any placables they may have interacted with etc.
	
	
	
	
	
	
	
	
	// Delete the Quest Vars the PC current has from the database
	string sTablePlayer = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
	string sTableToon = SQLEncodeSpecialChars(GetName(oPC));
	string sPCTableName = LEG_COMMON_GetPC2Table(OBJECT_SELF);
	SQLExecDirect("DELETE FROM " + sPCTableName + " WHERE `player` = '" + sTablePlayer + "' AND `tag` = '" + sTableToon + "' AND `Name` LIKE 'QuestID_" + sQuestID + "_%'");	

	// Cross Server is an excellent script for re-reading whats in the database and refreshing the player's quests and local vars based on whats in it.
	ExecuteScript("leg_quest_crossserver", oPC);
	
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
}

int LEG_QUEST_CheckObjectiveInventoryItems(object oPC, string sQuestID, int iNPC, string sObjectiveType, int iNeeds, int iObjective)
{
	string sItem;
	// See if we can bypass the inventory check.
	SQLExecDirect("SELECT `NoInvCheck` FROM `" + QUESTPREFIX + "_objrules` WHERE `QuestID` = '" + sQuestID + "' AND `NPCID` = '" + IntToString(iNPC) + "' AND `ObjID` = '" + IntToString(iObjective) + "'");
	SQLFetch();
	string sNoInvCheck = SQLGetData(1);
	if (sNoInvCheck != "")
		return TRUE;
		
	// If this NPC has ANY Prime Objectives and the PC has one of them completed, then we skip this.
	int iPrimeObj = GetLocalInt(oPC, "QUEST_" + sQuestID + IntToString(iNPC) + "PrimeDone");
	if (iPrimeObj == 0 || iPrimeObj == iObjective)
	{
		if (sObjectiveType == "DeliverItem")
		{
			// We have an item delivery to make.  Find out how many we need.		
			SQLExecDirect("SELECT * FROM `" + QUESTPREFIX + "_propitems` WHERE `QuestID` = " + sQuestID + " AND `QuestNPC` = " + IntToString(iNPC) + " AND `Action` = 'GIVEITEM'");
			SQLFetch();
			sItem = SQLGetData(3);
			iNeeds = StringToInt(SQLGetData(4));			
		}
		else if (sObjectiveType == "ObtainItem")
		{
			// We have an item delivery to make.  Find out how many we need.		
			SQLExecDirect("SELECT * FROM `" + QUESTPREFIX + "_objrefs` WHERE `QuestID` = " + sQuestID + " AND `QuestNPC` = " + IntToString(iNPC));
			SQLFetch();
			sItem = SQLGetData(1 + iObjective);
		}
		else if (sObjectiveType == "LootCreature" || sObjectiveType == "LootPlaceable" || sObjectiveType == "UseItemMob"  || sObjectiveType == "UseItemPlace")
		{
			// We have an item delivery to make.  Find out how many we need.		
			SQLExecDirect("SELECT * FROM `" + QUESTPREFIX + "_objrefs` WHERE `QuestID` = " + sQuestID + " AND `QuestNPC` = " + IntToString(iNPC));
			SQLFetch();
			sItem = SQLGetData(11 + iObjective);
		}
	}	
	
	// confirm quantity
	if (sItem != "")
	{
		int iPCHas = LEG_COMMON_GetInventoryCount(oPC, sItem);
		if (iPCHas >= iNeeds)
			return TRUE;
		else
			return FALSE;
	
	}
	return TRUE;
}



// //////////////////////////////////////////////////
// LEG_QUEST_CompleteObjectives
// //////////////////////////////////////////////////
void LEG_QUEST_CompleteObjectives(object oPC, string sQuestID, int iPlayerStep, int iFullSave = 0, int iNoNextNPC = 0)
{
	// Get the row from the databae.  We'll grab what vars we need depending on
	// where the PC is in the quest.
	SQLExecDirect("SELECT * FROM `" + QUESTPREFIX + "_mainquests` AS t1, `" + QUESTPREFIX + "_questheader` AS t2 WHERE t1.`QuestID`=t2.`QuestID` AND t1.`QuestID` = " + sQuestID + " AND t1.`QuestNPC` = " + IntToString(iPlayerStep));
	SQLFetch();
	int iObjective1 = StringToInt(SQLGetData(14));
	int iObjective2 = StringToInt(SQLGetData(15));
	int iObjective3 = StringToInt(SQLGetData(16));
	int iObjective4 = StringToInt(SQLGetData(17));
	int iObjective5 = StringToInt(SQLGetData(18));
	int iObjective6 = StringToInt(SQLGetData(19));
	int iObjective7 = StringToInt(SQLGetData(20));
	int iObjective8 = StringToInt(SQLGetData(21));
	int iObjective9 = StringToInt(SQLGetData(22));
	int iObjective10 = StringToInt(SQLGetData(23));	
	
	SetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ1", iObjective1);
	SetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ2", iObjective2);
	SetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ3", iObjective3);
	SetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ4", iObjective4);								
	SetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ5", iObjective5);		
	SetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ6", iObjective6);		
	SetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ7", iObjective7);		
	SetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ8", iObjective8);		
	SetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ9", iObjective9);		
	SetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ10", iObjective10);							
	
	string sTableID;
	if (iFullSave)
	{
		sTableID = LEG_COMMON_GetPC2Table(OBJECT_SELF);
		SetPersistentInt(oPC, "QuestID_" + sQuestID + "_OBJ1", iObjective1, 0, sTableID);
		SetPersistentInt(oPC, "QuestID_" + sQuestID + "_OBJ2", iObjective2, 0, sTableID);
		SetPersistentInt(oPC, "QuestID_" + sQuestID + "_OBJ3", iObjective3, 0, sTableID);
		SetPersistentInt(oPC, "QuestID_" + sQuestID + "_OBJ4", iObjective4, 0, sTableID);
		SetPersistentInt(oPC, "QuestID_" + sQuestID + "_OBJ5", iObjective5, 0, sTableID);
		SetPersistentInt(oPC, "QuestID_" + sQuestID + "_OBJ6", iObjective6, 0, sTableID);
		SetPersistentInt(oPC, "QuestID_" + sQuestID + "_OBJ7", iObjective7, 0, sTableID);
		SetPersistentInt(oPC, "QuestID_" + sQuestID + "_OBJ8", iObjective8, 0, sTableID);
		SetPersistentInt(oPC, "QuestID_" + sQuestID + "_OBJ9", iObjective9, 0, sTableID);
		SetPersistentInt(oPC, "QuestID_" + sQuestID + "_OBJ10", iObjective10, 0, sTableID);	
	}
		
	if (iNoNextNPC)
	{
		int iIndex = 1;
		string sObjType;
		SQLExecDirect("SELECT `ObjType1`,`ObjType2`,`ObjType3`,`ObjType4`,`ObjType5`,`ObjType6`,`ObjType7`,`ObjType8`,`ObjType9`,`ObjType10` FROM `" + QUESTPREFIX + "_objrefs` WHERE `QuestID` = " + sQuestID + " AND `QuestNPC` = " + IntToString(iPlayerStep));
		SQLFetch();
		for (iIndex = 1; iIndex <= 10; iIndex++)
		{
			sObjType = SQLGetData(iIndex);
			if (sObjType == "DeliverItem" || sObjType == "SpeakToNPC")
			{
				SetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ" + IntToString(iIndex), 0);
				if (iFullSave)
				{
					SetPersistentInt(oPC, "QuestID_" + sQuestID + "_OBJ" + IntToString(iIndex), 0, 0, sTableID);
				}	
			}
		}
	}
	

}



// //////////////////////////////////////////////////
// LEG_QUEST_ClearObjectives
// //////////////////////////////////////////////////
void LEG_QUEST_ClearObjectives(object oPC, string sQuestID, string sTableID)
{
	// Set all the players CURRENT objectives for a particular quest to 0 meaning
	// whatever step the PC is on or will be on for this quest, they will not
	// have any objectives completed for that step/NPC.
	SetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ1", 0);
	SetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ2", 0);
	SetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ3", 0);
	SetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ4", 0);
	SetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ5", 0);
	SetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ6", 0);
	SetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ7", 0);
	SetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ8", 0);
	SetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ9", 0);
	SetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ10", 0);
	DeletePersistentVariable(oPC, "QuestID_" + sQuestID + "_OBJ1", sTableID);
	DeletePersistentVariable(oPC, "QuestID_" + sQuestID + "_OBJ2", sTableID);
	DeletePersistentVariable(oPC, "QuestID_" + sQuestID + "_OBJ3", sTableID);
	DeletePersistentVariable(oPC, "QuestID_" + sQuestID + "_OBJ4", sTableID);
	DeletePersistentVariable(oPC, "QuestID_" + sQuestID + "_OBJ5", sTableID);
	DeletePersistentVariable(oPC, "QuestID_" + sQuestID + "_OBJ6", sTableID);
	DeletePersistentVariable(oPC, "QuestID_" + sQuestID + "_OBJ7", sTableID);
	DeletePersistentVariable(oPC, "QuestID_" + sQuestID + "_OBJ8", sTableID);
	DeletePersistentVariable(oPC, "QuestID_" + sQuestID + "_OBJ9", sTableID);
	DeletePersistentVariable(oPC, "QuestID_" + sQuestID + "_OBJ10", sTableID);
			
}


// //////////////////////////////////////////////////
// LEG_QUEST_CheckObjectives
// //////////////////////////////////////////////////
int LEG_QUEST_CheckObjectives(object oPC, string sQuestID, int iPlayerStep, int iIconRefresh = 0)
{
	// Get the row from the databae.  We'll grab what vars we need depending on
	// where the PC is in the quest.
	SQLExecDirect("SELECT * FROM `" + QUESTPREFIX + "_mainquests` AS t1, `" + QUESTPREFIX + "_questheader` AS t2 WHERE t1.`QuestID`=t2.`QuestID` AND t1.`QuestID` = " + sQuestID + " AND t1.`QuestNPC` = " + IntToString(iPlayerStep));
	SQLFetch();
	int iObjective1 = StringToInt(SQLGetData(14));
	int iObjective2 = StringToInt(SQLGetData(15));
	int iObjective3 = StringToInt(SQLGetData(16));
	int iObjective4 = StringToInt(SQLGetData(17));
	int iObjective5 = StringToInt(SQLGetData(18));
	int iObjective6 = StringToInt(SQLGetData(19));
	int iObjective7 = StringToInt(SQLGetData(20));
	int iObjective8 = StringToInt(SQLGetData(21));
	int iObjective9 = StringToInt(SQLGetData(22));
	int iObjective10 = StringToInt(SQLGetData(23));		
	int iPCObjective1 = GetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ1");
	int iPCObjective2 = GetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ2");
	int iPCObjective3 = GetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ3");
	int iPCObjective4 = GetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ4");								
	int iPCObjective5 = GetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ5");		
	int iPCObjective6 = GetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ6");		
	int iPCObjective7 = GetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ7");		
	int iPCObjective8 = GetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ8");		
	int iPCObjective9 = GetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ9");		
	int iPCObjective10 = GetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ10");			

	// Added this nastiness to confirm PC has actual inventory count of any items they're "supposed" to have
	// for those objective types that require items.
	SQLExecDirect("SELECT `ObjType1`,`ObjType2`,`ObjType3`,`ObjType4`,`ObjType5`,`ObjType6`,`ObjType7`,`ObjType8`,`ObjType9`,`ObjType10` FROM `" + QUESTPREFIX + "_objrefs` WHERE `QuestID` = " + sQuestID + " AND `QuestNPC` = " + IntToString(iPlayerStep));
	SQLFetch();
	string sObjectiveType1 = SQLGetData(1);
	string sObjectiveType2 = SQLGetData(2);
	string sObjectiveType3 = SQLGetData(3);
	string sObjectiveType4 = SQLGetData(4);
	string sObjectiveType5 = SQLGetData(5);
	string sObjectiveType6 = SQLGetData(6);
	string sObjectiveType7 = SQLGetData(7);
	string sObjectiveType8 = SQLGetData(8);
	string sObjectiveType9 = SQLGetData(9);
	string sObjectiveType10 = SQLGetData(10);
	
	int iGotItems1 = LEG_QUEST_CheckObjectiveInventoryItems(oPC, sQuestID, iPlayerStep, sObjectiveType1, iObjective1, 1);
	int iGotItems2 = LEG_QUEST_CheckObjectiveInventoryItems(oPC, sQuestID, iPlayerStep, sObjectiveType2, iObjective2, 2);
	int iGotItems3 = LEG_QUEST_CheckObjectiveInventoryItems(oPC, sQuestID, iPlayerStep, sObjectiveType3, iObjective3, 3);
	int iGotItems4 = LEG_QUEST_CheckObjectiveInventoryItems(oPC, sQuestID, iPlayerStep, sObjectiveType4, iObjective4, 4);
	int iGotItems5 = LEG_QUEST_CheckObjectiveInventoryItems(oPC, sQuestID, iPlayerStep, sObjectiveType5, iObjective5, 5);
	int iGotItems6 = LEG_QUEST_CheckObjectiveInventoryItems(oPC, sQuestID, iPlayerStep, sObjectiveType6, iObjective6, 6);
	int iGotItems7 = LEG_QUEST_CheckObjectiveInventoryItems(oPC, sQuestID, iPlayerStep, sObjectiveType7, iObjective7, 7);
	int iGotItems8 = LEG_QUEST_CheckObjectiveInventoryItems(oPC, sQuestID, iPlayerStep, sObjectiveType8, iObjective8, 8);
	int iGotItems9 = LEG_QUEST_CheckObjectiveInventoryItems(oPC, sQuestID, iPlayerStep, sObjectiveType9, iObjective9, 9);
	int iGotItems10 = LEG_QUEST_CheckObjectiveInventoryItems(oPC, sQuestID, iPlayerStep, sObjectiveType10, iObjective10, 10);
	
	// If the PC has accomplished all the objectives EXCEPT for the Special SKIP objective, return true.
	if (iGotItems1 == FALSE || iGotItems2 == FALSE || iGotItems3 == FALSE || iGotItems4 == FALSE || iGotItems5 == FALSE || iGotItems6 == FALSE || iGotItems7 == FALSE || iGotItems8 == FALSE || iGotItems9 == FALSE || iGotItems10 == FALSE)
	{
		if (!iIconRefresh)
			SendMessageToPC(oPC, "You are missing some required items");
			
		return FALSE;
	}
	
	// If ALL of the objectives are complete then we return TRUE.
	if (iPCObjective1 != iObjective1 || iPCObjective2 != iObjective2 || iPCObjective3 != iObjective3 || iPCObjective4 != iObjective4 || iPCObjective5 != iObjective5 || iPCObjective6 != iObjective6 || iPCObjective7 != iObjective7 || iPCObjective8 != iObjective8 || iPCObjective9 != iObjective9 || iPCObjective10 != iObjective10)
		return FALSE;
	else
		return TRUE;
}



// //////////////////////////////////////////////////
// LEG_QUEST_CheckObjective
// //////////////////////////////////////////////////
int LEG_QUEST_CheckObjective(object oPC, string sQuestID, int iPlayerStep, int iObjective)
{
	// Get the row from the databae.  We'll grab what vars we need depending on
	// where the PC is in the quest.
	SQLExecDirect("SELECT * FROM `" + QUESTPREFIX + "_mainquests` AS t1, `" + QUESTPREFIX + "_questheader` AS t2 WHERE t1.`QuestID`=t2.`QuestID` AND t1.`QuestID` = " + sQuestID + " AND t1.`QuestNPC` = " + IntToString(iPlayerStep));
	SQLFetch();
	int iObjectiveNeed = StringToInt(SQLGetData(13 + iObjective));
	int iPCObjectiveHas = GetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ" + IntToString(iObjective));

	// Added this nastiness to confirm PC has actual inventory count of any items they're "supposed" to have
	// for those objective types that require items.
	SQLExecDirect("SELECT `ObjType1`,`ObjType2`,`ObjType3`,`ObjType4`,`ObjType5`,`ObjType6`,`ObjType7`,`ObjType8`,`ObjType9`,`ObjType10` FROM `" + QUESTPREFIX + "_objrefs` WHERE `QuestID` = " + sQuestID + " AND `QuestNPC` = " + IntToString(iPlayerStep));
	SQLFetch();
	string sObjectiveType = SQLGetData(iObjective);
	int iGotItems = LEG_QUEST_CheckObjectiveInventoryItems(oPC, sQuestID, iPlayerStep, sObjectiveType, iObjectiveNeed, iObjective);
	
	// If the PC has accomplished all the objectives EXCEPT for the Special SKIP objective, return true.
	if (iGotItems == FALSE)
	{
		return FALSE;
	}
	
	// If ALL of the objectives are complete then we return TRUE.
	if (iPCObjectiveHas != iObjectiveNeed)
		return FALSE;
	else
		return TRUE;
}



// //////////////////////////////////////////////////
// LEG_QUEST_RewardsText
// //////////////////////////////////////////////////
string LEG_QUEST_RewardsText(string sRewards)
{
	// If we're passing no gold, then the reward is just XP.
	if (sRewards == "0" || sRewards == "")
		sRewards = "Rewards: <color=Yellow>Experience Points</color>";
	else
		sRewards = "Rewards: <color=Yellow>" + sRewards + " Gold</color>"; 
	
	// Return the pretty formated result.
	return sRewards;
}



// //////////////////////////////////////////////////
// LEG_QUEST_ChallengeColor
// //////////////////////////////////////////////////
string LEG_QUEST_ChallengeColor(object oPC, int iLevel)
{
	// Find out the level of the PC and compare.
	string sColor;
	int iChallenge = GetTotalLevels(oPC, FALSE) - iLevel;
	
	// If the result of the Player's Level and the Quest Level is identified as below
	// we want to set the color of what we are displaying to match this difficulty.
	// PURPLE = 	PC Is 4 Levels Lower than Quest
	// RED =	 	PC is 3 Levels Lower than Quest
	// YELLOW = 	PC is 2 Levels Lower than Quest
	// GREEN = 		PC is 1 level lower than quest, AT the quest or 1 level higher than quest.
	// CYAN = 		PC is 2 Levels Higher than Quest
	// WHITE =		PC is 3 Levels Higher than Quest
	// GREY = 		PC is 4 Levels Higher than Quest
	switch (iChallenge)
	{
		case -4:
			sColor = COLOUR_LIGHT_PURPLE;
			break;
		case -3:
			sColor = COLOUR_RED;
			break;
		case -2:
			sColor = COLOUR_YELLOW;
			break;
		case -1:
		case 0:
		case 1:
			sColor = COLOUR_LIGHT_GREEN;
			break;
		case 2:
			sColor = COLOUR_LIGHT_CYAN;
			break;
		case 3:
			sColor = COLOUR_WHITE;
			break;
		case 4:
			sColor = COLOUR_LIGHT_GREY;
			break;
	}		
	
	// If of course the PC is more than 5 levels below, automatic Purple
	// And if they are more than 5 levels above the quest, automatic Grey
	if (iChallenge < -4)
		sColor = COLOUR_LIGHT_PURPLE;
	else if (iChallenge	> 4)
		sColor = COLOUR_LIGHT_GREY;

	// Return our Color.
	return sColor;
}




// //////////////////////////////////////////////////
// LEG_QUEST_FireQuestGUI
// //////////////////////////////////////////////////
void LEG_QUEST_FireQuestGUI(string sGUI, string sGUIFile, object oPC, int iNPCPosition, string sQuestID, int iAdvanceNPC = 0, int iAdvanceOBJ = 0)
{
	// Get the quest row from the database for this NPC/Object.  We'll grab what vars we need depending on
	// where the PC is in the quest.
	SQLExecDirect("SELECT * FROM `" + QUESTPREFIX + "_mainquests` AS t1, `" + QUESTPREFIX + "_questheader` AS t2 WHERE t1.`QuestID`=t2.`QuestID` AND t1.`QuestID` = " + sQuestID + " AND t1.`QuestNPC` = " + IntToString(iNPCPosition));	
	SQLFetch();

	// Start pulling the data for the quest step out of the result.
	string sObjectiveText1 = SQLGetData(4);
	string sObjectiveText2 = SQLGetData(5);
	string sObjectiveText3 = SQLGetData(6);
	string sObjectiveText4 = SQLGetData(7);
	string sObjectiveText5 = SQLGetData(8);
	string sObjectiveText6 = SQLGetData(9);
	string sObjectiveText7 = SQLGetData(10);
	string sObjectiveText8 = SQLGetData(11);
	string sObjectiveText9 = SQLGetData(12);
	string sObjectiveText10 = SQLGetData(13);					
	int iObjective1 = StringToInt(SQLGetData(14));
	int iObjective2 = StringToInt(SQLGetData(15));
	int iObjective3 = StringToInt(SQLGetData(16));
	int iObjective4 = StringToInt(SQLGetData(17));
	int iObjective5 = StringToInt(SQLGetData(18));
	int iObjective6 = StringToInt(SQLGetData(19));
	int iObjective7 = StringToInt(SQLGetData(20));
	int iObjective8 = StringToInt(SQLGetData(21));
	int iObjective9 = StringToInt(SQLGetData(22));			
	int iObjective10 = StringToInt(SQLGetData(23));	
	string sOfferText = SQLGetData(24);
	string sContinueText = SQLGetData(25);
	string sFinishText = SQLGetData(26);
	string sTitle = SQLGetData(27);
	int iQuestType = StringToInt(SQLGetData(28));	
	string sRewards = SQLGetData(30);
	int iLevel = StringToInt(SQLGetData(31));
	int iGroupType = StringToInt(SQLGetData(32));
	
	// Initialize some variables that we'll use in a moment.
	string sIcon1;
	string sDescription1;
	string sIcon2;
	string sDescription2;
	string sIcon3;
	string sDescription3;
	string sQty;
	
	// This is required as a result of the bug found now that the quest tool can select pre-existing items
	// from the items table as rewards.  The order of the items go out of sync.
	int iRewardCounter = 0;
	SQLExecDirect("SELECT * FROM `" + QUESTPREFIX + "_questrewards` AS t1, `" + QUESTPREFIX + "_rewarditems` AS t2 WHERE t1.`QuestID`='" + sQuestID + "' AND t1.`Action`='GIVEITEM' AND t1.`Parameter1` = t2.`ResRef`");
	while (SQLFetch())
	{
		// Kick off a counter.  We allow up to 3 rewards.
		iRewardCounter++;
		
		// For the each reward, let's grab the first items details such as its icon, description and how many we get.
		if (iRewardCounter == 1)
		{
			sIcon1 = SQLGetData(10);
			sDescription1 = SQLGetData(9);
			sQty = SQLGetData(4);
			if (StringToInt(sQty) > 1)
			{
				sDescription1 = sDescription1 + " x " + sQty;	
			}
			sDescription1 = LEG_COMMON_TextRemoveBrace(sDescription1, 1, 0);
		}		
		else if (iRewardCounter == 2)
		{
			sIcon2 = SQLGetData(10);
			sDescription2 = SQLGetData(9);
			sQty = SQLGetData(4);
			if (StringToInt(sQty) > 1)
			{
				sDescription2 = sDescription2 + " x " + sQty;	
			}
			sDescription2 = LEG_COMMON_TextRemoveBrace(sDescription2, 1, 0);
		}
		else
		{
			sIcon3 = SQLGetData(10);
			sDescription3 = SQLGetData(9);
			sQty = SQLGetData(4);
			if (StringToInt(sQty) > 1)
			{
				sDescription3 = sDescription3 + " x " + sQty;	
			}
			sDescription3 = LEG_COMMON_TextRemoveBrace(sDescription3, 1, 0);
		}
	}
	
	// Setup what TEXT based rewards we're going to display in the GUI.  These are usually the amount
	// of gold, or just Experience Points etc.  Also grab the color of the difficulty of the quest based
	// on the players level and the recommended quest level.
	sRewards = LEG_QUEST_RewardsText(sRewards);
	string sColor = LEG_QUEST_ChallengeColor(oPC, iLevel);
	string sMainText, sTypeIcon;
	int iBribe, iSkill1, iSkill2;
	string sReluctantText = "", sFailText = "";
	
	// Make the offer text pretty, assuming this is an OFFER or CONTINUE GUI.
	if (sGUI == "leg_quest_offer" || sGUI == "leg_quest_continue" || sGUI == "leg_quest_continue_bribe" || sGUI == "leg_quest_continue_bribe_skill" || sGUI == "leg_quest_continue_all" || sGUI == "leg_quest_continue_skill1" || sGUI == "leg_quest_continue_skills" || sGUI == "leg_quest_continue_fail")
	{
		int iStandardGUI = FALSE;
		if (sGUI == "leg_quest_offer" || sGUI == "leg_quest_continue")
			iStandardGUI = TRUE;
		else
		{
			// We're reluctant, get the reluctant text.
			SQLExecDirect("SELECT * FROM `" + QUESTPREFIX + "_skills` WHERE `QuestID` = '" + sQuestID + "' AND `NPCID` = '" + IntToString(iNPCPosition) + "';");
			while(SQLFetch())
			{
				sReluctantText = SQLGetData(3);
				sFailText = SQLGetData(4);
				iBribe = StringToInt(SQLGetData(6));
				iSkill1 = StringToInt(SQLGetData(9));
				iSkill2 = StringToInt(SQLGetData(10));
			}
		}
		
		// Setup some Vars
		string sObj1, sObj2, sObj3, sObj4, sObj5, sObj6, sObj7, sObj8, sObj9, sObj10;
		
		// We throw in this code to identify quantities in objectives.  Sometimes, we have to speak to an NPC however
		// we use the Quantity field in the database table to identify which NPC we want hehe.. sneaky.  BUT this
		// causes us a little problem in that the NPC ID looks like a quantity in the GUI so we accomodate for this
		// using the below.
		if (FindSubString(GetStringLowerCase(sObjectiveText1), "speak") < 0 && FindSubString(GetStringLowerCase(sObjectiveText1), "deliver") < 0 && FindSubString(GetStringLowerCase(sObjectiveText1), "visit") < 0 && FindSubString(GetStringLowerCase(sObjectiveText1), "discover") < 0 && FindSubString(GetStringLowerCase(sObjectiveText1), "escort") < 0 && iObjective1 != 1 && LEG_QUEST_GetOBJDB(oPC, sQuestID, iNPCPosition, 1, "OBJHideQty") != "1")
			sObj1 = "(" + IntToString(iObjective1) + ")";
		if (FindSubString(GetStringLowerCase(sObjectiveText2), "speak") < 0 && FindSubString(GetStringLowerCase(sObjectiveText2), "deliver") < 0 && FindSubString(GetStringLowerCase(sObjectiveText2), "visit") < 0 && FindSubString(GetStringLowerCase(sObjectiveText2), "discover") < 0 && FindSubString(GetStringLowerCase(sObjectiveText2), "escort") < 0 && iObjective2 != 1 && LEG_QUEST_GetOBJDB(oPC, sQuestID, iNPCPosition, 2, "OBJHideQty") != "1")
			sObj2 = "(" + IntToString(iObjective2) + ")";
		if (FindSubString(GetStringLowerCase(sObjectiveText3), "speak") < 0 && FindSubString(GetStringLowerCase(sObjectiveText3), "deliver") < 0 && FindSubString(GetStringLowerCase(sObjectiveText3), "visit") < 0 && FindSubString(GetStringLowerCase(sObjectiveText3), "discover") < 0 && FindSubString(GetStringLowerCase(sObjectiveText3), "escort") < 0 && iObjective3 != 1 && LEG_QUEST_GetOBJDB(oPC, sQuestID, iNPCPosition, 3, "OBJHideQty") != "1")		
			sObj3 = "(" + IntToString(iObjective3) + ")";
		if (FindSubString(GetStringLowerCase(sObjectiveText4), "speak") < 0 && FindSubString(GetStringLowerCase(sObjectiveText4), "deliver") < 0 && FindSubString(GetStringLowerCase(sObjectiveText4), "visit") < 0 && FindSubString(GetStringLowerCase(sObjectiveText4), "discover") < 0 && FindSubString(GetStringLowerCase(sObjectiveText4), "escort") < 0 && iObjective4 != 1 && LEG_QUEST_GetOBJDB(oPC, sQuestID, iNPCPosition, 4, "OBJHideQty") != "1")
			sObj4 = "(" + IntToString(iObjective4) + ")";
		if (FindSubString(GetStringLowerCase(sObjectiveText5), "speak") < 0 && FindSubString(GetStringLowerCase(sObjectiveText5), "deliver") < 0 && FindSubString(GetStringLowerCase(sObjectiveText5), "visit") < 0 && FindSubString(GetStringLowerCase(sObjectiveText5), "discover") < 0 && FindSubString(GetStringLowerCase(sObjectiveText5), "escort") < 0 && iObjective5 != 1 && LEG_QUEST_GetOBJDB(oPC, sQuestID, iNPCPosition, 5, "OBJHideQty") != "1")
			sObj5 = "(" + IntToString(iObjective5) + ")";
		if (FindSubString(GetStringLowerCase(sObjectiveText6), "speak") < 0 && FindSubString(GetStringLowerCase(sObjectiveText6), "deliver") < 0 && FindSubString(GetStringLowerCase(sObjectiveText6), "visit") < 0 && FindSubString(GetStringLowerCase(sObjectiveText6), "discover") < 0 && FindSubString(GetStringLowerCase(sObjectiveText6), "escort") < 0 && iObjective6 != 1 && LEG_QUEST_GetOBJDB(oPC, sQuestID, iNPCPosition, 6, "OBJHideQty") != "1")
			sObj6 = "(" + IntToString(iObjective6) + ")";
		if (FindSubString(GetStringLowerCase(sObjectiveText7), "speak") < 0 && FindSubString(GetStringLowerCase(sObjectiveText7), "deliver") < 0 && FindSubString(GetStringLowerCase(sObjectiveText7), "visit") < 0 && FindSubString(GetStringLowerCase(sObjectiveText7), "discover") < 0 && FindSubString(GetStringLowerCase(sObjectiveText7), "escort") < 0 && iObjective7 != 1 && LEG_QUEST_GetOBJDB(oPC, sQuestID, iNPCPosition, 7, "OBJHideQty") != "1")
			sObj7 = "(" + IntToString(iObjective7) + ")";
		if (FindSubString(GetStringLowerCase(sObjectiveText8), "speak") < 0 && FindSubString(GetStringLowerCase(sObjectiveText8), "deliver") < 0 && FindSubString(GetStringLowerCase(sObjectiveText8), "visit") < 0 && FindSubString(GetStringLowerCase(sObjectiveText8), "discover") < 0 && FindSubString(GetStringLowerCase(sObjectiveText8), "escort") < 0 && iObjective8 != 1 && LEG_QUEST_GetOBJDB(oPC, sQuestID, iNPCPosition, 8, "OBJHideQty") != "1")
			sObj8 = "(" + IntToString(iObjective8) + ")";
		if (FindSubString(GetStringLowerCase(sObjectiveText9), "speak") < 0 && FindSubString(GetStringLowerCase(sObjectiveText9), "deliver") < 0 && FindSubString(GetStringLowerCase(sObjectiveText9), "visit") < 0 && FindSubString(GetStringLowerCase(sObjectiveText9), "discover") < 0 && FindSubString(GetStringLowerCase(sObjectiveText9), "escort") < 0 && iObjective9 != 1 && LEG_QUEST_GetOBJDB(oPC, sQuestID, iNPCPosition, 9, "OBJHideQty") != "1")
			sObj9 = "(" + IntToString(iObjective9) + ")";
		if (FindSubString(GetStringLowerCase(sObjectiveText10), "speak") < 0 && FindSubString(GetStringLowerCase(sObjectiveText10), "deliver") < 0 && FindSubString(GetStringLowerCase(sObjectiveText10), "visit") < 0 && FindSubString(GetStringLowerCase(sObjectiveText10), "discover") < 0 && FindSubString(GetStringLowerCase(sObjectiveText10), "escort") < 0 && iObjective10 != 1 && LEG_QUEST_GetOBJDB(oPC, sQuestID, iNPCPosition, 10, "OBJHideQty") != "1")
			sObj10 = "(" + IntToString(iObjective10) + ")";


		// Make the Offer/Continue Text a Pretty Yellow
		sOfferText = sOfferText + "\n\n";
		sContinueText = sContinueText + "\n\n";
		if (iStandardGUI && LEG_QUEST_GetOBJDB(oPC, sQuestID, iNPCPosition, 1, "OBJHideSelf") != "1")
		{
			sOfferText = sOfferText + "\n<color=Yellow>" + sObjectiveText1 + " " + sObj1 + "</color>";
			sContinueText = sContinueText + "\n<color=Yellow>" + sObjectiveText1 + " " + sObj1 + "</color>";
		}
		
		// For each objective that we actually have, make their text pretty and append it to the main text.
		// Note that we don't show any "DONE" here for objectives as that is for the Journal, not the Offer/Cont/Fin 
		// GUI.
		if (iObjective2 && iStandardGUI && LEG_QUEST_GetOBJDB(oPC, sQuestID, iNPCPosition, 2, "OBJHideSelf") != "1")
		{
			sOfferText = sOfferText + "\n<color=Yellow>" + sObjectiveText2 + " " + sObj2 + "</color>";
			sContinueText = sContinueText + "\n<color=Yellow>" + sObjectiveText2 + " " + sObj2 + "</color>";
		}
		if (iObjective3 && iStandardGUI && LEG_QUEST_GetOBJDB(oPC, sQuestID, iNPCPosition, 3, "OBJHideSelf") != "1")
		{
			sOfferText = sOfferText + "\n<color=Yellow>" + sObjectiveText3 + " " + sObj3 + "</color>";
			sContinueText = sContinueText + "\n<color=Yellow>" + sObjectiveText3 + " " + sObj3 + "</color>";
		}
		if (iObjective4 && iStandardGUI && LEG_QUEST_GetOBJDB(oPC, sQuestID, iNPCPosition, 4, "OBJHideSelf") != "1")
		{
			sOfferText = sOfferText + "\n<color=Yellow>" + sObjectiveText4 + " " + sObj4 + "</color>";
			sContinueText = sContinueText + "\n<color=Yellow>" + sObjectiveText4 + " " + sObj4 + "</color>";
		}
		if (iObjective5 && iStandardGUI && LEG_QUEST_GetOBJDB(oPC, sQuestID, iNPCPosition, 5, "OBJHideSelf") != "1")
		{
			sOfferText = sOfferText + "\n<color=Yellow>" + sObjectiveText5 + " " + sObj5 + "</color>";
			sContinueText = sContinueText + "\n<color=Yellow>" + sObjectiveText5 + " " + sObj5 + "</color>";
		}
		if (iObjective6 && iStandardGUI && LEG_QUEST_GetOBJDB(oPC, sQuestID, iNPCPosition, 6, "OBJHideSelf") != "1")
		{
			sOfferText = sOfferText + "\n<color=Yellow>" + sObjectiveText6 + " " + sObj6 + "</color>";
			sContinueText = sContinueText + "\n<color=Yellow>" + sObjectiveText6 + " " + sObj6 + "</color>";
		}
		if (iObjective7 && iStandardGUI && LEG_QUEST_GetOBJDB(oPC, sQuestID, iNPCPosition, 7, "OBJHideSelf") != "1")
		{
			sOfferText = sOfferText + "\n<color=Yellow>" + sObjectiveText7 + " " + sObj7 + "</color>";
			sContinueText = sContinueText + "\n<color=Yellow>" + sObjectiveText7 + " " + sObj7 + "</color>";
		}
		if (iObjective8 && iStandardGUI && LEG_QUEST_GetOBJDB(oPC, sQuestID, iNPCPosition, 8, "OBJHideSelf") != "1")
		{
			sOfferText = sOfferText + "\n<color=Yellow>" + sObjectiveText8 + " " + sObj8 + "</color>";
			sContinueText = sContinueText + "\n<color=Yellow>" + sObjectiveText8 + " " + sObj8 + "</color>";
		}
		if (iObjective9 && iStandardGUI && LEG_QUEST_GetOBJDB(oPC, sQuestID, iNPCPosition, 9, "OBJHideSelf") != "1")
		{
			sOfferText = sOfferText + "\n<color=Yellow>" + sObjectiveText9 + " " + sObj9 + "</color>";
			sContinueText = sContinueText + "\n<color=Yellow>" + sObjectiveText9 + " " + sObj9 + "</color>";
		}
		if (iObjective10 && iStandardGUI && LEG_QUEST_GetOBJDB(oPC, sQuestID, iNPCPosition, 10, "OBJHideSelf") != "1")
		{
			sOfferText = sOfferText + "\n<color=Yellow>" + sObjectiveText10 + " " + sObj10 + "</color>";
			sContinueText = sContinueText + "\n<color=Yellow>" + sObjectiveText10 + " " + sObj10 + "</color>";
		}
		
		if (sGUI == "leg_quest_offer")
			sMainText = sOfferText;	
		else if (sGUI == "leg_quest_continue")
			sMainText = sContinueText;
		else if (sGUI == "leg_quest_continue_fail")
			sMainText = sFailText; 
		else
			sMainText = sReluctantText;
	}				
	else
		sMainText = sFinishText;
	
	// If there are no icons configured then clear any tga entry we may have picked up from the DB table.
	int iRewards = 0;
	if (sIcon1 == ".tga")
		sIcon1 = "";
	if (sIcon2 == ".tga")
		sIcon2 = "";
	if (sIcon3 == ".tga")
		sIcon3 = "";

	if (sIcon1 != "")
		iRewards = 1;		
	if (sIcon2 != "")
		iRewards = 2;		
	if (sIcon3 != "")
		iRewards = 3;		
	
		
	// Based on the group type specified when the quest is created, use the correct images.  These would
	// be included in the hakpak for this plugin.
	if (iGroupType == 0)
		sTypeIcon = "solo_normal.tga";
	else if (iGroupType == 1)
		sTypeIcon = "solo_hard.tga";
	else if (iGroupType == 2)
		sTypeIcon = "group_normal.tga";
	else if (iGroupType == 3)
		sTypeIcon = "group_hard.tga";
	else if (iGroupType == 4)
		sTypeIcon = "raid.tga";
	else if (iGroupType == 5)
		sTypeIcon = "crafting_normal.tga";
	else if (iGroupType == 6)
		sTypeIcon = "crafting_hard.tga";
				
	// Now open the GUI.  The GUI could be an Offer, a Continue or a Finish call based on what we asked this
	// function to do.  Pass all the information we pulled from the database off to the appropriate GUI file
	// that was passed to this function.
	DisplayGuiScreen(oPC, sGUI, FALSE, sGUIFile);			
	SetGUIObjectText(oPC, sGUI, "title", -1, sColor + sTitle + "</color>");
	SetGUITexture(oPC, sGUI, "TYPE1", sTypeIcon);						
	SetGUIObjectText(oPC, sGUI, "quest", -1, sMainText);
	SetLocalGUIVariable(oPC, sGUI, 1, sQuestID);
	SetLocalGUIVariable(oPC, sGUI, 2, IntToString(iNPCPosition));
	SetLocalGUIVariable(oPC, sGUI, 3, IntToString(iObjective1));
	SetLocalGUIVariable(oPC, sGUI, 4, IntToString(iObjective2));
	SetLocalGUIVariable(oPC, sGUI, 5, IntToString(iObjective3));
	SetLocalGUIVariable(oPC, sGUI, 6, IntToString(iObjective4));
	SetLocalGUIVariable(oPC, sGUI, 7, IntToString(iObjective5));
	SetLocalGUIVariable(oPC, sGUI, 8, IntToString(iAdvanceNPC));
	SetLocalGUIVariable(oPC, sGUI, 10, IntToString(iRewards));
	SetLocalGUIVariable(oPC, sGUI, 11, IntToString(iQuestType));	
	SetLocalGUIVariable(oPC, sGUI, 12, IntToString(iAdvanceOBJ));	
	SetGUIObjectText(oPC, sGUI, "REWARDS", -1, sRewards);

	// If this is an OFFER or CONTINUE then lets set the appropriate 3 rewards text fields
	if (sGUI == "leg_quest_offer" || sGUI == "leg_quest_continue" || sGUI == "leg_quest_continue_bribe" || sGUI == "leg_quest_continue_bribe_skill" || sGUI == "leg_quest_continue_all" || sGUI == "leg_quest_continue_skill1" || sGUI == "leg_quest_continue_skills")
	{
		SetGUIObjectText(oPC, sGUI, "OFFER_REWARDS1", -1, sDescription1);
		SetGUIObjectText(oPC, sGUI, "OFFER_REWARDS2", -1, sDescription2);
		SetGUIObjectText(oPC, sGUI, "OFFER_REWARDS3", -1, sDescription3);
		SetGUITexture(oPC, sGUI, "OFFERED_ICON1", sIcon1);
		SetGUITexture(oPC, sGUI, "OFFERED_ICON2", sIcon2);			
		SetGUITexture(oPC, sGUI, "OFFERED_ICON3", sIcon3);
		

			if (sGUI == "leg_quest_continue_bribe")
			{
				SetGUIObjectText(oPC, sGUI, "BribeButton", -1, IntToString(iBribe) + " GP");	
			}
			else if (sGUI == "leg_quest_continue_bribe_skill")
			{
				SetGUIObjectText(oPC, sGUI, "BribeButton", -1, IntToString(iBribe) + " GP");	
				SetGUIObjectText(oPC, sGUI, "Skill1Button", -1, Get2DAString("skills", "LABEL", iSkill1));
			}
			else if (sGUI == "leg_quest_continue_all")
			{
				SetGUIObjectText(oPC, sGUI, "BribeButton", -1, IntToString(iBribe) + " GP");	
				SetGUIObjectText(oPC, sGUI, "Skill1Button", -1, Get2DAString("skills", "LABEL", iSkill1));				
				SetGUIObjectText(oPC, sGUI, "Skill2Button", -1, Get2DAString("skills", "LABEL", iSkill2));
			}
			else if (sGUI == "leg_quest_continue_skill1")
			{
				SetGUIObjectText(oPC, sGUI, "Skill1Button", -1, Get2DAString("skills", "LABEL", iSkill1));
			}
			else if (sGUI == "leg_quest_continue_skills")
			{
				SetGUIObjectText(oPC, sGUI, "Skill1Button", -1, Get2DAString("skills", "LABEL", iSkill1));
				SetGUIObjectText(oPC, sGUI, "Skill2Button", -1, Get2DAString("skills", "LABEL", iSkill2));				
			}
		
		
	}
	else if(sGUI == "leg_quest_continue_fail")
	{
		// Don't do anything special for fail text.
			
	}
	else
	{		
		// Otherwise, this is a Finish GUI and the 3 rewards are clickable boxes the PC gets to choose from
		// so populating that data is a little different.
		if (sDescription1 != "")
		{
			AddListBoxRow(oPC, sGUI, "REWARDS_LISTBOX", "ROW_1", "LISTBOX_ITEM_TEXT=" + sDescription1, "LISTBOX_ITEM_ICON=" + sIcon1, "15=1", "");
		}
		if (sDescription2 != "")
		{
			SetGUIObjectText(oPC, sGUI, "SELECT_REWARDS", -1, "Select a Reward:");
			AddListBoxRow(oPC, sGUI, "REWARDS_LISTBOX", "ROW_2", "LISTBOX_ITEM_TEXT=" + sDescription2, "LISTBOX_ITEM_ICON=" + sIcon2, "15=2", "");
		}
		if (sDescription3 != "")
		{
			AddListBoxRow(oPC, sGUI, "REWARDS_LISTBOX", "ROW_3", "LISTBOX_ITEM_TEXT=" + sDescription3, "LISTBOX_ITEM_ICON=" + sIcon3, "15=3", "");
		}
	}
}




// //////////////////////////////////////////////////
// LEG_QUEST_RefreshQuestIcon
// //////////////////////////////////////////////////
void LEG_QUEST_RefreshQuestIcon(object oNPC, object oMyIcon, object oPC)
{
	string sQuestID;
	int iNPCID;
	object oTrap;
	
	if (GetIsPC(oNPC))
		return;
	
	if (!GetIsPC(oPC))
		return;
	
	if (GetPCPlayerName(oPC) == "")
		return;

	if (!GetIsObjectValid(oMyIcon))
		return;
				
	// My Icon doesn't have a trap.  Better create one.
	CreateTrapOnObject(TRAP_BASE_TYPE_EPIC_FIRE, oMyIcon);
	oTrap = GetNearestTrapToObject(oNPC, FALSE);
	SetTrapDetectDC(oTrap, 250);
	SetTrapDisarmable(oTrap, FALSE);
	SetTrapRecoverable(oTrap, FALSE);
	
	
	// I have my Trap on my icon.  Should I light it up for this PC?
	int iPCStep;
	int iTotalQuests = GetLocalInt(oNPC, "LEG_QUEST_TotalQuests");
	int iCount;
	string sCount;
	for (iCount=1; iCount <= iTotalQuests; iCount++)
	{
		sQuestID = GetLocalString(oNPC, "LEG_QUEST_QuestID_" + IntToString(iCount));
		iNPCID = GetLocalInt(oNPC, "LEG_QUEST_NPCID_" + IntToString(iCount));
		iPCStep = GetLocalInt(oPC, "QuestID_" + sQuestID + "_NPC");
		sCount = IntToString(iCount);
		
		// If I'm not a quest NPC, then get me out.
		if (iNPCID == 0)
			return;
			
		// If I have a quest for the PC then...
		if (iPCStep == iNPCID)
		{
			
			//if (GetTag(oNPC) == "grannyflux")
//			SpeakString(GetName(oNPC) + " I'm in the = Loop", TALKVOLUME_SHOUT);

			// If the PC has all the objectives for this NPC.
			if (LEG_QUEST_CheckObjectives(oPC, sQuestID, iNPCID, 1))
			{
				//SpeakString(GetName(oNPC) + " I'm in the = Loop, Quest ID: " + sQuestID, TALKVOLUME_SHOUT);
				SetTrapDetectedBy(oTrap, oPC);	
			}
			// If the PC doesn't have all the objectives BUT the NPC is reluctant and the PC
			// hasn't resolved it yet.  Though we also only want to do this if the PC is not in 
			// a Failure wait state.
			else if (GetLocalInt(oNPC, "LEG_QUEST_Reluctant_" + sCount))
			{
				int iTimeSystem = GetLocalInt(GetModule(), "LEG_TIME_ACTIVE");
				string sTableID = LEG_COMMON_GetPC2Table(oPC);
				int iReluctantPassed = GetLocalInt(oPC, "QuestID_" + sQuestID + "_" + IntToString(iNPCID) + "_ReluctantPassed");
				
				// Check for Failure Wait State.
				int iSkillFail = GetLocalInt(oPC, "QuestID_" + sQuestID + "_FailTime");
				if (!iSkillFail && iTimeSystem)
				{
					// Check database just in case.
					iSkillFail = GetPersistentInt(oPC, "QuestID_" + sQuestID + "_FailTime", sTableID);
				}
				
				if (!iReluctantPassed && iSkillFail < LEG_COMMON_TimeStamp())
				{
					//SpeakString(GetName(oNPC) + " I'm in the = Loop, Reluctant section, Quest ID: " + sQuestID, TALKVOLUME_SHOUT);
					SetTrapDetectedBy(oTrap, oPC);	
				}
			}
		}
		else if (iPCStep == 0 || iPCStep == 998)
		{
			//if (GetTag(oNPC) == "grannyflux")
				//SpeakString(GetName(oNPC) + " I'm in the Step = 0 or 998 Loop", TALKVOLUME_SHOUT);

			string sRequirement = GetLocalString(oNPC, "LEG_QUEST_Requirement_" + sCount);
			string sQuestStarted = GetLocalString(oNPC, "LEG_QUEST_QuestStarted_" + sCount);
			
			if (GetLocalInt(oPC, "QuestID_" + sRequirement + "_NPC") == 999 || sRequirement == "")
			{
			
				// Create a name for the table structure for this player.  In this case, we're looking at
				// the "quests" table for this PC.
				string sTableID = LEG_COMMON_GetPC2Table(oPC);
								
				int nNextRepeat = GetPersistentInt(oPC, "QuestID_" + sQuestID + "_NextRepeat", sTableID);
				
				if (nNextRepeat == 0)
					nNextRepeat = GetLocalInt(oPC, "QuestID_" + sQuestID + "_NextRepeat");
					
				// If the timer has not passed, then fire the oneliner.	
				if (nNextRepeat > LEG_COMMON_TimeStamp() && iPCStep == 998)
					return;				
					
				if (GetLocalInt(oNPC, "LEG_QUEST_Starter_" + sCount))
				{
					//SpeakString(GetName(oNPC) + " I'm a new quest, player needs to talk to me. Setting my Trap Detected");
					// We've already checked if I need a specific quest finished via the sRequirement variable, but
					// what if I simply need a different quest started (not necessarily finished).
					if (GetLocalInt(oPC, "QuestID_" + sQuestStarted + "_NPC") > 0 || sQuestStarted == "")
					{
						// What about the other requirements to start this quest like Level, Race, Class, Item, Alignment, Feat???
						if (LEG_QUEST_CheckQuestRequirements(oPC, oNPC, sCount))
						{
							//SpeakString(GetName(oNPC) + " I'm in the Step = 0 or 998 Loop, Quest ID: " + sQuestID, TALKVOLUME_SHOUT);
							SetTrapDetectedBy(oTrap, oPC);	
						}
					}
				}
			}
		}
		// Well it looks like the PC has a few objectives that need completing, BUT!  There is one
		// way I could still want to talk to the player and that's if I'm one of those NPC's that have
		// been referred to the PC by another NPC.	
		else if (GetLocalInt(oPC, "QuestID_" + sQuestID + "_NPC") == GetLocalInt(oNPC, "LEG_QUEST_ObjectiveFor_" + IntToString(iCount)) && GetLocalInt(oNPC, "LEG_QUEST_IsObjective_" + IntToString(iCount)))
		{
			//if (GetTag(oNPC) == "grannyflux")
			//	SpeakString(GetName(oNPC) + " I'm in the Talk to Next Loop", TALKVOLUME_SHOUT);
				
			string sRequirement = GetLocalString(oNPC, "LEG_QUEST_Requirement_" + IntToString(iCount));
			string sQuestStarted = GetLocalString(oNPC, "LEG_QUEST_QuestStarted_" + IntToString(iCount));
			if (GetLocalInt(oPC, "QuestID_" + sRequirement + "_NPC") == 999 || sRequirement == "")
			{
				if (GetLocalInt(oPC, "QuestID_" + sQuestStarted + "_NPC") > 0 || sQuestStarted == "")
				{
					// One last thing to check.  If this NPC is only allowed to be talked to, AFTER the player
					// has completed any other objectives FIRST.
					string sCount = IntToString(iCount);
					int iPlayerStep = GetLocalInt(oPC, "QuestID_" + sQuestID + "_NPC");
					int iSkipOBJ = GetLocalInt(oNPC, "LEG_QUEST_IsObjective_" + sCount);

					if ((GetLocalInt(oNPC, "LEG_QUEST_OtherObjectivesDone_" + sCount) && LEG_QUEST_CheckOtherObjectives(oPC, sQuestID, iPlayerStep, iSkipOBJ, 1)) || !GetLocalInt(oNPC, "LEG_QUEST_OtherObjectivesDone_" + IntToString(iCount)))
					{
						// If this objective is currently active and available for a PC to perform
						if (LEG_QUEST_GetOBJ(oPC, sQuestID, iPlayerStep, iSkipOBJ, "OBJInactive") != "1")
						{
							// Even though I am the current NPC's objective, I may not be an ACTIVE objective yet until the PC
							// passes any reluctance the current NPC may have.
							int iCurrentNPCStep = GetLocalInt(oNPC, "LEG_QUEST_ObjectiveFor_" + IntToString(iCount));
							string sTableID = LEG_COMMON_GetPC2Table(oPC);
							int iReluctantPassed = GetLocalInt(oPC, "QuestID_" + sQuestID + "_" + IntToString(iCurrentNPCStep) + "_ReluctantPassed");
							
							if (iReluctantPassed)
							{
								//SpeakString(GetName(oNPC) + " I'm in the Talk to Next Loop, Quest ID: " + sQuestID, TALKVOLUME_SHOUT);
								SetTrapDetectedBy(oTrap, oPC);	
							}
						}
					}
				}
			}
		}
	}
}


// //////////////////////////////////////////////////
// LEG_QUEST_GiveFeat
// //////////////////////////////////////////////////
void LEG_QUEST_GiveFeat(object oPC, int iFeat)
{
	effect eEffect;
	switch (iFeat)
	{
		case 2871:		// Give the Legends Ancient Lore Feat
					    // +2 Lore
						if (GetHasFeat(iFeat, oPC, TRUE))
						{
							eEffect = SupernaturalEffect(ExtraordinaryEffect(EffectSkillIncrease(SKILL_LORE, 2)));
							ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oPC);
						}
						break;
		
		case 2872:		// Give the Venturing Forth feat for portalling from Eleden.
						if (GetHasFeat(iFeat, oPC, TRUE))
						{
							// Don't do anything for this feat.  It is for portalling only.
						}
						break;	
		
		case 2873:		// Give The Chronicles of Valanthia Feat
						// +2 HP
						if (GetHasFeat(iFeat, oPC, TRUE))
						{
							eEffect = SupernaturalEffect(ExtraordinaryEffect(EffectBonusHitpoints(2)));
							ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oPC);
						}
						break;
	}					
}


// //////////////////////////////////////////////////
// LEG_QUEST_QuestCreditItem
// //////////////////////////////////////////////////
void LEG_QUEST_QuestCreditItem(string sItem, object oTarget, string sQuestID = "", int iObjective = 0, int iOldCondition = 0, int iStackSize = 1, int iNotifyTarget = 1, int iPCHas = 1, int iPCNeeds = 1, string sPlaceID = "", int iAdvanceNPC = 0, int iNPCObjective = 0, string sAltMessage = "", int iMyFlagID = 0, object oObject = OBJECT_SELF)
{
	// You were supposed to complete this objective before your timer ran out!
	if (!LEG_QUEST_CheckTimerForCredit(sQuestID, oTarget, iNPCObjective, iObjective))
		return;
	
	// Create the item for the PC!
	object oItem;
	object oQuestBag = LEG_COMMON_GetInventoryItemByTag(oTarget, "leg_quest_questbag");
	if (GetIsObjectValid(oQuestBag))
		oItem = LEG_COMMON_CreateItem(oTarget, sItem, iStackSize, oQuestBag);
	else
		oItem = LEG_COMMON_CreateItem(oTarget, sItem, iStackSize);
	
	// Add the normal vars to the item to support dropping (NOTE, splitting stacks cause one of the 2 new stacks to lose vars - engine bug)
	SetLocalString(oItem, "LEG_QUEST_QuestID_1", sQuestID);
	SetLocalInt(oItem, "LEG_QUEST_IsObjective_1", iObjective);
	SetLocalInt(oItem, "LEG_QUEST_ObjectiveFor_1", iNPCObjective);
	SetLocalInt(oItem, "LEG_QUEST_PCNeeds_1", iPCNeeds);
					
	// We've just obtained an Item.  We should see if we should get credit for it from a quest.
	if (GetIsObjectValid(oItem))
	{
		// Notify the PC and save the credit.
		// Do a double check to ensure that our current "Has" actually matches what we have in inventory?
		int iActualInventory = LEG_COMMON_GetInventoryCount(oTarget, sItem);
		if (iActualInventory == iPCHas)
		{
			LEG_QUEST_ObjectiveCredit(sQuestID, oTarget, "Found", GetName(oItem), iPCHas, iPCNeeds, iObjective, sPlaceID, iNPCObjective, sAltMessage, iMyFlagID, oObject);
		}
		else
		{
			LEG_QUEST_ObjectiveCredit(sQuestID, oTarget, "Found", GetName(oItem), iActualInventory, iPCNeeds, iObjective, sPlaceID, iNPCObjective, sAltMessage, iMyFlagID, oObject);
		}
				
		// Notify the party that this member has looted something
		object oLeader = GetFactionLeader(oTarget);
		object oMember = GetFirstFactionMember(oLeader, TRUE);
	    while(oMember != OBJECT_INVALID)
	    {
			if (oMember != oTarget)		
				SendMessageToPC(oMember, GetName(oTarget) + " has aquired a " + GetName(oItem));
			oMember = GetNextFactionMember(oLeader, TRUE);
		}
	}
	else
	{
		// For some reason, we were not successful in creating the object.  It could be a result of inventory
		// being full or someone forgot to actually create the item in the toolset.  But let's pretend the
		// problem is inventory full because we NEVER forget to actually make the item do we?  DAMMIT!
		// Make it so the PC can re-loot this.
		SetLocalInt(oObject, GetPCPublicCDKey(oTarget), FALSE);
		string sTableID = LEG_COMMON_GetPC2Table(oTarget);
		
		// Is this a mob drop placeable?  If it is, we never stored this persistently so we don't need
		// to do this if thats the case
		if (!GetLocalInt(oObject, "MOBDeath"))
			SetPersistentInt(oTarget, sPlaceID, 0, 0, sTableID);
		
		// Show some sort of error message to the player
		LEG_COMMON_DisplayInfoBox(oTarget, "Unable to Get Item, Inventory Full or Missing Item!");
	}
}


// //////////////////////////////////////////////////
// LEG_QUEST_QuestCreditPlaceItem
// //////////////////////////////////////////////////
void LEG_QUEST_QuestCreditPlaceItem(string sItem, object oTarget, string sQuestID = "", int iObjective = 0, int iOldCondition = 0, int iStackSize = 1, int iNotifyTarget = 1, int iPCHas = 1, int iPCNeeds = 1, int iEffect = 0, string sPlaceID = "", int iNPCObjective = 0, string sAltMessage = "", int iMyFlagID = 0)
{
	// You were supposed to complete this objective before your timer ran out!
	if (!LEG_QUEST_CheckTimerForCredit(sQuestID, oTarget, iNPCObjective, iObjective))
		return;

	// First thing's first.  Destroy the item from the PC's inventory.
	string sItemName = LEG_COMMON_DestroyItems(oTarget, sItem, 1);
	object oIcon;

	// Save the fact that we have performed this objective.	
	LEG_QUEST_ObjectiveCredit(sQuestID, oTarget, "Placed", sItemName, iPCHas, iPCNeeds, iObjective, sPlaceID, iNPCObjective, sAltMessage, iMyFlagID);

	// If we need to throw out some fireworks or ground shakage or whatever.	
	DelayCommand(0.1, LEG_COMMON_VisualEffect(iEffect, OBJECT_SELF, OBJECT_INVALID));
}





// //////////////////////////////////////////////////
// LEG_QUEST_QuestCreditDestroyPlaceable
// //////////////////////////////////////////////////
void LEG_QUEST_QuestCreditDestroyPlaceable(string sItem, object oTarget, string sQuestID = "", int iObjective = 0, int iOldCondition = 0, int iStackSize = 1, int iNotifyTarget = 1, int iPCHas = 1, int iPCNeeds = 1, string sPlaceID = "", int iNPCObjective = 0, string sAltMessage = "", int iMyFlagID = 0)
{
	// You were supposed to complete this objective before your timer ran out!
	if (!LEG_QUEST_CheckTimerForCredit(sQuestID, oTarget, iNPCObjective, iObjective))
		return;
		
	// If we've used an item in this mess, let's destroy it.  This simulates dropping some dynamite down a hole or
	// something similar to that.
	if (sItem != "")
		LEG_COMMON_DestroyItems(oTarget, sItem, 1);

	// Time to announce the destruction of this placeable.
	string sPlaceableName = GetName(OBJECT_SELF);
	object oIcon;
	LEG_QUEST_ObjectiveCredit(sQuestID, oTarget, "Destroyed", sPlaceableName, iPCHas, iPCNeeds, iObjective, sPlaceID, iNPCObjective, sAltMessage, iMyFlagID);
		
	// Destroy the placeable, and let the Spawn plugin handle bringing it back.
	ExecuteScript("leg_quest_se_death", OBJECT_SELF);
	ExecuteScript("leg_spawn_ondeath", OBJECT_SELF);
	SetPlotFlag(OBJECT_SELF, FALSE);
	AssignCommand(OBJECT_SELF, SetIsDestroyable(TRUE, FALSE, FALSE));
	DestroyObject(OBJECT_SELF, 2.0, FALSE);
}


// //////////////////////////////////////////////////
// LEG_QUEST_QuestCreditExaminePlaceable
// //////////////////////////////////////////////////
void LEG_QUEST_QuestCreditExaminePlaceable(string sDiscovery, object oTarget, string sQuestID = "", int iObjective = 0, int iPCHas = 1, int iPCNeeds = 1, string sPlaceID = "", int iNPCObjective = 0, string sAltMessage = "", int iMyFlagID = 0)
{
	// You were supposed to complete this objective before your timer ran out!
	if (!LEG_QUEST_CheckTimerForCredit(sQuestID, oTarget, iNPCObjective, iObjective))
		return;
	
	// Not much to this other than just to give credit for looking at something.
	LEG_QUEST_ObjectiveCredit(sQuestID, oTarget, "Discovered", sDiscovery, iPCHas, iPCNeeds, iObjective, sPlaceID, iNPCObjective, sAltMessage, iMyFlagID);
}


// //////////////////////////////////////////////////
// LEG_QUEST_CheckTimerForCredit
// //////////////////////////////////////////////////
int LEG_QUEST_CheckTimerForCredit(string sQuestID, object oPC, int iNPCObjective, int iObjective)
{
	int iRequireTimer = GetLocalInt(OBJECT_SELF, "LEG_QUEST_TimerRequired_" + sQuestID);
	int iDeactivateTimer = GetLocalInt(OBJECT_SELF, "LEG_QUEST_TimerOff_" + sQuestID);
	if (iDeactivateTimer || iRequireTimer)
	{
		string sTimerQuestID = GetLocalString(oPC, "LEG_INFO_TimerBarQuestID");
		string sTableID = LEG_COMMON_GetPC2Table(oPC);
		if (sTimerQuestID == sQuestID && iDeactivateTimer)
		{
			// Who's timer is this and am I allowed to turn it off?
			if (GetLocalInt(oPC, "LEG_INFO_TimerBarNPC") == iNPCObjective)
			{
				// You DO have a timer running right now and it's for my quest AND you have one running so you are good to proceed
				// Let's turn off your timer and move on!
				ExecuteScript("leg_info_timerstop", oPC);
			}
		}
		else if (sTimerQuestID == sQuestID && !iDeactivateTimer)
		{
			return TRUE;
		}
		else if (iRequireTimer && GetPersistentInt(oPC, "QuestID_" + sQuestID + "_MOBTIMERFAILED" + IntToString(iNPCObjective), sTableID) != 1)
		{
			return TRUE;
		}
		else if (iRequireTimer && GetPersistentInt(oPC, "QuestID_" + sQuestID + "_MOBOBJTIMERFAILED" + IntToString(iObjective), sTableID) != 1)
		{
			// You don't have one running, but i REQUIRE one running so you are out of luck.  I get here if my timer was started by an objective VS an NPC.
			LEG_COMMON_DisplayInfoBox(oPC, "SORRY, YOUR TIMER RAN OUT BEFORE FINISHING THIS OBJECTIVE!");
			return FALSE;
		}
	}
	
	return TRUE;
}


// //////////////////////////////////////////////////
// LEG_QUEST_ObjectiveCredit
// //////////////////////////////////////////////////
void LEG_QUEST_ObjectiveCredit(string sQuestID, object oTarget, string sObjective, string sObjectiveTarget, int iPCHas, int iPCNeeds, int iObjective, string sPlaceID = "", int iNPCObjective = 0, string sAltMessage = "", int iMyFlagID = 0, object oObject = OBJECT_SELF)
{
	if (iPCHas > iPCNeeds)
		iPCHas = iPCNeeds;
					
	// We found our item, now let's get some credit for it.  First we inform the PC that we found this thing.
	// If our sObjectiveTarget text is blank, then send a message to the local chat channel only.
	if (sObjectiveTarget != "" && sAltMessage == "")
		LEG_COMMON_DisplayInfoBox(oTarget, sObjective + " " + sObjectiveTarget + " (" + IntToString(iPCHas) + "/" + IntToString(iPCNeeds) + ")");
	else if (sAltMessage != "")
		LEG_COMMON_DisplayInfoBox(oTarget, sAltMessage);
	else
		SendMessageToPC(oTarget, sObjective);	
	
	// Next, we update the PC's objective counter with how many they have now.		
	SetLocalInt(oTarget, "QuestID_" + sQuestID + "_OBJ" + IntToString(iObjective), iPCHas);
	
	// Store that same fact persistently.
	string sTableID = LEG_COMMON_GetPC2Table(oTarget);
	SetPersistentInt(oTarget, "QuestID_" + sQuestID + "_OBJ" + IntToString(iObjective), iPCHas, 0, sTableID);

	// Check for Objective Rules
	LEG_QUEST_ApplyObjectiveRules(oTarget, sQuestID, iNPCObjective, iObjective, iMyFlagID);
	
	// Play a pretty sound!
	PlaySound("gui_journaladd");

	// So we just got credit for a quest objective.  What if this is a timer objective?  
	// For now, all we need to do is start up a timer.
	int iTimerDuration = GetLocalInt(oObject, "LEG_INFO_TimerBarDuration_" + sQuestID);
	if (iTimerDuration > 0)
	{
		SetLocalInt(oTarget, "LEG_INFO_TimerBarDuration", iTimerDuration);
		SetLocalString(oTarget, "LEG_INFO_ProgBarTimerFailScript", "leg_quest_objtimerfail");
		SetLocalString(oTarget, "LEG_INFO_TimerBarQuestID", sQuestID);
		SetLocalInt(oTarget, "LEG_INFO_TimerBarNPC", iNPCObjective);
		SetLocalInt(oTarget, "LEG_INFO_TimerBarNPCOBJ", iObjective);
		SetPersistentInt(oTarget, "QuestID_" + sQuestID + "_TIMERMOB" + IntToString(iNPCObjective), 1, 0, sTableID);
		SetPersistentInt(oTarget, "QuestID_" + sQuestID + "_TIMERMOBOBJ" + IntToString(iObjective), 1, 0, sTableID);
		DeletePersistentVariable(oTarget, "QuestID_" + sQuestID + "_MOBTIMERFAILED" + IntToString(iNPCObjective), sTableID);
		DeletePersistentVariable(oTarget, "QuestID_" + sQuestID + "_MOBOBJTIMERFAILED" + IntToString(iObjective), sTableID);
		ExecuteScript("leg_info_timerbar", oTarget);
	}												
	
	// Is there a timer bar running for this quest and NPC?  If so, store that we did this objective in case we have to remove it later.
	if (GetLocalInt(oTarget, "LEG_INFO_TimerBarNPC") == iNPCObjective && GetLocalString(oTarget, "LEG_INFO_TimerBarQuestID") == sQuestID)
		SetPersistentInt(oTarget, "QuestID_" + sQuestID + "_TIMEROBJDONE" + IntToString(iObjective), iPCHas, 0, sTableID);

			
	// If I was just used and I am a reward for a quest or spawned as a result of a quest, then de-activate my spawner.  
	// The danger here is that we are removing the spawn from everyone in the party, based on the assumption that they
	// will all get credit either because the placeable is a party objective (applies to Examine, Placing and Destroying)
	// or simply that each player is assumed to use this quest placeable.  Regardless if they mess it up, the can go back to the
	// quest giver again, hit the continue button to re-activate it.  
	object oParent = GetLocalObject(oObject, "SPAWN_Parent");
	string sWPTag = GetTag(oParent);
	object oPartyMember = GetFirstFactionMember(oTarget);
	
	// Cycle through the party.  If the party member needed to kill this mob, deactivate the spawner and
	// clear THAT person's entry from the questspawns table.
   	while(oPartyMember != OBJECT_INVALID)
   	{
        if (GetIsPC(oPartyMember) && GetArea(oPartyMember) == GetArea(oTarget))
       	{
			if (GetLocalInt(oParent, "LEG_SPAWN_QuestBased") && GetLocalInt(oPartyMember, sWPTag))
			{
				SetLocalInt(oParent, "LEG_SPAWN_TriggerSpawn", 1);
				SetLocalInt(oPartyMember, sWPTag, 0);
				DeletePersistentVariable(oPartyMember, sWPTag, QUESTPREFIX + "_questspawns");
			}
		}
		
		oPartyMember = GetNextFactionMember(oTarget);
	}
	
	
	
	// If this is a placeable object...(and not an SE Man who can call this from the Complete Fake Objective)
	if (GetObjectType(oObject) == OBJECT_TYPE_PLACEABLE && GetTag(oObject) != "legquestheartbeat")
	{
		// We also want to ensure the object isn't used again.
		if (!GetLocalInt(oObject, "MOBDeath"))
		{
			sTableID = LEG_COMMON_GetPC2Table(oTarget);
			SetPersistentInt(oTarget, sQuestID + "_" + sPlaceID, iObjective, 0, sTableID);
		}
		else
		{
			// Lets make sure they can't search anymore during this server reset.
			SetLocalInt(oObject, GetPCPublicCDKey(oTarget), TRUE);
		}
	}	
	
	// If using the Quest Icon configuration, refresh anyone that's nearby that may need to be.
	if (LEG_QUEST_ICONS)
	{
		float fTimer = 0.1;
		object oIcon;
		object oNextNPC = GetFirstObjectInShape(SHAPE_SPHERE, StringToFloat(ICONREFRESHRANGE), GetLocation(oTarget), FALSE, OBJECT_TYPE_CREATURE);
		while (GetIsObjectValid(oNextNPC))
		{
			oIcon = GetLocalObject(oNextNPC, "MyIcon");
			DelayCommand(fTimer, LEG_QUEST_RefreshQuestIcon(oNextNPC, oIcon, oTarget));
			fTimer = fTimer + 0.1;
			oNextNPC = GetNextObjectInShape(SHAPE_SPHERE, StringToFloat(ICONREFRESHRANGE), GetLocation(oTarget), FALSE, OBJECT_TYPE_CREATURE);			
		}	
	}
}




// //////////////////////////////////////////////////
// LEG_QUEST_PCQualify
// //////////////////////////////////////////////////
int LEG_QUEST_PCQualify(object oPC, object oTarget)
{
	// First find out if we need to run this for the quest plugin and if so, then we're pretty much just going
	// to run the standard banter script to start the convo.
	int iTotalQuests = GetLocalInt(oTarget, "LEG_QUEST_TotalQuests");
	int iCount, iNeeds, iPCHas;
	string sQuestID, sQuestCounter;
	string sTableID = LEG_COMMON_GetPC2Table(oPC);
	
	// Start cycling through the quests this trigger offers.
	for (iCount = 1; iCount <= iTotalQuests; iCount++)
	{
		SetLocalObject(oPC, "QNPC", oTarget);
		sQuestCounter = IntToString(iCount);
		sQuestID = GetLocalString(oTarget, "LEG_QUEST_QuestID_" + sQuestCounter);
		int iObjective = GetLocalInt(oTarget, "LEG_QUEST_IsObjective_" + sQuestCounter);
		int iNPCObjective = GetLocalInt(oTarget, "LEG_QUEST_ObjectiveFor_" + sQuestCounter);
		int iAdvanceNPC = GetLocalInt(oTarget, "LEG_QUEST_NPCAdvance_" + sQuestCounter);			
	
		// Is the player on the quest and are they on this step?
		int iPlayerNPC = GetLocalInt(oPC, "QuestID_" + sQuestID + "_NPC");				
		int iPlayerOBJCount = GetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ" + IntToString(iObjective));
		if (iPlayerNPC == iNPCObjective)
		{
			// Is my Objective Owner reluctant and has the PC gotten passed that little issue?
			//int iReluctance = GetLocalInt(OBJECT_SELF, "LEG_QUEST_Reluctant_" + IntToString(iObjective));
			int iReluctantPassed = GetLocalInt(oPC, "QuestID_" + sQuestID + "_" + IntToString(iNPCObjective) + "_ReluctantPassed");
			
			if (iReluctantPassed == 0)
				return -1;
		
			// If this objective is currently active and available for a PC to perform
			if (LEG_QUEST_GetOBJ(oPC, sQuestID, iNPCObjective, iObjective, "OBJInactive") == "1")
			{
				return -1;
			}				
			
			// So what are we doing today?  Some exploring?  Ok.  If the PC needs to explore this
			// trigger, lets check and do what we have to do.
			// See how many of me the PC needs.  Usually 1.
			iNeeds = GetLocalInt(oTarget, "LEG_QUEST_PCNeeds_" + sQuestCounter);
			if (iNeeds == 0)
				iNeeds = 1;
			iPCHas = iPlayerOBJCount;
			if (iNeeds > iPCHas)
			{
				// Now the PC has one more than they had before!
				iPCHas++;

				return iPCHas;
			}
		}
	}
	
	return -1;
}


// //////////////////////////////////////////////////
// LEG_QUEST_CheckQuestRequirements
// //////////////////////////////////////////////////
int LEG_QUEST_CheckQuestRequirements(object oPC, object oTarget, string sQuestPosition)
{
	// Check the level etc requirements that are configured on the target.  Return TRUE if the PC
	// has them all met or they simply do not exist.
	
	// Level
	int iLevelReq = GetLocalInt(oTarget, "LEG_QUEST_LevelReq_" + sQuestPosition);
	string sClassReq = GetLocalString(oTarget, "LEG_QUEST_ClassReq_" + sQuestPosition);
	string sRaceReq = GetLocalString(oTarget, "LEG_QUEST_RaceReq_" + sQuestPosition);
	string sFeatReq = GetLocalString(oTarget, "LEG_QUEST_FeatReq_" + sQuestPosition);
	string sAlignReq = GetLocalString(oTarget, "LEG_QUEST_AlignReq_" + sQuestPosition);
	string sItemReq = GetLocalString(oTarget, "LEG_QUEST_ItemReq_" + sQuestPosition);
	if (iLevelReq)
	{
		// We have a level requirement
		if (GetTotalLevels(oPC, FALSE) < iLevelReq)
			return FALSE;
	}
	
	if (sAlignReq != "")
	{
		// Alignment requirement
		if ((sAlignReq == "Lawful Good" && GetAlignmentLawChaos(oPC) != ALIGNMENT_LAWFUL) || (sAlignReq == "Lawful Good" && GetAlignmentGoodEvil(oPC) != ALIGNMENT_GOOD))
			return FALSE;
		if ((sAlignReq == "Lawful Neutral" && GetAlignmentLawChaos(oPC) != ALIGNMENT_LAWFUL) || (sAlignReq == "Lawful Neutral" && GetAlignmentGoodEvil(oPC) != ALIGNMENT_NEUTRAL))
			return FALSE;
		if ((sAlignReq == "Lawful Evil" && GetAlignmentLawChaos(oPC) != ALIGNMENT_LAWFUL) || (sAlignReq == "Lawful Evil" && GetAlignmentGoodEvil(oPC) != ALIGNMENT_EVIL))
			return FALSE;
		if ((sAlignReq == "Neutral" && GetAlignmentLawChaos(oPC) != ALIGNMENT_NEUTRAL) || (sAlignReq == "Neutral" && GetAlignmentGoodEvil(oPC) != ALIGNMENT_NEUTRAL))
			return FALSE;
		if ((sAlignReq == "Chaotic Good" && GetAlignmentLawChaos(oPC) != ALIGNMENT_CHAOTIC) || (sAlignReq == "Chaotic Good" && GetAlignmentGoodEvil(oPC) != ALIGNMENT_GOOD))
			return FALSE;
		if ((sAlignReq == "Chaotic Neutral" && GetAlignmentLawChaos(oPC) != ALIGNMENT_CHAOTIC) || (sAlignReq == "Chaotic Neutral" && GetAlignmentGoodEvil(oPC) != ALIGNMENT_NEUTRAL))
			return FALSE;
		if ((sAlignReq == "Chaotic Evil" && GetAlignmentLawChaos(oPC) != ALIGNMENT_CHAOTIC) || (sAlignReq == "Chaotic Evil" && GetAlignmentGoodEvil(oPC) != ALIGNMENT_EVIL))
			return FALSE;
	}
	
	if (sItemReq != "")
	{
		// Item Requirement
		if (LEG_COMMON_GetInventoryCount(oPC, sItemReq) <= 0)
			return FALSE;
	}
	
	if (sClassReq != "")
	{
		// Class Requirement
		int iClassReq = StringToInt(sClassReq);
		if (GetClassByPosition(1, oPC) != iClassReq && GetClassByPosition(2, oPC) != iClassReq && GetClassByPosition(3, oPC) != iClassReq)
			return FALSE;
	}

	if (sRaceReq != "")
	{
		// Class Requirement
		int iRaceReq = StringToInt(sRaceReq);
		if (GetRacialType(oPC) != iRaceReq)
			return FALSE;
	}

	if (sFeatReq != "")
	{
		// Class Requirement
		int iFeatReq = StringToInt(sFeatReq);
		if (!GetHasFeat(iFeatReq, oPC, TRUE))
			return FALSE;
	}
		
	return TRUE;
}



int LEG_QUEST_IsAutoAdvanceNPC(string sQuestID, int iNPC)
{
			// We're reluctant, get the reluctant text.
			SQLExecDirect("SELECT COUNT(*) FROM `" + QUESTPREFIX + "_autoadvance` WHERE `QuestID` = '" + sQuestID + "' AND `NPCID` = '" + IntToString(iNPC) + "';");
			SQLFetch();
			return StringToInt(SQLGetData(1));
}


string LEG_QUEST_GetOBJ(object oPC, string sQuestID, int iNPC, int iObjective, string sOBJ)
{
	string sNPC = IntToString(iNPC);
	int iIndex = LEG_COMMON_SearchArrayElement(oPC, sQuestID + sNPC + "OBJID", IntToString(iObjective));
	if (iIndex != -1)
	{
		return LEG_COMMON_GetArrayElement(oPC, sQuestID + sNPC + sOBJ, iIndex);
	}
	return "";
}

void LEG_QUEST_SetOBJ(object oPC, string sQuestID, int iNPC, int iObjective, string sOBJ, string sValue)
{
	string sNPC = IntToString(iNPC);
	int iIndex = LEG_COMMON_SearchArrayElement(oPC, sQuestID + sNPC + "OBJID", IntToString(iObjective));
	if (iIndex != -1)
	{
		LEG_COMMON_SetArrayElement(oPC, sQuestID + sNPC + sOBJ, iIndex, sValue);
	}
}

string LEG_QUEST_GetOBJDB(object oPC, string sQuestID, int iNPC, int iObjective, string sOBJ)
{
	string sNPC = IntToString(iNPC);
	string sOBJRule = "";
	SQLExecDirect("SELECT * FROM `" + QUESTPREFIX + "_objrules` WHERE `QuestID` = '" + sQuestID + "' AND `NPCID` = '" + sNPC + "' AND `ObjID` = '" + IntToString(iObjective) + "'");
	while(SQLFetch())
	{
		if (sOBJ == "OBJInactive")
			sOBJRule = SQLGetData(4);
		else if (sOBJ == "OBJHideSelf")
			sOBJRule = SQLGetData(5);
		else if (sOBJ == "OBJHideSelfOnComplete")
			sOBJRule = SQLGetData(6);
		else if (sOBJ == "OBJNoDone")
			sOBJRule = SQLGetData(7);
		else if (sOBJ == "OBJShowOther")
		{
			sOBJRule = SQLGetData(8);
			if (sOBJRule == "")
				sOBJRule = "0";	
		}
		else if (sOBJ == "OBJNoActiveOther")
		{
			sOBJRule = SQLGetData(9);
			if (sOBJRule == "")
				sOBJRule = "0";	
		}
		else if (sOBJ == "OBJHideQty")
			sOBJRule = SQLGetData(10);
		else if (sOBJ == "OBJPrime")
			sOBJRule = SQLGetData(11);
	}
	
	return sOBJRule;	
}





void LEG_QUEST_ApplyObjectiveRules(object oTarget, string sQuestID, int iNPCObjective, int iObjective, int iMyFlagID, int iInitialize = FALSE)
{
	// Do some actions from the Objectives Rules if we have completed the Objective
	int iObjectivesChanged = FALSE;
	
	// If the objective is complete, then check and see if we have an area flag to activate.
	if (iMyFlagID)
	{
		if (LEG_QUEST_CheckObjective(oTarget, sQuestID, iNPCObjective, iObjective))
		{
			int iCurrentFlags = GetLocalInt(GetArea(OBJECT_SELF), "QUEST_SE_Flags1");
			LEG_QUEST_SER_SetFlag(GetArea(OBJECT_SELF), iMyFlagID);
			object oSEMan = GetNearestObjectByTag("legquestheartbeat", OBJECT_SELF);
			ExecuteScript("leg_quest_se_hb", oSEMan);
			string sTableID = LEG_COMMON_GetPC2Table(oTarget);
			SetLocalInt(oTarget, "QuestID_" + sQuestID + "_FLG" + IntToString(iObjective), iMyFlagID);
			SetPersistentInt(oTarget, "QuestID_" + sQuestID + "_FLG" + IntToString(iObjective), iMyFlagID, 0, sTableID);
			SetPersistentString(oTarget, "QuestID_" + sQuestID + "_FLGAREA" + IntToString(iObjective), GetTag(GetArea(OBJECT_SELF)), 0, sTableID);
		}	
	}
	

	if (LEG_QUEST_GetOBJ(oTarget, sQuestID, iNPCObjective, iObjective, "OBJPrime") == "1")
	{
		if (LEG_QUEST_CheckObjective(oTarget, sQuestID, iNPCObjective, iObjective))
		{
			// We've completed the PRIME objective so finish all other objectives unless it's a delivery or speak to.  
			LEG_QUEST_CompleteObjectives(oTarget, sQuestID, iNPCObjective, 1, 1);
			
			// The this variable so that when Check Inventory Items is called, objectives that were auto-completed are not checked for
			// missing items (assuming players turn in the quest before the server resets.  If this becomes a problem, we'll make this
			// persistent.
			SetLocalInt(oTarget, "QUEST_" + sQuestID + IntToString(iNPCObjective) + "PrimeDone", iObjective);

			string sTablePlayer = SQLEncodeSpecialChars(GetPCPlayerName(oTarget));
			string sTableToon = SQLEncodeSpecialChars(GetName(oTarget));						
			
			// The PC just finished the quest.  Clean up DB
			string sPCTableName = LEG_COMMON_GetPC2Table(oTarget);
			SQLExecDirect("DELETE FROM " + sPCTableName + " WHERE `player` = '" + sTablePlayer + "' AND `tag` = '" + sTableToon + "' AND `Name` LIKE 'QuestID_" + sQuestID + "_FLGAREA%'");	
			SQLExecDirect("DELETE FROM " + sPCTableName + " WHERE `player` = '" + sTablePlayer + "' AND `tag` = '" + sTableToon + "' AND `Name` LIKE 'QuestID_" + sQuestID + "_FLG%'");
		}
	}
		
	int iShowOther = StringToInt(LEG_QUEST_GetOBJ(oTarget, sQuestID, iNPCObjective, iObjective, "OBJShowOther"));
	if (iShowOther > 0)
	{
		if (LEG_QUEST_CheckObjective(oTarget, sQuestID, iNPCObjective, iObjective))
		{
			if (iShowOther & 1)				LEG_QUEST_SetOBJ(oTarget, sQuestID, iNPCObjective, 1, "OBJHideSelf", "");
			if (iShowOther & 2)				LEG_QUEST_SetOBJ(oTarget, sQuestID, iNPCObjective, 2, "OBJHideSelf", "");
			if (iShowOther & 4)				LEG_QUEST_SetOBJ(oTarget, sQuestID, iNPCObjective, 3, "OBJHideSelf", "");
			if (iShowOther & 8)				LEG_QUEST_SetOBJ(oTarget, sQuestID, iNPCObjective, 4, "OBJHideSelf", "");
			if (iShowOther & 16)			LEG_QUEST_SetOBJ(oTarget, sQuestID, iNPCObjective, 5, "OBJHideSelf", "");
			if (iShowOther & 32)			LEG_QUEST_SetOBJ(oTarget, sQuestID, iNPCObjective, 6, "OBJHideSelf", "");
			if (iShowOther & 64)			LEG_QUEST_SetOBJ(oTarget, sQuestID, iNPCObjective, 7, "OBJHideSelf", "");
			if (iShowOther & 128)			LEG_QUEST_SetOBJ(oTarget, sQuestID, iNPCObjective, 8, "OBJHideSelf", "");
			if (iShowOther & 256)			LEG_QUEST_SetOBJ(oTarget, sQuestID, iNPCObjective, 9, "OBJHideSelf", "");
			if (iShowOther & 512)			LEG_QUEST_SetOBJ(oTarget, sQuestID, iNPCObjective, 10, "OBJHideSelf", "");
			iObjectivesChanged = TRUE;
		}
	}

	int iActivateOther = StringToInt(LEG_QUEST_GetOBJ(oTarget, sQuestID, iNPCObjective, iObjective, "OBJActivateOther"));
	if (iActivateOther > 0)
	{
		if (LEG_QUEST_CheckObjective(oTarget, sQuestID, iNPCObjective, iObjective))
		{
			if (iActivateOther & 1)				LEG_QUEST_SetOBJ(oTarget, sQuestID, iNPCObjective, 1, "OBJInactive", "");
			if (iActivateOther & 2)				LEG_QUEST_SetOBJ(oTarget, sQuestID, iNPCObjective, 2, "OBJInactive", "");
			if (iActivateOther & 4)				LEG_QUEST_SetOBJ(oTarget, sQuestID, iNPCObjective, 3, "OBJInactive", "");
			if (iActivateOther & 8)				LEG_QUEST_SetOBJ(oTarget, sQuestID, iNPCObjective, 4, "OBJInactive", "");
			if (iActivateOther & 16)			LEG_QUEST_SetOBJ(oTarget, sQuestID, iNPCObjective, 5, "OBJInactive", "");
			if (iActivateOther & 32)			LEG_QUEST_SetOBJ(oTarget, sQuestID, iNPCObjective, 6, "OBJInactive", "");
			if (iActivateOther & 64)			LEG_QUEST_SetOBJ(oTarget, sQuestID, iNPCObjective, 7, "OBJInactive", "");
			if (iActivateOther & 128)			LEG_QUEST_SetOBJ(oTarget, sQuestID, iNPCObjective, 8, "OBJInactive", "");
			if (iActivateOther & 256)			LEG_QUEST_SetOBJ(oTarget, sQuestID, iNPCObjective, 9, "OBJInactive", "");
			if (iActivateOther & 512)			LEG_QUEST_SetOBJ(oTarget, sQuestID, iNPCObjective, 10, "OBJInactive", "");
			iObjectivesChanged = TRUE;
		}
	}
	
	// Check and see if I should hide my objective when complete.
	if (LEG_QUEST_GetOBJ(oTarget, sQuestID, iNPCObjective, iObjective, "OBJHideSelfOnComplete") == "1")
	{
		if (LEG_QUEST_CheckObjective(oTarget, sQuestID, iNPCObjective, iObjective))
		{
			// We've completed the objective so set ourselves to be hidden.  
			LEG_QUEST_SetOBJ(oTarget, sQuestID, iNPCObjective, iObjective, "OBJHideSelf", "1");
			iObjectivesChanged = TRUE;
		}
	}
		
	// If we've updated our objectives, then we need to notify via the secondary INFOBOX as well as investigate the
	// new popup with extra details.
	if (iObjectivesChanged == TRUE && iInitialize == FALSE)
	{
		LEG_COMMON_DisplayInfoBox(oTarget, "Objectives Updated", 0, 0, 1);
		AssignCommand(oTarget, PlaySound("gui_journaladd"));
	}
	
	// If there's a notice in the objective, display it.
	if (iInitialize == FALSE)
	{
		if (LEG_QUEST_CheckObjective(oTarget, sQuestID, iNPCObjective, iObjective))
		{
			string sMessage = LEG_QUEST_GetOBJ(oTarget, sQuestID, iNPCObjective, iObjective, "ChangeNotice");
			if (sMessage != "")
				LEG_COMMON_DisplayInfoBox(oTarget, sMessage, 0, 0, 2);
		}
	}
}


void LEG_QUEST_InitializeOBJRule(object oPC, string sQuestID, string sNPC, int iObjective)
{
	if (iObjective == -1)
	{
		SQLExecDirect("SELECT * FROM `" + QUESTPREFIX + "_objrules` WHERE `QuestID` = '" + sQuestID + "' AND `NPCID` = '" + sNPC + "'");
	}
	else
	{
		SQLExecDirect("SELECT * FROM `" + QUESTPREFIX + "_objrules` WHERE `QuestID` = '" + sQuestID + "' AND `NPCID` = '" + sNPC + "' AND `ObjID` = '" + IntToString(iObjective) + "'");
	}
	
	string sOBJRule;
	while(SQLFetch())
	{
		sOBJRule = SQLGetData(3);
		LEG_COMMON_AddArrayElement(oPC, sQuestID + sNPC + "OBJID", sOBJRule);
		sOBJRule = SQLGetData(4);
		LEG_COMMON_AddArrayElement(oPC, sQuestID + sNPC + "OBJInactive", sOBJRule);
		sOBJRule = SQLGetData(5);
		LEG_COMMON_AddArrayElement(oPC, sQuestID + sNPC + "OBJHideSelf", sOBJRule);
		sOBJRule = SQLGetData(6);
		LEG_COMMON_AddArrayElement(oPC, sQuestID + sNPC + "OBJHideSelfOnComplete", sOBJRule);
		sOBJRule = SQLGetData(7);
		LEG_COMMON_AddArrayElement(oPC, sQuestID + sNPC + "OBJNoDone", sOBJRule);
		sOBJRule = SQLGetData(8);
		if (sOBJRule == "") 
			sOBJRule = "0";
		LEG_COMMON_AddArrayElement(oPC, sQuestID + sNPC + "OBJShowOther", sOBJRule);
		sOBJRule = SQLGetData(9);
		if (sOBJRule == "") 
			sOBJRule = "0";
		LEG_COMMON_AddArrayElement(oPC, sQuestID + sNPC + "OBJActivateOther", sOBJRule);
		sOBJRule = SQLGetData(10);
		LEG_COMMON_AddArrayElement(oPC, sQuestID + sNPC + "OBJHideQty", sOBJRule);
		sOBJRule = SQLGetData(11);
		LEG_COMMON_AddArrayElement(oPC, sQuestID + sNPC + "OBJPrime", sOBJRule);
		sOBJRule = SQLGetData(12);
		LEG_COMMON_AddArrayElement(oPC, sQuestID + sNPC + "ChangeNotice", sOBJRule);
	}
}

void LEG_QUEST_ClearOBJRuleSet(object oPC, string sQuestID, int iNPC)
{
	string sNPC = IntToString(iNPC);
	LEG_COMMON_ClearArray(oPC, sQuestID + sNPC + "OBJID");
	LEG_COMMON_ClearArray(oPC, sQuestID + sNPC + "OBJInactive");
	LEG_COMMON_ClearArray(oPC, sQuestID + sNPC + "OBJHideSelf");
	LEG_COMMON_ClearArray(oPC, sQuestID + sNPC + "OBJHideSelfOnComplete");
	LEG_COMMON_ClearArray(oPC, sQuestID + sNPC + "OBJNoDone");
	LEG_COMMON_ClearArray(oPC, sQuestID + sNPC + "OBJShowOther");
	LEG_COMMON_ClearArray(oPC, sQuestID + sNPC + "OBJActivateOther");
	LEG_COMMON_ClearArray(oPC, sQuestID + sNPC + "OBJPrime");
	LEG_COMMON_ClearArray(oPC, sQuestID + sNPC + "OBJHideQty");
	LEG_COMMON_ClearArray(oPC, sQuestID + sNPC + "ChangeNotice");		
}


void LEG_QUEST_PartyMemberObjective(object oCompleter, object oParent, string sQuestCounter, string sTriggerText, string sOptionalItem = "")
{
	string sQuestID = GetLocalString(oParent, "LEG_QUEST_QuestID_" + sQuestCounter);
	string sTableID;
	int iObjective = GetLocalInt(oParent, "LEG_QUEST_IsObjective_" + sQuestCounter);
	int iNPCObjective = GetLocalInt(OBJECT_SELF, "LEG_QUEST_ObjectiveFor_" + sQuestCounter);
	int iPCNowHas = -1;
	object oIcon, oNextNPC;
	float fTimer = 0.1;
	object oPC = GetFirstFactionMember(oCompleter, TRUE);
	while (GetIsObjectValid(oPC))
	{
		if (oPC != oCompleter)
		{
			iPCNowHas = LEG_QUEST_PCQualify(oPC, oParent);
			if (iPCNowHas > 0)
			{
				// Get this PC's table
				sTableID = LEG_COMMON_GetPC2Table(oPC);
	
				// Update this PC
				LEG_COMMON_DisplayInfoBox(oPC, sTriggerText);
				
				// Save and give credit.
				SetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ" + IntToString(iObjective), 1);
				SetPersistentInt(oPC, "QuestID_" + sQuestID + "_OBJ" + IntToString(iObjective), 1, 0, sTableID);
				
				// Ensure oPC is commandable.
				SetCommandable(TRUE, oPC);
				
				// Play a pretty sound.
				PlaySound("gui_journaladd");
				
				// Remove an optional item
				if (sOptionalItem != "")
				{
					LEG_COMMON_DestroyItems(oPC, sOptionalItem, 1);
				}
				
				// Apply any Objective Rules
				LEG_QUEST_ApplyObjectiveRules(oPC, sQuestID, iNPCObjective, iObjective, 0);
				
				// If using the Quest Icon configuration, refresh anyone that's nearby that may need to be.
				if (LEG_QUEST_ICONS)
				{
					
					oNextNPC = GetFirstObjectInShape(SHAPE_SPHERE, StringToFloat(ICONREFRESHRANGE), GetLocation(oPC), FALSE, OBJECT_TYPE_CREATURE);
					while (GetIsObjectValid(oNextNPC))
					{
						oIcon = GetLocalObject(oNextNPC, "MyIcon");
						DelayCommand(fTimer, LEG_QUEST_RefreshQuestIcon(oNextNPC, oIcon, oPC));				
						fTimer = fTimer + 0.1;
						oNextNPC = GetNextObjectInShape(SHAPE_SPHERE, StringToFloat(ICONREFRESHRANGE), GetLocation(oPC), FALSE, OBJECT_TYPE_CREATURE);			
					}	
				}									
			}
		}
		oPC = GetNextFactionMember(oPC, TRUE);
	}	
}



void LEG_QUEST_SER_SetFlag(object oTarget, int iMyFlagID, int iOff = 0)
{
	if (iMyFlagID == -1)
		return;
		
	int iCurrentFlags = GetLocalInt(oTarget, "QUEST_SE_Flags1");

	if (iOff)
	{
		iCurrentFlags = iCurrentFlags & ~iMyFlagID;
	}
	else
	{
		iCurrentFlags |= iMyFlagID;
	}
	if (iCurrentFlags < 0)
		iCurrentFlags = 0;
		
	SetLocalInt(oTarget, "QUEST_SE_Flags1", iCurrentFlags);
}




int LEG_QUEST_CheckInventoryProps(object oPC, object oNPC, string sQuestID, int iNPCPosition, int iCheckSelf)
{

	// Check to see if I have all the required prop items if they are configured.
	string sPropItemToTake = "";
	SQLExecDirect("SELECT * FROM `" + QUESTPREFIX + "_propitems` WHERE `QuestID` = '" + sQuestID + "' AND `NPCID` = '" + IntToString(iNPCPosition) + "' AND `Action` = 'TAKEITEM';");
	while (SQLFetch())
	{
		// If we are supposed to take some prop items that were given to the PC, then we need to ensure they have them!
		sPropItemToTake = SQLGetData(3);
	}
	
	if (sPropItemToTake != "")
	{
		// Looks like we have a prop item.  How many are we supposed to take from the PC?
		int iWasGivenProps = 0;
		string sCheckSelf;
		if (iCheckSelf)
			sCheckSelf = "=";
		else
			sCheckSelf = "!=";
		SQLExecDirect("SELECT * FROM `" + QUESTPREFIX + "_propitems` WHERE `QuestID` = '" + sQuestID + "' AND `Parameter1` = '" + sPropItemToTake + "' AND `Action` = 'GIVEITEM' AND `NPCID` " + sCheckSelf + " '" + IntToString(iNPCPosition) + "';");
		while (SQLFetch())
		{
			iWasGivenProps = StringToInt(SQLGetData(4));
		}
		
		if (iWasGivenProps > 0)
		{
			// Player was given some props.  We need to ensure they have em.
			int iPCHas = LEG_COMMON_GetInventoryCount(oPC, sPropItemToTake);
			if (iPCHas < iWasGivenProps)
			{
				SendMessageToPC(oPC, "You are missing some required items!");
				string sOneLiner = LEG_QUEST_GetOneLiner(GetResRef(oNPC));
				AssignCommand(oNPC, ActionSpeakString(sOneLiner));
				return FALSE;
			}
		}
	}
	return TRUE;
}