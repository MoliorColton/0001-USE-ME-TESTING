/*

     Companion and Monster AI

    This file contains functions used to add spells, classes, and races to the AI.
	It also allows modification or removal of existing entries. Current entries are
	provided for everything used by the AI as an example to help in creating new
	entries.

*/



#include "hench_i0_generic"
#include "hench_i0_equip"
#include "hench_i0_heal"
#include "hench_i0_attack"
#include "hench_i0_buff"
#include "hench_i0_dispel"


const int SPELL_HENCH_AuraOfGlory_X2 = 562;
const int SPELL_HENCH_Haste_Slow_X2 = 563;
const int SPELL_HENCH_Summon_Shadow_X2 = 564;
const int SPELL_HENCH_Tide_of_Battle = 565;
const int SPELL_HENCH_Evil_Blight = 566;
const int SPELL_HENCH_Cure_Critical_Wounds_Others = 567;
const int SPELL_HENCH_Restoration_Others = 568;
//const int SPELL_HENCH_RedDragonDiscipleBreath = 690;
const int SPELL_HENCH_Harpysong = 686;
const int SPELL_HENCH_Epic_Warding = 695;
const int SPELL_HENCH_EyeballRay0 = 710;
const int SPELL_HENCH_EyeballRay1 = 711;
const int SPELL_HENCH_EyeballRay2 = 712;
const int SPELL_HENCH_Mindflayer_Mindblast_10 = 713;
const int SPELL_HENCH_Golem_Ranged_Slam = 715;
const int SPELL_HENCH_Bebelith_Web = 731;
const int SPELL_HENCH_Psionic_Inertial_Barrier = 741;
const int SPELL_HENCH_ShadowBlend = 757;
const int SPELL_HENCH_UndeadSelfHarm = 759;
const int SPELL_HENCH_Aura_of_Hellfire = 761;
const int SPELL_HENCH_Hell_Inferno = 762;
const int SPELL_HENCH_Psionic_Mass_Concussion = 763;
const int SPELL_HENCH_GlyphOfWardingDefault = 764;
const int SPELL_HENCH_Shadow_Attack = 769;
const int SPELL_HENCH_Slaad_Chaos_Spittle = 770;
const int SPELL_HENCH_DRAGON_BREATH_Prismatic = 771;
const int SPELL_HENCH_Battle_Boulder_Toss = 773;
const int SPELL_HENCH_Deflecting_Force = 774;
const int SPELL_HENCH_Giant_hurl_rock = 775;
const int SPELL_HENCH_Illithid_Mindblast = 789;
const int SPELL_HENCH_Grenade_FireBomb = 744;
const int SPELL_HENCH_Grenade_AcidBomb = 745;
const int SPELL_HENCH_HarperSleep = 480;
const int SPELL_HENCH_Beholder_Anti_Magic_Cone = 727;
const int SPELL_HENCH_Beholder_Special_Spell_AI = 736;
//const int SPELL_HENCH_Owl_Insight = 438;


int giSpellVersionToUse;

// provides a more future proof way of getting the version. Script does not need to be
// recompiled with new AI versions
int HenchGetSpellVersion()
{
	if (!giSpellVersionToUse)
	{
		giSpellVersionToUse = StringToInt(Get2DAString(HENCH_SPELL_ID_TABLE, HENCH_SPELL_INFO_COLUMN_NAME, 0)) & HENCH_SPELL_INFO_VERSION_MASK;
	
		if (!giSpellVersionToUse)
		{
			giSpellVersionToUse = HENCH_SPELL_INFO_VERSION;
		}
		else if (giSpellVersionToUse == 0x11000000)
		{
			// patch for default AI - mismatched versions
			giSpellVersionToUse = 0x10000000;
		}
//		Jug_Debug("spell version found is  " + IntToHexString(giSpellVersionToUse));	
	}
	return giSpellVersionToUse;
}


