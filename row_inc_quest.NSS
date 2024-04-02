// =============================================================
//
//    File: row_inc_quest
//    Desc: Rowell's Quest System Include
//  Author: Michael Marzilli
//    Site: http://www.engliton.org
//
// Created: Jan 17, 2007
// Updated: Feb 19, 2007
// Version: 1.0.4
//
// =============================================================

#include "row_inc_factions"


// =============================================================
// SYSTEM USAGE
// =============================================================

// 1)	Set up the Quest in the Database:
// 1a)	Set up Table_RQS_Quest with the basic Quest information
//			QuestID			A unique number used to identify the Quest.  This is very important.
//			QuestType 		The Type of Quest (See the GLOBAL CONSTANTS section below for a list of Types)
//			QuestName		The Name of the Quest.
//			QuestMinLevel	The Minimum Level a Character needs to be to perform this Quest
//			QuestMaxLevel	The Maximum Level a Character can be to perform this Quest
//			FactionID		The Faction that this Quest is related to (use 0 for None)
//			QuestMinFaction	The Minimum Faction Rank that a Character must be to perform the Quest (-5 to +5, use 0 as Default)
//			Repeatable		Is the Quest Repeatable?  (0=No , 1=Yes)
//			PreReqQuest		The QuestID of a Quest that must be performed before the Character can do this Quest
//			PreReqRace		The Races that this Quest is available to (this is a comma seperated value, based on the Racial Types. Example: 1,2,3,6)
//			RewardXP		The XP Awarded to the Character for completing the Quest
//			RewardGP		The GP Awarded to the Character for completing the Quest
//			RewardAllItem	0=No: Character awarded one Random item from the Rewards Table. 1=Yes: Character rewarded ALL items from the Rewards Table for this Quest.
//			OriginTag		The Tag of the object that originated this Quest.
//			OriginName		The Name of the object that originated this Quest.
//			DestinationTag	The Tag of the object to turn this Quest in to for a reward.
//			DestinationName	The Name of the object to turn this Quest in to for a reward.
//
//	1b)	Set up Table_RQS_Goal with the objects needed to complete the Quest
//			QuestGoalID		A unique number used to identify the Goal.
//			QuestID			The Quest that this object is a goal for.
//			ItemTag			The Tag of the goal object.
//			ItemName		The Name of the goal object.
//			ItemQty			The Number (Quantity) of objects needed to complete this goal.
//		You can have multiple goals for a quest.
//
//	1c) [optional]  Set up Table_RQS_Reward with the objects the character will be rewarded with upon completing the Quest
//			QuestRewardID	A unique number used to identify the Reward.
//			QuestID 		The Quest that this object is a reward for.
//			ItemTag 		The Tag of the reward object.
//			ItemName 		The Name of the reward object.
//			ItemQty			The Number (Quantity) of objects given to the player as a reward.
//		You can have multiple rewards for a quest.
//
//	1d) [optional]  Set up Table_RQS_Faction with the factions that are affect when the character completes the Quest
//			QuestFactionID	A unique number used to identify the Faction Adjustment.
//			QuestID			The Quest that this faction adjustment is for.
//			FactionID		The Faction being adjusted.
//			FactionChange	The amount of change to the character's standing with the Faction.
//		You can affect more than one faction for a quest.
//
//	2)	Set up the Quest Journal Entries
//			Set the Tag of each Quest to "RQS_#" where # is the QuestID of the Quest (example: RQS_4, RQS_17)
//			The starting entry should be numbered 1.
//			Additional quest entries should be consecutive numbers (2,3,4 etc)
//			Add an entry 998 for when the Character Completes a Quest (but has not turned it in for a reward).
//			Add an entry 999 to signify that the Character has completed the quest and gotten the reward.
//
//	3)	Set up the Quest Conversation(s)
//			See the "row_rqs_demo" conversation in the Demo Module for usage and set up of conversations.
//
//	4)	Create and Set up the Quest NPC(s)  (Originator, Destination)  These can be Creatures or Objects. These use Conversations.
//			Add the Local Variable:  RQS_QuestID	Type: Number	Value: The QuestID of the Quest this object is associated with.
//
//	5)	[optional] Create and Set up the Quest/Goal creatures.
//			Add the Local Variable:  RQS_QuestID	Type: Number	Value: The QuestID of the Quest this object is associated with.
//			Add the Local Variable:  RQS_Item		Type: String	Value: The Tag of the Goal Item that this creature should Drop.
//
//	6)	[optional] Create the Goal Item(s)
//			Create the items/objects in the NWN2 Toolset. Be sure that the items have proper Tags and ResRefs.
//			Goal Items can include: Creatures that a player must kill (as above in #5), 
//			items that a player must collect, or Triggers that a player must find (and enter).
//
//	7)	[optional] Create Reward Item(s)
//			Create the item(s) that you will reward the player with upon completing the quest.
//			Remember that this object's Tag should be added into the Table_RQS_Reward table.
//
//	8)	[optional] Create and set up the Destination Trigger object(s)
//			Add the Local Variable:  RQS_QuestID	Type: Number	Value: The QuestID of the Quest this object is associated with.
//			Remember that this object's Tag should be added into the Table_RQS_Goal table.
//
//


// =============================================================
// GLOBAL FUNCTIONS
// =============================================================

// RQS_ModuleInitQuests();
//   Called in the Module's OnModuleStart Event. 
//   This function initializes and sets up the RQS Questing System
void RQS_ModuleInitQuests();

// RQS_PlayerEnter(object oPC);
//   This function is called when the player First Enters the Server.
//	 This function sets up the journal for that Player (oPC) depending on the information
//   saved in the Database.  Completed and In-Progress Quests are both updated from the
//   Database to the Journal.
void RQS_PlayerEnter(object oPC);

// RQS_GetIsOnQuest(object oPC, int iQuestID);
//   Is the Character (oPC) currently working on a Quest (QuestID).
int  RQS_GetIsOnQuest(object oPC, int iQuestID);

// RQS_isEligibleForQuest(object oPC, int iQuestID);
//	 Determines if the Character (oPC) is Eligible to participate in Quest (iQuestID)
int  RQS_isEligibleForQuest(object oPC, int iQuestID);

// RQS_isQuestStarted(object oPC, int iQuestID);
//   Determine if the Character(oPC) has started a Quest (iQuestID)
int  RQS_isQuestStarted(object oPC, int iQuestID);

// RQS_isQuestComplete(object oPC, int iQuestID);
//   Determine if the Character(oPC) has completed all the steps of a Quest (iQuestID)
int  RQS_isQuestComplete(object oPC, int iQuestID);

// RQS_isQuestFinished(object oPC, int iQuestID);
//   Determine if the Character(oPC) has finished all the steps of a Quest (iQuestID), and gotten the Reward
int  RQS_isQuestFinished(object oPC, int iQuestID);

// RQS_isQuestRepeatable(int iQuestID);
//	 Is the Quest (iQuestID) repeatable?
int  RQS_isQuestRepeatable(int iQuestID);

// RQS_SetConversationTokens(int iQuestID);
//   Sets up the Conversation Tokens with the Quest Information from the Database
//	 Tokens 7501 to 7510 are used for this.
void RQS_SetConversationTokens(int iQuestID);

// RQS_StartQuest(object oPC, int iQuestID, object oNPC=OBJECT_INVALID);
//   Adds a record to the Quest Progress Table for the Character (oPC)
//   stating that he/she is starting the Quest (iQuestID) for the NPC (oNPC)
void RQS_StartQuest(object oPC, int iQuestID, object oNPC=OBJECT_INVALID);

// RQS_CompleteQuest(object oPC, int iQuestID, object oNPC=OBJECT_INVALID);
//   Updates the record in the Quest Progress Table for the Character (oPC)
//   Setting the Status for the Quest (iQuestID) to Complete (RQS_QUEST_COMPLETE)
//   for the NPC (oNPC).
void RQS_CompleteQuest(object oPC, int iQuestID, object oNPC=OBJECT_INVALID);

// RQS_RewardQuest(object oPC, int iQuestID, object oNPC=OBJECT_INVALID);
//   Updates the record in the Quest Progress Table for the Character (oPC)
//   Setting the Status for the Quest (iQuestID) to Complete and Rewarded (RQS_QUEST_REWARDED)
//   for the NPC (oNPC).
void RQS_RewardQuest(object oPC, int iQuestID, object oNPC=OBJECT_INVALID);

