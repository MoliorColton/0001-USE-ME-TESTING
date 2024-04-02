#include "nw_i0_spells"


void DoStats(object oPC, object oCONTROL)
{	
	if (GetResRef(oCONTROL) != "sfpb_storage") return;
	
	string sSCREEN = "SCREEN_INVENTORY";
	// opening the inventory hides these
	SetGUIObjectHidden(oPC, sSCREEN, "MENU_PAGES", TRUE);
	SetGUIObjectHidden(oPC, sSCREEN, "MENU_PAGES2", TRUE);
	SetGUIObjectHidden(oPC, sSCREEN, "HP_BAR1", TRUE);
	SetGUIObjectHidden(oPC, sSCREEN, "HP_BAR2", TRUE);
	SetGUIObjectHidden(oPC, sSCREEN, "HP_BAR3", TRUE);
	SetGUIObjectHidden(oPC, sSCREEN, "HP_BAR4", TRUE);
	SetGUIObjectHidden(oPC, sSCREEN, "HP_ICON", TRUE);

	// and shows these, which are normally hidden.
	SetGUIObjectHidden(oPC, sSCREEN, "BANK_BUTTON", FALSE);
	SetGUIObjectHidden(oPC, sSCREEN, "NOTE_BUTTONS", FALSE);
	SetGUIObjectHidden(oPC, sSCREEN, "WINDOW_NOTE", FALSE);
	SetGUIObjectHidden(oPC, sSCREEN, "BANK_TEXT", FALSE);
	SetGUIObjectHidden(oPC, sSCREEN, "SCREEN_BANK_HELP", FALSE);
	SetGUIObjectHidden(oPC, sSCREEN, "NOTE_TAB_IMAGE", FALSE);
	
}

void FinalizeStorageSave(object oPC, object oBANK, string sID)
{
    // Export the player character's data
    ExportSingleCharacter(oPC);
    
    // Store the contents of the bank or storage container
    int nCHECK = StoreCampaignObject("bank_items", sID, oBANK, oPC);
    
    // Check if the storage operation was successful
    if (nCHECK == 1)
    {
        // Inform the player that their bank has been closed
        SendMessageToPC(oPC, "You close your bank.");
        
        // Ensure the player character is not in a party
        RemoveRosterMemberFromParty(sID, oPC);
        
        // Remove the player character from the roster
        RemoveRosterMember(sID);
    }
    else
    {
        // If the storage operation failed, inform the player
        SendMessageToPC(oPC, "An error occurred. The item storage was not saved. Please contact the developers if you see this message. ");
    }

}


void BeginStorageSave(object oPC, object oCONTROL)
{
	string sID = GetPCPlayerName(oPC);
	object oBANK = GetObjectFromRosterName(sID);
	if (oBANK == OBJECT_INVALID) return;
	
	oPC = SetOwnersControlledCompanion(oCONTROL, oPC);
	RemoveSpecificEffect(EFFECT_TYPE_POLYMORPH, oPC);
	RemoveSpecificEffect(EFFECT_TYPE_CUTSCENEIMMOBILIZE, oPC);
	DelayCommand(0.0f, FinalizeStorageSave(oPC, oBANK, sID));
}

void SwitchInventory(object oPC, object oCONTROL)
{
	object oSWITCH = oPC;
	if (GetResRef(oCONTROL) != "sfpb_storage")
	{
		string sID = GetPCPlayerName(oPC);
		oSWITCH = GetObjectFromRosterName(sID);
	}
	object oNEW = SetOwnersControlledCompanion(oCONTROL, oSWITCH);
}

void TransferItem(object oPC, object oCONTROL)
{
	string sID = GetPCPlayerName(oPC);
	object oBANK = GetObjectFromRosterName(sID);
	if (oBANK == OBJECT_INVALID)
	{
		SendMessageToPC(oPC, "Error: Persistent chest not found.");
		return;
	}
	object oITEM = GetPlayerCurrentTarget(oCONTROL);
	if (GetItemPossessor(oITEM) != oCONTROL)
	{
		SendMessageToPC(oPC, "Error: Targeted object is not a transferable item. Right click on the item you wish to transfer.");
		return;
	}
	object oTAKE = oBANK;
	if (GetResRef(oCONTROL) == "sfpb_storage") oTAKE = GetOwnedCharacter(oCONTROL);
	AssignCommand(oCONTROL, ActionGiveItem(oITEM, oTAKE, FALSE));
}
void main(string sCOMMAND)
{
	object oPC = OBJECT_SELF;
	object oCONTROL = GetControlledCharacter(oPC);
	int nCOMMAND = StringToInt(sCOMMAND);
	switch (nCOMMAND)
	{		
		case 1: DoStats(oPC, oCONTROL); break;
		case 2: BeginStorageSave(oPC, oCONTROL); break;
		case 3: SwitchInventory(oPC, oCONTROL); break;
		case 4: TransferItem(oPC, oCONTROL); break;
	}
}