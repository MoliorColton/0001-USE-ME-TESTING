// Icequeen's Persistent Stores (10/28/08)
//:: Does buyer have enough gold in bank?

#include "iq_pbs_db_inc"
#include "iq_pss_db_inc"

int StartingConditional()
{
 object oPC = GetPCSpeaker();
 int nBankGold=PBGetBalance(oPC);
 int nPrice=GetLocalInt(OBJECT_SELF, "StorePrice");
 if (nBankGold >= nPrice) return TRUE;
 return FALSE;
}