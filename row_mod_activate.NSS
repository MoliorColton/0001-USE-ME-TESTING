// =============================================================
//
//    File: row_mod_activate
//    Desc: Rowell's Activate Item Script
//  Author: Michael Marzilli
//    Site: http://www.engliton.org
//
// Created: Dec 01, 2006
// Updated: Dec 01, 2006
// Version: 1.0.0
//
//   Usage: Place this script in the OnItemActivate Event in the Module
//
// =============================================================

#include "x2_inc_switches"
#include "row_inc_settings"

void main() {
     object oItem = GetItemActivated();
	 object oPC   = GetItemActivator();
	 string sTag;
     // * Generic Item Script Execution Code
     // * If MODULE_SWITCH_EXECUTE_TAGBASED_SCRIPTS is set to TRUE on the module,
     // * it will execute a script that has the same name as the item's tag
     // * inside this script you can manage scripts for all events by checking against
     // * GetUserDefinedItemEventNumber(). See x2_it_example.nss
     if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE) {
        SetUserDefinedItemEventNumber(X2_ITEM_EVENT_ACTIVATE);
		sTag = GetUserDefinedItemEventScriptName(oItem);
		if (gEnableItemTracking)
			sTag = GetStringLeft(sTag, GetStringLength(sTag) - (gIDsize + 1));
	 	SendMessageToPC(oPC, "EXEC SCRIPT: " + sTag);
        int nRet =   ExecuteScriptAndReturnInt(sTag,OBJECT_SELF);
        if (nRet == X2_EXECUTE_SCRIPT_END)
           return;

     }
		
		
	// INSERT YOUR OWN CODE BELOW
	// ===================================================================================

		

}
