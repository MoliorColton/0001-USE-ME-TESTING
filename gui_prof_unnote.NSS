#include "nw_i0_spells"   
#include "profession_include" 

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
        // Send a message to the player
        SendMessageToPC(oPC, "That would be quite impossible.");
        // Return or perform any other action you want
        NoteResetButtons(oPC);
        return;
    }

    string sTXT;

	
	
	
	
    // Check if the player possesses the item
    if (GetItemPossessor(oITEM) != oPC)
    {
        sTXT = "You may only un-note items in your inventory (select by targeting item with right click).";
        SendMessageToPC(oPC, sTXT);
        // Disable the "noting" buttons during the cooldown
        NoteResetButtons(oPC);
        return;
    }
	

	
	
int nINPUT = StringToInt(sINPUT);
//get the tag of the item
string sITEM_TAG = GetTag(oITEM);
//store the tag for later use
SetLocalString(oPC, "ITEM_TAG", sITEM_TAG);
// create the string that shows the cost of the enchanting
string sCOST = IntToString(nINPUT);
SetLocalObject(oPC, "ENCHANT_INPUT", oITEM);
SetLocalInt(oPC, "ENCHANT_RUNEA_QTY", 1);
SetLocalInt(oPC, "RUNE_UI", 2);


// initiate the "note" action directly without prompting for confirmation
NoteExecute(oPC);
}



//EXECUTE
void NoteExecute(object oPC)
{
//get the type of enchanting process
int nTYPE = GetLocalInt(oPC, "RUNE_UI");
//check if the process is for enchanting
if (nTYPE == 2)
{
    //check if player's inventory is full
   		//check if player's inventory is full
		int maxInvSize = 128;
		int currentInvSize = GetInventoryNum(oPC);
		int freeSpace = maxInvSize - currentInvSize;
	
  		//get the name and quantity of the rune needed
		string sCOST = GetLocalString(oPC, "ITEM_TAG");
        int nINPUT = GetLocalInt(oPC, "ENCHANT_RUNEA_QTY");

        //get the item that the player wants to enchant
        object oINPUT = GetLocalObject(oPC, "ENCHANT_INPUT");
		
		// check if the player has the required items to enchant
        if (GetItemQuantity(oPC, sCOST) < nINPUT) 
        {
            SendMessageToPC(oPC, "You do not have the required amount of items to unnote.");
			NoteResetButtons(oPC);
            return;
        }
		
		
		
			string sOUTPUT = "noted" + sCOST;
			int nIndex = FindSubString(sCOST, "noted");
			if (nIndex != -1) {
   			string sOUTPUT = GetStringLeft(sCOST,nIndex-1);
		}
			else 
		{
	   	    SendMessageToPC(oPC, "The item you selected was not a Bank Note.");
			NoteResetButtons(oPC);
 			return;
		}
if (freeSpace < nINPUT)
{
    SendMessageToPC(oPC, "You do not have enough free inventory spaces to unnote that many items.");
	NoteResetButtons(oPC);
    return;
}
		
		{
		// substring "noted" exists in sOUTPUT, proceed to remove input item and create new item
		sOUTPUT = GetSubString(sCOST, nIndex+5, -1); //start after the "noted" part, and take the rest of the string
		RemoveItems(oPC, sCOST, nINPUT);
		CreateItemOnObject(sOUTPUT, oPC, nINPUT);
		NoteResetButtons(oPC);


		} 
	}
}

void main(string sCOMMAND, string sINPUT)
{
    object oPC = OBJECT_SELF;
    
    // Check if the command input is for initiating the unnoting process
    if (sCOMMAND == "ENCHANT")
    {
        NoteInitiate(oPC, sINPUT);
    }
    // Check if the command input is for executing the unnoting process
    else if (sCOMMAND == "EXECUTE")
    {
        NoteExecute(oPC);
    }
}