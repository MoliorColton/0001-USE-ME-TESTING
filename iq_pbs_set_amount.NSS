//:: Icequeen's Persistent Banking (10/28/08)
//:: Set Token to amount spoken by PC

void main()
{
SetListening(OBJECT_SELF, FALSE);
SetCustomToken(1000, GetLocalString(OBJECT_SELF, "GOLD"));
}