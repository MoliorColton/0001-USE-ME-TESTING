#include "nw_i0_spells"
#include "profession_include"

const int FX_EQUIP = -9004;

// Will return a linked chain of EffectDamageIncrease()
effect DamageIncrease(int nDAMAGE, int DAMAGE_TYPE){
	effect eLINK = EffectDamageIncrease(5, DAMAGE_TYPE);
	nDAMAGE = nDAMAGE - 5;
	for (nDAMAGE; nDAMAGE>=5; nDAMAGE = nDAMAGE-5){
		eLINK = EffectLinkEffects(eLINK, EffectDamageIncrease(5, DAMAGE_TYPE));
	}
	for (nDAMAGE; nDAMAGE>=4; nDAMAGE = nDAMAGE-4){
		eLINK = EffectLinkEffects(eLINK, EffectDamageIncrease(4, DAMAGE_TYPE));
	}
	for (nDAMAGE; nDAMAGE>=3; nDAMAGE = nDAMAGE-3){
		eLINK = EffectLinkEffects(eLINK, EffectDamageIncrease(3, DAMAGE_TYPE));
	}
	for (nDAMAGE; nDAMAGE>=2; nDAMAGE = nDAMAGE-2){
		eLINK = EffectLinkEffects(eLINK, EffectDamageIncrease(2, DAMAGE_TYPE));
	}
	for (nDAMAGE; nDAMAGE>=1; nDAMAGE = nDAMAGE-1){
		eLINK = EffectLinkEffects(eLINK, EffectDamageIncrease(1, DAMAGE_TYPE));
	}
	return eLINK;
}

void PopEffects(object oPC, int nEFFECT_TYPE){
	effect eLoop = GetFirstEffect(oPC);
	while(GetIsEffectValid(eLoop)){
		if(GetEffectType(eLoop) == nEFFECT_TYPE)
			RemoveEffect(oPC, eLoop);
		eLoop = GetNextEffect(oPC);
	}
}

void UpdateEffects(object oPC){
    PopEffects(oPC, EFFECT_TYPE_DAMAGE_INCREASE);
    object oMAINHAND =     GetItemInSlot(4, oPC);
    int nDAMAGE_BUFF =     0;
    
    int nCOMBAT_STYLE =     GetLocalInt(oMAINHAND, "STYLE");
    int i;
    object oITEM;
    for (i=1; i<15; i++){
        oITEM = GetItemInSlot(i, oPC);
        if (GetLocalInt(oITEM, "STYLE") == nCOMBAT_STYLE || GetLocalInt(oITEM, "STYLE") == 4){
            nDAMAGE_BUFF = nDAMAGE_BUFF + GetLocalInt(oITEM, "DAMAGE_BONUS");
        }
    }
    if (nCOMBAT_STYLE !=3 && nCOMBAT_STYLE !=0){
        int DAMAGE_TYPE;
        if (nCOMBAT_STYLE == 1) DAMAGE_TYPE = DAMAGE_TYPE_SLASHING;
        else if (nCOMBAT_STYLE == 2) DAMAGE_TYPE = DAMAGE_TYPE_PIERCING;
        if (nDAMAGE_BUFF > 0){
            effect eDAMAGE_BONUS = DamageIncrease(nDAMAGE_BUFF, DAMAGE_TYPE);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDAMAGE_BONUS, oPC);
        }
    }
    if (nCOMBAT_STYLE == 3){
        SetLocalFloat(oPC, "SPELL_DAMAGE", 1.0+(IntToFloat(nDAMAGE_BUFF)/100));
    }
    else DeleteLocalFloat(oPC, "SPELL_DAMAGE");
}


