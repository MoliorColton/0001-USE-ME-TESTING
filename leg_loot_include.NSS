/*

    Script:			Loot Include script handling all contstants and functions specific to the LOOT plugin only.
					This also contains configuration options to allow builders to customize the LOOT system and
					set the appropriate parameters for it.
	Version:		1.13
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		None

	Change Log:		11/26/2010 - Updated to work with Legends Master Modular Systems
					12/18/2010 - 1.11 MV - Upgraded to Plugin 1.3, Added database support for random items.
					12/22/2010 - 1.12 MV - Added new item property for casting a randomly chosen spell on an item
					12/23/2010 - 1.13 MV - Added new functions for choosing props/spells and dupe checking.

*/

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// USER CONFIGURABLE CONSTANTS
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_loot_constants"




// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_all_masterinclude"


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// Constants for Item Properties.  We use these in the 2da file to identify which property we are going to apply
// /////////////////////////////////////////////////////////////////////////////////////////////////////
const int Light = 1;
const int LimitUseByAlign = 2;
const int AbilityBonus = 3;
const int ACBonus = 4;
const int ACBonusVsAlign = 5;
const int ACBonusVsDmgType = 6;
const int ACBonusVsRace = 7;
const int AttackBonus = 8;
const int AttackBonusVsAlign = 9;
const int AttackBonusVsRace = 10;
const int BonusHitpoints = 11;
const int BonusLevelSpell = 12;
const int BonusSavingThrow = 13;
const int BonusSavingThrowVsX = 14;
const int DamageBonus = 15;
const int DamageBonusVsAlign = 16;
const int DamageBonusVsRace = 17;
const int DamageReduction = 18;
const int EnhancementBonus = 19;
const int EnhancementBonusVsAlign = 20;
const int EnhancementBonusVsRace = 21;
const int EnhancementBonusVsSAlign = 22;
const int ExtraMeleeDamageType = 23;
const int ExtraRangeDamageType = 24;
const int Keen = 25;
const int MassiveCritical = 26;
const int MaxRangeStrengthMod = 27;
const int SkillBonus = 28;
const int VampiricRegeneration = 29;
const int BonusSpellResistance = 30;
const int Haste = 31;
const int CastSpell = 32;
const int HolyAvenger = 33;
const int CastRandomSpell = 34;
const int DarkVision = 35;
const int Regeneration = 36;
const int LimitUseByClass = 37;
const int NOTUSED = 38;
const int BonusFeat = 39;
const int DamageImmunity = 40;
const int ImmunityMisc = 41;
const int OnHitProps = 42;


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// FUNCTION DECLARATIONS
// /////////////////////////////////////////////////////////////////////////////////////////////////////


// ///////////////////////////////////////////////////////////////////////////
// Return an Itemproperty using the passed parameters
// int iPropertyType		- The Property ID from the 2da
// int iParameter1			- The first parameter value calculated from the 2da
// int iParameter2			- The second parameter value calculated from the 2da
// int iParameter3			- The third parameter value calculated from the 2da
//	Returns: The actual Item Property
itemproperty LEG_LOOT_GetItemProperty(int iPropertyType, int iParameter1, int iParameter2, int iParameter3);

// ///////////////////////////////////////////////////////////////////////////
// Check to see if the property passed is allowed on the item passed.
// object oItem				- The item to be checked.
// string sPropertiesFile	- The 2DA file we are looking in.
// int i2DAProperty			- The property from the 2DA we are looking in.
//	Returns: 0 if Property is OK for this item or 1 if property is not allowed
int LEG_LOOT_CheckRestrictions(object oItem, string sPropertiesFile, int i2DAProperty);

// ///////////////////////////////////////////////////////////////////////////
// Takes the property file passed and adds all entries that oItem is permitted
// to have into an array.  Once complete, randomly chooses an entry from that
// array.  The array holds the 2DA row number from the Properties File.  That
// row number is then returned.
// string sPropertiesFile	- The 2DA file to look in.
// object oItem				- The item that is checked against for valid props
// object oPC				- Simply used as entropy for the array name
//	Returns: int value of the 2DA row number of a non-restricted property
int LEG_LOOT_FindProperty(string sPropertiesFile, object oItem, object oPC);

