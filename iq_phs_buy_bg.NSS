//:: Icequeen's Persistent Housing (10/28/08)
//:: PC Buying house - Taking gold from bank

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
int nPCBankBal = PBGetBalance(oPC);
if (nCampPrice > nLocalPrice) nGPPayment = nCampPrice;
else nGPPayment = nLocalPrice;
if (nPCBankBal < nGPPayment)
    {
    SendMessageToPC(oPC, "You do not have enough gold in your account to purchase this house!");
    return;
    }
else
    {
    PHSetIsForSale(OBJECT_SELF, FALSE);
    SendMessageToPC(oPC, "Purchasing house!");
    PBWithdraw(oPC, nGPPayment);
    if (sMDB != "") SetCampaignInt(sMDB, sMAcc + "BANK_GOLD", nMortBal + nGPPayment);
    PHSetOwner(OBJECT_SELF, oPC);
    return;
    }
}