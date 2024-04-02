#include "x2_inc_switches"
#include "x2_inc_intweapon"
#include "moliorrs_equipment"

// Declare eStrBonustest1 at the top of the script
effect eStrBonustest1;

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
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_firecape");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    }
     if (GetTag(oItem) == "obsidiancape" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_obsidiancape");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    }   
     if (GetTag(oItem) == "onyxnecklace" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_necklace_onyx");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    }   
     if (GetTag(oItem) == "onyxnecklacee" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_necklace_berserker");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    }   
     if (GetTag(oItem) == "onyxamulet" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_amulet_onyx");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    }   
     if (GetTag(oItem) == "onyxamulete" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_amulet_fury");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    }   
     if (GetTag(oItem) == "dragonstonenecklace" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_necklace_dstone");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    }   
     if (GetTag(oItem) == "dragonstonenecklacee" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_necklace_skills");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    }   
     if (GetTag(oItem) == "dragonstoneamulet" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_amulet_dstone");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    }   
     if (GetTag(oItem) == "dragonstoneamulete" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_amulet_glory");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    }  
     if (GetTag(oItem) == "diamondamulet" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_amulet_diamond");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    }  
     if (GetTag(oItem) == "diamondamulete" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_amulet_power");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    }  
     if (GetTag(oItem) == "diamondnecklace" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_necklace_diamond");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    }  
     if (GetTag(oItem) == "diamondnecklacee" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_necklace_phoenix");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    }  
    if (GetTag(oItem) == "rubyamulete" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_amulet_strength");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    }  
    if (GetTag(oItem) == "rubyamulet" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_amulet_ruby");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    }  
    if (GetTag(oItem) == "rubynecklace" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_necklace_ruby");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    }  
    if (GetTag(oItem) == "rubynecklacee" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_necklace_digsite");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    }  
    if (GetTag(oItem) == "emeraldnecklace" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_necklace_emerald");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    }  
    if (GetTag(oItem) == "emeraldnecklacee" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_necklace_binding");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    }  
    if (GetTag(oItem) == "emeraldamulet" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_amulet_emerald");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    }  
    if (GetTag(oItem) == "emeraldamulete" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_amulet_defence");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    }  
    if (GetTag(oItem) == "sapphirenecklace" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_necklace_sapphire");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    }  
    if (GetTag(oItem) == "sapphirenecklacee" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_necklace_games");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    }  
   if (GetTag(oItem) == "sapphireamulet" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_amulet_sapphire");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    }  
   if (GetTag(oItem) == "sapphireamulete" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_amulet_magic");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    }  
   if (GetTag(oItem) == "redtopazamulet" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_amulet_rtopaz");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    }  
   if (GetTag(oItem) == "redtopazamulete" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_amulet_burning");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    }  
   if (GetTag(oItem) == "redtopaznecklace" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_necklace_rtopaz");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    }  
   if (GetTag(oItem) == "redtopaznecklacee" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_necklace_faith");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    }  
   if (GetTag(oItem) == "jadeamulet" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_amulet_jade");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    }  
   if (GetTag(oItem) == "jadeamulete" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_amulet_chemistry");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    }  
   if (GetTag(oItem) == "jadenecklace" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_necklace_jade");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    }  
   if (GetTag(oItem) == "jadenecklacee" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_necklace_dodgy");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    }  
   if (GetTag(oItem) == "glarialsamulet" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_amulet_glarial");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    }  
   if (GetTag(oItem) == "amuletofgloryench" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_amulet_etglory");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    }  
   if (GetTag(oItem) == "amuletofaccuracy" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_amulet_accuracy");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    }  
   if (GetTag(oItem) == "amuletofcatspeak" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_amulet_catspeak");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    }  
   if (GetTag(oItem) == "salveamulet" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_amulet_salve");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    } 
   if (GetTag(oItem) == "holyamulet" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_amulet_holy");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    } 
   if (GetTag(oItem) == "goldamulet" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_amulet_gold");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    } 
   if (GetTag(oItem) == "goldnecklace" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_necklace_gold");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    } 	
   if (GetTag(oItem) == "ghostspeakamulet" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_amulet_ghostspeak");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    } 		
   if (GetTag(oItem) == "lanternbelt01" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_lantern_01");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    } 	
   if (GetTag(oItem) == "lanternbelt02" && GetItemPossessor(oItem) == oPC)
    {
        effect eVFX1;
        eVFX1 = EffectNWN2SpecialEffectFile("fx_lantern_02");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX1, oPC);
    } 		
	
}