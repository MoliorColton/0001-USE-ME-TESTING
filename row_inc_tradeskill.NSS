// =============================================================
//
//    File: row_inc_tradeskill
//    Desc: Rowell's Tradeskill System
//  Author: Michael Marzilli
//    Site: http://www.engliton.org
//
// Created: Nov 28, 2006
// Updated: Jan 18, 2007
// Version: 1.0.3
//
// =============================================================

#include "row_inc_functions"


// =============================================================
// GLOBAL FUNCTIONS
// =============================================================

// RTS_ModuleInitTradeskills();
//   Used to Initialize the Tradeskill System.
//   Call in your OnModuleStart Event
void   RTS_ModuleInitTradeskills();

// RTS_GetLevel(object oPC, int iSkill)
//   Returns the Character's (oPC) Tradeskill Level in a particular Skill (iSkill)
int    RTS_GetLevel(object oPC, int iSkill);

// RTS_GetXP(object oPC, int iSkill)
//   Returns the Character's (oPC) Tradeskill XP in a particular Skill (iSkill)
int    RTS_GetXP(object oPC, int iSkill);

// RTS_GetSkillName
//   Returns the Text String Equivalent for the numeric value of a Skill (iSkill)
string RTS_GetSkillName(int iSkill);

// RTS_CalcLevel(object oPC, int iSkill, int iXP)
//   Returns the Tradeskill Level for a Character (oPC) for a particular Skill (iSkill)
//   depending upon the number of XP (iXP) that character has
int    RTS_CalcLevel(object oPC, int iSkill, int iXP);

// RTS_AdjustXP(object oPC, int iSkill, int iAdjust)
//   Give the Character (oPC) additional XP (iAdjust) applied to a particular Skill (iSkill)
void   RTS_AdjustXP(object oPC, int iSkill, int iAdjust, int iRLevel);

// RTS_CanUseRecipe(object oPC, int iSkill, iRecipe)
//   Makes sure that a Character (oPC) has the proper Skill Level in Skill (iSkill) to
//   use a Recipe (iRecipe).  The function also makes sure that the character has the 
//   Recipe in their recipe book
int    RTS_CanUseRecipe(object oPC, int iSkill, int iRecipe);

// RTS_AcquireRecipe(object oPC, object oItem, int iRecipe)
//   Adds the Recipe (iRecipe) to the Character's (oPC) Recipe Book.
//   Also destroys the Recipe object (oItem) that the character used to learn the recipe.
void   RTS_AcquireRecipe(object oPC, object oItem, int iRecipe);

// RTS_UseRecipe(object oPC, object oItem, int iRecipe)
//   When a Character (oPC) uses a crafting Station (oItem) to apply a Recipe (iRecipe)
//   Checks the following:
//     Does the Character have the Recipe in their Recipe Book?
//     Is the Character Skilled enough in the Tradeskill to make the item?
//     Is the Character using the proper Craft Station?  (if applicable)
//     Does the Character have the proper Tools?
//     Does the Character have the proper Resources, in the proper Quantities?
//   If so, the item is created, the resources used up, and Tradeskill XP awarded.
void   RTS_UseRecipe(object oPC, object oItem, int iRecipe);


// =============================================================
// GLOBAL CONSTANTS
// =============================================================

// FIRST TIER TRADESKILLS
int RTS_SKILL_FARMING      = 1;
int RTS_SKILL_FISHING      = 2;
int RTS_SKILL_SKINNING     = 3;
int RTS_SKILL_MINING_ORE   = 4;
int RTS_SKILL_MINING_GEMS  = 5;
int RTS_SKILL_LUMBERING    = 6;
int RTS_SKILL_HERBALISM    = 7;

// SECOND TIER TRADESKILLS
int RTS_SKILL_COOKING      = 10;
int RTS_SKILL_LEATHERCRAFT = 11;
int RTS_SKILL_WEAPONCRAFT  = 12;
int RTS_SKILL_ARMORCRAFT   = 13;
int RTS_SKILL_JEWELCRAFT   = 14;
int RTS_SKILL_WOODCRAFT    = 15;
int RTS_SKILL_ALCHEMY      = 16;

// NOTE: If you add/change Tradeskills above, you will also need to adjust the function
//		 RTS_GetSkillName(int iSkill)    further below in this script to include your
//		 new/changed Tradeskills.

