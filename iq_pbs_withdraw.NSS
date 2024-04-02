//:: Icequeen's Persistent Banking (10/28/08)
//:: Withdraw funds from player bank account

#include "iq_pbs_db_inc"

void main()
{
object oPC=GetPCSpeaker();
int nWithdraw=StringToInt(GetLocalString(OBJECT_SELF, "GOLD"));
PBWithdraw(oPC, nWithdraw);
GiveGoldToCreature(oPC, nWithdraw);
int nTotal=PBGetBalance(oPC);
string sTotal=IntToString(nTotal);
if (nTotal<1) sTotal="No";
SetCustomToken(1000, sTotal);
}