// --------- \\
// CONSTANTS \\
// --------- \\

//Options for Clangeddin's Fixes (recompile "clangfix_equip" and "i_clangfix_ac" scripts if you change this)
const int CLANG_DISABLE_EFFECTFIX = FALSE;				//Set to TRUE if you wish to disable the "cpu intensive" check that fixes damage immunity from temporary effects.
const int CLANG_DISABLE_IUDFIX = FALSE;					//Set to TRUE if you wish to disable the fix to Improved Uncanny Dodge.
const int CLANG_DISABLE_BUFFDEVICE = FALSE;				//Set to TRUE if you wish to disable the buffing device.
const int CLANG_FXEQUIP = -9004; 						//The ID used to identify effects applied by On Equip scripts.
const int CLANG_MAXIMMU = 100;							//The maximum amount of damage immunity % from items. (range 0 to 100).
const int CLANG_MAXVULN = 100;							//The maximum amount of damage vulnerabilty % from items. (range 0 to 100).

//Options for Clangeddin's Rebuild (recompile "gui_clang_rebuild" script if you change this)
const int CLANG_REB_DELETE_HISTORY = FALSE;				//If set to TRUE, Relevels will remove History Feats as well.
const int CLANG_REB_FULL_FORBIDBACK = FALSE;			//If set to TRUE, Full Rebuild will no longer allow Background Change.
const int CLANG_REB_FULL_FORBIDGOD = FALSE;				//If set to TRUE, Full Rebuild will no longer allow Deity Change.
const int CLANG_REB_FULL_GOLDSCALE = FALSE; 			//If set to TRUE, the gold cost of full rebuild will scale up with the character's level.
const int CLANG_REB_FULL_GOLDCOST = 0; 					//If higher than 0, full rebuild will cost gold.
const int CLANG_REB_FULL_ITEMCOST = FALSE; 				//If set to TRUE, full rebuild will require an item.
const string CLANG_REB_FULL_ITEM_TAG = "cft_gem_14"; 	//The tag of the items required to do full rebuild.
const int CLANG_REB_PART_GOLDSCALE = FALSE; 			//If set to TRUE, the gold cost of partial rebuild will scale up with the character's level.
const int CLANG_REB_PART_GOLDCOST = 0; 					//If higher than 0, partial rebuild will cost gold.
const int CLANG_REB_PART_ITEMCOST = FALSE;				//If set to TRUE, partial rebuild will require an item.
const string CLANG_REB_PART_ITEM_TAG = "cft_gem_14"; 	//The tag of the items required to do partial rebuild.

//Options for Clangeddin's User Interface (recompile "gui_clangui" script if you change this)
const int CLANG_UI_DISABLE_RECALL = FALSE;				//If set to TRUE, Recall companion feature will be disabled.
const int CLANG_UI_DISABLE_HPNUMBERS = FALSE;			//If set to TRUE, target window will not display HP numbers.
const int CLANG_UI_DISABLE_STORAGE = FALSE;				//If set to TRUE, the multiplayer persistent storage will be disabled.

// ---------- \\
// PROTOTYPES \\
// ---------- \\

//Returns a proper element string for the various DAMAGE_TYPE_ variables.
//For example for nELEMENT = DAMAGE_TYPE_FIRE it will return the string "Fire".
//nCAPS: if TRUE it will set all the string to Upper case. (In the above example it would be "FIRE")
string GetElementString(int nELEMENT, int nCAPS = FALSE);

//Returns the corresponding DAMAGE_TYPE_* variable from the IP_CONST_DAMAGETYPE_* equivalent.
//nREVERSE: if TRUE then it will do the reverse operation, returning the IP_CONST_DAMAGETYPE_* variable from DAMAGE_TYPE_* equivalent.
//Returns -1 on error.
int ConvertElement(int nELEMENT, int nREVERSE = FALSE);

//Returns how many sTAG tagged items oPC possesses. This includes stack size.
//For example, if I have one stack with 99 arrows and one stack with 41 arrows, this function will return 140.
//nREF: if TRUE then sTAG will be meant as the item's resref (template?) string instead of tag.
int GetItemQuantity(object oPC, string sTAG, int nREF = FALSE);

