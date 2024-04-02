//:: Icequeen's Persistent Banking (10/28/08)
//:: Get Player's Bank Balance

#include "iq_pbs_db_inc"

void main()
{
object oPC=GetLastSpeaker();
int nBalance=PBGetBalance(oPC);
string sBalance=IntToString(nBalance);
if (nBalance<1) sBalance="No";
SetCustomToken(1000, sBalance);
}