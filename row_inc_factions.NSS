// =============================================================
//
//    File: row_inc_factions
//    Desc: Rowell's Faction System
//  Author: Michael Marzilli
//    Site: http://www.engliton.org
//
// Created: Nov 06, 2006
// Updated: Jan 18, 2007
// Version: 1.0.3
//
// =============================================================

#include "nw_i0_generic"
#include "row_inc_functions"

// =============================================================
// SYSTEM USAGE
// =============================================================
//
// NOTE:  You will need to Add 3 new Custom Factions to your module.
//		  It is VERY important that these factions be placed in the proper slots.
//		  RFS_NEUTRAL in slot #5.  This faction should be Neutral (50) to all other Factions.
//		  RFS_HOSTILE in slot #6.  This faction should be Friendly (100) to Hostile and RFS_Hostile.
//		 						   This faction should be Hostile (0) to Player, Commoner, Defender, RFS_Friendly.
//								   This faction should be Neutral (50) to Merchant, RFS_Neutral.
//		  RFS_FRIENDLY in slot #7. This faction should be Hostile (0) to Hostile and RFS_Hostile.
//								   This faction should be Friendly (100) to all other factions.

// NOTE:  There seems to be some bugs in the NWN2 game where setting Personal Reputation
//        does not work.  The only way to make a neutral creature hostile is to change that
//        creature's faction to STANDARD_FACTION_RFS_HOSTILE.  Setting the reputation of the
//        Player to 0 with the NPC does not make the NPC Hostile.
//        This code will be updated as soon as Obsidian fixes the bug.  But, for now,
//        Whenever a creature needs to be hostile, it is moved to the
//        STANDARD_FACTION_RFS_HOSTILE Faction.



// =============================================================
// GLOBAL FUNCTIONS
// =============================================================

// RFS_ModuleInitFactions()
//   Called in the Module's OnModuleStart Event. 
//   This function initializes and sets up the RFS Factioning System
void RFS_ModuleInitFactions();

// RFS_GetFactionRank(object oPC, string sFactionName, int iFactionID=0, object oNPC=OBJECT_INVALID);
//   Given a Player (oPC), will determine their faction ranking with the faction defined by either sFactionName or oNPC.
//   If a creature is passed in oNPC, that creature's faction is used.  Otherwise, sFactionName is used.
//   Example 1: intRank = RFS_GetFactionRank(oPC, "goblin");
//   Example 2: intRank = RFS_GetFactionRank(oPC, "", 1);
//   Example 3: intRank = RFS_GetFactionRank(oPC, "", 0, oNPC);
int  RFS_GetFactionRank(object oPC, string sFactionName, int iFactionID=0, object oNPC=OBJECT_INVALID);

// RFS_InitNPC(object oNPC)
//   Called in the Creature's OnSpawn Event.
//   This function initalizes and sets up the creature in the RFS Factioning System
//   Example: RFS_InitNPC(OBJECT_SELF);
void RFS_InitNPC(object oNPC);

// RFS_SetFactionAttitude(object oPC, object oNPC)
//   Called in the Creature's OnPerception Event.
//   This function checks to see how the creature (oNPC) feels about what is perceived (oPC).
//   Attitude (hostility/friendliness/neutrality) is set accordingly.
//   Example: RFS_SetFactionAttitude(oPC, OBJECT_SELF);
void RFS_SetFactionAttitude(object oPC, object oNPC);

// RFS_ProcessNPC(object oPC, object oNPC, string strAction)
//   Called in the Creature's OnDeath Event, as well as several other places where
//   changes to faction are necessary.
//   This function applies changes to oPC's faction standing with oNPC, based on the action defined in strAction.
//   Example: RFS_ProcessNPC(oPC, OBJECT_SELF, "kill");
void RFS_ProcessNPC(object oPC, object oNPC, string strAction);

// RFS_UpdateFaction(object oPC, int iFactionID, int iFactionChange);
//   This function updates a Faction (iFactionID) by an amount (iFactionChange)
//   for the Player (oPC).
void RFS_UpdateFaction(object oPC, int iFactionID, int iFactionChange);

