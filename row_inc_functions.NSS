// =============================================================
//
//    File: row_inc_functions
//    Desc: Rowell's Functions
//  Author: Michael Marzilli
//    Site: http://www.engliton.org
//
// Created: Oct 04, 2006
// Updated: Feb 06, 2007
// Version: 1.0.4
//
// =============================================================

#include "row_inc_database"


// =============================================================
// GLOBAL FUNCTIONS
// =============================================================

// GetCDKeyID(object oPC)
//   Returns the Database Record ID of the CDKey for the Player
int    GetCDKeyID(object oPC);

// GetPlayerID(object oPC)
//   Returns the Database Record ID of the Player
int    GetPlayerID(object oPC);

// GetCharacterID(object oPC)
//   Returns the Database Record ID of the Character
int    GetCharacterID(object oPC);

// GetItemID(object oItem)
//   Returns the Database Record ID of the Item
int    GetItemID(object oItem, object oPC=OBJECT_INVALID);

// GetItemOwner(object oItem)
//   Passes the Database Character ID of the Owner of the Item
int    GetItemOwner(object oItem);

// int GetIsPlayerDM(object oPC)
//   Returns from the Database whether or not this Player Account belongs to a Server DM
int    GetIsPlayerDM(object oPC);

// FormatID(int iID)
//   Returns a (gIDsize) character string based on the integer passed, with leading zeros
//   Example:  159 is converted to "00000159"
string FormatID(int iID);



// GetRace(object oPC)
//   Returns the String Value of the Race of the Object
string GetRace(object oPC);

// GetRaceSub(object oPC)
//   Returns the String Value of the Sub Race of the Object
string GetRaceSub(object oPC);

// Get PCGender(object oPC)
//   Returns the String Value of the Gender of the Object
string GetPCGender(object oPC);

// GetAlignment(object oPC)
//   Returns the String Value of the Alignment of the Object
string GetAlignment(object oPC);

// GetClass(int iPos, object oPC)
//   Returns the String Value of the Class of the Object, given the position (1-3)
string GetClass(int iPos, object oPC);

// GetLevel(object oPC)
//   Returns the true level of the object, combining the levels of up to all 3 classes
int    GetLevel(object oPC);

// GetGameDate()
//   Returns the Current Game Date in the string form of "YYYYMMDD"
string GetGameDate();

// GetGameDate()
//   Returns the Current Game Date and Time in the string form of "YYYYMMDDHHMM"
string GetGameTime();

// StringZero(int iNum, int iSize)
//   Given a number (iNum), converts it to a String and adds leading zeros
//   to make the string iSize long
//   Example:  StringZero(10,5) would return  "00010"
string StringZero(int iNum, int iSize);

// GetItemTag(object oItem)
//   Given an Item Object, returns the Tag of the Item
//   If the Database Item Tracking Setting is turned on,
//   the function will return the True Tag (not the modified DB Tag).
string GetItemTag(object oItem);

// GetTrackedItemPossessedBy(object oPC, string sTag);
//   This function returns the object in the Character's (oPC) inventory,
//   given a particular Tag (sTag).  This function should be used when
//   Item Tracking is Enabled (gEnableItemTracking = TRUE) in the place
//   of the GetItemPossessedBy() function.
//   Otherwise, this Function acts exactly like the built-in GetItemPossessedBy(object oPC, string sTag)
object GetTrackedItemPossessedBy(object oPC, string sTag);

// Row_ModuleStart()
//   Use in the Module's OnModuleStart Event
void   Row_ModuleStart();

// Row_ModuleEnter(object oPC=OBJECT_INVALID)
//   Use in the Modules's OnClientEnter Event
void   Row_ModuleEnter(object oPC=OBJECT_INVALID);

// Row_ModulePlayerLoaded(object oPC=OBJECT_INVALID)
//   Use in the Module's OnPlayerLoaded Event
void   Row_ModulePlayerLoaded(object oPC=OBJECT_INVALID);

// Row_ModuleExit(object oPC=OBJECT_INVALID)
//   Use in the Module's OnClientExit Event
void   Row_ModuleExit(object oPC=OBJECT_INVALID);



// Row_AreaEnter(object oPC=OBJECT_INVALID)
//   Use in all Areas' OnEnter Event
void   Row_AreaEnter(object oPC=OBJECT_INVALID);

// Row_AreaExit(object oPC=OBJECT_INVALID)
//   Use in all Areas' OnExit Event
void   Row_AreaExit(object oPC=OBJECT_INVALID);



// Row_PlayerRest(object oPC=OBJECT_INVALID)
//   Use in the Module's OnPlayerRest Event
void   Row_PlayerRest(object oPC=OBJECT_INVALID);

// Row_PlayerDead(object oPC=OBJECT_INVALID, object oNPC=OBJECT_INVALID)
//   Use in the Module's OnPlayerDeath Script
void   Row_PlayerDead(object oPC=OBJECT_INVALID, object oNPC=OBJECT_INVALID);

// Row_PlayerRaise(int bPortToBind, object oPC=OBJECT_INVALID)
//   Use in the Module's OnPlayerRespawn Script with bPortToBind set to TRUE
//   Use in Raise Dead and Ressurrect Spells Scripts, with bPortToBind set to FALSE
void   Row_PlayerRaise(int bPortToBind, object oPC=OBJECT_INVALID);


// Row_AddToLootTable(object oItem)
//   Use to add an item to the Database, to catalog the items drop, and how many times
//   each item has dropped in the game.
void   Row_AddToLootTable(object oItem);

// Row_ItemCreate(string strResRef, sting strTag="", object oOwner=OBJECT_INVALID)
//   Used internally and should not be used.
object Row_ItemCreate(string strResRef, string strTag="", object oOwner=OBJECT_INVALID);

// Row_ItemGain(object oItem=OBJECT_INVALID)
//   Use in the Module's OnAcquire Script
void   Row_ItemGain(object oItem=OBJECT_INVALID);

// Row_ItemLose(object oItem=OBJECT_INVALID)
//   Use in the Module's OnUnacquire Script
void   Row_ItemLose(object oItem=OBJECT_INVALID);


// GetNPCID(object oNPC);
//   Returns the NPC ID for the given NPC (oNPC)
int    GetNPCID(object oNPC);

// IncreaseNPCkills(object oNPC);
//	 Increases the Total Number of Kills that an NPC type has inflicted upon Player Characters
void   IncreaseNPCkills(object oNPC);

// IncreaseNPCdeaths(object oNPC);
//	 Increases the Total Number of Deaths that the NPC type has suffered.
void   IncreaseNPCdeaths(object oNPC);


// Row_ResetCharacter(object oPC);
//   Used to set the character's (oPC) Feats and Spells to all used.
//   This stops people from logging off and back on to get all their spells back.
void   Row_ResetCharacter(object oPC);

// Row_DiscoverLocation(object oPC, object oPlace=OBJECT_SELF);
//   Used to reward the character (oPC) when they step into a trigger (oPlace)
//   and discover a new location.
void   Row_DiscoverLocation(object oPC, object oPlace=OBJECT_SELF);

// RemoveEffects(object oPC)
//   Use to remove all negative affects from a character.
//   This function is a direct copy from the NWN script in nw_i0_plot
void   RemoveBadEffects(object oPC);


// EVENT ORDER
// -----------------------------------------------------------------------
// 1. AquireItem Events fire for all items the logging in PC carries.
// 2. Equip Item Events fire for all items the PC has equipped.
// 3. Client Enter Event Fires
// 4. UnEquip event fires for anything forcibly unequipped during 
//    the Client Enter Script (or due to ELC/ILR restrictions too I think)
// 5. UnAcquire Item events fire for anything removed during client Enter.
// 6. PC Loaded Event fires.
// 7. Area On Enter event fires
// 8. Area On Client Enter event fires.


// =============================================================
// DATA FUNCTION
// =============================================================

// GET THE PLAYER'S CDKEY ID FROM LOCAL VARIABLE/DATABASE
int GetCDKeyID(object oPC) {
  string sSQL;
  int    i = 0;
      
  // NON-PLAYERS DON'T GET A CDKEYID
  if (!GetIsPC(oPC) && !GetIsDM(oPC)) 
	return 0;
  
  if (GetLocalInt(oPC, "DB_CDKeyID") > 0) {
    i = GetLocalInt(oPC, "DB_CDKeyID");
  } else {
    if (DBRecordExists("Table_CDKey", "CDKey='" + GetPCPublicCDKey(oPC) + "'") == TRUE) {
	  i = DBReadInt("Table_CDKey", "CDKeyID", "CDKey='" + GetPCPublicCDKey(oPC) + "'");
	} else {
	  i = DBAddRecord("Table_CDKey", "CDKey", "'" + GetPCPublicCDKey(oPC) + "'", "CDKeyID", "CDKey='" + GetPCPublicCDKey(oPC) + "'");
	  // INIT CERTAIN FIELDS IN THE DATABASE
	  DBUpdateInt("Table_CDKey", "Banned", 0, "CDKeyID=" + IntToString(i), oPC);
	}
	SetLocalInt(oPC, "DB_CDKeyID", i);
  }
  
  return i;
}


// GET THE PLAYER'S PLAYER ID FROM LOCAL VARIABLE/DATABASE
int GetPlayerID(object oPC) {
  string sSQL;
  int    iCDID;
  int    i = 0;
      
  // NON-PLAYERS DON'T GET A PLAYERID
  if (!GetIsPC(oPC) && !GetIsDM(oPC)) 
	return 0;
    
  if (GetLocalInt(oPC, "DB_PlayerID") > 0) {
    i = GetLocalInt(oPC, "DB_PlayerID");
  } else {
    if (DBRecordExists("Table_Player", "PlayerName='" + SQLEncode(GetPCPlayerName(oPC)) + "'") == TRUE) {
	  i = DBReadInt("Table_Player", "isDM", "PlayerName='" + SQLEncode(GetPCPlayerName(oPC)) + "'");
	  SetLocalInt(oPC, "DB_isDM", i);	  
	  i = DBReadInt("Table_Player", "PlayerID", "PlayerName='" + SQLEncode(GetPCPlayerName(oPC)) + "'");
	} else {
	  i = DBAddRecord("Table_Player", "PlayerName", "'" + SQLEncode(GetPCPlayerName(oPC)) + "'", "PlayerID", "PlayerName='" + SQLEncode(GetPCPlayerName(oPC)) + "'");
	  iCDID = GetCDKeyID(oPC);
	  // INIT CERTAIN FIELDS IN THE DATABASE
	  sSQL = "SET Banned=0,TimeOnline=0,isDM=0,CDKeyID=" + IntToString(iCDID) + ",FirstLogin=" + gDateTimeNow;
      DBSQLCmd("UPDATE " + gTable_Prefix + "Table_Player " + sSQL + " WHERE PlayerID=" + IntToString(i)); 
	  SetLocalInt(oPC, "DB_isDM", 0);	  

	}
	SetLocalInt(oPC, "DB_PlayerID", i);
  }
  
  return i;
}


