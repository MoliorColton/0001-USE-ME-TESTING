//:: Icequeen's Persistent Banking (10/28/08)
//:: Set Banker to listen for gold amount

#include "iq_pbs_db_inc"

void main()
{
DeleteLocalString(OBJECT_SELF, "GOLD");
SetListening(OBJECT_SELF, TRUE);
SetListenPattern(OBJECT_SELF, "*n", 1);
}