//Returns how many items (actually how many stacks of items) oPC has.
//For example, if I only have one stack of 10 potions and 1 weapon, this function will return 2.
//nBAGS: If set to TRUE, it will also count items inside containers.
int GetInventoryNum(object oPC, int nBAGS = FALSE);

//Returns the true level of oPC, including the ECL penalty from subrace adjustment
int GetTrueLevel(object oPC);

//A wrapper to apply damage to objects easily.
//Can go beyond 9999 damage.
//nIGNORES: an int between 0 and 100 that represents the percentage of the damage that will ignores resistance.
//For example nIGNORES = 50, means that half damage will ignore resistances.
void DealDamage(object oTARGET, int nDMG, int nTYPE, int nPOWER = DAMAGE_POWER_NORMAL, int nIGNORES = 0);

//Removes nQTY items tagged sTAG from oPC.
//nFEED: If TRUE feedback will be displayed in the combat log.
//nREF: if TRUE then sTAG will be meant as the item's resref (template?) string instead of tag.
void RemoveItems(object oPC, string sTAG, int nQTY, int nFEED = TRUE, int nREF = FALSE);

//Forces oTARGET to attack oPC for at least fDUR Seconds.
//nINTERRUPT: If set to TRUE it will also interrupt any action performed by oTARGET.
//nPVP: If set to TRUE, it will also work against players.
//nSTART: Should stay set to TRUE. It's false only inside itself as a recursive call.
void RunTaunt(object oPC, object oTARGET, float fDUR, int nINTERRUPT = TRUE, int nPVP = TRUE, int nSTART = TRUE);

//Plays sSOUND at lSOUND location.
//sSOUND is the name of the sound file without the extension.
//n2D: if TRUE the sound will be played as 2D.
void ReallyPlaySound(location lSOUND, string sSOUND, int n2D = FALSE);

//Workoaround to make PlayCustomAnimation really work.
//Use it with AssignCommand to oPC, like this: AssignCommand(oPC, ReallyPlayCustomAnimation(oPC, sANIM));
void ReallyPlayCustomAnimation(object oPC, string sANIM, int nLOOP = FALSE, float fSPEED = 1.0);

//Returns TRUE if the spell with ID nSPELL cast by oPC on oTarget is to be considered a buffing spell.
//Works with standard NWN2 rules, customized/new spells may not be recognized properly.
int GetIsBuffSpell(object oPC, object oTARGET, int nSPELL);

//A Wrapper to apply eFX effect to oPC a more convenient way.
//fDUR: defines the duration of the effect. If equal to 0.0f, the effect is considered INSTANT, if negative it's considered permanent.
//nSUB defines if the effect is magical, extraordinary or supernatural.
//nID: if different than 0, it will set the effect to have said Spell Id. Negative numbers work.
void ApplyEffectToObjectFaster(object oPC, effect eFX, float fDUR = 0.0f, int nSUB = SUBTYPE_MAGICAL, int nID = 0);

//A wrapper to properly delevel characters, also needed to properly handle character deleveling past level 40.
//Warning: characters with a real level of 41 or higher (for example a level 39 Drow) will not use the SetXP
//function, instead they will use the ResetCreatureLevelForXP one. This implies that they will be sent back to
//level 1 regardless and they will have the choices of their starting package applied to that level
//(this includes feats and spells).
void ProperlyRelevelCharacter(object oPC, int nLVL);

//A function to handle the storage of variables saved in the character's essence for singleplayer games.
//Make use of it when you must export a character or when your character is about to change module (inside a campaign for example).
//Using it again will retrieve the copied essence from the container.
//The stored copy of the essence is tagged as "clangfix_stored".
void AutoItemConservation(object oPC);



// ----------- \\
// DEFINITIONS \\
// ----------- \\

void DealDamage(object oTARGET, int nDMG, int nTYPE, int nPOWER = DAMAGE_POWER_NORMAL, int nIGNORES = 0)
{
	if (nDMG < 1) return;
	int nDAMAGE = nDMG;
	if (nDAMAGE > 9999) nDAMAGE = 9999;
	if (nIGNORES <= 0) ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDAMAGE, nTYPE, nPOWER, FALSE), oTARGET);
	else if (nIGNORES >= 100) ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDAMAGE, nTYPE, nPOWER, TRUE), oTARGET);
	else
	{
		int nIGNORED = (nDAMAGE * nIGNORES) / 100;
		int nRESISTED = nDAMAGE - nIGNORES;
		if (nIGNORED > 0) ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nIGNORED, nTYPE, nPOWER, TRUE), oTARGET);
		if (nRESISTED > 0) ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nRESISTED, nTYPE, nPOWER, FALSE), oTARGET);
	}
	DelayCommand(0.0f, DealDamage(oTARGET, nDMG - 9999, nTYPE, nIGNORES));
}