// ///////////////////////////////////////////////////////////////////////////
// Checks for duplicate properties on the passed item.  The total number
// of Current properties is passed via the PropCounter variable.  The
// property we want to check to see if it already exists is passed as the
// Property Type variable.
// int iPropCounter			- The number of Current Properties already given.
// int iPropertyType		- The property type we want to see exists
// object oItem				- The item with the existing properties.
//	Returns: int value of True if it exists already, false if it does not.
int LEG_LOOT_CheckDupe(int iPropCounter, int iPropertyType, object oItem);

// ///////////////////////////////////////////////////////////////////////////
// Puts all spells from the Loot spell 2DA that is of the passed level
// using the "caster level" and is supported by the Base Item passed
// into an array.  Once complete, randomly chooses one of the array values
// to return.  The array value will be the row number of the spells 2da
// file.
// int iItemLevel			- The caster level we want to match in the 2da
// int iBaseItemType		- The item we want to apply - Potion, Scroll etc
// string sPropertiesFile	- Used as entropy in the array name
// object oPC				- Used as entropy in the array name
//	Returns: int value the 2DA row in the loot spells 2da file
int LEG_LOOT_GetSpell(int iItemLevel, int iBaseItemType, string sPropertiesFile, object oPC);



// /////////////////////////////////////////////////////////////////////////////////////////////////////
// FUNCTIONS
// /////////////////////////////////////////////////////////////////////////////////////////////////////




