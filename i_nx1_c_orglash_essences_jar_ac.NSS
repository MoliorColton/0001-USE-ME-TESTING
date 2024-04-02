// i_nx1_jaroforglashessences_ac
/*
   Jar of Orglash Extract is activated.
*/
// OP - OEI 3/8/07
// EPF 3/19/07 -- scripting.

#include "X2_I0_SPELLS"
#include "x2_inc_itemprop"
#include "x2_inc_spellhook"
#include "c_inc_global"

const int STRREF_APPLY_FAILURE = 208586;
const int STRREF_APPLY_SUCCESS = 208588;

void AddIcyEffectToWeapon(object oTarget, float fDuration)
{
   // If the spell is cast again, any previous itemproperties matching are removed.
   IPSafeAddItemProperty(oTarget, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD,10), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
   IPSafeAddItemProperty(oTarget, ItemPropertyVisualEffect(ITEM_VISUAL_COLD), fDuration,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);
   
   return;
}

void main()
{
    // * This code runs when the Unique Power property of the item is used
    object oPC      = GetItemActivator();
    object oItem    = GetItemActivated();
    object oTarget  = GetItemActivatedTarget();
    location lTarget = GetItemActivatedTargetLocation();

    if(GetMeleeWeapon(oTarget))
    {
        AddIcyEffectToWeapon(oTarget, 600.f);
		FloatingTextStrRefOnCreature(STRREF_APPLY_SUCCESS,oPC);
    }
    else if(GetTag(oTarget) == BURNING_TREE_TAG)
    {
        FloatingTextStrRefOnCreature(STRREF_APPLY_FAILURE,oPC);
    }
}