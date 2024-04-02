//::///////////////////////////////////////////////
//:: Example XP2 OnItemEquipped
//:: x2_mod_def_unequ
//:: (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Put into: OnUnEquip Event
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-16
//:://////////////////////////////////////////////
#include "x2_inc_switches"
#include "x2_inc_intweapon"
#include "moliorrs_equipment"

void main()
{
    object oItem = GetPCItemLastUnequipped();
    object oPC   = GetPCItemLastUnequippedBy();
    DelayCommand(0.0f, BeginHandlingEquipment(oPC, oItem, TRUE));

   // -------------------------------------------------------------------------
   // Fix of login-logout bonus stack
   // -------------------------------------------------------------------------
    {
        // An object already equiped at co is unequip.
        if (GetLocalInt(oItem, "var_DbgItemCo") > 0)
        {
            //Get back the object slot
            int iTemSlot = GetLocalInt(oItem, "var_DbgItemCo") -1;
            //Equip it again and unequip
            AssignCommand(oPC,DelayCommand(0.05, ActionEquipItem(oItem, iTemSlot)));
            AssignCommand(oPC,DelayCommand(0.1, ActionUnequipItem(oItem)));
            //Flag object and player
            SetLocalInt(oItem, "var_DbgItemCo", -1);
            SetLocalInt(oPC, "var_EnDbgItem", 1);
            return;
        }
        // No more need of this flag
        else if(GetLocalInt(oItem, "var_DbgItemCo") == -1)
        {
            DeleteLocalInt(oItem, "var_DbgItemCo");
        }
    }



    // -------------------------------------------------------------------------
    //  Intelligent Weapon System
    // -------------------------------------------------------------------------
    if (IPGetIsIntelligentWeapon(oItem))
    {
        IWSetIntelligentWeaponEquipped(oPC, OBJECT_INVALID);
        IWPlayRandomUnequipComment(oPC, oItem);
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
        SetUserDefinedItemEventNumber(X2_ITEM_EVENT_UNEQUIP);
        int nRet =   ExecuteScriptAndReturnInt(GetUserDefinedItemEventScriptName(oItem), OBJECT_SELF);
        if (nRet == X2_EXECUTE_SCRIPT_END) return;
    }

    if ((GetTag(oItem) == "firecape" && GetItemPossessor(oItem) == oPC))
    {
        effect eVFX;
        eVFX = EffectNWN2SpecialEffectFile("fx_firecape");
        RemoveSEFFromObject( oPC, "fx_firecape" );
    }

}