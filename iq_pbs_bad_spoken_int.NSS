//:: Icequeen's Persistent Banking (10/28/08)
//:: Did banker hear something other than a valid integer?

int StartingConditional()
{
string sGold=GetLocalString(OBJECT_SELF, "GOLD");
return (sGold=="" || GetStringLength(sGold)>9);
}