//:: Icequeen's Persistent Banking (10/28/08)
//:: Begin Banker conversation

void main()
{
BeginConversation();
if (GetListenPatternNumber()==1 && GetLastSpeaker()==GetPCSpeaker())
	{
	string sGold=GetMatchedSubstring(0);
	SetLocalString(OBJECT_SELF, "GOLD", sGold);
	SetCustomToken(1000, sGold);
	}
}