// Icequeen's Persistent Stores (10/28/08)
//:: PC Buying store with gold on hand

#include "iq_pss_db_inc"

void main()
{
object oPC = GetPCSpeaker();
int nGPPayment = GetLocalInt(OBJECT_SELF, "StorePrice");
if (GetGold(oPC) < nGPPayment)
    {
    SendMessageToPC(oPC,"You do not have enough gold on hand to purchase this store!");
    return;
    }
else
    {
    PSSetIsForSale(OBJECT_SELF, FALSE);
    SendMessageToPC(oPC, "Purchasing Store!");
    TakeGoldFromCreature(nGPPayment, oPC, TRUE);
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