// RFS_GetStoreMarkup(object oPC, object oNPC)
//   This function returns an integer value, based on oPC's faction standing with oNPC Merchant,
//   which affects the Store's MarkUp when Selling to oPC
//   Example: iMarkUp = RFS_GetStoreMarkup(oPC, oMerchant);
int  RFS_GetStoreMarkup(object oPC, object oNPC);

// RFS_GetStoreMarkdown(object oPC, object oNPC)
//   This function returns an integer value, based on oPC's faction standing with oNPC Merchant,
//   which affects the Store's MarkDown when Buying from oPC
//   Example: iMarkDown = RFS_GetStoreMarkdown(oPC, oMerchant);
int  RFS_GetStoreMarkdown(object oPC, object oNPC);



// =============================================================
// GLOBAL CONSTANTS
// =============================================================

// DEFINE THE FACTION STANDING ENUMERATIONS
const int RFS_FACTION_KOS        = -5;
const int RFS_FACTION_HOSTILE    = -4;
const int RFS_FACTION_HATED      = -3;
const int RFS_FACTION_DISLIKED   = -2;
const int RFS_FACTION_UNFRIENDLY = -1;
const int RFS_FACTION_NEUTRAL    =  0;
const int RFS_FACTION_FRIENDLY   =  1;
const int RFS_FACTION_LIKED      =  2;
const int RFS_FACTION_TRUSTED    =  3;
const int RFS_FACTION_HONORED    =  4;
const int RFS_FACTION_LOVED      =  5;

const int STANDARD_FACTION_RFS_NEUTRAL = 5;
const int STANDARD_FACTION_RFS_HOSTILE = 6;
const int STANDARD_FACTION_RFS_FRIEND  = 7;


// =============================================================
// FACTION FUNCTIONS
// =============================================================

void RFS_ModuleInitFactions() {
  string sSQL;
  string sFactionID;
  string sAffectFactionID;
    
  // ABORT IF THE DATABASE IS OFFLINE
  if (gDatabaseType < DATABASE_TYPE_NWNX)
	iRFSactiveSystem = FALSE;
	
  // ABORT IF THE FACTION SYSTEM IS NOT ACTIVE
  if (iRFSactiveSystem == FALSE) 
  	return;
	
  // FIND ALL THE RULES WHICH SHOW ONE FACTION HATING ANOTHER
  sSQL = "SELECT FactionID,AffectFactionID FROM " + gTable_Prefix + "Table_Faction_Rule WHERE Action='hate'";
  DBOpen(sSQL);
  
  while (SQLFetch() == SQL_SUCCESS) {
    sFactionID       = SQLGetData(1);
    sAffectFactionID = SQLGetData(2);
	SetLocalInt(GetModule(), "RFS_" + sFactionID + "_HATES_" + sAffectFactionID, 1);
  }

}


int RFS_ValueToRank(int iValue) {
  int iRank;
  
  if (iValue  > 30000)
  	iValue    = 30000;
  if (iValue < -30000)
  	iValue   = -30000;
	
  if (iValue <=  -1000)   iRank = RFS_FACTION_UNFRIENDLY;
  if (iValue <=  -3000)   iRank = RFS_FACTION_DISLIKED;
  if (iValue <=  -7000)   iRank = RFS_FACTION_HATED;
  if (iValue <= -13000)   iRank = RFS_FACTION_HOSTILE;
  if (iValue <= -21000)   iRank = RFS_FACTION_KOS;
  if (iValue >   -1000 && 
      iValue <    1000)   iRank = RFS_FACTION_NEUTRAL;
  if (iValue >=   1000)   iRank = RFS_FACTION_FRIENDLY;
  if (iValue >=   3000)   iRank = RFS_FACTION_LIKED;
  if (iValue >=   7000)   iRank = RFS_FACTION_TRUSTED;
  if (iValue >=  13000)   iRank = RFS_FACTION_HONORED;
  if (iValue >=  21000)   iRank = RFS_FACTION_LOVED;
  
  return iRank;
}


