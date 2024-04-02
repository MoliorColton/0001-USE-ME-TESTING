// Icequeen's Persistent Stores (10/28/08)
//:: PC Buying store - Taking gold from bank

#include "iq_pbs_db_inc"
#include "iq_pss_db_inc"

void main()
{
object oPC = GetPCSpeaker();
int nGPPayment=GetLocalInt(OBJECT_SELF, "HousePrice");
int nPCBankBal = PBGetBalance(oPC);
if (nPCBankBal < nGPPayment)
    {
    SendMessageToPC(oPC, "You do not have enough gold in your account to purchase this store!");
    return;
    }
else
    {
    PSSetIsForSale(OBJECT_SELF, FALSE);
    SendMessageToPC(oPC, "Purchasing Store!");
    PBWithdraw(oPC, nGPPayment);
	int nGold=FloatToInt((IntToFloat(nGPPayment)/100)*95);
	PSSetLocalInt(OBJECT_SELF, "OldGold", nGold);
	PSSetGold(OBJECT_SELF, nGold);
	PSSetOwner(OBJECT_SELF, oPC);
	PSSetMarkup(OBJECT_SELF, 50);
	PSSetMarkdown(OBJECT_SELF, 50);
	PSSetFirstName(OBJECT_SELF, GetFirstName(oPC)+"'s");
	return;
    }
}