// general spell entry, use functions below for specific types of spells
void HenchSetSpellEntry(int nSpellID, int iSpellInfo, int iTargetInfo, int nDamageInfo, int nSaveDC,
	int nEffectTypes, int nSaveType, float fEffectWeight)
{
	iSpellInfo += HenchGetSpellVersion();

    string sSpellInfoStr = HENCH_SPELL_ID_INFO + IntToString(nSpellID);

    SetLocalInt(GetModule(), sSpellInfoStr, iSpellInfo);
    SetLocalInt(GetModule(), sSpellInfoStr + HENCH_SPELL_TARGET_COLUMN_NAME, iTargetInfo);
    SetLocalFloat(GetModule(), sSpellInfoStr + HENCH_SPELL_EFFECT_WEIGHT_COLUMN_NAME, fEffectWeight);
    SetLocalInt(GetModule(), sSpellInfoStr + HENCH_SPELL_EFFECT_TYPES_COLUMN_NAME, nEffectTypes);
    SetLocalInt(GetModule(), sSpellInfoStr + HENCH_SPELL_DAMAGE_INFO_COLUMN_NAME, nDamageInfo);
    SetLocalInt(GetModule(), sSpellInfoStr + HENCH_SPELL_SAVE_TYPE_COLUMN_NAME, nSaveType);
    SetLocalInt(GetModule(), sSpellInfoStr + HENCH_SPELL_SAVE_DC_TYPE_COLUMN_NAME, nSaveDC);

//	Jug_Debug("spell info for  " + IntToString(nSpellID) + " is " + IntToHexString(testSpellInfo));	

	// test code below	
/*	string columnInfo = Get2DAString(HENCH_SPELL_ID_TABLE, HENCH_SPELL_INFO_COLUMN_NAME, nSpellID);
	int testSpellInfo = StringToInt(columnInfo);
	if (testSpellInfo != iSpellInfo)
	{
		Jug_Debug("mismatch with spell info " + IntToString(nSpellID));	
	}
	
    int testTargetInfo = StringToInt(Get2DAString(HENCH_SPELL_ID_TABLE, HENCH_SPELL_TARGET_COLUMN_NAME, nSpellID));	
	if (testTargetInfo != iTargetInfo)
	{
		Jug_Debug("mismatch with target info " + IntToString(nSpellID) + " is " + IntToHexString(testTargetInfo) + " is " + IntToHexString(iTargetInfo));	
	}
	
    int testDamageInfo = StringToInt(Get2DAString(HENCH_SPELL_ID_TABLE, HENCH_SPELL_DAMAGE_INFO_COLUMN_NAME, nSpellID));	
	if (testDamageInfo != nDamageInfo)
	{
		Jug_Debug("mismatch with damage info " + IntToString(nSpellID) + " is " + IntToHexString(testDamageInfo) + " is " + IntToHexString(nDamageInfo));	
	}
	
    int testSaveDCInfo = StringToInt(Get2DAString(HENCH_SPELL_ID_TABLE, HENCH_SPELL_SAVE_DC_TYPE_COLUMN_NAME, nSpellID));	
	if (testSaveDCInfo != nSaveDC)
	{
		Jug_Debug("mismatch with saveDC info " + IntToString(nSpellID) + " is " + IntToHexString(testSaveDCInfo) + " is " + IntToHexString(nSaveDC));	
	}

    int testEffectTypesInfo = StringToInt(Get2DAString(HENCH_SPELL_ID_TABLE, HENCH_SPELL_EFFECT_TYPES_COLUMN_NAME, nSpellID));	
	if (testEffectTypesInfo != nEffectTypes)
	{
		Jug_Debug("mismatch with effect types info " + IntToString(nSpellID) + " is " + IntToHexString(testEffectTypesInfo) + " is " + IntToHexString(nEffectTypes));	
	}

    int testSaveTypeInfo = StringToInt(Get2DAString(HENCH_SPELL_ID_TABLE, HENCH_SPELL_SAVE_TYPE_COLUMN_NAME, nSpellID));	
	if (testSaveTypeInfo != nSaveType)
	{
		Jug_Debug("mismatch with save type info " + IntToString(nSpellID) + " is " + IntToHexString(testSaveTypeInfo) + " is " + IntToHexString(nSaveType));	
	}
		
	float testEffectWeightInfo = StringToFloat(Get2DAString(HENCH_SPELL_ID_TABLE, HENCH_SPELL_EFFECT_WEIGHT_COLUMN_NAME, nSpellID));	
	if (fabs(testEffectWeightInfo - fEffectWeight) > 0.0001)
	{
		Jug_Debug("mismatch with effect weight info " + IntToString(nSpellID) + " is " + FloatToString(testEffectWeightInfo) + " is " + FloatToString(fEffectWeight));	
	} */
}


int GetSpellDamageInfo(int nDamageTypes, int nDamageAmount, int nCasterLimit, int nDivKind, int nDivBy, int nSpellKind)
{
	return nDamageTypes + (nDamageAmount << 12) + (nCasterLimit << 20) + nDivKind + ((nDivBy - 1) << 26) + nSpellKind;
}


int GetSpellBuffInfo(int nDamageAmount, int nCasterLimit, int nDivKind, int nDivBy, int nCountDivBy, int nSpellKind)
{
	return nDamageAmount + (nCasterLimit << 8) + nDivKind + ((nDivBy - 1) << 16) + (nCountDivBy << 20) + nSpellKind;
}


int GetImmunityIncInfo(int nFlags, int nAmount)
{
	return nFlags + (nAmount << 12);
}

// add, remove, change entry for an attack spell
void HenchSetSpellAttackEntry(int nSpellID, int nSpellType, int nSpellLevel, int iSpellFlags, float fRadius,
	int iTargetFlags, int nDamageInfo, int nSaveDC, int nEffectTypes, int nSaveTypePartial, int nImmunity1,
	int nImmunity2, float fEffectWeight)
{
	int iSpellInfo = nSpellType | iSpellFlags | (nSpellLevel << HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT);
	int iTargetInfo = iTargetFlags | (FloatToInt(fRadius * 10 + 0.5) << 6);	
	int nSaveType = nSaveTypePartial + (nImmunity1 << 6) + (nImmunity2 << 12);
		
	HenchSetSpellEntry(nSpellID, iSpellInfo, iTargetInfo, nDamageInfo, nSaveDC,
		nEffectTypes, nSaveType, fEffectWeight);
}

