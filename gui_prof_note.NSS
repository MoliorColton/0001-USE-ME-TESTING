#include "nw_i0_spells"   
// include the base spell file 
#include "profession_include" 
// include profession specific functions
// Forward declaration of NoteExecute function
void NoteExecute(object oPC);
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

void NoteInitiate(object oPC, string sINPUT)
{
// Get the object selected by the player
object oITEM = GetPlayerCurrentTarget(oPC);
// Get the object type of the selected item
int nObjectType = GetObjectType(oITEM);

// Check if the selected item is a creature
if (nObjectType == OBJECT_TYPE_CREATURE)
{
    // Send a funny message to the player
    SendMessageToPC(oPC, "Much to our dismay, the bank cannot legally keep a living creature in the vaults.");
    // Return or perform any other action you want
	NoteResetButtons(oPC);
	return;
}




    string sTXT;

    if (GetItemPossessor(oITEM) != oPC)
    {
        sTXT = "You may only note items in your inventory (select by targeting item with right click).";
        SendMessageToPC(oPC, sTXT);
        // Disable the "noting" buttons during the cooldown
        NoteResetButtons(oPC);
        return;
    }

    // Check if the player is in a trade window
    if (GetLocalInt(oPC, "TRADE_WINDOW_OPEN") == TRUE)
    {
        SendMessageToPC(oPC, "You cannot note items while in a trade window.");
        // Disable the "noting" buttons during the cooldown
        NoteResetButtons(oPC);
        return;
    }

    // Check if the item is stackable
    int stackSize = GetItemStackSize(oITEM);
    if (stackSize > 1)
    {
        SendMessageToPC(oPC, "Stackable items cannot be noted.");
        // Disable the "noting" buttons during the cooldown
        NoteResetButtons(oPC);
        return;
    }
    
    // check if oITEM is valid / plot or not, we won't alch plot items for obvious reason
    if (GetPlotFlag(oITEM))
    {   
        sTXT = "This item is important and cannot be Noted.";
        SendMessageToPC(oPC, sTXT);
        NoteResetButtons(oPC);
        return;
    }
	    if (GetItemCursedFlag(oITEM))
    {
        // Item is cursed
        SendMessageToPC(oPC, "This item is important and cannot be Noted.");
		 NoteResetButtons(oPC);
        return;
    }

    // Get the tag of the item
    string sITEM_TAG = GetTag(oITEM);
    // store the tag for later use
    SetLocalString(oPC, "ITEM_TAG", sITEM_TAG);
    int nINPUT = StringToInt(sINPUT);

    // create the string that shows the cost of the enchanting
    string sCOST = IntToString(nINPUT);

    // initiate the "note" action directly without prompting for confirmation
    NoteExecute(oPC);
}

void NoteExecute(object oPC)
{
    // Set the noting in progress
    SetLocalInt(oPC, "NOTING_IN_PROGRESS", TRUE);
    DelayCommand(1.6f, SetLocalInt(oPC, "NOTING_IN_PROGRESS", FALSE));
    
    // get the type of enchanting process
    int nTYPE = GetLocalInt(oPC, "RUNE_UI");

    // check if the process is for enchanting
    if (nTYPE == 2)
    {
        // check if player's inventory is full
        if (GetInventoryNum(oPC) >= 128)
        {
            SendMessageToPC(oPC, "You must have at least one free inventory space to note this item.");
			NoteResetButtons(oPC);
            return;
        }
        
        // get the name and quantity of the rune needed
        string sCOST = GetLocalString(oPC, "ITEM_TAG");
        int nINPUT = GetLocalInt(oPC, "ENCHANT_RUNEA_QTY");

        // get the item that the player wants to enchant
        object oINPUT = GetLocalObject(oPC, "ENCHANT_INPUT");

        // check if the player has the required items to enchant
        if (GetItemQuantity(oPC, sCOST) < 1) 
        {
            SendMessageToPC(oPC, "You do not have the required items to note.");
            NoteResetButtons(oPC);
			return;
        }

        {
            string sOUTPUT = "noted" + sCOST; // the tag of the item plus noted
            // create the noted item in the player's inventory
            CreateItemOnObject(sOUTPUT, oPC);

            // check if the created item is valid 
            object oOUTPUT = GetItemPossessedBy(oPC, sOUTPUT);
            if (!GetIsObjectValid(oOUTPUT))
            {
                SendMessageToPC(oPC, "This item cannot be noted");
                // Disable the "noting" buttons during the cooldown
                NoteResetButtons(oPC);
				return;
            }
            else
            {
                // remove the used items from the player's inventory
                RemoveItems(oPC, sCOST, nINPUT);

                // Re-enable the "noting" buttons
				NoteResetButtons(oPC);
            }
        }        
    }
}

// main function that handles the command input
void main(string sCOMMAND, string sINPUT)
{
    object oPC = OBJECT_SELF;
    // check if the command input is for enchanting
    if (sCOMMAND == "ENCHANT") NoteInitiate(oPC, sINPUT);
    else NoteExecute(oPC);
}