// RQS_AbortQuest(object oPC, int iQuestID, object oNPC=OBJECT_INVALID);
//   Deletes the record in the Quest Progress Table for the Character (oPC)
//   Removing the Status for the Quest (iQuestID) given by the NPC (oNPC).
void RQS_AbortQuest(object oPC, int iQuestID, object oNPC=OBJECT_INVALID);

// RQS_OnKill(object oPC, object oNPC);
//   Process the Quest Progress Table Update when the Character (oPC)
//   kills a Quest NPC (oNPC)
void RQS_OnKill(object oPC, object oNPC);

// RQS_OnGain(object oPC, object oItem=OBJECT_INVALID);
//   Process the Quest Progress Table Update when the Character (oPC)
//   gains a Quest Item (oItem).  The Progress is increased by 1 toward the goal.
void RQS_OnGain(object oPC, object oItem=OBJECT_INVALID);

// RQS_OnLose(object oPC, object oItem=OBJECT_INVALID);
//   Process the Quest Progress Table Update when the Character (oPC)
//   gains a Quest Item (oItem).  The Progress is decreased by 1 away from the goal.
void RQS_OnLose(object oPC, object oItem=OBJECT_INVALID);

// RQS_OnArrive(object oPC, object oLocation);
//   Mark the appropriate Quest as Complete (RQS_QUEST_COMPLETE) when the Character (oPC)
//   enters a Trigger (oLocation).  The character has arrived at the destination.
void RQS_OnArrive(object oPC, object oLocation);

// RQS_OnSpawn(object oPC, object oEncounter);
//   When a Character (oPC) enters an Encounter Trigger (oEncounter), a check is made to
//   see if the character is on the quest that this trigger is for.
//   If the character is on the quest, the creatures are allowed to Spawn.
//   If the character is not on the quest associated with this trigger, the creatures are de-spawned.
void RQS_OnSpawn(object oPC, object oEncounter);


// =============================================================
// GLOBAL CONSTANTS
// =============================================================

int RQS_QUEST_TYPE_KILL_ALL = 1;	// KILL X NUMBER OF CREATURES
int RQS_QUEST_TYPE_COLLECT  = 2;	// COLLECT X NUMBER OF ITEMS FROM GROUND/CREATURES
int RQS_QUEST_TYPE_DELIVER  = 3;	// DELIVER THE OBJECT GIVEN BY THE ORIGINATOR, TO THE DESTINATION
int RQS_QUEST_TYPE_ESCORT   = 4;	// ESCORT THE NPC TO A CERTAIN LOCATION/TRIGGER
int RQS_QUEST_TYPE_DISCOVER = 5;	// GO TO A LOCATION, STEP INSIDE A CERTAIN TRIGGER WHICH COMPLETES QUEST
int RQS_QUEST_TYPE_CREATE   = 6;	// USE TRADESKILLS TO CREATE A DESIGNATED ITEM

int RQS_QUEST_COMPLETE      = 998;	// NUMBER USED TO MARK A QUEST COMPLETED FOR THE CHARACTER
int RQS_QUEST_REWARDED		= 999;	// NUMBER USED TO MARK A QUEST COMPLETED, AND CHARACTER REWARDED;

int RQS_LOADED_FALSE        = 1;	// FALSE VALUE
int RQS_LOADED_TRUE         = 2;	// TRUE  VALUE


// =============================================================
// QUEST FUNCTIONS
// =============================================================

void RQS_ModuleInit_SQLite() {
  string sSQL;
  
  // CHECK QUEST TABLE
  WriteTimestampedLogEntry("-- Checking Table_RQS_Quest");
  sSQL = "QuestID int," +
         "QuestType int," + 
         "QuestName varchar(50)," + 
         "QuestMinLevel int," + 
         "QuestMaxLevel int," + 
		 "FactionID int," +
		 "QuestMinFaction int," +
		 "Repeatable int," +
		 "PreReqQuest int," +
		 "PreReqRace varchar(16)," +
		 "RewardXP int," +
		 "RewardGP int," +
		 "RewardAllItem int," +
         "OriginTag varchar(32)," + 
         "OriginName varchar(64)," + 
         "DestinationTag varchar(32)," + 
         "DestinationName varchar(64)"; 
  if (DBTableExists("Table_RQS_Quest", sSQL)) { 
    // DO NOTHING 
  }

  // CHECK QUEST GOAL TABLE
  WriteTimestampedLogEntry("-- Checking Table_RQS_Goal");
  sSQL = "QuestGoalID int," +
         "QuestID int," + 
         "ItemTag varchar(32)," + 
         "ItemName varchar(64)," + 
         "ItemQty int";
  if (DBTableExists("Table_RQS_Goal", sSQL)) { 
    // DO NOTHING 
  }

  // CHECK QUEST ITEM REWARD TABLE
  WriteTimestampedLogEntry("-- Checking Table_RQS_Reward");
  sSQL = "QuestRewardID int," +
         "QuestID int," + 
         "ItemTag varchar(32)," + 
         "ItemName varchar(64)," + 
         "ItemQty int";
  if (DBTableExists("Table_RQS_Reward", sSQL)) { 
    // DO NOTHING 
  }

  // CHECK QUEST FACTION REWARD TABLE
  WriteTimestampedLogEntry("-- Checking Table_RQS_Faction");
  sSQL = "QuestFactionID int," +
         "QuestID int," + 
         "FactionID int," + 
         "FactionChange int";
  if (DBTableExists("Table_RQS_Faction", sSQL)) { 
    // DO NOTHING 
  }

  // CHECK QUEST CHARACTER PROGRESS TABLE
  WriteTimestampedLogEntry("-- Checking Table_RQS_Progress");
  sSQL = "QuestProgressID int," +
         "QuestID int," + 
         "CharacterID int," + 
         "ItemTag varchar(32)," + 
         "ItemQty int";
  if (DBTableExists("Table_RQS_Progress", sSQL)) { 
    // DO NOTHING 
  }

}


void RQS_ModuleInit_MySQL() {
  string sSQL;

  // CHECK RECIPE TABLE
  WriteTimestampedLogEntry("-- Checking Table_RQS_Quest");
  sSQL = "QuestID int," +
         "QuestType int," + 
         "QuestName varchar(50)," + 
         "QuestMinLevel int," + 
         "QuestMaxLevel int," + 
		 "FactionID int," +
		 "QuestMinFaction int," +
		 "Repeatable int," +
		 "PreReqQuest int," +
		 "PreReqRace varchar(16)," +
		 "RewardXP int," +
		 "RewardGP int," +
		 "RewardAllItem int," +
         "OriginTag varchar(32)," + 
         "OriginName varchar(64)," + 
         "DestinationTag varchar(32)," + 
         "DestinationName varchar(64)," +
		 "PRIMARY KEY (QuestID)";
  if (DBTableExists("Table_RQS_Quest", sSQL)) { 
    // DO NOTHING 
  }

  // CHECK QUEST GOAL TABLE
  WriteTimestampedLogEntry("-- Checking Table_RQS_Goal");
  sSQL = "QuestGoalID int," +
         "QuestID int," + 
         "ItemTag varchar(32)," + 
         "ItemName varchar(64)," + 
         "ItemQty int," +
		 "PRIMARY KEY (QuestGoalID)";
  if (DBTableExists("Table_RQS_Goal", sSQL)) { 
    // DO NOTHING 
  }

  // CHECK QUEST ITEM REWARD TABLE
  WriteTimestampedLogEntry("-- Checking Table_RQS_Reward");
  sSQL = "QuestRewardID int," +
         "QuestID int," + 
         "ItemTag varchar(32)," + 
         "ItemName varchar(64)," + 
         "ItemQty int," +
		 "PRIMARY KEY (QuestRewardID)";
  if (DBTableExists("Table_RQS_Reward", sSQL)) { 
    // DO NOTHING 
  }

  // CHECK QUEST FACTION REWARD TABLE
  WriteTimestampedLogEntry("-- Checking Table_RQS_Faction");
  sSQL = "QuestFactionID int," +
         "QuestID int," + 
         "FactionID int," + 
         "FactionChange int," +
		 "PRIMARY KEY (QuestFactionID)";
  if (DBTableExists("Table_RQS_Faction", sSQL)) { 
    // DO NOTHING 
  }

  // CHECK QUEST CHARACTER PROGRESS TABLE
  WriteTimestampedLogEntry("-- Checking Table_RQS_Progress");
  sSQL = "QuestProgressID int," +
         "QuestID int," + 
         "CharacterID int," + 
         "ItemTag varchar(32)," + 
         "ItemQty int," +
		 "PRIMARY KEY (QuestProgressID)";
  if (DBTableExists("Table_RQS_Progress", sSQL)) { 
    // DO NOTHING 
  }
  
}