// GET THE PLAYER'S CHARACTER ID FROM LOCAL VARIABLE/DATABASE
int GetCharacterID(object oPC) {
  int    iCID = 0;
  int    i;
  object oDefaultBind;
  string sCID;
  string strFields;
  string strValues;
  string strValue2;
  string sSQL;
      
  // NON-PLAYERS DON'T GET A CHARACTERID
  if (!GetIsPC(oPC) && !GetIsDM(oPC)) 
	return 0;
    
  if (GetLocalInt(oPC, "DB_CharacterID") > 0) {
    iCID = GetLocalInt(oPC, "DB_CharacterID");
  } else {
    if (DBRecordExists("Table_Character", "CharName='" + SQLEncode(GetName(oPC)) + "'") == TRUE) {

	  // CHARACTER ALREADY EXISTS IN THE DATABASE - GRAB THEIR CHARACTER ID
	  iCID = DBReadInt("Table_Character", "CharacterID", "CharName='" + SQLEncode(GetName(oPC)) + "' AND PlayerID=" + IntToString(GetPlayerID(oPC)));

	} else {

	  // CHARACTER DOES NOT EXIST IN THE DATABASE - ADD THEM IN AND GRANT THEM STARTER PRIVS
	  if (GetXP(oPC) < 1 && GetGold(oPC) == 0)
	  	GiveGoldToCreature(oPC, gStartingGold);
	  
	  strFields = "CharName,PlayerID";
	  strValues = "'" + SQLEncode(GetName(oPC)) + "'," + IntToString(GetPlayerID(oPC));
	  iCID = DBAddRecord("Table_Character", strFields, strValues, "CharacterID", "CharName='" + SQLEncode(GetName(oPC)) + "'");

	  // INIT CERTAIN FIELDS IN THE DATABASE
	  sSQL = "SET LoginCount=0,Banned=0,Deleted=0,Deaths=0,FirstLogin=" + gDateTimeNow;
      DBSQLCmd("UPDATE " + gTable_Prefix + "Table_Character " + sSQL + " WHERE CharacterID=" + IntToString(iCID)); 

	  // CREATE THE PLAYERS STARTING LOCATION IN THE DATABASE
	  strFields = "CharacterID,AreaName,Location,LKey";
	  strValues = IntToString(iCID) + ",";
	  strValue2 = "'" + SQLEncode(GetName(GetAreaFromLocation(GetStartingLocation()))) + "'," +
	  			  "'" + SQLLocationToString(GetStartingLocation()) + "','";
	  i = DBAddRecord("Table_Location", strFields, strValues+strValue2+"saved'", "LocationID");
	  i = DBAddRecord("Table_Location", strFields, strValues+strValue2+"current'", "LocationID");

	  // FIND THE DEFAULT RESPAWN LOCATION
	  oDefaultBind = GetObjectByTag("row_default_bind");
	  if (oDefaultBind != OBJECT_INVALID) {
	  	strValue2 = "'" + SQLEncode(GetName(GetArea(oDefaultBind))) + "'," +
	  				"'" + SQLLocationToString(GetLocation(oDefaultBind)) + "','";
	  	i = DBAddRecord("Table_Location", strFields, strValues+strValue2+"bound'", "LocationID");	  	  
	  } else
	  	i = DBAddRecord("Table_Location", strFields, strValues+strValue2+"bound'", "LocationID");	  
	}
	  
    // UPDATE THE PLAYER'S CHARACTER INFORMATION TO THE DATABASE
	sCID = IntToString(iCID);
	
	sSQL = "SET " +
		   "Abil_STR=" + IntToString(GetAbilityScore(oPC, ABILITY_STRENGTH)) + "," +
		   "Abil_CON=" + IntToString(GetAbilityScore(oPC, ABILITY_CONSTITUTION)) + "," +
		   "Abil_DEX=" + IntToString(GetAbilityScore(oPC, ABILITY_DEXTERITY)) + "," +
		   "Abil_INT=" + IntToString(GetAbilityScore(oPC, ABILITY_INTELLIGENCE)) + "," +
		   "Abil_WIS=" + IntToString(GetAbilityScore(oPC, ABILITY_WISDOM)) + "," +
		   "Abil_CHA=" + IntToString(GetAbilityScore(oPC, ABILITY_CHARISMA));
	DBSQLCmd("UPDATE " + gTable_Prefix + "Table_Character " + sSQL + " WHERE CharacterID=" + sCID);
	
	sSQL = "SET " +
		   "XP=" + IntToString(GetXP(oPC)) + "," +
		   "GP=" + IntToString(GetGold(oPC)) + "," +
		   "MaxHP=" + IntToString(GetMaxHitPoints(oPC)) + "," +
		   "CurHP=" + IntToString(GetCurrentHitPoints(oPC)) + "," +
		   "OverallLevel=" + IntToString(GetLevel(oPC)) + "," +
		   "Level1=" + IntToString(GetLevelByPosition(1, oPC)) + "," +
		   "Level2=" + IntToString(GetLevelByPosition(2, oPC)) + "," +
		   "Level3=" + IntToString(GetLevelByPosition(3, oPC)) + "," +
		   "IsDead=" + IntToString(GetIsDead(oPC));
	DBSQLCmd("UPDATE " + gTable_Prefix + "Table_Character " + sSQL + " WHERE CharacterID=" + sCID);
	
 	sSQL = "SET " +
		   "Race='" + GetRace(oPC) + "'," +
		   "SubRace='" + GetRaceSub(oPC) + "'," +
		   "Alignment='" + GetAlignment(oPC) + "'," +
		   "Gender='" + GetPCGender(oPC) + "'," +
		   "Class1='" + GetClass(1, oPC) + "'," +
		   "Class2='" + GetClass(2, oPC) + "'," +
		   "Class3='" + GetClass(3, oPC) + "'";
	DBSQLCmd("UPDATE " + gTable_Prefix + "Table_Character " + sSQL + " WHERE CharacterID=" + sCID);

	
	if (GetName(GetArea(oPC)) != "") {
	  sSQL = "SET " +
		     "AreaName='" + SQLEncode(GetName(GetArea(oPC))) + "'," +
		     "Location='" + SQLLocationToString(GetLocation(oPC)) + "'";
	  DBSQLCmd("UPDATE " + gTable_Prefix + "Table_Location " + sSQL + " WHERE LKey='saved' AND CharacterID=" + sCID);

  	  sSQL = "SET " +
		     "AreaName='" + SQLEncode(GetName(GetArea(oPC))) + "'," +
		     "Location='" + SQLLocationToString(GetLocation(oPC)) + "'";
	  DBSQLCmd("UPDATE " + gTable_Prefix + "Table_Location " + sSQL + " WHERE LKey='current' AND CharacterID=" + sCID);
	}
	
	SetLocalInt(oPC, "DB_CharacterID", iCID);
  }
  
  return iCID;
  
}


// GET THE ITEM'S ID FROM LOCAL VARIABLE/DATABASE
int GetItemID(object oItem, object oPC=OBJECT_INVALID) {
  object oPC;
  object oTemp;
  string strTemp;
  string strTag;
  int	 iOwnerID;
  int    i = 0;
      
  // NON-ITEM OBJECTS DON'T GET AN ITEMID
  if (GetObjectType(oItem) != OBJECT_TYPE_ITEM) 
	return 0;
    
  // CHECK IF ITEM'S OWNER IS A PC. IF THEY ARE, IS THE PC LOGGED IN FULLY?
  // IF THE OBJECT IS AN NPC, DO NOT CATALOG THEIR EQUIPMENT, 
  // THAT GETS DONE ONLY WHEN A PC PICKS THE ITEM UP FOR LOOT.
  if (oPC == OBJECT_INVALID)
	oPC = GetItemPossessor(oItem);
		
  if (GetIsPC(oPC)) {
  	// ABORT IF THE CHARACTER IS STILL LOGGING IN
	if (GetLocalInt(oPC, "CHARACTER_IS_NOW_ONLINE") != 1)
		return 0;
  }	
		
  if (GetLocalInt(oItem, "DB_ItemID") > 0) {
    i = GetLocalInt(oItem, "DB_ItemID");
  } else {
    strTag = GetTag(oItem);
	strTag = GetStringRight(strTag, (gIDsize + 1));
	if (GetStringLeft(strTag, 1) == "_" && StringToInt(GetStringRight(strTag, gIDsize)) > 0) {
	  // CHECK THE ITEM'S TAG FOR THE ITEMID
	  i = StringToInt(GetStringRight(strTag, gIDsize));
      SetLocalInt(oItem, "DB_ItemID", i);
    } else {	  
      // CHECK THE DATABASE FOR THE ITEM ID
      if (DBRecordExists("Table_Item", "ItemTag='" + GetTag(oItem) + "'") == TRUE) {
  	    i = DBReadInt("Table_Item", "ItemID", "ItemTag='" + GetTag(oItem) + "'");
        SetLocalInt(oItem, "DB_ItemID", i);
	  } else {
	    oPC = GetItemPossessor(oItem);
		if (GetIsPC(oPC))
			iOwnerID = GetCharacterID(oPC);
		else
			return 0;
			
		if (GetLocalInt(oPC, "ITEM_CREATING") <= 1) {
		  SetLocalInt(oPC, "ITEM_CREATING", 2);
	      strTemp = GetTag(oItem) + IntToString(Random(99999)+100000) + "DEL";
	      i = DBAddRecord("Table_Item", "ItemTag", "'" + strTemp + "'", "ItemID", "ItemTag='" + strTemp + "'");
	      strTag = GetTag(oItem) + "_" + FormatID(i);
		
	      DBUpdateString("Table_Item", "ItemTag", strTag, "ItemID=" + IntToString(i));
	      DBUpdateString("Table_Item", "ItemName", SQLEncode(GetName(oItem)), "ItemID=" + IntToString(i));
	      DBUpdateString("Table_Item", "ItemResRef", GetResRef(oItem), "ItemID=" + IntToString(i));
	      DBUpdateString("Table_Item", "StoredIn", "", "ItemID=" + IntToString(i));
	      DBUpdateString("Table_Item", "Rituals", "", "ItemID=" + IntToString(i));
	      DBUpdateInt("Table_Item", "OwnerID", iOwnerID, "ItemID=" + IntToString(i));
	      DBUpdateInt("Table_Item", "ItemCount", GetNumStackedItems(oItem), "ItemID=" + IntToString(i));
	      DBUpdateInt("Table_Item", "Identified", GetIdentified(oItem), "ItemID=" + IntToString(i));
	      DBUpdateInt("Table_Item", "Charges", GetItemCharges(oItem), "ItemID=" + IntToString(i));
	      DBUpdateInt("Table_Item", "CreatorID", 0, "ItemID=" + IntToString(i));
	      DBUpdateInt("Table_Item", "doDelete", 0, "ItemID=" + IntToString(i));
						
	      oTemp = CopyObject(oItem, GetLocation(oPC), oPC, strTag);
	      SetPlotFlag(oItem, FALSE);
	      DestroyObject(oItem);
          SetLocalInt(oTemp, "DB_ItemID", i);
		  SetLocalInt(oTemp, "DB_ItemOwner", iOwnerID);
	    }
	  }
	}
  }
  
  return i;
}


// GET THE ITEM'S OWNER FROM LOCAL VARIABLE/DATABASE
int GetItemOwner(object oItem) {
  int    i = 0;
    
  // NON-ITEM OBJECTS DON'T GET AN ITEMID
  if (GetObjectType(oItem) != OBJECT_TYPE_ITEM) 
	return 0;
  i = GetItemID(oItem);
  
  if (GetLocalInt(oItem, "DB_ItemOwner") > 0) {
    i = GetLocalInt(oItem, "DB_ItemOwner");
  } else {
    i = DBReadInt("Table_Item", "OwnerID", "ItemTag='" + GetTag(oItem) + "'");
    SetLocalInt(oItem, "DB_ItemOwner", i);
  }
  
  return i;
}


// GET THE PLAYER'S DM STATUS FROM LOCAL VARIABLE/DATABASE
int GetIsPlayerDM(object oPC) {
  int iPID;
  int iIsDM;
  
  iPID  = GetPlayerID(oPC);
  iIsDM = GetLocalInt(oPC, "DB_isDM");	  

  return iIsDM;
  
}


// FORMAT A NUMBER AS A STRING, WITH LEADING ZEROS
string FormatID(int iID) {
  string strID;
 
  strID = IntToString(iID);
  strID = GetStringLeft("000000000000000000000", gIDsize - GetStringLength(strID)) + strID;
 
  return strID;
  
}

string GetItemTag(object oItem) {
  string sTag;
  object oTemp;
  
  sTag = GetTag(oItem);
  if (gEnableItemTracking) {
  	oTemp = CreateObject(OBJECT_TYPE_ITEM, sTag, GetStartingLocation());
	if (oTemp != OBJECT_INVALID) {
	  SetPlotFlag(oTemp, FALSE);
	  DestroyObject(oTemp, 0.0);
	} else
      sTag = GetStringLeft(sTag, GetStringLength(sTag) - (gIDsize + 1));
  	  oTemp = CreateObject(OBJECT_TYPE_ITEM, sTag, GetStartingLocation());
	  if (oTemp != OBJECT_INVALID) {
	    SetPlotFlag(oTemp, FALSE);
	    DestroyObject(oTemp, 0.0);
	  } else
	  	sTag = GetResRef(oItem);
  }
  
  return sTag;
  
}

object GetTrackedItemPossessedBy(object oPC, string sTag){
  object oItem;
  string sTemp;
  int    iMaxItems = 100;	// THIS WILL (HOPEFULLY) STOP ANY "TOO MANY INSTRUCTIONS" ERRORS FROM POPPING UP
  int    iLength;			// IF YOU DO GET "TOO MANY INSTRUCTIONS" ERRORS HERE, DECREASE THE VALUE OF iMaxItems
  int    i = 0;
  
//  if (gEnableItemTracking == FALSE)
//	  return GetItemPossessedBy(oPC, sTag);
	
//  else {
    oItem   = GetFirstItemInInventory(oPC);
	sTag    = GetStringLowerCase(sTag);
	iLength = GetStringLength(sTag);
	while (oItem != OBJECT_INVALID && i < iMaxItems) {
	  i++;
	  sTemp = GetStringLowerCase(GetTag(oItem));
	  if (GetStringLeft(sTemp, iLength) == sTag && !GetLocalInt(oItem, "DESTROY_ME"))
	  	return oItem;
      oItem = GetNextItemInInventory(oPC);
	}
//  }
  
  return OBJECT_INVALID;
  
}


// =============================================================
// PLAYER FUNCTIONS
// =============================================================

string GetRace(object oPC) {
  string st;
  int    i = GetRacialType(oPC);

  switch (i) {
    case RACIAL_TYPE_DWARF:
      st = "Dwarf";
      break;
    case RACIAL_TYPE_ELF:
      st = "Elf";
      break;
    case RACIAL_TYPE_GNOME:
      st = "Gnome";
      break;
    case RACIAL_TYPE_HALFELF:
      st = "Half Elf";
      break;
    case RACIAL_TYPE_HALFLING:
      st = "Halfling";
      break;
    case RACIAL_TYPE_HALFORC:
      st = "Half Orc";
      break;
    case RACIAL_TYPE_HUMAN:
      st = "Human";
      break;
  }
 
  return st;
}

