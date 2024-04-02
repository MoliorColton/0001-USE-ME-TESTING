//::////////////////////////////////////
//:: MoliorRS OnItemActivate Script ////
//::////////////////////////////////////

#include "nw_i0_spells"
#include "x2_inc_switches"
#include "profession_include"
#include "summoned_table"
#include "table_farming"



void RenewFire(object oFIRE, int nLIGHT, string sFLAME, float fDUR)
{
	effect eFLAME = EffectSilence();
	eFLAME = EffectLinkEffects(eFLAME, EffectVisualEffect(nLIGHT));
	eFLAME = EffectLinkEffects(eFLAME, EffectNWN2SpecialEffectFile(sFLAME));
	eFLAME = SupernaturalEffect(eFLAME);
	eFLAME = SetEffectSpellId(eFLAME, -10);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFLAME, oFIRE, fDUR);
}


void UseRuneSack(object oPC)
{
	// very basic and dumb way to check if the player has 4 free inventory slots
	// will add a function later to instead check if the player has runes already and ignore if the player does not have enough slots
	// but this works for now. 
    int maxInvSize = 128;
    int currentInvSize = GetInventoryNum(oPC);
    int freeSpace = maxInvSize - currentInvSize;
    if (freeSpace < 4)
    {
        SendMessageToPC(oPC, "You need at least 4 free inventory spaces.");
        return;
    }
	// establishing the min and max number of runes to give.
 	int nChaosRuneMin = 100;
    int nChaosRuneMax = 200;
    int nDeathRuneMin = 100;
    int nDeathRuneMax = 200;
    int nBloodRuneMin = 50;
    int nBloodRuneMax = 100;
    int nSoulRuneMin = 25;
    int nSoulRuneMax = 50;
    //randomness function within the min and max rune integer constraints
	int nChaosRune = Random(nChaosRuneMax - nChaosRuneMin + 1) + nChaosRuneMin;
	int nDeathRune = Random(nDeathRuneMax - nDeathRuneMin + 1) + nDeathRuneMin;
	int nBloodRune = Random(nBloodRuneMax - nBloodRuneMin + 1) + nBloodRuneMin;
	int nSoulRune = Random(nSoulRuneMax - nSoulRuneMin + 1) + nSoulRuneMin;
    // Giving the player the runes
    CreateItemOnObject("chaosrune", oPC, nChaosRune);
    CreateItemOnObject("deathrune", oPC, nDeathRune);
    CreateItemOnObject("bloodrune", oPC, nBloodRune);
    CreateItemOnObject("soulrune", oPC, nSoulRune);
}

void UseHerbSack(object oPC)
{
	// very basic and dumb way to check if the player has 4 free inventory slots
	// will add a function later to instead check if the player has runes already and ignore if the player does not have enough slots
	// but this works for now. 
    int maxInvSize = 128;
    int currentInvSize = GetInventoryNum(oPC);
    int freeSpace = maxInvSize - currentInvSize;
    if (freeSpace < 4)
    {
        SendMessageToPC(oPC, "You need at least 4 free inventory spaces.");
        return;
    }
	// establishing the min and max number of runes to give.
 	int nChaosRuneMin = 100;
    int nChaosRuneMax = 200;
    int nDeathRuneMin = 100;
    int nDeathRuneMax = 200;
    int nBloodRuneMin = 50;
    int nBloodRuneMax = 100;
    int nSoulRuneMin = 25;
    int nSoulRuneMax = 50;
    //randomness function within the min and max rune integer constraints
	int nChaosRune = Random(nChaosRuneMax - nChaosRuneMin + 1) + nChaosRuneMin;
	int nDeathRune = Random(nDeathRuneMax - nDeathRuneMin + 1) + nDeathRuneMin;
	int nBloodRune = Random(nBloodRuneMax - nBloodRuneMin + 1) + nBloodRuneMin;
	int nSoulRune = Random(nSoulRuneMax - nSoulRuneMin + 1) + nSoulRuneMin;
    // Giving the player the runes
    CreateItemOnObject("chaosrune", oPC, nChaosRune);
    CreateItemOnObject("deathrune", oPC, nDeathRune);
    CreateItemOnObject("bloodrune", oPC, nBloodRune);
    CreateItemOnObject("soulrune", oPC, nSoulRune);
}

