#include "nw_i0_spells"   
#include "profession_include" 

void NoteInitiate(object oPC)
{
    object oITEM = GetPlayerCurrentTarget(oPC);
    string sTXT;
    if (GetItemPossessor(oITEM) != oPC)
    {
        sTXT = "You may only note items in your inventory (select by targeting item with right click).";
        SendMessageToPC(oPC, sTXT);
        return;
    }
    //get the tag of the item
    string sITEM_TAG = GetTag(oITEM);
    //store the tag for later use
    SetLocalString(oPC, "ITEM_TAG", sITEM_TAG);
    //create the string that shows the cost of the enchanting
    sTXT = "Note 10 " + GetName(oITEM) + " ?";
    //set some local variables on the player object for later use
    SetLocalObject(oPC, "ENCHANT_INPUT", oITEM);
    SetLocalInt(oPC, "ENCHANT_RUNEA_QTY", 10);
    SetLocalInt(oPC, "RUNE_UI", 2);
    //displays a message box to confirm the enchantment
    DisplayMessageBox(oPC, 0, sTXT, "gui_prof_noteten", "", TRUE);
}
void NoteExecute(object oPC)
{
    //get the type of enchanting process
    int nTYPE = GetLocalInt(oPC, "RUNE_UI");

    //check if the process is for enchanting
    if (nTYPE == 2)
    {
	   	//check if player's inventory is full
		int maxInvSize = 128;
		int currentInvSize = GetInventoryNum(oPC);
		int freeSpace = maxInvSize - currentInvSize;
		SendMessageToPC(oPC, "You have " + IntToString(freeSpace) + " free inventory spaces.");
		
        //check if player's inventory is full
        if (GetInventoryNum(oPC) >= 128)
        {
            SendMessageToPC(oPC, "Your Must have at least one free inventory space to note this item.");
            return;
        }

        //get the name and quantity of the rune needed
        string sCOST = GetLocalString(oPC, "ITEM_TAG");
        int nINPUT = GetLocalInt(oPC, "ENCHANT_RUNEA_QTY");

        //get the item that the player wants to enchant
        object oINPUT = GetLocalObject(oPC, "ENCHANT_INPUT");

        // check if the player has the required items to enchant
        if (GetItemQuantity(oPC, sCOST) < nINPUT) 
        {
            SendMessageToPC(oPC, "You do not have the required amount of items to note.");
            return;
        }
		else 
		{
		

			string sOUTPUT = "noted" + sCOST; // the tag of the item plus noted
			
			// create the noted item in the player's inventory
			CreateItemOnObject(sOUTPUT, oPC, nINPUT);
			
			// check if the created item is valid 
			object oOUTPUT = GetItemPossessedBy(oPC, sOUTPUT);
			if(!GetIsObjectValid(oOUTPUT))
			{
			    SendMessageToPC(oPC, "This item cannot be noted");
  			    return;
			}
			else
			{
 		    // remove the used items from the player's inventory
  			RemoveItems(oPC, sCOST, nINPUT);
			}
		}
    }
}

void main(string sCOMMAND, string sINPUT)
{
    object oPC = OBJECT_SELF;
    // check if the command input is for enchanting
    if (sCOMMAND == "ENCHANT") NoteInitiate(oPC);
    else NoteExecute(oPC);
}