void SpellResistanceFix(object oPC, string s2DA = "iprp_srcost", string sCOL = "Value")
{
	object oITEM;
	int nEQUIP;
	int nSR;
	int nMAX;
	int nTYPE;
	int nTABLE;
	int nCACHE = GetNum2DARows(s2DA);
	itemproperty iPROP;
	while (nEQUIP < 18)
	{
		oITEM = GetItemInSlot(nEQUIP, oPC);
		if (GetItemHasItemProperty(oITEM, ITEM_PROPERTY_SPELL_RESISTANCE) == TRUE)
		{
			iPROP = GetFirstItemProperty(oITEM);
			while (GetIsItemPropertyValid(iPROP))
			{
				nTYPE = GetItemPropertyType(iPROP);
				if (nTYPE == ITEM_PROPERTY_SPELL_RESISTANCE)
				{
					nTABLE = GetItemPropertyCostTableValue(iPROP);
					nSR = StringToInt(Get2DAString(s2DA, sCOL, nTABLE));
					if (nSR > nMAX)	nMAX = nSR;
				}
				iPROP = GetNextItemProperty(oITEM);
			}
		}
		nEQUIP = nEQUIP + 1;
	}
	if (nMAX < 1) return;
	effect eSR = EffectSpellResistanceIncrease(nMAX);
	eSR = SupernaturalEffect(eSR);
	eSR = SetEffectSpellId(eSR, FX_EQUIP);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSR, oPC);
}

int CheckRequirements(object oPC, object oITEM)
{
	string sFEED;
	
	//Quest requirements
	string sQUEST = GetLocalString(oITEM, "quest_id");
	if (sQUEST != "")
	{
		string sNAME = GetLocalString(oITEM, "quest_name");
		int nSTATE = GetLocalInt(oITEM, "quest_state");
		if (GetJournalEntry(sQUEST, oPC) < nSTATE)
		{
			sFEED = "You must have completed the " + sNAME + " quest to be able to equip this item.";
			SendMessageToPC(oPC, sFEED);
			return FALSE;
		}
	}
	
	//Skill ranks requirements
	int nSKILL = GetLocalInt(oITEM, "skill_id");
	if (nSKILL > 0)
	{
		int nRANK = GetLocalInt(oITEM, "skill_rank");
		if (GetSkillRank(nSKILL, oPC) < nRANK)
		{
			string sPROF = ConvertProfIDToName(nSKILL);
			sFEED = "You need at least " + IntToString(nRANK) + " ranks in " + sPROF + " profession to be able to wear this item.";
			SendMessageToPC(oPC, sFEED);
			return FALSE;
		}
	}
	string sAREA = GetTag(GetArea(oPC));
	if (sAREA == "431arena"){
		SendMessageToPC(oPC, "Oi, no equipping armour or weapons during the fight. That's cheating!");
		return FALSE;
	}
		
	
	//Level or class level requirements
	int nLVL = GetLocalInt(oITEM, "level");
	if (nLVL < 1) return TRUE;
	string sCLASS;
	string sVAR = "class";
	int nCLASS;
	int nCOUNT;
	while (nCOUNT < 4)
	{
		if (nCOUNT > 0) sVAR = "class" + IntToString(nCOUNT);
		sCLASS = GetLocalString(oITEM, sVAR);
		if (sCLASS == "fighter") nCLASS = CLASS_TYPE_FIGHTER;
		else if (sCLASS == "ranger") nCLASS = CLASS_TYPE_RANGER;
		else if (sCLASS == "wizard") nCLASS = CLASS_TYPE_WIZARD;
		else if (sCLASS == "rogue") nCLASS = CLASS_TYPE_ROGUE;
		else if (sCLASS == "paladin") nCLASS = CLASS_TYPE_PALADIN;
		else break;
		if (GetLevelByClass(nCLASS, oPC) >= nLVL) return TRUE;
		sFEED = sFEED + sCLASS + " ";
		nCOUNT = nCOUNT + 1;
	}
	if (nCOUNT > 0) sFEED = "You need to have at least " + IntToString(nLVL) + " levels as " + sFEED;
	else if (GetHitDice(oPC) < nLVL) sFEED = "You need to be level " + IntToString(nLVL) + " ";
	else return TRUE; 
	sFEED = sFEED + "to be able to wear this item.";
	SendMessageToPC(oPC, sFEED);
	return FALSE;
}

void BeginHandlingEquipment(object oPC, object oITEM, int nUNEQUIP = FALSE){
	if (nUNEQUIP == FALSE)
	{
		if (CheckRequirements(oPC, oITEM) == FALSE)
		{
			AssignCommand(oPC, ClearAllActions(TRUE));
			AssignCommand(oPC, ActionUnequipItem(oITEM));
			return;
		}
	}
	RemoveEffectsFromSpell(oPC, FX_EQUIP);
	DelayCommand(0.0f, SpellResistanceFix(oPC));
	DelayCommand(0.1f, UpdateEffects(oPC));
}