#include "nw_i0_spells"   
#include "profession_include" 


void NoteResetButtons2(object oPC)
{
    // Re-enable the "noting" buttons
    DelayCommand(3.0, SetGUIObjectDisabled(oPC, "SCREEN_INVENTORY", "noteone", FALSE));
    DelayCommand(3.0, SetGUIObjectDisabled(oPC, "SCREEN_INVENTORY", "notefive", FALSE));
    DelayCommand(3.0, SetGUIObjectDisabled(oPC, "SCREEN_INVENTORY", "noteall", FALSE));
    DelayCommand(3.0, SetGUIObjectDisabled(oPC, "SCREEN_INVENTORY", "unnoteone", FALSE));
    DelayCommand(3.0, SetGUIObjectDisabled(oPC, "SCREEN_INVENTORY", "unnotefive", FALSE));
	DelayCommand(3.0, SetGUIObjectDisabled(oPC, "SCREEN_INVENTORY", "checkfreeslots", FALSE));
}

void NoteResetButtons(object oPC)
{
    // Re-enable the "noting" buttons
    SetGUIObjectDisabled(oPC, "SCREEN_INVENTORY", "noteone", TRUE);
    SetGUIObjectDisabled(oPC, "SCREEN_INVENTORY", "notefive", TRUE);
    SetGUIObjectDisabled(oPC, "SCREEN_INVENTORY", "noteall", TRUE);
    SetGUIObjectDisabled(oPC, "SCREEN_INVENTORY", "unnoteone", TRUE);
    SetGUIObjectDisabled(oPC, "SCREEN_INVENTORY", "unnotefive", TRUE);
	SetGUIObjectDisabled(oPC, "SCREEN_INVENTORY", "checkfreeslots", TRUE);
    NoteResetButtons2(oPC);
}




// This function calculates the number of free inventory slots for a given player character
void main()
{
    	object oPC = OBJECT_SELF;
		int maxInvSize = 128;
		int currentInvSize = GetInventoryNum(oPC);
		int freeSpace = maxInvSize - currentInvSize;
		SendMessageToPC(oPC, "You have " + IntToString(freeSpace) + " free inventory spaces.");
		NoteResetButtons(oPC);
}