void RQS_ModuleInitQuests() {

  // ABORT IF THE DATABASE IS OFFLINE
  if (gDatabaseType < DATABASE_TYPE_NWNX)
	iRQSactiveSystem = FALSE;
	
  // ABORT IF THE QUEST SYSTEM IS NOT ACTIVE
  if (iRQSactiveSystem == FALSE)
	return;

  // CHECK TO MAKE SURE THE QUEST TABLES EXIST
  // CREATE THE TABLES IF THEY DO NOT EXIST
  if (gDatabaseFormat == DATABASE_FORMAT_SQLITE)
  	RQS_ModuleInit_SQLite();
  if (gDatabaseFormat == DATABASE_FORMAT_MYSQL)
  	RQS_ModuleInit_MySQL();

}


void RQS_PlayerEnter(object oPC) {
  string sSQL;
  int    iCID;
  int    iQuestID;
  int    iState;
  
  // ABORT IF THE QUEST SYSTEM IS NOT ACTIVE
  if (iRQSactiveSystem == FALSE)
	return;

  // CHECK IF THE oPC OBJECT IS A PLAYER
  if (!GetIsPC(oPC))
  	return;

  // GET THE CHARACTER'S CHARACTERID
  iCID = GetCharacterID(oPC);
  
  // BUILD SQL STATEMENT TO FIND ALL THE QUEST THE CHARACTER IS ON
  sSQL = "SELECT QuestID,ItemQty FROM " + gTable_Prefix + "Table_RQS_Progress WHERE CharacterID=" + IntToString(iCID) + " AND ItemTag='OVERALL'";
  SQLExecDirect(sSQL);
  
  // UPDATE THE JOURNAL WITH THE DATABASE ENTRIES
  while (SQLFetch() == SQL_SUCCESS) {
  	iQuestID = StringToInt(SQLGetData(1));
  	iState   = StringToInt(SQLGetData(2));

    SetLocalInt(oPC, "RQS_Q" + IntToString(iQuestID) + "_COMPLETE", RQS_LOADED_FALSE);
    SetLocalInt(oPC, "RQS_Q" + IntToString(iQuestID) + "_REWARDED", RQS_LOADED_FALSE);
    SetLocalInt(oPC, "RQS_Q" + IntToString(iQuestID) + "_STARTED",  RQS_LOADED_TRUE);	
	if (iState >= RQS_QUEST_COMPLETE)
	  SetLocalInt(oPC, "RQS_Q" + IntToString(iQuestID) + "_COMPLETE", RQS_LOADED_TRUE);
	if (iState == RQS_QUEST_REWARDED)
	  SetLocalInt(oPC, "RQS_Q" + IntToString(iQuestID) + "_REWARDED", RQS_LOADED_TRUE);
	  
	AddJournalQuestEntry("RQS_" + IntToString(iQuestID), iState, oPC, FALSE, FALSE, TRUE);
  }

}

int RQS_GetIsOnQuest(object oPC, int iQuestID) {
  int isOnQuest;
  int iCID;

  // ABORT IF THE QUEST SYSTEM IS NOT ACTIVE
  if (iRQSactiveSystem == FALSE)
	return FALSE;

  // CHECK IF THE oPC OBJECT IS A PLAYER
  if (!GetIsPC(oPC))
  	return FALSE;

  // MAKE SURE THAT THE CREATURE IS A QUEST CREATURE
  if (iQuestID == 0)
    return FALSE;

  // GET THE CHARACTER ID
  iCID = GetCharacterID(oPC);
  
  // GET THE QUEST STARTED LOCAL VARIABLE
  isOnQuest = GetLocalInt(oPC, "RQS_Q" + IntToString(iQuestID) + "_STARTED");

  // CHECK IF THE CHARACTER IS ON THIS QUEST
  if (isOnQuest == 0) {
    isOnQuest = DBReadInt("Table_RQS_Progress", "ItemQty", "QuestID=" + IntToString(iQuestID) + " AND CharacterID=" + IntToString(iCID) + " AND ItemTag='OVERALL'");
	if (isOnQuest > 0 && isOnQuest < RQS_QUEST_COMPLETE)
	  isOnQuest = RQS_LOADED_TRUE;
	else
	  isOnQuest = RQS_LOADED_FALSE;
	SetLocalInt(oPC, "RQS_Q" + IntToString(iQuestID) + "_STARTED", isOnQuest);
  }
  
  return (isOnQuest == RQS_LOADED_TRUE);
  
}


int  RQS_isEligibleForQuest(object oPC, int iQuestID) {
  int    isEligible = TRUE;
  int    iQMinLevel, iQMaxLevel, iQuest;
  int	 iRepeat, iFaction, iFactionRk, iCID;
  int	 i;
  string sSQL;
  string sRace, sPRace;
  
  // ABORT IF THE QUEST SYSTEM IS NOT ACTIVE
  if (iRQSactiveSystem == FALSE)
	return FALSE;

  // CHECK IF THE oPC OBJECT IS A PLAYER
  if (!GetIsPC(oPC))
  	return FALSE;

  // MAKE SURE THAT THE CREATURE IS A QUEST CREATURE
  if (iQuestID == 0)
    return FALSE;

  // MAKE SURE THAT THE CHARACTER MEETS THE LEVEL REQUIREMENTS, RACIAL REQUIREMENT AND
  // THAT THEY'VE COMPLETED ANY QUESTS NECESSARY TO DO THIS QUEST
  sSQL = "SELECT QuestMinLevel,QuestMaxLevel,PreReqRace,PreReqQuest,Repeatable, QuestMinFaction " +
  		 "FROM " + gTable_Prefix + "Table_RQS_Quest WHERE QuestID=" + IntToString(iQuestID);
  SQLExecDirect(sSQL);
  if (SQLFetch() == SQL_SUCCESS) {
  
    iQMinLevel = StringToInt(SQLGetData(1));
    iQMaxLevel = StringToInt(SQLGetData(2));
    sRace      = "," + SQLGetData(3) + ",";
    iQuest     = StringToInt(SQLGetData(4));
	iRepeat    = StringToInt(SQLGetData(5));
	iFaction   = StringToInt(SQLGetData(6));
	iFactionRk = StringToInt(SQLGetData(7));
	sPRace     = "," + IntToString(GetRacialType(oPC)) + ",";
	iCID       = GetCharacterID(oPC);
	
	// CHECK FOR MINIMUM CHARACTER LEVEL
	if (iQMinLevel > GetLevel(oPC))
	  isEligible == FALSE;
	// CHECK FOR MAXIMUM CHARACTER LEVEL
	if (GetLevel(oPC) > iQMaxLevel && iQMaxLevel > 0)
	  isEligible == FALSE;
	// CHECK FOR CHARACTER RACE
	if (sRace != ",," && FindSubString(sRace, sPRace) == 0)
	  isEligible == FALSE;
	// CHECK FOR FACTION
	i = RFS_GetFactionRank(oPC, "", iFaction);
	if (GetLocalInt(oPC, "RFS_FactionRank_"  + IntToString(iFaction)) < iFactionRk)
	  isEligible = FALSE;
    // CHECK FOR PRE-REQUISITE QUESTS
	if (iQuest > 0) {
	  iQuest = DBReadInt("Table_RQS_Progress", "ItemQty", "QuestID=" + IntToString(iQuest) + " AND CharacterID=" + IntToString(iCID) + " AND ItemTag='OVERALL'");
	  if (iQuest < RQS_QUEST_REWARDED)
	  	isEligible = FALSE;
	}
    // CHECK FOR REPEATABILITY
    iQuest = DBReadInt("Table_RQS_Progress", "ItemQty", "QuestID=" + IntToString(iQuestID) + " AND CharacterID=" + IntToString(iCID) + " AND ItemTag='OVERALL'");	
    if (iQuest >= RQS_QUEST_COMPLETE && iRepeat == FALSE)
      isEligible = FALSE;
		
  } else
  	return FALSE;

  
  return isEligible;

}