string GetRaceSub(object oPC) {
  string st;

  if (GetSubRace(oPC) != 0) {
    switch (GetSubRace(oPC)) {
    // EVALUATE SUB-RACES HERE
    case RACIAL_SUBTYPE_AASIMAR:
      st = "Aasimar";
      break;
    case RACIAL_SUBTYPE_DROW:
      st = "Drow";
      break;
    case RACIAL_SUBTYPE_GOLD_DWARF:
      st = "Gold Dwarf";
      break;
    case RACIAL_SUBTYPE_GRAY_DWARF:
      st = "Gray Dwarf";
      break;
    case RACIAL_SUBTYPE_LIGHTFOOT_HALF:
      st = "Lightfoot Halfling";
      break;
    case RACIAL_SUBTYPE_MOON_ELF:
      st = "Moon Elf";
      break;
    case RACIAL_SUBTYPE_ROCK_GNOME:
      st = "Rock Gnome";
      break;
    case RACIAL_SUBTYPE_SHIELD_DWARF:
      st = "Shield Dwarf";
      break;
    case RACIAL_SUBTYPE_STRONGHEART_HALF:
      st = "Strongheart Halfling";
      break;
    case RACIAL_SUBTYPE_SUN_ELF:
      st = "Sun Elf";
      break;
    case RACIAL_SUBTYPE_SVIRFNEBLIN:
      st = "Svirfneblin";
      break;
    case RACIAL_SUBTYPE_TIEFLING:
      st = "Tiefling";
      break;
    case RACIAL_SUBTYPE_WILD_ELF:
      st = "Wild Elf";
      break;
    case RACIAL_SUBTYPE_WOOD_ELF:
      st = "Wood Elf";
      break;
    }
  }
 
  return st;
}

string GetPCGender(object oPC) {
  string st = "N/A";
  int    i = GetGender(oPC);

  switch (i) {
    case GENDER_MALE:
      st = "Male";
      break;
    case GENDER_FEMALE:
      st = "Female";
      break;	  
  }
  
  return st;
}

string GetAlignment(object oPC) {
  string st;
  int    i = GetAlignmentLawChaos(oPC);

  st = "Neutral ";
  switch (i) {
    case ALIGNMENT_LAWFUL:
      st = "Lawful ";
      break;
    case ALIGNMENT_CHAOTIC:
      st = "Chaotic ";
      break;
  }

  i = GetAlignmentGoodEvil(oPC);
  switch(i) {
    case ALIGNMENT_GOOD:
      st = st + "Good";
      break;
    case ALIGNMENT_EVIL:
      st = st + "Evil";
      break;
    case ALIGNMENT_NEUTRAL:
      st = st + "Neutral";
      break;
  }
  if (st == "Neutral Neutral")
    st = "True Neutral";

  return st;
}

string GetClass(int iPos, object oPC) {
  string st;
  int    i = GetClassByPosition(iPos, oPC);

  switch (i) {
    case CLASS_TYPE_ARCANE_ARCHER:
      st = "Arcane Archer";
      break;
    case CLASS_TYPE_ARCANETRICKSTER:
      st = "Arcane Trickster";
      break;
    case CLASS_TYPE_ASSASSIN:
      st = "Assassin";
      break;
    case CLASS_TYPE_BARBARIAN:
      st = "Barbarian";
      break;
    case CLASS_TYPE_BARD:
      st = "Bard";
      break;
    case CLASS_TYPE_BLACKGUARD:
      st = "Blackguard";
      break;
    case CLASS_TYPE_CLERIC:
      st = "Cleric";
      break;
    case CLASS_TYPE_DIVINECHAMPION:
      st = "Divine Champion";
      break;
    case CLASS_TYPE_DRAGONDISCIPLE:
      st = "Dragon Disciple";
      break;
    case CLASS_TYPE_DRUID:
      st = "Druid";
      break;
    case CLASS_TYPE_DUELIST:
      st = "Duelist";
      break;
    case CLASS_TYPE_DWARVENDEFENDER:
      st = "Dwarven Defender";
      break;
    case CLASS_TYPE_ELDRITCH_KNIGHT:
      st = "Eldritch Knight";
      break;
    case CLASS_TYPE_FIGHTER:
      st = "Fighter";
      break;
    case CLASS_TYPE_FRENZIEDBERSERKER:
      st = "Frenzied Berserker";
      break;
    case CLASS_TYPE_HARPER:
      st = "Harper";
      break;
    case CLASS_TYPE_MONK:
      st = "Monk";
      break;
    case CLASS_TYPE_PALADIN:
      st = "Paladin";
      break;
    case CLASS_TYPE_PALEMASTER:
      st = "Palemaster";
      break;
    case CLASS_TYPE_RANGER:
      st = "Ranger";
      break;
    case CLASS_TYPE_ROGUE:
      st = "Rogue";
      break;
    case CLASS_TYPE_SHADOWDANCER:
      st = "Shadow Dancer";
      break;
    case CLASS_TYPE_SHIFTER:
      st = "Shifter";
      break;
    case CLASS_TYPE_SORCERER:
      st = "Sorcerer";
      break;
    case CLASS_TYPE_WARLOCK:
      st = "Warlock";
      break;
    case CLASS_TYPE_WARPRIEST:
      st = "War Priest";
      break;
    case CLASS_TYPE_WEAPON_MASTER:
      st = "Weapon Master";
      break;
    case CLASS_TYPE_WIZARD:
      st = "Wizard";
      break;
  }

  return st;
}

int GetLevel(object oPC){
  int i = 0;

  i = i + GetLevelByPosition(1, oPC);
  i = i + GetLevelByPosition(2, oPC);
  i = i + GetLevelByPosition(3, oPC);

  return i;
}

string StringZero(int iNum, int iSize) {
	string st;
	
	st = IntToString(iNum);
	if (GetStringLength(st) < iSize)
		st = GetStringLeft("0000000000000000", iSize-GetStringLength(st)) + st;
	
	return st;
}

string GetGameDate() {
  string sDate;
  
  sDate = StringZero(GetCalendarYear(), 4) +
  		  StringZero(GetCalendarMonth(), 2) +
		  StringZero(GetCalendarDay(), 2);

  return sDate;
  
}

string GetGameTime() {
  string sDate;
  
  sDate = StringZero(GetCalendarYear(), 4) +
  		  StringZero(GetCalendarMonth(), 2) +
		  StringZero(GetCalendarDay(), 2) +
		  StringZero(GetTimeHour(), 2) +
		  StringZero(GetTimeMinute(), 2);

  return sDate;
  
}

// =============================================================
// MODULE FUNCTIONS
// =============================================================
void Row_ModuleStart_SQLite(){
  string sSQL;
  
  // DEBUG CODE
  if (iNWNdebug)
  	DBAddError("-- Row_ModuleStart_SQLite");
  
  // CHECK COUNT TABLE
  WriteTimestampedLogEntry("-- Checking Table_Count");
  sSQL = "TableName varchar(25)," + 
         "TableCount int";
  if (DBTableExists("Table_Count", sSQL)) {
  	// DO NOTHING. TABLE EXISTS
  } else {
	// MAKE SURE THE COUNT TABLE EXISTS/WAS CREATED
    // IF THE TABLE IS MISSING, THEN THE DATABASE MAY NOT BE AVAILABLE
	// IE: TURN OFF DATABASE FUNCTIONS
	sSQL = "SELECT COUNT(TableName) FROM Table_Count";
	SQLExecDirect(sSQL);
	
	if (SQLFetch() != SQL_SUCCESS) {
	  WriteTimestampedLogEntry("SQL Database is Unavailable. Disabling.");
	  if (iNWNdebug)
		DBAddError("SQL Database is Unavailable. Disabling.");
  	  //gDatabaseType = DATABASE_TYPE_NONE;
	  return;
	}
  }
  
  
  // CHECK ERROR TABLE
  WriteTimestampedLogEntry("-- Checking Table_Error");
  sSQL = "ErrorID int," +
  		 "ErrorDate Date," +
         "ErrorDesc varchar(500)";
  if (DBTableExists("Table_Error", sSQL)) { 
    // DO NOTHING 
  }
  
  // CHECK CDKEY TABLE
  WriteTimestampedLogEntry("-- Checking Table_CDKey");
  sSQL = "CDKeyID int," +
         "CDKey varchar(16)," + 
         "Banned int";
  if (DBTableExists("Table_CDKey", sSQL)) { 
  	// DO NOTHING 
  }

  // CHECK IP ADDRESS TABLE
  WriteTimestampedLogEntry("-- Checking Table_IPAddress");
  sSQL = "IPID int," +
         "CDKeyID int," +
         "IPAddress varchar(16)," + 
         "Banned int";
  if (DBTableExists("Table_IPAddress", sSQL)) { 
  	// DO NOTHING 
  }

  // CHECK PLAYER TABLE
  WriteTimestampedLogEntry("-- Checking Table_Player");
  sSQL = "PlayerID int," +
         "CDKeyID int," +
         "PlayerName varchar(64)," + 
         "Banned int," +
         "FirstLogin Date," +
         "LastLogin Date," +
         "LastLogout Date," +
         "LoginCount int," +
         "TimeOnline int," +
		 "isDM int";
  if (DBTableExists("Table_Player", sSQL)) { 
    // DO NOTHING 
  }

  // CHECK CHARACTER TABLE
  WriteTimestampedLogEntry("-- Checking Table_Character");
  sSQL = "CharacterID int," +
         "PlayerID int," +
         "CharName varchar(32)," + 
         "FirstLogin Date," +
         "LastLogin Date," +
         "LastLogout Date," +
         "LoginCount int," +
		 "TimeOnline int," +
         "Banned int," +
         "Deleted int," +
         "Race varchar(32)," + 
         "SubRace varchar(32)," + 
         "Gender varchar(6)," + 
         "XP int," +
         "GP int," +
         "Alignment varchar(16)," + 
         "OverallLevel int," +
         "MaxHP int," +
         "CurHP int," +
         "Class1 varchar(20)," + 
         "Class2 varchar(20)," + 
         "Class3 varchar(20)," + 
         "Level1 int," +
         "Level2 int," +
         "Level3 int," +
         "Deaths int," +
         "IsDead int," +
         "Abil_STR int," +
         "Abil_CON int," +
         "Abil_DEX int," +
         "Abil_INT int," +
         "Abil_WIS int," +
         "Abil_CHA int," +
         "IsOnline int";
  if (DBTableExists("Table_Character",  sSQL)) { 
    // DO NOTHING 
  }

  // CHECK LOCATION TABLE
  WriteTimestampedLogEntry("-- Checking Table_Location");
  sSQL = "LocationID int," +
         "CharacterID int," +
         "LKey varchar(10)," + 
         "AreaName varchar(64)," + 
         "Location varchar(250)";
  if (DBTableExists("Table_Location", sSQL)) { 
    // DO NOTHING 
  }
    
  // CHECK AREA TABLE
  WriteTimestampedLogEntry("-- Checking Table_Area");
  sSQL = "AreaID int," +
         "AreaName varchar(64)," + 
         "AreaTag varchar(100)," + 
         "Visits int," + 
         "WebMapX int," + 
         "WebMapY int," + 
         "WebSafe int," + 
         "WebInside int," + 
         "WebUnderground int";
  if (DBTableExists("Table_Area", sSQL)) { 
    // DO NOTHING 
  }
  
  // CHECK FACTION TABLE
  WriteTimestampedLogEntry("-- Checking Table_Faction");
  sSQL = "FactionID int," +
         "FactionName varchar(64)";
  if (DBTableExists("Table_Faction", sSQL)) { 
    // DO NOTHING 
  }

  // CHECK FACTION PLAYER TABLE
  WriteTimestampedLogEntry("-- Checking Table_Faction_Player");
  sSQL = "PlayerFactionID int," +
  		 "CharacterID int," +
		 "LastChanged Date," +
		 "FactionID int," + 
		 "FactionValue int," +
		 "FactionRank int";
  if (DBTableExists("Table_Faction_Player", sSQL)) { 
    // DO NOTHING 
  }
  
  // CHECK FACTION RULE TABLE
  WriteTimestampedLogEntry("-- Checking Table_Faction_Rule");
  sSQL = "FactionRuleID int," +
		 "FactionID int," + 
         "Action varchar(10)," +
		 "AffectFactionID int," +
		 "AffectValue int";
  if (DBTableExists("Table_Faction_Rule", sSQL)) { 
    // DO NOTHING 
  }
  
  // CHECK CALENDAR TABLE
  WriteTimestampedLogEntry("-- Checking Table_Calendar");
  sSQL = "DateID int," +
         "Value varchar(20)," + 
         "Year int," +
         "Month int," +
         "Day int," +
         "Hour int," +
         "Min int";
  if (DBTableExists("Table_Calendar", sSQL)) { 
    // DO NOTHING 
  }
  
  // CHECK RBS BANKING TABLE
  WriteTimestampedLogEntry("-- Checking Table_Bank");
  sSQL = "BankID int," +
		 "CharacterID int," + 
		 "BankTag varchar(32)," +
		 "SaveGP int," + 
		 "LoanGP int," + 
		 "SaveDate varchar(10)," +
		 "LoanDate varchar(10)";
  if (DBTableExists("Table_Bank", sSQL)) { 
    // DO NOTHING 
  }
  
  // CHECK RBS BANK VAULT TABLE
  WriteTimestampedLogEntry("-- Checking Table_Bank_Vault");
  sSQL = "BankVaultID int," +
		 "CharacterID int," + 
		 "VaultTag varchar(64)," +
         "ItemName varchar(75)," + 
         "ItemResRef varchar(64)," + 
         "ItemTag varchar(100)," + 
         "ItemCount int," +
         "Identified int," +
         "Charges int," +
         "CreatorID int," +
         "Rituals varchar(100)";
  if (DBTableExists("Table_Bank_Vault", sSQL)) { 
    // DO NOTHING 
  }
  
  // CHECK ITEM TABLE
  WriteTimestampedLogEntry("-- Checking Table_Item");
  sSQL = "ItemID int," +
         "OwnerID int," +
         "ItemName varchar(75)," + 
         "ItemResRef varchar(64)," + 
         "ItemTag varchar(100)," + 
         "ItemCount int," +
         "Identified int," +
         "Charges int," +
         "CreatorID int," +
         "StoredIn varchar(100)," + 
         "Rituals varchar(100)," + 
         "doDelete int";
  if (DBTableExists("Table_Item", sSQL)) { 
    // DO NOTHING 
  }
  
  // CHECK LOOT DROP TABLE
  WriteTimestampedLogEntry("-- Checking Table_LootDrop");
  sSQL = "LootID int," +
         "ItemName varchar(75)," + 
         "ItemResRef varchar(64)," + 
         "GPvalue int," +
         "TimesDropped int" ;
  if (DBTableExists("Table_LootDrop", sSQL)) { 
    // DO NOTHING 
  }

  // CHECK DISCOVERY TABLE
  WriteTimestampedLogEntry("-- Checking Table_Discovery");
  sSQL = "DiscoveryID int," +
         "CharacterID int," +
         "LocationTag varchar(32)," + 
         "Found int";
  if (DBTableExists("Table_Discovery", sSQL)) { 
  	// DO NOTHING 
  }

  // CHECK CREATURE TABLE
  WriteTimestampedLogEntry("-- Checking Table_NPC");
  sSQL = "NPCID int," +
  		 "NPCname varchar(64)," +
         "NPCtag varchar(32)," +
         "Level int," +
         "Deaths int," +
         "Kills int";
  if (DBTableExists("Table_NPC", sSQL)) { 
    // DO NOTHING 
  }
  
  // CHECK AUCTION TABLE
  WriteTimestampedLogEntry("-- Checking Table_Auction");
  sSQL = "AuctionID int," +
         "ItemID int," + 
         "OwnerID int," + 
         "EndYear int," + 
         "EndMonth int," + 
         "EndDay int," + 
         "EndHour int," + 
         "LastBidderID int," + 
         "LastBid int," + 
         "HighBid int," + 
         "Buyout int," + 
         "NumBids int," +
         "IsExpired int";
  if (DBTableExists("Table_Auction", sSQL)) { 
    // DO NOTHING 
  }
  
  // CHECK WEBUSER TABLE
  WriteTimestampedLogEntry("-- Checking Table_WebUser");
  sSQL = "WebUserID int," +
         "CDKeyID int," +
         "Username varchar(25)," + 
         "Password varchar(20)," + 
         "Email varchar(100)," + 
         "FirstLogin Date," +
         "LastLogin Date," +
         "LoginCount int," +
         "AccessLevel int";
  if (DBTableExists("Table_WebUser", sSQL)) { 
    // DO NOTHING  
  }
  
}

