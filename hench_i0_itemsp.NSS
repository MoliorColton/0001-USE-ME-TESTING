/*

    Companion and Monster AI

    This file contains routines used for casting spells, using feats, items (potions,
    scrolls, and rods by companions and monsters. Several options are tried and the highest
    weighted options is what is finally cast.

    Also deals with creatures with a negative effect on them that
    impacts spellcasting (silence, primary ability drain)

*/


#include "hench_i0_generic"
#include "hench_i0_equip"
#include "hench_i0_heal"
#include "hench_i0_attack"
#include "hench_i0_buff"
#include "hench_i0_dispel"

const int HENCH_ITEM_TYPE_NONE      = 0;
const int HENCH_ITEM_TYPE_OTHER     = 1;
const int HENCH_ITEM_TYPE_POTION    = 2;

const int HENCH_TALENT_USE_SPELLS_ONLY = 3;
const int HENCH_TALENT_USE_ABILITIES_ONLY = 5;
const int HENCH_TALENT_USE_ITEMS_ONLY = 6;


// checks if spell has already been tested
int HasItemTalentSpell(int spellID);

// add spell to list that has already been tested
void AddItemTalentSpell(int spellID);

// check if aura spell should be cast after ClearAllActions is done
void HenchCheckCastAuraSpell();

// dispatches the spell to the correct handling routine (buff, attack, protection, etc.)
// nItemType is HENCH_ITEM_TYPE_*
void DispatchSpell(int nItemType);

// most standard spells are sent into this function
// fills in fields of gsCurrentspInfo and calls DispatchSpell
void HenchTalentSpellDispatch(talent tTalent, int nSpellID, int spellIDInfo, int nItemType);

// most feats are sent into this function
// fills in fields of gsCurrentspInfo and calls DispatchSpell
void HenchFeatDispatch(int nFeatID, int nSpellID, int bUseCheatCast);

// spontaneously cast spells sent to this function (cure, inflict, summons, and possibly others)
// fills in fields of gsCurrentspInfo and calls DispatchSpell
void HenchSpontaneousDispatch(int nSpellID, int bForceUnlimited);

// tries to find all talents for a particular talent type in a category
int FindItemSpellTalentsByCategory(int nCategory, int maximumToFind, int talentExclude, int nItemType);

// checks and casts spontaneous cure or inflict spells, returns TRUE if one already found or cast
int CheckSpontaneousCureOrInflictSpell(int nSpellID);

// checks and casts spontaneous mass cure or inflict spells, returns TRUE if one already found or cast
int CheckSpontaneousMassCureOrInflictSpell(int nSpellID);

// tries to find all talents for a category, cycles allowed talent types and calls FindItemSpellTalentsByCategory
void InitializeSpellTalentCategory(int nCategory);

// tries to find all talents for a category except items, cycles allowed talent types and calls FindItemSpellTalentsByCategory
void InitializeSpellTalentCategoryNoItems(int nCategory);

// find spell talents for all categories
void InitializeSpellTalents();

// Return TRUE if oObject is affected by an Inspire Bard Song
int HenchGetHasInspireBardSongSpellEffect(object oObject=OBJECT_SELF);

// Test all feats than can be used
void InitializeFeats();

// test various spell shapes for the warlock spell
void InitializeWarlockAttackSpell(int nSpellID, int nSpellLevel);

// test various warlock essences, then call InitializeWarlockAttackSpell to test shapes
void InitializeWarlockAttackSpells();

// gets spell casting information from a class position (class, level, primary ability, etc.)
int InitializeClassByPosition(int iPosition);

// gets spell casting information (class, level, primary ability, etc.)
void InitializeSpellCasting();

// test various spells, feats, etc. calling the correct dispatch function
void InitializeItemSpells(int negativeEffects, int positiveEffects);

// decrement spell for spontaneous spell cast, tries various means to decrement
void HenchDecrementSpontaneousSpell(int nSpellID);

// cast a given spell given the sSpellInformation structure
void HenchCastSpell(struct sSpellInformation spInfo);

// determine what if any spell, feat, etc. should be cast, used, etc.
int HenchCheckSpellToCast(int currentRound, int bTestOnly = FALSE);

// determine persistent area of effect spells that could cause problems
int CheckAOEForSelf(int currentNegEffects, int currentPosEffects);


const int HENCH_DISABLE_EFFECT_SILENCE = 0x1;
const int HENCH_DISABLE_EFFECT_NO_MAGIC = 0x2;

int bgDisablingEffect;      // disabling effect for spells
int igAuraSpellToCast;	// pending aura to cast

// void main() {  InitializeItemSpells(0, 0, 0);  }


int giItemTalentSpellCount;
int giItemTalentSpellStart;
const int maxItemTalentSpellCount = 10;
int itemSpellID1, itemSpellID2, itemSpellID3, itemSpellID4, itemSpellID5,
        itemSpellID6, itemSpellID7, itemSpellID8, itemSpellID9, itemSpellID10;

int HasItemTalentSpell(int spellID)
{
    if (giItemTalentSpellCount < 1)
    {
        return FALSE;
    }
    if (spellID == itemSpellID1)
    {
        return 1;
    }
    if (giItemTalentSpellCount < 2)
    {
        return FALSE;
    }
    if (spellID == itemSpellID2)
    {
        return 2;
    }
    if (giItemTalentSpellCount < 3)
    {
        return FALSE;
    }
    if (spellID == itemSpellID3)
    {
        return 3;
    }
    if (giItemTalentSpellCount < 4)
    {
        return FALSE;
    }
    if (spellID == itemSpellID4)
    {
        return 4;
    }
    if (giItemTalentSpellCount < 5)
    {
        return FALSE;
    }
    if (spellID == itemSpellID5)
    {
        return 5;
    }
    if (giItemTalentSpellCount < 6)
    {
        return FALSE;
    }
    if (spellID == itemSpellID6)
    {
        return 6;
    }
    if (giItemTalentSpellCount < 7)
    {
        return FALSE;
    }
    if (spellID == itemSpellID7)
    {
        return 7;
    }
    if (giItemTalentSpellCount < 8)
    {
        return FALSE;
    }
    if (spellID == itemSpellID8)
    {
        return 8;
    }
    if (giItemTalentSpellCount < 9)
    {
        return FALSE;
    }
    if (spellID == itemSpellID9)
    {
        return 9;
    }
    if (giItemTalentSpellCount < 10)
    {
        return FALSE;
    }
    if (spellID == itemSpellID10)
    {
        return 10;
    }
    return TRUE;
}


void AddItemTalentSpell(int spellID)
{
    if (giItemTalentSpellCount >= maxItemTalentSpellCount)
    {
        return;
    }
    giItemTalentSpellCount ++;

    if (giItemTalentSpellCount == 1)
    {
        itemSpellID1 = spellID;
        return;
    }
    if (giItemTalentSpellCount == 2)
    {
        itemSpellID2 = spellID;
        return;
    }
    if (giItemTalentSpellCount == 3)
    {
        itemSpellID3 = spellID;
        return;
    }
    if (giItemTalentSpellCount == 4)
    {
        itemSpellID4 = spellID;
        return;
    }
    if (giItemTalentSpellCount == 5)
    {
        itemSpellID5 = spellID;
        return;
    }
    if (giItemTalentSpellCount == 6)
    {
        itemSpellID6 = spellID;
        return;
    }
    if (giItemTalentSpellCount == 7)
    {
        itemSpellID7 = spellID;
        return;
    }
    if (giItemTalentSpellCount == 8)
    {
        itemSpellID8 = spellID;
        return;
    }
    if (giItemTalentSpellCount == 9)
    {
        itemSpellID9 = spellID;
        return;
    }
    if (giItemTalentSpellCount == 10)
    {
        itemSpellID10 = spellID;
        return;
    }
}


void HenchCheckCastAuraSpell()
{
//	Jug_Debug(GetName(OBJECT_SELF) + " check cast persist spell");		
	if (igAuraSpellToCast > 0)
	{
//		Jug_Debug(GetName(OBJECT_SELF) + " cast persist spell");		
		ActionCastSpellAtObject(igAuraSpellToCast, OBJECT_SELF, METAMAGIC_NONE, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
	}
}


void DispatchSpell(int nItemType)
{
    int targetInformation = GetLocalInt(GetModule(), gCurrentSpellInfoStr + HENCH_SPELL_TARGET_COLUMN_NAME);
    gsCurrentspInfo.shape = targetInformation & HENCH_SPELL_TARGET_SHAPE_MASK;
    switch (targetInformation & HENCH_SPELL_TARGET_RANGE_MASK)
    {
    case HENCH_SPELL_TARGET_RANGE_PERSONAL:
        gsCurrentspInfo.range = 0.0;
        break;
    case HENCH_SPELL_TARGET_RANGE_TOUCH:
        gsCurrentspInfo.range = 4.0;
        break;
    case HENCH_SPELL_TARGET_RANGE_SHORT:
        gsCurrentspInfo.range = 8.0;
        break;
    case HENCH_SPELL_TARGET_RANGE_MEDIUM:
        gsCurrentspInfo.range = 20.0;
        break;
    case HENCH_SPELL_TARGET_RANGE_LONG:
        gsCurrentspInfo.range = 40.0;
        break;
    case HENCH_SPELL_TARGET_RANGE_INFINITE:
        gsCurrentspInfo.range = 300.0;
        break;
    }
    if (nItemType)
    {
        gsCurrentspInfo.spellInfo |= HENCH_SPELL_INFO_ITEM_FLAG;
        if (nItemType == HENCH_ITEM_TYPE_POTION)
        {
            gsCurrentspInfo.range = 0.0;
        }
        else
        {
                // wands, etc. don't have AoO
            gsCurrentspInfo.spellInfo &= HENCH_SPELL_INFO_REMOVE_CONCENTRATION_FLAG;
        }
    }
    gsCurrentspInfo.radius = IntToFloat((targetInformation & HENCH_SPELL_TARGET_RADIUS_MASK) >> 6) / 10.0;

//	Jug_Debug(GetName(OBJECT_SELF) + " spell type " + IntToHexString(gsCurrentspInfo.spellInfo & HENCH_SPELL_INFO_SPELL_TYPE_MASK));
//	Jug_Debug(GetName(OBJECT_SELF) + " dispatching spell " + IntToString(gsCurrentspInfo.spellID) + " " + Get2DAString("spells", "Label", gsCurrentspInfo.spellID) + " other "  + IntToString(gsCurrentspInfo.otherID));

    int spellType = gsCurrentspInfo.spellInfo & HENCH_SPELL_INFO_SPELL_TYPE_MASK;
    if (!(gsCurrentspInfo.spellInfo & gbSpellInfoCastMask))
    {
        return;
    }

    switch (spellType)
    {
    case HENCH_SPELL_INFO_SPELL_TYPE_ATTACK:
    case HENCH_SPELL_INFO_SPELL_TYPE_HEAL:
    case HENCH_SPELL_INFO_SPELL_TYPE_HARM:
        HenchSpellAttack(GetCurrentSpellSaveType(), targetInformation);
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_BUFF:
        HenchCheckBuff();
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_AC_BUFF:
        HenchCheckACBuff();
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_DR_BUFF:
        HenchCheckDRBuff();
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_PERSISTENTAREA:
        // just activate with quick cast if not present
        if (!GetHasSpellEffect(gsCurrentspInfo.spellID))
        {
//			Jug_Debug(GetName(OBJECT_SELF) + " putting in aura to do");
			igAuraSpellToCast = gsCurrentspInfo.spellID;			
        }
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_POLYMORPH:
        if (!GetHenchAssociateState(HENCH_ASC_DISABLE_POLYMORPH))
        {
            HenchCheckPolymorph();
        }
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_DISPEL:
        HenchCheckDispel();
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_INVISIBLE:
        if (gbCheckInvisbility)
        {
            HenchCheckInvisibility();
        }
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_CURECONDITION:
        HenchCheckCureCondition();
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_SUMMON:
        if (!GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_SUMMONED)) && !GetHenchAssociateState(HENCH_ASC_DISABLE_SUMMONS))
        {
            HenchCheckSummons();
        }
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_ATTR_BUFF:
        HenchCheckAttrBuff();
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_ENGR_PROT:
        HenchCheckEnergyProt();
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_MELEE_ATTACK:
        HenchMeleeAttackSpell();
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_ARCANE_ARCHER:
        {
            int itemType = GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND));
            if ((itemType == BASE_ITEM_LONGBOW) || (itemType == BASE_ITEM_SHORTBOW))
            {
                HenchSpellAttack(GetCurrentSpellSaveType(), targetInformation);
            }
        }
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_SPELL_PROT:
        HenchCheckSpellProtections();
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_DRAGON_BREATH:
        {
            int combatRoundCount = GetLocalInt(OBJECT_SELF, henchCombatRoundStr);
            int lastDragonBreath = GetLocalInt(OBJECT_SELF, henchLastDraBrStr);
            if (lastDragonBreath == 0 || lastDragonBreath < combatRoundCount - 2)
            {
                // breath is unlimited
                gsCurrentspInfo.castingInfo = HENCH_CASTING_INFO_USE_SPELL_REGULAR | HENCH_CASTING_INFO_CHEAT_CAST_FLAG;
				gsCurrentspInfo.otherID = METAMAGIC_NONE;
                HenchSpellAttack(GetCurrentSpellSaveType(), targetInformation);
            }
        }
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_DETECT_INVIS:
        HenchCheckDetectInvisibility();
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_DOMINATE:
        if (!GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_DOMINATED)))
        {
            int lastDominate = GetLocalInt(OBJECT_SELF, henchLastDomStr);
            int combatRoundCount = GetLocalInt(OBJECT_SELF, henchCombatRoundStr);
            if (lastDominate == 0 && lastDominate >= combatRoundCount - 7)
            {
                HenchSpellAttack(GetCurrentSpellSaveType(), targetInformation);
            }
        }
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_WEAPON_BUFF:
        HenchCheckWeaponBuff();
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_BUFF_ANIMAL_COMP:
        HenchCheckAnimalCompanionBuff();
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_PROT_EVIL:
        HenchCheckProtEvil();
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_PROT_GOOD:
        HenchCheckProtGood();
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_REGENERATE:
        HenchCheckRegeneration();
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_GUST_OF_WIND:
        gsGustOfWind = gsCurrentspInfo;
// TODO MotB disabled for now, check friendly AoEs HenchSpellAttack(GetCurrentSpellSaveType());
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_ELEMENTAL_SHIELD:
        HenchCheckElementalShield();
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_TURN_UNDEAD:
        HenchCheckTurnUndead();
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_MELEE_ATTACK_BUFF:
        HenchMeleeAttackBuff();
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_RAISE_DEAD:
        HenchRaiseDead();
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_CONCEALMENT:
        HenchConcealment();
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_ATTACK_SPECIAL:
        HenchSpellAttackSpecial();
		break;
    case HENCH_SPELL_INFO_SPELL_TYPE_HEAL_SPECIAL:
		HenchCheckHealSpecial();
		break;
    }
}


void HenchTalentSpellDispatch(talent tTalent, int nSpellID, int spellIDInfo, int nItemType)
{
//	Jug_Debug(GetName(OBJECT_SELF) + " found spell " + IntToString(nSpellID) + " level " + IntToString(nSpellLevel));
//  Jug_Debug(GetName(OBJECT_SELF) + " spell info " + IntToHexString(spellIDInfo));

	if ((spellIDInfo == 0) || (spellIDInfo & HENCH_SPELL_INFO_MASTER_OR_IGNORE_FLAG))
	{
		return;
	}
	
	gsCurrentspInfo.spellID = nSpellID;
	gsCurrentspInfo.castingInfo = HENCH_CASTING_INFO_USE_SPELL_TALENT;
	gsCurrentspInfo.tTalent = tTalent;
	gsCurrentspInfo.otherID = -1;
	gsCurrentspInfo.spellLevel = (spellIDInfo & HENCH_SPELL_INFO_SPELL_LEVEL_MASK) >> HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT;
	gsCurrentspInfo.spellInfo = spellIDInfo;
	
	DispatchSpell(nItemType);
}


