// =============================================================
//
//    File: row_rbs_vault_close
//    Desc: Rowell's Banking System - Persistent Vault - 
//									  Close Event
//  Author: Michael Marzilli
//    Site: http://www.engliton.org
//
// Created: Jan 12, 2007
// Updated: Jan 22, 2007
// Version: 1.0.0
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


void main() {
  object oPC    = GetLastClosedBy();
  object oChest = OBJECT_SELF;
  object oObj;

  // CHECK IF PERSISTENT CONTAINERS ARE ACTIVE
  if (gDatabaseType < DATABASE_TYPE_NWNX)
    return;

  // SAVE CHARACTER'S UPDATED INVENTORY
  ExportSingleCharacter(oPC);

  // RE-LOCK CONTAINER (IF NECESSARY)
  SetLocked(oChest, FALSE);
  DeleteLocalInt(oChest, "LAST_OPENER");
  DeleteLocalString(oChest, "IS_OPEN");
  DeleteLocalObject(oChest, "LAST_OPENER_OBJ");
  if (GetLockKeyRequired(oChest))
    SetLocked(oChest, TRUE);

  // REMOVE THE CONTENTS OF THE CONTAINER
  oObj = GetFirstItemInInventory(oChest);
  while (GetIsObjectValid(oObj)) {
    DestroyObject(oObj);
    oObj = GetNextItemInInventory(oChest);
  }
	
}