void ApplyEffectToObjectFaster(object oPC, effect eFX, float fDUR = 0.0f, int nSUB = SUBTYPE_MAGICAL, int nID = 0)
{
	int nDUR = DURATION_TYPE_INSTANT;
	if (fDUR > 0.0f) nDUR = DURATION_TYPE_TEMPORARY;
	else if (fDUR < 0.0f) nDUR = DURATION_TYPE_PERMANENT;
	if (nSUB == SUBTYPE_EXTRAORDINARY) eFX = ExtraordinaryEffect(eFX);
	else if (nSUB == SUBTYPE_SUPERNATURAL) eFX = SupernaturalEffect(eFX);
	if (nID != 0) eFX = SetEffectSpellId(eFX, nID);
	ApplyEffectToObject(nDUR, eFX, oPC, fDUR);
}

//Only used inside RunTaunt, do not use anywhere else.
void LockOnTarget(object oPC, object oTARGET)
{
	if (GetCurrentAction(oTARGET) == ACTION_CASTSPELL) return;
	if (GetAttemptedAttackTarget() == oPC)
	{
		if (GetAttackTarget(oTARGET) == oPC) return;
	}
	ClearAllActions();
	ActionAttack(oPC);
}

void RunTaunt(object oPC, object oTARGET, float fDUR, int nINTERRUPT = TRUE, int nPVP = TRUE, int nSTART = TRUE)
{	
	if (nSTART == TRUE)
	{
		if (GetLocalInt(oTARGET, "TAUNT_IMMUNE") == TRUE)
		{
			string sTXT = GetName(oTARGET) + "is immune to taunt effects.";
			SendMessageToPC(oPC, sTXT);
			return;
		}
		if ((nPVP != TRUE) && (GetIsPC(oTARGET) == TRUE)) return;
		if (GetLocalObject(oTARGET, "TAUNT_SOURCE") != OBJECT_INVALID)
		{
			string sTXT = GetName(oTARGET) + "is already under the effects of a taunt.";
			SendMessageToPC(oPC, sTXT);
			return;
		}
		if (nINTERRUPT == TRUE) AssignCommand(oTARGET, ClearAllActions());
		effect eTAUNT = ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_TAUNT));
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTAUNT, oTARGET, fDUR);
		SetLocalObject(oTARGET, "TAUNT_SOURCE", oPC);	
	}
	if (fDUR <= 0.0f)
	{
		DeleteLocalObject(oTARGET, "TAUNT_SOURCE");
		return;
	}
	if (GetIsDead(oPC) == TRUE)
	{
		DeleteLocalObject(oTARGET, "TAUNT_SOURCE");
		return;
	}
	if (GetIsDead(oTARGET) == TRUE)
	{
		DeleteLocalObject(oTARGET, "TAUNT_SOURCE");
		return;
	}
	AssignCommand(oTARGET, LockOnTarget(oPC, oTARGET));
	DelayCommand(0.5, RunTaunt(oPC, oTARGET, fDUR - 0.5, nINTERRUPT, nPVP, FALSE));
}

void RemoveItems(object oPC, string sTAG, int nQTY, int nFEED = TRUE, int nREF = FALSE)
{
	if (sTAG == "") return;
	if (nQTY < 1) return;
	int nCOUNT = nQTY;
	int nSTACK;
	string sITEM;
	object oITEM = GetFirstItemInInventory(oPC);
	while (oITEM != OBJECT_INVALID)
	{
		if (nREF == TRUE) sITEM = GetResRef(oITEM);
		else sITEM = GetTag(oITEM);
		if (sITEM == sTAG)
		{
			nSTACK = GetItemStackSize(oITEM);
			if (nSTACK > nCOUNT) SetItemStackSize(oITEM, nSTACK - nCOUNT, nFEED);
			else DestroyObject(oITEM, 0.0f, nFEED);
			nCOUNT = nCOUNT - nSTACK;
			if (nCOUNT < 1) return;
		}
		oITEM = GetNextItemInInventory(oPC);
	}
}

