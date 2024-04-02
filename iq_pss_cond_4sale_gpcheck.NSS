// Icequeen's Persistent Stores (10/28/08)
//:: Does buyer have enough gold?

#include "iq_pbs_db_inc"
#include "iq_pss_db_inc"

int StartingConditional()
{
 object oPC = GetPCSpeaker();
 // ----- Get How much gold Player has on him & in bank -----
 int nBankGold=PBGetBalance(oPC);
 int nCarryGold=GetGold(oPC);
 int nPlayerGold=nCarryGold+nBankGold;
int nPrice=GetLocalInt(OBJECT_SELF, "StorePrice");
 if (nPlayerGold >= nPrice) return TRUE;
 return FALSE;
}