int  RQS_isQuestStarted(object oPC, int iQuestID) {
  string sSQL;
  int    iCID;
  int    i;
  
  // ABORT IF THE QUEST SYSTEM IS NOT ACTIVE
  if (iRQSactiveSystem == FALSE)
	return FALSE;

  // CHECK IF THE oPC OBJECT IS A PLAYER
  if (!GetIsPC(oPC))
  	return FALSE;

  // MAKE SURE THAT THE CREATURE IS A QUEST CREATURE
  if (iQuestID == 0)
    return FALSE;

  // GET THE CHARACTER'S CHARACTERID
  iCID = GetCharacterID(oPC);
  
  // CHECK LOCAL VARIABLE
  if (GetLocalInt(oPC, "RQS_Q" + IntToString(iQuestID) + "_STARTED") > 0)
  	return  (GetLocalInt(oPC, "RQS_Q" + IntToString(iQuestID) + "_STARTED") == RQS_LOADED_TRUE);
  
  // CHECK IF THE QUEST IS MARKED COMPLETE FOR THIS CHARACTER
  if (DBRecordExists("Table_RQS_Progress", "QuestID=" + IntToString(iQuestID) + " AND CharacterID=" + IntToString(iCID) + " AND ItemTag='OVERALL'")) {
    SetLocalInt(oPC, "RQS_Q" + IntToString(iQuestID) + "_STARTED", RQS_LOADED_TRUE);
    return TRUE;
  } else
    SetLocalInt(oPC, "RQS_Q" + IntToString(iQuestID) + "_STARTED", RQS_LOADED_FALSE);
      
  return FALSE;
  
}


int  RQS_isQuestComplete(object oPC, int iQuestID) {
  string sSQL;
  int    iCompleteNum;
  int    isComplete = TRUE;
  int    iCID;
  int    i;
  
  // ABORT IF THE QUEST SYSTEM IS NOT ACTIVE
  if (iRQSactiveSystem == FALSE)
	return FALSE;

  // CHECK IF THE oPC OBJECT IS A PLAYER
  if (!GetIsPC(oPC))
  	return FALSE;

  // MAKE SURE THAT THE CREATURE IS A QUEST CREATURE
  if (iQuestID == 0)
    return FALSE;

  // GET THE CHARACTER'S CHARACTERID
  iCID = GetCharacterID(oPC);
  
  // CHECK IF OVERALL QUEST IS COMPLETE IN THE DATABASE
  iCompleteNum = DBReadInt("Table_RQS_Progress", "ItemQty", "QuestID=" + IntToString(iQuestID) + " AND CharacterID=" + IntToString(iCID) + " AND ItemTag='OVERALL'");
  if (iCompleteNum == RQS_QUEST_COMPLETE)
  	return TRUE;
	
  // CHECK LOCAL VARIABLE
//  if (GetLocalInt(oPC, "RQS_Q" + IntToString(iQuestID) + "_COMPLETE") > 0) 
//    return (GetLocalInt(oPC, "RQS_Q" + IntToString(iQuestID) + "_COMPLETE") == RQS_LOADED_TRUE);

  // CHECK OVERALL QUEST EXISTENCE
  if (DBRecordExists("Table_RQS_Progress", "QuestID=" + IntToString(iQuestID) + " AND CharacterID=" + IntToString(iCID) + " AND ItemTag='OVERALL'") == FALSE) {
    SetLocalInt(oPC, "RQS_Q" + IntToString(iQuestID) + "_COMPLETE", RQS_LOADED_FALSE);
  	return FALSE;
  }
  
  // QUERY THE DATABASE ON STATUS
  sSQL = "SELECT tp.ItemQty AS tpItemQty,tg.ItemQty AS tgItemQty FROM " + gTable_Prefix + "Table_RQS_Progress AS tp " +
         "JOIN " + gTable_Prefix + "Table_RQS_Goal AS tg ON tp.ItemTag=tg.ItemTag AND tp.QuestID=tg.QuestID " +
         "WHERE tp.QuestID=" + IntToString(iQuestID) + " " + 
		 "AND tp.CharacterID=" + IntToString(iCID) + " " +
		 "AND tp.ItemTag<>'OVERALL'";
  SQLExecDirect(sSQL);
  while (SQLFetch() == SQL_SUCCESS) {
    if (StringToInt(SQLGetData(1)) < StringToInt(SQLGetData(2)))
	  isComplete = FALSE;
  }
  		 
  // UPDATE THE OVERALL RECORD (IF APPLICABLE)
  if (isComplete) {
	if (iCompleteNum < RQS_QUEST_COMPLETE) { 
      FloatingTextStringOnCreature("You have Completed the [" + DBReadString("Table_RQS_Quest", "QuestName", "QuestID=" + IntToString(iQuestID)) + "] Quest.", oPC, FALSE);
	  RQS_CompleteQuest(oPC, iQuestID);
	}
  } else
    SetLocalInt(oPC, "RQS_Q" + IntToString(iQuestID) + "_COMPLETE", RQS_LOADED_FALSE);
  
  return isComplete;
  
}


int  RQS_isQuestFinished(object oPC, int iQuestID) {
  string sSQL;
  int    iCID;
  int    i;
  
  // ABORT IF THE QUEST SYSTEM IS NOT ACTIVE
  if (iRQSactiveSystem == FALSE)
	return FALSE;

  // CHECK IF THE oPC OBJECT IS A PLAYER
  if (!GetIsPC(oPC))
  	return FALSE;

  // MAKE SURE THAT THE CREATURE IS A QUEST CREATURE
  if (iQuestID == 0)
    return FALSE;

  // GET THE CHARACTER'S CHARACTERID
  iCID = GetCharacterID(oPC);
  
  // CHECK LOCAL VARIABLE
  if (GetLocalInt(oPC, "RQS_Q" + IntToString(iQuestID) + "_REWARDED") > 0) 
    return (GetLocalInt(oPC, "RQS_Q" + IntToString(iQuestID) + "_REWARDED") == RQS_LOADED_TRUE);
  
  // CHECK IF THE QUEST IS MARKED COMPLETE FOR THIS CHARACTER
  i = DBReadInt("Table_RQS_Progress", "ItemQty", "QuestID=" + IntToString(iQuestID) + " AND CharacterID=" + IntToString(iCID) + " AND ItemTag='OVERALL'");
  if (i == RQS_QUEST_REWARDED) {
    SetLocalInt(oPC, "RQS_Q" + IntToString(iQuestID) + "_REWARDED", RQS_LOADED_TRUE);
	return TRUE;
  } else
    SetLocalInt(oPC, "RQS_Q" + IntToString(iQuestID) + "_REWARDED", RQS_LOADED_FALSE);
      
  return FALSE;
  
}


int  RQS_isQuestRepeatable(int iQuestID) {
  int    i;
  
  // ABORT IF THE QUEST SYSTEM IS NOT ACTIVE
  if (iRQSactiveSystem == FALSE)
	return FALSE;

  // MAKE SURE THAT THE CREATURE IS A QUEST CREATURE
  if (iQuestID == 0)
    return FALSE;

  // CHECK LOCAL VARIABLE
  if (GetLocalInt(GetModule(), "RQS_Q" + IntToString(iQuestID) + "_REPEATABLE") > 0)
  	return (GetLocalInt(GetModule(), "RQS_Q" + IntToString(iQuestID) + "_REPEATABLE") == RQS_LOADED_TRUE);
  
  // CHECK IF THE QUEST IS MARKED COMPLETE FOR THIS CHARACTER
  i = DBReadInt("Table_RQS_Quest", "Repeatable", "QuestID=" + IntToString(iQuestID));
  SetLocalInt(GetModule(), "RQS_Q" + IntToString(iQuestID) + "_REPEATABLE", i + 1);    
  
  return i;
  
}