void Row_ModuleStart_MySQL(){
  string sSQL;
  
  // DEBUG CODE
  if (iNWNdebug)
  	DBAddError("-- Row_ModuleStart_MySQL");
  
  // CHECK COUNT TABLE
  WriteTimestampedLogEntry("-- Checking Table_Count");
  sSQL = "TableName varchar(25)," + 
         "TableCount int(8) default 0";
  if (DBTableExists("Table_Count", sSQL)) {
  	// DO NOTHING. TABLE EXISTS
  } else {
	// MAKE SURE THE COUNT TABLE EXISTS/WAS CREATED
    // IF THE TABLE IS MISSING, THEN THE DATABASE MAY NOT BE AVAILABLE
	// IE: TURN OFF DATABASE FUNCTIONS
	sSQL = "SELECT COUNT(TableName) FROM Table_Count";
	SQLExecDirect(sSQL);
	
	if (SQLFetch() != SQL_SUCCESS) {
	  WriteTimestampedLogEntry("SQL Database is Unavailable. Disabling.");
	  if (iNWNdebug)
		DBAddError("SQL Database is Unavailable. Disabling.");
  	  //gDatabaseType = DATABASE_TYPE_NONE;
	  return;
	}
  }
  
  
  // CHECK ERROR TABLE
  WriteTimestampedLogEntry("-- Checking Table_Error");
  sSQL = "ErrorID int," +
  		 "ErrorDate datetime," +
         "ErrorDesc varchar(500)," +
		 "PRIMARY KEY (ErrorID)";
  if (DBTableExists("Table_Error", sSQL)) { 
    // DO NOTHING 
  }
  
  // CHECK CDKEY TABLE
  WriteTimestampedLogEntry("-- Checking Table_CDKey");
  sSQL = "CDKeyID int," +
         "CDKey varchar(16)," + 
         "Banned int," +
		 "PRIMARY KEY (CDKeyID)";
  if (DBTableExists("Table_CDKey", sSQL)) { 
  	// DO NOTHING 
  }

  // CHECK IP ADDRESS TABLE
  WriteTimestampedLogEntry("-- Checking Table_IPAddress");
  sSQL = "IPID int," +
         "CDKeyID int," +
         "IPAddress varchar(16)," + 
         "Banned int," +
		 "PRIMARY KEY (IPID)";
  if (DBTableExists("Table_IPAddress", sSQL)) { 
  	// DO NOTHING 
  }

  // CHECK PLAYER TABLE
  WriteTimestampedLogEntry("-- Checking Table_Player");
  sSQL = "PlayerID int," +
         "CDKeyID int," +
         "PlayerName varchar(64)," + 
         "Banned int," +
         "FirstLogin datetime," +
         "LastLogin datetime," +
         "LastLogout datetime," +
         "LoginCount int," +
         "TimeOnline int," +
		 "isDM int," +
		 "PRIMARY KEY (PlayerID)";
  if (DBTableExists("Table_Player", sSQL)) { 
    // DO NOTHING 
  }

  // CHECK CHARACTER TABLE
  WriteTimestampedLogEntry("-- Checking Table_Character");
  sSQL = "CharacterID int," +
         "PlayerID int," +
         "CharName varchar(32)," + 
         "FirstLogin datetime," +
         "LastLogin datetime," +
         "LastLogout datetime," +
         "TimeOnline int," +
         "LoginCount int," +
         "Banned int," +
         "Deleted int," +
         "Race varchar(32)," + 
         "SubRace varchar(32)," + 
         "Gender varchar(6)," + 
         "XP int," +
         "GP int," +
         "Alignment varchar(16)," + 
         "OverallLevel int," +
         "MaxHP int," +
         "CurHP int," +
         "Class1 varchar(20)," + 
         "Class2 varchar(20)," + 
         "Class3 varchar(20)," + 
         "Level1 int," +
         "Level2 int," +
         "Level3 int," +
         "Deaths int," +
         "IsDead int," +
         "Abil_STR int," +
         "Abil_CON int," +
         "Abil_DEX int," +
         "Abil_INT int," +
         "Abil_WIS int," +
         "Abil_CHA int," +
         "IsOnline int," +
		 "PRIMARY KEY (CharacterID)";
  if (DBTableExists("Table_Character",  sSQL)) { 
    // DO NOTHING 
  }

  // CHECK LOCATION TABLE
  WriteTimestampedLogEntry("-- Checking Table_Location");
  sSQL = "LocationID int," +
         "CharacterID int," +
         "LKey varchar(10)," + 
         "AreaName varchar(64)," + 
         "Location varchar(250)," +
		 "PRIMARY KEY (LocationID)";
  if (DBTableExists("Table_Location", sSQL)) { 
    // DO NOTHING 
  }
    
  // CHECK AREA TABLE
  WriteTimestampedLogEntry("-- Checking Table_Area");
  sSQL = "AreaID int," +
         "AreaName varchar(64)," + 
         "AreaTag varchar(100)," + 
         "Visits int," + 
         "WebMapX int," + 
         "WebMapY int," + 
         "WebSafe int," + 
         "WebInside int," + 
         "WebUnderground int," +
		 "PRIMARY KEY (AreaID)";
  if (DBTableExists("Table_Area", sSQL)) { 
    // DO NOTHING 
  }
  
  // CHECK FACTION TABLE
  WriteTimestampedLogEntry("-- Checking Table_Faction");
  sSQL = "FactionID int," +
         "FactionName varchar(64)," +
		 "PRIMARY KEY (FactionID)";
  if (DBTableExists("Table_Faction", sSQL)) { 
    // DO NOTHING 
  }

  // CHECK FACTION PLAYER TABLE
  WriteTimestampedLogEntry("-- Checking Table_Faction_Player");
  sSQL = "PlayerFactionID int," +
  		 "CharacterID int," +
		 "LastChanged datetime," +
		 "FactionID int," + 
		 "FactionValue int," +
		 "FactionRank int," +
		 "PRIMARY KEY (PlayerFactionID)";
  if (DBTableExists("Table_Faction_Player", sSQL)) { 
    // DO NOTHING 
  }
  
  // CHECK FACTION RULE TABLE
  WriteTimestampedLogEntry("-- Checking Table_Faction_Rule");
  sSQL = "FactionRuleID int," +
		 "FactionID int," + 
         "Action varchar(10)," +
		 "AffectFactionID int," +
		 "AffectValue int," +
		 "PRIMARY KEY (FactionRuleID)";
  if (DBTableExists("Table_Faction_Rule", sSQL)) { 
    // DO NOTHING 
  }
  
  // CHECK CALENDAR TABLE
  WriteTimestampedLogEntry("-- Checking Table_Calendar");
  sSQL = "DateID int," +
         "Value varchar(20)," + 
         "Year int," +
         "Month int," +
         "Day int," +
         "Hour int," +
         "Min int," +
		 "PRIMARY KEY (DateID)";
  if (DBTableExists("Table_Calendar", sSQL)) { 
    // DO NOTHING 
  }
  
  // CHECK RBS BANKING TABLE
  WriteTimestampedLogEntry("-- Checking Table_Bank");
  sSQL = "BankID int," +
		 "CharacterID int," + 
		 "BankTag varchar(32)," +
		 "SaveGP int," + 
		 "LoanGP int," + 
		 "SaveDate varchar(10)," +
		 "LoanDate varchar(10)," +
		 "PRIMARY KEY (BankID)";
  if (DBTableExists("Table_Bank", sSQL)) { 
    // DO NOTHING 
  }
  
  // CHECK RBS BANKING TABLE
  WriteTimestampedLogEntry("-- Checking Table_Bank_Vault");
  sSQL = "BankVaultID int," +
		 "CharacterID int," + 
		 "VaultTag varchar(64)," +
         "ItemName varchar(75)," + 
         "ItemResRef varchar(64)," + 
         "ItemTag varchar(100)," + 
         "ItemCount int," +
         "Identified int," +
         "Charges int," +
         "CreatorID int," +
         "Rituals varchar(100)," + 
		 "PRIMARY KEY (BankVaultID)";
  if (DBTableExists("Table_Bank_Vault", sSQL)) { 
    // DO NOTHING 
  }
  
  // CHECK ITEM TABLE
  WriteTimestampedLogEntry("-- Checking Table_Item");
  sSQL = "ItemID int," +
         "OwnerID int," +
         "ItemName varchar(75)," + 
         "ItemResRef varchar(64)," + 
         "ItemTag varchar(100)," + 
         "ItemCount int," +
         "Identified int," +
         "Charges int," +
         "CreatorID int," +
         "StoredIn varchar(100)," + 
         "Rituals varchar(100)," + 
         "doDelete int,"+
		 "PRIMARY KEY (ItemID)";
  if (DBTableExists("Table_Item", sSQL)) { 
    // DO NOTHING 
  }
  
  // CHECK LOOT DROP TABLE
  WriteTimestampedLogEntry("-- Checking Table_LootDrop");
  sSQL = "LootID int," +
         "ItemName varchar(75)," + 
         "ItemResRef varchar(64)," + 
         "GPvalue int," +
         "TimesDropped int," +
		 "PRIMARY KEY (LootID)";
  if (DBTableExists("Table_LootDrop", sSQL)) { 
    // DO NOTHING 
  }

  // CHECK DISCOVERY TABLE
  WriteTimestampedLogEntry("-- Checking Table_Discovery");
  sSQL = "DiscoveryID int," +
         "CharacterID int," +
         "LocationTag varchar(32)," + 
         "Found int," +
		 "PRIMARY KEY (DiscoveryID)";
  if (DBTableExists("Table_Discovery", sSQL)) { 
  	// DO NOTHING 
  }

  // CHECK CREATURE TABLE
  WriteTimestampedLogEntry("-- Checking Table_NPC");
  sSQL = "NPCID int," +
  		 "NPCname varchar(64)," +
         "NPCtag varchar(32)," +
         "Level int," +
         "Deaths int," +
         "Kills int," +
		 "PRIMARY KEY (NPCID)";
  if (DBTableExists("Table_NPC", sSQL)) { 
    // DO NOTHING 
  }
  
  // CHECK AUCTION TABLE
  WriteTimestampedLogEntry("-- Checking Table_Auction");
  sSQL = "AuctionID int," +
         "ItemID int," + 
         "OwnerID int," + 
         "EndYear int," + 
         "EndMonth int," + 
         "EndDay int," + 
         "EndHour int," + 
         "LastBidderID int," + 
         "LastBid int," + 
         "HighBid int," + 
         "Buyout int," + 
         "NumBids int," +
         "IsExpired int," +
		 "PRIMARY KEY (AuctionID)";
  if (DBTableExists("Table_Auction", sSQL)) { 
    // DO NOTHING 
  }
  
  // CHECK WEBUSER TABLE
  WriteTimestampedLogEntry("-- Checking Table_WebUser");
  sSQL = "WebUserID int," +
         "CDKeyID int," +
         "Username varchar(25)," + 
         "Password varchar(20)," + 
         "Email varchar(100)," + 
         "FirstLogin datetime," +
         "LastLogin datetime," +
         "LoginCount int," +
         "AccessLevel int," +
		 "PRIMARY KEY (WebUserID)";
  if (DBTableExists("Table_WebUser", sSQL)) { 
    // DO NOTHING  
  }
  
}