int GetItemQuantity(object oPC, string sTAG, int nREF = FALSE)
{
	if ((nREF == FALSE) && (GetItemPossessedBy(oPC, sTAG) == OBJECT_INVALID)) return 0;
	int nTOT;
	string sITEM;
	object oITEM = GetFirstItemInInventory(oPC);
	while (oITEM != OBJECT_INVALID)
	{
		if (nREF == TRUE) sITEM = GetResRef(oITEM);
		else sITEM = GetTag(oITEM);
		if (sITEM == sTAG) nTOT = nTOT + GetItemStackSize(oITEM);
		oITEM = GetNextItemInInventory(oPC);
	}
	return nTOT;
}

int GetInventoryNum(object oPC, int nBAGS = FALSE)
{
	int nITEM;
	int nBAG;
	object oBAG;
	object oIN;
	object oITEM = GetFirstItemInInventory(oPC);
	while (oITEM != OBJECT_INVALID)
	{
		if (nBAG > 0) nBAG = nBAG - 1;
		else nITEM = nITEM + 1;
		if ((GetHasInventory(oITEM) == TRUE) && (nBAGS != TRUE))
		{
			oBAG = oITEM;
			oIN = GetFirstItemInInventory(oBAG);
			while (oIN != OBJECT_INVALID)
			{
				nBAG = nBAG + 1;
				oIN = GetNextItemInInventory(oBAG);	
			}
		}
		oITEM = GetNextItemInInventory(oPC);
	}
	return nITEM;
}

void ReallyPlaySound(location lSOUND, string sSOUND, int n2D = FALSE)
{
	string sOUTPUT = sSOUND;
	if (n2D = TRUE) sOUTPUT = "D_" + sSOUND;
	object oSOUND = CreateObject(OBJECT_TYPE_CREATURE, "soundplayer", lSOUND, FALSE, sOUTPUT);
}

void ReallyPlayCustomAnimation(object oPC, string sANIM, int nLOOP = FALSE, float fSPEED = 1.0f)
{
	PlayCustomAnimation(oPC, sANIM, nLOOP, fSPEED);
}

string GetElementString(int nELEMENT, int nCAPS = FALSE)
{
	string sTXT;
	switch (nELEMENT)
	{
		case DAMAGE_TYPE_BLUDGEONING: sTXT = "Bludgeoning"; break;
		case DAMAGE_TYPE_PIERCING: sTXT = "Piercing"; break;
		case DAMAGE_TYPE_SLASHING: sTXT = "Slashing"; break;
		case DAMAGE_TYPE_MAGICAL: sTXT = "Magical"; break;
		case DAMAGE_TYPE_ACID: sTXT = "Acid"; break;
		case DAMAGE_TYPE_COLD: sTXT = "Cold"; break;
		case DAMAGE_TYPE_DIVINE: sTXT = "Divine"; break;
		case DAMAGE_TYPE_ELECTRICAL: sTXT = "Electrical"; break;
		case DAMAGE_TYPE_FIRE: sTXT = "Fire"; break;
		case DAMAGE_TYPE_NEGATIVE: sTXT = "Negative"; break;
		case DAMAGE_TYPE_POSITIVE: sTXT = "Positive"; break;
		case DAMAGE_TYPE_SONIC: sTXT = "Sonic"; break;
		default: sTXT = "Error";
	}
	if (nCAPS == TRUE) sTXT = GetStringUpperCase(sTXT);
	return sTXT;
}