void RQS_SetConversationTokens(int iQuestID) {
  string sSQL;
  string sTemp = "";
  int    iType;
  int    iRewards;
  int    iPRQuest;
  
  // ABORT IF THE QUEST SYSTEM IS NOT ACTIVE
  if (iRQSactiveSystem == FALSE)
	return;

  // QUERY THE DATABASE FOR QUEST INFORMATION
  sSQL = "SELECT QuestName,QuestType,QuestMinLevel,QuestMaxLevel,OriginName,DestinationName,RewardGP,RewardAllItem " +
  		 "FROM " + gTable_Prefix + "Table_RQS_Quest WHERE QuestID=" + IntToString(iQuestID);
  SQLExecDirect(sSQL);
  
  if (SQLFetch() == SQL_SUCCESS) {
	// SET THE QUEST NAME
  	SetCustomToken(7501, SQLDecode(SQLGetData(1)));
  
  	// SET THE QUEST TYPE  
	iType = StringToInt(SQLGetData(2));
  	switch (iType) {
	  case 1:	SetCustomToken(7502, "Kill");     break;  
	  case 2:	SetCustomToken(7502, "Collect");  break;  
 	  case 3:	SetCustomToken(7502, "Deliver");  break;  
	  case 4:	SetCustomToken(7502, "Escort");   break;  
	  case 5:	SetCustomToken(7502, "Discover"); break;  
	  case 6:	SetCustomToken(7502, "Make");     break;  
  	}

	// SET THE QUEST LEVEL RANGES
  	SetCustomToken(7503, SQLGetData(3));
  	SetCustomToken(7504, SQLGetData(4));
  
    // SET THE QUEST ORIGINATOR NAME
  	SetCustomToken(7505, SQLDecode(SQLGetData(5)));
	
	// SET THE QUEST DESTINATION/TURN-IN NAME
  	SetCustomToken(7506, SQLDecode(SQLGetData(6)));
	
	// SET THE QUEST GP REWARD
  	SetCustomToken(7507, SQLGetData(7)+"gp");
	iRewards = StringToInt(SQLGetData(8));
	
	// GET THE ITEM(S) NECESSARY TO COMPLETE THIS QUEST
	sSQL = "SELECT ItemName,ItemQty FROM " + gTable_Prefix + "Table_RQS_Goal WHERE QuestID=" + IntToString(iQuestID);
	SQLExecDirect(sSQL);

	sTemp = "";	
	while (SQLFetch() == SQL_SUCCESS) {
	  sTemp = sTemp + SQLGetData(2) + " " + SQLGetData(1) + ", ";	
	}
	if (sTemp != "")
	  sTemp = GetStringLeft(sTemp, GetStringLength(sTemp)-2);

	// SET THE QUEST ITEM(S) NECESSARY TO COMPLETE THIS QUEST
  	SetCustomToken(7508, sTemp);

	
	// GET THE PROGRESS OF THE QUEST
	sSQL = "SELECT tr.ItemName,tr.ItemTag,tp.ItemQty AS tpItemQty,tr.ItemQty AS trItemQty FROM " + gTable_Prefix + "Table_RQS_Reward AS tr " +
	       "JOIN " + gTable_Prefix + "Table_RQS_Progress AS tp ON tr.QuestID=tp.QuestID AND tr.ItemTag=tp.ItemTag " +
	       "WHERE QuestID=" + IntToString(iQuestID);

	sTemp = "";	
	while (SQLFetch() == SQL_SUCCESS) {
	  sTemp = sTemp + SQLDecode(SQLGetData(1)) + "(" + SQLGetData(3) + "/" + SQLGetData(4) + "), ";	
	}
	if (sTemp != "")
	  sTemp = GetStringLeft(sTemp, GetStringLength(sTemp)-2);

	// SET THE QUEST ITEM(S) NECESSARY TO COMPLETE THIS QUEST
  	SetCustomToken(7509, sTemp);

	
	// GET THE ITEM REWARDS FOR THIS QUEST
	sTemp = "";
	sSQL = "SELECT ItemName,ItemQty FROM " + gTable_Prefix + "Table_RQS_Reward WHERE QuestID=" + IntToString(iQuestID);
	SQLExecDirect(sSQL);
	
	while (SQLFetch() == SQL_SUCCESS) {
	  sTemp = sTemp + SQLDecode(SQLGetData(1));
	  if (StringToInt(SQLGetData(2)) > 1)
	  	sTemp = sTemp + " x" + SQLGetData(2);
		
	  if (iRewards == TRUE)
	  	sTemp = sTemp + " and ";	
	  else
	  	sTemp = sTemp + " or ";	
	}
	if (sTemp != "")
	  sTemp = GetStringLeft(sTemp, GetStringLength(sTemp)-4);

	// SET THE QUEST ITEM REWARDS FOR THIS QUEST
  	SetCustomToken(7510, sTemp);
				
  }
	
}


void RQS_StartQuest(object oPC, int iQuestID, object oNPC=OBJECT_INVALID) {
  string strFields;
  string strValues;
  string sAllGoals;
  string sCurGoal;
  string sSQL;
  int    iCID;
  int    iCount;
  int    i, n;
  
  // ABORT IF THE QUEST SYSTEM IS NOT ACTIVE
  if (iRQSactiveSystem == FALSE)
	return;

  // CHECK IF THE oPC OBJECT IS A PLAYER
  if (!GetIsPC(oPC))
  	return;

  // MAKE SURE THAT THE CREATURE IS A QUEST CREATURE
  if (iQuestID == 0)
	if (oNPC != OBJECT_INVALID)
	  iQuestID = GetLocalInt(oNPC, "RQS_QuestID");
	else
	  return;
  if (iQuestID == 0)
    return;

  // GET THE CHARACTER'S CHARACTERID
  iCID = GetCharacterID(oPC);
  
  // MAKE SURE THE CHARACTER IS ELIGIBLE FOR THIS QUEST  
  if (RQS_isEligibleForQuest(oPC, iQuestID) == FALSE)
  	return;
	
  // SET QUEST AS STARTED
  if (DBRecordExists("Table_RQS_Progress", "QuestID=" + IntToString(iQuestID) + " AND CharacterID=" + IntToString(iCID) + " AND ItemTag='OVERALL'") == TRUE) {
	// UPDATE OVERALL QUEST PROGRESS RECORD
	DBDeleteRecord("Table_RQS_Progress", "QuestID=" + IntToString(iQuestID) + " AND CharacterID=" + IntToString(iCID) + " AND ItemTag<>'OVERALL'");
	DBUpdateInt("Table_RQS_Progress", "ItemQty", 1, "QuestID=" + IntToString(iQuestID) + " AND CharacterID=" + IntToString(iCID) + " AND ItemTag='OVERALL'");
  } else {
	// ADD OVERALL QUEST PROGRESS RECORD
	strFields = "QuestID,CharacterID,ItemTag,ItemQty";
	strValues = IntToString(iQuestID) + "," + IntToString(iCID) + ",'OVERALL',1";
	i = DBAddRecord("Table_RQS_Progress", strFields, strValues, "QuestProgressID");
  }
  
  // SET LOCAL VARIABLES
  SetLocalInt(oPC, "RQS_Q" + IntToString(iQuestID) + "_STARTED",  RQS_LOADED_TRUE);
  SetLocalInt(oPC, "RQS_Q" + IntToString(iQuestID) + "_COMPLETE", RQS_LOADED_FALSE);
  SetLocalInt(oPC, "RQS_Q" + IntToString(iQuestID) + "_REWARDED", RQS_LOADED_FALSE);
	
  // SET THE JOURNAL ENTRY AS STARTED
  RemoveJournalQuestEntry("RQS_" + IntToString(iQuestID), oPC, FALSE, FALSE);
  AddJournalQuestEntry("RQS_" + IntToString(iQuestID), 1, oPC, FALSE, FALSE);

  // ADD INDIVIDUAL QUEST TRACKING RECORDS
  sAllGoals = "";
  sSQL = "SELECT ItemTag FROM " + gTable_Prefix + "Table_RQS_Goal WHERE QuestID=" + IntToString(iQuestID);
  SQLExecDirect(sSQL);
	
  while (SQLFetch() == SQL_SUCCESS) {
	sAllGoals = sAllGoals + SQLDecode(SQLGetData(1)) + "|";
  }
  
  iCount = GetArrayCount(sAllGoals);  
  for (n=1; n <= iCount; n++) {
	sCurGoal = GetArrayString(sAllGoals, n);
	if (sCurGoal != "")
	  if (DBRecordExists("Table_RQS_Progress",  "QuestID=" + IntToString(iQuestID) + " AND CharacterID=" + IntToString(iCID) + " AND ItemTag='" + sCurGoal + "'") == FALSE) {
	    strFields = "QuestID,CharacterID,ItemTag,ItemQty";
	  	strValues = IntToString(iQuestID) + "," + IntToString(iCID) + ",'" + sCurGoal + "',0";
	 	i = DBAddRecord("Table_RQS_Progress", strFields, strValues, "QuestProgressID");
	  }	else
	    n = iCount;
  }
  
}


