//:: Icequeen's Persistent Housing (10/28/08)
//:: Mortgage-tool Conversation starting conditional file
//:: Sets up the mortgage interaction variables
//:: Is this house for sale?

#include "iq_pbs_db_inc"
#include "iq_phs_db_inc"

int StartingConditional()
{
 int bReturn=FALSE;
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
 // ----- Is this house for sale? -----
 string sMortHolder;
 if (PHGetIsForSale(OBJECT_SELF))
 	{
	sMortHolder=PHGetMortgageHolder(OBJECT_SELF);
	if (sMortHolder=="") sMortHolder="The Bank";
	bReturn=TRUE;
	}
 // ------------------------------------
 // ----- Set Tokens for Convo -----
 SetCustomToken(5000, IntToString(nBankGold));
 SetCustomToken(5001, IntToString(nCarryGold));
 SetCustomToken(5002, IntToString(nPlayerGold));
 SetCustomToken(5003, IntToString(nPrice));
 SetCustomToken(5004, sMortHolder);
 // ------------------------------------
 return bReturn;
}