int RTS_COMPONENT_STATION  = 1;
int RTS_COMPONENT_TOOL     = 2;
int RTS_COMPONENT_RESOURCE = 3;

string strRTSerror;



// =============================================================
// TRADESKILL FUNCTIONS
// =============================================================

void RTS_ModuleInit_SQLite() {
  string sSQL;
  
  // CHECK RECIPE TABLE
  WriteTimestampedLogEntry("-- Checking Table_RTS_Recipe");
  sSQL = "RecipeID int," +
         "RecipeName varchar(32)," + 
         "SkillID int," + 
         "SkillLevel int," + 
         "ItemTag varchar(32)," + 
         "ItemName varchar(32)," + 
         "ItemQty varchar(3)," + 
         "XPreward int";
  if (DBTableExists("Table_RTS_Recipe", sSQL)) { 
    // DO NOTHING 
  }

  // CHECK RECIPE COMPONENT TABLE
  WriteTimestampedLogEntry("-- Checking Table_RTS_Component");
  sSQL = "ComponentID int," +
         "ComponentType int," + 
         "RecipeID int," + 
         "ItemTag varchar(32)," + 
         "ItemName varchar(32)," + 
         "ItemQty int";
  if (DBTableExists("Table_RTS_Component", sSQL)) { 
    // DO NOTHING 
  }
				
  // CHECK CHARACTER RECIPE BOOK TABLE
  WriteTimestampedLogEntry("-- Checking Table_RTS_Book");
  sSQL = "RecipeBookID int," +
         "CharacterID int," + 
         "RecipeID int";
  if (DBTableExists("Table_RTS_Book", sSQL)) { 
    // DO NOTHING 
  }

  // CHECK CHARACTER TRADESKILL XP TABLE
  WriteTimestampedLogEntry("-- Checking Table_RTS_XP");
  sSQL = "RTSXPID int," +
         "CharacterID int," + 
         "SkillID int," +
		 "Level int," +
         "XP int";
  if (DBTableExists("Table_RTS_XP", sSQL)) { 
    // DO NOTHING 
  }

}

void RTS_ModuleInit_MySQL() {
  string sSQL;

  // CHECK RECIPE TABLE
  WriteTimestampedLogEntry("-- Checking Table_RTS_Recipe");
  sSQL = "RecipeID int NOT NULL," +
         "RecipeName varchar(32) default NULL," + 
         "SkillID int default 0," + 
         "SkillLevel int default 0," + 
         "ItemTag varchar(32) default NULL," + 
         "ItemName varchar(32) default NULL," + 
         "ItemQty varchar(3) default NULL," + 
         "XPreward int default 0," +
		 "PRIMARY KEY (RecipeID)";
  if (DBTableExists("Table_RTS_Recipe", sSQL)) { 
    // DO NOTHING 
  }

  // CHECK RECIPE COMPONENT TABLE
  WriteTimestampedLogEntry("-- Checking Table_RTS_Component");
  sSQL = "ComponentID int NOT NULL," +
         "ComponentType int default 0," + 
         "RecipeID int default 0," + 
         "ItemTag varchar(32) default NULL," + 
         "ItemName varchar(32) default NULL," + 
         "ItemQty int default 0," +
		 "PRIMARY KEY (ComponentID)";
  if (DBTableExists("Table_RTS_Component", sSQL)) { 
    // DO NOTHING 
  }
				
  // CHECK CHARACTER RECIPE BOOK TABLE
  WriteTimestampedLogEntry("-- Checking Table_RTS_Book");
  sSQL = "RecipeBookID int NOT NULL," +
         "CharacterID int default 0," + 
         "RecipeID int default 0," +
		 "PRIMARY KEY (RecipeBookID)";
  if (DBTableExists("Table_RTS_Book", sSQL)) { 
    // DO NOTHING 
  }

  // CHECK CHARACTER TRADESKILL XP TABLE
  WriteTimestampedLogEntry("-- Checking Table_RTS_XP");
  sSQL = "RTSXPID int NOT NULL," +
         "CharacterID int default 0," + 
         "SkillID int default 0," +
		 "Level int default 0," +
         "XP int default 0," +
		 "PRIMARY KEY (RTSXPID)";
  if (DBTableExists("Table_RTS_XP", sSQL)) { 
    // DO NOTHING 
  }

}