int RFS_GetFactionRank(object oPC, string sFactionName, int iFactionID=0, object oNPC=OBJECT_INVALID) {
	int iCID;
	int iValue;
	int i;
	
	
    // ABORT IF THE FACTION SYSTEM IS NOT ACTIVE
    if (iRFSactiveSystem == FALSE) 
  	  return 0;
	
	// NON-PLAYERS DON'T GET A PLAYERID
	if (!GetIsPC(oPC) || GetIsDM(oPC)) 
		return 0;

	// CHECK IF THERE WAS AN NPC PASSED TO THIS FUNCTION
	// AND IF THE INFORMATION WAS ALREADY PRE-LOADED
	if (oNPC != OBJECT_INVALID) {
		sFactionName = GetLocalString(oNPC, "rfs_faction_name");
		iFactionID   = GetLocalInt(oNPC, "RFS_FactionID");
	}
	sFactionName = GetStringLowerCase(sFactionName);
	if (sFactionName == "" && iFactionID == 0)
		return 0;

	// GET THE FACTIONID BASED ON THE FACTION NAME
	if (iFactionID == 0) {
		iFactionID = DBReadInt("Table_Faction", "FactionID", "FactionName='" + sFactionName + "'");
		if (oNPC != OBJECT_INVALID)
			SetLocalInt(oNPC, "RFS_FactionID", iFactionID);
	}
	
	// GET THE CHARACTER'S ID
	iCID = GetCharacterID(oPC);
	
	if (GetLocalInt(oPC, "RFS_FactionRank_" + IntToString(iFactionID)) > 0) {
    	i = GetLocalInt(oPC, "RFS_FactionRank_" + IntToString(iFactionID)) - 6;
	} else {
		if (DBRecordExists("Table_Faction_Player", "CharacterID=" + IntToString(iCID) + " AND FactionID=" + IntToString(iFactionID) ) == TRUE) {
			i = DBReadInt("Table_Faction_Player", "FactionValue", "CharacterID=" + IntToString(iCID) + " AND FactionID=" + IntToString(iFactionID) );
			SetLocalInt(oPC, "RFS_FactionValue_" + IntToString(iFactionID), i);
			i = DBReadInt("Table_Faction_Player", "FactionRank", "CharacterID=" + IntToString(iCID) + " AND FactionID=" + IntToString(iFactionID) );
			SetLocalInt(oPC, "RFS_FactionRank_" + IntToString(iFactionID), i + 6);
		} else {
			iValue = DBReadInt("Table_Faction_Rule", "AffectValue", "FactionID="+IntToString(iFactionID)+" AND Action='start'");
			i = DBAddRecord("Table_Faction_Player", "CharacterID,FactionID,FactionValue,FactionRank", 
			                IntToString(iCID)   + "," + IntToString(iFactionID) + "," +
			                IntToString(iValue) + "," + IntToString(RFS_ValueToRank(iValue)), 
							"PlayerFactionID");
			SetLocalInt(oPC, "RFS_FactionValue_" + IntToString(iFactionID), iValue);
			SetLocalInt(oPC, "RFS_FactionRank_"  + IntToString(iFactionID), RFS_ValueToRank(iValue)+6);
		}
	}
  
  return i;	
	
}