void RQS_CompleteQuest(object oPC, int iQuestID, object oNPC=OBJECT_INVALID) {
  int iCID;

  // ABORT IF THE QUEST SYSTEM IS NOT ACTIVE
  if (iRQSactiveSystem == FALSE)
	return;

  // CHECK IF THE oPC OBJECT IS A PLAYER
  if (!GetIsPC(oPC))
  	return;

  // MAKE SURE THAT THE CREATURE IS A QUEST CREATURE
  if (iQuestID == 0)
	if (oNPC != OBJECT_INVALID)
	  iQuestID = GetLocalInt(oNPC, "RQS_QuestID");
	else
	  return;
  if (iQuestID == 0)
    return;

  // GET THE CHARACTER'S CHARACTERID
  iCID = GetCharacterID(oPC);
  
  // SET THE QUEST AS COMPLETE
  if (oNPC != OBJECT_INVALID) {
    SetLocalInt(oPC, "RQS_Q" + IntToString(iQuestID) + "_" + GetTag(oNPC), RQS_QUEST_COMPLETE);
    DBUpdateInt("Table_RQS_Progress", "ItemQty", RQS_QUEST_COMPLETE, "QuestID=" + IntToString(iQuestID) + " AND CharacterID=" + IntToString(iCID) + " AND ItemTag='" + GetTag(oNPC) + "'");
  } else {
    SetLocalInt(oPC, "RQS_Q" + IntToString(iQuestID) + "_OVERALL", RQS_QUEST_COMPLETE);
    DBUpdateInt("Table_RQS_Progress", "ItemQty", RQS_QUEST_COMPLETE, "QuestID=" + IntToString(iQuestID) + " AND CharacterID=" + IntToString(iCID) + " AND ItemTag='OVERALL'");
  }
  
  // SET THE JOURNAL ENTRY AS COMPLETE
  AddJournalQuestEntry("RQS_" + IntToString(iQuestID), RQS_QUEST_COMPLETE, oPC, FALSE, FALSE);
  SetLocalInt(oPC, "RQS_Q" + IntToString(iQuestID) + "_COMPLETE", RQS_LOADED_TRUE);
  
}


void RQS_RewardQuest(object oPC, int iQuestID, object oNPC=OBJECT_INVALID) {
  object oItem;
  string sSQL;
  string sTemp;
  string sData;
  int    iCID;
  int    iGiveAll;
  int    iFactionID;
  int    iFactionChange;
  int    iCount;
  int    i, n, c;

  // ABORT IF THE QUEST SYSTEM IS NOT ACTIVE
  if (iRQSactiveSystem == FALSE)
	return;

  // CHECK IF THE oPC OBJECT IS A PLAYER
  if (!GetIsPC(oPC))
  	return;

  // MAKE SURE THAT THE CREATURE IS A QUEST CREATURE
  if (iQuestID == 0)
	if (oNPC != OBJECT_INVALID)
	  iQuestID = GetLocalInt(oNPC, "RQS_QuestID");
	else 	  
	  return;
  if (iQuestID == 0)
    return;

  // GET THE CHARACTER'S CHARACTERID
  iCID = GetCharacterID(oPC);

  // SET THE QUEST AS COMPLETE
  DBUpdateInt("Table_RQS_Progress", "ItemQty", RQS_QUEST_REWARDED, "QuestID=" + IntToString(iQuestID) + " AND CharacterID=" + IntToString(iCID) + " AND ItemTag='OVERALL'");
  i = DBDeleteRecord("Table_RQS_Progress", "QuestID=" + IntToString(iQuestID) + " AND CharacterID=" + IntToString(iCID) + " AND ItemTag<>'OVERALL'");
  if (oNPC != OBJECT_INVALID)
    SetLocalInt(oPC, "RQS_Q" + IntToString(iQuestID) + "_" + GetTag(oNPC), RQS_QUEST_REWARDED);
  else
    SetLocalInt(oPC, "RQS_Q" + IntToString(iQuestID) + "_OVERALL", RQS_QUEST_REWARDED);

  // SET THE JOURNAL ENTRY AS REWARDED
  AddJournalQuestEntry("RQS_" + IntToString(iQuestID), RQS_QUEST_REWARDED, oPC, FALSE, FALSE);
  SetLocalInt(oPC, "RQS_Q" + IntToString(iQuestID) + "_REWARDED", RQS_LOADED_TRUE);
  
  // REWARD THE CHARACTER WITH GP AND XP REWARDS
  GiveGoldToCreature(oPC, DBReadInt("Table_RQS_Quest", "RewardGP", "QuestID=" + IntToString(iQuestID)));
  GiveXPToCreature(oPC,  DBReadInt("Table_RQS_Quest", "RewardXP", "QuestID=" + IntToString(iQuestID)));
  iGiveAll = DBReadInt("Table_RQS_Quest", "RewardAllItem", "QuestID=" + IntToString(iQuestID));
  if (iGiveAll == TRUE) {
    iGiveAll = DBReadInt("Table_RQS_Quest", "COUNT(*)", "QuestID=" + IntToString(iQuestID));
	iGiveAll = Random(iGiveAll) + 1;
  } else
    iGiveAll = 0;
	
  // REWARD THE CHARACTER WITH ITEM REWARD(S)
  sSQL = "SELECT ItemTag,ItemQty FROM " + gTable_Prefix + "Table_RQS_Reward WHERE QuestID=" + IntToString(iQuestID);
  SQLExecDirect(sSQL);
  i = 0;
  while (SQLFetch() == SQL_SUCCESS && ( (iGiveAll == 0) || (iGiveAll > 0 && i < iGiveAll) ) ) {
    i++;
	if (i == iGiveAll || iGiveAll == 0) 
	  CreateItemOnObject(SQLDecode(SQLGetData(1)), oPC, StringToInt(SQLGetData(2)));
  }
  
  // REWARD THE CHARACTER WITH FACTION REWARD(S)
  iCount = 0;
  sData  = "";
  sSQL = "SELECT FactionID, FactionChange FROM " + gTable_Prefix + "Table_RQS_Faction WHERE QuestID=" + IntToString(iQuestID);
  SQLExecDirect(sSQL);
  while (SQLFetch() == SQL_SUCCESS) {
    iCount++;
    sData = sData + SQLGetData(1) + "/" + SQLGetData(2) + "|";
  }
  for (i=1; i<=iCount; i++) {
    sTemp = GetArrayString(sData, i);
	n = FindSubString(sTemp, "/") + 1;
	if (n > 0) {
	  iFactionID = StringToInt(GetStringLeft(sTemp, n-1));
	  iFactionChange = StringToInt(GetStringRight(sTemp, GetStringLength(sTemp)-n));
	  RFS_UpdateFaction(oPC, iFactionID, iFactionChange);
	}
  }
 
  // REMOVE THE QUEST GOAL ITEMS FROM THE CHARACTER'S INVENTORY
  iCount = 0;
  sData  = "";
  sSQL = "SELECT ItemTag,ItemQty FROM " + gTable_Prefix + "Table_RQS_Goal WHERE QuestID=" + IntToString(iQuestID); 
  SQLExecDirect(sSQL);
  while (SQLFetch() == SQL_SUCCESS) {
    iCount++;
	sData = sData + SQLGetData(1) + "/" + SQLGetData(2) + "|";
  }  
  for (i=1; i<=iCount; i++) {
    sTemp = GetArrayString(sData, i);
	n = FindSubString(sTemp, "/") + 1;
	if (n > 0) {
	  c     = StringToInt(GetStringRight(sTemp, GetStringLength(sTemp)-n));
	  sTemp = GetStringLeft(sTemp, n-1);
      for (n=1; n<=c; n++) {
	    oItem = GetTrackedItemPossessedBy(oPC, sTemp);
	    if (oItem != OBJECT_INVALID) {
	      SetPlotFlag(oItem, FALSE);
		  SetLocalInt(oItem, "DESTROY_ME", TRUE);
		  DestroyObject(oItem);
	    }
	  }
	}
  }
  
}


void RQS_AbortQuest(object oPC, int iQuestID, object oNPC=OBJECT_INVALID) {
  int iCID;
  int i;

  // ABORT IF THE QUEST SYSTEM IS NOT ACTIVE
  if (iRQSactiveSystem == FALSE)
	return;

  // CHECK IF THE oPC OBJECT IS A PLAYER
  if (!GetIsPC(oPC))
  	return;

  // MAKE SURE THAT THE CREATURE IS A QUEST CREATURE
  if (iQuestID == 0)
	if (oNPC != OBJECT_INVALID)
	  iQuestID = GetLocalInt(oNPC, "RQS_QuestID");
	else
	  return;
  if (iQuestID == 0)
    return;

  // GET THE CHARACTER'S CHARACTERID
  iCID = GetCharacterID(oPC);

  // REMOVE THE QUEST ENTRY FROM THE QUEST PROGRESS TABLE FOR THE CHARACTER
  if (DBReadInt("Table_RQS_Progress", "ItemQty", "QuestID=" + IntToString(iQuestID) + " AND CharacterID=" + IntToString(iCID)) < RQS_QUEST_REWARDED)
    i = DBDeleteRecord("Table_RQS_Progress", "QuestID=" + IntToString(iQuestID) + " AND CharacterID=" + IntToString(iCID));
  
  // SET LOCAL VARIABLES
  SetLocalInt(oPC, "RQS_Q" + IntToString(iQuestID) + "_STARTED",  RQS_LOADED_FALSE);
  SetLocalInt(oPC, "RQS_Q" + IntToString(iQuestID) + "_COMPLETE", RQS_LOADED_FALSE);
  SetLocalInt(oPC, "RQS_Q" + IntToString(iQuestID) + "_REWARDED", RQS_LOADED_FALSE);

  // REMOVE JOURNAL ENTRY
  RemoveJournalQuestEntry("RQS_" + IntToString(iQuestID), oPC, FALSE, FALSE);
  
}




