#include "nw_i0_spells"   
// include the base spell file 
#include "profession_include" 
// include profession specific functions

// function to initiate the rune enchanting process
void NoteInitiate(object oPC, string sINPUT)
{
object oITEM = GetPlayerCurrentTarget(oPC);
string sTXT;
if (GetItemPossessor(oITEM) != oPC)
{
sTXT = "You may only unnote items in your inventory (select by targeting item with right click).";
SendMessageToPC(oPC, sTXT);
return;
}
int nINPUT = StringToInt(sINPUT);
//get the tag of the item
string sITEM_TAG = GetTag(oITEM);
//store the tag for later use
SetLocalString(oPC, "ITEM_TAG", sITEM_TAG);
//create the string that shows the cost of the enchanting
string sCOST = IntToString(nINPUT);
sTXT = "Unnote 25 " + GetName(oITEM) + " ?";
//set some local variables on the player object for later use
SetLocalObject(oPC, "ENCHANT_INPUT", oITEM);
SetLocalInt(oPC, "ENCHANT_RUNEA_QTY", 25);
SetLocalInt(oPC, "RUNE_UI", 2);
//displays a message box to confirm the enchantment
DisplayMessageBox(oPC, 0, sTXT, "gui_prof_unnoteall", "", TRUE);
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
		int maxInvSize = 128;
		int currentInvSize = GetInventoryNum(oPC);
		int freeSpace = maxInvSize - currentInvSize;
		SendMessageToPC(oPC, "You have " + IntToString(freeSpace) + " free inventory spaces.");
	
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
		
		
		
			string sOUTPUT = "noted" + sCOST;
			int nIndex = FindSubString(sCOST, "noted");
			if (nIndex != -1) {
   			string sOUTPUT = GetStringLeft(sCOST,nIndex-1);
		}
			else 
		{
	   	    SendMessageToPC(oPC, "The item you selected was not a Bank Note.");
 			return;
		}
if (freeSpace < nINPUT)
{
    SendMessageToPC(oPC, "You do not have enough free inventory spaces to unnote that many items.");
    return;
}
		
		{
		// substring "noted" exists in sOUTPUT, proceed to remove input item and create new item
		sOUTPUT = GetSubString(sCOST, nIndex+5, -1); //start after the "noted" part, and take the rest of the string
		RemoveItems(oPC, sCOST, nINPUT);
		CreateItemOnObject(sOUTPUT, oPC, nINPUT);
		CreateItemOnObject(sOUTPUT, oPC, nINPUT);
		CreateItemOnObject(sOUTPUT, oPC, nINPUT);
		CreateItemOnObject(sOUTPUT, oPC, nINPUT);
		CreateItemOnObject(sOUTPUT, oPC, nINPUT);
		CreateItemOnObject(sOUTPUT, oPC, nINPUT);
		CreateItemOnObject(sOUTPUT, oPC, nINPUT);
		CreateItemOnObject(sOUTPUT, oPC, nINPUT);
		CreateItemOnObject(sOUTPUT, oPC, nINPUT);
		CreateItemOnObject(sOUTPUT, oPC, nINPUT);
		CreateItemOnObject(sOUTPUT, oPC, nINPUT);
		CreateItemOnObject(sOUTPUT, oPC, nINPUT);
		CreateItemOnObject(sOUTPUT, oPC, nINPUT);
		CreateItemOnObject(sOUTPUT, oPC, nINPUT);
		CreateItemOnObject(sOUTPUT, oPC, nINPUT);
		CreateItemOnObject(sOUTPUT, oPC, nINPUT);
		CreateItemOnObject(sOUTPUT, oPC, nINPUT);
		CreateItemOnObject(sOUTPUT, oPC, nINPUT);
		CreateItemOnObject(sOUTPUT, oPC, nINPUT);
		CreateItemOnObject(sOUTPUT, oPC, nINPUT);
		CreateItemOnObject(sOUTPUT, oPC, nINPUT);
		CreateItemOnObject(sOUTPUT, oPC, nINPUT);
		CreateItemOnObject(sOUTPUT, oPC, nINPUT);
		CreateItemOnObject(sOUTPUT, oPC, nINPUT);
		CreateItemOnObject(sOUTPUT, oPC, nINPUT);

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