void RFS_InitNPC(object oNPC) {
	int    iFactionID      = 0;
	string sFactionName    = GetStringLowerCase(GetLocalString(oNPC, "rfs_faction_name"));
	string sFactionCommand = "";
	string sSQL;

    // ABORT IF THE FACTION SYSTEM IS NOT ACTIVE
    if (iRFSactiveSystem == FALSE) 
    	return;
	
	// ABORT IF THE OBJECT IS NOT AN NPC
	if (GetIsPC(oNPC))
		return;
		
	// ABORT IF THE NPC IS PART OF NO RFS FACTION
	SetLocalInt(oNPC, "RFS_Init", 1);
	if (sFactionName == "")
		return;

	// CHECK IF THE FACTION EXISTS IN THE DATABASE
	if (DBRecordExists("Table_Faction", "FactionName='" + sFactionName + "'" ) == FALSE)
		return;
	
	// GET THE NPC'S FACTION NUMBER
	iFactionID = DBReadInt("Table_Faction", "FactionID", "FactionName='" + sFactionName + "'");
	SetLocalInt(oNPC, "RFS_FactionID", iFactionID);
	
	// LOAD ALL THE FACTION ACTIONS ONTO THE NPC
	sFactionCommand = DBReadString("Table_Faction_Rule", "Action,AffectFactionID,AffectValue", "FactionID=" + IntToString(iFactionID)); 
	SetLocalString(oNPC, "RFS_Command", sFactionCommand);
	
}


void RFS_MakeHostile(object oPC, object oNPC) {
    int    bSeen;
    int    bHeard;

    // ABORT IF THE FACTION SYSTEM IS NOT ACTIVE
    if (iRFSactiveSystem == FALSE) 
    	return;
	
	// GATHER NECESSARY NPC VARIABLE CHECKS
	if (!GetIsPC(oNPC)) {
    	bSeen    = GetLastPerceptionSeen();
    	bHeard   = GetLastPerceptionHeard();
	} else {
		bSeen  = TRUE;
		bHeard = TRUE;
	}
	
	// CHANGE REPUTATION TO HATE
	if (GetIsPC(oPC))
		ChangeToStandardFaction(oNPC, STANDARD_FACTION_RFS_HOSTILE);

	AssignCommand(oPC,  SetIsTemporaryEnemy(oNPC, oPC));
	AssignCommand(oNPC, SetIsTemporaryEnemy(oPC, oNPC));
	AssignCommand(oPC,  SetIsTemporaryEnemy(oPC, oNPC));
	AssignCommand(oNPC, SetIsTemporaryEnemy(oNPC, oPC));
	
	// IF BOTH ARE PLAYERS, SET THEM TO HOSTILE TO EACHOTHER
	if (!GetIsPC(oNPC) && (bSeen || bHeard)) {
		AssignCommand(oNPC, DelayCommand(0.1, ActionAttack(oPC)));
	}
	
	// DEBUG - ANNOUNCE REPUTATION
	if (iNWNdebug){
	  object oTemp = GetFirstPC();
	  while (oTemp != OBJECT_INVALID) {
		SendMessageToPC(oTemp, "----------");
		SendMessageToPC(oTemp, GetName(oNPC)+" SEES "+GetName(oPC));
		SendMessageToPC(oTemp, GetName(oPC) +" Rep with "+GetName(oNPC)+": "+IntToString(GetReputation(oNPC, oPC)));
		SendMessageToPC(oTemp, GetName(oNPC)+" Rep with "+GetName(oPC) +": "+IntToString(GetReputation(oPC, oNPC)));
		oTemp = GetNextPC();
	  }
	}
}


