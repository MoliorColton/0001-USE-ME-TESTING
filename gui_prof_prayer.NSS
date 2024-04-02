#include "nw_i0_spells"
#include "profession_include"

void ApplyPrayer(object oPC, int nPRAYER, int nFAMILY)
{
	effect eFX;
	switch (nPRAYER)
	{
		case 01: //Thick Skin
			eFX = EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 5);
			eFX = EffectLinkEffects(eFX, EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING, 5));
			eFX = EffectLinkEffects(eFX, EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, 5));
			break;
		case 02: eFX = EffectAbilityIncrease(ABILITY_STRENGTH, 2); break; //Burst of Strength
		case 03: eFX = EffectAttackIncrease(2); break; //Clarity of Thought
		case 04: eFX = EffectAbilityIncrease(ABILITY_DEXTERITY, 2); break; //Sharp Eye
		case 05: eFX = EffectAbilityIncrease(ABILITY_INTELLIGENCE, 2); break; //Mystic Will
		case 06: //Rock Skin
			eFX = EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 10);
			eFX = EffectLinkEffects(eFX, EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING, 10));
			eFX = EffectLinkEffects(eFX, EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, 10));
			break;
		case 07: eFX = EffectAbilityIncrease(ABILITY_STRENGTH, 4); break; //Superhuman Strength
		case 08: eFX = EffectAttackIncrease(4); break; //Improved Reflexes
case 10:
{
    // Calculate regeneration amount as a fixed value
    int nRegenAmount = 100;
    // Apply the regeneration effect with a 10-second interval
    eFX = EffectRegenerate(nRegenAmount, 30.0);
}
break; // Rapid Heal

		case 12: eFX = EffectAbilityIncrease(ABILITY_DEXTERITY, 4); break; //Hawk Eye
		case 13: eFX = EffectAbilityIncrease(ABILITY_INTELLIGENCE, 4); break; //Mystic Lore
		case 14: //Steel Skin
			eFX = EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 15);
			eFX = EffectLinkEffects(eFX, EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING, 15));
			eFX = EffectLinkEffects(eFX, EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, 15));
			break;
		case 15: eFX = EffectAbilityIncrease(ABILITY_STRENGTH, 6); break; //Ultimate Strength
		case 16: eFX = EffectAttackIncrease(6); break; //Incredible Reflexes
		case 17: //Protect from Magic
			eFX = EffectDamageImmunityIncrease(DAMAGE_TYPE_MAGICAL, 50);
			break; 
		case 18: //Protect from Missile
			eFX = EffectConcealment(50, MISS_CHANCE_TYPE_VS_RANGED);
			break; 
		case 19: //Protect from Melee
			eFX = EffectConcealment(50, MISS_CHANCE_TYPE_VS_MELEE);
			break; 
		case 20: eFX = EffectAbilityIncrease(ABILITY_DEXTERITY, 6); break; //Eagle Eye
		case 21: eFX = EffectAbilityIncrease(ABILITY_INTELLIGENCE, 6); break; //Mystic Might
		case 22:
{
    // Calculate regeneration amount as a fixed value
    int nRegenAmount = 1000;
    // Apply the regeneration effect with a 10-second interval
    eFX = EffectRegenerate(nRegenAmount, 30.0);
}
break; // Rapid Renewall
		
		
	}
	eFX = ExtraordinaryEffect(eFX);
	eFX = SetEffectSpellId(eFX, nFAMILY);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFX, oPC, 600.0);
}

void main(string sPRAYER)
{
	object oPC = OBJECT_SELF;
	object oESSENCE = GetLocalObject(oPC, "PLAYER_ESSENCE");
	if (oESSENCE == OBJECT_INVALID)
	{
		oESSENCE = GetItemPossessedBy(oPC, "player_essence");
		SetLocalObject(oPC, "PLAYER_ESSENCE", oESSENCE);
	}
	int nPOINTS = GetLocalInt(oESSENCE, "PRAYER_POINTS");
	int nRANK = GetSkillRank(SKILL_PRAYER, oPC);
	if (sPRAYER == "UPDATE")
	{
		string sTXT = "" + IntToString(nPOINTS) + "/" + IntToString(nRANK);
		SetGUIObjectText(oPC, "SCREEN_CHARACTER", "PRAYER_POINTS", -1, sTXT);
		SetGUIObjectText(oPC, "SCREEN_INVENTORY", "PRAYER_POINTS", -1, sTXT);
		return;
	}
	int nPRAYER = StringToInt(sPRAYER);
	int nFAMILY;
	int nCOST;
	int nREQ;
	switch (nPRAYER)
	{
		case 01: nFAMILY = -681; nCOST = 1; nREQ = 1; break; //Thick Skin
		case 02: nFAMILY = -682; nCOST = 4; nREQ = 4; break; //Burst of Strength
		case 03: nFAMILY = -687; nCOST = 7; nREQ = 7; break; //Clarity of Thought
		case 04: nFAMILY = -683; nCOST = 8; nREQ = 8; break; //Sharp Eye
		case 05: nFAMILY = -684; nCOST = 9; nREQ = 9; break; //Mystic Will
		case 06: nFAMILY = -681; nCOST = 10; nREQ = 10; break; //Rock Skin
		case 07: nFAMILY = -682; nCOST = 13; nREQ = 13; break; //Superhuman Strength
		case 08: nFAMILY = -687; nCOST = 16; nREQ = 16; break; //Improved Reflexes
		case 10: nFAMILY = -685; nCOST = 22; nREQ = 22; break; //Rapid Heal
		case 12: nFAMILY = -683; nCOST = 26; nREQ = 26; break; //Hawk Eye
		case 13: nFAMILY = -684; nCOST = 27; nREQ = 27; break; //Mystic Lore
		case 14: nFAMILY = -681; nCOST = 28; nREQ = 28; break; //Steel Skin
		case 15: nFAMILY = -682; nCOST = 31; nREQ = 31; break; //Ultimate Strength
		case 16: nFAMILY = -687; nCOST = 34; nREQ = 34; break; //Incredible Reflexes
		case 17: nFAMILY = -686; nCOST = 37; nREQ = 37; break; //Protect from Magic
		case 18: nFAMILY = -686; nCOST = 40; nREQ = 40; break; //Protect from Missile
		case 19: nFAMILY = -686; nCOST = 43; nREQ = 43; break; //Protect from Melee
		case 20: nFAMILY = -683; nCOST = 44; nREQ = 44; break; //Eagle Eye
		case 21: nFAMILY = -684; nCOST = 45; nREQ = 45; break; //Mystic Might
		case 22: nFAMILY = -685; nCOST = 65; nREQ = 65; break; //Rapid Renewal
	}
	if (nRANK < nREQ)
	{
		SendMessageToPC(oPC, "You need a Prayer level of " + IntToString(nREQ) + " to use that.");
		return;
	}
	if (nPOINTS < nCOST)
	{
		SendMessageToPC(oPC, "You don't have enough Prayer Points to use that.");
		return;
	}
	SetLocalInt(oESSENCE, "PRAYER_POINTS", nPOINTS - nCOST);
	RemoveEffectsFromSpell(oPC, nFAMILY);
	DelayCommand(0.0f, ApplyPrayer(oPC, nPRAYER, nFAMILY));
}