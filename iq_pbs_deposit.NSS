//:: Icequeen's Persistent Banking (10/28/08)
//:: Deposit gold into player bank account

#include "iq_pbs_db_inc"

void main()
{
object oPC=GetPCSpeaker();
int nDeposit=StringToInt(GetLocalString(OBJECT_SELF, "GOLD"));
TakeGoldFromCreature(nDeposit, oPC, TRUE);
PBDeposit(oPC, nDeposit);
int nTotal=PBGetBalance(oPC);
string sTotal=IntToString(nTotal);
if (nTotal<1) sTotal="No";
SetCustomToken(1000, sTotal);
}