void RFS_SetFactionAttitude(object oPC, object oNPC) {
	int iPCRank = RFS_GetFactionRank(oPC, "", 0, oNPC);
	int iCID    = GetCharacterID(oPC);
	
	
	// ABORT IF THE ACTIVE FACTION SYSTEM IS SET TO FALSE
	if (iRFSactiveSystem == FALSE)
		return;
	
	// ABORT IF THE oPC OBJECT IS NOT A PLAYER
	if (!GetIsPC(oPC)) {
		int iFactionID       = GetLocalInt(oNPC, "RFS_FactionID");
		int iTargetFactionID = GetLocalInt(oNPC, "RFS_FactionID");
		if (iFactionID > 0 && iTargetFactionID > 0) 
		  if (GetLocalInt(GetModule(), "RFS_" + IntToString(iFactionID) + "_HATES_" + IntToString(iTargetFactionID)) == 1) {
			RFS_MakeHostile(oPC, oNPC);
			if (!GetIsInCombat(oNPC))
				AssignCommand(oNPC, ActionAttack(oPC));
			if (!GetIsInCombat(oPC))
				AssignCommand(oPC, ActionAttack(oNPC));
				
		  }
		return;
	}
		
	// CHECK IF THE NPC'S ATTITUDE IS ALREADY SET
	if (GetLocalInt(oNPC, "RFS_AttitudeSet_" + IntToString(iCID)) == 1)
		return;
			
	// ADJUST THE NPC'S ATTITUDE TOWARDS THE PC
	if (iPCRank > 0) {
		// SetPCLike(oPC, oNPC);
		// SetPCLike(oNPC, oPC);
		AssignCommand(oPC,  DelayCommand(0.1, SetIsTemporaryFriend(oNPC)));
		AssignCommand(oNPC, DelayCommand(0.1, SetIsTemporaryFriend(oPC)));
	} else {
	  switch (iPCRank) {
	    case RFS_FACTION_NEUTRAL:
			AssignCommand(oPC,  DelayCommand(0.1, SetIsTemporaryNeutral(oNPC)));
			AssignCommand(oNPC, DelayCommand(0.1, SetIsTemporaryNeutral(oPC)));
			break;
			
		case RFS_FACTION_KOS: 
			RFS_MakeHostile(oPC, oNPC);
			break;
			
		case RFS_FACTION_HOSTILE: 
			RFS_MakeHostile(oPC, oNPC);
			break;
			
		case RFS_FACTION_HATED:
			if (Random(100) < 90) {
				RFS_MakeHostile(oPC, oNPC);
			} else {
				// SetPCLike(oPC, oNPC);
				// SetPCLike(oNPC, oPC);
				AssignCommand(oPC,  DelayCommand(0.1, SetIsTemporaryNeutral(oNPC)));
				AssignCommand(oNPC, DelayCommand(0.1, SetIsTemporaryNeutral(oPC)));
			}
			break;
			
		case RFS_FACTION_DISLIKED:
			if (Random(100) < 40) {
				RFS_MakeHostile(oPC, oNPC);
			} else {
				// SetPCLike(oPC, oNPC);
				// SetPCLike(oNPC, oPC);
				AssignCommand(oPC,  DelayCommand(0.1, SetIsTemporaryNeutral(oNPC)));
				AssignCommand(oNPC, DelayCommand(0.1, SetIsTemporaryNeutral(oPC)));
			}
			break;
			
		case RFS_FACTION_UNFRIENDLY:
			if (Random(100) < 10) {
				RFS_MakeHostile(oPC, oNPC);
			} else {
				// SetPCLike(oPC, oNPC);
				// SetPCLike(oNPC, oPC);
				AssignCommand(oPC,  DelayCommand(0.1, SetIsTemporaryNeutral(oNPC)));
				AssignCommand(oNPC, DelayCommand(0.1, SetIsTemporaryNeutral(oPC)));
			}
			break;
			
	  }
	}	
	
	SetLocalInt(oNPC, "RFS_AttitudeSet_" + IntToString(iCID), 1);
	
}