void RTS_ModuleInitTradeskills() {
  
  // ABORT IF THE DATABASE IS OFFLINE
  if (gDatabaseType < DATABASE_TYPE_NWNX)
	iRTSactiveSystem = FALSE;
	
  // ABORT IF THE TRADESKILL SYSTEM IS NOT ACTIVE
  if (iRTSactiveSystem == FALSE)
	return;

  // CHECK TO MAKE SURE THE TRADESKILL TABLES EXIST
  // CREATE THE TABLES IF THEY DO NOT EXIST
  if (gDatabaseFormat == DATABASE_FORMAT_SQLITE)
  	RTS_ModuleInit_SQLite();
  if (gDatabaseFormat == DATABASE_FORMAT_MYSQL)
  	RTS_ModuleInit_MySQL();

}


int RTS_GetLevel(object oPC, int iSkill) {
  string sSQL;
  int    iCID;
  int    i = 0;
      
  // NON-PLAYERS DON'T GET A PLAYERID
  if ((!GetIsPC(oPC) && !GetIsDM(oPC)) || iRTSactiveSystem == FALSE) 
	return 1;
  
  // GET THE CHARACTER ID
  iCID = GetCharacterID(oPC);
  
  // LOAD THE CHARACTER'S TRADESKILL LEVEL AND XP
  if (GetLocalInt(oPC, "RTS_"+IntToString(iSkill)+"_Level") > 0) {
    i = GetLocalInt(oPC, "RTS_"+IntToString(iSkill)+"_Level");
  } else {
    if (DBRecordExists("Table_RTS_XP", "CharacterID=" + IntToString(iCID) + " AND SkillID=" + IntToString(iSkill)) == TRUE) {
	  i = DBReadInt("Table_RTS_XP", "XP", "CharacterID=" + IntToString(iCID) + " AND SkillID=" + IntToString(iSkill));
	  SetLocalInt(oPC, "RTS_"+IntToString(iSkill)+"_XP", i);	  
	  i = DBReadInt("Table_RTS_XP", "Level", "CharacterID=" + IntToString(iCID) + " AND SkillID=" + IntToString(iSkill));
	} else {
	  i = DBAddRecord("Table_RTS_XP", "CharacterID,SkillID,XP,Level", IntToString(iCID)+","+IntToString(iSkill)+",0,1", "RTSXPID", "CharacterID=" + IntToString(iCID) + " AND SkillID=" + IntToString(iSkill));
	  SetLocalInt(oPC, "RTS_"+IntToString(iSkill)+"_XP", 0);	  
	  i = 1;
	}
	SetLocalInt(oPC, "RTS_"+IntToString(iSkill)+"_Level", i);
  }
  
  return i;

}


int RTS_GetXP(object oPC, int iSkill) {
  string sSQL;
  int    iCID;
  int    i = 0;
      
  // NON-PLAYERS DON'T GET HAVE TRADESKILLS
  if ((!GetIsPC(oPC) && !GetIsDM(oPC)) || iRTSactiveSystem == FALSE) 
	return 0;
  
  // GET THE CHARACTER ID
  iCID = GetCharacterID(oPC);
  
  // LOAD THE CHARACTER'S TRADESKILL LEVEL AND XP
  if (GetLocalInt(oPC, "RTS_"+IntToString(iSkill)+"_XP") > 0) {
    i = GetLocalInt(oPC, "RTS_"+IntToString(iSkill)+"_XP");
  } else {
    if (DBRecordExists("Table_RTS_XP", "CharacterID=" + IntToString(iCID) + " AND SkillID=" + IntToString(iSkill)) == TRUE) {
	  i = DBReadInt("Table_RTS_XP", "Level", "CharacterID=" + IntToString(iCID) + " AND SkillID=" + IntToString(iSkill));
	  SetLocalInt(oPC, "RTS_"+IntToString(iSkill)+"_Level", i);	  
	  i = DBReadInt("Table_RTS_XP", "XP", "CharacterID=" + IntToString(iCID) + " AND SkillID=" + IntToString(iSkill));
	} else {
	  i = DBAddRecord("Table_RTS_XP", "CharacterID,SkillID,XP,Level", IntToString(iCID)+","+IntToString(iSkill)+",0,1", "RTSXPID", "CharacterID=" + IntToString(iCID) + " AND SkillID=" + IntToString(iSkill));
	  SetLocalInt(oPC, "RTS_"+IntToString(iSkill)+"_Level", 1);	  
	  i = 1;
	}
	SetLocalInt(oPC, "RTS_"+IntToString(iSkill)+"_XP", i);
  }
  
  return i;

}