void RQS_OnKill(object oPC, object oNPC) {
  string sItemTag;
  object oParty;
  int    iQuestID;
  int    iQuestType;
  int    iNeeded;
  int    iCID;
  int    i;

  // ABORT IF THE QUEST SYSTEM IS NOT ACTIVE
  if (iRQSactiveSystem == FALSE)
	return;

  // MAKE SURE THE PLAYER IS LOADED
  if (oPC == OBJECT_INVALID)
    oPC = GetLastKiller();
	
  // CHECK IF THE oPC OBJECT IS A PLAYER
  if (!GetIsPC(oPC))
  	return;

  // MAKE SURE THAT THE CREATURE IS A QUEST CREATURE
  iQuestID = GetLocalInt(oNPC, "RQS_QuestID");
  if (iQuestID == 0)
    return;

  // MAKE SURE THE CHARACTER IS ON THE QUEST, AND THE QUEST IS NOT COMPLETED
  if (RQS_GetIsOnQuest(oPC, iQuestID) == FALSE)
  	return;
	
  // GET THE CHARACTER'S CHARACTERID
  iCID = GetCharacterID(oPC);
  
  // CHECK THE STYLE OF QUEST THAT THIS IS
  iQuestType = GetLocalInt(GetModule(), "RQS_QUEST_TYPE_" + IntToString(iQuestID));
  if (iQuestType == 0) {
    iQuestType = DBReadInt("Table_RQS_Quest", "QuestType", "QuestID=" + IntToString(iQuestID));
    SetLocalInt(GetModule(), "RQS_QUEST_TYPE_" + IntToString(iQuestID), iQuestType);
  }
  
  // CHECK FOR OBJECT NEEDED QUANTITY
  iNeeded = DBReadInt("Table_RQS_Goal", "ItemQty", "QuestID=" + IntToString(iQuestID) + " AND ItemTag='" + GetTag(oNPC) + "'");
  if (iNeeded == 0) 
    return;
	
  switch (iQuestType) {
	case 1:		// RQS_QUEST_TYPE_KILL_ALL:

		// INCREASE KILL COUNT FOR THE NPC'S KILLER
  	    i = DBReadInt("Table_RQS_Progress", "ItemQty", "QuestID=" + IntToString(iQuestID) + " AND CharacterID=" + IntToString(iCID) + " AND ItemTag='" + GetTag(oNPC) + "'");
		if (i+1 < iNeeded) {		  
		  i++;
		  FloatingTextStringOnCreature("You have killed " + IntToString(i) + " " + GetName(oNPC) + "s (out of " + IntToString(iNeeded) + " needed for a Quest)", oPC, FALSE);
		} else {
		  if (i < RQS_QUEST_COMPLETE)
		    FloatingTextStringOnCreature("You have killed all the " + GetName(oNPC) + "s needed for this Quest", oPC, FALSE);
		  i = RQS_QUEST_COMPLETE;
		}
		DBUpdateInt("Table_RQS_Progress", "ItemQty", i, "QuestID=" + IntToString(iQuestID) + " AND CharacterID=" + IntToString(iCID) + " AND ItemTag='" + GetTag(oNPC) + "'");
		SetLocalInt(oPC, "RQS_Q" + IntToString(iQuestID) + "_" + GetTag(oNPC), i);	
		if (RQS_isQuestComplete(oPC, iQuestID)) { 
		  // DO NOTHING
		}	

		// INCREASE KILL COUNT FOR PARTY MEMBERS
		oParty = GetFirstFactionMember(oPC);
		while (oParty != OBJECT_INVALID) {
		  if (oParty != oPC) {

		    // GET THE CHARACTER'S CHARACTERID
			iCID = GetCharacterID(oPC);

			// GET QUEST PROGRESS
  		    i = DBReadInt("Table_RQS_Progress", "ItemQty", "QuestID=" + IntToString(iQuestID) + " AND CharacterID=" + IntToString(iCID) + " AND ItemTag='" + GetTag(oNPC) + "'");
			
			// FACTOR IN THIS KILL ONLY IF THE PARTY MEMBER IS ON THE QUEST, AND IN THE SAME AREA AS THE KILLER PC
			if (GetArea(oParty) == GetArea(oPC)) 
  			if (RQS_GetIsOnQuest(oParty, iQuestID) == TRUE) {
		  	  if (i+1 < iNeeded) {		  
			    i++;
			    FloatingTextStringOnCreature("You have killed " + IntToString(i) + " " + GetName(oNPC) + "s (out of " + IntToString(iNeeded) + " needed for a Quest)", oParty, FALSE);
			  } else {
			    if (i < RQS_QUEST_COMPLETE)
			      FloatingTextStringOnCreature("You have killed all the " + GetName(oNPC) + "s needed for this Quest", oParty, FALSE);
			    i = RQS_QUEST_COMPLETE;
			  }
			  DBUpdateInt("Table_RQS_Progress", "ItemQty", i, "QuestID=" + IntToString(iQuestID) + " AND CharacterID=" + IntToString(iCID) + " AND ItemTag='" + GetTag(oNPC) + "'");
		  	  SetLocalInt(oParty, "RQS_Q" + IntToString(iQuestID) + "_" + GetTag(oNPC), i);	
			  if (RQS_isQuestComplete(oParty, iQuestID)) { 
			    // DO NOTHING
			  }	
		  	}
		  	oParty = GetNextFactionMember(oPC);
		  }
		
		}
		break;
		
	case 2:		// RQS_QUEST_TYPE_COLLECT:
		// MAKE SURE THAT THE CREATURE HAS THE QUEST OBJECT IN THE INVENTORY
		sItemTag = GetLocalString(oNPC, "RQS_Item");
		if (sItemTag != "") {
		  if (GetTrackedItemPossessedBy(oNPC, sItemTag) == OBJECT_INVALID) 
		  	CreateItemOnObject(sItemTag, oNPC, 1);
		}
		break;
  }
    	
}


void RQS_OnGain(object oPC, object oItem=OBJECT_INVALID) {
  string sSQL;
  string sItemTag;
  int    iQuestID = 0;
  int    iQuestType;
  int    iNeeded;
  int    iHave;
  int    iCID;
  int    i;
  
  // ABORT IF THE QUEST SYSTEM IS NOT ACTIVE
  if (iRQSactiveSystem == FALSE)
	return;

  // MAKE SURE THE PLAYER IS VALID
  if (oPC == OBJECT_INVALID)
    oPC = GetModuleItemAcquiredBy();
	
  // CHECK IF THE oPC OBJECT IS A PLAYER
  if (!GetIsPC(oPC))
  	return;

  // IGNORE INITIAL LOG IN ITEM GAINS
  if (GetLocalInt(oPC, "ITEM_CREATING") > 0)
	return;	
	
  // MAKE SURE THE ITEM IS VALID
  if (oItem == OBJECT_INVALID)
    oItem = GetModuleItemAcquired();
	
  // GET THE CHARACTER'S CHARACTERID
  iCID = GetCharacterID(oPC);
  
  // GET THE ITEM'S TAG
  sItemTag = GetItemTag(oItem);
  
  // GET THE ASSSOCIATED QUEST ID
  sSQL = "SELECT tg.QuestID,tg.ItemQty AS tgItemQty,tp.ItemQty AS tpItemQty FROM " + gTable_Prefix + "Table_RQS_Goal AS tg " +
  		 "JOIN " + gTable_Prefix + "Table_RQS_Progress AS tp ON tg.QuestID=tp.QuestID AND tg.ItemTag=tp.ItemTag " +
		 "WHERE tg.ItemTag='" + sItemTag + "' " +
		 "AND tp.CharacterID=" + IntToString(iCID) + " " +
		 "AND tp.ItemQty<" + IntToString(RQS_QUEST_COMPLETE);
  SQLExecDirect(sSQL);
  
  if (SQLFetch() == SQL_SUCCESS) {
  	iQuestID = StringToInt(SQLGetData(1));
	iNeeded  = StringToInt(SQLGetData(2));
	iHave    = StringToInt(SQLGetData(3));
  } else
  	return;
 
  if (iQuestID > 0) {
    // UPDATE QUANTITIES (IF NECESSARY)
    if (iHave < iNeeded)		  
	  iHave++;
    DBUpdateInt("Table_RQS_Progress", "ItemQty", iHave, "QuestID=" + IntToString(iQuestID) + " AND CharacterID=" + IntToString(iCID) + " AND ItemTag='" + sItemTag + "'");
    SetLocalInt(oPC, "RQS_Q" + IntToString(iQuestID) + "_" + sItemTag, iHave);
 
    // NOTIFY THE PLAYER ABOUT THE GAIN OF A QUEST ITEM  
    FloatingTextStringOnCreature("You have gained a Quest Item.", oPC, FALSE);
    FloatingTextStringOnCreature("You need " + IntToString(iNeeded) + " " +GetName(oItem)+ ", you have " + IntToString(iHave) + ".", oPC, FALSE);

    // CHECK ENTIRE QUEST IS COMPLETE
    if (RQS_isQuestComplete(oPC, iQuestID)) { 
	  // DO NOTHING
    }	
  }	
}

