//:: Icequeen's Persistent Banking (10/28/08)
//:: Does player have the amount of gold spoken?

int StartingConditional()
{
return (GetGold(GetPCSpeaker())>=StringToInt(GetLocalString(OBJECT_SELF, "GOLD")));
}