int ConvertElement(int nELEMENT, int nREVERSE = FALSE)
{
	if (nREVERSE == TRUE)
	{
		switch (nELEMENT)
		{
			case DAMAGE_TYPE_BLUDGEONING: 	return IP_CONST_DAMAGETYPE_BLUDGEONING;
			case DAMAGE_TYPE_PIERCING: 		return IP_CONST_DAMAGETYPE_PIERCING;
			case DAMAGE_TYPE_SLASHING: 		return IP_CONST_DAMAGETYPE_SLASHING;
			case DAMAGE_TYPE_MAGICAL: 		return IP_CONST_DAMAGETYPE_MAGICAL;
			case DAMAGE_TYPE_ACID: 			return IP_CONST_DAMAGETYPE_ACID;
			case DAMAGE_TYPE_COLD: 			return IP_CONST_DAMAGETYPE_COLD;
			case DAMAGE_TYPE_DIVINE: 		return IP_CONST_DAMAGETYPE_DIVINE;
			case DAMAGE_TYPE_ELECTRICAL: 	return IP_CONST_DAMAGETYPE_ELECTRICAL;
			case DAMAGE_TYPE_FIRE: 			return IP_CONST_DAMAGETYPE_FIRE;
			case DAMAGE_TYPE_NEGATIVE: 		return IP_CONST_DAMAGETYPE_NEGATIVE;
			case DAMAGE_TYPE_POSITIVE: 		return IP_CONST_DAMAGETYPE_POSITIVE;
			case DAMAGE_TYPE_SONIC: 		return IP_CONST_DAMAGETYPE_SONIC;
		}
	}
	else
	{
		switch (nELEMENT)
		{
			case IP_CONST_DAMAGETYPE_BLUDGEONING: 	return DAMAGE_TYPE_BLUDGEONING;
			case IP_CONST_DAMAGETYPE_PIERCING: 		return DAMAGE_TYPE_PIERCING;
			case IP_CONST_DAMAGETYPE_SLASHING: 		return DAMAGE_TYPE_SLASHING;
			case IP_CONST_DAMAGETYPE_MAGICAL: 		return DAMAGE_TYPE_MAGICAL;
			case IP_CONST_DAMAGETYPE_ACID: 			return DAMAGE_TYPE_ACID;
			case IP_CONST_DAMAGETYPE_COLD: 			return DAMAGE_TYPE_COLD;
			case IP_CONST_DAMAGETYPE_DIVINE: 		return DAMAGE_TYPE_DIVINE;
			case IP_CONST_DAMAGETYPE_ELECTRICAL: 	return DAMAGE_TYPE_ELECTRICAL;
			case IP_CONST_DAMAGETYPE_FIRE: 			return DAMAGE_TYPE_FIRE;
			case IP_CONST_DAMAGETYPE_NEGATIVE: 		return DAMAGE_TYPE_NEGATIVE;
			case IP_CONST_DAMAGETYPE_POSITIVE: 		return DAMAGE_TYPE_POSITIVE;
			case IP_CONST_DAMAGETYPE_SONIC:			return DAMAGE_TYPE_SONIC;
		}
	}
	return -1;
}

int GetIsBuffSpell(object oPC, object oTARGET, int nSPELL)
{
	switch(nSPELL)
	{
		//Positive Exceptions
		case SPELL_LIGHT:
			return TRUE;
			
		//Negative Exceptions
		case SPELL_SHIELD_OTHER:
		case SPELL_SANCTUARY:
		case SPELL_BANE:
		case SPELL_ENLARGE_PERSON:
		case SPELL_REDUCE_PERSON:
		case SPELL_REDUCE_PERSON_GREATER:
		case SPELL_REDUCE_PERSON_MASS:
		case SPELL_REDUCE_ANIMAL:
			return FALSE;
			
		//Conditional Exceptions
		case SPELL_GREATER_MAGIC_WEAPON:
		case SPELL_MAGIC_WEAPON:
		case SPELL_KEEN_EDGE:
		case SPELL_WEAPON_OF_IMPACT:
		case SPELL_BLADES_OF_FIRE:
		case SPELL_FLAME_WEAPON:
			object oWEAPON = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTARGET);
			if (oWEAPON == OBJECT_INVALID) return FALSE;
			if (GetWeaponRanged(oWEAPON) == TRUE)
			{
				if (nSPELL == SPELL_GREATER_MAGIC_WEAPON) return TRUE;
				if (nSPELL == SPELL_MAGIC_WEAPON) return TRUE;
				else return FALSE;
			}
			if (GetWeaponType(oWEAPON) == WEAPON_TYPE_BLUDGEONING)
			{
				if (nSPELL == SPELL_KEEN_EDGE) return FALSE;
			}
			else if (nSPELL == SPELL_WEAPON_OF_IMPACT) return FALSE;
			return TRUE;		
	}
	
	if ((Get2DAString("spells", "Range", nSPELL) == "P") && (oPC != oTARGET)) return FALSE;
	int nCATEGORY = StringToInt(Get2DAString("spells", "Category", nSPELL));
	switch (nCATEGORY)
	{
		case 8:
		case 9:
		case 10:
		case 12:
		case 13:
		case 14:
			return TRUE;
	}
	return FALSE;
}

