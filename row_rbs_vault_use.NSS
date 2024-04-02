// =============================================================
//
//    File: row_rbs_vault_use
//    Desc: Rowell's Banking System - Persistent Vault - 
//									  Use Event
//  Author: Michael Marzilli
//    Site: http://www.engliton.org
//
// Created: Jan 12, 2007
// Updated: Jan 22, 2007
// Version: 1.0.3
//
// NOTE: The Identity of the Vault is based in its Tag.
//       If you have two Vault Objects in your module with the
//       same Tag, when a player opens one, he will be able to
//       access the same objects that are in the other as well.
//       if you want to have two seperate storage containers,
//       each with their own seperate inventory, use a different
//       tag for each object when you place it into your module.
//
// =============================================================

#include "row_inc_banking"


object oPC       = GetLastUsedBy();
object oChest    = OBJECT_SELF;
string sChestTag = SQLEncode(GetTag(oChest));
int    iCID;

  
int RBS_VaultLoad() {
  string sSQL;
  string sItemName;
  string sItemRes;
  string sItemTag;
  string sRituals;
  int    iID;
  int    iCount;
  int    iIdentified;
  int    iCharges;
  int    iCreatorID;
  object oItem;
  object oTemp;
  int    iTotalCount = 0;
  int    i;

  // READ IN ALL ITEMS IN THE VAULT FOR THE CHARACTER		 
  sSQL = "SELECT BankVaultID,CharacterID,VaultTag,ItemName,ItemResRef,ItemTag,ItemCount,Identified,Charges,CreatorID,Rituals " +
  		 "  FROM " + gTable_Prefix + "Table_Bank_Vault " +
         "  WHERE VaultTag='" + sChestTag + "' AND CharacterID=" + IntToString(iCID);
  SQLExecDirect(sSQL);

  while (SQLFetch() == SQL_SUCCESS) {

	// READ IN THE DATABASE FIELDS
  	sItemName   = SQLDecode(SQLGetData(4));
	sItemRes    = SQLDecode(SQLGetData(5));
	sItemTag    = SQLDecode(SQLGetData(6));
	sRituals    = SQLGetData(11);
	iID         = StringToInt(SQLGetData(1));
	iCount      = StringToInt(SQLGetData(7));
	iIdentified = StringToInt(SQLGetData(8));
	iCharges    = StringToInt(SQLGetData(9));
	iCreatorID  = StringToInt(SQLGetData(10));
	
	if (iCount < 1)
	  iCount = 1;
	  
	// CREATE A TEMPORARY ITEM
	if (gEnableItemTracking == TRUE) {
	
	  // THE FUNCTION  CreateItemOnOject  IS BROKEN (FROM PATCH 1.0 to 1.3)
	  // IT DOES NOT CONTAIN AN ARGUEMENT FOR NewTag
	  // oTemp = CreateItemOnObject(sItemRes, oChest, iCount, sItemTag);

	  
	  // ITEM TRACKING IS TURNED ON, WE ARE CONCERNED ABOUT THE ITEM TAG
	  //   DO THE CODE BELOW AS A TEMPORARY FIX
	  //   WILL NOT HANDLE STACKED ITEMS
	  if ((iRBS_AllowStacks == TRUE) || (iRBS_AllowStacks == FALSE && iCount == 1)) {
	    oTemp = CreateObject(OBJECT_TYPE_ITEM, sItemRes, GetLocation(oChest), FALSE, sItemTag);
        if (oTemp != OBJECT_INVALID) {
	      iTotalCount++;
  		  if (GetItemStackSize(oItem) == 1)
	        SetLocalInt(oTemp, "RBS_BANKVAULTID", iID);
          SetLocalInt(oTemp, "OWNER", iCID);
	      SetLocalInt(oTemp, "CREATOR", iCreatorID);
          SetIdentified(oTemp,  iIdentified);
          SetItemCharges(oTemp, iCharges);
          SetLocalString(oTemp, "RITUALS", sRituals);
	  
	      // COPY THE TEMPORARY ITEM TO A NEW ITEM WITH THE PROPER TAG
		  for (i=1; i <= iCount; i++) {
		    oItem = CopyItem(oTemp, oChest, TRUE);
	  	  }
	  
	      // DESTROY THE TEMPORARY ITEM
	      SetPlotFlag(oTemp, FALSE);
	      DestroyObject(oTemp);
	
	    } else
	      FloatingTextStringOnCreature("Unable to create " + sItemName + " (" + sItemRes + ") in " + GetName(oChest) + ".", oPC, FALSE);
	  } else
	    FloatingTextStringOnCreature("Cannot create stackable item " + sItemName + " (" + sItemRes + ") in " + GetName(oChest) + ".", oPC, FALSE);
	  	
    } else {
	
	  // ITEM TRACKING IS TURNED OFF - WE DO NOT CARE ABOUT THE ITEM TAG
	  
	  // THE FUNCTION  CreateItemOnOject  IS BROKEN (FROM PATCH 1.0 to 1.3)
	  // oTemp = CreateItemOnObject(sItemRes, oChest, iCount);
	  
	  if ((iRBS_AllowStacks == TRUE) || (iRBS_AllowStacks == FALSE && iCount == 1)) {
	    // TEMPORARY FIX - THIS WILL NOT GIVE YOU STACKED ITEMS
	    // ----------------------------------------------------------
	    oTemp = CreateObject(OBJECT_TYPE_ITEM, sItemRes, GetLocation(oChest), FALSE, sItemTag);
	    // ----------------------------------------------------------
	  
        if (oTemp != OBJECT_INVALID) {
	      iTotalCount++;
  	 	  if (GetItemStackSize(oItem) == 1)
		    SetLocalInt(oTemp, "RBS_BANKVAULTID", iID);
          SetLocalInt(oTemp, "OWNER", iCID);
	      SetLocalInt(oTemp, "CREATOR", iCreatorID);
          SetIdentified(oTemp,  iIdentified);
          SetItemCharges(oTemp, iCharges);
          SetLocalString(oTemp, "RITUALS", sRituals);
		
		
	      // ----------------------------------------------------------
		  // MORE OF THE TEMPORARY FIX
		  // ----------------------------------------------------------
	      // COPY THE TEMPORARY ITEM TO A NEW ITEM WITH THE PROPER TAG
	 	  for (i=1; i <= iCount; i++) {
		    oItem = CopyItem(oTemp, oChest, TRUE);
	  	  }
		
	      // DESTROY THE TEMPORARY ITEM
	      SetPlotFlag(oTemp, FALSE);
	      DestroyObject(oTemp);
		  // ----------------------------------------------------------
		
	    } else
	      FloatingTextStringOnCreature("Unable to create " + sItemName + " (" + sItemRes + ") in " + GetName(oChest) + ".", oPC, FALSE);

	  } else
	    FloatingTextStringOnCreature("Cannot create stackable item " + sItemName + " (" + sItemRes + ") in " + GetName(oChest) + ".", oPC, FALSE);
	   
	}
  }

  return iTotalCount;
  
}