void Row_ModuleStart() {
  string sSQL;
    
  // ABORT IF THE DATABASE IS ALREADY INITIALIZED
  if (GetLocalInt(GetModule(), "DATABASE_IS_INIT") == 1)
  	return;
	
  // DEBUG CODE
  if (iNWNdebug)
  	DBAddError("-- Row_ModuleStart");
  
  if (gDatabaseType == DATABASE_TYPE_NONE)
  	return; 
	
  // MAKE SURE NWNX4 IS UP AND RUNNING
  if (!NWNXInstalled()) { 
	gDatabaseType == DATABASE_TYPE_NONE;
	SetLocalString(GetModule(), "ERROR", "NWNX4 has not been installed.  Before proceeding with mysql installation, you'll need to download and install NWNX4.");
	PrintString("No NWNX4");
	return;
  }
   
  // CHECK TABLES - CREATE IF NECESSARY
  if (gDatabaseFormat == DATABASE_FORMAT_SQLITE)
  	Row_ModuleStart_SQLite();
  if (gDatabaseFormat == DATABASE_FORMAT_MYSQL)
  	Row_ModuleStart_MySQL();
  
  // GET/SET THE CURRENT DATE/TIME
  sSQL = "SELECT Year,Month,Day,Hour,Min FROM " + gTable_Prefix + "Table_Calendar WHERE value='current_date'";
  DBOpen(sSQL);
  if (SQLFetch() == SQL_SUCCESS) {
	int iYear  = StringToInt(SQLGetData(1));
	int iMonth = StringToInt(SQLGetData(2));
	int iDay   = StringToInt(SQLGetData(3));
	int iHour  = StringToInt(SQLGetData(4));
	int iMin   = StringToInt(SQLGetData(5));
	
	SetTime(iHour, iMin, 0, 0);
	SetCalendar(iYear, iMonth, iDay);
	
  } else {
	int iYear  = GetCalendarYear();
	int iMonth = GetCalendarMonth();
	int iDay   = GetCalendarDay();
	int iHour  = GetTimeHour();
	int iMin   = GetTimeMinute();

	DBAddRecord("Table_Calendar", "Value,Year,Month,Day,Hour,Min", "'current_date',"+
	IntToString(iYear)+","+IntToString(iMonth)+","+IntToString(iDay)+","+
	IntToString(iHour)+","+IntToString(iMin), "DateID");
  }

  // SET ALL PLAYERS/CHARACTERS AS OFFLINE
  DBUpdateInt("Table_Character", "IsOnline", 0, "IsOnline=1");
  
  // MARK THE MODULE AS LOADED  
  WriteTimestampedLogEntry("SQL TABLE CHECK COMPLETE");
  SetLocalInt(GetModule(), "DATABASE_IS_INIT", 1);
  
}

void Row_ModuleEnter(object oPC=OBJECT_INVALID) {
  int    iPID   = 0;
  int    iCID   = 0;
  int    iIsDM  = 0;
  int    iCount = 0;
  int    i      = 0;
    
  // GATHER THE EVENT TRIGGERING OBJECT IF IT IS NOT PASSED
  if (oPC == OBJECT_INVALID)
    oPC = GetEnteringObject();
	
  // ABORT IF THE OBJECT IS NOT A PLAYER OR DM
  if ((!GetIsPC(oPC) && !GetIsDM(oPC)) || GetIsPossessedFamiliar(oPC) || GetIsDMPossessed(oPC))
    return;
		
  // DEBUG CODE
  if (iNWNdebug)
  	DBAddError("-- Row_ModuleEnter");

  // ABORT IF THERE IS NO DATABASE ACCESS  
  if (gDatabaseType == DATABASE_TYPE_NONE)
  	return; 

  // STORE THE PLAYER'S DATABASE VALUES ONTO THE PLAYER OBJECT
  iPID  = GetPlayerID(oPC);
  iCID  = GetCharacterID(oPC);
  iIsDM = GetIsPlayerDM(oPC);
  
    
  // UPDATE THE PLAYER'S TIME STATISTICS
  iCount = DBReadInt("Table_Player", "LoginCount", "PlayerID=" + IntToString(iPID), oPC);
  iCount++;
  DBUpdateInt("Table_Player", "LoginCount", iCount, "PlayerID=" + IntToString(iPID), oPC);
  DBUpdateString("Table_Player", "LastLogin", gDateTimeNow, "PlayerID=" + IntToString(iPID), oPC);
  
  // UPDATE THE CHARACTER'S TIME STATISTICS
  iCount = DBReadInt("Table_Character", "LoginCount", "CharacterID=" + IntToString(iCID), oPC);
  iCount++;
  DBUpdateInt("Table_Character", "LoginCount", iCount, "CharacterID=" + IntToString(iCID), oPC);
  DBUpdateString("Table_Character", "LastLogin", gDateTimeNow, "CharacterID=" + IntToString(iCID), oPC);
  DBUpdateInt("Table_Character", "isOnline", 1, "CharacterID=" + IntToString(iCID), oPC);

  // UPDATE THE IP ADDRESS TABLE
  if (DBRecordExists("Table_IPAddress", "IPAddress='" + GetPCIPAddress(oPC) + "'") == FALSE) 
    i = DBAddRecord("Table_IPAddress", "CDKeyID,IPAddress,Banned", IntToString(GetCDKeyID(oPC)) + ",'" + GetPCIPAddress(oPC) + "',0", "IPID");
  
  // INITALIZE THE PLAYER'S CHARACTER ONLINE STATUS
  SetLocalInt(oPC, "IsOnline", FALSE);
  
  // DISPLAY LOGIN TO DM'S AND TO LOG FILE
  SendMessageToAllDMs("[Player Name: "+GetPCPlayerName(oPC)+ "] [Character Name: "+GetName(oPC)+"] [Character Logins: "+IntToString(i)+"]");
  WriteTimestampedLogEntry(" Player Name: " + GetPCPlayerName(oPC) + " Character Name: "+GetName(oPC));
  WriteTimestampedLogEntry("  IP Address: " + GetPCIPAddress(oPC) +   " CD Key: " + GetPCPublicCDKey(oPC));
  WriteTimestampedLogEntry("Total Logins: "+IntToString(i));
  if (GetIsDM(oPC))
    WriteTimestampedLogEntry("LOGGED ON AS DM!!!");

  // CHECK IF THE USER IS BANNED
  if (DBReadInt("Table_Player", "Banned", "PlayerID=" + IntToString(iPID)) == TRUE) {
    SendMessageToAllDMs("[PLAYER IS BANNED! BOOTING...]");
    WriteTimestampedLogEntry("---PLAYER IS BANNED! BOOTING...");  
    AssignCommand(oPC, BootPC(oPC));
	return;
  }  
  // CHECK IF THE USER IS SIGNED ON AS A DM, BUT THEIR PLAYER ACCOUNT IS NOT DM ACTIVE
  // (EXTRA SECURITY AGAINST FAKE DM'S / HACKERS)
  if (GetIsDM(oPC) && iIsDM == FALSE) {
    SendMessageToAllDMs("[PLAYER IS SIGNED ON AS A DM, BUT ACCOUNT NOT SET AS A DM! BOOTING...]");
    WriteTimestampedLogEntry("---PLAYER IS NOT A DM! BOOTING...");  
    AssignCommand(oPC, BootPC(oPC));
	return;
  }
  
  // SET THE PLAYER FLAG THAT THEY ARE ONLINE TO TRUE
  SetLocalInt(oPC, "CHARACTER_IS_NOW_ONLINE", 1);
  
}


void Row_ModulePlayerLoaded(object oPC=OBJECT_INVALID) {
  int      iCID = 0;
  string   strLoc;
  location lLoc;
  int 	   i;
  
  // DEBUG CODE
  if (iNWNdebug)
  	DBAddError("-- Row_ModulePlayerLoaded");
  
  // GATHER THE EVENT TRIGGERING OBJECT IF IT IS NOT PASSED
  if (oPC == OBJECT_INVALID)
    oPC = GetEnteringObject();
	
  // ABORT IF THE OBJECT IS NOT A PLAYER OR DM
  if (!GetIsPC(oPC))
    return;

  // ABORT IF THE PLAYER IS NOT READY TO BE TELEPORTED YET
  if (GetLocalInt(oPC, "OKAY_TO_PORT") != 1) 
  	return;
	
  // STORE THE PLAYER'S DATABASE VALUES ONTO THE PLAYER OBJECT
  iCID = GetCharacterID(oPC);

  // ABORT IF THE PLAYER IS LOGGING BACK ON (BEFORE THE SERVER WAS RESET)
  if (GetLocalInt(oPC, "CHAR_LOG_ON_COMPLETE") == 1) {
  
    // CHECK / SET THE CHARACTER'S HIT POINTS
    i = DBReadInt("Table_Character", "CurHP", "CharacterID=" + IntToString(iCID));
    if (GetCurrentHitPoints(oPC) > i) 
    	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetCurrentHitPoints(oPC)-i, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL, TRUE), oPC);
  
    // IF THE CHARACTER IS DEAD IN THE DATABASE, MAKE THE CHARACTER DEAD
    i = DBReadInt("Table_Character", "IsDead", "CharacterID=" + IntToString(iCID));
    if (i == 1 && !GetIsDead(oPC))
  	  DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetMaxHitPoints(oPC)+50, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL, TRUE), oPC));
	  
	// SET FEATS / SPELLS TO NO USES LEFT	  
    Row_ResetCharacter(oPC);
	
  	return;
  }
  			
  // JUMP THE CHARACTER TO THE LAST SAVED LOCATION
  strLoc = DBReadString("Table_Location", "Location", "CharacterID=" + IntToString(iCID) + " AND LKey='saved'", oPC);
  if (strLoc != "") {
	lLoc   = SQLStringToLocation(strLoc);
	DelayCommand(0.5, AssignCommand(oPC, JumpToLocation(lLoc)));
	DelayCommand(0.7, AssignCommand(oPC, SetFacing(GetFacingFromLocation(lLoc))));
  }
    
  SetLocalInt(oPC, "CHAR_LOG_ON_COMPLETE", 1);
  
}


void Row_ModuleExit(object oPC=OBJECT_INVALID) {
  string sSQL;
  int    iPID;
  int    iCID;
  int    i        = 0;
  int    iTotal   = 0;
  int    iTimeNow = 0;
    
  // GATHER THE EVENT TRIGGERING OBJECT IF IT IS NOT PASSED
  if (oPC == OBJECT_INVALID)
    oPC = GetExitingObject();
	
  // ABORT IF THE OBJECT IS NOT A PLAYER OR DM
  if ((!GetIsPC(oPC) && !GetIsDM(oPC)) || GetIsPossessedFamiliar(oPC) || GetIsDMPossessed(oPC))
    return;
		
  // DEBUG CODE
  if (iNWNdebug)
  	DBAddError("-- Row_ModuleExit");
  
  // SET THE PLAYER FLAG THAT THEY ARE ONLINE TO TRUE
  SetLocalInt(oPC, "CHARACTER_IS_NOW_ONLINE", 0);

    // UPDATE THE PLAYER TIME STATISTICS
  iPID = GetPlayerID(oPC);
  iCID = GetCharacterID(oPC);
  
  // SET THE CHARACTER'S CURRENT HIT POINTS
  DBUpdateInt("Table_Character", "CurHP", GetCurrentHitPoints(oPC), "CharacterID=" + IntToString(iCID), oPC);
  
  // SET THE CHARACTER'S DEATH STATUS
  DBUpdateInt("Table_Character", "IsDead", GetIsDead(oPC), "CharacterID=" + IntToString(iCID), oPC);
    
  // UPDATE TIME SPENT ONLINE
  if (gDatabaseFormat == DATABASE_FORMAT_SQLITE) {
    sSQL = "";
//	SQLITE CANNOT DO DATE/TIME CALCULATIONS
//	sSQL = "SELECT DATEDIFF('n',LastLogin,'" + gDateTimeNow + "'),TimeOnline FROM " + gTable_Prefix + "Table_Player" +
//	       "  WHERE PlayerID=" + IntToString(iPID);
  }
  if (gDatabaseFormat == DATABASE_FORMAT_MYSQL) {
	sSQL = "SELECT TIMESTAMPDIFF(MINUTE, LastLogin, " + gDateTimeNow + "),TimeOnline FROM " + gTable_Prefix + "Table_Player" +
           "  WHERE PlayerID=" + IntToString(iPID);
  }

  if (sSQL != "") {
    SQLExecDirect(sSQL);
    if (SQLFetch() == SQL_SUCCESS) {
      iTimeNow = StringToInt(SQLGetData(1));
      iTotal   = StringToInt(SQLGetData(2));
      iTotal   = iTotal + iTimeNow;
      DBUpdateInt("Table_Player", "TimeOnline", iTotal, "PlayerID=" + IntToString(iPID), oPC);
    }
  }
  DBUpdateString("Table_Player", "LastLogout", gDateTimeNow, "PlayerID=" + IntToString(iPID), oPC);

  // UPDATE THE CHARACTER TIME STATISTICS
  if (gDatabaseFormat == DATABASE_FORMAT_SQLITE) {
	  sSQL = "";
//	  SQLITE CANNOT DO DATE/TIME CALCULATIONS
//	  sSQL = "SELECT DATEDIFF('n',LastLogin'," + gDateTimeNow + "'),TimeOnline FROM " + gTable_Prefix + "Table_Character" +
//           "  WHERE CharacterID=" + IntToString(iCID);
  }
  if (gDatabaseFormat == DATABASE_FORMAT_MYSQL) {
	sSQL = "SELECT TIMESTAMPDIFF(MINUTE, LastLogin, " + gDateTimeNow + "),TimeOnline FROM " + gTable_Prefix + "Table_Character" +
           "  WHERE CharacterID=" + IntToString(iCID);
  }
		 
  if (sSQL != "") {
    SQLExecDirect(sSQL);
    if (SQLFetch() == SQL_SUCCESS) {
      iTimeNow = StringToInt(SQLGetData(1));
      iTotal   = StringToInt(SQLGetData(2));
      iTotal   = iTotal + iTimeNow; 
  	  DBUpdateInt("Table_Character", "TimeOnline", iTotal, "CharacterID=" + IntToString(iCID), oPC);
    }
  }
  DBUpdateString("Table_Character", "LastLogout", gDateTimeNow, "CharacterID=" + IntToString(iCID), oPC);
  
  // SET THE PLAYER/CHARACTER AS OFFLINE
  DBUpdateInt("Table_Character", "IsOnline", 0, "CharacterID=" + IntToString(iCID), oPC);
  
}


