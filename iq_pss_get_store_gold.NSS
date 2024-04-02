// Icequeen's Persistent Stores (10/28/08)
// Has the store made profit?

#include "iq_pss_db_inc"

int StartingConditional()
{
int bReturn=FALSE;
int nGold=PSGetGold(OBJECT_SELF);
int nOldGold=GetLocalInt(OBJECT_SELF, "OldGold");
SetCustomToken(6003, IntToString(nGold));
SetCustomToken(6004, IntToString(nOldGold));
SetCustomToken(6005, IntToString(abs(nGold-nOldGold)));
if (nGold>nOldGold) bReturn=TRUE;
return bReturn;
}