string RTS_GetSkillName(int iSkill) {
  string sName;
  
  sName = "Unknown Skill";
  
  switch (iSkill) {
	case 1:
	  sName = "Farming";
	  break;
	case 2:
	  sName = "Fishing";
	  break;
	case 3:
	  sName = "Skinning";
	  break;
	case 4:
	  sName = "Ore Mining";
	  break;
	case 5:
	  sName = "Gem Mining";
	  break;
	case 6:
	  sName = "Lumbering";
	  break;
	case 7:
	  sName = "Herbalism";
	  break;

	case 10:
	  sName = "Cooking";
	  break;
	case 11:
	  sName = "Leatherworking";
	  break;
	case 12:
	  sName = "Weaponsmithing";
	  break;
	case 13:
	  sName = "Armorsmithing";
	  break;
	case 14:
	  sName = "Jewelcrafting";
	  break;
	case 15:
	  sName = "Carpentry";
	  break;
	case 16:
	  sName = "Alchemy";
	  break;

  }
  
  return sName;
			
}


int RTS_CalcLevel(object oPC, int iSkill, int iXP) {
  int nHD    = 1;
  int tHD    = 1;
  int iLevel = 20;
  int nMin   = (((nHD * (nHD - 1)) / 2) * 1000) ;

  while (nMin < iXP && nHD < iLevel) {
    tHD = nHD + 1;
    nMin = (((tHD * (tHD - 1)) / 2) * 1000);
    if (nMin < iXP) {
      nHD++;
    }
  }
  if (nHD > iLevel) nHD = iLevel;
  if (nHD < 1)  nHD = 1;

  SetLocalInt(oPC, "RTS_"+IntToString(iSkill)+"_Level", nHD);

  return nHD;
}


void RTS_AdjustXP(object oPC, int iSkill, int iAdjust, int iRLevel) {
  string sSQL;
  string sName;
  float	 fAdjust;
  int    iCID   = GetCharacterID(oPC);
  int    iXP    = RTS_GetXP(oPC, iSkill);
  int    iLevel = RTS_GetLevel(oPC, iSkill);
  int    i;
  
  // NON-PLAYERS DON'T GET HAVE TRADESKILLS
  if ((!GetIsPC(oPC) && !GetIsDM(oPC)) || iRTSactiveSystem == FALSE)
	return;

  // VALIDATE THE LEVELS - AVOID DIVIDE BY ZERO ERRORS
  if (iLevel < 1)
  	iLevel = 1;
  if (iRLevel < 1)
  	iRLevel = 1;

  // DOES THE PLAYER GET TRADESKILL XP FOR THIS RECIPE?
  if (iRLevel < iLevel - iRTSrewardRange) {
	iAdjust = 0;
  	FloatingTextStringOnCreature("This Recipe is Trivial for you now!", oPC, FALSE);
	return;
  }
      
  // USE DEFAULT XP CALCULATION?
  if (iAdjust == 0) {
  	// USE DEFAULT FORMULA FOR XP AWARD
	fAdjust = IntToFloat(iRLevel) / IntToFloat(iLevel);
	fAdjust = fAdjust * IntToFloat(iRTSrewardBaseXP);
	iAdjust = FloatToInt(fAdjust);
  } else {
  	// USE CUSTOM XP FOR XP AWARD
	fAdjust = IntToFloat(iRLevel) / IntToFloat(iLevel);
	fAdjust = fAdjust * IntToFloat(iAdjust);
	iAdjust = FloatToInt(fAdjust);	
  }
  iAdjust = iAdjust + ((iRLevel / 2) + (iLevel / 2));
  
  
  // MAKE THE ADJUSTMENT
  sName = RTS_GetSkillName(iSkill);
  iXP = iXP + iAdjust;
  SetLocalInt(oPC, "RTS_"+IntToString(iSkill)+"_XP", iXP);
  FloatingTextStringOnCreature("You gain " + IntToString(iAdjust) + "xp in " + sName + ".", oPC, FALSE);
  
  // CHECK IF THE CHARACTER LEVELED IN THIS TRADESKILL
  i = RTS_CalcLevel(oPC, iSkill, iXP);
  if (i > iLevel) {
  	FloatingTextStringOnCreature("You have gained a Level in " + sName + "!", oPC, FALSE);
	SetLocalInt(oPC, "RTS_"+IntToString(iSkill)+"_Gained", 1);
  }
  iLevel = i;
  
  // SAVE THE ADJUSTMENT
  sSQL = "SET XP=" + IntToString(iXP) + ",Level=" + IntToString(iLevel);
  DBSQLCmd("UPDATE " + gTable_Prefix + "Table_RTS_XP " + sSQL + " WHERE CharacterID=" + IntToString(iCID) + " AND SkillID=" + IntToString(iSkill));
	
}


