// =============================================================
//
//    File: row_fp_chest_open
//    Desc: Rowell's Fair Play Chest - Open Event
//  Author: Michael Marzilli
//    Site: http://www.engliton.org
//
// Created: Oct 02, 2006
// Updated: Jan 04, 2007
// Version: 1.0.0
//
// =============================================================

#include "row_treasure_system"
#include "row_inc_chest"
#include "row_inc_quest"


void main() {
	object oChest   = OBJECT_SELF;
	object oItem    = OBJECT_INVALID;
	int    iLocked  = GetLocalInt(oChest, "IsLocked");
	int	   iTrapped = GetLocalInt(oChest, "IsTrapped");
	int    iCount   = GetLocalInt(oChest, "ITEM_COUNT");
	int	   iQuestID = GetLocalInt(oChest, "RQS_QuestID");
	object oPC      = GetLastOpenedBy();
	string sID      = GetPCPlayerName(oPC) + GetName(oPC) + "oFPC";
	int    iLevel   = 0;
	int    iGold    = 0;
	int    i        = 0;
	
	// CHECK IF CHEST IS INITIALIZED
	if (GetLocalInt(oChest, "IsInitialized") != 1) {
		ChestInit(oChest);
		iLocked  = GetLocalInt(oChest, "IsLocked");
		iTrapped = GetLocalInt(oChest, "IsTrapped");
		iCount   = GetLocalInt(oChest, "ITEM_COUNT");
	}
	
	// EMPTY THE CHEST CONTAINER
	oItem = GetFirstItemInInventory(oChest);
	while (oItem != OBJECT_INVALID) {
		SetPlotFlag(oItem, FALSE);
		DestroyObject(oItem);
		oItem = GetNextItemInInventory(oChest);
	}

	// CHECK IF THE CHEST IS A QUEST CONTAINER
	// IF SO, CHECK IF THE CHARACTER IS ON THAT QUEST
	if (iQuestID > 0) {
	  if (!RQS_isQuestStarted(oPC, iQuestID))
		return;
	  if (RQS_isQuestComplete(oPC, iQuestID) || RQS_isQuestFinished(oPC, iQuestID))
		return;
	}
	
	// ASSIGN TREASURE TO THE CHEST
	if (GetLocalInt(oChest, sID) != 1) {
	
		// INSERT PRE-POPULATED ITEMS (NON-RANDOM)
		if (iCount > 0) {
			for (i=1; i<=iCount; i++) {
				CreateItemOnObject(GetLocalString(oChest, "ITEM_"+IntToString(i)), oChest);
			}
		} else {
		// INSERT RANDOM TREASURE	
		
			// Populate the Chest with some Gold
			if (GetLocalInt(oChest, "BaseLevel") == 0) {
				// Gold according to PC's Level
				iLevel = GetTotalLevels(oPC, TRUE);
				iGold  = Random(iLevel * 5) + iLevel + d4();
				AssignCommand(oChest, GiveGoldToCreature(oChest, iGold));
				CreateItemOnObject("nw_it_gold001", oChest, iGold);			
			} else {
				// Gold according to the Object Variable
				iLevel = GetLocalInt(oChest, "BaseLevel");
				iGold  = Random(iLevel * 5) + iLevel + d4();
				AssignCommand(oChest, GiveGoldToCreature(oChest, iGold));
				CreateItemOnObject("nw_it_gold001", oChest, iGold);			
			}
		
			// Populate the Chest with Treasure
			if (iLevel < 21) { iGold = TREASURE_TYPE_HIGH; }
			if (iLevel < 14) { iGold = TREASURE_TYPE_MED; }
			if (iLevel < 7)  { iGold = TREASURE_TYPE_LOW; }
			CTG_CreateTreasure(iGold, oPC, oChest);
		}
		
		// Mark that Player as having used the Chest
		SetLocalInt(oChest, sID, 1);
		
	}
	
}