void RFS_ProcessNPC(object oPC, object oNPC, string strAction) {
	int    iFactionID      = GetLocalInt(oNPC,    "RFS_FactionID");
	string sFactionName    = GetLocalString(oNPC, "rfs_faction_name");
	string sFactionCommand = GetLocalString(oNPC, "RFS_Command");
	string sProcess		   = "";
	string sAction;
	int    iCID;
	int    iAffectID;
	int    iAffectValue;
	int    i;
	
    // ABORT IF THE FACTION SYSTEM IS NOT ACTIVE
    if (iRFSactiveSystem == FALSE) 
    	return;
	
	// ABORT IF THE TWO OBJECTS ARE NOT WHAT THE ARE SUPPOSED TO BE
	if (GetIsPC(oNPC) || !GetIsPC(oPC))
		return;
		
	// CHECK IF NPC IS INITIALIZED
	if (GetLocalInt(oNPC, "RFS_Init") != 1)
		RFS_InitNPC(oNPC);

	// ABORT IF THE NPC IS PART OF NO RFS FACTION
	if (sFactionName == "" || iFactionID < 1)
		return;
		
	// ABORT IF THERE IS NO ACTION
	if (strAction == "")
		return;

	// BEGIN PROCESSING
	iCID = GetCharacterID(oPC);
	while (sFactionCommand != "") {
		if (GetStringLeft(sFactionCommand, 1) == "|")
		  sFactionCommand = GetStringRight(sFactionCommand, GetStringLength(sFactionCommand)-1);
		i = FindSubString(sFactionCommand, "|") + 1;
		if (i > 0) {
			sProcess        = GetStringLeft(sFactionCommand, i);
			sFactionCommand = GetStringRight(sFactionCommand, GetStringLength(sFactionCommand)-i);
		} else {
			sProcess        = sFactionCommand;
			sFactionCommand = "";
		}
		
		// BREAK UP THE LINE INTO: ACTION, AFFECTID, AFFECTVALUE
		i = FindSubString(sProcess, "/") + 1;
		if (i > 0) {
			sAction  = GetStringLeft(sProcess, i-1);
			sProcess = GetStringRight(sProcess, GetStringLength(sProcess)-i);
		} else {
			sAction      = sProcess;
			iAffectID    = 0;
			iAffectValue = 0;
			sProcess     = "";
		}
		
		
		i = FindSubString(sProcess, "/") + 1;
		if (i > 0) {
			iAffectID = StringToInt(GetStringLeft(sProcess, i-1));
			sProcess  = GetStringRight(sProcess, GetStringLength(sProcess)-i);
		} else {
			iAffectID    = StringToInt(sProcess);
			iAffectValue = 0;
			sProcess     = "";
		}

				
		i = FindSubString(sProcess, "/") + 1;
		if (i > 0) {
			iAffectValue = StringToInt(GetStringLeft(sProcess, i-1));
			sProcess     = "";
		} else {
			iAffectValue = StringToInt(sProcess);
			sProcess     = "";
		}
		
		if (strAction == sAction && iAffectID > 0 && iAffectValue != 0) {
			// GET THE PLAYERS STANDING WITH THE AFFECTED FACTION (iAffectID)
			sFactionName = DBReadString("Table_Faction", "FactionName", "FactionID=" + IntToString(iAffectID));
			i = RFS_GetFactionRank(oPC, sFactionName);
			i = GetLocalInt(oPC, "RFS_FactionValue_" + IntToString(iAffectID));
			i = i + iAffectValue;
			if (i > 30000)  i =  30000;
			if (i < -30000) i = -30000;
			SetLocalInt(oPC, "RFS_FactionValue_" + IntToString(iAffectID), i);
			SetLocalInt(oPC, "RFS_FactionRank_"  + IntToString(iAffectID), RFS_ValueToRank(i)+6);
			DBUpdateInt("Table_Faction_Player", "FactionValue", i,                  "CharacterID=" + IntToString(iCID) + " AND FactionID=" + IntToString(iAffectID));
			DBUpdateInt("Table_Faction_Player", "FactionRank",  RFS_ValueToRank(i), "CharacterID=" + IntToString(iCID) + " AND FactionID=" + IntToString(iAffectID));
			if (iAffectValue >= 0)
				FloatingTextStringOnCreature("Your standing with " + sFactionName + " has improved.", oPC, FALSE);
			else
				FloatingTextStringOnCreature("Your standing with " + sFactionName + " has worsened.",  oPC, FALSE);

		}
	}
		
}

