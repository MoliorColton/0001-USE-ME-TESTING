// Icequeen's Persistent Stores (10/28/08)
//:: Does buyer have enough gold on hand?

#include "iq_pss_db_inc"

int StartingConditional()
{
 object oPC = GetPCSpeaker();
 int nCarryGold=GetGold(oPC);
 int nPrice=GetLocalInt(OBJECT_SELF, "StorePrice");
 if (nCarryGold >= nPrice) return TRUE;
 return FALSE;
}