void main() {
  object oItem;
  int    iCount;

  
  // CHECK IF PERSISTENT CONTAINERS ARE ACTIVE
  if (gDatabaseType < DATABASE_TYPE_NWNX)
    return;

  // CHECK IF THE USER IS AN ACTUAL PERSON
  if (!GetIsPC(oPC) && !GetIsDM(oPC))
    return;
	
  // GET THE CHARACTER'S ID NUMBER
  iCID = GetCharacterID(oPC);

  // CHECK IF CONTAINER IS IN USE
  int    iLastOpener    = GetLocalInt(oChest, "LAST_OPENER");
  string sIsOpen        = GetLocalString(oChest, "IS_OPEN");
  object oLastOpenerObj = GetLocalObject(oChest, "LAST_OPENER_OBJ");

  // IF THE CHEST IS ALREADY IN USE (OPEN), HAVE THIS PLAYER WALK AWAY
  if (sIsOpen == "Y" && GetName(oPC) != GetName(oLastOpenerObj)) {
    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, ActionMoveAwayFromObject(oChest, FALSE, 3.0));
    return;
  }

  // REMOVE THE CONTENTS OF THE CONTAINER
  oItem = GetFirstItemInInventory(oChest);
  while (GetIsObjectValid(oItem)) {
    DestroyObject(oItem);
    oItem = GetNextItemInInventory(oChest);
  }
  
  // COUNT ITEMS IN VAULT FOR THIS CHARACTER
  iCount = RBS_VaultLoad();
  SetLocalString(oChest, "IS_OPEN", "Y");
  FloatingTextStringOnCreature("This container is holding "+IntToString(iCount)+" Unique Items.", oPC, FALSE);
	
}