// add, remove, change entry for an special attack spell
// new entries cannot be made without changing the hench_i0_attack function
void HenchSetSpellAttackSpecialEntry(int nSpellID, int nSpellLevel, int iSpellFlags, float fRadius,
	int iTargetFlags, int nSaveType)
{
	int iSpellInfo = HENCH_SPELL_INFO_SPELL_TYPE_ATTACK_SPECIAL | iSpellFlags | (nSpellLevel << HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT);
	int iTargetInfo = iTargetFlags | (FloatToInt(fRadius * 10 + 0.5) << 6);	

	HenchSetSpellEntry(nSpellID, iSpellInfo, iTargetInfo, 0, 0,
		0, nSaveType, 0.0);
}

// add, remove, change entry for an buff spell
void HenchSetSpellBuffEntry(int nSpellID, int nSpellType, int nSpellLevel, int iSpellFlags, float fRadius,
	int iTargetFlags, int nEffectTypes, int nSaveTypePartial, int nImmunity, int nItemProp, float fEffectWeight)
{
	int iSpellInfo = nSpellType | iSpellFlags | (nSpellLevel << HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT);
	int iTargetInfo = iTargetFlags | (FloatToInt(fRadius * 10 + 0.5) << 6);	
	int nSaveType = nSaveTypePartial + (nImmunity << 6) + (nItemProp << 18);
		
	HenchSetSpellEntry(nSpellID, iSpellInfo, iTargetInfo, 0, 0,
		nEffectTypes, nSaveType, fEffectWeight);
}

// add, remove, change entry for a concealment spell
void HenchSetSpellConcealmentEntry(int nSpellID, int nSpellLevel, int iSpellFlags, float fRadius,
	int iTargetFlags, float fEffectWeight)
{
	int iSpellInfo = HENCH_SPELL_INFO_SPELL_TYPE_CONCEALMENT | iSpellFlags | (nSpellLevel << HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT);
	int iTargetInfo = iTargetFlags | (FloatToInt(fRadius * 10 + 0.5) << 6);	
		
	HenchSetSpellEntry(nSpellID, iSpellInfo, iTargetInfo, 0, 0,
		0, 0, fEffectWeight);
}


// add, remove, change entry for an AC buff spell
void HenchSetSpellACBuffEntry(int nSpellID, int nSpellLevel, int iSpellFlags, float fRadius,
	int iTargetFlags, int nDamageInfo, int nACType, int bNotSelf, int nFlags, float fEffectWeight)
{
	int iSpellInfo = HENCH_SPELL_INFO_SPELL_TYPE_AC_BUFF | iSpellFlags | (nSpellLevel << HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT);
	int iTargetInfo = iTargetFlags | (FloatToInt(fRadius * 10 + 0.5) << 6);	
	int nSaveType = (nACType << 18);
	if (bNotSelf)
	{
		nSaveType += HENCH_SPELL_SAVE_TYPE_NOTSELF_FLAG;
	}
		
	HenchSetSpellEntry(nSpellID, iSpellInfo, iTargetInfo, nDamageInfo, nFlags,
		0, nSaveType, fEffectWeight);
}

// add, remove, change entry for an DR buff spell
void HenchSetSpellDRBuffEntry(int nSpellID, int nSpellLevel, int iSpellFlags, float fRadius,
	int iTargetFlags, int nAmount, int bNotSelf, float fEffectWeight)
{
	int iSpellInfo = HENCH_SPELL_INFO_SPELL_TYPE_DR_BUFF | iSpellFlags | (nSpellLevel << HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT);
	int iTargetInfo = iTargetFlags | (FloatToInt(fRadius * 10 + 0.5) << 6);	
	int nSaveType = (nAmount << 6);
	if (bNotSelf)
	{
		nSaveType += HENCH_SPELL_SAVE_TYPE_NOTSELF_FLAG;
	}

	HenchSetSpellEntry(nSpellID, iSpellInfo, iTargetInfo, 0, 0,
		0, nSaveType, fEffectWeight);
}


// add, remove, change entry for an summon spell
void HenchSetSpellSummonEntry(int nSpellID, int nSpellLevel, int iSpellFlags, float fRadius,
	int iTargetFlags, float fEffectWeight)
{
	int iSpellInfo = HENCH_SPELL_INFO_SPELL_TYPE_SUMMON | iSpellFlags | (nSpellLevel << HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT);
	int iTargetInfo = iTargetFlags | (FloatToInt(fRadius * 10 + 0.5) << 6);	

	HenchSetSpellEntry(nSpellID, iSpellInfo, iTargetInfo, 0, 0,
		0, 0, fEffectWeight);
}


