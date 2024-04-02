// Icequeen's Persistent Stores (10/28/08)
// Give Owner profits, after taking out 5% for the salesman's cut.

#include "iq_pss_db_inc"

void main()
{
int nGold=PSGetGold(OBJECT_SELF);
if (nGold<1) return; // failsafe
object oPC=GetPCSpeaker();
GiveGoldToCreature(oPC, FloatToInt(nGold*0.95));
DelayCommand(0.1, PSSetGold(OBJECT_SELF, 0));
PSSetLocalInt(OBJECT_SELF, "OldGold", 0);
}