void UseLogs(object oPC, object oLOG, object oFIRE)
{
	    // Check if oFIRE is a valid object
    if (!GetIsObjectValid(oFIRE) || GetTag(oFIRE) != "bonfire")
    {
        SendMessageToPC(oPC, "You can only do that on a bonfire.");
        return;
    }
    if (GetLocalInt(oFIRE, "EXTINCT") == TRUE)
    {
        SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + "You may add logs only to bonfires that are still burning.");
        return;
    }
    float fDUR;
    int nXP;
    int nLVL;
    effect eVFX;
    int nLIGHT = VFX_DUR_LIGHT_YELLOW_20;
    string sLOG = GetTag(oLOG);
    int nTYPE = StringToInt(GetStringRight(sLOG, 2));
    string sFLAME = "fx_bonfire";
    switch (nTYPE)
    {
        case 01: nLVL = 1; nXP = 40; fDUR = 45.0; break; //Normal Logs
        case 02: nLVL = 15; nXP = 60; fDUR = 60.0; break; //Oak Logs
        case 03: nLVL = 30; nXP = 90; fDUR = 90.0; break; //Willow Logs
        case 04: nLVL = 45; nXP = 135; fDUR = 120.0; break; //Maple Logs
        case 05: nLVL = 60; nXP = 203; fDUR = 240.0; break; //Yew Logs
        case 06: nLVL = 75; nXP = 304; fDUR = 480.0; nLIGHT = VFX_DUR_LIGHT_BLUE_20; sFLAME = "fx_nshore_bonfire"; break; //Magic Logs
        default: return;
    }
    if (GetSkillRank(SKILL_FIREMAKING, oPC) < nLVL)
    {
        SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + "You need to have " + IntToString(nLVL) + " levels in Firemaking to make a fire out of " + GetName(oLOG) + ".");
        return;
    }
    GiveCraftXP(oPC, SKILL_FIREMAKING, nXP);
    int nSTACK = GetItemStackSize(oLOG);
    if (nSTACK > 1) SetItemStackSize(oLOG, nSTACK - 1);
    else DestroyObject(oLOG);
    location lPC = GetLocation(oPC);
    ReallyPlaySound(lPC, "Firemaking");
    RemoveEffectsFromSpell(oFIRE, -10);
    DelayCommand(0.0f, RenewFire(oFIRE, nLIGHT, sFLAME, fDUR));
    eVFX = EffectNWN2SpecialEffectFile("fx_firemaking");
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oPC, 1.5);
}


void UseTinderbox(object oPC, object oLOG)