// ////////////////////////////////////////////////////
// LEG_LOOT_GetItemProperty
// ////////////////////////////////////////////////////
itemproperty LEG_LOOT_GetItemProperty(int iPropertyType, int iParameter1, int iParameter2, int iParameter3)
{
	itemproperty ipItemProperty;
	switch (iPropertyType)
	{
		case Light:						ipItemProperty = ItemPropertyLight(iParameter1, iParameter2); break;
		case LimitUseByAlign:			ipItemProperty = ItemPropertyLimitUseByAlign(iParameter1); break;
		case AbilityBonus:				ipItemProperty = ItemPropertyAbilityBonus(iParameter1, iParameter2); break;
		case ACBonus:					ipItemProperty = ItemPropertyACBonus(iParameter1); break;
		case ACBonusVsAlign:			ipItemProperty = ItemPropertyACBonusVsAlign(iParameter1, iParameter2); break;
		case ACBonusVsDmgType:			ipItemProperty = ItemPropertyACBonusVsDmgType(iParameter1, iParameter2); break;
		case ACBonusVsRace:				ipItemProperty = ItemPropertyACBonusVsRace(iParameter1, iParameter2); break;
		case AttackBonus:				ipItemProperty = ItemPropertyAttackBonus(iParameter1); break;
		case AttackBonusVsAlign:		ipItemProperty = ItemPropertyAttackBonusVsAlign(iParameter1, iParameter2); break;
		case AttackBonusVsRace:			ipItemProperty = ItemPropertyAttackBonusVsRace(iParameter1, iParameter2); break;
		case BonusHitpoints:			ipItemProperty = ItemPropertyBonusHitpoints(iParameter1); break;
		case BonusLevelSpell:			ipItemProperty = ItemPropertyBonusLevelSpell(iParameter1, iParameter2); break;
		case BonusSavingThrow:			ipItemProperty = ItemPropertyBonusSavingThrow(iParameter1, iParameter2); break;
		case BonusSavingThrowVsX:		ipItemProperty = ItemPropertyBonusSavingThrowVsX(iParameter1, iParameter2); break;
		case DamageBonus:				ipItemProperty = ItemPropertyDamageBonus(iParameter1, iParameter2); break;
		case DamageBonusVsAlign:		ipItemProperty = ItemPropertyDamageBonusVsAlign(iParameter1, iParameter2, iParameter3); break;
		case DamageBonusVsRace:			ipItemProperty = ItemPropertyDamageBonusVsRace(iParameter1, iParameter2, iParameter3); break;
		case DamageReduction:			ipItemProperty = ItemPropertyDamageReduction(iParameter1, iParameter2, 0, 1); break;
		case EnhancementBonus:			ipItemProperty = ItemPropertyEnhancementBonus(iParameter1); break;
		case EnhancementBonusVsAlign:	ipItemProperty = ItemPropertyEnhancementBonusVsAlign(iParameter1, iParameter2); break;
		case EnhancementBonusVsRace:	ipItemProperty = ItemPropertyEnhancementBonusVsRace(iParameter1, iParameter2); break;
		case EnhancementBonusVsSAlign:	ipItemProperty = ItemPropertyEnhancementBonusVsSAlign(iParameter1, iParameter2); break;
		case ExtraMeleeDamageType:		ipItemProperty = ItemPropertyExtraMeleeDamageType(iParameter1); break;
		case ExtraRangeDamageType:		ipItemProperty = ItemPropertyExtraRangeDamageType(iParameter1); break;
		case Keen:						ipItemProperty = ItemPropertyKeen(); break;
		case MassiveCritical:			ipItemProperty = ItemPropertyMassiveCritical(iParameter1); break;
		case MaxRangeStrengthMod:		ipItemProperty = ItemPropertyMaxRangeStrengthMod(iParameter1); break;
		case SkillBonus:				ipItemProperty = ItemPropertySkillBonus(iParameter1, iParameter2); break;
		case VampiricRegeneration:		ipItemProperty = ItemPropertyVampiricRegeneration(iParameter1); break;
		case BonusSpellResistance:		ipItemProperty = ItemPropertyBonusSpellResistance(iParameter1); break;
		case Haste:						ipItemProperty = ItemPropertyHaste(); break;
		case CastSpell:					ipItemProperty = ItemPropertyCastSpell(iParameter1, iParameter2); break;
		case HolyAvenger:				ipItemProperty = ItemPropertyHolyAvenger(); break;
		case CastRandomSpell:			ipItemProperty = ItemPropertyCastSpell(iParameter1, iParameter2); break;
		case DarkVision:				ipItemProperty = ItemPropertyDarkvision(); break;
		case Regeneration:				ipItemProperty = ItemPropertyRegeneration(iParameter1); break;
		case LimitUseByClass:			ipItemProperty = ItemPropertyLimitUseByClass(iParameter1); break;
		case BonusFeat:					ipItemProperty = ItemPropertyBonusFeat(iParameter1); break;
		case DamageImmunity:			ipItemProperty = ItemPropertyDamageImmunity(iParameter1, iParameter2); break;
		case ImmunityMisc:				ipItemProperty = ItemPropertyImmunityMisc(iParameter1); break;
		case OnHitProps:				ipItemProperty = ItemPropertyOnHitProps(iParameter1, iParameter2, iParameter3); break;
		default:						SpeakString("No Valid Property Selected!", TALKVOLUME_SHOUT);
	}
	
	return ipItemProperty;
}


