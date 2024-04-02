// Icequeen's Persistent Stores (10/28/08)
//:: Is this store for sale?

#include "iq_pbs_db_inc"
#include "iq_pss_db_inc"

int StartingConditional()
{
 int bReturn=FALSE;
 object oPC = GetPCSpeaker();
 // ----- Get How much gold Player has on him & in bank -----
 int nBankGold=PBGetBalance(oPC);
 int nCarryGold=GetGold(oPC);
 int nPlayerGold=nCarryGold+nBankGold;
 // ------------------------------------
 // ----- Get the Price of this store -----
 int nPrice=GetLocalInt(OBJECT_SELF, "StorePrice");
 // ------------------------------------
 // ----- Is this store for sale? -----
 if (PSGetIsForSale(OBJECT_SELF) || PSGetOwner(OBJECT_SELF)=="") bReturn=TRUE;
 // ------------------------------------
 // ----- Set Tokens for Convo -----
 SetCustomToken(6000, IntToString(nPrice));
 // ------------------------------------
 return bReturn;
}