int RTS_CanUseRecipe(object oPC, int iSkill, int iRecipe) {
  string sSQL;
  int    iCID;
  int    iLevel;
  int    iRLevel;
  
  // NON-PLAYERS DON'T GET A PLAYERID
  if ((!GetIsPC(oPC) && !GetIsDM(oPC)) || iRTSactiveSystem == FALSE)
	return FALSE;

  // CHECK IF WE'VE PRE-LOADED THIS RECIPE FOR THE CHARACTER  ( 1=False, 2=True)
  if (GetLocalInt(oPC,  "RTS_" + IntToString(iSkill)  + "_Gained") == 1)
  	DeleteLocalInt(oPC, "RTS_" + IntToString(iRecipe) + "_Recipe");
  if (GetLocalInt(oPC,  "RTS_" + IntToString(iRecipe) + "_Recipe") == 1)
  	return FALSE;
  if (GetLocalInt(oPC,  "RTS_" + IntToString(iRecipe) + "_Recipe") >  1)
	return TRUE;
	
  // GET THE CHARACTER ID
  iCID = GetCharacterID(oPC);
  
  // CHECK IF THE CHARACTER HAS THE RECIPE IN THEIR RECIPE BOOK
  if (DBRecordExists("Table_RTS_Book", "CharacterID=" + IntToString(iCID) + " AND RecipeID=" + IntToString(iRecipe)) == TRUE) {
  	SetLocalInt(oPC, "RTS_" + IntToString(iRecipe) + "_Recipe", 2);
  } else {
  	SetLocalInt(oPC, "RTS_" + IntToString(iRecipe) + "_Recipe", 1);
	return FALSE;    
  }
  
  // CHECK LEVEL REQUIREMENTS
  iLevel  = RTS_GetLevel(oPC, iSkill);
  iRLevel = DBReadInt("Table_RTS_Recipe", "SkillLevel", "RecipeID=" + IntToString(iRecipe) + " AND SkillID=" + IntToString(iSkill));

  if (iLevel < iRLevel) {
  	SetLocalInt(oPC, "RTS_" + IntToString(iRecipe) + "_Recipe", 1);
	return FALSE;    
  } else {
  	SetLocalInt(oPC, "RTS_" + IntToString(iRecipe) + "_Recipe", 2);
  }  	  
  
  return TRUE;
  
}