void AutoItemConservation(object oPC)
{
	if (GetInventoryNum(oPC) > 127)
	{
		FloatingTextStringOnCreature("Inventory Full. Cannot proceed with essence transfer.", oPC, FALSE);
		return;
	}
	
	object oNEW;
	object oESS = GetItemPossessedBy(oPC, "clangfix");
	object oBAG = GetItemPossessedBy(oPC, "clangfix_container");
	if (oBAG == OBJECT_INVALID)
	{
		oBAG = CreateItemOnObject("clangfix_container", oPC);
		oNEW = CopyItem(oESS, oBAG, TRUE);
		SetTag(oNEW, "clangfix_stored");
		FloatingTextStringOnCreature("Stored character's essence in transfer container.", oPC, FALSE);
		return;
	}
	
	object oIN = GetFirstItemInInventory(oBAG);
	while (oIN != OBJECT_INVALID)
	{
		if (GetTag(oIN) == "clangfix_stored")
		{
			oNEW = CopyItem(oIN, oPC, TRUE);
			SetTag(oNEW, "clangfix");
			DestroyObject(oESS, 0.0f, FALSE);
			DestroyObject(oBAG, 0.0f, FALSE);
			FloatingTextStringOnCreature("Retrieved stored essence from transfer container.", oPC, FALSE);
			return;
		}
		oIN = GetNextItemInInventory(oBAG);
	}
	DestroyObject(oBAG, 0.0f, FALSE);
}

void ProperlyRelevelCharacter(object oPC, int nLVL)
{
	int nXP = GetXP(oPC);
	int n2DA_LVL = GetNum2DARows("exptable");
	int nMAX = n2DA_LVL - 1;
	if (nLVL < 1) nLVL = 1;
	else if (nLVL > nMAX) nLVL = nMAX;
	if (GetTrueLevel(oPC) > 40) ResetCreatureLevelForXP(oPC, 0, FALSE);
	else SetXP(oPC, 0);
	DelayCommand(0.0f, SetXP(oPC, nXP));
}

void LoopTemporaryImmunity(object oPC, int nELEMENT, int nTEMP)
{
	if (CLANG_DISABLE_EFFECTFIX == TRUE) return;
	if (nELEMENT == DAMAGE_TYPE_BLUDGEONING) return;
	if (nELEMENT == DAMAGE_TYPE_PIERCING) return;
	if (nELEMENT == DAMAGE_TYPE_SLASHING) return;
	if (nTEMP < 1) return;
	int nPERM = GetLocalInt(oPC, "CLANGFIX_ELEM_PERM_" + IntToString(nELEMENT));
	if (nTEMP + nPERM < 100) return;
	
	int nNEW_TEMP = 0;
	effect ePREV = GetFirstEffect(oPC);
	while (GetIsEffectValid(ePREV) == TRUE)
	{
		if (GetEffectType(ePREV) == EFFECT_TYPE_DAMAGE_IMMUNITY_INCREASE)
		{
			if (GetEffectInteger(ePREV, 0) == nELEMENT)
			{
				if (GetEffectDurationType(ePREV) == DURATION_TYPE_TEMPORARY)
				{
					nNEW_TEMP = nNEW_TEMP + GetEffectInteger(ePREV, 1);
				}
			}					
		}
		ePREV = GetNextEffect(oPC);
	}
	effect eFX = EffectDamageResistance(nELEMENT, 9999);
	eFX = SupernaturalEffect(eFX);
	eFX = SetEffectSpellId(eFX, CLANG_FXEQUIP);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFX, oPC, 6.0);
	DelayCommand(6.0, LoopTemporaryImmunity(oPC, nELEMENT, nNEW_TEMP));
}

int GetTrueLevel(object oPC)
{
	string sECL = Get2DAString("racialsubtypes", "ECL", GetSubRace(oPC));
	int nECL = StringToInt(sECL);
	if (nECL < 0) nECL = 0;
	int nLEVEL = GetHitDice(oPC) + nECL;
	return nLEVEL;
}