// =============================================================
// AREA FUNCTIONS
// =============================================================
void Row_AreaEnter(object oPC=OBJECT_INVALID) {
  object oArea   = OBJECT_SELF;
  string sSQL;
  int    iCID;
  int    iVisits = 0;
  int    iCount  = 0;
  int    iLevel  = 0;

    // GATHER THE EVENT TRIGGERING OBJECT IF IT IS NOT PASSED
  if (oPC == OBJECT_INVALID)
    oPC = GetEnteringObject();
	
  // ABORT IF THE OBJECT IS NOT A PLAYER OR DM
  if ((!GetIsPC(oPC) && !GetIsDM(oPC)) || GetIsPossessedFamiliar(oPC) || GetIsDMPossessed(oPC))
    return;
		
  // DEBUG CODE
  if (iNWNdebug)
  	DBAddError("-- Row_AreaEnter");
  
  // CLEAR THE CHARACTER'S COMBAT FLAG
  if (GetIsPC(oPC) && GetIsInCombat(oPC))
    AssignCommand(oPC, ClearAllActions(TRUE));
  
  // CHECK IF AREA EXISTS IN DATABASE - ADD IF IT IS NOT
  if (GetLocalInt(oArea, "DBchecked") != 1) {
    if (DBRecordExists("Table_Area", "AreaTag='" + GetTag(oArea) + "'") == FALSE) {
      sSQL = "'" + SQLEncode(GetName(oArea)) + "'," +
			 "'" + GetTag(oArea) + "'," +
			 IntToString(GetIsAreaInterior(oArea)) + "," +
			 IntToString(GetIsAreaInterior(oArea) && GetIsAreaNatural(oArea));
	  if (DBAddRecord("Table_Area", "AreaName,AreaTag,WebInside,WebUnderground", sSQL, "AreaID")) {
	    // Do Nothing
	  }
	}
	SetLocalInt(oArea, "DBchecked", 1);
  }
  
  // UPDATE AREA INFORMATION IN DATABASE
  iVisits = DBReadInt("Table_Area", "Visits", "AreaTag='" + GetTag(oArea) + "'");
  iVisits++;
  if (GetIsDM(oPC) || !GetIsPC(oPC)) {
    // Do nothing - DM's and NPCs do not affect Area Visit Counts
  } else {
    DBUpdateInt("Table_Area", "Visits", iVisits, "AreaTag='" + GetTag(oArea) + "'");
  }

  // UPDATE THE CHARACTER'S LOCATION IN THE DATABASE
  iCID = GetCharacterID(oPC);
  if (GetIsPC(oPC) && iCID > 0) {
	sSQL = "SET " +
		   "AreaName='" + SQLEncode(GetName(oArea)) + "'," +
		   "Location='" + SQLLocationToString(GetLocation(oPC)) + "'";
	DBSQLCmd("UPDATE "  + gTable_Prefix + "Table_Location " + sSQL + " WHERE LKey='current' AND CharacterID=" + IntToString(iCID));
	if (GetLocalInt(oPC, "IsOnline") == FALSE)
	  DBUpdateInt("Table_Character", "IsOnline", 1, "CharacterID=" + IntToString(iCID), oPC);
  }
  
  // LIST OTHER PLAYERS IN ZONE
  SendMessageToPC(oPC, "Entering: " + GetName(oArea));
  object tempObj = GetFirstPC();
  while (GetIsObjectValid(tempObj)) {
    if (GetTag(GetArea(tempObj)) == GetTag(GetArea(oPC)) && !GetIsDM(tempObj)) {
      iCount = iCount + 1;
      iLevel = iLevel + GetHitDice(tempObj);
    }
    tempObj = GetNextPC();
  }
  if (iCount > 1) {
    SendMessageToPC(oPC,   "   There are " + IntToString(iCount) + " Players here, including you.");
    SendMessageToPC(oPC,   "   Including you, Average Level: " + IntToString(iLevel / iCount));
    if (!GetIsDM(oPC))
      SendMessageToPC(oPC, "   Excluding you, Average Level: " + IntToString((iLevel-GetHitDice(oPC)) / (iCount-1)));
  } else {
    SendMessageToPC(oPC,   "   You are the only Player in this Area.");
  }
  SendMessageToPC(oPC,     "   This Area has been used "+IntToString(iVisits)+" times.");
    
}


void Row_AreaExit(object oPC=OBJECT_INVALID) {
    object oArea       = OBJECT_SELF;
    object oCreature;
	object oItem;
    int    bPlayerHere = FALSE;

   // GATHER THE EVENT TRIGGERING OBJECT IF IT IS NOT PASSED
  if (oPC == OBJECT_INVALID)
    oPC = GetExitingObject();
  
  // ABORT IF THE OBJECT IS NOT A PLAYER OR DM
  if ((!GetIsPC(oPC) && !GetIsDM(oPC)) || GetIsPossessedFamiliar(oPC) || GetIsDMPossessed(oPC))
    return;
		
  // DEBUG CODE
  if (iNWNdebug)
  	DBAddError("-- Row_AreaExit");
  
  // LOOK FOR THE PRESENCE OF ANOTHER PLAYER IN THE CURRENT AREA
  oCreature = GetFirstObjectInArea(oArea);
  while(oCreature != OBJECT_INVALID && bPlayerHere == FALSE) {
    if (GetIsPC(oCreature) == TRUE)
       bPlayerHere = TRUE;
    oCreature = GetNextObjectInArea(oArea);
  }

  // IF PLAYERS ARE HERE, ABORT CLEANUP SCRIPT
  if (bPlayerHere == TRUE) return;
  
  // IF NO PLAYERS ARE HERE, CLEAN UP THE AREA
  oCreature = GetFirstObjectInArea(oArea);
  while(oCreature != OBJECT_INVALID) {
    //Destroy Encounter Created Creatures
    if (GetObjectType(oCreature) == OBJECT_TYPE_CREATURE && GetIsEncounterCreature(oCreature)) {
      SetPlotFlag(oCreature, FALSE);
      DestroyObject(oCreature);
    }

    //Destroy Dropped Items
    if (GetObjectType(oCreature) == OBJECT_TYPE_ITEM && GetPlotFlag(oCreature) == FALSE) {
      SetPlotFlag(oCreature, FALSE);
      DestroyObject(oCreature);
    }

    //Destroy Monster Corpses, and items on them
    if ( GetObjectType(oCreature) == OBJECT_TYPE_PLACEABLE &&
        (GetStringUpperCase(GetTag(oCreature)) == "BODY BAG" ||
         GetStringUpperCase(GetTag(oCreature)) == "BODYBAG"  ||
         GetStringUpperCase(GetTag(oCreature)) == "REMAINS")) {
      if (GetHasInventory(oCreature)) {
        oItem = GetFirstItemInInventory(oCreature);
        while (GetIsObjectValid(oItem)) {
          SetPlotFlag(oItem, FALSE);
          DestroyObject(oItem);
          oItem = GetNextItemInInventory(oCreature);
        }
	  }
      SetPlotFlag(oCreature, FALSE);
      DestroyObject(oCreature);
    }

    oCreature = GetNextObjectInArea(oArea);
  }

}


// =============================================================
// PLAYER FUNCTIONS
// =============================================================
void Row_PlayerRest(object oPC=OBJECT_INVALID) {
  string sSQL;
  string sCID;
  int    iCID;
  int    iRestCount;
  string sRestTime;
  string sNowTime    = GetGameTime();
  int    bOkayToRest = FALSE;
  
  // GATHER THE EVENT TRIGGERING OBJECT IF IT IS NOT PASSED
  if (oPC == OBJECT_INVALID)
    oPC  = GetLastPCRested();
  
  // GET LOCAL REST WATCH VARIABLES
  bOkayToRest = GetLocalInt(oPC, "I_AM_RESTING");
  iRestCount  = GetLocalInt(oPC, "ROW_REST_COUNT");
  sRestTime   = GetLocalString(oPC, "ROW_REST_TIME");

  // ABORT IF THE OBJECT IS NOT A PLAYER OR DM
  if ((!GetIsPC(oPC) && !GetIsDM(oPC)) || GetIsPossessedFamiliar(oPC) || GetIsDMPossessed(oPC))
    return;

  // DEBUG CODE
  if (iNWNdebug)
  	DBAddError("-- Row_PlayerRest");
  
  // GET CHARACTER ID
  iCID = GetCharacterID(oPC);
  sCID = IntToString(iCID);
  	
  switch (GetLastRestEventType()) {

	case REST_EVENTTYPE_REST_STARTED:
	  if (iRestRulesEnforced) {
		if (sRestTime != sNowTime) {
			SetLocalString(oPC, "ROW_REST_TIME", sNowTime);
			SetLocalInt(oPC, "ROW_REST_COUNT", 1);
			bOkayToRest = TRUE;
		} else {
			if (iRestCount < iRestNumberOfTimes) {
				SetLocalInt(oPC, "ROW_REST_COUNT", iRestCount+1);
				bOkayToRest = TRUE;
			} else {
				bOkayToRest = FALSE;
				AssignCommand(oPC, ClearAllActions(TRUE));
				FloatingTextStringOnCreature("You can only Rest " + IntToString(iRestNumberOfTimes) + " times per Hour.", oPC, FALSE);
			}
		}
		
	  } else {
		bOkayToRest = TRUE;
	  }
	
	  SetLocalInt(oPC, "I_AM_RESTING", bOkayToRest);
	  
	  if (bOkayToRest) {
  	    // SAVE THE AREA THAT THE PLAYER IS CURRENTLY IN TO THE DATABASE AS SAVED LOCATION
	    sSQL = "SET " +
			   "AreaName='" + SQLEncode(GetName(GetArea(oPC))) + "'," +
			   "Location='" +  SQLLocationToString(GetLocation(oPC)) + "'";
	    DBSQLCmd("UPDATE " + gTable_Prefix + "Table_Location " + sSQL + " WHERE LKey='saved' AND CharacterID=" + sCID);

	    // SAVE THE AREA THAT THE PLAYER IS CURRENTLY IN TO THE DATABASE AS CURRENT LOCATION
	    sSQL = "SET " +
			   "AreaName='" + SQLEncode(GetName(GetArea(oPC))) + "'," +
			   "Location='" +  SQLLocationToString(GetLocation(oPC)) + "'";
	    DBSQLCmd("UPDATE " + gTable_Prefix + "Table_Location " + sSQL + " WHERE LKey='current' AND CharacterID=" + sCID);
 
	    FloatingTextStringOnCreature("Your location has been saved.", oPC, FALSE);
	  }
	  break;
	  
	case REST_EVENTTYPE_REST_CANCELLED:
	  DeleteLocalInt(oPC, "I_AM_RESTING");
	  break;

	case REST_EVENTTYPE_REST_INVALID:
	  DeleteLocalInt(oPC, "I_AM_RESTING");
	  break;
	  
   	case REST_EVENTTYPE_REST_FINISHED:
	  if (bOkayToRest) {	
	    // UPDATE THE PLAYER'S CHARACTER INFORMATION TO THE DATABASE
	    ExportSingleCharacter(oPC);
	
	    // SAVE CHARACTER INFORMATION TO THE DATABASE
	    sSQL = "SET " +
			   "Abil_STR=" + IntToString(GetAbilityScore(oPC, ABILITY_STRENGTH)) + "," +
			   "Abil_CON=" + IntToString(GetAbilityScore(oPC, ABILITY_CONSTITUTION)) + "," +
			   "Abil_DEX=" + IntToString(GetAbilityScore(oPC, ABILITY_DEXTERITY)) + "," +
			   "Abil_INT=" + IntToString(GetAbilityScore(oPC, ABILITY_INTELLIGENCE)) + "," +
			   "Abil_WIS=" + IntToString(GetAbilityScore(oPC, ABILITY_WISDOM)) + "," +
			   "Abil_CHA=" + IntToString(GetAbilityScore(oPC, ABILITY_CHARISMA));
	    DBSQLCmd("UPDATE " + gTable_Prefix + "Table_Character " + sSQL + " WHERE CharacterID=" + sCID);
	
	    // SAVE CHARACTER INFORMATION TO THE DATABASE
	    sSQL = "SET " +
			   "XP=" + IntToString(GetXP(oPC)) + "," +
			   "GP=" + IntToString(GetGold(oPC)) + "," +
			   "MaxHP=" + IntToString(GetMaxHitPoints(oPC)) + "," +
			   "CurHP=" + IntToString(GetCurrentHitPoints(oPC)) + "," +
			   "OverallLevel=" + IntToString(GetLevel(oPC)) + "," +
			   "Level1=" + IntToString(GetLevelByPosition(1, oPC)) + "," +
			   "Level2=" + IntToString(GetLevelByPosition(2, oPC)) + "," +
			   "Level3=" + IntToString(GetLevelByPosition(3, oPC)) + "," +
			   "IsDead=" + IntToString(GetIsDead(oPC));
	    DBSQLCmd("UPDATE " + gTable_Prefix + "Table_Character " + sSQL + " WHERE CharacterID=" + sCID);

	    // SAVE CHARACTER INFORMATION TO THE DATABASE
	    sSQL = "SET " +
			   "Race='" + GetRace(oPC) + "'," +
			   "SubRace='" + GetRaceSub(oPC) + "'," +
			   "Alignment='" + GetAlignment(oPC) + "'," +
			   "Gender='" + GetPCGender(oPC) + "'," +
			   "Class1='" + GetClass(1, oPC) + "'," +
			   "Class2='" + GetClass(2, oPC) + "'," +
			   "Class3='" + GetClass(3, oPC) + "'";
	    DBSQLCmd("UPDATE " + gTable_Prefix + "Table_Character " + sSQL + " WHERE CharacterID=" + sCID);

	    FloatingTextStringOnCreature("Your character has been saved.", oPC, FALSE);
 	    DeleteLocalInt(oPC, "I_AM_RESTING");
	  }
	  break;
		
  }
  
}