void RFS_UpdateFaction(object oPC, int iFactionID, int iFactionChange) {
  string sFactionName;
  int    iFactionValue;
  int    iCID;

  // ABORT IF THE FACTION SYSTEM IS NOT ACTIVE
  if (iRFSactiveSystem == FALSE) 
  	return;
	
  // ABORT IF oPC IS NOT A PLAYER
  if (!GetIsPC(oPC))
	return;
		
  // ABORT IF THE NPC IS PART OF NO RFS FACTION
  if (iFactionID == 0 || iFactionChange == 0)
	return;
		
  // BEGIN PROCESSING
  iCID = GetCharacterID(oPC);

  // GET THE FACTION NAME
  sFactionName = DBReadString("Table_Faction", "FactionName", "FactionID=" + IntToString(iFactionID));

  // ADJUST THE PLAYERS STANDING WITH THE FACTION	
  iFactionValue = RFS_GetFactionRank(oPC, "", iFactionID);
  iFactionValue = iFactionValue + iFactionChange;
  if (iFactionValue > 30000)  iFactionValue =  30000;
  if (iFactionValue < -30000) iFactionValue = -30000;
  
  // SAVE THE CHANGES
  SetLocalInt(oPC, "RFS_FactionValue_" + IntToString(iFactionID), iFactionValue);
  SetLocalInt(oPC, "RFS_FactionRank_"  + IntToString(iFactionID), RFS_ValueToRank(iFactionValue)+6);
  DBUpdateInt("Table_Faction_Player", "FactionValue", iFactionValue,                  "CharacterID=" + IntToString(iCID) + " AND FactionID=" + IntToString(iFactionID));
  DBUpdateInt("Table_Faction_Player", "FactionRank",  RFS_ValueToRank(iFactionValue), "CharacterID=" + IntToString(iCID) + " AND FactionID=" + IntToString(iFactionID));
  
  // NOTIFY THE PLAYER OF THE CHANGES
  if (iFactionChange >= 0)
	FloatingTextStringOnCreature("Your standing with " + sFactionName + " has improved.", oPC, FALSE);
  else
	FloatingTextStringOnCreature("Your standing with " + sFactionName + " has worsened.",  oPC, FALSE);

}


// DETERMINE STORE MARKUP WHEN SELLING TO PC
int RFS_GetStoreMarkup(object oPC, object oNPC) {
	string sFactionName = GetStringLowerCase(GetLocalString(oNPC, "rfs_faction_name"));
	int    iPCRank;
	
    // ABORT IF THE FACTION SYSTEM IS NOT ACTIVE
    if (iRFSactiveSystem == FALSE) 
    	return 0;
	
	// ABORT IF NOT A VALID NPC
	if (GetIsPC(oNPC))
		return 0;
		
	// ABORT IF NPC IS NOT PART OF A FACTION
	if (sFactionName == "")
		return 0;
		
	// CHECK IF NPC IS INITIALIZED
	if (GetLocalInt(oNPC, "RFS_Init") != 1)
		RFS_InitNPC(oNPC);

	// SET THE VALUE BASED ON THE PLAYER'S FACTION
	iPCRank =  RFS_GetFactionRank(oPC, sFactionName, 0, oNPC);
	iPCRank = (iPCRank * iRFSmarkUpRate) * (-1);
	
	return iPCRank;
	
}

// DETERMINE STORE MARKDOWN WHEN BUYING FROM PC
int RFS_GetStoreMarkdown(object oPC, object oNPC) {
	string sFactionName = GetStringLowerCase(GetLocalString(oNPC, "rfs_faction_name"));
	int    iPCRank;
	
    // ABORT IF THE FACTION SYSTEM IS NOT ACTIVE
    if (iRFSactiveSystem == FALSE) 
    	return 0;
	
	// ABORT IF NOT A VALID NPC
	if (GetIsPC(oNPC))
		return 0;
	
	// ABORT IF NPC IS NOT PART OF A FACTION
	if (sFactionName == "")
		return 0;
		
	// CHECK IF NPC IS INITIALIZED
	if (GetLocalInt(oNPC, "RFS_Init") != 1)
		RFS_InitNPC(oNPC);
		
	// SET THE VALUE BASED ON THE PLAYER'S FACTION
	iPCRank = RFS_GetFactionRank(oPC, sFactionName, 0, oNPC);
	iPCRank = (iPCRank * iRFSmarkDownRate);
	
	return iPCRank;
	
}