// add, remove, change entry for a cure condition spell
void HenchSetSpellCureConditionEntry(int nSpellID, int nSpellLevel, int iSpellFlags, float fRadius,
	int iTargetFlags, int nEffectTypes, int nSaveTypePartial, int nImmunity)
{
	int iSpellInfo = HENCH_SPELL_INFO_SPELL_TYPE_CURECONDITION | iSpellFlags | (nSpellLevel << HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT);
	int iTargetInfo = iTargetFlags | (FloatToInt(fRadius * 10 + 0.5) << 6);	
	int nSaveType = nSaveTypePartial + (nImmunity << 6);
		
	HenchSetSpellEntry(nSpellID, iSpellInfo, iTargetInfo, 0, 0,
		nEffectTypes, nSaveType, 0.0);
}


// add, remove, change entry for a spell protection spell
void HenchSetSpellSpellProtEntry(int nSpellID, int nSpellLevel, int iSpellFlags, float fRadius,
	int iTargetFlags, int nEffectTypes)
{
	int iSpellInfo = HENCH_SPELL_INFO_SPELL_TYPE_SPELL_PROT | iSpellFlags | (nSpellLevel << HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT);
	int iTargetInfo = iTargetFlags | (FloatToInt(fRadius * 10 + 0.5) << 6);	
		
	HenchSetSpellEntry(nSpellID, iSpellInfo, iTargetInfo, 0, 0,
		nEffectTypes, 0, 0.0);
}


// add, remove, change entry for a energy protection spell
void HenchSetSpellEnergyProtEntry(int nSpellID, int nSpellLevel, int iSpellFlags, float fRadius,
	int iTargetFlags, int nIncAmount)
{
	int iSpellInfo = HENCH_SPELL_INFO_SPELL_TYPE_ENGR_PROT | iSpellFlags | (nSpellLevel << HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT);
	int iTargetInfo = iTargetFlags | (FloatToInt(fRadius * 10 + 0.5) << 6);	
		
	HenchSetSpellEntry(nSpellID, iSpellInfo, iTargetInfo, 0, 0,
		0, nIncAmount, 0.0);
}


// add, remove, change entry for a detect invisibility spell
void HenchSetSpellDetectInvisEntry(int nSpellID, int nSpellLevel, int iSpellFlags, float fRadius,
	int iTargetFlags, int nEffectTypes, float fEffectWeight)
{
	int iSpellInfo = HENCH_SPELL_INFO_SPELL_TYPE_DETECT_INVIS | iSpellFlags | (nSpellLevel << HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT);
	int iTargetInfo = iTargetFlags | (FloatToInt(fRadius * 10 + 0.5) << 6);	

	HenchSetSpellEntry(nSpellID, iSpellInfo, iTargetInfo, 0, 0,
		nEffectTypes, 0, fEffectWeight);
}


// add, remove, change entry for a general spell
void HenchSetSpellGeneralEntry(int nSpellID, int nSpellType, int nSpellLevel, int iSpellFlags, float fRadius,
	int iTargetFlags)
{
	int iSpellInfo = nSpellType | iSpellFlags | (nSpellLevel << HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT);
	int iTargetInfo = iTargetFlags | (FloatToInt(fRadius * 10 + 0.5) << 6);	
		
	HenchSetSpellEntry(nSpellID, iSpellInfo, iTargetInfo, 0, 0,
		0, 0, 0.0);
}


// add, remove, change entry for dispel or breach spell
void HenchSetSpellInvisibleEntry(int nSpellID, int nSpellLevel, int iSpellFlags, float fRadius,
	int iTargetFlags, int nEffectTypes, float nCurrentWeight)
{
	int iSpellInfo = HENCH_SPELL_INFO_SPELL_TYPE_INVISIBLE | iSpellFlags | (nSpellLevel << HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT);
	int iTargetInfo = iTargetFlags | (FloatToInt(fRadius * 10 + 0.5) << 6);	
		
	HenchSetSpellEntry(nSpellID, iSpellInfo, iTargetInfo, 0, 0,
		nEffectTypes, 0, nCurrentWeight);
}


// add, remove, change entry for dispel or breach spell
void HenchSetSpellDispelEntry(int nSpellID, int nSpellLevel, int iSpellFlags, float fRadius,
	int iTargetFlags, int nFlags)
{
	int iSpellInfo = HENCH_SPELL_INFO_SPELL_TYPE_DISPEL | iSpellFlags | (nSpellLevel << HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT);
	int iTargetInfo = iTargetFlags | (FloatToInt(fRadius * 10 + 0.5) << 6);	
		
	HenchSetSpellEntry(nSpellID, iSpellInfo, iTargetInfo, nFlags, 0,
		0, 0, 0.0);
}


// add, remove, change entry for a attribute buff spell
void HenchSetSpellAttrBuffEntry(int nSpellID, int nSpellLevel, int iSpellFlags, float fRadius,
	int iTargetFlags, int iAbilityKind, int nAmount)
{
	int iSpellInfo = HENCH_SPELL_INFO_SPELL_TYPE_ATTR_BUFF | iSpellFlags | (nSpellLevel << HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT);
	int iTargetInfo = iTargetFlags | (FloatToInt(fRadius * 10 + 0.5) << 6);	

	HenchSetSpellEntry(nSpellID, iSpellInfo, iTargetInfo, nAmount, 0,
		iAbilityKind, 0, 0.0);
}