void Row_PlayerDead(object oPC=OBJECT_INVALID, object oNPC=OBJECT_INVALID) {
  string sSQL;
  int    iCID;
  int    i;
  
  // GATHER THE EVENT TRIGGERING OBJECT IF IT IS NOT PASSED
  if (oPC == OBJECT_INVALID)
    oPC = GetLastPlayerDied();
  
  // FIND OUT WHO KILLED THE PLAYER
  if (oNPC == OBJECT_INVALID)
    oNPC = GetLastKiller();
	
  // ABORT IF THE OBJECT IS NOT A PLAYER OR DM
  if ((!GetIsPC(oPC) && !GetIsDM(oPC)) || GetIsPossessedFamiliar(oPC) || GetIsDMPossessed(oPC))
    return;
  
  // DEBUG CODE
  if (iNWNdebug)
  	DBAddError("-- Row_PlayerDead");
  
  // INCREASE THE CHARACTER'S DEATH COUNT
  iCID = GetCharacterID(oPC);
  i = DBReadInt("Table_Character", "Deaths", "CharacterID=" + IntToString(iCID), oPC);
  i++;
  
  // INCREASE THE NPC'S KILL COUNT
  IncreaseNPCkills(oNPC);
   
  // SET THE PLAYER AS DEAD IN THE DATABASE
  sSQL= "SET " +
		"Deaths=" + IntToString(i) + "," +
		"IsDead=" + IntToString(GetIsDead(oPC)) + "," +
		"CurHP="  + IntToString(GetCurrentHitPoints(oPC));
  DBSQLCmd("UPDATE " + gTable_Prefix + "Table_Character " + sSQL + " WHERE CharacterID=" + IntToString(iCID));

  sSQL = "SET " +
		 "AreaName='" + SQLEncode(GetName(GetArea(oPC))) + "'," +
		 "Location='" +  SQLLocationToString(GetLocation(oPC)) + "'";
  DBSQLCmd("UPDATE " + gTable_Prefix + "Table_Location " + sSQL + " WHERE LKey='current' AND CharacterID=" + IntToString(iCID));
    
}


void Row_PlayerRaise(int bPortToBind, object oPC=OBJECT_INVALID) {
  string   sSQL;
  string   strBindLocation;
  location locBindLocation;
  effect   eCharFX;
  int      iCID;
  int      i;
  
  // GATHER THE EVENT TRIGGERING OBJECT IF IT IS NOT PASSED
  if (oPC == OBJECT_INVALID) {
    oPC = GetLastRespawnButtonPresser();
	if (oPC == OBJECT_INVALID)
		oPC = GetLocalObject(OBJECT_SELF, "LAST_RESPAWN_BUTTON_PRESSER");
  }
  
  // RAISE THE CHARACTER
  if (GetIsDead(oPC)) {
    ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectResurrection(),oPC);
    if (bPortToBind == TRUE)
		ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectHeal(GetMaxHitPoints(oPC)), oPC);
    RemoveBadEffects(oPC);  
  }

  // ABORT IF THE OBJECT IS NOT A PLAYER OR DM
  if (!GetIsPC(oPC) || GetIsDM(oPC) || GetIsPossessedFamiliar(oPC) || GetIsDMPossessed(oPC))
    return;
  
  // DEBUG CODE
  if (iNWNdebug)
  	DBAddError("-- Row_PlayerRaise");
  
  // RESET FACTION STANDINGS
  SetStandardFactionReputation(STANDARD_FACTION_COMMONER, 80, oPC);
  SetStandardFactionReputation(STANDARD_FACTION_MERCHANT, 80, oPC);
  SetStandardFactionReputation(STANDARD_FACTION_DEFENDER, 80, oPC);

  // TRANSPORT THE CHARACTER TO THEIR BIND LOCATION?
  if (bPortToBind == TRUE) {
	iCID = GetCharacterID(oPC);
 	strBindLocation = DBReadString("Table_Location", "Location", "CharacterID=" + IntToString(iCID) + " AND LKey='bound'");
    if (strBindLocation != "") {
   	  locBindLocation = SQLStringToLocation(strBindLocation);
      AssignCommand(oPC, DelayCommand(0.2, JumpToLocation(locBindLocation)));
	  AssignCommand(oPC, DelayCommand(0.4, SetFacing(GetFacingFromLocation(locBindLocation))));
      eCharFX  = EffectVisualEffect(VFX_IMP_RESTORATION);
      DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eCharFX, oPC));
	} else {
	  SendMessageToPC(oPC, "Could not locate your Bind Location. Sorry.");
    }
  }
      
  // SET THE PLAYER AS ALIVE IN THE DATABASE
  sSQL= "SET ";
  sSQL = sSQL + "IsDead=" + IntToString(GetIsDead(oPC)) + ",";
  sSQL = sSQL + "CurHP="  + IntToString(GetCurrentHitPoints(oPC));
  DBSQLCmd("UPDATE " + gTable_Prefix + "Table_Character " + sSQL + " WHERE CharacterID=" + IntToString(iCID));

  sSQL = "SET " +
		 "AreaName='" + SQLEncode(GetName(GetArea(oPC))) + "'," +
		 "Location='" + strBindLocation + "'";
  DBSQLCmd("UPDATE " + gTable_Prefix + "Table_Location " + sSQL + " WHERE LKey='current' AND CharacterID=" + IntToString(iCID));
  
}


// =============================================================
// ITEM FUNCTIONS
// =============================================================
void Row_AddToLootTable(object oItem) {
  int iIID;
  int iCount;
  
  if (oItem == OBJECT_INVALID)
    return;
	
  // DEBUG CODE
  if (iNWNdebug)
  	DBAddError("-- Row_AddToLootTable");
  
  if (DBRecordExists("Table_LootDrop", "ItemResRef='" + GetResRef(oItem) + "'") == TRUE) {
    // INCREASE THE NUMBER OF TIMESDROPPED IN THE DATABASE FOR THIS ITEM
    iIID   = DBReadInt("Table_LootDrop", "ItemID",       "ItemResRef='" + GetResRef(oItem) + "'");
    iCount = DBReadInt("Table_LootDrop", "TimesDropped", "ItemID=" + IntToString(iIID) + "'");
	iCount++;
	DBUpdateInt("Table_LootDrop", "TimesDropped", iCount, "ItemID=" + IntToString(iIID) + "'");
  } else {
    // ADD ITEM INTO THE LOOT DROP TABLE
    iIID = DBAddRecord("Table_LootDrop", "ItemName,ItemResRef,GPvalue,TimesDropped", 
	                   "'" + SQLEncode(GetName(oItem)) + "','" + GetResRef(oItem) + "'," + 
					   IntToString(GetGoldPieceValue(oItem)) + ",1", "LootID");					
  }
  
}

object Row_ItemCreate(string strResRef, string strTag="", object oOwner=OBJECT_INVALID) {
  location locTempLocation;
  object   oItem;
  object   oTemp;
  string   strTempTag;
  string   sSQL;
  int      iItemID;

  if (gEnableItemTracking == FALSE) {
	oTemp = CreateItemOnObject(strResRef, oOwner);
    Row_AddToLootTable(oTemp);
	return oTemp;
  }
      
  // ABORT IF THE CHARACTER IS ACQUIRING A COPY OF THIS ITEM (FROM THIS SCRIPT)
  if (oOwner != OBJECT_INVALID) {
  	if (GetLocalInt(oOwner, "ITEM_CREATING") == 1)
	  return OBJECT_INVALID;
	SetLocalInt(oOwner, "ITEM_CREATING", 1);
  }
  
  // IGNORE GOLD CREATION
  if (strResRef == "nw_it_gold001")
    strTag = "";
	
  // CREATE THE BASE TAG
  if (strTag == "")
    strTag = strResRef;

  // CREATE THE TEMPORARY OBJECT AND ADD THAT INTO THE DATABASE AS A PLACEHOLDER
  locTempLocation = GetLocation(oOwner);
  strTempTag = strTag + IntToString(Random(99999) + 100000) + "DEL";
  oTemp      = CreateObject(OBJECT_TYPE_ITEM, strResRef, locTempLocation, FALSE, strTempTag);
  iItemID    = DBAddRecord("Table_Item", "ItemName,ItemResRef,ItemTag", "'" + SQLEncode(GetName(oTemp)) + "','" + GetResRef(oTemp) + "','" + strTempTag + "'", "ItemID", "ItemTag='" + strTempTag + "'");
  
  // CREATE THE REAL OBJECT BY COPYING THE TEMPORARY OBJECT AND ASSIGN IT A NEW TAG
  strTag     = strTag + "_" + FormatID(iItemID);
  oItem      = CopyObject(oTemp, locTempLocation, oOwner, strTag);
  SetPlotFlag(oTemp, FALSE);
  DestroyObject(oTemp);
  
  // UPDATE THE DATABASE
  SetLocalInt(oItem, "DB_ItemID", iItemID);
  sSQL = "SET " +
		 "ItemTag='"   + strTag + "'," +
		 "ItemCount="  + IntToString(GetNumStackedItems(oItem)) + "," +
		 "Identified=" + IntToString(GetIdentified(oItem)) + "," +
		 "Charges="    + IntToString(GetItemCharges(oItem));
  DBSQLCmd("UPDATE " + gTable_Prefix + "Table_Item " + sSQL + " WHERE ItemID=" + IntToString(iItemID));
  
  // ADD ITEM TO LOOTDROP TABLE IF THE ITEM WAS CREATED ON AN NPC OR IN A PLACEABLE (TREASURE CHEST)
  if (GetObjectType(oOwner) == OBJECT_TYPE_PLACEABLE ||
     (GetObjectType(oOwner) == OBJECT_TYPE_CREATURE  && !GetIsPC(oOwner) && !GetIsDM(oOwner))) 
    Row_AddToLootTable(oItem);
  
  if (oOwner != OBJECT_INVALID)
  	DeleteLocalInt(oOwner, "ITEM_CREATING");
	
  return oItem;

}