{

	if (GetItemPossessor(oLOG) != oPC) return;
	string sLOG = GetTag(oLOG);
	if (GetStringLeft(sLOG, 4) != "logs") return;
	float fDUR;
	int nXP;
	int nLVL;
	int nLIGHT = VFX_DUR_LIGHT_YELLOW_20;
	int nTYPE = StringToInt(GetStringRight(sLOG, 2));
	string sFLAME = "fx_bonfire";
	switch (nTYPE)
	{
		case 01: nLVL = 1; nXP = 40; fDUR = 45.0; break; //Normal Logs
		case 02: nLVL = 15; nXP = 60; fDUR = 60.0; break; //Oak Logs
		case 03: nLVL = 30; nXP = 90; fDUR = 90.0; break; //Willow Logs
		case 04: nLVL = 45; nXP = 135; fDUR = 120.0; break; //Maple Logs
		case 05: nLVL = 60; nXP = 203; fDUR = 240.0; break; //Yew Logs
		case 06: nLVL = 75; nXP = 304; fDUR = 480.0; nLIGHT = VFX_DUR_LIGHT_BLUE_20; sFLAME = "fx_nshore_bonfire"; break; //Magic Logs
		default: return;
	}
	int nCOUNT;
	int nFOUND;
	object oINVALID = OBJECT_INVALID;
	object oFIRE = GetObjectByTag("bonfire");
	while (oFIRE != oINVALID)
	{
		if (GetLocalObject(oFIRE, "FIRE_OWNER") == oPC)
		{
			nFOUND = TRUE;
			break;
		}
		nCOUNT = nCOUNT + 1;
		oFIRE = GetObjectByTag("bonfire", nCOUNT);
	}
	if (nFOUND == TRUE)
	{
		SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + "You already have set a bonfire somewhere. Either use logs on it to renew the flame or wait for it to disappear.");
		return;
	}
	if (GetSkillRank(SKILL_FIREMAKING, oPC) < nLVL)
	{
		SendMessageToPC(oPC, HSS_FEEDBACK_COLOUR + "You need to have " + IntToString(nLVL) + " levels in Firemaking to burn " + GetName(oLOG) + ".");
		return;
	}
	
	int nSTACK = GetItemStackSize(oLOG);
	effect eVFX;
	if (nSTACK > 1) SetItemStackSize(oLOG, nSTACK - 1);
	else DestroyObject(oLOG);
	location lPC = GetLocation(oPC);
	oFIRE = CreateObject(OBJECT_TYPE_PLACEABLE, "bonfire", lPC, TRUE);
	ReallyPlaySound(lPC, "Firemaking");	
	effect eFLAME = EffectVisualEffect(nLIGHT);
	eFLAME = EffectLinkEffects(eFLAME, EffectNWN2SpecialEffectFile(sFLAME));
	eFLAME = SupernaturalEffect(eFLAME);
	eFLAME = SetEffectSpellId(eFLAME, -10);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFLAME, oFIRE, fDUR);
	SetLocalObject(oFIRE, "FIRE_OWNER", oPC);
	SetCustomHeartbeat(oFIRE, 5000);
	GiveCraftXP(oPC, SKILL_FIREMAKING, nXP);
	eVFX = EffectNWN2SpecialEffectFile("fx_firemaking");
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oPC, 1.5);

}
 
void UseShears(object oPC, string sTARGET)
{
	if (GetLocalInt(oPC, "SHEARS") == TRUE) SendMessageToPC(oPC, "You need to wait 10 seconds before you can use this item again.");
	else if (sTARGET == "sheep")
	{
		SetLocalInt(oPC, "SHEARS", TRUE);
		if (d100() > 49) CreateItemOnObject("ballofwool", oPC);
		else SendMessageToPC(oPC, "You failed to collect a ball of wool. (50% chance)");
		DelayCommand(10.0, DeleteLocalInt(oPC, "SHEARS"));	
	}
}

void BuryBones(object oPC, string sITEM)
{
	effect eVFX;
	int nXP = 5;
	if (GetStringLeft(sITEM, 3) == "big") nXP = 15;
	else if (GetStringLeft(sITEM, 6) == "dragon") nXP = 72;
	else if (GetStringLeft(sITEM, 3) == "bat") nXP = 10;
	else if (GetStringLeft(sITEM, 5) == "jogre") nXP = 15;
	else if (GetStringLeft(sITEM, 4) == "wolf") nXP = 5;
	GiveCraftXP(oPC, SKILL_PRAYER, nXP);
	eVFX = EffectNWN2SpecialEffectFile("fx_prayer");
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oPC, 1.5);
}

void PrayerPotion(object oPC, string sITEM)
{
	object oESSENCE = GetItemPossessedBy(oPC, "player_essence");
	int nRESTORE = StringToInt(GetStringRight(sITEM, 2));
	int nPRAY = GetSkillRank(SKILL_PRAYER, oPC, TRUE);
	int nPOINTS = GetLocalInt(oESSENCE, "PRAYER_POINTS");
	int nNEW = nPOINTS + nRESTORE;
	if (nNEW > nPRAY) nNEW = nPRAY;
	SetLocalInt(oESSENCE, "PRAYER_POINTS", nNEW);
}

void PlantSeed(object oPC, object oITEM, string sITEM)

