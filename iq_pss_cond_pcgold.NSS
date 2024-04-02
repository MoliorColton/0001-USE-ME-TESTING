// Icequeen's Persistent Stores (10/28/08)
//:: Does player have the amount of gold?

int StartingConditional(int nDeposit)
{
return (GetGold(GetPCSpeaker())>=nDeposit);
}