// add, remove, change entry for a weapon buff spell
void HenchSetSpellWeapBuffEntry(int nSpellID, int nSpellLevel, int iSpellFlags, float fRadius,
	int iTargetFlags, int nDamageInfo, int nSaveDC, int nEffectTypes, int nSaveType, float fEffectWeight)
{
	int iSpellInfo = HENCH_SPELL_INFO_SPELL_TYPE_WEAPON_BUFF | iSpellFlags | (nSpellLevel << HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT);
	int iTargetInfo = iTargetFlags | (FloatToInt(fRadius * 10 + 0.5) << 6);	
		
	HenchSetSpellEntry(nSpellID, iSpellInfo, iTargetInfo, nDamageInfo, nSaveDC,
		nEffectTypes, nSaveType, fEffectWeight);
}


// add, remove, change entry for a weapon buff spell
void HenchSetSpellPolymorphEntry(int nSpellID, int nSpellLevel, int iSpellFlags, float fRadius,
	int iTargetFlags, int nEffectTypes, float fEffectWeight)
{
	int iSpellInfo = HENCH_SPELL_INFO_SPELL_TYPE_POLYMORPH | iSpellFlags | (nSpellLevel << HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT);
	int iTargetInfo = iTargetFlags | (FloatToInt(fRadius * 10 + 0.5) << 6);	
		
	HenchSetSpellEntry(nSpellID, iSpellInfo, iTargetInfo, 0, 0,
		nEffectTypes, 0, fEffectWeight);
}


// add, remove, change entry for a melee attack spell
void HenchSetSpellMeleeAttackEntry(int nSpellID, int nSpellLevel, int iSpellFlags, float fRadius,
	int iTargetFlags, int nType)
{
	int iSpellInfo = HENCH_SPELL_INFO_SPELL_TYPE_MELEE_ATTACK | iSpellFlags | (nSpellLevel << HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT);
	int iTargetInfo = iTargetFlags | (FloatToInt(fRadius * 10 + 0.5) << 6);	
		
	HenchSetSpellEntry(nSpellID, iSpellInfo, iTargetInfo, 0, 0,
		0, nType, 0.0);
}


// add, remove, change entry for a melee attack buff (size changing) spell
void HenchSetSpellMeleeAttackBuffEntry(int nSpellID, int nSpellLevel, int iSpellFlags, float fRadius,
	int iTargetFlags, int nType, float nCurrentWeight)
{
	int iSpellInfo = HENCH_SPELL_INFO_SPELL_TYPE_MELEE_ATTACK_BUFF | iSpellFlags | (nSpellLevel << HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT);
	int iTargetInfo = iTargetFlags | (FloatToInt(fRadius * 10 + 0.5) << 6);	
		
	HenchSetSpellEntry(nSpellID, iSpellInfo, iTargetInfo, 0, 0,
		0, nType, nCurrentWeight);
}


// add, remove, change entry for raising dead
void HenchSetSpellRaiseDeadEntry(int nSpellID, int nSpellLevel, int iSpellFlags, float fRadius,
	int iTargetFlags, float nCurrentWeight)
{
	int iSpellInfo = HENCH_SPELL_INFO_SPELL_TYPE_RAISE_DEAD | iSpellFlags | (nSpellLevel << HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT);
	int iTargetInfo = iTargetFlags | (FloatToInt(fRadius * 10 + 0.5) << 6);	
		
	HenchSetSpellEntry(nSpellID, iSpellInfo, iTargetInfo, 0, 0,
		0, 0, nCurrentWeight);
}


// add, remove, change entry for ingoring a spell, for regular spells putting this in helps the AI
// find spells even if not used
void HenchSetSpellIgnoreEntry(int nSpellID, int nSpellLevel, int iSpellFlags)
{
	int iSpellInfo = iSpellFlags | (nSpellLevel << HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT);
		
	HenchSetSpellEntry(nSpellID, iSpellInfo, 0, 0, 0,
		0, 0, 0.0);
}


// this is a master spell, define the sub spells, only useful for feat based spells with subspells (i.e. Wildshape)
void HenchSetSpellMasterEntry(int nSpellID, int nSpellLevel, int nSubSpell1 = 0, int nSubSpell2 = 0, int nSubSpell3 = 0, int nSubSpell4 = 0, int nSubSpell5 = 0)
{
	HenchSetSpellEntry(nSpellID, HENCH_SPELL_INFO_MASTER_FLAG | (nSpellLevel << HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT), nSubSpell1, nSubSpell3, nSubSpell5,
		nSubSpell2, nSubSpell4, 0.0);
}