// //////////////////////////////////////////////////
// LEG_LOOT_CheckRestrictions
// //////////////////////////////////////////////////
int LEG_LOOT_CheckRestrictions(object oItem, string sPropertiesFile, int i2DAProperty)
{
	// Get all the restritions this property happens to have.
	string sItemType1 = Get2DAString(sPropertiesFile, "RESTRICT1", i2DAProperty);
	string sItemType2 = Get2DAString(sPropertiesFile, "RESTRICT2", i2DAProperty);
	string sItemType3 = Get2DAString(sPropertiesFile, "RESTRICT3", i2DAProperty);
	string sItemType4 = Get2DAString(sPropertiesFile, "RESTRICT4", i2DAProperty);
	int iMyItem = GetBaseItemType(oItem);
	int iItemType1 = StringToInt(sItemType1);
	int iItemType2 = StringToInt(sItemType2);
	int iItemType3 = StringToInt(sItemType3);
	int iItemType4 = StringToInt(sItemType4);
	string sGrpType1 = Get2DAString(sPropertiesFile, "GRPRESTRICT1", i2DAProperty);
	string sGrpType2 = Get2DAString(sPropertiesFile, "GRPRESTRICT2", i2DAProperty);
	string sGrpType3 = Get2DAString(sPropertiesFile, "GRPRESTRICT3", i2DAProperty);
	string sGrpType4 = Get2DAString(sPropertiesFile, "GRPRESTRICT4", i2DAProperty);
	string sExcType1 = Get2DAString(sPropertiesFile, "GRPEXCLUDE1", i2DAProperty);
	string sItemMembership1 = Get2DAString(ITEMGRPMEMBERFILE, "GROUP1", iMyItem);
	string sItemMembership2 = Get2DAString(ITEMGRPMEMBERFILE, "GROUP2", iMyItem);
	string sItemMembership3 = Get2DAString(ITEMGRPMEMBERFILE, "GROUP3", iMyItem);
	
	// If this property can be added to any item then we can use this catch all to quickly exit the
	// function.  This would assume a restrict entry of all *
	if (sItemType1 == "*" && sItemType2 == "*" && sItemType3 == "*" && sItemType4 == "*" && sGrpType1 == "*" && sGrpType2 == "*" && sGrpType3 == "*" && sGrpType4 == "*")
	{
		// If we have an exclusion, let's just check for it here.
		if (sExcType1 != "*")
		{
			if (sItemMembership1 == sExcType1 || sItemMembership2 == sExcType1 || sItemMembership3 == sExcType1)
				return 1;
			else
				return 0;
		}
		else
			return 0;
	}

	// Next we go through each individual item type.  If our current item is listed as one of them,
	// then we are also good to go.
	if (iMyItem == iItemType1 && sItemType1 != "*")
		return 0;
	if (iMyItem == iItemType2 && sItemType2 != "*")
		return 0;
	if (iMyItem == iItemType3 && sItemType3 != "*")
		return 0;
	if (iMyItem == iItemType4 && sItemType4 != "*")
		return 0;
	
	// So if we got here, that means there are restrictions and so far our item does not fall into any
	// of them, so finally we check and see if our item is in a group restriction.  If it is, we are good
	// and if not, then our item is not allowed this property.  To do this we have a group file 2da which
	// has an entry for each item type.  The row for each item, matches the itemtype so all we have to do
	// is lookup the itemtype number (which will be the row number) and see what groups this item is a member of
	if (sGrpType1 != "*")
	{
		if (sItemMembership1 == sGrpType1 || sItemMembership2 == sGrpType1 || sItemMembership3 == sGrpType1)
			return 0;
	}
	if (sGrpType2 != "*")
	{
		if (sItemMembership1 == sGrpType2 || sItemMembership2 == sGrpType2 || sItemMembership3 == sGrpType2)
			return 0;
	}
	if (sGrpType3 != "*")
	{
		if (sItemMembership1 == sGrpType3 || sItemMembership2 == sGrpType3 || sItemMembership3 == sGrpType3)
			return 0;
	}
	if (sGrpType4 != "*")
	{
		if (sItemMembership1 == sGrpType4 || sItemMembership2 == sGrpType4 || sItemMembership3 == sGrpType4)
			return 0;
	}
	
	// We added an exclusions entry into the 2DA's.  This was required because certain groups could not have
	// certain properties.  Such as Wands which typically can only have CastSpell and Weight Reductions LOL
	// So if our groups that we are members of are on this exclusion list, then we can't have that property.
	if (sExcType1 != "*")
	{
		if (sItemMembership1 == sExcType1 || sItemMembership2 == sExcType1 || sItemMembership3 == sExcType1)
			return 1;
	}
	
	return 1;
}


