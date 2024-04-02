// =============================================================
//
//    File: row_rbs_vault_disturb
//    Desc: Rowell's Banking System - Persistent Vault - 
//									  Disturb Contents Event
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


object oPC       = GetLastDisturbed();
object oChest    = OBJECT_SELF;
string sChestTag = SQLEncode(GetTag(oChest));
int    iCID;


int RBS_VaultAddItem(object oItem) {
  string sItemName   = SQLEncode(GetName(oItem));
  string sItemRes    = SQLEncode(GetResRef(oItem));
  string sItemTag    = SQLEncode(GetTag(oItem));
  string sRituals    = "";
  int    iCount      = GetNumStackedItems(oItem);
  int    iIdentified = GetIdentified(oItem);
  int    iCharges    = GetItemCharges(oItem);
  int    iCreatorID  = 0;
  int    iDidAdd     = TRUE;
  int    iID;
  int    i;
  string strFields;
  string strValues;
  
  // VALIDATE TAG AND RESREF
  if (sItemTag == "" || sItemRes == "" || sItemName == "")
  	return 0;
	
  // VALIDATE STACK COUNT
  if (iCount < 1) 
	  iCount = 1;  

  if (DBRecordExists("Table_Bank_Vault", "VaultTag='" + sChestTag + "' AND CharacterID=" + IntToString(iCID) + " AND ItemTag='" + sItemTag + "'") == TRUE) {
  
  	// UPDATE THE ITEM COUNT IN THE DATABASE
	iID = DBReadInt("Table_Bank_Vault", "BankVaultID", "VaultTag='" + sChestTag + "' AND CharacterID=" + IntToString(iCID) + " AND ItemTag='" + sItemTag + "'");
	i   = DBReadInt("Table_Bank_Vault", "ItemCount",   "VaultTag='" + sChestTag + "' AND CharacterID=" + IntToString(iCID) + " AND ItemTag='" + sItemTag + "'");
	iCount = iCount + i;
	DBUpdateInt("Table_Bank_Vault", "ItemCount",  iCount, "BankVaultID=" + IntToString(iID));
	iDidAdd = FALSE;
	
  } else {

    // ASSIGN FIELDS AND VALUES FOR SQL STATEMENT
    strFields = "CharacterID,VaultTag,ItemName,ItemResRef,ItemTag,ItemCount,Identified,Charges,CreatorID,Rituals";
    strValues = IntToString(iCID) + ",'" + sChestTag + "','" + sItemName + "','" + sItemRes + "'," +
                "'" + sItemTag + "'," + IntToString(iCount) + "," + IntToString(iIdentified) + "," +
	  		    IntToString(iCharges) + "," + IntToString(iCreatorID) + ",'" + sRituals + "'";
								
    // ADD THE ITEM TO THE DATABASE				
  	iID = DBAddRecord("Table_Bank_Vault", strFields, strValues, "BankVaultID", "VaultTag='" + sChestTag + "' AND CharacterID=" + IntToString(iCID) + " AND ItemTag='" + sItemTag + "'");
  	SetLocalInt(oItem, "RBS_BANKVAULTID", iID);
  }
  
  // ZERO OUT VAULT ID FOR STACKABLE ITEMS
  if (GetItemStackSize(oItem) > 1)
    DeleteLocalInt(oItem, "RBS_BANKVAULTID");
	
  // UPDATE THE ITEM'S LOCATION IF ITEM TRACKING IS TURNED ON
  if (gEnableItemTracking == TRUE) {
  	i = DBReadInt("Table_Item", "ItemID", "OwnerID=" + IntToString(iCID) + " AND ItemTag='" + sItemTag + "' AND StoredIn=''");
	if (i > 0)
	  DBUpdateString("Table_Item", "StoredIn",  sChestTag, "ItemID=" + IntToString(i) + " AND OwnerID=" + IntToString(iCID));
  }
  
  return iDidAdd;
  
}