{


	object oAREA = GetArea(oPC);
	if (GetIsAreaNatural(oAREA) != AREA_NATURAL)
	{
		SendMessageToPC(oPC, "Seeds can be planted only in natural areas.");
		return;
	}
	if (GetIsAreaInterior(oAREA) == TRUE)
	{
		SendMessageToPC(oPC, "Seeds cannot be planted in underground or interior areas.");
		return;
	}
	string sSEED = GetStringRight(sITEM, 3);
	int nSEED = StringToInt(sSEED);
	RetrieveProperPlant(oPC, oITEM, nSEED);

	
}

void Compost(object oPC, object oITEM, object oPLANT)
{
    int nSTAGE = GetLocalInt(oPLANT, "PLANT_STAGE");
    if (nSTAGE != 1)
    {
        SendMessageToPC(oPC, "Composts may be used only on plants that are not growing yet.");
        return;
    }

    int nSUPER = GetLocalInt(oITEM, "SUPER");
    float fTIME = GetLocalFloat(oPLANT, "PLANT_TIME");
    if (nSUPER == 1) fTIME = fTIME / 2.0;
    
    // Set the stage to 2 immediately
    SetLocalInt(oPLANT, "PLANT_STAGE", 2);

    // Remove the "fx_needscompost" effect instantly
    RemoveSEFFromObject(oPLANT, "fx_needscompost");

    // Schedule the change to stage 3 after the specified time
    DelayCommand(fTIME, SetLocalInt(oPLANT, "PLANT_STAGE", 3));
    FloatingTextStringOnCreature("This plant is now growing. It will take " + FloatToString(fTIME, 18, 0) + " seconds before it can be harvested.", oPC, FALSE);

    int nITEM = GetItemStackSize(oITEM);
    if (nITEM > 1) SetItemStackSize(oITEM, nITEM - 1);
    else DestroyObject(oITEM);
}


void PlantCure(object oPC, object oITEM, object oPLANT)
{
	if (GetLocalInt(oPLANT, "PLANT_STAGE") != 4)
	{
		SendMessageToPC(oPC, "Plant Cures may be used only on ill plants.");
		return;
	}
	int nITEM = GetItemStackSize(oITEM);
	if (nITEM > 1) SetItemStackSize(oITEM, nITEM - 1);
	else DestroyObject(oITEM);
	HarvestPlant(oPC, oPLANT);
}

void Henchman(object oPC, string sITEM)
{
	SendMessageToPC(oPC, "DEBUG_HENCH_01");
	string sTYPE = GetStringRight(sITEM, 3);
	int nTYPE = StringToInt(sTYPE);
	string sHENCH = RetrieveSummonedCreature(nTYPE, 1);
	object oHENCH = GetHenchman(oPC);
	if (oHENCH != OBJECT_INVALID)
	{
		RemoveHenchman(oPC, oHENCH);
		DestroyObject(oHENCH);
		if (GetTag(oHENCH) == sHENCH) return;
	}
	oHENCH = CreateObject(OBJECT_TYPE_CREATURE, sHENCH, GetLocation(oPC));
	DelayCommand(0.0f, AddHenchman(oPC, oHENCH));
}

void SummonPet2(object oPC, string sPET)
{
	location lPET = CalcSafeLocation(oPC, GetLocation(oPC), RADIUS_SIZE_COLOSSAL, TRUE, TRUE);
	effect eFX = EffectSummonCreature(sPET);
	eFX = SupernaturalEffect(eFX);
	ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eFX, lPET);
}

void SummonPet(object oPC, string sITEM)
{
	string sTYPE = GetStringRight(sITEM, 3);
	int nTYPE = StringToInt(sTYPE);
	string sPET = RetrieveSummonedCreature(nTYPE);
	AssignCommand(oPC, SummonPet2(oPC, sPET));
}