void RTS_AcquireRecipe(object oPC, object oItem, int iRecipe) {
  string sSQL;
  int    iCID;
  int    iLevel;
  int    iRLevel;
  int    iSkill;
  
  // NON-PLAYERS DON'T GET A PLAYERID
  if ((!GetIsPC(oPC) && !GetIsDM(oPC)) || iRTSactiveSystem == FALSE) 
	return;

  // GET THE CHARACTER ID
  iCID = GetCharacterID(oPC);

  // ABORT IF CHARACTER HAS THE RECIPE
  if (DBRecordExists("Table_RTS_Book", "CharacterID=" + IntToString(iCID) + " AND RecipeID=" + IntToString(iRecipe)) == TRUE) {
  	FloatingTextStringOnCreature("You already know this recipe.", oPC, FALSE);
  	return;
  }
  
  // ABORT IF THE CHARACTER IS TOO LOW A SKILL LEVEL TO LEARN
  iRLevel = DBReadInt("Table_RTS_Recipe", "SkillLevel", "RecipeID=" + IntToString(iRecipe));
  iSkill  = DBReadInt("Table_RTS_Recipe", "SkillID",    "RecipeID=" + IntToString(iRecipe));
  iLevel  = RTS_GetLevel(oPC, iSkill);
  if (iLevel < iRLevel) {
	FloatingTextStringOnCreature("You are too unskilled to learn this recipe.", oPC, FALSE);
  	return;
  }  
  

  // RESET LOCAL VARIABLE
  DeleteLocalInt(oPC, "RTS_" + IntToString(iRecipe) + "_Recipe");
  
  // SAVE RECIPE TO CHARACTER'S RECIPE BOOK
  iSkill = DBAddRecord("Table_RTS_Book", "CharacterID,RecipeID", IntToString(iCID)+","+IntToString(iRecipe), "RecipeBookID", "CharacterID=" + IntToString(iCID) + " AND RecipeID=" + IntToString(iRecipe));
  SetLocalInt(oPC, "RTS_" + IntToString(iRecipe) + "_Recipe", 2);
  
  // DESTROY THE RECIPE ITEM
  FloatingTextStringOnCreature("You have successfully learned " + GetName(oItem) + ".", oPC, FALSE);
  if (iRTSdestroyRecipe) {
  	SetPlotFlag(oItem, FALSE);
  	DestroyObject(oItem);
  }
  
}

void RTS_Gather(object oSelf, object oPC) {
  int    iCID;
  int    iSkill = GetLocalInt(oSelf, "RTS_SKILL");
  int    iLevel = GetLocalInt(oSelf, "RTS_LEVEL");
  string sTool  = GetLocalString(oSelf, "RTS_TOOL");
  string sRes   = GetLocalString(oSelf, "RTS_RESOURCE");
  string sName  = RTS_GetSkillName(iSkill);
  string sID    = GetPCPlayerName(oPC) + GetName(oPC) + "oRRG";
  object oTemp;
  int    iPlevel;
  int    iAnimation = 0;
  int    i;
  
  if (oPC == OBJECT_INVALID)
	oPC = GetLastUsedBy();

  // NON-PLAYERS CANNOT GATHER RESOURCES
  if ((!GetIsPC(oPC) && !GetIsDM(oPC)) || iRTSactiveSystem == FALSE) 
	return;
	
  // GET THE CHARACTER ID
  iCID = GetCharacterID(oPC);
	
  // MAKE SURE THE PLAYER HAS THE PROPER TOOL TO GATHER RESOURCES
  if (sTool != "" && GetTrackedItemPossessedBy(oPC, sTool) == OBJECT_INVALID) {
	FloatingTextStringOnCreature("You do not have the proper tool to gather this resource.", oPC, FALSE);
  	return;
  }
  
  // MAKE SURE THE PLAYER HAS THE PROPER SKILL AND LEVEL
  iPlevel = RTS_GetLevel(oPC, iSkill);
  if (iPlevel >= iLevel && sName != "Unknown Skill") {
  
    // FOR THE SKILLS BELOW, NEED TO ANIMATE AN ATTACK FOR THE WORK ANIMATION
    if (iSkill == RTS_SKILL_MINING_ORE   ||
  	    iSkill == RTS_SKILL_MINING_GEMS  ||
	    iSkill == RTS_SKILL_LUMBERING    ||
 	    iSkill == RTS_SKILL_WEAPONCRAFT  ||
	    iSkill == RTS_SKILL_ARMORCRAFT   ||
	    iSkill == RTS_SKILL_WOODCRAFT)
	  AssignCommand(oPC, ActionAttack(oSelf, TRUE));

	// OTHERWISE, ANIMATE THE CHARACTER WHILE HE/SHE GATHERS THE RESOURCES
	if (iSkill == RTS_SKILL_FISHING)   iAnimation = ANIMATION_LOOPING_GET_MID;
	if (iSkill == RTS_SKILL_COOKING)   iAnimation = ANIMATION_LOOPING_COOK01;
	
	if (iSkill == RTS_SKILL_SKINNING     ||
	    iSkill == RTS_SKILL_HERBALISM) iAnimation = ANIMATION_LOOPING_GET_LOW;
		
	if (iSkill == RTS_SKILL_FARMING  ) iAnimation = ANIMATION_LOOPING_SHOVELING;
		
	if (iSkill == RTS_SKILL_LEATHERCRAFT ||
	    iSkill == RTS_SKILL_JEWELCRAFT   ||
	    iSkill == RTS_SKILL_ALCHEMY)   iAnimation = ANIMATION_LOOPING_CRAFT01;
	if (iAnimation > 0)
		AssignCommand(oPC, ActionPlayAnimation(iAnimation, 1.0, 5.0));
	AssignCommand(oPC, DelayCommand(3.0, ClearAllActions(TRUE)));
		
	// CREATE THE OBJECT IN FRONT OF THE CHARACTER
	iPlevel = (iPlevel - iLevel) + 1;
	if (iPlevel > 5)
		iPlevel = 5;
	for (i=1; i<=iPlevel; i++) {
	  oTemp = CreateObject(OBJECT_TYPE_ITEM, sRes, GetLocation(oPC), FALSE, sRes);
	}

	// AWARD THE CHARACTER WITH SKILL XP
	FloatingTextStringOnCreature("You have gathered " + IntToString(iPlevel) + " " + GetName(oTemp) + "s.", oPC, FALSE);
	RTS_AdjustXP(oPC, iSkill, 5, iLevel);
	SetLocalInt(oSelf, sID, 1);
	
  }

}


