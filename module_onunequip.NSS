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

// Declare eStrBonustest1 at the top of the script
effect eStrBonustest1;

void main()
{
     object oItem = GetPCItemLastUnequipped();
     object oPC   = GetPCItemLastUnequippedBy();
	 DelayCommand(0.0f, BeginHandlingEquipment(oPC, oItem, TRUE));

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
if ((GetTag(oItem) == "obsidiancape" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_obsidiancape");
    RemoveSEFFromObject( oPC, "fx_obsidiancape" );
}
if ((GetTag(oItem) == "onyxnecklace" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_necklace_onyx");
    RemoveSEFFromObject( oPC, "fx_necklace_onyx" );
}
if ((GetTag(oItem) == "onyxnecklacee" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_necklace_berserker");
    RemoveSEFFromObject( oPC, "fx_necklace_berserker" );
}
if ((GetTag(oItem) == "onyxamulet" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_amulet_onyx");
    RemoveSEFFromObject( oPC, "fx_amulet_onyx" );
}
if ((GetTag(oItem) == "onyxamulete" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_amulet_fury");
    RemoveSEFFromObject( oPC, "fx_amulet_fury" );
}
if ((GetTag(oItem) == "dragonstonenecklace" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_necklace_dstone");
    RemoveSEFFromObject( oPC, "fx_necklace_dstone" );
}
if ((GetTag(oItem) == "dragonstonenecklacee" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_necklace_skills");
    RemoveSEFFromObject( oPC, "fx_necklace_skills" );
}
if ((GetTag(oItem) == "dragonstoneamulet" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_amulet_dstone");
    RemoveSEFFromObject( oPC, "fx_amulet_dstone" );
}
if ((GetTag(oItem) == "dragonstoneamulete" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_amulet_glory");
    RemoveSEFFromObject( oPC, "fx_amulet_glory" );
}
if ((GetTag(oItem) == "diamondamulet" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_amulet_diamond");
    RemoveSEFFromObject( oPC, "fx_amulet_diamond" );
}
if ((GetTag(oItem) == "diamondamulete" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_amulet_power");
    RemoveSEFFromObject( oPC, "fx_amulet_power" );
}
if ((GetTag(oItem) == "diamondnecklace" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_necklace_diamond");
    RemoveSEFFromObject( oPC, "fx_necklace_diamond" );
}
if ((GetTag(oItem) == "diamondnecklacee" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_necklace_phoenix");
    RemoveSEFFromObject( oPC, "fx_necklace_phoenix" );
}
if ((GetTag(oItem) == "rubyamulete" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_amulet_strength");
    RemoveSEFFromObject( oPC, "fx_amulet_strength" );
}
if ((GetTag(oItem) == "rubyamulet" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_amulet_ruby");
    RemoveSEFFromObject( oPC, "fx_amulet_ruby" );
}
if ((GetTag(oItem) == "rubynecklace" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_necklace_ruby");
    RemoveSEFFromObject( oPC, "fx_necklace_ruby" );
}
if ((GetTag(oItem) == "rubynecklacee" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_necklace_digsite");
    RemoveSEFFromObject( oPC, "fx_necklace_digsite" );
}
if ((GetTag(oItem) == "emeraldnecklace" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_necklace_emerald");
    RemoveSEFFromObject( oPC, "fx_necklace_emerald" );
}
if ((GetTag(oItem) == "emeraldnecklacee" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_necklace_binding");
    RemoveSEFFromObject( oPC, "fx_necklace_binding" );
}
if ((GetTag(oItem) == "emeraldamulet" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_amulet_emerald");
    RemoveSEFFromObject( oPC, "fx_amulet_emerald" );
}
if ((GetTag(oItem) == "emeraldamulete" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_amulet_defence");
    RemoveSEFFromObject( oPC, "fx_amulet_defence" );
}
if ((GetTag(oItem) == "sapphirenecklace" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_necklace_sapphire");
    RemoveSEFFromObject( oPC, "fx_necklace_sapphire" );
}
if ((GetTag(oItem) == "sapphirenecklacee" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_necklace_games");
    RemoveSEFFromObject( oPC, "fx_necklace_games" );
}
if ((GetTag(oItem) == "sapphireamulet" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_amulet_sapphire");
    RemoveSEFFromObject( oPC, "fx_amulet_sapphire" );
}
if ((GetTag(oItem) == "sapphireamulete" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_amulet_magic");
    RemoveSEFFromObject( oPC, "fx_amulet_magic" );
}
if ((GetTag(oItem) == "redtopazamulet" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_amulet_rtopaz");
    RemoveSEFFromObject( oPC, "fx_amulet_rtopaz" );
}
if ((GetTag(oItem) == "redtopazamulete" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_amulet_burning");
    RemoveSEFFromObject( oPC, "fx_amulet_burning" );
}
if ((GetTag(oItem) == "redtopaznecklace" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_necklace_rtopaz");
    RemoveSEFFromObject( oPC, "fx_necklace_rtopaz" );
}
if ((GetTag(oItem) == "redtopaznecklacee" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_necklace_faith");
    RemoveSEFFromObject( oPC, "fx_necklace_faith" );
}
if ((GetTag(oItem) == "jadeamulet" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_amulet_jade");
    RemoveSEFFromObject( oPC, "fx_amulet_jade" );
}
if ((GetTag(oItem) == "jadeamulete" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_amulet_chemistry");
    RemoveSEFFromObject( oPC, "fx_amulet_chemistry" );
}
if ((GetTag(oItem) == "jadenecklace" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_necklace_jade");
    RemoveSEFFromObject( oPC, "fx_necklace_jade" );
}
if ((GetTag(oItem) == "jadenecklacee" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_necklace_dodgy");
    RemoveSEFFromObject( oPC, "fx_necklace_dodgy" );
}
if ((GetTag(oItem) == "glarialsamulet" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_amulet_glarial");
    RemoveSEFFromObject( oPC, "fx_amulet_glarial" );
}
if ((GetTag(oItem) == "amuletofgloryench" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_amulet_etglory");
    RemoveSEFFromObject( oPC, "fx_amulet_etglory" );
}
if ((GetTag(oItem) == "amuletofaccuracy" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_amulet_accuracy");
    RemoveSEFFromObject( oPC, "fx_amulet_accuracy" );
}
if ((GetTag(oItem) == "amuletofcatspeak" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_amulet_catspeak");
    RemoveSEFFromObject( oPC, "fx_amulet_catspeak" );
}
if ((GetTag(oItem) == "salveamulet" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_amulet_salve");
    RemoveSEFFromObject( oPC, "fx_amulet_salve" );
}
if ((GetTag(oItem) == "holyamulet" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_amulet_holy");
    RemoveSEFFromObject( oPC, "fx_amulet_holy" );
}
if ((GetTag(oItem) == "goldamulet" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_amulet_gold");
    RemoveSEFFromObject( oPC, "fx_amulet_gold" );
}
if ((GetTag(oItem) == "goldnecklace" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_necklace_gold");
    RemoveSEFFromObject( oPC, "fx_necklace_gold" );
}
if ((GetTag(oItem) == "ghostspeakamulet" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_amulet_ghostspeak");
    RemoveSEFFromObject( oPC, "fx_amulet_ghostspeak" );
}
if ((GetTag(oItem) == "lanternbelt01" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_lantern_01");
    RemoveSEFFromObject( oPC, "fx_lantern_01" );
}
if ((GetTag(oItem) == "lanternbelt02" && GetItemPossessor(oItem) == oPC))
{
    effect eVFX;
    eVFX = EffectNWN2SpecialEffectFile("fx_lantern_02");
    RemoveSEFFromObject( oPC, "fx_lantern_02" );
}
}