void Pickpocket(object oPC, object oTARGET, int nTHIEF)
{
	int nXP = GetLocalInt(oTARGET, "THIEF_XP");
	if (nXP < 1)
	{
		SendMessageToPC(oPC, "This creature cannot be pickpocketed.");
		return;
	}
	string sTHIEF = GetBicFileName(oPC);
	if (sTHIEF == "") return;
	if (GetLocalInt(oTARGET, sTHIEF) == TRUE)
	{
		SendMessageToPC(oPC, "You have already pickpocketed this creature.");
		return;
	}
	int nCHECK = GetLocalInt(oTARGET, "THIEF_REQ");
	if (nCHECK > nTHIEF)
	{
		SendMessageToPC(oPC, "You need a Thieving level of " + IntToString(nCHECK) + ".");
		return;
	}
	ReallyPlayCustomAnimation(oPC, "search");
	int nSUCCESS = 50 + (nTHIEF - nCHECK) * 2;
	if (Random(100) >= nSUCCESS)
	{
		int nDMG = GetMaxHitPoints(oPC) / 10;
		effect eDAMAGE = EffectDamage(nDMG, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_NORMAL, TRUE);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDAMAGE, oPC);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), oPC, 5.0);
		SendMessageToPC(oPC, "Your pickpocket attempt failed!");
		return;
	}
	SetLocalInt(oTARGET, sTHIEF, TRUE);
	int nGP = GetLocalInt(oTARGET, "THIEF_GP");
	if (nGP > 0) GiveGoldToCreature(oPC, nGP);
	int nSTEAL = GetLocalInt(oTARGET, "THIEF_TOTAL");
	if (nSTEAL < 1) nSTEAL = 1;
	int nROLL = Random(nSTEAL);
	string sSTEAL = GetLocalString(oTARGET, "THIEF_ITEM_" + IntToString(nROLL));
	if (sSTEAL != "") CreateItemOnObject(sSTEAL, oPC);
	GiveCraftXP(oPC, SKILL_THIEVING, nXP);
	float fRESPAWN = GetLocalFloat(oTARGET, "THIEF_RESPAWN");
	if (fRESPAWN > 0.0f) DelayCommand(fRESPAWN, DeleteLocalInt(oTARGET, sTHIEF));
}
//::////////////////////////////////////
//:: theiving stalls START ////
//::////////////////////////////////////