// //////////////////////////////////////////////////
// LEG_LOOT_FindProperty
// //////////////////////////////////////////////////
int LEG_LOOT_FindProperty(string sPropertiesFile, object oItem, object oPC)
{
	// Test function using an array.
	int iTotalRows = GetNum2DARows(sPropertiesFile);
	int iCounter = 0;
	int iPropertyType;
	string sRandomID = GetName(oPC);
	
	// Cycle through and create arrays to generate a list of non-restricted properties if the array doesnt already exist.
	// We create the array once for each NEW property we apply because we don't want the dupe checker having to come in 
	// here and re-create the array every time it finds a duplicate.
	if (!LEG_COMMON_GetArrayElementCount(OBJECT_SELF, "PropArray_" + sPropertiesFile + "Row" + sRandomID))
	{
		for (iCounter = 0; iCounter < iTotalRows; iCounter++)
		{
			iPropertyType = StringToInt(Get2DAString(sPropertiesFile, "PROPERTY", iCounter));
			
			if (!LEG_LOOT_CheckRestrictions(oItem, sPropertiesFile, iCounter))
				LEG_COMMON_AddArrayElement(OBJECT_SELF, "PropArray_" + sPropertiesFile + "Row" + sRandomID, IntToString(iCounter));
		}
	}	
	// Now we randomly choose one from the allowed list.
	int iArrayCount = LEG_COMMON_GetArrayElementCount(OBJECT_SELF, "PropArray_" + sPropertiesFile + "Row" + sRandomID);
	
	// If there are no properties available then we have a problem.
	if (!iArrayCount)
		return -1;
		
	int iChoice = Random(iArrayCount) + 1;
	int i2DARow = StringToInt(LEG_COMMON_GetArrayElement(OBJECT_SELF, "PropArray_" + sPropertiesFile + "Row" + sRandomID, iChoice));

	return i2DARow;
}



// //////////////////////////////////////////////////
// LEG_LOOT_CheckDupe
// //////////////////////////////////////////////////
int LEG_LOOT_CheckDupe(int iPropCounter, int iPropertyType, object oItem)
{
	int iDupeFound, iDupeCounter;
	
	// Loop through all the props and check for dupes.
	if (iPropCounter > 0)
	{
		for (iDupeCounter = 0; iDupeCounter < iPropCounter; iDupeCounter++)
		{
			if (iPropertyType == GetLocalInt(oItem, "Prop_" + IntToString(iDupeCounter)))
			{
				iDupeFound = TRUE;
				break;
			}
			else
				iDupeFound = FALSE;
		}
	}
	else
		iDupeFound = FALSE;
		
	return iDupeFound;
}



// //////////////////////////////////////////////////
// LEG_LOOT_GetSpell
// //////////////////////////////////////////////////
int LEG_LOOT_GetSpell(int iItemLevel, int iBaseItemType, string sPropertiesFile, object oPC)
{
	string sRandomID = GetName(oPC);
	int iCounter, iCasterLvl;
	int iTotalSpells = GetNum2DARows(DBSPELLFILE);
	int iMaxCasterLevel = iItemLevel * 3;
	int iMinCasterLevel = iMaxCasterLevel - 2;
	for (iCounter = 0; iCounter < iTotalSpells; iCounter++)
	{
		iCasterLvl = StringToInt(Get2DAString(DBSPELLFILE, "CasterLvl", iCounter));
		if ((iBaseItemType == 102 && Get2DAString(DBSPELLFILE, "ScrollUse", iCounter) == "1") || (iBaseItemType == 101 && Get2DAString(DBSPELLFILE, "PotionUse", iCounter) == "1") || (iBaseItemType == 46 && Get2DAString(DBSPELLFILE, "WandUse", iCounter) == "1"))		
		{
			if (iCasterLvl >= iMinCasterLevel && iCasterLvl <= iMaxCasterLevel)
				LEG_COMMON_AddArrayElement(OBJECT_SELF, "SpellArray_" + sPropertiesFile + "Row" + sRandomID, IntToString(iCounter));
		}
	}

	// Now we randomly choose one from the allowed list.
	int iArrayCount = LEG_COMMON_GetArrayElementCount(OBJECT_SELF, "SpellArray_" + sPropertiesFile + "Row" + sRandomID);
	
	// If there are no properties available then we have a problem.
	if (!iArrayCount)
		return -1;
		
	int iChoice = Random(iArrayCount) + 1;
	int i2DARow = StringToInt(LEG_COMMON_GetArrayElement(OBJECT_SELF, "SpellArray_" + sPropertiesFile + "Row" + sRandomID, iChoice));

	return i2DARow;

}