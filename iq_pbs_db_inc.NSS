//:: Icequeen's Persistent Banking (10/28/08)
// Author: Icequeen6769

#include "iq_func_lib"

// Retrieve Player's Bank Balance
int PBGetBalance(object oPlayer)
{
	string sPDB=SSGetPlayerDatabase(oPlayer);
	string sKey=SSGetCharacterKey(oPlayer);
	return GetCampaignInt(sPDB, sKey + "BANK_GOLD");
}

// Deposit Gold into Player's Bank account
void PBDeposit(object oPlayer, int nDeposit)
{
	string sPDB=SSGetPlayerDatabase(oPlayer);
	string sKey=SSGetCharacterKey(oPlayer);
	int nOldGold=PBGetBalance(oPlayer);
	SetCampaignInt(sPDB, sKey + "BANK_GOLD", nOldGold + nDeposit);
}

// Withdraw Gold from Player's Bank Account
void PBWithdraw(object oPlayer, int nWithdraw)
{
	string sPDB=SSGetPlayerDatabase(oPlayer);
	string sKey=SSGetCharacterKey(oPlayer);
	int nOldGold=PBGetBalance(oPlayer);
	SetCampaignInt(sPDB, sKey + "BANK_GOLD", nOldGold - nWithdraw);
}
// ---------- Retirement Functions ----------

// Remove a character (and all variables pertaining to that character) from Player's database
// Used to "retire" characters
void PBRemoveDatabaseCharacter(object oPC)
{
	string sPDB=SSGetPlayerDatabase(oPC);
	string sKey=SSGetCharacterKey(oPC);
	DeleteCampaignVariable(sPDB, sKey + "BANK_GOLD");
	DelayCommand(1.0, PackCampaignDatabase(sPDB));
}