void RQS_OnLose(object oPC, object oItem=OBJECT_INVALID) {
  string sSQL;
  string sItemTag;
  int    iQuestID = 0;
  int    iQuestType;
  int    iNeeded;
  int    iHave;
  int    iCID;
  int    i;
  
  // ABORT IF THE QUEST SYSTEM IS NOT ACTIVE
  if (iRQSactiveSystem == FALSE)
	return;

  // MAKE SURE THE PLAYER IS VALID
  if (oPC == OBJECT_INVALID)
    oPC = GetModuleItemLostBy();
	
  // CHECK IF THE oPC OBJECT IS A PLAYER
  if (!GetIsPC(oPC))
  	return;
	
  // MAKE SURE THE ITEM IS VALID
  if (oItem == OBJECT_INVALID)
    oItem = GetModuleItemLost();
	
  // GET THE CHARACTER'S CHARACTERID
  iCID = GetCharacterID(oPC);
  
  // GET THE ITEM'S TAG
  sItemTag = GetItemTag(oItem);
  
  // GET THE ASSSOCIATED QUEST ID
  sSQL = "SELECT tg.QuestID,tg.ItemQty AS tgItemQty,tp.ItemQty AS tpItemQty FROM " + gTable_Prefix + "Table_RQS_Goal AS tg " +
  		 "JOIN " + gTable_Prefix + "Table_RQS_Progress AS tp ON tg.QuestID=tp.QuestID AND tg.ItemTag=tp.ItemTag " +
		 "WHERE tg.ItemTag='" + sItemTag + "' " +
		 "AND tp.CharacterID=" + IntToString(iCID);
  SQLExecDirect(sSQL);
  
  if (SQLFetch() == SQL_SUCCESS) {
  	iQuestID = StringToInt(SQLGetData(1));
	iNeeded  = StringToInt(SQLGetData(2));
	iHave    = StringToInt(SQLGetData(3));
  } else
  	return;
 
  if (iQuestID > 0 && iHave < RQS_QUEST_REWARDED) {
    // CHECK IF QUEST WAS MARKED COMPLETE
	if (iHave >= iNeeded) {
	  iHave = iNeeded;
      DBUpdateInt("Table_RQS_Progress", "ItemQty", 1, "QuestID=" + IntToString(iQuestID) + " AND CharacterID=" + IntToString(iCID) + " AND ItemTag='OVERALL'");
      RemoveJournalQuestEntry("RQS_" + IntToString(iQuestID), oPC, FALSE, FALSE);
      AddJournalQuestEntry("RQS_" + IntToString(iQuestID), 1, oPC, FALSE, FALSE);
	}
	 
    // UPDATE QUANTITIES (IF NECESSARY)
    if (iHave > 0)		  
	  iHave--;
    DBUpdateInt("Table_RQS_Progress", "ItemQty", iHave, "QuestID=" + IntToString(iQuestID) + " AND CharacterID=" + IntToString(iCID) + " AND ItemTag='" + sItemTag + "'");
    SetLocalInt(oPC, "RQS_Q" + IntToString(iQuestID) + "_" + sItemTag, iHave);

    // NOTIFY THE PLAYER ABOUT THE LOSE OF A QUEST ITEM  
    FloatingTextStringOnCreature("You have dropped a Quest Item.", oPC, FALSE);
    FloatingTextStringOnCreature("You need " + IntToString(iNeeded) + " " +GetName(oItem)+ ", you have " + IntToString(iHave) + ".", oPC, FALSE);
   
    // CHECK ENTIRE QUEST IS COMPLETE
    if (RQS_isQuestComplete(oPC, iQuestID)) { 
  	  // DO NOTHING
    }	
  }
		
}

void RQS_OnArrive(object oPC, object oLocation) {
  string sSQL;
  int    iQuestID;
  int    iCID;
  
  // ABORT IF THE QUEST SYSTEM IS NOT ACTIVE
  if (iRQSactiveSystem == FALSE)
	return;

  // MAKE SURE THE PLAYER IS VALID
  if (oPC == OBJECT_INVALID)
    oPC = GetEnteringObject();
	
  // CHECK IF THE oPC OBJECT IS A PLAYER
  if (!GetIsPC(oPC))
  	return;

  // MAKE SURE THAT THE CREATURE IS A QUEST CREATURE
  iQuestID = GetLocalInt(oLocation, "RQS_QuestID");
  if (iQuestID == 0)
    return;

  // GET THE CHARACTER'S CHARACTERID
  iCID = GetCharacterID(oPC);
	  
  // MAKE SURE THE CHARACTER IS ON THE QUEST, AND THE QUEST IS NOT COMPLETED
  if (!RQS_isQuestStarted(oPC, iQuestID) || RQS_isQuestComplete(oPC, iQuestID) || RQS_isQuestFinished(oPC, iQuestID))
  	return;
	
  // MARK THE QUEST STEP AS COMPLETE
  RQS_CompleteQuest(oPC, iQuestID, oLocation);
   
  // NOTIFY THE PLAYER 
  FloatingTextStringOnCreature("You have found " + GetName(oLocation) + ",", oPC, FALSE);

  // CHECK ENTIRE QUEST IS COMPLETE
  if (RQS_isQuestComplete(oPC, iQuestID)) { 
	// DO NOTHING
  }	
		
}


void RQS_OnSpawn(object oPC, object oEncounter) {
  object oNPC;
  int    iQuestID;
  int    isOkayToSpawn;
  
  // ABORT IF THE QUEST SYSTEM IS NOT ACTIVE
  if (iRQSactiveSystem == FALSE)
	return;

  // MAKE SURE THE PLAYER IS VALID
  if (oPC == OBJECT_INVALID)
    oPC = GetEnteringObject();
	
  // CHECK IF THE oPC OBJECT IS A PLAYER
  if (!GetIsPC(oPC))
  	return;

  // MAKE SURE THAT THE CREATURE IS A QUEST CREATURE
  iQuestID = GetLocalInt(oEncounter, "RQS_QuestID");
  if (iQuestID == 0)
    return;

  // IF THE CHARACTER IS NOT ON THE QUEST THAT THIS ENCOUNTER IS ASSOCIATED WITH,
  // DE-SPAWN THE CREATURES.
  isOkayToSpawn = RQS_GetIsOnQuest(oPC, iQuestID);
  if (isOkayToSpawn)
    isOkayToSpawn = (RQS_isQuestComplete(oPC, iQuestID) == FALSE && RQS_isQuestFinished(oPC, iQuestID) == FALSE);
  
  if (isOkayToSpawn == FALSE) {
	oNPC = GetFirstInPersistentObject(oEncounter, OBJECT_TYPE_CREATURE, PERSISTENT_ZONE_ACTIVE);
	while (oNPC != OBJECT_INVALID) {
	  if (GetIsEncounterCreature(oNPC)) {
	    SetPlotFlag(oNPC, FALSE);
	    DestroyObject(oNPC);
	  }
	  oNPC = GetNextInPersistentObject(oEncounter, OBJECT_TYPE_CREATURE, PERSISTENT_ZONE_ACTIVE);
	}
  }

}