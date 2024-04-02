//:: Icequeen's Persistent Banking (10/28/08)
//:: Does player have enough gold in their account?

#include "iq_pbs_db_inc"

int StartingConditional()
{
object oPC=GetLastSpeaker();
int nGold=StringToInt(GetLocalString(OBJECT_SELF, "GOLD"));
int nBalance=PBGetBalance(oPC);
return(nBalance>=nGold);
}