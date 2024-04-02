#include "profession_include"

//Used in conversation for converting rune essences at rune altars.
//nRUNE: The type of altar used.
//	1 = Air, 2 = Mind, 3 = Water, 4 = Earth, 5 = Fire, 6 = Body 7 = Cosmic
//	8 = Chaos, 9 = Astral, 10 = Nature, 11 = Law, 12 = Death, 13 = Blood
//nQTY: The amount of rune essences you wish to convert to rune.

void main(int nQTY)
{
	object oPC = GetPCSpeaker();
	if (GetInventoryNum(oPC) >= 128)
	{
		SendMessageToPC(oPC, "Your inventory is full.");
		return;
	}
	string sRUNE;	
	int nXP;
	int nREQ;
	int nRUNE = GetLocalInt(oPC, "RUNE_ALTAR");
	switch (nRUNE)
	{
		case 01: nREQ = 1; nXP = 10; sRUNE = "Air"; break;
		case 02: nREQ = 2; nXP = 10; sRUNE = "Mind"; break;
		case 03: nREQ = 5; nXP = 12; sRUNE = "Water"; break;
		case 04: nREQ = 9; nXP = 14; sRUNE = "Earth"; break;
		case 05: nREQ = 14; nXP = 14; sRUNE = "Fire"; break;
		case 06: nREQ = 20; nXP = 16; sRUNE = "Body"; break;
		case 07: nREQ = 27; nXP = 16; sRUNE = "Cosmic"; break;
		case 08: nREQ = 35; nXP = 18; sRUNE = "Chaos"; break;
		case 09: nREQ = 40; nXP = 18; sRUNE = "Astral"; break;
		case 10: nREQ = 44; nXP = 20; sRUNE = "Nature"; break;
		case 11: nREQ = 10; nXP = 30; sRUNE = "Law"; break;
		case 12: nREQ = 40; nXP = 40; sRUNE = "Death"; break;
		case 13: nREQ = 50; nXP = 50; sRUNE = "Blood"; break;
		default: SendMessageToPC(oPC, "ERROR"); return;
	}
	int nLVL = GetSkillRank(SKILL_RUNECRAFTING, oPC, TRUE);
	if (nLVL < nREQ)
	{
		SendMessageToPC(oPC, "You don't have the required ranks in Runecrafting (" + IntToString(nREQ) + ") to make runes of this type.");
		return;
	}
	string sESSENCE = "runeessence";
	effect eVFX = EffectNWN2SpecialEffectFile("fx_runecrafting");
	if (nRUNE > 8) sESSENCE = "pureessence";
	int nMULT = 1 + nLVL / (11 + 2 * (nREQ - 1));
	int nTOT = GetItemQuantity(oPC, sESSENCE);
	if (nTOT < nQTY) nQTY = nTOT;
	if (nQTY < 1) return;
	GiveCraftXP(oPC, SKILL_RUNECRAFTING, nXP * nQTY);
	RemoveItems(oPC, sESSENCE, nQTY, FALSE);
	nQTY = nQTY * nMULT;
	SendMessageToPC(oPC, "You have successfully created " + IntToString(nQTY) + " " + sRUNE + " runes.");
	ReallyPlaySound(GetLocation(oPC), "Runecrafting");
	ReallyPlayCustomAnimation(oPC, "mjr_conjure", FALSE);
	sRUNE = GetStringLowerCase(sRUNE) + "rune";
	
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oPC, 1.5);
	
	while (nQTY > 0)
	{	
		CreateItemOnObject(sRUNE, oPC, nQTY, "", FALSE);
		nQTY = nQTY - 10000;
	}
}