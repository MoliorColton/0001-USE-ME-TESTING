//:: Icequeen's Persistent Housing (10/28/08)
//:: PC Buying house with gold on hand

#include "iq_pbs_db_inc"
#include "iq_phs_db_inc"

void main()
{
object oPC = GetPCSpeaker();
int nCampPrice = PHGetCampHousePrice(OBJECT_SELF);
int nLocalPrice = GetLocalInt(OBJECT_SELF, "HousePrice");
int nGPPayment;
string sMDB = PHGetMortgageDatabase(OBJECT_SELF);
string sMAcc = PHGetMortgageAccount(OBJECT_SELF);
int nMortBal = GetCampaignInt(sMDB, sMAcc + "BANK_GOLD");
if (nCampPrice > nLocalPrice) nGPPayment = nCampPrice;
else nGPPayment = nLocalPrice;
if (GetGold(oPC) < nGPPayment)
    {
    SendMessageToPC(oPC,"You do not have enough gold on hand to purchase this house!");
    return;
    }
else
    {
    PHSetIsForSale(OBJECT_SELF, FALSE);
    SendMessageToPC(oPC, "Purchasing house!");
    TakeGoldFromCreature(nGPPayment, oPC, TRUE);
    if (sMDB != "") DelayCommand(0.50, SetCampaignInt(sMDB, sMAcc + "BANK_GOLD", nMortBal + nGPPayment));
    PHSetOwner(OBJECT_SELF, oPC);
    return;
    }
}