int RBS_VaultRemoveItem(object oItem) {
  string sItemTag     = SQLEncode(GetTag(oItem));
  int    iBankVaultID = GetLocalInt(oItem, "RBS_BANKVAULTID");
  int    iCount       = GetModuleItemAcquiredStackSize();
  int    i;
  
  // UPDATE THE ITEM'S LOCATION IF ITEM TRACKING IS TURNED ON
  if (gEnableItemTracking == TRUE) {
  	i = DBReadInt("Table_Item", "ItemID", "OwnerID=" + IntToString(iCID) + " AND ItemTag='" + sItemTag + "' AND StoredIn='" + sChestTag + "'");
	if (i > 0)
	  DBUpdateString("Table_Item", "StoredIn",  "", "ItemID=" + IntToString(i) + " AND OwnerID=" + IntToString(iCID));
  }

  i = DBReadInt("Table_Bank_Vault", "ItemCount", "VaultTag='" + sChestTag + "' AND CharacterID=" + IntToString(iCID) + " AND ItemTag='" + sItemTag + "'");
  if (iCount == i || i == 0) {
	// DELETE THE DATABASE RECORD
	if (iBankVaultID > 0) {
	  i = DBDeleteRecord("Table_Bank_Vault", "BankVaultID=" + IntToString(iBankVaultID));
	} else {
	  i = DBDeleteRecord("Table_Bank_Vault", "VaultTag='" + sChestTag + "' AND CharacterID=" + IntToString(iCID) + " AND ItemTag='" + sItemTag + "'");  
	}
	
  } else {
  	// UPDATE THE ITEM COUNT IN THE DATABASE
	if (iBankVaultID > 0) {
	  DBUpdateInt("Table_Bank_Vault", "ItemCount",  iCount, "BankVaultID=" + IntToString(iBankVaultID)); 
	} else {
	  DBUpdateInt("Table_Bank_Vault", "ItemCount",  iCount, "VaultTag='" + sChestTag + "' AND CharacterID=" + IntToString(iCID) + " AND ItemTag='" + sItemTag + "'"); 
	} 
	return FALSE;
  }
  
  return TRUE;
}


void main() {
  object oItem = GetInventoryDisturbItem();
  int    iItemCount;
  
  // CHECK IF PERSISTENT CONTAINERS ARE ACTIVE
  if (gDatabaseType < DATABASE_TYPE_NWNX) 
    return;

  // CHECK IF THE USER IS AN ACTUAL PERSON
  if (!GetIsPC(oPC) && !GetIsDM(oPC))
    return;
	
  // GET THE CHARACTER'S ID NUMBER
  iCID = GetCharacterID(oPC);
  
  // CHECK TO SEE IF ITEM ACTUALLY EXISTS
  if (!GetIsObjectValid(oItem))
    return;

  // COUNT NUMBER OF ITEMS THIS CHARACTER HAS IN STORAGE
  iItemCount = DBReadInt("Table_Bank_Vault", "COUNT(CharacterID)", "CharacterID=" + IntToString(iCID) + " AND VaultTag='" + sChestTag + "'");
  
  // GIVE OR TAKE ITEM FROM THE PERSON
  switch(GetInventoryDisturbType()) {
  
    case INVENTORY_DISTURB_TYPE_ADDED:	  
	  // REJECT IF THE ITEM IS A STACKABLE ITEM
	  if (iRBS_AllowStacks == FALSE && GetItemStackSize(oItem) > 1) {
        FloatingTextStringOnCreature("You cannot Store Stackable Items in this container.", oPC, FALSE);
        CopyItem(oItem, oPC, TRUE);
		SetPlotFlag(oItem, FALSE);
        DestroyObject(oItem);
        return;	  
	  }
	  // REJECT ITEM IF IT HAS NO TAG, RESREF OR NAME
	  if (GetTag(oItem) == "" || GetResRef(oItem) == "" || GetName(oItem) == "") {
        FloatingTextStringOnCreature("This Item is Invalid. (Missing Tag/ResRef/Name).", oPC, FALSE);
		DBAddError("Unable to Add Item to Bank Vault. Name=[" + GetName(oItem) + "], Tag=[" + GetTag(oItem) + "], ResRef=[" + GetResRef(oItem) + "]");
        CopyItem(oItem, oPC, TRUE);
		SetPlotFlag(oItem, FALSE);
        DestroyObject(oItem);
        return;	  
	  }
      // REJECT ITEM IF THE CONTAINER HAS MORE THAN iRBS_MaxItems ITEMS FOR THIS CHARACTER
      if (iItemCount > iRBS_MaxItems - 1) {
        FloatingTextStringOnCreature("This container is Full.", oPC, FALSE);
        CopyItem(oItem, oPC, TRUE);
		SetPlotFlag(oItem, FALSE);
        DestroyObject(oItem);
        return;
      } else {
        if (RBS_VaultAddItem(oItem))
		  iItemCount++;
        ExportSingleCharacter(oPC);
      }
      break;

    case INVENTORY_DISTURB_TYPE_REMOVED:
    case INVENTORY_DISTURB_TYPE_STOLEN:
      if (RBS_VaultRemoveItem(oItem))
		iItemCount--;
      ExportSingleCharacter(oPC);
      break;
  }

  FloatingTextStringOnCreature("This container is holding "+IntToString(iItemCount)+" Unique Items.", oPC, FALSE);
  
}