// returns a packed int with the feat and spell id casting information
int HenchGetFeatSpell(int nFeatID, int nSpellID, int bCheatCast = FALSE)
{
	return nFeatID + (nSpellID << 16) + (bCheatCast ? 0x40000000 : 0);
}


// general class information and feat spell information
void HenchSetClassEntry(int nClassID, int iClassFlags, int iClassSpellAbility, int featSpell1 = -1,
	int featSpell2 = -1, int featSpell3 = -1, int featSpell4 = -1, int featSpell5 = -1, int featSpell6 = -1,
	int featSpell7 = -1, int featSpell8 = -1, int featSpell9 = -1, int featSpell10 = -1, int featSpell11 = -1,
	int featSpell12 = -1, int featSpell13 = -1)
{
	iClassFlags += HenchGetSpellVersion();
	if (iClassSpellAbility > 0)
	{
		iClassFlags += (iClassSpellAbility - ABILITY_CONSTITUTION) << HENCH_CLASS_ABILITY_MODIFIER_SHIFT;
	}

    string sClassInfoStr = HENCH_CLASS_ID_INFO + IntToString(nClassID);

    SetLocalInt(GetModule(), sClassInfoStr, iClassFlags);

	
	if (featSpell1 > 0)
	{
    	SetLocalInt(GetModule(), sClassInfoStr + HENCH_CLASS_FEATS_SEPERATOR + "1", featSpell1);	
		if (featSpell2 > 0)
		{
	    	SetLocalInt(GetModule(), sClassInfoStr + HENCH_CLASS_FEATS_SEPERATOR + "2", featSpell2);	
			if (featSpell3 > 0)
			{
		    	SetLocalInt(GetModule(), sClassInfoStr + HENCH_CLASS_FEATS_SEPERATOR + "3", featSpell3);	
				if (featSpell4 > 0)
				{
			    	SetLocalInt(GetModule(), sClassInfoStr + HENCH_CLASS_FEATS_SEPERATOR + "4", featSpell4);		
					if (featSpell5 > 0)
					{
				    	SetLocalInt(GetModule(), sClassInfoStr + HENCH_CLASS_FEATS_SEPERATOR + "5", featSpell5);	
						if (featSpell6 > 0)
						{
					    	SetLocalInt(GetModule(), sClassInfoStr + HENCH_CLASS_FEATS_SEPERATOR + "6", featSpell6);	
							if (featSpell7 > 0)
							{
						    	SetLocalInt(GetModule(), sClassInfoStr + HENCH_CLASS_FEATS_SEPERATOR + "7", featSpell7);	
								if (featSpell8 > 0)
								{
							    	SetLocalInt(GetModule(), sClassInfoStr + HENCH_CLASS_FEATS_SEPERATOR + "8", featSpell8);	
									if (featSpell9 > 0)
									{
								    	SetLocalInt(GetModule(), sClassInfoStr + HENCH_CLASS_FEATS_SEPERATOR + "9", featSpell9);	
										if (featSpell10 > 0)
										{
									    	SetLocalInt(GetModule(), sClassInfoStr + HENCH_CLASS_FEATS_SEPERATOR + "10", featSpell10);	
											if (featSpell11 > 0)
											{
										    	SetLocalInt(GetModule(), sClassInfoStr + HENCH_CLASS_FEATS_SEPERATOR + "11", featSpell1);	
												if (featSpell12 > 0)
												{
											    	SetLocalInt(GetModule(), sClassInfoStr + HENCH_CLASS_FEATS_SEPERATOR + "12", featSpell1);	
													if (featSpell13 > 0)
													{
												    	SetLocalInt(GetModule(), sClassInfoStr + HENCH_CLASS_FEATS_SEPERATOR + "13", featSpell1);	
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
	
	// test code below	
/*	string columnInfo = Get2DAString(HENCH_CLASS_ID_TABLE, HENCH_CLASS_ID_FLAGS_COLUMN, nClassID);
	int testClassInfo = StringToInt(columnInfo);
	if (testClassInfo != iClassFlags)
	{
		Jug_Debug("mismatch with class info " + IntToString(nClassID) + " is " + IntToHexString(testClassInfo) + " is " + IntToHexString(iClassFlags));	
	}
	
	int testFeatSpell;
	
	testFeatSpell = StringToInt(Get2DAString(HENCH_CLASS_ID_TABLE, HENCH_CLASS_FEATS_COLUMN + "1", nClassID));
	if (featSpell1 > 0 ? testFeatSpell != featSpell1 : testFeatSpell)
	{
		Jug_Debug("mismatch with class feat spell 1 info " + IntToString(nClassID) + " is " + IntToHexString(testFeatSpell) + " is " + IntToHexString(featSpell1));	
	}
	testFeatSpell = StringToInt(Get2DAString(HENCH_CLASS_ID_TABLE, HENCH_CLASS_FEATS_COLUMN + "2", nClassID));
	if (featSpell2 > 0 ? testFeatSpell != featSpell2 : testFeatSpell)
	{
		Jug_Debug("mismatch with class feat spell 2 info " + IntToString(nClassID) + " is " + IntToHexString(testFeatSpell) + " is " + IntToHexString(featSpell2));	
	}
	testFeatSpell = StringToInt(Get2DAString(HENCH_CLASS_ID_TABLE, HENCH_CLASS_FEATS_COLUMN + "3", nClassID));
	if (featSpell3 > 0 ? testFeatSpell != featSpell3 : testFeatSpell)
	{
		Jug_Debug("mismatch with class feat spell 3 info " + IntToString(nClassID) + " is " + IntToHexString(testFeatSpell) + " is " + IntToHexString(featSpell3));	
	}
	testFeatSpell = StringToInt(Get2DAString(HENCH_CLASS_ID_TABLE, HENCH_CLASS_FEATS_COLUMN + "4", nClassID));
	if (featSpell4 > 0 ? testFeatSpell != featSpell4 : testFeatSpell)
	{
		Jug_Debug("mismatch with class feat spell 4 info " + IntToString(nClassID) + " is " + IntToHexString(testFeatSpell) + " is " + IntToHexString(featSpell4));	
	}
	testFeatSpell = StringToInt(Get2DAString(HENCH_CLASS_ID_TABLE, HENCH_CLASS_FEATS_COLUMN + "5", nClassID));
	if (featSpell5 > 0 ? testFeatSpell != featSpell5 : testFeatSpell)
	{
		Jug_Debug("mismatch with class feat spell 5 info " + IntToString(nClassID) + " is " + IntToHexString(testFeatSpell) + " is " + IntToHexString(featSpell5));	
	}
	testFeatSpell = StringToInt(Get2DAString(HENCH_CLASS_ID_TABLE, HENCH_CLASS_FEATS_COLUMN + "6", nClassID));
	if (featSpell6 > 0 ? testFeatSpell != featSpell6 : testFeatSpell)
	{
		Jug_Debug("mismatch with class feat spell 6 info " + IntToString(nClassID) + " is " + IntToHexString(testFeatSpell) + " is " + IntToHexString(featSpell6));	
	}
	testFeatSpell = StringToInt(Get2DAString(HENCH_CLASS_ID_TABLE, HENCH_CLASS_FEATS_COLUMN + "7", nClassID));
	if (featSpell7 > 0 ? testFeatSpell != featSpell7 : testFeatSpell)
	{
		Jug_Debug("mismatch with class feat spell 7 info " + IntToString(nClassID) + " is " + IntToHexString(testFeatSpell) + " is " + IntToHexString(featSpell7));	
	}
	testFeatSpell = StringToInt(Get2DAString(HENCH_CLASS_ID_TABLE, HENCH_CLASS_FEATS_COLUMN + "8", nClassID));
	if (featSpell8 > 0 ? testFeatSpell != featSpell8 : testFeatSpell)
	{
		Jug_Debug("mismatch with class feat spell 8 info " + IntToString(nClassID) + " is " + IntToHexString(testFeatSpell) + " is " + IntToHexString(featSpell8));	
	}
	testFeatSpell = StringToInt(Get2DAString(HENCH_CLASS_ID_TABLE, HENCH_CLASS_FEATS_COLUMN + "9", nClassID));
	if (featSpell9 > 0 ? testFeatSpell != featSpell9 : testFeatSpell)
	{
		Jug_Debug("mismatch with class feat spell 9 info " + IntToString(nClassID) + " is " + IntToHexString(testFeatSpell) + " is " + IntToHexString(featSpell9));	
	}
	testFeatSpell = StringToInt(Get2DAString(HENCH_CLASS_ID_TABLE, HENCH_CLASS_FEATS_COLUMN + "10", nClassID));
	if (featSpell10 > 0 ? testFeatSpell != featSpell10 : testFeatSpell)
	{
		Jug_Debug("mismatch with class feat spell 10 info " + IntToString(nClassID) + " is " + IntToHexString(testFeatSpell) + " is " + IntToHexString(featSpell10));	
	}
	testFeatSpell = StringToInt(Get2DAString(HENCH_CLASS_ID_TABLE, HENCH_CLASS_FEATS_COLUMN + "11", nClassID));
	if (featSpell11 > 0 ? testFeatSpell != featSpell11 : testFeatSpell)
	{
		Jug_Debug("mismatch with class feat spell 11 info " + IntToString(nClassID) + " is " + IntToHexString(testFeatSpell) + " is " + IntToHexString(featSpell11));	
	}
	testFeatSpell = StringToInt(Get2DAString(HENCH_CLASS_ID_TABLE, HENCH_CLASS_FEATS_COLUMN + "12", nClassID));
	if (featSpell12 > 0 ? testFeatSpell != featSpell12 : testFeatSpell)
	{
		Jug_Debug("mismatch with class feat spell 12 info " + IntToString(nClassID) + " is " + IntToHexString(testFeatSpell) + " is " + IntToHexString(featSpell12));	
	}
	testFeatSpell = StringToInt(Get2DAString(HENCH_CLASS_ID_TABLE, HENCH_CLASS_FEATS_COLUMN + "13", nClassID));
	if (featSpell13 > 0 ? testFeatSpell != featSpell13 : testFeatSpell)
	{
		Jug_Debug("mismatch with class feat spell 13 info " + IntToString(nClassID) + " is " + IntToHexString(testFeatSpell) + " is " + IntToHexString(featSpell13));	
	} */
}


// general racial sub type information and feat spell information
void HenchSetRacialEntry(int nRacialSubTypeID, int iRacialFlags, int featSpell1 = -1,
	int featSpell2 = -1, int featSpell3 = -1, int featSpell4 = -1, int featSpell5 = -1)
{
	iRacialFlags += HenchGetSpellVersion();

    string sRacialInfoStr = HENCH_RACIAL_ID_INFO + IntToString(nRacialSubTypeID);

    SetLocalInt(GetModule(), sRacialInfoStr, iRacialFlags);
	
	if (featSpell1 > 0)
	{
    	SetLocalInt(GetModule(), sRacialInfoStr + HENCH_RACIAL_FEATS_SEPERATOR + "1", featSpell1);	
		if (featSpell2 > 0)
		{
	    	SetLocalInt(GetModule(), sRacialInfoStr + HENCH_RACIAL_FEATS_SEPERATOR + "2", featSpell2);	
			if (featSpell3 > 0)
			{
		    	SetLocalInt(GetModule(), sRacialInfoStr + HENCH_RACIAL_FEATS_SEPERATOR + "3", featSpell3);	
				if (featSpell4 > 0)
				{
			    	SetLocalInt(GetModule(), sRacialInfoStr + HENCH_RACIAL_FEATS_SEPERATOR + "4", featSpell4);	
					if (featSpell5 > 0)
					{
		    			SetLocalInt(GetModule(), sRacialInfoStr + HENCH_RACIAL_FEATS_SEPERATOR + "5", featSpell5);
					}
				}
			}
		}
	}
	
	// test code below
/*	string columnInfo = Get2DAString(HENCH_RACIAL_ID_TABLE, HENCH_RACIAL_ID_FLAGS_COLUMN, nRacialSubTypeID);
	int testRacialInfo = StringToInt(columnInfo);
	if (testRacialInfo != iRacialFlags)
	{
		Jug_Debug("mismatch with racial info " + IntToString(nRacialSubTypeID) + " is " + IntToHexString(testRacialInfo) + " is " + IntToHexString(iRacialFlags));	
	}
	
	int testFeatSpell;
		
	testFeatSpell = StringToInt(Get2DAString(HENCH_RACIAL_ID_TABLE, HENCH_RACIAL_FEATS_COLUMN + "1", nRacialSubTypeID));
	if (featSpell1 > 0 ? testFeatSpell != featSpell1 : testFeatSpell)
	{
		Jug_Debug("mismatch with racial feat spell 1 info " + IntToString(nRacialSubTypeID) + " is " + IntToHexString(testFeatSpell) + " is " + IntToHexString(featSpell1));	
	}
	testFeatSpell = StringToInt(Get2DAString(HENCH_RACIAL_ID_TABLE, HENCH_RACIAL_FEATS_COLUMN + "2", nRacialSubTypeID));
	if (featSpell2 > 0 ? testFeatSpell != featSpell2 : testFeatSpell)
	{
		Jug_Debug("mismatch with racial feat spell 2 info " + IntToString(nRacialSubTypeID) + " is " + IntToHexString(testFeatSpell) + " is " + IntToHexString(featSpell2));	
	}
	testFeatSpell = StringToInt(Get2DAString(HENCH_RACIAL_ID_TABLE, HENCH_RACIAL_FEATS_COLUMN + "3", nRacialSubTypeID));
	if (featSpell3 > 0 ? testFeatSpell != featSpell3 : testFeatSpell)
	{
		Jug_Debug("mismatch with racial feat spell 3 info " + IntToString(nRacialSubTypeID) + " is " + IntToHexString(testFeatSpell) + " is " + IntToHexString(featSpell3));	
	}
	testFeatSpell = StringToInt(Get2DAString(HENCH_RACIAL_ID_TABLE, HENCH_RACIAL_FEATS_COLUMN + "4", nRacialSubTypeID));
	if (featSpell4 > 0 ? testFeatSpell != featSpell4 : testFeatSpell)
	{
		Jug_Debug("mismatch with racial feat spell 4 info " + IntToString(nRacialSubTypeID) + " is " + IntToHexString(testFeatSpell) + " is " + IntToHexString(featSpell4));	
	}
	testFeatSpell = StringToInt(Get2DAString(HENCH_RACIAL_ID_TABLE, HENCH_RACIAL_FEATS_COLUMN + "5", nRacialSubTypeID));
	if (featSpell5 > 0 ? testFeatSpell != featSpell5 : testFeatSpell)
	{
		Jug_Debug("mismatch with racial feat spell 5 info " + IntToString(nRacialSubTypeID) + " is " + IntToHexString(testFeatSpell) + " is " + IntToHexString(featSpell5));	
	} */
}