void ThiefSteal(object oPC, object oOBJECT, int nTHIEF)
{
	int nCHECK;
	int nXP = GetLocalInt(oOBJECT, "THIEF_XP");
	if (nXP < 1)
	{
		SendMessageToPC(oPC, "You cannot steal from this.");
		return;
	}


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


void Thievery(object oPC, object oTARGET)
{
	if (GetIsPC(oPC) == FALSE) return;
	int nTHIEF = GetSkillRank(SKILL_THIEVING, oPC);
	int nTYPE = GetObjectType(oTARGET);
	switch (nTYPE)
	{
		case OBJECT_TYPE_CREATURE: Pickpocket(oPC, oTARGET, nTHIEF); break;
		case OBJECT_TYPE_DOOR: ThiefSteal(oPC, oTARGET, nTHIEF); break;
		case OBJECT_TYPE_PLACEABLE: ThiefSteal(oPC, oTARGET, nTHIEF); break;
		case OBJECT_TYPE_TRIGGER: ThiefSteal(oPC, oTARGET, nTHIEF); break;
	}
}

void main()
{
	object oMOD = GetModule();
	object oPC = GetItemActivator();
	object oITEM = GetItemActivated();
	object oTARGET = GetItemActivatedTarget();
	string sITEM = GetTag(oITEM);
	string sTARGET = GetTag(oTARGET);
	

	
	//Healing from Food and other tag based scripts
	float fHEAL = GetLocalFloat(oITEM, "healAmt");
	if (fHEAL > 0.0)
	{
		int nHEAL = FloatToInt(fHEAL);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHEAL), oPC, 0.0);
	}
	

	
	else if (GetStringLeft(sITEM, 9) == "henchman_") Henchman(oPC, sITEM);
	else if (GetStringLeft(sITEM, 11) == "summoncomp_") SummonPet(oPC, sITEM);
	else if (sITEM == "thieftools") Thievery(oPC, oTARGET);
	else if (GetStringLeft(sITEM, 5) == "seed_") PlantSeed(oPC, oITEM, sITEM);
	else if (GetStringRight(sITEM, 7) == "compost") Compost(oPC, oITEM, oTARGET);
	else if (sITEM == "plantcure") PlantCure(oPC, oITEM, oTARGET);
	else if (GetStringLeft(sITEM, 4) == "logs") UseLogs(oPC, oITEM, oTARGET);
	else if (sITEM == "slayerrunesack") UseRuneSack(oPC);
	else if (sITEM == "slayerherbsack") UseHerbSack(oPC);
	else if (sITEM == "tinderbox") UseTinderbox(oPC, oTARGET);
	else if (sITEM == "shears") UseShears(oPC, sTARGET);
	else if (GetStringRight(sITEM, 5) == "bones") BuryBones(oPC, sITEM);
	else if (GetStringLeft(sITEM, 14) == "prayer_potion_") PrayerPotion(oPC, sITEM);
	else if (sITEM == "knife") DisplayGuiScreen(oPC, "SCREEN_FLETCHM_1", FALSE, "fletchingmenu.xml");
	else if (sITEM == "chisel") DisplayGuiScreen(oPC, "CHISELMENU", FALSE, "chiselmenu.xml");
	else if (sITEM == "needle") DisplayGuiScreen(oPC, "NEEDLEMENU", FALSE, "needlemenu.xml");
	else if (sITEM == "vialofwater") DisplayGuiScreen(oPC, "HERBMIXMENU", FALSE, "herbmix.xml");
	else if (sITEM == "knife") DisplayGuiScreen(oPC, "SCREEN_FLETCHM_1", FALSE, "fletchingmenu.xml");
	else if (sITEM == "pizzabase") DisplayGuiScreen(oPC, "SCREEN_DOUGH_1", FALSE, "doughmenu.xml");	
	else if (sITEM == "pastrydough") DisplayGuiScreen(oPC, "SCREEN_DOUGH_1", FALSE, "doughmenu.xml");
	else if (sITEM == "breaddough") DisplayGuiScreen(oPC, "SCREEN_DOUGH_1", FALSE, "doughmenu.xml");
	else if (sITEM == "bowstring") DisplayGuiScreen(oPC, "BOWSTRINGMENEU", FALSE, "stringingmenu.xml");
	else if (sITEM == "arrowshaft") DisplayGuiScreen(oPC, "ARROWSMENU", FALSE, "arrowsmenu.xml");
	else if (sITEM == "headlessarrows") DisplayGuiScreen(oPC, "TIPPINGMENU", FALSE, "tippingmenu.xml");
	else if (sITEM == "sapphirebolttips") DisplayGuiScreen(oPC, "BOLTTIPPING", FALSE, "bolttippingmenu.xml");
	else if (sITEM == "emeraldbolttips") DisplayGuiScreen(oPC, "BOLTTIPPING", FALSE, "bolttippingmenu.xml");
	else if (sITEM == "rubybolttips") DisplayGuiScreen(oPC, "BOLTTIPPING", FALSE, "bolttippingmenu.xml");
	else if (sITEM == "diamondbolttips") DisplayGuiScreen(oPC, "BOLTTIPPING", FALSE, "bolttippingmenu.xml");
	else if (sITEM == "dragonstonebolttips") DisplayGuiScreen(oPC, "BOLTTIPPING", FALSE, "bolttippingmenu.xml");
	else if (sITEM == "normalstock") DisplayGuiScreen(oPC, "CBOWMAKING", FALSE, "cbowmenu.xml");	
	else if (sITEM == "oakstock") DisplayGuiScreen(oPC, "CBOWMAKING", FALSE, "cbowmenu.xml");	
	else if (sITEM == "willowstock") DisplayGuiScreen(oPC, "CBOWMAKING", FALSE, "cbowmenu.xml");	
	else if (sITEM == "maplestock") DisplayGuiScreen(oPC, "CBOWMAKING", FALSE, "cbowmenu.xml");	
	else if (sITEM == "yewstock") DisplayGuiScreen(oPC, "CBOWMAKING", FALSE, "cbowmenu.xml");
	else if (sITEM == "magicstock") DisplayGuiScreen(oPC, "CBOWMAKING", FALSE, "cbowmenu.xml");	
	else if (sITEM == "feathers") DisplayGuiScreen(oPC, "ARROWSMENU", FALSE, "arrowsmenu.xml");	
	else if (sITEM == "waterring") DisplayGuiScreen(oPC, "WATERMENU", FALSE, "watermenu.xml"); 
    else if (sITEM == "guamunf") DisplayGuiScreen(oPC, "HERBMIXMENU", FALSE, "herbmix.xml");    
    else if (sITEM == "harrpotionunf") DisplayGuiScreen(oPC, "HERBMIXMENU", FALSE, "herbmix.xml");    
    else if (sITEM == "marrpotionunf") DisplayGuiScreen(oPC, "HERBMIXMENU", FALSE, "herbmix.xml");    
    else if (sITEM == "ranpotionunf") DisplayGuiScreen(oPC, "HERBMIXMENU", FALSE, "herbmix.xml");    
    else if (sITEM == "tarrpotionunf") DisplayGuiScreen(oPC, "HERBMIXMENU", FALSE, "herbmix.xml");
	else if (sITEM == "bookofhelp") DisplayGuiScreen(oPC, "HELPBOOKMENU", FALSE, "helpbook.xml");
	else if (sITEM == "toolbelt") DisplayGuiScreen(oPC, "TOOLBELTMENUU", FALSE, "toolbeltmenu.xml");
	else if (sITEM == "ballofwool") DisplayGuiScreen(oPC, "NEEDLEMENU", FALSE, "needlemenu.xml");
	else if (sITEM == "mortarandpestle") DisplayGuiScreen(oPC, "PESTLEMORTitemactiAR", FALSE, "pestlemortarmenu.xml");
	else if (sITEM == "bowlofwater") DisplayGuiScreen(oPC, "BOWLOFWATER", FALSE, "bowlofwater.xml");
	else if (sITEM == "jugofwater") DisplayGuiScreen(oPC, "JUGOFWATER", FALSE, "jugtofwater.xml");
    else if (sITEM == "bucketofwater") DisplayGuiScreen(oPC, "BUCKETOFWATER", FALSE, "bucketofwater.xml");
	else if (sITEM == "glassblowingpipe") DisplayGuiScreen(oPC, "GLASSBLOWING", FALSE, "glassblowing.xml");
	else if (sITEM == "unpoweredorb") DisplayGuiScreen(oPC, "STAFFMAKING", FALSE, "staffmaking.xml");
	else if (sITEM == "airorb") DisplayGuiScreen(oPC, "STAFFMAKING", FALSE, "staffmaking.xml");
	else if (sITEM == "waterorb") DisplayGuiScreen(oPC, "STAFFMAKING", FALSE, "staffmaking.xml");
	else if (sITEM == "earthorb") DisplayGuiScreen(oPC, "STAFFMAKING", FALSE, "staffmaking.xml");
	else if (sITEM == "fireorb") DisplayGuiScreen(oPC, "STAFFMAKING", FALSE, "staffmaking.xml");
	else if (sITEM == "gstonecutter") DisplayGuiScreen(oPC, "GEMAUTOCUTTERMENU", FALSE, "gemstoneautcutter.xml");
	else if (sITEM == "qgthazelscroll") DisplayGuiScreen(oPC, "GRANDTREESCROLL1", FALSE, "qgtscroll1.xml"); 
	else if (sITEM == "flightedogrearrow") DisplayGuiScreen(oPC, "TIPPINGMENU", FALSE, "tippingmenu.xml");

	else   
	{
		// Auto-Generated by Legends Master Configurator 1.92
		ExecuteScript("leg_all_mastermod_itemactivated", oMOD);
		ExecuteScript("itemconvo", oITEM);
	}

	//Default NWN2 tag based scripts
	if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE)
	{
		SetUserDefinedItemEventNumber(X2_ITEM_EVENT_ACTIVATE);
		int nRet = ExecuteScriptAndReturnInt(GetUserDefinedItemEventScriptName(oITEM), oMOD);
		//if (nRet == X2_EXECUTE_SCRIPT_END) return;
	}
}