void HenchFeatDispatch(int nFeatID, int nSpellID, int bUseCheatCast)
{
//	Jug_Debug(GetName(OBJECT_SELF) + " feat dispatch " + IntToString(nFeatID) + " spell " + IntToString(nSpellID) + " cheat " + IntToString(bUseCheatCast));
	int spellInformation = GetSpellInformation(nSpellID);
    if (spellInformation & HENCH_SPELL_INFO_MASTER_FLAG)
    {
		string sMasterSpellInfoStr = gCurrentSpellInfoStr;
//		Jug_Debug(GetName(OBJECT_SELF) + " running sub spell code");
		int spellID;
		spellID = GetLocalInt(GetModule(), sMasterSpellInfoStr + HENCH_SPELL_TARGET_COLUMN_NAME);
		if (!spellID)
		{
			return;
		}
		HenchFeatDispatch(nFeatID, spellID, TRUE);
		spellID = GetLocalInt(GetModule(), sMasterSpellInfoStr + HENCH_SPELL_EFFECT_TYPES_COLUMN_NAME);
		if (!spellID)
		{
			return;
		}
		HenchFeatDispatch(nFeatID, spellID, TRUE);
		spellID = GetLocalInt(GetModule(), sMasterSpellInfoStr + HENCH_SPELL_DAMAGE_INFO_COLUMN_NAME);
		if (!spellID)
		{
			return;
		}
		HenchFeatDispatch(nFeatID, spellID, TRUE);
		spellID = GetLocalInt(GetModule(), sMasterSpellInfoStr + HENCH_SPELL_SAVE_TYPE_COLUMN_NAME);
		if (!spellID)
		{
			return;
		}
		HenchFeatDispatch(nFeatID, spellID, TRUE);
		spellID = GetLocalInt(GetModule(), sMasterSpellInfoStr + HENCH_SPELL_SAVE_DC_TYPE_COLUMN_NAME);
		if (!spellID)
		{
			return;
		}
		HenchFeatDispatch(nFeatID, spellID, TRUE);
		return;
    }
	
    if (bUseCheatCast)
    {
    	gsCurrentspInfo.castingInfo = HENCH_CASTING_INFO_USE_SPELL_FEATID | HENCH_CASTING_INFO_CHEAT_CAST_FLAG;
    }
	else
	{
    	gsCurrentspInfo.castingInfo = HENCH_CASTING_INFO_USE_SPELL_FEATID;
	}
    gsCurrentspInfo.spellID = nSpellID;
    gsCurrentspInfo.otherID = nFeatID;
	gsCurrentspInfo.spellInfo = spellInformation;
    gsCurrentspInfo.spellLevel = (spellInformation & HENCH_SPELL_INFO_SPELL_LEVEL_MASK) >> HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT;

    DispatchSpell(HENCH_ITEM_TYPE_NONE);
}


void HenchSpontaneousDispatch(int nSpellID, int bForceUnlimited)
{
//Jug_Debug(GetName(OBJECT_SELF) + " doing spontaneous dispatch " + IntToString(nSpellID));
   	gsCurrentspInfo.castingInfo = HENCH_CASTING_INFO_USE_SPELL_REGULAR | HENCH_CASTING_INFO_CHEAT_CAST_FLAG |
		(nMySpellCasterLevel << HENCH_CASTING_INFO_CHEAT_SPELL_LEVEL_SHIFT);
    gsCurrentspInfo.spellID = nSpellID;
    gsCurrentspInfo.otherID = METAMAGIC_NONE;
	int spellInformation = GetSpellInformation(nSpellID);
	if (bForceUnlimited)
	{
		spellInformation |= HENCH_SPELL_INFO_UNLIMITED_FLAG;
	}
	gsCurrentspInfo.spellInfo = spellInformation;
    gsCurrentspInfo.spellLevel = (spellInformation & HENCH_SPELL_INFO_SPELL_LEVEL_MASK) >> HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT;

    DispatchSpell(HENCH_ITEM_TYPE_NONE);
}


int giCheckSpontaneousFlags;
int giCheckSpontaneousLevels;
string gsSpontaneousClassColumn;
string gsSpontaneousClassCache;

int FindItemSpellTalentsByCategory(int nCategory, int maximumToFind, int talentExclude, int nItemType)
{
//	Jug_Debug(GetName(OBJECT_SELF) + " find spells by cat " + IntToString(nCategory) + " max " + IntToString(maximumToFind) + " exclude " + IntToString(talentExclude));
    int spellsFound;
    int testCR = 20;
    talent tBest;
	
    while (testCR >= 0)
    {
//		Jug_Debug("testing talent type " + " category " + IntToString(nCategory) + " exclude " + IntToString(talentExclude) + " cr " + IntToString(testCR));
        talent tBest = GetCreatureTalentBest(nCategory, testCR, OBJECT_SELF, talentExclude);
        if (!GetIsTalentValid(tBest))
        {
            if (spellsFound == 0)
            {
                return 0;
            }
            break;
        }
        int nType = GetTypeFromTalent(tBest);
        if (nType == TALENT_TYPE_SPELL)
        {
            int nNewSpellID = GetIdFromTalent(tBest);
//			Jug_Debug(">>>found talent type " + IntToString(nType) + " id " + Get2DAString("spells", "Label", nNewSpellID) + " category " + IntToString(nCategory) + " exclude " + IntToString(talentExclude) + " cr " + IntToString(testCR));
			int iSpellInformation = GetSpellInformation(nNewSpellID);
            if (!HasItemTalentSpell(nNewSpellID))
            {
//				Jug_Debug(">>>dispatch talent type " + IntToString(nType) + " id " + Get2DAString("spells", "Label", nNewSpellID) + " category " + IntToString(nCategory) + " exclude " + IntToString(talentExclude) + " cr " + IntToString(testCR));
                AddItemTalentSpell(nNewSpellID);
                spellsFound ++;

                HenchTalentSpellDispatch(tBest, nNewSpellID, iSpellInformation, nItemType);
				
				if (giCheckSpontaneousFlags == talentExclude)
				{
					string cacheName = gsSpontaneousClassCache + IntToString(nNewSpellID);
					int cacheValue = GetLocalInt(GetModule(), cacheName);
					if (!cacheValue)
					{
	                	string columnInfo = Get2DAString("spells", gsSpontaneousClassColumn , nNewSpellID);
						int spontaneousSpellLevel = StringToInt(columnInfo);
						if ((spontaneousSpellLevel != 0) || (FindSubString("*", columnInfo) < 0))
						{
							cacheValue = (1 << spontaneousSpellLevel);
	//						Jug_Debug(GetName(OBJECT_SELF) + " spontaneous " + Get2DAString("spells", "Label", nNewSpellID) + " level " + IntToString(spontaneousSpellLevel) + " mask " + IntToHexString(giCheckSpontaneousLevels));					
						}
						else
						{
							cacheValue = 0x80000000;
	//						Jug_Debug(GetName(OBJECT_SELF) + " spontaneous no match " + Get2DAString("spells", "Label", nNewSpellID));					
						}
						SetLocalInt(GetModule(), cacheName, cacheValue);
					}
					giCheckSpontaneousLevels |= cacheValue;				
				}
                if (spellsFound >= maximumToFind)
                {
                    return spellsFound;
                }
            }
	        if (nItemType)
	        {
	            // you can only find one item with GetCreatureTalentBest
	            break;
	        }			
			int curCR = (iSpellInformation & HENCH_SPELL_INFO_SPELL_LEVEL_MASK) >> 12; // HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT - 1 makes it two times spell level
			testCR = testCR < curCR ? testCR : curCR;
        }
		else
		{
/*			if (nType == TALENT_TYPE_FEAT)
			{
				Jug_Debug("!!!!Found talent type " + IntToString(nType) + " id " + Get2DAString("feat", "Label", GetIdFromTalent(tBest)) + " category " + IntToString(nCategory) + " exclude " + IntToString(talentExclude));
			}
			else
			{
				Jug_Debug("!!!!Found talent type " + IntToString(nType) + " id " + Get2DAString("skills", "Label", GetIdFromTalent(tBest)) + " category " + IntToString(nCategory) + " exclude " + IntToString(talentExclude));
			} */
			break;
		}
        testCR -= 2;
    }
	
    int nTry;

    while (nTry < 5)
    {
        tBest = GetCreatureTalentRandom(nCategory, OBJECT_SELF, talentExclude);
        int nType = GetTypeFromTalent(tBest);
        if (nType == TALENT_TYPE_SPELL)
        {
            int nNewSpellID = GetIdFromTalent(tBest);
            int iSpellInformation = GetSpellInformation(nNewSpellID);

//			if (nItemType)
//			{
//				Jug_Debug("!!!!Found talent type " + IntToString(nType) + " id " + Get2DAString("spells", "Label", nNewSpellID) + " category " + IntToString(nCategory) + " exclude " + IntToString(talentExclude));
//			}
            if (!HasItemTalentSpell(nNewSpellID))
            {
//				Jug_Debug(">>>dispatch talent type " + IntToString(nType) + " id " + Get2DAString("spells", "Label", nNewSpellID) + " category " + IntToString(nCategory) + " exclude " + IntToString(talentExclude));
                AddItemTalentSpell(nNewSpellID);
                spellsFound ++;
                HenchTalentSpellDispatch(tBest, nNewSpellID, iSpellInformation, nItemType);				
            }
        }
/*		else
		{
			if (nType == TALENT_TYPE_FEAT)
			{
				Jug_Debug("!!!!Found talent type " + IntToString(nType) + " id " + Get2DAString("feat", "Label", GetIdFromTalent(tBest)) + " category " + IntToString(nCategory) + " exclude " + IntToString(talentExclude));
			}
			else
			{
				Jug_Debug("!!!!Found talent type " + IntToString(nType) + " id " + Get2DAString("skills", "Label", GetIdFromTalent(tBest)) + " category " + IntToString(nCategory) + " exclude " + IntToString(talentExclude));
			}
		} */
        if (spellsFound >= maximumToFind)
        {
            return spellsFound;
        }
        nTry ++;
    }
    return spellsFound;
}


int CheckSpontaneousCureOrInflictSpell(int nSpellID)
{
	if (!GetHasSpell(nSpellID))
	{
		return FALSE;
	}
    int spellInfo = GetSpellInformation(nSpellID);	
	int spellLevel = (spellInfo & HENCH_SPELL_INFO_SPELL_LEVEL_MASK) >> HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT;
	
	if (giCheckSpontaneousLevels & (1 << spellLevel))
	{
//		Jug_Debug(GetName(OBJECT_SELF) + " cure spell " + IntToString(nSpellID) + " " + Get2DAString("spells", "Label", nSpellID) + " spell level " + IntToString(spellLevel) + " mask " + IntToString(giCheckSpontaneousLevels));
		gsCurrentspInfo.spellInfo = spellInfo;	
	    gsCurrentspInfo.spellLevel = spellLevel;
	    gsCurrentspInfo.castingInfo = HENCH_CASTING_INFO_USE_SPELL_CURE_OR_INFLICT | HENCH_CASTING_INFO_CHEAT_CAST_FLAG |
			(nMySpellCasterLevel << HENCH_CASTING_INFO_CHEAT_SPELL_LEVEL_SHIFT);
	    gsCurrentspInfo.range = 4.0;
	    gsCurrentspInfo.shape = HENCH_SHAPE_NONE;
	    gsCurrentspInfo.spellID = nSpellID;
	    gsCurrentspInfo.otherID = METAMAGIC_NONE;
	    HenchSpellAttack(GetCurrentSpellSaveType(), HENCH_SPELL_TARGET_VIS_REQUIRED_FLAG);	
	}

    return TRUE;
}


int CheckSpontaneousMassCureOrInflictSpell(int nSpellID)
{
	if (!GetHasSpell(nSpellID))
	{
		return FALSE;
	}
    int spellInfo = GetSpellInformation(nSpellID);	
	int spellLevel = (spellInfo & HENCH_SPELL_INFO_SPELL_LEVEL_MASK) >> HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT;
	
	if (giCheckSpontaneousLevels & (1 << spellLevel))
	{
//		Jug_Debug(GetName(OBJECT_SELF) + " cure spell " + IntToString(nSpellID) + " " + Get2DAString("spells", "Label", nSpellID) + " spell level " + IntToString(spellLevel) + " mask " + IntToString(giCheckSpontaneousLevels));
		gsCurrentspInfo.spellInfo = spellInfo;	
	    gsCurrentspInfo.spellLevel = spellLevel;
	    gsCurrentspInfo.castingInfo = HENCH_CASTING_INFO_USE_SPELL_CURE_OR_INFLICT | HENCH_CASTING_INFO_CHEAT_CAST_FLAG |
			(nMySpellCasterLevel << HENCH_CASTING_INFO_CHEAT_SPELL_LEVEL_SHIFT);
		gsCurrentspInfo.range = 8.0;
		gsCurrentspInfo.radius = RADIUS_SIZE_LARGE;
		gsCurrentspInfo.shape = SHAPE_SPHERE;
		gsCurrentspInfo.spellID = nSpellID;
	    gsCurrentspInfo.otherID = METAMAGIC_NONE;
		HenchSpellAttack(GetCurrentSpellSaveType(), HENCH_SPELL_TARGET_SHAPE_LOOP);
	}

    return TRUE;
}


int gExcludedItemTalents;   // global flags for excluded talent types, polymorph can change setting
int gbUseSpells;
int gbUseAbilities;
int gbUseItems;


void InitializeSpellTalentCategory(int nCategory)
{
	giItemTalentSpellCount = giItemTalentSpellStart;
	int spellCount = 10;
	if (gbUseSpells)
	{
		spellCount -= FindItemSpellTalentsByCategory(nCategory, spellCount, HENCH_TALENT_USE_SPELLS_ONLY, FALSE);
	}
	if (gbUseAbilities)
	{
		spellCount -= FindItemSpellTalentsByCategory(nCategory, spellCount, HENCH_TALENT_USE_ABILITIES_ONLY, FALSE);
	}
	if (gbUseItems)
	{
		FindItemSpellTalentsByCategory(nCategory, spellCount, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_OTHER);
	}
}


void InitializeSpellTalentCategoryNoItems(int nCategory)
{
	giItemTalentSpellCount = giItemTalentSpellStart;
	int spellCount = 10;
	if (gbUseSpells)
	{
		spellCount -= FindItemSpellTalentsByCategory(nCategory, spellCount, HENCH_TALENT_USE_SPELLS_ONLY, FALSE);
	}
	if (gbUseAbilities)
	{
		FindItemSpellTalentsByCategory(nCategory, spellCount, HENCH_TALENT_USE_ABILITIES_ONLY, FALSE);
	}
}


int gbDisableHighLevelSpells;

void InitializeEpicSpells()
{
	if ((GetHitDice(OBJECT_SELF) <= 20) || gbDisableHighLevelSpells || bgDisablingEffect)
	{
		return;
	}
    if (GetHasFeat(FEAT_EPIC_BLINDING_SPEED))
    {
        HenchFeatDispatch(FEAT_EPIC_BLINDING_SPEED, 647, FALSE);
    }
	// the DC get done wrong due to cheat casting appears to be fixed at +3 ability mod	
    if (GetHasFeat(FEAT_EPIC_SPELL_HELLBALL))
    {
        HenchFeatDispatch(FEAT_EPIC_SPELL_HELLBALL, 636, TRUE);
    }
	if (GetHasFeat(1971 /* FEAT_EPIC_LAST_STAND */) && GetIsObjectValid(GetFactionLeader(OBJECT_SELF)))
    {
        HenchFeatDispatch(1971, 1067, FALSE);
    }
    if (GetHasFeat(1991 /* FEAT_EPIC_SPELL_DAMNATION */))
    {
        HenchFeatDispatch(1991, 1076, FALSE);
    }
    if (GetHasFeat(1992 /* FEAT_EPIC_SPELL_ENTROPIC_HUSK */))
    {
        HenchFeatDispatch(1992, 1077, FALSE);
    }
    if (GetHasFeat(1993 /* FEAT_EPIC_SPELL_EPIC_GATE */))
    {
        HenchFeatDispatch(1993, 1078, FALSE);
    }
    if (GetHasFeat(1995 /* FEAT_EPIC_SPELL_VAMPIRIC_FEAST */))
    {
        HenchFeatDispatch(1995, 1080, FALSE);
    }
}


const int HENCH_CHECK_SPONTANEOUS_HEAL		= 1;
const int HENCH_CHECK_SPONTANEOUS_HARM		= 2;
const int HENCH_CHECK_SPONTANEOUS_SUMMON	= 3;

