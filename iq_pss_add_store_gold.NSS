// Icequeen's Persistent Stores (10/28/08)
// add gold to store

#include "iq_pss_db_inc"

void main(int nDeposit)
{
object oPC=GetPCSpeaker();
TakeGoldFromCreature(nDeposit, oPC, TRUE);
int nGold=PSGetGold(OBJECT_SELF)+nDeposit;
DelayCommand(0.1, PSSetGold(OBJECT_SELF, nGold));
DelayCommand(0.1, PSSetLocalInt(OBJECT_SELF, "OldGold", nGold));
SetCustomToken(6003, IntToString(nGold));
SetCustomToken(6004, IntToString(nGold));
SetCustomToken(6005, "0");
}