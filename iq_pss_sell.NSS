// Icequeen's Persistent Stores (10/28/08)
//:: Set Store "For Sale"

#include "iq_pbs_db_inc"
#include "iq_pss_db_inc"

void main()
{
object oPC=GetPCSpeaker();
int nGold=FloatToInt(PSGetGold(OBJECT_SELF)*0.95);
PBDeposit(oPC, nGold);	
SendMessageToPC(oPC, IntToString(nGold)+" has been transferred into your bank account!");
SetCampaignString(PSGetStoreID(OBJECT_SELF), "OwnedBy", "Bank");
DelayCommand(0.1, PSSetGold(OBJECT_SELF, 0));
PSSetIsForSale(OBJECT_SELF, TRUE);
PSSetFirstName(OBJECT_SELF, "Unemployed");
return;
}