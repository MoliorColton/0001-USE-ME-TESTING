#include "nw_i0_spells"   
#include "profession_include" 

void AlchcheckInitiate(object oPC)
{
    object oITEM = GetPlayerCurrentTarget(oPC);
    string sTXT;
	string sCOST = "ALCHCHECK";
	string sValue = GetLocalString(oITEM, "alchemy");	

    if (GetItemPossessor(oITEM) != oPC)
    {
        sTXT = "You may only value items in your inventory (select by targeting item with right click).";
        SendMessageToPC(oPC, sTXT);
        return;
    }
	// check if the selected item is valid AKA plot or not, we won't alch plot items
	if (GetPlotFlag(oITEM))
	{
  	SendMessageToPC(oPC, "This item is important and cannot be Low-Alchemized");
  	return;
	}
	

		
	// Check if oITEM's string sValue has the specific string variable
	if (sValue != "alchemy")
	{
	SendMessageToPC(oPC, "This item cannot be Alchemized");
    return;
	}

    //get the tag of the item
    string sITEM_TAG = GetTag(oITEM);
    //store the tag for later use
    SetLocalString(oPC, "ITEM_TAG", sITEM_TAG);
	//get the value of the item as stored by an intiger value variable
	int nValue1 = GetLocalInt(oITEM, "lowalch");
	int nValue2 = GetLocalInt(oITEM, "highalch");
	string sValue1 = IntToString(nValue1);
	string sValue2 = IntToString(nValue2);
    //create the string that shows the cost of the enchanting
    sTXT = GetName(oITEM) + " will Low-Alchemize " + " for " + sValue1 + " coins, and will High-Alchemize " + " for " + sValue2 + " coins. This will alchemize the first item of this type in your inventory, even if the item is within a bag of holding.";
    //set some local variables on the player object for later use
    //displays a message box to confirm the enchantment
    DisplayMessageBox(oPC, 0, sTXT, "gui_prof_alchcheck", "", TRUE);
}



void main(string sCOMMAND, string sINPUT)
{
    object oPC = OBJECT_SELF;
    if (sCOMMAND == "ALCHCHECK") AlchcheckInitiate(oPC);
    else return;
}