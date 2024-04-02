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
  object oPC  = GetLastOpenedBy();
  int    iCID = GetCharacterID(oPC);
  
  // CHECK IF PERSISTENT CONTAINERS ARE ACTIVE
  if (gDatabaseType < DATABASE_TYPE_NWNX) {
    SendMessageToPC(oPC, "This Container is Temporarily Disabled.");
    return;
  }

  // CHECK IF THE USER IS AN ACTUAL PERSON
  if (!GetIsPC(oPC) && !GetIsDM(oPC))
    return;
	
  // GET THE CHARACTER'S ID NUMBER
  iCID = GetCharacterID(oPC);
	
  // CHECK IF CONTAINER IS IN USE
  int    iLastOpener    = GetLocalInt(OBJECT_SELF, "LAST_OPENER");
  string sIsOpen        = GetLocalString(OBJECT_SELF, "IS_OPEN");
  object oLastOpenerObj = GetLocalObject(OBJECT_SELF, "LAST_OPENER_OBJ");

  if ((GetIsObjectValid(oLastOpenerObj) == FALSE) ||
      (iLastOpener == iCID) ||
      (GetIsOpen(OBJECT_SELF) == FALSE)) {
    SetLocalInt(OBJECT_SELF,    "LAST_OPENER", iCID);
    SetLocalString(OBJECT_SELF, "IS_OPEN", "Y");
    SetLocalObject(OBJECT_SELF, "LAST_OPENER_OBJ", oPC);
    FloatingTextStringOnCreature("This container can hold up to "+IntToString(iRBS_MaxItems)+" Items.", oPC, FALSE);
  } else {
    FloatingTextStringOnCreature("The container is already in use.", oPC, FALSE);
    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, ActionMoveAwayFromObject(OBJECT_SELF, FALSE, 3.0));
    return;
  }	
  
}