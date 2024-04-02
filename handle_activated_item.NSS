#include "x2_inc_switches"
#include "x2_inc_intweapon"
#include "moliorrs_equipment"

void main()
{
    object oItem = GetPCItemLastEquipped();
    object oPC = GetPCItemLastEquippedBy();
    DelayCommand(0.0f, BeginHandlingEquipment(oPC, oItem));

    // -------------------------------------------------------------------------
    // Intelligent Weapon System
    // -------------------------------------------------------------------------
    if (IPGetIsIntelligentWeapon(oItem))
    {
        IWSetIntelligentWeaponEquipped(oPC, oItem);
        // Prevent players from reequipping their weapon
        if (IWGetIsInIntelligentWeaponConversation(oPC))
        {
            object oConv = GetLocalObject(oPC, "X2_O_INTWEAPON_SPIRIT");
            IWEndIntelligentWeaponConversation(oConv, oPC);
        }
        else
        {
            // Trigger Drain Health Event
            if (GetLocalInt(oPC, "X2_L_ENSERRIC_ASKED_Q3") == 1)
                ExecuteScript("x2_ens_dodrain", oPC);
            else
                IWPlayRandomEquipComment(oPC, oItem);
        }
    }

    // -------------------------------------------------------------------------
    // Generic Item Script Execution Code
    // If MODULE_SWITCH_EXECUTE_TAGBASED_SCRIPTS is set to TRUE on the module,
    // it will execute a script that has the same name as the item's tag
    // inside this script you can manage scripts for all events by checking against
    // GetUserDefinedItemEventNumber(). See x2_it_example.nss
    // -------------------------------------------------------------------------
    if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE)
    {
        SetUserDefinedItemEventNumber(X2_ITEM_EVENT_EQUIP);
        int nRet = ExecuteScriptAndReturnInt(GetUserDefinedItemEventScriptName(oItem), OBJECT_SELF);
        if (nRet == X2_EXECUTE_SCRIPT_END) return;
    }

    // Check if the equipped item has the desired tag and belongs to the entering player
    if (GetTag(oItem) == "firecape" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX;
        eVFX = EffectNWN2SpecialEffectFile("fx_firecape");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX, oPC);
        SendMessageToPC(oPC, "Fire Cape effect added!");
    }
    else
    {
		effect eVFX;
		eVFX = EffectNWN2SpecialEffectFile("fx_firecape");            
		RemoveEffect(oPC, eVFX);            
		SendMessageToPC(oPC, "Fire Cape effect removed!");
    }
    
}