void InitializeSpellTalents()
{
	int iCheckSpontaneousSpells;
	int iCheckSpontaneousLevels;
	
	if (!bgDisablingEffect)
    {
		if ((gbSpellInfoCastMask & HENCH_SPELL_INFO_HEAL_OR_CURE) &&
			(GetLevelByClass(CLASS_TYPE_CLERIC) > 0))
		{		
			giCheckSpontaneousFlags = HENCH_TALENT_USE_SPELLS_ONLY;
			gsSpontaneousClassColumn = "Cleric";
			gsSpontaneousClassCache = "HenchSpontCleric";
			iCheckSpontaneousSpells = (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_EVIL) ?
				HENCH_CHECK_SPONTANEOUS_HARM : HENCH_CHECK_SPONTANEOUS_HEAL;
		}
	}	

	if (gbUseAbilities)
	{	
		InitializeEpicSpells();
		FindItemSpellTalentsByCategory(TALENT_CATEGORY_DRAGONS_BREATH, 3, HENCH_TALENT_USE_ABILITIES_ONLY, FALSE);
        FindItemSpellTalentsByCategory(TALENT_CATEGORY_PERSISTENT_AREA_OF_EFFECT, 3, HENCH_TALENT_USE_ABILITIES_ONLY, FALSE);
	}

	InitializeSpellTalentCategoryNoItems(TALENT_CATEGORY_HARMFUL_RANGED);	
	InitializeSpellTalentCategoryNoItems(TALENT_CATEGORY_HARMFUL_TOUCH);
	if (iCheckSpontaneousSpells == HENCH_CHECK_SPONTANEOUS_HARM)
	{
		if (HasItemTalentSpell(SPELL_INFLICT_CRITICAL_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x010;
		}
		if (HasItemTalentSpell(SPELL_INFLICT_SERIOUS_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x008;
		}
		if (HasItemTalentSpell(SPELL_INFLICT_MODERATE_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x004;
		}
		if (HasItemTalentSpell(SPELL_INFLICT_LIGHT_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x002;
		}
	}
	InitializeSpellTalentCategoryNoItems(TALENT_CATEGORY_HARMFUL_AREAEFFECT_DISCRIMINANT);
	if (iCheckSpontaneousSpells == HENCH_CHECK_SPONTANEOUS_HARM)
	{
		if (HasItemTalentSpell(SPELL_MASS_INFLICT_CRITICAL_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x100;
		}
		if (HasItemTalentSpell(SPELL_MASS_INFLICT_SERIOUS_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x080;
		}
		if (HasItemTalentSpell(SPELL_MASS_INFLICT_MODERATE_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x040;
		}
		if (HasItemTalentSpell(SPELL_MASS_INFLICT_LIGHT_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x020;
		}
	}
	InitializeSpellTalentCategoryNoItems(TALENT_CATEGORY_HARMFUL_AREAEFFECT_INDISCRIMINANT);
	
	if (gbUseItems)
	{
		giItemTalentSpellCount = giItemTalentSpellStart;
		FindItemSpellTalentsByCategory(TALENT_CATEGORY_HARMFUL_RANGED, 3, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_OTHER);
		giItemTalentSpellCount = giItemTalentSpellStart;
		FindItemSpellTalentsByCategory(TALENT_CATEGORY_HARMFUL_TOUCH, 3, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_OTHER);
		giItemTalentSpellCount = giItemTalentSpellStart;
		FindItemSpellTalentsByCategory(TALENT_CATEGORY_HARMFUL_AREAEFFECT_DISCRIMINANT, 3, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_OTHER);
		giItemTalentSpellCount = giItemTalentSpellStart;
		FindItemSpellTalentsByCategory(TALENT_CATEGORY_HARMFUL_AREAEFFECT_INDISCRIMINANT, 3, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_OTHER);
	}	

	InitializeSpellTalentCategory(TALENT_CATEGORY_BENEFICIAL_OBTAIN_ALLIES);	
	InitializeSpellTalentCategory(TALENT_CATEGORY_DISPEL);
	InitializeSpellTalentCategory(TALENT_CATEGORY_SPELLBREACH);
		
    InitializeSpellTalentCategory(TALENT_CATEGORY_BENEFICIAL_PROTECTION_AREAEFFECT);
    InitializeSpellTalentCategory(TALENT_CATEGORY_BENEFICIAL_PROTECTION_SELF);
	if (gbUseItems)
	{
		FindItemSpellTalentsByCategory(TALENT_CATEGORY_BENEFICIAL_PROTECTION_POTION, 10, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_POTION);
	}
    InitializeSpellTalentCategory(TALENT_CATEGORY_BENEFICIAL_PROTECTION_SINGLE);
    InitializeSpellTalentCategory(TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_AREAEFFECT);
    InitializeSpellTalentCategory(TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_SELF);
	if (gbUseItems)
	{
		FindItemSpellTalentsByCategory(TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_POTION, 10, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_POTION);
	}
    InitializeSpellTalentCategory(TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_SINGLE);
    InitializeSpellTalentCategory(TALENT_CATEGORY_BENEFICIAL_CONDITIONAL_AREAEFFECT);
    InitializeSpellTalentCategory(TALENT_CATEGORY_BENEFICIAL_CONDITIONAL_SINGLE);
	if (gbUseItems)
	{
		FindItemSpellTalentsByCategory(TALENT_CATEGORY_BENEFICIAL_CONDITIONAL_POTION, 10, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_POTION);
	}
		
    // 0 talent category is misc spells (***** category in spells.2da)
    InitializeSpellTalentCategory(0);
		
    InitializeSpellTalentCategoryNoItems(TALENT_CATEGORY_BENEFICIAL_HEALING_TOUCH);
	if (iCheckSpontaneousSpells == HENCH_CHECK_SPONTANEOUS_HEAL)
	{
		if (HasItemTalentSpell(SPELL_CURE_CRITICAL_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x010;
		}
		if (HasItemTalentSpell(SPELL_CURE_SERIOUS_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x008;
		}
		if (HasItemTalentSpell(SPELL_CURE_MODERATE_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x004;
		}
		if (HasItemTalentSpell(SPELL_CURE_LIGHT_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x002;
		}
	}
	if (gbUseItems)
	{
		FindItemSpellTalentsByCategory(TALENT_CATEGORY_BENEFICIAL_HEALING_TOUCH, 3, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_POTION);
		FindItemSpellTalentsByCategory(TALENT_CATEGORY_BENEFICIAL_HEALING_POTION, 3, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_POTION);
	}
    InitializeSpellTalentCategoryNoItems(TALENT_CATEGORY_BENEFICIAL_HEALING_AREAEFFECT);
	if (iCheckSpontaneousSpells == HENCH_CHECK_SPONTANEOUS_HEAL)
	{
		if (HasItemTalentSpell(SPELL_MASS_CURE_CRITICAL_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x100;
		}
		if (HasItemTalentSpell(SPELL_MASS_CURE_SERIOUS_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x080;
		}
		if (HasItemTalentSpell(SPELL_MASS_CURE_MODERATE_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x040;
		}
		if (HasItemTalentSpell(SPELL_MASS_CURE_LIGHT_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x020;
		}
	}
	if (gbUseItems)
	{
		FindItemSpellTalentsByCategory(TALENT_CATEGORY_BENEFICIAL_HEALING_AREAEFFECT, 3, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_POTION);
	}
	
	InitializeSpellTalentCategory(TALENT_CATEGORY_CANTRIP);
	if (iCheckSpontaneousSpells)
	{
		if (iCheckSpontaneousSpells == HENCH_CHECK_SPONTANEOUS_HEAL)
		{
			if (HasItemTalentSpell(SPELL_CURE_MINOR_WOUNDS))			
			{
				iCheckSpontaneousLevels |= 0x001;
			}
		}
		else if (iCheckSpontaneousSpells == HENCH_CHECK_SPONTANEOUS_HARM)
		{
			if (HasItemTalentSpell(SPELL_INFLICT_MINOR_WOUNDS))			
			{
				iCheckSpontaneousLevels |= 0x001;
			}
		}
		
		giCheckSpontaneousLevels &= ~iCheckSpontaneousLevels;

		if (iCheckSpontaneousSpells == HENCH_CHECK_SPONTANEOUS_HEAL)
		{		
			CheckSpontaneousCureOrInflictSpell(SPELL_CURE_CRITICAL_WOUNDS);
			CheckSpontaneousCureOrInflictSpell(SPELL_CURE_SERIOUS_WOUNDS);
			CheckSpontaneousCureOrInflictSpell(SPELL_CURE_MODERATE_WOUNDS);
			CheckSpontaneousCureOrInflictSpell(SPELL_CURE_LIGHT_WOUNDS);
			CheckSpontaneousCureOrInflictSpell(SPELL_CURE_MINOR_WOUNDS);
			
			CheckSpontaneousMassCureOrInflictSpell(SPELL_MASS_CURE_CRITICAL_WOUNDS);
			CheckSpontaneousMassCureOrInflictSpell(SPELL_MASS_CURE_SERIOUS_WOUNDS);
			CheckSpontaneousMassCureOrInflictSpell(SPELL_MASS_CURE_MODERATE_WOUNDS);
			CheckSpontaneousMassCureOrInflictSpell(SPELL_MASS_CURE_LIGHT_WOUNDS);
		}
		else if (iCheckSpontaneousSpells == HENCH_CHECK_SPONTANEOUS_HARM)
		{				
			CheckSpontaneousCureOrInflictSpell(SPELL_INFLICT_CRITICAL_WOUNDS);
			CheckSpontaneousCureOrInflictSpell(SPELL_INFLICT_SERIOUS_WOUNDS);
			CheckSpontaneousCureOrInflictSpell(SPELL_INFLICT_MODERATE_WOUNDS);
			CheckSpontaneousCureOrInflictSpell(SPELL_INFLICT_LIGHT_WOUNDS);
			CheckSpontaneousCureOrInflictSpell(SPELL_INFLICT_MINOR_WOUNDS);
			
			CheckSpontaneousMassCureOrInflictSpell(SPELL_MASS_INFLICT_CRITICAL_WOUNDS);
			CheckSpontaneousMassCureOrInflictSpell(SPELL_MASS_INFLICT_SERIOUS_WOUNDS);
			CheckSpontaneousMassCureOrInflictSpell(SPELL_MASS_INFLICT_MODERATE_WOUNDS);
			CheckSpontaneousMassCureOrInflictSpell(SPELL_MASS_INFLICT_LIGHT_WOUNDS);
		}
	}
}
	

int HenchGetHasInspireBardSongSpellEffect( object oObject=OBJECT_SELF )
{
    if ( GetHasSpellEffect( SPELLABILITY_SONG_INSPIRE_COURAGE, oObject ) ||
//       GetHasSpellEffect( SPELLABILITY_SONG_INSPIRE_COMPETENCE, oObject ) ||
         GetHasSpellEffect( SPELLABILITY_SONG_INSPIRE_DEFENSE, oObject ) ||
//       GetHasSpellEffect( SPELLABILITY_SONG_INSPIRE_REGENERATION, oObject ) ||
         GetHasSpellEffect( SPELLABILITY_SONG_INSPIRE_TOUGHNESS, oObject ) ||
         GetHasSpellEffect( SPELLABILITY_SONG_INSPIRE_SLOWING, oObject ) ||
         GetHasSpellEffect( SPELLABILITY_SONG_INSPIRE_JARRING, oObject ) ||
         GetHasSpellEffect( 1074, oObject )) // FEAT_EPIC_SONG_OF_REQUIEM
    {
        return ( TRUE );
    }

    return ( FALSE );
}


void HenchCheakFeatSpellPacked(int packedInfo)
{
	int nFeat = packedInfo & HENCH_FEAT_SPELL_MASK_FEAT;
//	Jug_Debug(GetName(OBJECT_SELF) + " checking feat " + IntToString(nFeat));
	if (GetHasFeat(nFeat))
	{
		int nSpell = (packedInfo & HENCH_FEAT_SPELL_MASK_SPELL) >> 16;	
//		Jug_Debug(GetName(OBJECT_SELF) + " dispatching spell " + IntToString(nSpell) + " cheat " + IntToString(packedInfo & HENCH_FEAT_SPELL_MASK_SPELL));
		HenchFeatDispatch(nFeat, nSpell, packedInfo & HENCH_FEAT_SPELL_MASK_SPELL);	
	}
}


int HenchReserveGetHasSpellRegular(int nSpell)
{
	int nCount = GetHasSpell(nSpell);
	if (!nCount)
	{
		return FALSE;
	}	
	if ((GetLevelByClass(CLASS_TYPE_BARD) > 3) || (GetLevelByClass(CLASS_TYPE_SORCERER) > 3) ||
		(GetLevelByClass(CLASS_TYPE_FAVORED_SOUL) > 3))
	{
		if (nCount > 1)
		{
			return TRUE;
		}	
	}	
	// reserve the spell
	AddItemTalentSpell(nSpell);
	giItemTalentSpellStart++;
	return TRUE;
}


int HenchReserveGetHasSpellCure(int nSpell)
{
	int nCount = GetHasSpell(nSpell);
	if (!nCount)
	{
		return FALSE;
	}	
	if ((GetLevelByClass(CLASS_TYPE_BARD) > 3) || (GetLevelByClass(CLASS_TYPE_CLERIC) > 3) ||
		(GetLevelByClass(CLASS_TYPE_FAVORED_SOUL) > 3))
	{
		if (nCount > 1)
		{
			return TRUE;
		}	
	}	
	// reserve the spell
	AddItemTalentSpell(nSpell);
	giItemTalentSpellStart++;
	return TRUE;
}


int GetAcidReserveDamageDice()
{
	if (HenchReserveGetHasSpellRegular(173))
		return 9;
	if (HenchReserveGetHasSpellRegular(71)) // Greater_Shadow_Conjuration
		return 7;	
	if (HenchReserveGetHasSpellRegular(0))
		return 6;	
	if (HenchReserveGetHasSpellRegular(873))
		return 5;	
	if (HenchReserveGetHasSpellRegular(1859) || HenchReserveGetHasSpellRegular(1205))
		return 4;		
	if ( HenchReserveGetHasSpellRegular(523) || HenchReserveGetHasSpellRegular(1753) || HenchReserveGetHasSpellRegular(1814) )  // 1753 Energized_Shield, 1814 Weapon_Energy
		return 3;		
	if ( HenchReserveGetHasSpellRegular(115) || HenchReserveGetHasSpellRegular(1747) ) // 1747 Lesser_Energized_Shield
		return 2;		
	return 0;
}

int GetSonicReserveDamageDice()
{
	if ( HenchReserveGetHasSpellRegular(1038) || HenchReserveGetHasSpellRegular(1820) )
		return 8;
	if ( HenchReserveGetHasSpellRegular(1016) || HenchReserveGetHasSpellRegular(1813) || HenchReserveGetHasSpellRegular(2027) )
		return 5;
	if ( HenchReserveGetHasSpellRegular(1861) || HenchReserveGetHasSpellRegular(1037) || HenchReserveGetHasSpellRegular(1743) || HenchReserveGetHasSpellRegular(1173)  || HenchReserveGetHasSpellRegular(1209))
		return 4;
	if ( HenchReserveGetHasSpellRegular(1753) || HenchReserveGetHasSpellRegular(1829) )  // 1753 Energized_Shield
		return 3;
	return 0;
}

int GetFieryBurstReserveDamageDice()
{
	if (HenchReserveGetHasSpellRegular(116) || HenchReserveGetHasSpellRegular(158) || HenchReserveGetHasSpellRegular(48) )
		return 9;
	if (HenchReserveGetHasSpellRegular(89) || HenchReserveGetHasSpellRegular(2025))
		return 8;
	if ( HenchReserveGetHasSpellRegular(39) || HenchReserveGetHasSpellRegular(57) )
		return 7;
	if ( HenchReserveGetHasSpellRegular(61) || HenchReserveGetHasSpellRegular(440) || HenchReserveGetHasSpellRegular(446) || HenchReserveGetHasSpellRegular(869) || HenchReserveGetHasSpellRegular(871) )
		return 5;
	if ( HenchReserveGetHasSpellRegular(47) || HenchReserveGetHasSpellRegular(191) || HenchReserveGetHasSpellRegular(1826) || HenchReserveGetHasSpellRegular(1208))
		return 4;
	if ( HenchReserveGetHasSpellRegular(58) || HenchReserveGetHasSpellRegular(59) || HenchReserveGetHasSpellRegular(1753) || HenchReserveGetHasSpellRegular(1759) || HenchReserveGetHasSpellRegular(1814) )
		return 3;
	if ( HenchReserveGetHasSpellRegular(518) || HenchReserveGetHasSpellRegular(542) || HenchReserveGetHasSpellRegular(851) || HenchReserveGetHasSpellRegular(1001) || HenchReserveGetHasSpellRegular(1055) || 
		HenchReserveGetHasSpellRegular(1747) || HenchReserveGetHasSpellRegular(1858) )
		return 2;
	return 0;
}

int GetAirReserveDamageDice()
{
	if (HenchReserveGetHasSpellRegular(48))
		return 9;
	if (HenchReserveGetHasSpellRegular(2026))
		return 5;
	if (HenchReserveGetHasSpellRegular(75))
		return 2;
	return 0;
}

int GetForceReserveDamageDice()
{
	if (HenchReserveGetHasSpellRegular(463))
		return 9;
	if (HenchReserveGetHasSpellRegular(462))
		return 8;
	if ( HenchReserveGetHasSpellRegular(123) || HenchReserveGetHasSpellRegular(461) )
		return 7;
	if ( HenchReserveGetHasSpellRegular(448) || HenchReserveGetHasSpellRegular(460) )
		return 6;
	if (HenchReserveGetHasSpellRegular(459))
		return 5;
	if ( HenchReserveGetHasSpellRegular(1863) || HenchReserveGetHasSpellRegular(447) )
		return 4;
	return 0;
}

int GetElecReserveDamageDice()
{
	if (HenchReserveGetHasSpellRegular(173))
		return 9;
	if (HenchReserveGetHasSpellRegular(14))
		return 6;
	if (HenchReserveGetHasSpellRegular(1015))
		return 5;
	if (HenchReserveGetHasSpellRegular(1827) || HenchReserveGetHasSpellRegular(1162)  || HenchReserveGetHasSpellRegular(1207))
		return 4;
	if ( HenchReserveGetHasSpellRegular(11) || HenchReserveGetHasSpellRegular(101) || HenchReserveGetHasSpellRegular(526) || HenchReserveGetHasSpellRegular(1753) || HenchReserveGetHasSpellRegular(1814) )
		return 3;
	return 0;
}

int GetNecroReserveLevel()
{
	if ( HenchReserveGetHasSpellRegular(51) || HenchReserveGetHasSpellRegular(190) )
		return 9;
	if ( HenchReserveGetHasSpellRegular(29) || HenchReserveGetHasSpellRegular(367) || HenchReserveGetHasSpellRegular(898) || HenchReserveGetHasSpellRegular(1018) )
		return 8;
	if ( HenchReserveGetHasSpellRegular(28) || HenchReserveGetHasSpellRegular(56) || HenchReserveGetHasSpellRegular(366) || HenchReserveGetHasSpellRegular(895) || 
		HenchReserveGetHasSpellRegular(1032) || HenchReserveGetHasSpellRegular(1796) )
		return 7;
	if ( HenchReserveGetHasSpellRegular(18) || HenchReserveGetHasSpellRegular(30) || HenchReserveGetHasSpellRegular(77) || HenchReserveGetHasSpellRegular(528) || HenchReserveGetHasSpellRegular(892) )
		return 6;
	if ( HenchReserveGetHasSpellRegular(19) || HenchReserveGetHasSpellRegular(23) || HenchReserveGetHasSpellRegular(164) || HenchReserveGetHasSpellRegular(1017) )
		return 5;
	if ( HenchReserveGetHasSpellRegular(38) || HenchReserveGetHasSpellRegular(52) || HenchReserveGetHasSpellRegular(435) || HenchReserveGetHasSpellRegular(1773) )
		return 4;
	if ( HenchReserveGetHasSpellRegular(2) || HenchReserveGetHasSpellRegular(27) || HenchReserveGetHasSpellRegular(54) || HenchReserveGetHasSpellRegular(129) || HenchReserveGetHasSpellRegular(188) || 
		HenchReserveGetHasSpellRegular(434) || HenchReserveGetHasSpellRegular(513) || HenchReserveGetHasSpellRegular(1036) )
		return 3;
	return 0;
}

int GetColdReserveLevel()
{
	if ( HenchReserveGetHasSpellRegular(158) || HenchReserveGetHasSpellRegular(1045))
		return 9;
	if (HenchReserveGetHasSpellRegular(886))
		return 8;
	if (HenchReserveGetHasSpellRegular(25))
		return 5;
	if ( HenchReserveGetHasSpellRegular(47) || HenchReserveGetHasSpellRegular(368) || HenchReserveGetHasSpellRegular(1043) || HenchReserveGetHasSpellRegular(1825) || HenchReserveGetHasSpellRegular(1206) )
		return 4;
	if ( HenchReserveGetHasSpellRegular(1031) || HenchReserveGetHasSpellRegular(1753) || HenchReserveGetHasSpellRegular(1814) )
		return 3;
	if ( HenchReserveGetHasSpellRegular(1042) || HenchReserveGetHasSpellRegular(1747) || HenchReserveGetHasSpellRegular(2028))
		return 2;
	return 0;
}

int GetHealingReserveLevel()
{
	if ( HenchReserveGetHasSpellCure(897) || HenchReserveGetHasSpellRegular(114) )
		return 8;
	if ( HenchReserveGetHasSpellCure(894) || HenchReserveGetHasSpellRegular(374) || HenchReserveGetHasSpellRegular(70) || HenchReserveGetHasSpellRegular(153) )
		return 7;
	if ( HenchReserveGetHasSpellCure(891) || HenchReserveGetHasSpellRegular(79) || HenchReserveGetHasSpellRegular(1023) )
		return 6;
	if ( HenchReserveGetHasSpellCure(80) || HenchReserveGetHasSpellRegular(1030) || HenchReserveGetHasSpellRegular(142) || HenchReserveGetHasSpellRegular(1004) )
		return 5;
	if ( HenchReserveGetHasSpellCure(31) || HenchReserveGetHasSpellRegular(152) )
		return 4;
	if ( HenchReserveGetHasSpellCure(35) || HenchReserveGetHasSpellRegular(126) || HenchReserveGetHasSpellRegular(145) || HenchReserveGetHasSpellRegular(147) || 
		HenchReserveGetHasSpellRegular(1020) || HenchReserveGetHasSpellRegular(1022) )
		return 3;
	if ( HenchReserveGetHasSpellCure(34) || HenchReserveGetHasSpellRegular(149) || HenchReserveGetHasSpellRegular(97) || HenchReserveGetHasSpellRegular(1169) )
		return 2;
	return 0;
}

int GetWarReserveLevel()
{
	if (HenchReserveGetHasSpellRegular(131)) //Level 9
		return 9;
	if (HenchReserveGetHasSpellRegular(132)) //Level 8
		return 8;
	if (HenchReserveGetHasSpellRegular(1011)) //Level 7
		return 7;
	if (HenchReserveGetHasSpellRegular(5)) //Level 6
		return 6;
	if (HenchReserveGetHasSpellRegular(61)) //Level 5
		return 5;
	if (HenchReserveGetHasSpellRegular(42)) //Level 4
		return 4;
	return 0;
}

int GetPolyReserveLevel()
{
	if (HenchReserveGetHasSpellRegular(161)) //Level 9
		return 9;
	if (HenchReserveGetHasSpellRegular(184)) //Level 6
		return 6;
	if (HenchReserveGetHasSpellRegular(130)) //Level 4
		return 4;
	if (HenchReserveGetHasSpellRegular(305))
		return 9;
	return 0;
}


void HenchReserveFeatDispatch(int nFeatID, int nSpellID, int nSpellLevel, int bCheatCast = FALSE)
{
	if (nSpellLevel <= 0)
	{	
		return;
	}	
	if (bCheatCast)
	{
		gsCurrentspInfo.castingInfo = HENCH_CASTING_INFO_USE_SPELL_FEATID | HENCH_CASTING_INFO_CHEAT_CAST_FLAG;
	}
	else
	{
		gsCurrentspInfo.castingInfo = HENCH_CASTING_INFO_USE_SPELL_FEATID;
	}
	gsCurrentspInfo.spellID = nSpellID;
	gsCurrentspInfo.otherID = nFeatID;
	gsCurrentspInfo.spellInfo = GetSpellInformation(nSpellID);
	gsCurrentspInfo.spellLevel = nSpellLevel;
	
	int saveCasterLevel = nMySpellCasterLevel;
	// leave DC as primary ability class
	//nMySpellCasterDC = 10 + GetAbilityModifier(iAbility);
	// change caster level to damage dice (proper number of hit dice)
	nMySpellCasterLevel = nSpellLevel;
	DispatchSpell(HENCH_ITEM_TYPE_NONE);
	nMySpellCasterLevel = saveCasterLevel;
}


void HenchCheckReserveFeats()
{
    if (GetHasFeat(3092 /* FEAT_RESERVE_ACIDIC_SPLATTER */))
    {
        HenchReserveFeatDispatch(3092, 1864, GetAcidReserveDamageDice());
    }
    if (GetHasFeat(3094 /* FEAT_RESERVE_FIERY_BURST */))
    {
        HenchReserveFeatDispatch(3094, 1866, GetFieryBurstReserveDamageDice());
    }
    if (GetHasFeat(3096 /* FEAT_RESERVE_INVISIBLE_NEEDLE */))
    {
        HenchReserveFeatDispatch(3096, 1868, GetForceReserveDamageDice());
    }
    if (GetHasFeat(3097 /* FEAT_RESERVE_MINOR_SHAPESHIFT */))
    {
        HenchReserveFeatDispatch(3097, 1920, GetPolyReserveLevel(), TRUE);
    }
    if (GetHasFeat(3098 /* FEAT_RESERVE_STORM_BOLT */))
    {
        HenchReserveFeatDispatch(3098, 1870, GetElecReserveDamageDice(), TRUE);
    }
    if (GetHasFeat(3099 /* FEAT_RESERVE_SICKENING_GRASP */))
    {
        HenchReserveFeatDispatch(3099, 1871, GetNecroReserveLevel());
    }
    if (GetHasFeat(3101 /* FEAT_RESERVE_WINTERS_BLAST */))
    {
        HenchReserveFeatDispatch(3101, 1873, GetColdReserveLevel(), TRUE);
    }
    if (GetHasFeat(3102 /* FEAT_RESERVE_HOLY_WARRIOR */))
    {
        HenchReserveFeatDispatch(3102, 1874, GetWarReserveLevel(), FALSE);
    }
    if (GetHasFeat(3104 /* FEAT_RESERVE_TOUCH_OF_HEALING */))
    {
        HenchReserveFeatDispatch(3104, 1876,  GetHealingReserveLevel());
    }
    if (GetHasFeat(3093 /* FEAT_RESERVE_CLAP_OF_THUNDER */))
    {
        HenchReserveFeatDispatch(3093, 1865, GetSonicReserveDamageDice());
    }
}


void InitializeFeats()
{
	// check for general feats
    if (GetHasFeat(FEAT_TURN_UNDEAD))
    {
        HenchFeatDispatch(FEAT_TURN_UNDEAD, SPELLABILITY_TURN_UNDEAD, FALSE);

        int abilityModifier = GetAbilityModifier(ABILITY_CHARISMA);
        // in order to prevent constant calling if Charisma low, do random check
        if ((abilityModifier > 0) && ((abilityModifier * abilityModifier) >= Random(100)))
        {
            if (GetHasFeat(FEAT_DIVINE_MIGHT))
            {
                HenchFeatDispatch(FEAT_DIVINE_MIGHT, SPELL_DIVINE_MIGHT, FALSE);
            }
            if (GetHasFeat(FEAT_DIVINE_SHIELD) && (GetPercentageHPLoss(OBJECT_SELF) < 50))
            {
                HenchFeatDispatch(FEAT_DIVINE_SHIELD, SPELL_DIVINE_SHIELD, FALSE);
            }
		    if (GetHasFeat(FEAT_DIVINE_VENGEANCE))
		    {
		        HenchFeatDispatch(FEAT_DIVINE_VENGEANCE, SPELL_DIVINE_VENGEANCE, FALSE);
		    }			
        }
	    if (GetHasFeat(2255 /* FEAT_SACRED_PURIFICATION */))
	    {
	        HenchFeatDispatch(2255, 1215, FALSE);
	    }
    }
	
	// check for class feats
	int iPosition = 1;
    int nClassLevel = GetLevelByPosition(iPosition);	
	while ((nClassLevel > 0) && (iPosition <= 4))
	{
	    int nClass = HenchGetClassByPosition(iPosition, nClassLevel);
		int nClassFlags = HenchGetClassFlags(nClass);
		
		if ((nClassFlags & HENCH_CLASS_FEAT_SPELLS) && (!bgDisablingEffect || (nClassFlags & HENCH_CLASS_IGNORE_SILENCE)))
		{
			// set up casting level, DC			
			int iAbility = ((nClassFlags & HENCH_CLASS_ABILITY_MODIFIER_MASK) >> HENCH_CLASS_ABILITY_MODIFIER_SHIFT) + ABILITY_CONSTITUTION;
			nMySpellCasterDC = 10 + GetAbilityModifier(iAbility);
			nMySpellCasterLevel = nClassLevel;
	    	nMySpellCasterSpellPenetration = nMySpellCasterLevel;
			
//			Jug_Debug(GetName(OBJECT_SELF) + " class " + IntToString(nClass) + " ability " + IntToString(iAbility) + " DC " + IntToString(nMySpellCasterDC));					
			string currentClassInfo = HENCH_CLASS_ID_INFO + IntToString(nClass);
			int featSpellIndex = 1;
			while (TRUE)
			{
				int featSpellInfo = GetLocalInt(GetModule(), currentClassInfo + HENCH_CLASS_FEATS_SEPERATOR + IntToString(featSpellIndex));				
				if (!featSpellInfo)
				{
					break;
				}
//				Jug_Debug(GetName(OBJECT_SELF) + " class " + IntToString(nClass) + " get feat spell " + IntToHexString(featSpellInfo));
				HenchCheakFeatSpellPacked(featSpellInfo);
				featSpellIndex ++;
			}						
			if (nClass == CLASS_TYPE_SPIRIT_SHAMAN)
			{		
		        if (GetIsSpirit(GetLocalObject(OBJECT_SELF, sEnemyLineOfSight)))
		        {
//          		Jug_Debug(GetName(OBJECT_SELF) + " checking spirit shaman abilities");
		            if (GetHasFeat(FEAT_CHASTISE_SPIRITS))
		            {
//              		Jug_Debug(GetName(OBJECT_SELF) + " spirit shaman chastise");
		                HenchFeatDispatch(FEAT_CHASTISE_SPIRITS, 1094, FALSE);
		                // TODO Weaken Spirits?
		            }
		            if (GetHasFeat(2021) && GetIsObjectValid(GetFactionLeader(OBJECT_SELF)))
		            {
//              		Jug_Debug(GetName(OBJECT_SELF) + " spirit shaman warding");
		                HenchFeatDispatch(2021, SPELLABILITY_WARDING_OF_THE_SPIRITS, FALSE);
		            }
		        }
			}
		}				
		nClassLevel = GetLevelByPosition(++iPosition);
	}
	
    if (GetHasFeat(FEAT_WILD_SHAPE) && !(bgDisablingEffect & HENCH_DISABLE_EFFECT_SILENCE))
    {
            // note: elephant's hide and oaken resilience are free actions
        if (GetHasFeat(FEAT_ELEPHANTS_HIDE) && !GetHasSpell(SPELL_TORTOISE_SHELL)
            && (gbSpellInfoCastMask & HENCH_SPELL_INFO_MEDIUM_DUR_BUFF))
        {
            int posEffects = GetCreaturePosEffects(OBJECT_SELF);
            if (!(posEffects & HENCH_EFFECT_TYPE_POLYMORPH))
            {
                if (!(posEffects & HENCH_EFFECT_TYPE_AC_INCREASE) ||
                    (GetCreatureACBonus(OBJECT_SELF, AC_NATURAL_BONUS) <= 5))
                {
//						Jug_Debug(GetName(OBJECT_SELF) + " using elephant hide");
                    ActionUseFeat(FEAT_ELEPHANTS_HIDE, OBJECT_SELF);
                }
            }
        }
        if (GetHasFeat(FEAT_OAKEN_RESILIENCE) && !(GetHasFeat(FEAT_ELEMENTAL_SHAPE) ||
            GetHasFeat(FEAT_EPIC_WILD_SHAPE_DRAGON) || GetHasFeat(2111) ||
            GetHenchAssociateState(HENCH_ASC_DISABLE_POLYMORPH)) &&
            (gbSpellInfoCastMask & HENCH_SPELL_INFO_MEDIUM_DUR_BUFF))
        {
            if (!GetIsImmune(OBJECT_SELF, IMMUNITY_TYPE_CRITICAL_HIT))
            {
//					Jug_Debug(GetName(OBJECT_SELF) + " using oaken resilience");
                ActionUseFeat(FEAT_OAKEN_RESILIENCE, OBJECT_SELF);
            }
        }
        HenchFeatDispatch(FEAT_WILD_SHAPE, SPELLABILITY_WILD_SHAPE_BROWN_BEAR, TRUE);

        if (GetHasFeat(FEAT_EPIC_WILD_SHAPE_DRAGON))
        {
            HenchFeatDispatch(FEAT_WILD_SHAPE, 707, TRUE);
            HenchFeatDispatch(FEAT_WILD_SHAPE, 708, TRUE);
            HenchFeatDispatch(FEAT_WILD_SHAPE, 709, TRUE);
        }
        if (GetHasFeat(2001))
        {
            HenchFeatDispatch(FEAT_WILD_SHAPE, SPELLABILITY_MAGICAL_BEAST_WILD_SHAPE_WINTER_WOLF, TRUE);
        }
        if (GetHasFeat(2111))
        {
            HenchFeatDispatch(FEAT_WILD_SHAPE, SPELLABILITY_PLANT_WILD_SHAPE_TREANT, TRUE);
        }
    }
	if ((GetLevelByClass(CLASS_TYPE_BARD) > 0) && !(bgDisablingEffect & HENCH_DISABLE_EFFECT_SILENCE))
	{		
		nMySpellCasterDC = 10 + GetAbilityModifier(ABILITY_CHARISMA);
		nMySpellCasterLevel = GetBardicClassLevel(OBJECT_SELF);
    	nMySpellCasterSpellPenetration = nMySpellCasterLevel;
		if (GetHasFeat(FEAT_BARD_SONGS))
		{
			if (!GetHasNormalBardSongSpellEffect())
			{
				if (GetHasFeat(FEAT_BARDSONG_COUNTERSONG))
				{
					HenchFeatDispatch(FEAT_BARDSONG_COUNTERSONG, SPELLABILITY_SONG_COUNTERSONG, FALSE);
				}
/*				if (GetHasFeat(FEAT_BARDSONG_FASCINATE)) effect has a problem with the AI
				{
					HenchFeatDispatch(FEAT_BARDSONG_FASCINATE, SPELLABILITY_SONG_FASCINATE, FALSE);
				} */
				if (GetHasFeat(FEAT_BARDSONG_HAVEN_SONG))
				{
					HenchFeatDispatch(FEAT_BARDSONG_HAVEN_SONG, SPELLABILITY_SONG_HAVEN_SONG, FALSE);
				}
				if (GetHasFeat(FEAT_BARDSONG_INSPIRE_HEROICS))
				{
					if (GetHasFeat(FEAT_EPIC_CHORUS_OF_HEROISM, OBJECT_SELF, TRUE))
					{
						if (GetIsObjectValid(GetFactionLeader(OBJECT_SELF)))
						{						
							HenchFeatDispatch(FEAT_EPIC_CHORUS_OF_HEROISM, 1158, FALSE);
						}
					}
					else
					{
						HenchFeatDispatch(FEAT_BARDSONG_INSPIRE_HEROICS, SPELLABILITY_SONG_INSPIRE_HEROICS, FALSE);
					}
				}
				if (GetHasFeat(FEAT_BARDSONG_INSPIRE_LEGION) && GetIsObjectValid(GetFactionLeader(OBJECT_SELF)))
				{
					HenchFeatDispatch(FEAT_BARDSONG_INSPIRE_LEGION, SPELLABILITY_SONG_INSPIRE_LEGION, FALSE);
				}
				// Not done FEAT_BARDSONG_IRONSKIN_CHANT (faction only), FEAT_BARDSONG_SONG_OF_FREEDOM, Song_Cloud_Mind
			}
			if (GetHasFeat(FEAT_CURSE_SONG))
			{
				object oTest = GetLocalObject(OBJECT_SELF, sEnemyLineOfSight);
				int bUseCurseSong;
				while (GetIsObjectValid(oTest))
				{
					if (GetHasSpellEffect(SPELLABILITY_EPIC_CURSE_SONG, oTest))
					{
						bUseCurseSong = FALSE;
						break;
					}					
					bUseCurseSong = TRUE;
					oTest = GetLocalObject(oTest, sEnemyLineOfSight);					
				}
				if (bUseCurseSong)
				{
					HenchFeatDispatch(FEAT_CURSE_SONG, SPELLABILITY_EPIC_CURSE_SONG, FALSE);
				}
			}
			if (GetHasFeat(1988) && !GetHasSpellEffect(1074, OBJECT_SELF)) // FEAT_EPIC_SONG_OF_REQUIEM
			{
				HenchFeatDispatch(1988, 1074, FALSE);
			}
		}
		if (!HenchGetHasInspireBardSongSpellEffect())
		{
			if (GetHasFeat(FEAT_BARDSONG_INSPIRE_COURAGE))
			{
				HenchFeatDispatch(FEAT_BARDSONG_INSPIRE_COURAGE, SPELLABILITY_SONG_INSPIRE_COURAGE, FALSE);
			}
			if (GetHasFeat(FEAT_BARDSONG_INSPIRE_DEFENSE))
			{
				HenchFeatDispatch(FEAT_BARDSONG_INSPIRE_DEFENSE, SPELLABILITY_SONG_INSPIRE_DEFENSE, FALSE);
			}
			/* if (GetHasFeat(FEAT_BARDSONG_INSPIRE_JARRING))
			{
				HenchFeatDispatch(FEAT_BARDSONG_INSPIRE_JARRING, SPELLABILITY_SONG_INSPIRE_JARRING, FALSE);
			} */
			if (GetHasFeat(FEAT_BARDSONG_INSPIRE_REGENERATION))
			{
				HenchFeatDispatch(FEAT_BARDSONG_INSPIRE_REGENERATION, SPELLABILITY_SONG_INSPIRE_REGENERATION, FALSE);
			}
			/* if (GetHasFeat(FEAT_BARDSONG_INSPIRE_SLOWING))
			{
				HenchFeatDispatch(FEAT_BARDSONG_INSPIRE_SLOWING, SPELLABILITY_SONG_INSPIRE_SLOWING, FALSE);
			} */
			if (GetHasFeat(FEAT_BARDSONG_INSPIRE_TOUGHNESS))
			{
				HenchFeatDispatch(FEAT_BARDSONG_INSPIRE_TOUGHNESS, SPELLABILITY_SONG_INSPIRE_TOUGHNESS, FALSE);
			}
			// Not done FEAT_BARDSONG_INSPIRE_COMPETENCE
		}
	}
		
	// check for racial sub type feats
	int nRacialSubType = GetSubRace(OBJECT_SELF);
	string currentRacialInfo = HENCH_RACIAL_ID_INFO + IntToString(nRacialSubType);	
	int nRacialFlags = GetLocalInt(GetModule(), currentRacialInfo);
	if ((nRacialFlags & HENCH_SPELL_INFO_VERSION_MASK) != HENCH_SPELL_INFO_VERSION)
	{
//		Jug_Debug(GetName(OBJECT_SELF) + " racial info " + IntToString(nRacialFlags) + " not found in cache");	
        nRacialFlags = StringToInt(Get2DAString(HENCH_RACIAL_ID_TABLE, HENCH_RACIAL_ID_FLAGS_COLUMN, nRacialSubType));
		if (nRacialFlags == 0)
		{
            nRacialFlags = HENCH_SPELL_INFO_VERSION;
		}
		else
		{
			if (nRacialFlags & HENCH_RACIAL_FEAT_SPELLS)
			{
				int featSpellIndex = 1;
				while (TRUE)
				{
					int featSpellInfo = StringToInt(Get2DAString(HENCH_RACIAL_ID_TABLE, HENCH_RACIAL_FEATS_COLUMN + IntToString(featSpellIndex), nRacialSubType));					
					if (!featSpellInfo)
					{
						break;
					}
//					Jug_Debug(GetName(OBJECT_SELF) + " racial type " + IntToString(nRacialSubType) + " add feat spell " + IntToHexString(featSpellInfo));	
					SetLocalInt(GetModule(), currentRacialInfo + HENCH_RACIAL_FEATS_SEPERATOR + IntToString(featSpellIndex), featSpellInfo);				
					featSpellIndex ++;
				}
				DeleteLocalInt(GetModule(), currentRacialInfo + HENCH_RACIAL_FEATS_SEPERATOR + IntToString(featSpellIndex));
			}
		}
		SetLocalInt(GetModule(), currentRacialInfo, nRacialFlags);	
	}
//	Jug_Debug(GetName(OBJECT_SELF) + " racial sub type " + IntToString(nRacialSubType) + " nRacialFlags " + IntToHexString(nRacialFlags));	

	if ((nRacialFlags & HENCH_RACIAL_FEAT_SPELLS) && !bgDisablingEffect)
	{	
		nMySpellCasterDC = 10 + GetAbilityModifier(ABILITY_CHARISMA);
		nMySpellCasterLevel = GetTotalLevels(OBJECT_SELF, TRUE);
    	nMySpellCasterSpellPenetration = nMySpellCasterLevel;
	
		int featSpellIndex = 1;
		while (TRUE)
		{
			int featSpellInfo = GetLocalInt(GetModule(), currentRacialInfo + HENCH_RACIAL_FEATS_SEPERATOR + IntToString(featSpellIndex));				
			if (!featSpellInfo)
			{
				break;
			}
//			Jug_Debug(GetName(OBJECT_SELF) + " racial " + IntToString(nRacialSubType) + " get feat spell " + IntToHexString(featSpellInfo));
			HenchCheakFeatSpellPacked(featSpellInfo);
			featSpellIndex ++;
		}
	}
    if (GetHasFeat(FEAT_FEY_HERITAGE) && !bgDisablingEffect)
    {
		nMySpellCasterDC = 10 + GetAbilityModifier(ABILITY_CHARISMA);
		nMySpellCasterLevel = GetTotalLevels(OBJECT_SELF, TRUE);
    	nMySpellCasterSpellPenetration = nMySpellCasterLevel;
        if (GetHasFeat(FEAT_FEY_LEGACY))
        {
            HenchFeatDispatch(FEAT_FEY_LEGACY, 26, TRUE);
        }
        if (GetHasFeat(FEAT_FEY_PRESENCE))
        {
            HenchFeatDispatch(FEAT_FEY_PRESENCE, 855, TRUE);
        }
    }
    else if (GetHasFeat(FEAT_FIENDISH_HERITAGE) && !bgDisablingEffect)
    {
		nMySpellCasterDC = 10 + GetAbilityModifier(ABILITY_CHARISMA);
		nMySpellCasterLevel = GetTotalLevels(OBJECT_SELF, TRUE);
    	nMySpellCasterSpellPenetration = nMySpellCasterLevel;
        if (GetHasFeat(FEAT_FIENDISH_LEGACY))
        {
            HenchFeatDispatch(FEAT_FIENDISH_LEGACY, 179, TRUE);
        }
        if (GetHasFeat(FEAT_FIENDISH_PRESENCE))
        {
            HenchFeatDispatch(FEAT_FIENDISH_PRESENCE, 54, TRUE);
        }
    }
	int nAtWillSpell = GetLocalInt(OBJECT_SELF, HENCH_AT_WILL_SPELL_ONE);
	if (nAtWillSpell)
	{
		nMySpellCasterDC = 10 + GetAbilityModifier(ABILITY_CHARISMA);		
		nMySpellCasterLevel = GetLocalInt(OBJECT_SELF, HENCH_AT_WILL_CASTER_LEVEL);
		if (nMySpellCasterLevel <= 0)
		{
			nMySpellCasterLevel = 10;
		}		
    	nMySpellCasterSpellPenetration = nMySpellCasterLevel;	
		int nAtWillIndex = 1;	
		do		
		{		
//			Jug_Debug(GetName(OBJECT_SELF) + " at spell " + IntToString(nAtWillSpell) + " caster level " + IntToString(nMySpellCasterLevel));
			HenchSpontaneousDispatch(nAtWillSpell, TRUE);		
			nAtWillIndex ++;
			nAtWillSpell = GetLocalInt(OBJECT_SELF, HENCH_AT_WILL_SPELL_START + IntToString(nAtWillIndex));		
		} 	while (nAtWillSpell);	
	}
}


void InitializeWarlockAttackSpell(int nSpellID, int nSpellLevel)
{
    int originalSpellInformation = GetSpellInformation(nSpellID);
    int saveType = GetCurrentSpellSaveType();

//  Jug_Debug(GetName(OBJECT_SELF) + " test warlock spell " + IntToString(nSpellID));

//      spInfo.tTalent = tTalent;
    gsCurrentspInfo.spellInfo = originalSpellInformation;
    gsCurrentspInfo.castingInfo = HENCH_CASTING_INFO_USE_SPELL_WARLOCK;
    gsCurrentspInfo.spellID = nSpellID;

    if (GetHasSpell(SPELL_I_ELDRITCH_SPEAR))
    {
//  Jug_Debug(GetName(OBJECT_SELF) + " test warlock spear");
        gsCurrentspInfo.spellLevel = 1;
        gsCurrentspInfo.otherID = SPELL_I_ELDRITCH_SPEAR;
        gsCurrentspInfo.range = 40.0;
        gsCurrentspInfo.shape = HENCH_SHAPE_NONE;
        HenchSpellAttack(saveType | HENCH_SPELL_SAVE_TYPE_TOUCH_RANGE_FLAG, HENCH_SPELL_TARGET_VIS_REQUIRED_FLAG);
    }
    if (GetHasSpell(SPELL_I_HIDEOUS_BLOW))
    {
//  Jug_Debug(GetName(OBJECT_SELF) + " test warlock hideous has weapon " + IntToString(GetInitWeaponStatus() & HENCH_AI_HAS_MELEE));
        if ((GetDistanceToObject(ogClosestSeenOrHeardEnemy) < 5.0) &&
            (GetInitWeaponStatus() & HENCH_AI_HAS_MELEE))
        {
//  Jug_Debug(GetName(OBJECT_SELF) + " test warlock hideous");
            gsCurrentspInfo.spellLevel = 1;
            gsCurrentspInfo.otherID = SPELL_I_HIDEOUS_BLOW;
            gsCurrentspInfo.range = 5.0;
            gsCurrentspInfo.shape = HENCH_SHAPE_NONE;
            HenchSpellAttack(saveType, 0);
        }
    }
    if (GetHasSpell(SPELL_I_ELDRITCH_CONE))
    {
//  Jug_Debug(GetName(OBJECT_SELF) + " test warlock cone");
        gsCurrentspInfo.spellLevel = 3;
        gsCurrentspInfo.otherID = SPELL_I_ELDRITCH_CONE;
        gsCurrentspInfo.shape = SHAPE_SPELLCONE;
        gsCurrentspInfo.radius = 11.0;
        gsCurrentspInfo.range = 8.0;
		// shift over save info to second position		
		int originalSave1Info = (saveType & HENCH_SPELL_SAVE_TYPE_SAVES1_MASK) * HENCH_SPELL_SAVE_TYPE_SAVE12_SHIFT;		
        HenchSpellAttack((saveType & HENCH_SPELL_SAVE_TYPE_SAVES1_MASK_REMOVE) | HENCH_SPELL_SAVE_TYPE_SAVE1_REFLEX |
			HENCH_SPELL_SAVE_TYPE_SAVE1_DAMAGE_EVASION | HENCH_SPELL_SAVE_TYPE_CHECK_FRIENDLY_FLAG |
			HENCH_SPELL_SAVE_TYPE_NOTSELF_FLAG | originalSave1Info, HENCH_SPELL_TARGET_SHAPE_LOOP);
    }
    gsCurrentspInfo.range = 20.0;       // the rest of the spells have range 20
    if (GetHasSpell(SPELL_I_ELDRITCH_CHAIN))
    {
//  Jug_Debug(GetName(OBJECT_SELF) + " test warlock chain");
        gsCurrentspInfo.spellLevel = 2;
        gsCurrentspInfo.otherID = SPELL_I_ELDRITCH_CHAIN;
        gsCurrentspInfo.shape = SHAPE_SPHERE;
        gsCurrentspInfo.radius = RADIUS_SIZE_COLOSSAL;
        HenchSpellAttack(saveType | HENCH_SPELL_SAVE_TYPE_TOUCH_RANGE_FLAG | HENCH_SPELL_SAVE_TYPE_NOTSELF_FLAG, HENCH_SPELL_TARGET_SHAPE_LOOP | HENCH_SPELL_TARGET_VIS_REQUIRED_FLAG | HENCH_SPELL_TARGET_SECONDARY_TARGETS | HENCH_SPELL_TARGET_CHECK_COUNT | HENCH_SPELL_TARGET_SECONDARY_HALF_DAM);
    }
    if (GetHasSpell(SPELL_I_ELDRITCH_DOOM))
    {
//  Jug_Debug(GetName(OBJECT_SELF) + " test warlock doom");
        gsCurrentspInfo.spellLevel = 4;
        gsCurrentspInfo.otherID = SPELL_I_ELDRITCH_DOOM;
        gsCurrentspInfo.shape = SHAPE_SPHERE;
        gsCurrentspInfo.radius = RADIUS_SIZE_HUGE;
		// shift over save info to second position		
		int originalSave1Info = (saveType & HENCH_SPELL_SAVE_TYPE_SAVES1_MASK) * HENCH_SPELL_SAVE_TYPE_SAVE12_SHIFT;		
        HenchSpellAttack((saveType & HENCH_SPELL_SAVE_TYPE_SAVES1_MASK_REMOVE) | HENCH_SPELL_SAVE_TYPE_SAVE1_REFLEX |
			HENCH_SPELL_SAVE_TYPE_SAVE1_DAMAGE_EVASION | HENCH_SPELL_SAVE_TYPE_CHECK_FRIENDLY_FLAG |
			originalSave1Info, HENCH_SPELL_TARGET_SHAPE_LOOP);
    }
//  Jug_Debug(GetName(OBJECT_SELF) + " test warlock none");
    gsCurrentspInfo.spellLevel = nSpellLevel;
    gsCurrentspInfo.otherID = -1;
    gsCurrentspInfo.shape = HENCH_SHAPE_NONE;
	if ((nSpellID == SPELLABILITY_I_ELDRITCH_BLAST) && (giWarlockDamageDice > 9))
	{
		// for some reason raw eldritch blast ingnores spell resistance at the 10th dice
		saveType &= ~HENCH_SPELL_SAVE_TYPE_SR_FLAG;
	}
    HenchSpellAttack(saveType | HENCH_SPELL_SAVE_TYPE_TOUCH_RANGE_FLAG, HENCH_SPELL_TARGET_VIS_REQUIRED_FLAG);
}


void InitializeWarlockAttackSpells()
{
    if (!gbUseSpells)
    {
        return;
    }
    int warlockLevel = GetLevelByClass(CLASS_TYPE_WARLOCK);
    if (warlockLevel < 1)
    {
        return;
    }	
	// epic warlock spells
	if (gbUseAbilities && (GetHitDice(OBJECT_SELF) > 20) && !gbDisableHighLevelSpells  && !bgDisablingEffect)
	{	
	    if (GetHasFeat(1996 /* FEAT_EPIC_SPELL_DAMNATION_WARLOCK */))
	    {
	        HenchFeatDispatch(1996, 1076, FALSE);
	    }
	    if (GetHasFeat(1997 /* FEAT_EPIC_SPELL_ENTROPIC_HUSK_WARLOCK */))
	    {
	        HenchFeatDispatch(1997, 1077, FALSE);
	    }
	    if (GetHasFeat(1998 /* FEAT_EPIC_SPELL_EPIC_GATE_WARLOCK */))
	    {
	        HenchFeatDispatch(1998, 1078, FALSE);
	    }
	    if (GetHasFeat(1999 /* FEAT_EPIC_SPELL_HELLBALL_WARLOCK */))
	    {
	        HenchFeatDispatch(1999, 636, TRUE);
	    }
	    if (GetHasFeat(2000 /* FEAT_EPIC_SPELL_VAMPIRIC_FEAST_WARLOCK */))
	    {
	        HenchFeatDispatch(2000, 1080, FALSE);
	    }
	    if (GetHasFeat(3224 /* FEAT_EPIC_SPELL_EPIC_GATE */))
	    {
	        HenchFeatDispatch(3224, 1078, FALSE);
	    }	
	}	
	
    if (!(HENCH_SPELL_INFO_UNLIMITED_FLAG & gbSpellInfoCastMask))
    {
        return;
    }
	// adjust warlock level for PrCs
	if (GetHasFeat(3271 /*FEAT_HEARTWARDER_SPELLCASTING_WARLOCK*/))
	{
		warlockLevel += GetLevelByClass(131 /*CLASS_HEARTWARDER*/);
	}
	if (GetHasFeat(3545 /*FEAT_STORMSINGER_SPELLCASTING_WARLOCK*/))
	{
		warlockLevel += GetLevelByClass(109 /*CLASS_STORMSINGER*/);
	}
	if (GetHasFeat(3341 /*FEAT_KOT_SPELLCASTING_WARLOCK*/))
	{
		warlockLevel += GetLevelByClass(132 /*CLASS_KNIGHT_TIERDRIAL*/);
	}
	if (GetHasFeat(3372 /*FEAT_DRSLR_SPELLCASTING_WARLOCK*/))
	{
		warlockLevel += (GetLevelByClass(134 /*CLASS_DRAGONSLAYER*/) + 1) / 2;
	}
	
    if (warlockLevel > 20)
    {
        giWarlockDamageDice = (warlockLevel - 2) / 2;
    	giWarlockMinSaveDC = nMySpellCasterDC + 9 + (warlockLevel - 20) / 3;
    }
	else
	{
	    if (warlockLevel <= 12)
	    {
	        giWarlockDamageDice = (warlockLevel + 1) / 2;
	    }
	    else
	    {
	        giWarlockDamageDice = (warlockLevel + 7) / 3;
	    }
	    giWarlockMinSaveDC = nMySpellCasterDC + giWarlockDamageDice;
	}
	
	int saveOldSpellCasterSpellPenetration = nMySpellCasterSpellPenetration;
	if (warlockLevel > 9)
	{
		// warlock caster level seems to be capped at level 9 for spell resistance
		nMySpellCasterSpellPenetration -= warlockLevel - 9;
	}	
	
    int featIndex;
    for (featIndex = FEAT_EPIC_ELDRITCH_BLAST_1; featIndex <= FEAT_EPIC_ELDRITCH_BLAST_10; featIndex++)
    {
        if (!GetHasFeat(featIndex))
        {
            break;
        }
        giWarlockDamageDice++;
    }
		// Fey Power Heritage Feat gives +1 to Warlock Level for this
	if (GetHasFeat(FEAT_FEY_POWER) || GetHasFeat(FEAT_FIENDISH_POWER))						
	{ 
        giWarlockDamageDice++;
	}
    gbWarlockMaster = GetHasFeat(FEAT_EPIC_ELDRITCH_MASTER);

    InitializeWarlockAttackSpell(SPELLABILITY_I_ELDRITCH_BLAST, giWarlockDamageDice);
    if (GetHasSpell(SPELL_I_VITRIOLIC_BLAST))
    {
        InitializeWarlockAttackSpell(SPELL_I_VITRIOLIC_BLAST, 3);
    }
    if (GetHasSpell(SPELL_I_UTTERDARK_BLAST))
    {
        InitializeWarlockAttackSpell(SPELL_I_UTTERDARK_BLAST, 4);
    }
    if (GetHasSpell(SPELL_I_NOXIOUS_BLAST))
    {
        InitializeWarlockAttackSpell(SPELL_I_NOXIOUS_BLAST, 3);
    }
    if (GetHasSpell(SPELL_I_BEWITCHING_BLAST))
    {
        InitializeWarlockAttackSpell(SPELL_I_BEWITCHING_BLAST, 3);
    }
    if (GetHasSpell(1131))	// binding blast
    {
        InitializeWarlockAttackSpell(1131, 7);
    }
    if (GetHasSpell(1130))	// hindering blast
    {
        InitializeWarlockAttackSpell(1130, 4);
    }
    if (GetHasSpell(SPELL_I_HELLRIME_BLAST))
    {
        InitializeWarlockAttackSpell(SPELL_I_HELLRIME_BLAST, 2);
    }
    if (GetHasSpell(SPELL_I_BRIMSTONE_BLAST))
    {
        InitializeWarlockAttackSpell(SPELL_I_BRIMSTONE_BLAST, 2);
    }
    if (GetHasSpell(SPELL_I_BESHADOWED_BLAST))
    {
        InitializeWarlockAttackSpell(SPELL_I_BESHADOWED_BLAST, 2);
    }
    if (GetHasSpell(SPELL_I_DRAINING_BLAST))
    {
        InitializeWarlockAttackSpell(SPELL_I_DRAINING_BLAST, 1);
    }
    if (GetHasSpell(SPELL_I_FRIGHTFUL_BLAST))
    {
        InitializeWarlockAttackSpell(SPELL_I_FRIGHTFUL_BLAST, 1);
    }
	
	nMySpellCasterSpellPenetration = saveOldSpellCasterSpellPenetration;
}


void InitializeSpellCasting()
{
	int spellCastingLevel;	
	int spellCastingFlags;	
	int prcBonusSpellCastingLevel;
	int sneakAttackDice;

	int iPosition = 1;
    int nClassLevel = GetLevelByPosition(iPosition);
	
	while ((nClassLevel > 0) && (iPosition <= 4))
	{
	    int nClass = HenchGetClassByPosition(iPosition, nClassLevel);
		int nClassFlags = HenchGetClassFlags(nClass);		
		int testSpellProgFlags = nClassFlags & HENCH_CLASS_SPELL_PROG_MASK;
		if (testSpellProgFlags && !((nClassFlags & HENCH_CLASS_FOURTH_LEVEL_NEEDED) && (nClassLevel < 5)))
		{				
			int testSpellCastingLevel;		
			switch (testSpellProgFlags)
			{
				case HENCH_FULL_SPELL_PROGRESSION:
					testSpellCastingLevel = nClassLevel;
					break;
				case HENCH_SKIP_FIRST_SPELL_PROGRESSION:
					testSpellCastingLevel = nClassLevel - 1;
					break;
				case HENCH_EVERY_OTHER_ODD_SPELL_PROGRESSION:
					testSpellCastingLevel = (nClassLevel + 1) / 2;
					break;
				case HENCH_EVERY_OTHER_EVEN_SPELL_PROGRESSION:
					testSpellCastingLevel = nClassLevel / 2;
					break;
				case HENCH_SKIP_FOURTH_SPELL_PROGRESSION:
	            	testSpellCastingLevel = nClassLevel - nClassLevel / 4;
					break;
				case HENCH_SKIP_FIRST_THIRD_SPELL_PROGRESSION:
	            	testSpellCastingLevel = nClassLevel * 2 / 3;
					break;
			}			
			if (nClassFlags & HENCH_CLASS_PRC_FLAG)
			{			
				prcBonusSpellCastingLevel += testSpellCastingLevel;			
			}
			else
			{			
				int practicedSpellCasterFeat = GetLocalInt(GetModule(), HENCH_CLASS_PS_INFO + IntToString(nClass));
//				Jug_Debug(GetName(OBJECT_SELF) + " class " + IntToString(nClass) + " practiced spellcaster " + IntToString(practicedSpellCasterFeat));				
		        if (practicedSpellCasterFeat && GetHasFeat(practicedSpellCasterFeat))
		        {
		            testSpellCastingLevel += 4;
		        }
				if (testSpellCastingLevel > spellCastingLevel)
				{
					spellCastingLevel = testSpellCastingLevel;
					spellCastingFlags = nClassFlags;
				}				
			}
			if (nClassFlags & HENCH_CLASS_DIVINE_FLAG)
			{			
            	bAnySpellcastingClasses |= HENCH_DIVINE_SPELLCASTING;
			}
			else
			{			
				if (!GetHasFeat(FEAT_EPIC_AUTOMATIC_STILL_SPELL_3))
				{
				    if (nClass == CLASS_TYPE_SORCERER || nClass == CLASS_TYPE_WIZARD)
				    {
				        if (GetArcaneSpellFailure(OBJECT_SELF) > 20)
				        {
        					gExcludedItemTalents |= TALENT_EXCLUDE_SPELL;
				        }
				    }
				    else if (nClass == CLASS_TYPE_BARD || nClass == CLASS_TYPE_WARLOCK)
				    {
				                                    // FEAT_ARMORED_CASTER_BARD FEAT_ARMORED_CASTER_WARLOCK
				        if (GetArcaneSpellFailure(OBJECT_SELF) > ((GetHasFeat(1859) || GetHasFeat(1860)) ? 45 : 30))
				        {
        					gExcludedItemTalents |= TALENT_EXCLUDE_SPELL;
				        }
				    }
				}
            	bAnySpellcastingClasses |= HENCH_ARCANE_SPELLCASTING;
			}
			if (nClassFlags & HENCH_CLASS_DC_BONUS_FLAG)
			{			
				nMySpellCasterDC += 1 + nClassLevel / 2;
			}
		}
		switch (nClassFlags & HENCH_CLASS_SA_MASK)
		{
			case HENCH_CLASS_SA_NONE:
				break;			
			case HENCH_CLASS_SA_EVERY_OTHER_ODD:
				sneakAttackDice += (nClassLevel + 1) / 2;
				break;
			case HENCH_CLASS_SA_EVERY_OTHER_EVEN:
				sneakAttackDice += nClassLevel / 2;
				break;
			case HENCH_CLASS_SA_EVERY_THIRD_SKIP_FIRST:
				sneakAttackDice += (nClassLevel - 1) / 3;
				break;
			case HENCH_CLASS_SA_EVERY_THIRD:
				sneakAttackDice += nClassLevel / 3;
				break;
			case HENCH_CLASS_SA_EVERY_THIRD_FROM_TWO:
				sneakAttackDice += (nClassLevel + 1) / 3;
				break;
			case HENCH_CLASS_SA_EVERY_THIRD_FROM_ONE:
				sneakAttackDice += (nClassLevel + 2) / 3;
				break;
			default: // HENCH_CLASS_SA_EVERY_FORTH
				sneakAttackDice += nClassLevel / 4;
				break;
		}
//		Jug_Debug(GetName(OBJECT_SELF) + " class " + IntToString(nClass) + " new sneak attack " + IntToString(sneakAttackDice));
		nClassLevel = GetLevelByPosition(++iPosition);
	}
	if (spellCastingFlags)
	{	
		spellCastingLevel += prcBonusSpellCastingLevel;	
		if (spellCastingLevel > GetHitDice(OBJECT_SELF))
		{			
			spellCastingLevel = GetHitDice(OBJECT_SELF);
		}
		int iAbility = ((spellCastingFlags & HENCH_CLASS_ABILITY_MODIFIER_MASK) >> HENCH_CLASS_ABILITY_MODIFIER_SHIFT) + ABILITY_CONSTITUTION;
		nMySpellCasterDC += GetAbilityModifier(iAbility);
//		Jug_Debug(GetName(OBJECT_SELF) + " my ability is " + IntToString(iAbility) + " level is " + IntToString(spellCastingLevel) + " current DC " + IntToString(nMySpellCasterDC));		
		nMySpellCasterLevel = spellCastingLevel;
	}
	else
	{
		nMySpellCasterLevel = GetLocalInt(OBJECT_SELF, HENCH_SPECIAL_ABILITY_CASTER_LEVEL);
		if (nMySpellCasterLevel <= 0)
		{
			nMySpellCasterLevel = GetCasterLevel(OBJECT_SELF);
			if (nMySpellCasterLevel <= 0)
			{
		    	nMySpellCasterLevel = GetHitDice(OBJECT_SELF);
			}
		}
		nMySpellCasterDC = GetAbilityModifier(ABILITY_CHARISMA);
	}
    if (nMySpellCasterLevel > 22)
    {
        nMySpellCasterDC += (nMySpellCasterLevel - 20) / 3;
    }
	if (GetHasFeat(FEAT_SPELLCASTING_PRODIGY))
	{
		nMySpellCasterDC ++;
	}

    nMySpellCasterDC += 10;
    int nMySpellCasterSpellPenetrationBonus;

    if (GetHasFeat(FEAT_EPIC_SPELL_PENETRATION))
    {
        nMySpellCasterSpellPenetrationBonus = 6;
    }
    else if (GetHasFeat(FEAT_GREATER_SPELL_PENETRATION))
    {
        nMySpellCasterSpellPenetrationBonus = 4;
    }
    else if (GetHasFeat(FEAT_SPELL_PENETRATION))
    {
        nMySpellCasterSpellPenetrationBonus = 2;
    }

    nMySpellCasterSpellPenetration = nMySpellCasterLevel + nMySpellCasterSpellPenetrationBonus;
    nMySpellCastingConcentration = GetSkillRank(SKILL_CONCENTRATION);
    if (GetHasFeat(FEAT_COMBAT_CASTING))
    {
        nMySpellCastingConcentration += 4;
    }

    nMyRangedTouchAttack = GetBaseAttackBonus(OBJECT_SELF) + GetLocalInt(OBJECT_SELF, attackBonusStr) + 11 /* 21 - 10 */;
    nMyMeleeTouchAttack = nMyRangedTouchAttack + GetAbilityModifier(ABILITY_STRENGTH);
    nMyRangedTouchAttack += GetAbilityModifier(ABILITY_DEXTERITY);
}


void InitializeItemSpells(int negativeEffects, int positiveEffects)
{
    SetLocalObject(OBJECT_SELF, sLastSpellTargetObject, OBJECT_SELF);

    int itemSpellsFound = FALSE;

//  Jug_Debug(GetName(OBJECT_SELF) + " arc spell fail " + IntToString(GetArcaneSpellFailure(OBJECT_SELF)));

	if (negativeEffects & HENCH_EFFECT_TYPE_SILENCE)
	{
		bgDisablingEffect = HENCH_DISABLE_EFFECT_SILENCE;
	}
	if (gfSpellFailureChance > 0.5)
	{
		bgDisablingEffect |= HENCH_DISABLE_EFFECT_NO_MAGIC;
	}

    gExcludedItemTalents = GetLocalInt(OBJECT_SELF, N2_TALENT_EXCLUDE);

	goHealingKit = GetBestHealingKit();

    InitializeSpellCasting();

	
//  Jug_Debug(GetName(OBJECT_SELF) + " start exclude " + IntToString(gExcludedItemTalents));
    //Jug_Debug(GetName(OBJECT_SELF) + " spell failure chance " + FloatToString(gfSpellFailureChance));

    if (!bAnySpellcastingClasses || (bgDisablingEffect & HENCH_DISABLE_EFFECT_NO_MAGIC))
    {
//      Jug_Debug(GetName(OBJECT_SELF) + " excluding spells !!!");
        gExcludedItemTalents |= TALENT_EXCLUDE_SPELL;
    }
    int bPolymorphed = positiveEffects & (HENCH_EFFECT_TYPE_POLYMORPH | HENCH_EFFECT_TYPE_WILDSHAPE);
    int bCheckForHealingAndCuringItems;
//  Jug_Debug(GetName(OBJECT_SELF) + " start exclude " + IntToString(gExcludedItemTalents) +  " spells " + IntToString(bAnySpellcastingClasses) + " arcane spell failure " + IntToString(bArcaneSpellFailure));
    if (bPolymorphed || !GetIsObjectValid(GetFirstItemInInventory()) || !GetCreatureUseItems(OBJECT_SELF))
    {
//      Jug_Debug(";;;;;;" + GetName(OBJECT_SELF) + " can't use items");
        gExcludedItemTalents |= TALENT_EXCLUDE_ITEM;
    }
    else if ((gExcludedItemTalents & TALENT_EXCLUDE_ITEM) && GetHenchAssociateState(HENCH_ASC_ENABLE_HEALING_ITEM_USE))
    {
        bCheckForHealingAndCuringItems = TRUE;
    }

    if (bPolymorphed)
    {
//          Jug_Debug(GetName(OBJECT_SELF) + " poly effects " + IntToHexString(positiveEffects));

        if (!(positiveEffects & HENCH_EFFECT_TYPE_WILDSHAPE) || !GetHasFeat(FEAT_NATURAL_SPELL))
        {
//          Jug_Debug(GetName(OBJECT_SELF) + " exclude spells");
            gExcludedItemTalents |= TALENT_EXCLUDE_SPELL;
        }

        gExcludedItemTalents |= TALENT_EXCLUDE_ABILITY;
/*
        no polymorph spell use in NWN2
        int polymorphShape = GetLocalInt(OBJECT_SELF, sPolymorphTypeStr);
        int polymorphSpellIndex;
        for (polymorphSpellIndex = 1; polymorphSpellIndex <= 3; polymorphSpellIndex++)
        {
            int polymorphSpell = StringToInt(Get2DAString("polymorph", "SPELL" + IntToString(polymorphSpellIndex), polymorphShape));
            if (polymorphSpell <= 0)
            {
                break;
            }
            HenchSpontaneousDispatch(polymorphSpell, TRUE);
        } */
/*
        no potion use in NWN2
        FindItemSpellTalentsByCategory2(TALENT_CATEGORY_BENEFICIAL_HEALING_POTION, 5, TALENT_EXCLUDE_SPELL | TALENT_EXCLUDE_ABILITY, HENCH_ITEM_TYPE_POTION);
        FindItemSpellTalentsByCategory2(TALENT_CATEGORY_BENEFICIAL_CONDITIONAL_POTION, 5, TALENT_EXCLUDE_SPELL | TALENT_EXCLUDE_ABILITY, HENCH_ITEM_TYPE_POTION);
        FindItemSpellTalentsByCategory2(TALENT_CATEGORY_BENEFICIAL_PROTECTION_POTION, 5, TALENT_EXCLUDE_SPELL | TALENT_EXCLUDE_ABILITY, HENCH_ITEM_TYPE_POTION);
        FindItemSpellTalentsByCategory2(TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_POTION, 5, TALENT_EXCLUDE_SPELL | TALENT_EXCLUDE_ABILITY, HENCH_ITEM_TYPE_POTION); */
    }
    else if (GetHasSkill(SKILL_HEAL) &&
        ((!(gExcludedItemTalents & TALENT_EXCLUDE_ITEM)) || bCheckForHealingAndCuringItems) &&
        (gbSpellInfoCastMask & HENCH_SPELL_INFO_HEAL_OR_CURE))
    {
        if (GetIsObjectValid(goHealingKit))
        {
//			Jug_Debug(GetName(OBJECT_SELF) + " checking healing kit " + GetName(goHealingKit));
            gsCurrentspInfo.castingInfo = HENCH_CASTING_INFO_USE_HEALING_KIT;
            gsCurrentspInfo.spellID = HENCH_HEALING_KIT_ID;
            gsCurrentspInfo.otherID = -1;
            gsCurrentspInfo.spellInfo = HENCH_SPELL_INFO_SPELL_TYPE_HEAL_SPECIAL | HENCH_SPELL_INFO_ITEM_FLAG;
            gsCurrentspInfo.spellLevel = 6;     // make this equivalent to a heal spell
            gsCurrentspInfo.shape = HENCH_SHAPE_NONE;
            gsCurrentspInfo.range = 4.0;

            HenchCheckHealSpecial();
        }
    }
	
	gbUseSpells = !(gExcludedItemTalents & TALENT_EXCLUDE_SPELL);
	gbUseAbilities = !(gExcludedItemTalents & TALENT_EXCLUDE_ABILITY);
	gbUseItems = !(gExcludedItemTalents & TALENT_EXCLUDE_ITEM);
	
	InitializeWarlockAttackSpells();
    if (gbUseAbilities && !(bgDisablingEffect & HENCH_DISABLE_EFFECT_NO_MAGIC))
    {
		HenchCheckReserveFeats();
    }	
	InitializeSpellTalents();

    if (bCheckForHealingAndCuringItems)
    {
	    int saveDisableNonUnlimitedOrHealOrCure = gbDisableNonUnlimitedOrHealOrCure;
		gbDisableNonUnlimitedOrHealOrCure = TRUE;
        FindItemSpellTalentsByCategory(TALENT_CATEGORY_BENEFICIAL_HEALING_POTION, 5, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_POTION);
        FindItemSpellTalentsByCategory(TALENT_CATEGORY_BENEFICIAL_HEALING_TOUCH, 5, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_OTHER);
        FindItemSpellTalentsByCategory(TALENT_CATEGORY_BENEFICIAL_HEALING_AREAEFFECT, 5, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_OTHER);
        FindItemSpellTalentsByCategory(TALENT_CATEGORY_BENEFICIAL_CONDITIONAL_POTION, 5, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_POTION);
        FindItemSpellTalentsByCategory(TALENT_CATEGORY_BENEFICIAL_CONDITIONAL_SINGLE, 5, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_OTHER);
        FindItemSpellTalentsByCategory(TALENT_CATEGORY_BENEFICIAL_CONDITIONAL_AREAEFFECT, 5, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_OTHER);
	    gbDisableNonUnlimitedOrHealOrCure = saveDisableNonUnlimitedOrHealOrCure;
    }

    if (gbUseAbilities)
    {
        InitializeFeats();
    }
}


void HenchDecrementSpontaneousSpell(int nSpellID)
{
	int originalCount = GetHasSpell(nSpellID);
	DecrementRemainingSpellUses(OBJECT_SELF, nSpellID);
	int newCount = GetHasSpell(nSpellID);
	
//	Jug_Debug(GetName(OBJECT_SELF) + " first spell decr result " + IntToString(newCount) + " orig " + IntToString(originalCount));
	
	if (newCount < originalCount)
	{	
		return;
	}
	
	int spellInfo = GetSpellInformation(nSpellID);
	int spellLevel = (spellInfo & HENCH_SPELL_INFO_SPELL_LEVEL_MASK) >> HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT;
	int spellCR = spellLevel * 2;
	
	int talentCategory;
	int highestLevelSpell = -1;
	int decrementSpellID;
	for (talentCategory = TALENT_CATEGORY_CANTRIP; talentCategory--; talentCategory >= 0)
	{	
        talent tBest = GetCreatureTalentBest(talentCategory, spellCR, OBJECT_SELF, HENCH_TALENT_USE_SPELLS_ONLY);
		if (GetIsTalentValid(tBest))
		{		
            int testSpellID = GetIdFromTalent(tBest);
//			Jug_Debug(GetName(OBJECT_SELF) + " found spell " + IntToString(testSpellID));
			int testSpellInfo = GetSpellInformation(testSpellID);
			int testSpellLevel = (testSpellInfo & HENCH_SPELL_INFO_SPELL_LEVEL_MASK) >> HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT;
			if (testSpellLevel > highestLevelSpell)
			{
				highestLevelSpell = testSpellLevel;
				decrementSpellID = testSpellID;
 				if (highestLevelSpell >= spellLevel)
				{
					break;
				}			
			}
		}
	}
//	Jug_Debug(GetName(OBJECT_SELF) + " highest spell level " + IntToString(highestLevelSpell));
	if (highestLevelSpell >= 0)
	{	
		DecrementRemainingSpellUses(OBJECT_SELF, decrementSpellID);
//		Jug_Debug(GetName(OBJECT_SELF) + " decrementing " + IntToString(decrementSpellID));
	}
}


void HenchCheckPolymorphFeatDecrement(int featID)
{
	if (GetHasEffect(EFFECT_TYPE_POLYMORPH))
	{
//		Jug_Debug(GetName(OBJECT_SELF) + " current feat uses " + IntToString(GetHasFeat(featID)));
		DecrementRemainingFeatUses(OBJECT_SELF, featID);
//		Jug_Debug(GetName(OBJECT_SELF) + " new feat uses " + IntToString(GetHasFeat(featID)));
	}
/*	else
	{
		Jug_Debug(GetName(OBJECT_SELF) + " doesn't have polymorph effect");
	} */
}


void HenchCastSpell(struct sSpellInformation spInfo)
{
	int castingType = spInfo.castingInfo & HENCH_CASTING_INFO_USE_MASK;
    if ((castingType == HENCH_CASTING_INFO_USE_SPELL_WARLOCK) &&
        (spInfo.otherID == SPELL_I_HIDEOUS_BLOW))
    {
		object oRightHandWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
        HenchEquipAppropriateWeapons(spInfo.oTarget, 100.0, FALSE, FALSE);
        if (GetWeaponRanged(oRightHandWeapon))
        {
            ActionWait(1.0);
        }
        else if (GetHasEffect(EFFECT_TYPE_HIDEOUS_BLOW))
        {
            if ((GetCurrentAction() != ACTION_ATTACKOBJECT) ||
                (GetAttackTarget(OBJECT_SELF) != spInfo.oTarget))
            {
                ClearAllActions();
                ActionAttack(spInfo.oTarget);
            }
			HenchCheckCastAuraSpell();
            return;
        }
    }
	else
	{
    	ClearAllActions();
		HenchCheckCastAuraSpell();
	}

//	Jug_Debug(GetName(OBJECT_SELF) + " attempt to cast spell " + IntToString(spInfo.spellID) + " " + Get2DAString("spells", "Label", spInfo.spellID) + " other "  + IntToString(spInfo.otherID) + " casting info " + IntToString(spInfo.castingInfo));

    switch (spInfo.spellInfo & HENCH_SPELL_INFO_SPELL_TYPE_MASK)
    {
    case HENCH_SPELL_INFO_SPELL_TYPE_HEAL:
    case HENCH_SPELL_INFO_SPELL_TYPE_HARM:
    case HENCH_SPELL_INFO_SPELL_TYPE_REGENERATE:
    case HENCH_SPELL_INFO_SPELL_TYPE_HEAL_SPECIAL:
        if (spInfo.oTarget == OBJECT_SELF && GetLocalInt(OBJECT_SELF, HENCH_HEAL_SELF_STATE) == HENCH_HEAL_SELF_CANT)
        {
            if (bgAnyValidTarget && (gsBestSelfInvisibility.spellID > 0))
            {
//				Jug_Debug(GetName(OBJECT_SELF) + " attempt to become invisible");
                    // become invisible
                spInfo = gsBestSelfInvisibility;
                spInfo.oTarget = OBJECT_SELF;
				castingType = spInfo.castingInfo & HENCH_CASTING_INFO_USE_MASK;
            }
            // indicate to others that going to heal self
            SetLocalInt(OBJECT_SELF, HENCH_HEAL_SELF_STATE, HENCH_HEAL_SELF_IN_PROG);
        }
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_SUMMON:
        if (spInfo.range == 0.0)
        {
            spInfo.oTarget = OBJECT_SELF;
        }
        else
        {
            spInfo.oTarget = OBJECT_INVALID;
            spInfo.lTargetLoc =  GetSummonLocation(spInfo.range);
        }
        break;
    }

    if (bgMeleeAttackers && !GetHenchAssociateState(HENCH_ASC_DISABLE_AUTO_WEAPON_SWITCH))
    {
        EquipShield(FALSE);
    }

    if (bgEnableMoveAway && GetIsObjectValid(spInfo.oTarget) && ((((spInfo.shape == HENCH_SHAPE_NONE) &&
        ((spInfo.range > 5.0) || (spInfo.oTarget == OBJECT_SELF)))) || (spInfo.castingInfo & HENCH_CASTING_INFO_RANGED_SEL_AREA_FLAG)))
    {
//      Jug_Debug(GetName(OBJECT_SELF) + " move away for spell " + IntToString(spInfo.spellID) + " " + Get2DAString("spells", "Label", spInfo.spellID) + " other "  + IntToString(spInfo.otherID));
        bgEnableMoveAway = FALSE;
        if (spInfo.oTarget == OBJECT_SELF)
        {
            if (MoveAwayFromEnemies(ogClosestSeenOrHeardEnemy, 9.0))
            {
                HenchStartCombatRoundAfterAction(OBJECT_INVALID);
                return;
            }
        }
        else
        {
            if (MoveAwayFromEnemies(spInfo.oTarget, spInfo.range > 10.0 ? 8.0 : spInfo.range - 1.0))
            {
                HenchStartCombatRoundAfterAction(spInfo.oTarget);
                return;
            }
        }
    }

//	Jug_Debug(GetName(OBJECT_SELF) + " def casting mode is " + IntToString(GetActionMode(OBJECT_SELF, ACTION_MODE_DEFENSIVE_CAST)) + " melee attackers " + IntToString(bgMeleeAttackers));

    if ((spInfo.spellInfo & HENCH_SPELL_INFO_CONCENTRATION_FLAG) &&
        !(spInfo.spellInfo & HENCH_SPELL_INFO_ITEM_FLAG))
    {
		if (!GetLocalInt(OBJECT_SELF, N2_COMBAT_MODE_USE_DISABLED))
		{
	        int bCurrentDefCastMode = GetActionMode(OBJECT_SELF, ACTION_MODE_DEFENSIVE_CAST);
	        int bNewDefCastMode = bgMeleeAttackers && (Getd20Chance(nMySpellCastingConcentration - 15 - spInfo.spellLevel) > 0.67);
	
//      	Jug_Debug(GetName(OBJECT_SELF) + " check def casting old " + IntToString(bCurrentDefCastMode) + " new " + IntToString(bNewDefCastMode) + " chance " + FloatToString(Getd20Chance(nMySpellCastingConcentration - 15 - spInfo.spellLevel)));
	
	        if (bCurrentDefCastMode != bNewDefCastMode)
	        {
//      		Jug_Debug(GetName(OBJECT_SELF) + " change def casting");
	            SetActionMode(OBJECT_SELF, ACTION_MODE_DEFENSIVE_CAST, bNewDefCastMode);
	        }
			if (!bNewDefCastMode)
			{
				if (GetHasFeat(FEAT_IMPROVED_COMBAT_EXPERTISE))
				{
					if (!GetActionMode(OBJECT_SELF, ACTION_MODE_IMPROVED_COMBAT_EXPERTISE))
					{
	            		SetActionMode(OBJECT_SELF, ACTION_MODE_IMPROVED_COMBAT_EXPERTISE, TRUE);
					}
				}
				else if (GetHasFeat(FEAT_COMBAT_EXPERTISE))
				{		
					if (!GetActionMode(OBJECT_SELF, ACTION_MODE_COMBAT_EXPERTISE))
					{
	            		SetActionMode(OBJECT_SELF, ACTION_MODE_COMBAT_EXPERTISE, TRUE);
					}
				}
			}
		}
    }
	DeleteLocalInt(OBJECT_SELF, HENCH_SPELL_CASTER_LEVEL_OVERRIDE);
    if (castingType == HENCH_CASTING_INFO_USE_SPELL_TALENT)
    {
        if (GetIsObjectValid(spInfo.oTarget))
        {
//			Jug_Debug(GetName(OBJECT_SELF) + " attempt to cast spell on object " + IntToString(spInfo.spellID) + " on " + GetName(spInfo.oTarget));
            SetLocalObject(OBJECT_SELF, sLastSpellTargetObject, spInfo.oTarget);
            if (GetIsEnemy(spInfo.oTarget))
            {
                SetLocalObject(OBJECT_SELF, sHenchLastTarget, spInfo.oTarget);
            }
            ActionUseTalentOnObject(spInfo.tTalent, spInfo.oTarget);
        }
        else
        {
//			Jug_Debug(GetName(OBJECT_SELF) + " attempt to cast spell at location " + IntToString(spInfo.spellID));
            ActionUseTalentAtLocation(spInfo.tTalent, spInfo.lTargetLoc);
        }
    }
    else if (castingType == HENCH_CASTING_INFO_USE_SPELL_FEATID)
    {
        if (GetIsObjectValid(spInfo.oTarget))
        {
            SetLocalObject(OBJECT_SELF, sLastSpellTargetObject, spInfo.oTarget);
            if (GetIsEnemy(spInfo.oTarget))
            {
                SetLocalObject(OBJECT_SELF, sHenchLastTarget, spInfo.oTarget);
            }
            if (spInfo.castingInfo & HENCH_CASTING_INFO_CHEAT_CAST_FLAG)
            {
//				Jug_Debug(GetName(OBJECT_SELF) + " attempt to cast feat cheat on object " + IntToString(spInfo.otherID) + " on " + GetName(spInfo.oTarget));
                ActionCastSpellAtObject(spInfo.spellID, spInfo.oTarget, METAMAGIC_NONE, TRUE);				
				if ((spInfo.spellInfo & HENCH_SPELL_INFO_SPELL_TYPE_MASK) == HENCH_SPELL_INFO_SPELL_TYPE_POLYMORPH)
				{
//					Jug_Debug(GetName(OBJECT_SELF) + " polymorph option");
					DelayCommand(4.5, HenchCheckPolymorphFeatDecrement(spInfo.otherID));
				}
				else
				{				
                	ActionDoCommand(DecrementRemainingFeatUses(OBJECT_SELF, spInfo.otherID));
				}
            }
            else
            {
//				Jug_Debug(GetName(OBJECT_SELF) + " attempt to cast feat on object " + IntToString(spInfo.otherID) + " on " + GetName(spInfo.oTarget));
                ActionUseFeat(spInfo.otherID, spInfo.oTarget);
            }
        }
        else
        {
//			Jug_Debug(GetName(OBJECT_SELF) + " attempt to cast feat at location " + IntToString(spInfo.spellID));
            ActionCastSpellAtLocation(spInfo.spellID, spInfo.lTargetLoc, METAMAGIC_NONE, TRUE);
            ActionDoCommand(DecrementRemainingFeatUses(OBJECT_SELF, spInfo.otherID));
        }
    }
    else if (castingType == HENCH_CASTING_INFO_USE_SPELL_WARLOCK)
    {
        if (GetIsObjectValid(spInfo.oTarget))
        {
            SetLocalObject(OBJECT_SELF, sLastSpellTargetObject, spInfo.oTarget);
            SetLocalObject(OBJECT_SELF, sHenchLastTarget, spInfo.oTarget);
        }
        if (spInfo.otherID > 0)
        {
            int nMetamagicEssence = METAMAGIC_NONE;
            switch (spInfo.spellID)
            {
            case SPELL_I_FRIGHTFUL_BLAST:
                nMetamagicEssence = METAMAGIC_INVOC_FRIGHTFUL_BLAST;
                break;
            case SPELL_I_DRAINING_BLAST:
                nMetamagicEssence = METAMAGIC_INVOC_DRAINING_BLAST;
                break;
            case SPELL_I_BESHADOWED_BLAST:
                nMetamagicEssence = METAMAGIC_INVOC_BESHADOWED_BLAST;
                break;
            case SPELL_I_BRIMSTONE_BLAST:
                nMetamagicEssence = METAMAGIC_INVOC_BRIMSTONE_BLAST;
                break;
            case SPELL_I_HELLRIME_BLAST:
                nMetamagicEssence = METAMAGIC_INVOC_HELLRIME_BLAST;
                break;
            case SPELL_I_BEWITCHING_BLAST:
                nMetamagicEssence = METAMAGIC_INVOC_BEWITCHING_BLAST;
                break;
            case SPELL_I_NOXIOUS_BLAST:
                nMetamagicEssence = METAMAGIC_INVOC_NOXIOUS_BLAST;
                break;
            case SPELL_I_VITRIOLIC_BLAST:
                nMetamagicEssence = METAMAGIC_INVOC_VITRIOLIC_BLAST;
                break;
            case SPELL_I_UTTERDARK_BLAST:
                nMetamagicEssence = METAMAGIC_INVOC_UTTERDARK_BLAST;
                break;
			case 1131:	// binding blast
                nMetamagicEssence = METAMAGIC_INVOC_BINDING_BLAST;
                break;			
			case 1130:	// hindering blast
                nMetamagicEssence = METAMAGIC_INVOC_HINDERING_BLAST;
                break;
            }
//          Jug_Debug(GetName(OBJECT_SELF) + " warlock casting " + IntToString(spInfo.otherID) + " meta " + IntToString(nMetamagicEssence) + " meta spell " + IntToString(spInfo.spellID));
            if (GetIsObjectValid(spInfo.oTarget))
            {
				if ((spInfo.otherID == SPELL_I_HIDEOUS_BLOW) && GetHenchOption(HENCH_OPTION_HIDEOUS_BLOW_INSTANT))
				{
					// make hideous blow instance so it doesn' take two rounds
//					Jug_Debug(GetName(OBJECT_SELF) + " use hideous blow");
                	ActionCastSpellAtObject(spInfo.otherID, spInfo.oTarget, nMetamagicEssence, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
				}
				else
				{
                	ActionCastSpellAtObject(spInfo.otherID, spInfo.oTarget, nMetamagicEssence);
				}
            }
            else
            {
                ActionCastSpellAtLocation(spInfo.otherID, spInfo.lTargetLoc, nMetamagicEssence);
            }
        }
        else if (spInfo.spellID != SPELLABILITY_I_ELDRITCH_BLAST)
        {
//          Jug_Debug(GetName(OBJECT_SELF) + " warlock casting " + IntToString(spInfo.spellID));
            ActionCastSpellAtObject(spInfo.spellID,  spInfo.oTarget);
        }
        else
        {
            int nFeat = GetBestEldritchBlastFeat();
//          Jug_Debug(GetName(OBJECT_SELF) + " warlock casting feat " + IntToString(nFeat));
            ActionUseFeat(nFeat, spInfo.oTarget);
        }
    }
    else if ((castingType == HENCH_CASTING_INFO_USE_SPELL_REGULAR) ||
		(castingType == HENCH_CASTING_INFO_USE_SPELL_CURE_OR_INFLICT))
    {
		int bUseCheatCast = spInfo.castingInfo & HENCH_CASTING_INFO_CHEAT_CAST_FLAG;
		if (bUseCheatCast)
		{
			// set the cheat cast caster level
			SetLocalInt(OBJECT_SELF, HENCH_SPELL_CASTER_LEVEL_OVERRIDE,
				(spInfo.castingInfo & HENCH_CASTING_INFO_CHEAT_SPELL_LEVEL_MASK) >>
				HENCH_CASTING_INFO_CHEAT_SPELL_LEVEL_SHIFT);
//			Jug_Debug(GetName(OBJECT_SELF) + " cheat spell CL " + IntToString(GetLocalInt(OBJECT_SELF, HENCH_SPELL_CASTER_LEVEL_OVERRIDE)));
			DelayCommand(5.0, DeleteLocalInt(OBJECT_SELF, HENCH_SPELL_CASTER_LEVEL_OVERRIDE));
		}
        if (GetIsObjectValid(spInfo.oTarget))
        {
//  Jug_Debug("^^^^^^^^" + GetName(OBJECT_SELF) + " attempt to cast spontaneous spell on object " + IntToString(spInfo.spellID) + " on " + GetName(spInfo.oTarget));
            SetLocalObject(OBJECT_SELF, sLastSpellTargetObject, spInfo.oTarget);
            if (GetIsEnemy(spInfo.oTarget))
            {
                SetLocalObject(OBJECT_SELF, sHenchLastTarget, spInfo.oTarget);
            }
            ActionCastSpellAtObject(spInfo.spellID, spInfo.oTarget, spInfo.otherID, bUseCheatCast);
        }
        else
        {
//  Jug_Debug("^^^^^^^^" + GetName(OBJECT_SELF) + " attempt to cast spontaneous spell at location " + IntToString(spInfo.spellID));
            ActionCastSpellAtLocation(spInfo.spellID, spInfo.lTargetLoc, spInfo.otherID, bUseCheatCast);
        }
        if (castingType == HENCH_CASTING_INFO_USE_SPELL_CURE_OR_INFLICT)
        {
//  Jug_Debug("^^^^^^^^" + GetName(OBJECT_SELF) + " decrementing spell " + IntToString(spInfo.spellID));
            int nMainSpell = spInfo.spellID;
            ActionDoCommand(HenchDecrementSpontaneousSpell(nMainSpell));
        }
    }
    else if (castingType == HENCH_CASTING_INFO_USE_HEALING_KIT)
    {
        ActionUseSkill(SKILL_HEAL, spInfo.oTarget, 0, goHealingKit);
    }
		
	switch (spInfo.spellInfo & HENCH_SPELL_INFO_SPELL_TYPE_MASK)
    {
	case HENCH_SPELL_INFO_SPELL_TYPE_ATTACK:
		if (spInfo.castingInfo & HENCH_CASTING_INFO_PERSISTENT_SPELL_FLAG)
		{
			// create marker so other party members won't duplicate persistent AoE spells
//			Jug_Debug(GetName(OBJECT_SELF) + " casting persistent spell");
			location lTarget;
	        if (GetIsObjectValid(spInfo.oTarget))
	        {
				lTarget = GetLocation(spInfo.oTarget);
	        }
	        else
	        {
	            lTarget = spInfo.lTargetLoc;
	        }
			object oMarker = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_ipoint ", lTarget, FALSE, sPersistSpellMarkerTag);
			DestroyObject(oMarker, 4.0);
			SetLocalObject(oMarker, sPersistSpellMarkerTag, OBJECT_SELF);
			SetLocalInt(oMarker, sPersistSpellMarkerTag, GetLocalInt(GetModule(), sHenchPersistSpellIDInfo + IntToString(spInfo.spellID)));
		}
		break;
    case HENCH_SPELL_INFO_SPELL_TYPE_DISPEL:
        SetLocalInt(OBJECT_SELF, henchLastDispelStr, GetLocalInt(OBJECT_SELF, henchCombatRoundStr));
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_DRAGON_BREATH:
       SetLocalInt(OBJECT_SELF, henchLastDraBrStr, GetLocalInt(OBJECT_SELF, henchCombatRoundStr));
//     Jug_Debug("@@@@" + GetName(OBJECT_SELF) + " doing dragon breath");
       break;
    case HENCH_SPELL_INFO_SPELL_TYPE_DOMINATE:
        SetLocalInt(OBJECT_SELF, henchLastDomStr, GetLocalInt(OBJECT_SELF, henchCombatRoundStr));
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_TURN_UNDEAD:
        SetLocalInt(OBJECT_SELF, henchLastTurnStr,  GetLocalInt(OBJECT_SELF, henchCombatRoundStr));
        break;
    }
}


int HenchCheckSpellToCast(int currentRound, int bTestOnly)
{
//  Jug_Debug(GetName(OBJECT_SELF) + " attack target weight " + FloatToString(gfTargetWeight));

    HenchGetBestDispelTarget();

    struct sSpellInformation spInfo;
    int bFound;
	
	// check best option for invisibility and
	// check if some pending buff or early rounds with sneak attacks and melee attack chosen	
	if ((gsBestSelfHide.spellID > 0) && (((bfBuffTargetAccumWeight > gfAttackTargetWeight) && 
		(giNumberOfPendingBuffs > 2)) || ((currentRound < 3) &&
		GetHasFeat(FEAT_SNEAK_ATTACK) && (gsAttackTargetInfo.spellID < 0))))
	{
        spInfo = gsBestSelfHide;
        spInfo.oTarget = OBJECT_SELF;
        bFound = TRUE;
        bgEnableMoveAway = FALSE;
    }
    else if ((gsAttackTargetInfo.spellID >= 0) && (gfAttackTargetWeight >= gfBuffTargetWeight))
    {
        spInfo = gsAttackTargetInfo;
        bFound = TRUE;
    }
    else if ((gsBuffTargetInfo.spellID >= 0) && (gfBuffTargetWeight > gfAttackTargetWeight))
    {
        spInfo = gsBuffTargetInfo;
        bFound = TRUE;
    }
    else if ((gsMeleeAttackspInfo.spellID > 0) && (GetConcetrationWeightAdjustment(gsMeleeAttackspInfo.spellInfo, gsMeleeAttackspInfo.spellLevel) >= (IntToFloat(Random(100)) / 100.0)))
    {
        spInfo = gsMeleeAttackspInfo;
        spInfo.oTarget = OBJECT_SELF;
        bFound = TRUE;
        bgEnableMoveAway = FALSE;
    }
    else if ((gsDelayedAttrBuff.spellID > 0) && (GetConcetrationWeightAdjustment(gsDelayedAttrBuff.spellInfo, gsDelayedAttrBuff.spellLevel) >= (IntToFloat(Random(100)) / 100.0)))
    {
        spInfo = gsDelayedAttrBuff;
        spInfo.oTarget = OBJECT_SELF;
        bFound = TRUE;
        bgEnableMoveAway = FALSE;
    }
    else if ((gsPolymorphspInfo.spellID > 0) && (GetConcetrationWeightAdjustment(gsPolymorphspInfo.spellInfo, gsPolymorphspInfo.spellLevel) >= (IntToFloat(Random(100)) / 100.0)))
    {
        if ((gsPolyAttrBuff.spellID > 0) && (GetConcetrationWeightAdjustment(gsPolyAttrBuff.spellInfo, gsPolyAttrBuff.spellLevel) >= (IntToFloat(Random(100)) / 100.0)))
        {
            spInfo = gsPolyAttrBuff;
        }
        else
        {
            spInfo = gsPolymorphspInfo;
        }
        spInfo.oTarget = OBJECT_SELF;
        bFound = TRUE;
        bgEnableMoveAway = FALSE;
    }

    if (bFound)
    {
        if (!bTestOnly)
        {
            HenchCastSpell(spInfo);
        }
        return TRUE;
    }

    return FALSE;
}


int CheckAOEForSelf(int currentNegEffects, int currentPosEffects)
{
    object oAOE = HenchGetAOEProblem(currentNegEffects, currentPosEffects);

    if (!GetIsObjectValid(oAOE))
    {
        return FALSE;
    }
//	Jug_Debug("(((((((((" + GetName(OBJECT_SELF) + " has problem with " + GetName(oAOE));

    int bDisableRemove;	
	object oAOECreator = GetAreaOfEffectCreator(oAOE);
		
	if (GetFactionEqual(oAOECreator) || GetIsFriend(oAOECreator))
	{
	    bDisableRemove = TRUE;
	}
	
	int persistSpellFlags = HenchGetAoESpellInfo(oAOE);
	if (!bDisableRemove)
	{
	    if ((persistSpellFlags & HENCH_PERSIST_FOG) && (gsGustOfWind.spellID > 0))
	    {
	        gsGustOfWind.oTarget = OBJECT_INVALID;
	        gsGustOfWind.lTargetLoc = FindBestDispelLocation(oAOE);
	        HenchCastSpell(gsGustOfWind);
	        return TRUE;
	    }
	    if ((persistSpellFlags & HENCH_PERSIST_CAN_DISPEL) && (gsBestDispel.spellID > 0) && !GetLocalInt(OBJECT_SELF, sHenchDontDispel))
	    {		
			int nSpellInformation = GetSpellInformation(persistSpellFlags & HENCH_PERSIST_SPELL_MASK);		
    		if ((nSpellInformation & HENCH_SPELL_TARGET_RANGE_MASK) == HENCH_SPELL_TARGET_RANGE_PERSONAL)
	        {
	            gsBestDispel.oTarget = oAOECreator;
	            HenchCastSpell(gsBestDispel);
	            return TRUE;
	        }
	        gsBestDispel.oTarget = OBJECT_INVALID;
	        gsBestDispel.lTargetLoc = FindBestDispelLocation(oAOE);
	        HenchCastSpell(gsBestDispel);
	        return TRUE;
	    }
	}
    if (!bgMeleeAttackers && (persistSpellFlags & HENCH_PERSIST_MOVE_AWAY) && !(currentNegEffects & HENCH_EFFECT_IMMOBILE))
    {	
		if ((persistSpellFlags & HENCH_PERSIST_SPELL_MASK) == SPELL_SILENCE)
		{
			// make sure we don't have silence effect
			effect eCurEffect = GetFirstEffect(OBJECT_SELF);
			while (GetIsEffectValid(eCurEffect))
			{
				if (GetEffectType(eCurEffect) == EFFECT_TYPE_AREA_OF_EFFECT)
				{
                	if (GetEffectSpellId(eCurEffect) == SPELL_SILENCE)
					{
//						Jug_Debug("(((((((((" + GetName(OBJECT_SELF) + " can't run away from self");
						// can't run away from self
						return FALSE;
					}
				}
				eCurEffect = GetNextEffect(OBJECT_SELF);			
			}		
		}	
            // run away if no melee attackers
        ActionMoveAwayFromLocation(GetLocation(oAOE), TRUE, 10.0);
        return TRUE;
    }
    return FALSE;
}