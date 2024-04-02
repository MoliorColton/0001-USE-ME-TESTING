#include "X0_I0_SPELLS"

int TouchResult(int nDieSize, int nDieNumber, int nMetaMagic, object oTarget){
	int nTouch = TouchAttackRanged(oTarget, TRUE);
	int nDamage;
	if (nTouch != 0){
		if (nTouch == 2 && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT)) nDieNumber = nDieNumber * 2;
		nDamage = MaximizeOrEmpower(nDieSize, nDieNumber, nMetaMagic);
	}
	return nDamage;
}