int RTS_GetItemPossessedBy(object oPC, string sTag, int iQty, int iMarkForDelete) {
  object oTemp;
  int    i;
  int    iCount = 0;
  
  oTemp = GetFirstItemInInventory(oPC);
  while (oTemp != OBJECT_INVALID && iCount < iQty) {
    if ((GetTag(oTemp) == sTag || GetStringLeft(GetTag(oTemp), GetStringLength(sTag)) == sTag) && GetLocalInt(oTemp, "RTS_MAKE_HOLD") != 1) {
	  i = GetNumStackedItems(oTemp);
	  if (i < 1)
	  	i = 1;
	  iCount = iCount + i;
	  if (iMarkForDelete)
	  	SetLocalInt(oTemp, "RTS_MAKE_HOLD", 1);	
	}
    oTemp = GetNextItemInInventory(oPC);
  }
    
  return iCount;
}


void RTS_UseRecipe(object oPC, object oItem, int iRecipe) {
  int    iCID;
  int    iSkill;
  int    iCount;
  int    iTotal;
  int    iClearToCreate = TRUE;
  int    iXP = 0;
  int    iLevel = 0;
  int    i;
  object oTemp;
  string sSQL;
  string sArray;
  string sTag;
  string sName;
  
  
  // NON-PLAYERS CANNOT USE RECIPES
  if ((!GetIsPC(oPC) && !GetIsDM(oPC)) || iRTSactiveSystem == FALSE) 
	return;

  // CAN THE CHARACTER USE THIS RECIPE?
  strRTSerror = "";
  iCID   = GetCharacterID(oPC);
  iSkill = DBReadInt("Table_RTS_Recipe", "SkillID",    "RecipeID=" + IntToString(iRecipe));
  iXP    = DBReadInt("Table_RTS_Recipe", "XPreward",   "RecipeID=" + IntToString(iRecipe));
  iLevel = DBReadInt("Table_RTS_Recipe", "SkillLevel", "RecipeID=" + IntToString(iRecipe));
  if (RTS_CanUseRecipe(oPC, iSkill, iRecipe) == FALSE) 
	return;
	
  // CHECK FOR CORRECT STATION - (IF NEEDED)
  sTag  = DBReadString("Table_RTS_Component", "ItemTag",  "RecipeID=" + IntToString(iRecipe) + " AND ComponentType=" + IntToString(RTS_COMPONENT_STATION));
  sName = DBReadString("Table_RTS_Component", "ItemName", "RecipeID=" + IntToString(iRecipe) + " AND ComponentType=" + IntToString(RTS_COMPONENT_STATION));
  if (sTag != "" && GetObjectType(oItem) != OBJECT_TYPE_PLACEABLE) {
	oItem = GetNearestObjectByTag(sTag, oPC);
	if (GetDistanceBetween(oPC, oItem) > 7.0) {
		FloatingTextStringOnCreature("You need to be closer to a " + sName + " Crafting Station.", oPC, FALSE);
		oItem = OBJECT_INVALID;
		return;
	}
  }
  if (sTag != "" && sTag != GetStringLowerCase(GetStringLeft(GetTag(oItem), GetStringLength(sTag)   ) ))
  	return;  

	
  // CHECK FOR CORRECT TOOLS - (IF NEEDED)
  sSQL = "SELECT ItemTag,ItemName,ItemQty FROM " + gTable_Prefix + "Table_RTS_Component WHERE RecipeID=" + IntToString(iRecipe) + " AND ComponentType=" + IntToString(RTS_COMPONENT_TOOL);
  if (iClearToCreate)
	DBOpen(sSQL);
  while (SQLFetch() == SQL_SUCCESS && iClearToCreate == TRUE) {
    sTag  = SQLDecode(SQLGetData(1));
	sName = SQLDecode(SQLGetData(2));
	i     = StringToInt(SQLGetData(3));

	iTotal = RTS_GetItemPossessedBy(oPC, sTag, i, FALSE);
	if (iTotal < i) {
	  strRTSerror = strRTSerror + IntToString(i - iTotal) + " " + sName + ", ";
	  iClearToCreate = FALSE;
	}
  }
  

  // CHECK FOR THE CORRECT RESOURCES (AND QUANTITIES)
  iCount = 0;
  sSQL = "SELECT ItemTag,ItemName,ItemQty FROM " + gTable_Prefix + "Table_RTS_Component WHERE RecipeID=" + IntToString(iRecipe) + " AND ComponentType=" + IntToString(RTS_COMPONENT_RESOURCE);
  if (iClearToCreate)
  	DBOpen(sSQL);
  while (SQLFetch() == SQL_SUCCESS) {
    iCount++;
    sTag  = SQLDecode(SQLGetData(1));
	sName = SQLDecode(SQLGetData(2));
	i     = StringToInt(SQLGetData(3));
	iTotal = RTS_GetItemPossessedBy(oPC, sTag, i, TRUE);
	if (iTotal < i) {
	  strRTSerror = strRTSerror + IntToString(i - iTotal) + " " + sName + ", ";
	  iClearToCreate = FALSE;
	}
  }

  // ABORT IF THE PROPER RESOURCES ARE NOT PRESENT
  i = 0;
  if (iClearToCreate == FALSE) {
  	if (strRTSerror != "")
		strRTSerror = GetStringLeft(strRTSerror, GetStringLength(strRTSerror)-2);
  	FloatingTextStringOnCreature("You are missing " + strRTSerror + " for this recipe.", oPC, FALSE);
    oTemp = GetFirstItemInInventory(oPC);
    while (oTemp != OBJECT_INVALID && i < iCount) {
      if (GetLocalInt(oTemp, "RTS_MAKE_HOLD") == 1) {
		i++;
	  	DeleteLocalInt(oTemp, "RTS_MAKE_HOLD");	
   	  }
      oTemp = GetNextItemInInventory(oPC);
    }
  	return;
  }

  // CHARACTER HAS ALL THE NECESSARY OBJECTS
  // CREATE THE OBJECT IN FRONT OF THE CHARACTER
  sTag  = DBReadString("Table_RTS_Recipe", "ItemTag", "RecipeID=" + IntToString(iRecipe));	  
  oTemp = CreateObject(OBJECT_TYPE_ITEM, sTag, GetLocation(oPC), FALSE, sTag);
  FloatingTextStringOnCreature("You have created a " + GetName(oTemp) + ".", oPC, FALSE);

  // AWARD THE CHARACTER WITH SKILL XP
  RTS_AdjustXP(oPC, iSkill, iXP, iLevel);

  // DESTROY THE RESOURCE MATERIALS
  i = 0;
  oTemp = GetFirstItemInInventory(oPC);
  while (oTemp != OBJECT_INVALID && i < iCount) {
    if (GetLocalInt(oTemp, "RTS_MAKE_HOLD") == 1) {
	  i++;
	  SetPlotFlag(oTemp, FALSE);
	  DestroyObject(oTemp);
	}
    oTemp = GetNextItemInInventory(oPC);
  }

  
}