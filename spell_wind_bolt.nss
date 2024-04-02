#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "x2_i0_spells"
#include "nw_i0_spells"
#include "touch_spell_handler"

void main(){
    object oTarget = GetSpellTargetObject();
    if (!X2PreSpellCastCode()){
        return;
    }
			//		6d10
	int nDieNumber = 6;
	int nDieSize = 10;
	
	object oPC = GetLastSpellCaster();
	int nCasterLevel = GetCasterLevel(oPC);
	nDieNumber = nDieNumber + (nDieNumber*((nCasterLevel+4)/5));
    int nMetaMagic = GetMetaMagicFeat();
		
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_LIGHTNING); //LIGHTNING, ICE, ACID, FIRE
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)){
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        float fDist = GetDistanceToObject(oTarget);
        float fDelay = (fDist/25.0);
		int nDamage = TouchResult(nDieSize, nDieNumber, nMetaMagic, oTarget);
		float fSpellDamage = GetLocalFloat(oPC, "SPELL_DAMAGE");
		if (fSpellDamage != 0.0f) nDamage = FloatToInt(fSpellDamage * nDamage);
		effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
	}
}