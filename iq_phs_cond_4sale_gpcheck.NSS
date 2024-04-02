//:: Icequeen's Persistent Housing (10/28/08)
//:: Mortgage-tool Conversation starting conditional file
//:: Does buyer have enough gold?

#include "iq_pbs_db_inc"
#include "iq_phs_db_inc"

int StartingConditional()
{
 object oPC = GetPCSpeaker();
 // ----- Get How much gold Player has on him & in bank -----
 int nBankGold=PBGetBalance(oPC);
 int nCarryGold=GetGold(oPC);
 int nPlayerGold=nCarryGold+nBankGold;
 // ------------------------------------
 // ----- Get the Price of this house -----
 int nPrice;
 int nCampPrice=PHGetCampHousePrice(OBJECT_SELF);
 int nLocalPrice=GetLocalInt(OBJECT_SELF, "HousePrice");
 if (nCampPrice > nLocalPrice) nPrice=nCampPrice;
 else nPrice=nLocalPrice;
 // ------------------------------------
 if (nPlayerGold >= nPrice) return TRUE;
 return FALSE;
}