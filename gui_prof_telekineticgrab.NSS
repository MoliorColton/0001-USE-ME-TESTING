#include "nw_i0_spells"
#include "profession_include"



void Telegrabexecute(object oPC)
{





    // Check if the spell is already in progress
    if (GetLocalInt(oPC, "TELEGRAB_IN_PROGRESS") == TRUE)
    {
        SendMessageToPC(oPC, "Telegrab is already in progress. Please wait.");
        return;
    }

    // Check if the player is in a trade window
    if (GetLocalInt(oPC, "TRADE_WINDOW_OPEN") == TRUE)
    {
        SendMessageToPC(oPC, "You cannot telegrab items while in a trade window.");
        return;
    }
	
	
	
    // Get the targeted item
    object oITEM = GetPlayerCurrentTarget(oPC);
    effect eVFX;
    string sTXT;
    int nFAIL;
    int nREQ = 43;
    int nRANK = GetSkillRank(SKILL_RUNECRAFTING, oPC);
    if (nRANK < nREQ)

    {
        sTXT = "You need " + IntToString(nREQ) + " ranks in Runecrafting to cast the Telekinetic Grab spell.";
        SendMessageToPC(oPC, sTXT);
        SetLocalInt(oPC, "TELEGRAB_IN_PROGRESS", FALSE); // Reset the spell in progress
        return;
    }

    //get the item that the player wants to enchant
    object oINPUT = GetLocalObject(oPC, "ALCH_INPUT");
    if (GetItemQuantity(oPC, "airrune") < 1) nFAIL = TRUE;
    else if (GetItemQuantity(oPC, "lawrune") < 1) nFAIL = TRUE;
    if (nFAIL == TRUE)
    {
        SendMessageToPC(oPC, "You need at least 1 air & 1 law rune");
        SetLocalInt(oPC, "TELEGRAB_IN_PROGRESS", FALSE); // Reset the spell in progress
        return;
    }
	DelayCommand(3.0f, SetGUIObjectDisabled(oPC, "SCREEN_INVENTORY", "telegrab", FALSE));
    // Check if the targeted object is an item on the ground
    if (GetObjectType(oITEM) == OBJECT_TYPE_ITEM)
    {
        // Get the stack size of the targeted item
        int nStackSize = GetItemStackSize(oITEM);

        // Check if the targeted item is in the player's inventory
        object oInventoryItem = GetFirstItemInInventory(oPC);
        while (GetIsObjectValid(oInventoryItem))
        {
            if (oInventoryItem == oITEM)
            {
                SendMessageToPC(oPC, "Cannot perform telegrab on an item in the inventory.");
                SetLocalInt(oPC, "TELEGRAB_IN_PROGRESS", FALSE); // Reset the spell in progress
                return;
            }
            oInventoryItem = GetNextItemInInventory(oPC);
        }

        // Check if the targeted item is already in the player's inventory
        object oExistingItem = GetItemPossessedBy(oPC, GetTag(oITEM));

        if (GetIsObjectValid(oExistingItem))
        {
            // If the item is already in the player's inventory and stackable, increase the stack size
            if (GetItemStackSize(oExistingItem) > 1)
            {
                int nExistingStackSize = GetItemStackSize(oExistingItem);
                SetItemStackSize(oExistingItem, nExistingStackSize + nStackSize);

            }
            else
            {
                // If the item is already in the player's inventory but not stackable,
                // create a copy of the item with the same stack size
                object oItemCopy = CreateItemOnObject(GetTag(oITEM), oPC, nStackSize);

            }
    		// Set the spell in progress
    		SetLocalInt(oPC, "TELEGRAB_IN_PROGRESS", TRUE);
			DelayCommand(1.6f, SetLocalInt(oPC, "TELEGRAB_IN_PROGRESS", FALSE));
			// Disable the "telegrab" button during the cooldown
    		SetGUIObjectDisabled(oPC, "SCREEN_INVENTORY", "telegrab", TRUE);
            // Get the position of the targeted item
            vector vPos = GetPosition(oITEM);

            // Set the player's facing to the position of the targeted item
            SetFacingPoint(vPos, FALSE);

            // Destroy the original item on the ground
            DestroyObject(oITEM, 1.5f);
            // Apply visual effect to the targeted ground object
            eVFX = EffectNWN2SpecialEffectFile("fx_telegraborb");
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oITEM, 2.0);
            //amount of XP given
            int nXP = 43;
            //Skill 2da ID
            int nSKILL = 36;
            AssignCommand(oPC, ReallyPlayCustomAnimation(oPC, "point", TRUE));
            eVFX = EffectNWN2SpecialEffectFile("fx_telegrabplayer");
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oPC, 2.0);
            RemoveItems(oPC, "airrune", 1);
            RemoveItems(oPC, "lawrune", 1);
            DelayCommand(1.5, AssignCommand(oPC, ReallyPlayCustomAnimation(oPC, "idle", TRUE)));
            ExecuteScript("profession_action", oPC);
			// Re-Enable the "telegrab" button during the cooldown
    		SetGUIObjectDisabled(oPC, "SCREEN_INVENTORY", "telegrab", FALSE);
			           

        }
        else
        {
		    // Set the spell in progress
    		SetLocalInt(oPC, "TELEGRAB_IN_PROGRESS", TRUE);
			DelayCommand(1.6f, SetLocalInt(oPC, "TELEGRAB_IN_PROGRESS", FALSE));
			// Disable the "telegrab" button during the cooldown
    		SetGUIObjectDisabled(oPC, "SCREEN_INVENTORY", "telegrab", TRUE);
            // Create a copy of the item with the stack size
            object oItemCopy = CreateItemOnObject(GetTag(oITEM), oPC, nStackSize);

            // Get the position of the targeted item
            vector vPos = GetPosition(oITEM);

            // Set the player's facing to the position of the targeted item
            SetFacingPoint(vPos, FALSE);

            // Destroy the original item on the ground
            DestroyObject(oITEM, 1.5f);
            // Apply visual effect to the targeted ground object
            eVFX = EffectNWN2SpecialEffectFile("fx_telegraborb");
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oITEM, 2.0);
            //amount of XP given
            int nXP = 43;
            //Skill 2da ID
            int nSKILL = 36;
            AssignCommand(oPC, ReallyPlayCustomAnimation(oPC, "point", TRUE));
            eVFX = EffectNWN2SpecialEffectFile("fx_telegrabplayer");
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oPC, 2.0);
            RemoveItems(oPC, "airrune", 1);
            RemoveItems(oPC, "lawrune", 1);
            DelayCommand(1.5, AssignCommand(oPC, ReallyPlayCustomAnimation(oPC, "idle", TRUE)));
            ExecuteScript("profession_action", oPC);
			// Re-Enable the "telegrab" button during the cooldown
    		SetGUIObjectDisabled(oPC, "SCREEN_INVENTORY", "telegrab", FALSE);
        }
    }
}

void main(string sCOMMAND, string sINPUT)
{
    object oPC = OBJECT_SELF;
    if (sCOMMAND == "TELEGRAB")
    {
        Telegrabexecute(oPC);
    }
    else
        return;
}