void Row_ItemGain(object oItem=OBJECT_INVALID) {
  object oGainer = GetModuleItemAcquiredBy();
  object oLoser  = GetModuleItemAcquiredFrom();
  string sSQL;
  int    iOwner;
  int    iIID;
  int    iCID;
  
  if (gEnableItemTracking == FALSE)
	  return;
  
  // ABORT IF WE ARE ALREADY IN THE MIDDLE OF TAKING CARE OF A GAINED ITEM
  if (GetLocalInt(oGainer, "ITEM_CREATING") > 0)
	return;	
  SetLocalInt(oGainer, "ITEM_CREATING", 1);
  
  // IF NOT ITEM IS PASSED TO THE FUNCTION, GRAB IT FROM THE MODULE
  if (oItem == OBJECT_INVALID)
    oItem = GetModuleItemAcquired();
  sSQL = GetTag(oItem);
  
  // DEBUG CODE
  if (iNWNdebug)
  	DBAddError("-- Row_ItemGain");
  
  // GET THE ITEMID.  RE-LOAD THE ITEM IF NECESSARY
  iIID = GetItemID(oItem, oGainer);
  iCID = GetCharacterID(oGainer);
  if (oItem == OBJECT_INVALID)
    oItem = GetItemPossessedBy(oGainer, sSQL + "_" + FormatID(iIID));
  
  if (GetIsPC(oGainer)) {
    iOwner = GetItemOwner(oItem);
	// SET THE ITEM OWNER TO THE PERSON THAT GAINED THE ITEM
	if (iOwner != iCID) {
      sSQL = "SET " +
			 "OwnerID="    + IntToString(iCID) + "," +
			 "doDelete="   + IntToString(FALSE) + "," +
			 "ItemCount="  + IntToString(GetNumStackedItems(oItem)) + "," +
			 "Identified=" + IntToString(GetIdentified(oItem)) + "," +
			 "Charges="    + IntToString(GetItemCharges(oItem));
      DBSQLCmd("UPDATE " + gTable_Prefix + "Table_Item " + sSQL + " WHERE ItemID=" + IntToString(iIID));
	  SetLocalInt(oItem, "DB_ItemOwner", iCID);
	}
	
	// IF ITEM WAS TAKEN FROM A CORPSE, OR A TREASURE CHEST, ADD IT TO THE LOOT DROP TABLE
	if (GetObjectType(oLoser) == OBJECT_TYPE_PLACEABLE)
      if (GetLocalInt(oLoser, "Track_Loot_Drops") == 1 ||
	      GetStringUpperCase(GetResRef(oLoser)) == "ROW_FP_CHEST" ||
         (GetStringUpperCase(GetTag(oLoser)) == "BODY BAG" ||
          GetStringUpperCase(GetTag(oLoser)) == "BODYBAG"  ||
          GetStringUpperCase(GetTag(oLoser)) == "REMAINS")) {
	    Row_AddToLootTable(oItem);
	  }
  } else {
    // SET THE ITEM TO UNOWNED IN THE DATABASE. MARK FOR DELETION
    iOwner = GetItemOwner(oItem);
	iCID   = GetCharacterID(oLoser);
	if (iOwner == iCID) {
      sSQL = "SET " +
			 "OwnerID=0,"  +
			 "doDelete="   + IntToString(TRUE) + "," +
			 "ItemCount="  + IntToString(GetNumStackedItems(oItem)) + "," +
			 "Identified=" + IntToString(GetIdentified(oItem)) + "," +
			 "Charges="    + IntToString(GetItemCharges(oItem));
      DBSQLCmd("UPDATE " + gTable_Prefix + "Table_Item " + sSQL + " WHERE ItemID=" + IntToString(iIID));
	  SetLocalInt(oItem, "DB_ItemOwner", 0);
	}
  }
  
  DeleteLocalInt(oGainer, "ITEM_CREATING");
  
}


void Row_ItemLose(object oItem=OBJECT_INVALID) {
  object oLoser = GetModuleItemLostBy();
  object oGainer;
  string sSQL;
  int    iIID;
  int    iOwner;
  
  if (gEnableItemTracking == FALSE)
	  return;
  	  
  // ABORT IF WE ARE ALREADY IN THE MIDDLE OF TAKING CARE OF A GAINED/LOST ITEM
  if (GetLocalInt(oLoser, "ITEM_CREATING") == 1)
	return;

  // IF NOT ITEM IS PASSED TO THE FUNCTION, GRAB IT FROM THE MODULE
  if (oItem == OBJECT_INVALID)
    oItem = GetModuleItemLost();
	
  if (oItem == OBJECT_INVALID) {
  	return;
  }
  
  // DEBUG CODE
  if (iNWNdebug)
  	DBAddError("-- Row_ItemLose");
  
  // GET THE ITEMID.  RE-LOAD THE ITEM IF NECESSARY
  iIID = GetItemID(oItem);
  
  // GET THE OBJECT THAT CURRENTLY OWNS THE ITEM
  oGainer = GetItemPossessor(oItem);
  if (oGainer == OBJECT_INVALID)
    oGainer = GetModuleItemAcquiredBy();
  
  		
  // SET THE ITEM TO UNOWNED IN THE DATABASE. MARK FOR DELETION
  if (GetIsPC(oLoser) && iIID > 0) {
    // iOwner = GetItemOwner(oItem);
	// if (iOwner == GetCharacterID(oLoser) || !GetIsPC(oGainer)) {
      sSQL = "SET " +
			 "doDelete=1," +
			 "ItemCount="  + IntToString(GetNumStackedItems(oItem)) + "," +
			 "Identified=" + IntToString(GetIdentified(oItem)) + "," +
			 "Charges="    + IntToString(GetItemCharges(oItem));
      DBSQLCmd("UPDATE " + gTable_Prefix + "Table_Item " + sSQL + " WHERE ItemID=" + IntToString(iIID));
	  SetLocalInt(oItem, "DB_ItemOwner", 0);
	// }
  }
  
}


// =============================================================
// NPC FUNCTIONS
// =============================================================


int GetNPCID(object oNPC) {
  string strFields;
  string strValues;
  int i;
  
  // NON-PLAYERS DON'T GET A CHARACTERID
  if (GetIsPC(oNPC) || GetIsDM(oNPC)) 
	return 0;
  
  if (DBRecordExists("Table_NPC", "NPCtag='" + GetTag(oNPC) + "'")) {
    i = DBReadInt("Table_NPC", "NPCID", "NPCtag='" + GetTag(oNPC) + "'");
  } else {
  	strFields = "NPCname,NPCtag,Level,Kills,Deaths";
	strValues = "'" + SQLEncode(GetName(oNPC)) + "','" + GetTag(oNPC) + "'," + IntToString(GetHitDice(oNPC)) + ",0,0";
    i = DBAddRecord("Table_NPC", strFields, strValues, "NPCID", "NPCtag='" + GetTag(oNPC) + "'"); 
  }

  return i;
  
}


void IncreaseNPCkills(object oNPC) {
  int iNID;
  int i;
  
  // GET THE NPC'S ID
  iNID = GetNPCID(oNPC);
  
  // GET THE NPC'S CURRENT VALUE
  i = DBReadInt("Table_NPC", "Kills", "NPCID=" + IntToString(iNID));
  
  // ADJUST THE VALUE
  i++;
  
  // SAVE THE VALUE TO THE DATABASE
  DBUpdateInt("Table_NPC", "Kills", i, "NPCID=" + IntToString(iNID));
    
}


void IncreaseNPCdeaths(object oNPC) {
  int iNID;
  int i;
  
  // GET THE NPC'S ID
  iNID = GetNPCID(oNPC);
  
  // GET THE NPC'S CURRENT VALUE
  i = DBReadInt("Table_NPC", "Deaths", "NPCID=" + IntToString(iNID));
  
  // ADJUST THE VALUE
  i++;
  
  // SAVE THE VALUE TO THE DATABASE
  DBUpdateInt("Table_NPC", "Deaths", i, "NPCID=" + IntToString(iNID));
  
}


// =============================================================
// OBJECT/MISC FUNCTIONS
// =============================================================

void Row_BindAltar(object oAltar, object oPC=OBJECT_INVALID) {
  string sSQL;
  effect eAltarFX, eCharFX;
  object oArea;
  int    iCID;
  
  if (oPC == OBJECT_INVALID)
  	oPC = GetLastUsedBy();
	
  // PLAY SOME PRETTY SFX ON THE ALTAR AND CHARACTER
  AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE, 1.0, 4.0));
  eAltarFX = EffectVisualEffect(VFX_IMP_AURA_HOLY);
  DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eAltarFX, oPC));
  eCharFX  = EffectVisualEffect(VFX_IMP_RESTORATION);
  DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eCharFX, oPC));

  
  // ABORT IF THE ACTIVATOR IS NOT A PC
  if (!GetIsPC(oPC))
  	return;
	
  // DEBUG CODE
  if (iNWNdebug)
  	DBAddError("-- Row_BindAltar");
  
  // UPDATE THE CHARACTER'S LOCATION IN THE DATABASE
  iCID = GetCharacterID(oPC);
  if (iCID > 0) {
    oArea = GetArea(oPC);
	sSQL = "SET " +
		   "AreaName='" +SQLEncode(GetName(oArea)) + "'," +
		   "Location='" +  SQLLocationToString(GetLocation(oPC)) + "'";
	DBSQLCmd("UPDATE " + gTable_Prefix + "Table_Location " + sSQL + " WHERE LKey='bound' AND CharacterID=" + IntToString(iCID));
	FloatingTextStringOnCreature("You feel your soul bind to this Altar.", oPC, FALSE);
  }

}
  
void Row_ResetCharacter(object oPC) {
  int i;
  int iDecrementIndex;
  talent tSpell;
  talent tFeat;

  i = 0;
  while (i < 1860) {
    tSpell = TalentSpell(i);
    tFeat  = TalentFeat(i);

    if (i < 1009 && GetIsTalentValid(tSpell))
	if (GetHasSpell(GetIdFromTalent(tSpell), oPC)) {
        for (iDecrementIndex = 1; iDecrementIndex < 10; iDecrementIndex++) {
          DecrementRemainingSpellUses(oPC, GetIdFromTalent(tSpell));
        }
    }

    if (GetIsTalentValid(tFeat))
	if (GetHasFeat(GetIdFromTalent(tFeat), oPC)) {
        for (iDecrementIndex = 1; iDecrementIndex < 10; iDecrementIndex++) {
          DecrementRemainingFeatUses(oPC, GetIdFromTalent(tFeat));
        }
    }
	i++;
  }

}


void Row_DiscoverLocation(object oPC, object oPlace=OBJECT_SELF) {
  string strFields;
  string strValues;
  int    iPCLevel = GetLevel(oPC);
  int    iPLLevel = GetLocalInt(oPlace, "DISCOVERY_LEVEL");
  int    iReward  = 0;
  int    iCID;
  int    i;
  int    iDiscovered;

  // GATHER THE EVENT TRIGGERING OBJECT IF IT IS NOT PASSED
  if (oPC == OBJECT_INVALID)
    oPC = GetEnteringObject();
	
  // ABORT IF THE OBJECT IS NOT A PLAYER OR DM
  if ((!GetIsPC(oPC) && !GetIsDM(oPC)) || GetIsPossessedFamiliar(oPC) || GetIsDMPossessed(oPC))
    return;
		
  // ABORT IF THERE IS NO DATABASE ACCESS  
  if (gDatabaseType == DATABASE_TYPE_NONE)
  	return; 

  // GET THE CHARACTER ID
  iCID = GetCharacterID(oPC);

  // CHECK IF THE LOCATION HAS ALREADY BEEN DISCOVERED BY THE CHARACTER
  iDiscovered = GetLocalInt(oPlace, "DISCOVERED_" + IntToString(iCID));
  if (iDiscovered)
  	return;
	  
  // SET MINIMUM VALUES
  if (iPLLevel < 1)
  	iPLLevel = 1;  
  
  // IF THE CHARACTER HASNT DISCOVERED THE LOCATION, REWARD THEM
  if (!DBRecordExists("Table_Discovery", "CharacterID=" + IntToString(iCID) + " AND LocationTag='" + GetTag(oPlace) + "'")) {

  	// SAVE THE DISCOVERY INTO THE DATABASE
	strFields = "CharacterID,LocationTag,Found";
	strValues = IntToString(iCID) + ",'" + GetTag(oPlace) + "',1";
    i = DBAddRecord("Table_Discovery", strFields, strValues, "DiscoveryID", "CharacterID=" + IntToString(iCID) + " AND LocationTag='" + GetTag(oPlace) + "'");
	
	// NOTIFY THE PLAYER OF HIS/HER DISCOVERY
	FloatingTextStringOnCreature("You have discovered " + GetName(oPlace), oPC, FALSE);

	// CALCULATE XP TO GIVE TO THE CHARACTER
	if (iPCLevel > iPLLevel) {
  	  iReward = ((20 - (iPCLevel - iPLLevel)) / 20) * iDiscoveryReward;
	  if (iReward < 5)
	  	iReward = 5;
	} else
	  iReward = iDiscoveryReward;

	// GIVE THE CHARACTER THE XP REWARD
	AssignCommand(oPC, GiveXPToCreature(oPC, iReward));
	
  }
  
  // MARK THIS LOCATION AS SAVED
  SetLocalInt(oPlace, "DISCOVERED_" + IntToString(iCID), TRUE);

}


// =============================================================
// DUPLICATED FUNCTIONS FROM OTHER NWN SCRIPTS
// =============================================================

void RemoveBadEffects(object oPC) {
    //Declare major variables
    object oTarget = oPC;
    effect eVisual = EffectVisualEffect(VFX_IMP_RESTORATION);
    effect eBad    = GetFirstEffect(oTarget);
    int    bValid;
	
    //Search for negative effects
    while(GetIsEffectValid(eBad)) {
        if (GetEffectType(eBad) == EFFECT_TYPE_ABILITY_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_AC_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_ATTACK_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_SAVING_THROW_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_SKILL_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_BLINDNESS ||
            GetEffectType(eBad) == EFFECT_TYPE_DEAF ||
            GetEffectType(eBad) == EFFECT_TYPE_PARALYZE ||
            GetEffectType(eBad) == EFFECT_TYPE_NEGATIVELEVEL ||
            GetEffectType(eBad) == EFFECT_TYPE_FRIGHTENED ||
            GetEffectType(eBad) == EFFECT_TYPE_DAZED ||
            GetEffectType(eBad) == EFFECT_TYPE_CONFUSED ||
            GetEffectType(eBad) == EFFECT_TYPE_POISON ||
            GetEffectType(eBad) == EFFECT_TYPE_DISEASE
                )
            {
                //Remove effect if it is negative.
                RemoveEffect(oTarget, eBad);
            }
        eBad = GetNextEffect(oTarget);
    }
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RESTORATION, FALSE));

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);

}