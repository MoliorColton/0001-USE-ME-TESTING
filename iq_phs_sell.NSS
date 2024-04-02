//:: Icequeen's Persistent Housing (10/28/08)
//:: PC Selling house

#include "iq_pbs_db_inc"
#include "iq_phs_db_inc"

void main()
{
object oPC=GetPCSpeaker();
string sMDB = PHGetMortgageDatabase(OBJECT_SELF);
string sMAcc = PHGetMortgageAccount(OBJECT_SELF);
string sMHolder = PHGetMortgageHolder(OBJECT_SELF);
int nMortBal = GetCampaignInt(sMDB, sMAcc + "BANK_GOLD");
int nCampPrice=PHGetCampHousePrice(OBJECT_SELF);
int nLocalPrice=GetLocalInt(OBJECT_SELF, "HousePrice");
int nGPPayment;
if (nCampPrice > nLocalPrice) nGPPayment=nCampPrice;
else nGPPayment=nLocalPrice;
PBDeposit(oPC, nGPPayment);	
if (sMDB!="")
	{
	SetCampaignInt(sMDB, sMAcc + "BANK_GOLD", nMortBal - nGPPayment);
	SendMessageToPC(oPC, sMHolder+" has transferred "+IntToString(nGPPayment)+" gold into your bank account!");
	}
else SendMessageToPC(oPC, IntToString(nGPPayment)+" has been transferred into your bank account!");
SetCampaignString(GetTag(OBJECT_SELF), "OwnedBy", sMAcc);
PHSetIsForSale(OBJECT_SELF, TRUE);
return;
}