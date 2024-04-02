#include "profession_include"


void ThiefStall(object oPC, object oOBJECT, int nTHIEF)
{
	object oPlayer = GetLastUsedBy();
	int nCHECK;
	int nXP = GetLocalInt(oOBJECT, "THIEF_XP");
	if (nXP < 1)
	{
		SendMessageToPC(oPC, "You cannot steal from this.");
		return;
	}
    else
	if (oPlayer == OBJECT_INVALID)
    {
        // error message
        SpeakString("Hey I don't have a player selected!");;
    }
	else
    {
		int nCHECK = GetLocalInt(oOBJECT, "THIEF_REQ");
		if (nCHECK > nTHIEF) SendMessageToPC(oPC, "You need a Thieving level of " + IntToString(nCHECK) + " steal from this.");
		else
		{
			SendMessageToPC(oPC, "You attempt steal...");
			int nGP = GetLocalInt(oOBJECT, "THIEF_GP");
			if (nGP > 0) GiveGoldToCreature(oPC, nGP);
			string sSTEAL = GetLocalString(oOBJECT, "THIEF_ITEM");
			if (sSTEAL != "") CreateItemOnObject(sSTEAL, oPC);
			GiveCraftXP(oPC, SKILL_THIEVING, nXP);
		}
	}
}

