#include "nw_i0_spells"   
#include "profession_include" 

void AlchInitiate(object oPC)
{
    // Check if the spell is already in progress
    if (GetLocalInt(oPC, "HIGHALCH_IN_PROGRESS") == TRUE)
    {
        SendMessageToPC(oPC, "You are already casting this spell, please wait.");
        return;
    }
	
	
	
    // Check if the player is in a trade window
    if (GetLocalInt(oPC, "TRADE_WINDOW_OPEN") == TRUE)
    {
        SendMessageToPC(oPC, "You cannot cast alchemy spells items while in a trade window.");
        return;
    }
	
	
	//get the targeted item
    object oITEM = GetPlayerCurrentTarget(oPC);
    string sTXT;
    int nFAIL;
    effect eVFX;
	//local varriable on the item so the script knows it can be used in alchemy
    string sValue = GetLocalString(oITEM, "alchemy");
    int nREQ = 55;  // Actual value needs to be 55, but 1 is for testing
    int nRANK = GetSkillRank(SKILL_RUNECRAFTING, oPC);
    if (nRANK < nREQ)
    {
        sTXT = "You need " + IntToString(nREQ) + " ranks in Runecrafting to cast the High Level Alchemy spell.";
        SendMessageToPC(oPC, sTXT);
        SetLocalInt(oPC, "HIGHALCH_IN_PROGRESS", FALSE); // Reset the spell in progress
        return;
    }
	// check that oITEM is currently in the player's inventory
    if (GetItemPossessor(oITEM) != oPC)
    {
        sTXT = "You may only High-Alchemize items in your inventory (select by targeting item with right click).";
        SendMessageToPC(oPC, sTXT);
        SetLocalInt(oPC, "HIGHALCH_IN_PROGRESS", FALSE); // Reset the spell in progress
        return;
    }

    // check if oITEM is valid / plot or not, we won't alch plot items for obvious reason
    if (GetPlotFlag(oITEM))
    {	
        sTXT = "This item is important and cannot be High-Alchemized.";
		SendMessageToPC(oPC, sTXT);
		SetLocalInt(oPC, "HIGHALCH_IN_PROGRESS", FALSE); // Reset the spell in progress
        return;
    }

    // Check if oITEM's string sValue has the specific string variable
    if (sValue != "alchemy")
    {
        sTXT = "This item cannot be High-Alchemized.";
		SendMessageToPC(oPC, sTXT);
		SetLocalInt(oPC, "HIGHALCH_IN_PROGRESS", FALSE); // Reset the spell in progress
        return; 
    }

    // Check rune quantities
    if (GetItemQuantity(oPC, "naturerune") < 1 || GetItemQuantity(oPC, "firerune") < 5)
    {
		sTXT = "You need at least 1 nature & 5 fire runes";
        SendMessageToPC(oPC, sTXT);
        SetLocalInt(oPC, "HIGHALCH_IN_PROGRESS", FALSE); // Reset the spell in progress
        return;
    }



    //get the tag of the item
    string sITEM_TAG = GetTag(oITEM);
    //store the tag for later use
    SetLocalString(oPC, "ITEM_TAG", sITEM_TAG);

    //get the value of the item as stored by an integer value variable
    int nValue1 = GetLocalInt(oITEM, "highalch");
    string sValue1 = IntToString(nValue1);
    //set some local variables on the player object for later use
    SetLocalObject(oPC, "ALCH_INPUT", oITEM);
    SetLocalInt(oPC, "ALCH_INPUT_QTY", 1);

    //get the name and quantity of the rune needed
    string sCOST = GetLocalString(oPC, "ITEM_TAG");
    int nINPUT = GetLocalInt(oPC, "ALCH_INPUT_QTY");
    string sItem1 = "naturerune";
    string sItem2 = "firerune";

    //amount of XP given
    int nXP = 31;
    //Skill 2da ID
    int  nSKILL = 36;
	
	
	// Set the spell in progress
    SetLocalInt(oPC, "HIGHALCH_IN_PROGRESS", TRUE);
    DelayCommand(1.6f, SetLocalInt(oPC, "HIGHALCH_IN_PROGRESS", FALSE));
	// Disable the "lowalchemy" button during the cooldown
    SetGUIObjectDisabled(oPC, "SCREEN_INVENTORY", "highalchemy", TRUE);


	
    // remove the used items from the player's inventory, play VFX, play animation
    AssignCommand(oPC, ReallyPlayCustomAnimation(oPC, "worship", TRUE));
    eVFX = EffectNWN2SpecialEffectFile("fx_low_alchemy");
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oPC, 2.5);
    RemoveItems(oPC, "naturerune", 1);
    RemoveItems(oPC, "firerune", 5);
    RemoveItems(oPC, sCOST, nINPUT);
    GiveGoldToCreature(oPC, nValue1);
    DelayCommand(3.0, AssignCommand(oPC, ReallyPlayCustomAnimation(oPC, "idle", TRUE)));
	
	// Re-enable the "highalchemy" button
    DelayCommand(3.0, SetGUIObjectDisabled(oPC, "SCREEN_INVENTORY", "highalchemy", FALSE));
	
	
    ExecuteScript("profession_action", oPC);
	


}

void main(string sCOMMAND, string sINPUT)
{
    object oPC = OBJECT_SELF;
    if (sCOMMAND == "HIGHALCH") AlchInitiate(oPC);
    else return;
}