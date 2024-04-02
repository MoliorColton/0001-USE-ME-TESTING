#include "nw_i0_spells"
#include "profession_include"

void Overhead(object oPC, int nPRAYER, int nFAMILY)
{
	effect eFX;
	effect eVFX;
	switch (nPRAYER)
	{
			case 1: //Thick Skin	
			eVFX = EffectNWN2SpecialEffectFile("fx_pthickskin");
			eVFX = SetEffectSpellId(eVFX,34050);
			eVFX = ExtraordinaryEffect(eVFX);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVFX,oPC,2.0);	
			break;
			
			case 2: //Burst of Strength	
			eVFX = EffectNWN2SpecialEffectFile("fx_pburstofstrength");
			eVFX = SetEffectSpellId(eVFX,34050);
			eVFX = ExtraordinaryEffect(eVFX);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVFX,oPC,2.0);	
			break;
			
			case 3: //Clarity of Thought
			eVFX = EffectNWN2SpecialEffectFile("fx_pclarityofthought");
			eVFX = SetEffectSpellId(eVFX,34050);
			eVFX = ExtraordinaryEffect(eVFX);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVFX,oPC,2.0);	
			break;
			
			case 4: //Sharp Eye
			eVFX = EffectNWN2SpecialEffectFile("fx_psharpeye");
			eVFX = SetEffectSpellId(eVFX,34050);
			eVFX = ExtraordinaryEffect(eVFX);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVFX,oPC,2.0);	
			break;
			
			
			case 5: //Mystic Will
			eVFX = EffectNWN2SpecialEffectFile("fx_pmysticwill");
			eVFX = SetEffectSpellId(eVFX,34050);
			eVFX = ExtraordinaryEffect(eVFX);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVFX,oPC,2.0);	
			break;
						
			case 6: //Rock Skin		
			eVFX = EffectNWN2SpecialEffectFile("fx_prockskin");
			eVFX = SetEffectSpellId(eVFX,34050);
			eVFX = ExtraordinaryEffect(eVFX);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVFX,oPC,2.0);	
			break;			
			
			case 7: //Superhuman Strength		
			eVFX = EffectNWN2SpecialEffectFile("fx_psuperstrength");
			eVFX = SetEffectSpellId(eVFX,34050);
			eVFX = ExtraordinaryEffect(eVFX);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVFX,oPC,2.0);	
			break;			
				
			
			case 8: //Improved Reflexes
			eVFX = EffectNWN2SpecialEffectFile("fx_pimprovedreflexes");
			eVFX = SetEffectSpellId(eVFX,34050);
			eVFX = ExtraordinaryEffect(eVFX);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVFX,oPC,2.0);	
			break;			
			

			
			case 10: //Rapid Heal
			eVFX = EffectNWN2SpecialEffectFile("fx_prapidheal");
			eVFX = SetEffectSpellId(eVFX,34050);
			eVFX = ExtraordinaryEffect(eVFX);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVFX,oPC,2.0);	
			break;				
			
			case 12: //Hawk Eye
			eVFX = EffectNWN2SpecialEffectFile("fx_phawkeye");
			eVFX = SetEffectSpellId(eVFX,34050);
			eVFX = ExtraordinaryEffect(eVFX);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVFX,oPC,2.0);	
			break;			
			
			case 13: //Mystic Lore
			eVFX = EffectNWN2SpecialEffectFile("fx_pmysticlore");
			eVFX = SetEffectSpellId(eVFX,34050);
			eVFX = ExtraordinaryEffect(eVFX);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVFX,oPC,2.0);	
			break;			
			
			case 14: //Steel Skin
			eVFX = EffectNWN2SpecialEffectFile("fx_psteelskin");
			eVFX = SetEffectSpellId(eVFX,34050);
			eVFX = ExtraordinaryEffect(eVFX);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVFX,oPC,2.0);	
			break;			

			case 15: //Ultimate Strength
			eVFX = EffectNWN2SpecialEffectFile("fx_pultrastrength");
			eVFX = SetEffectSpellId(eVFX,34050);
			eVFX = ExtraordinaryEffect(eVFX);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVFX,oPC,2.0);	
			break;	
		
			case 16: //Incredible Reflexes
			eVFX = EffectNWN2SpecialEffectFile("fx_pincrediblereflexes");
			eVFX = SetEffectSpellId(eVFX,34050);
			eVFX = ExtraordinaryEffect(eVFX);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVFX,oPC,2.0);	
			break;	
			
			case 17: //Protect From Magic
			RemoveSEFFromObject(oPC, "fx_pfromrange");
			RemoveSEFFromObject(oPC, "fx_pfrommagic");
			RemoveSEFFromObject(oPC, "fx_melee");
			eVFX = EffectNWN2SpecialEffectFile("fx_pfrommagic");
			eVFX = SetEffectSpellId(eVFX,34050);
			eVFX = ExtraordinaryEffect(eVFX);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVFX,oPC, 600.0);	
			break;			
			
			case 18: //Protect from Missiles
			RemoveSEFFromObject(oPC, "fx_pfromrange");
			RemoveSEFFromObject(oPC, "fx_pfrommagic");
			RemoveSEFFromObject(oPC, "fx_melee");
			eVFX = EffectNWN2SpecialEffectFile("fx_pfromrange");
			eVFX = SetEffectSpellId(eVFX,34050);
			eVFX = ExtraordinaryEffect(eVFX);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVFX,oPC, 600.0);	
			break;			
			
			case 19: //Protect From melee	
			RemoveSEFFromObject(oPC, "fx_pfromrange");
			RemoveSEFFromObject(oPC, "fx_pfrommagic");
			RemoveSEFFromObject(oPC, "fx_melee");
			eVFX = EffectNWN2SpecialEffectFile("fx_melee");
			eVFX = SetEffectSpellId(eVFX,34050);
			eVFX = ExtraordinaryEffect(eVFX);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVFX,oPC, 600.0);
			break;
			
			case 20: //Eagle Eye	
			eVFX = EffectNWN2SpecialEffectFile("fx_peagleeye");
			eVFX = SetEffectSpellId(eVFX,34050);
			eVFX = ExtraordinaryEffect(eVFX);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVFX,oPC,2.0);	
			break;
			
			case 21: //Mystic Might	
			eVFX = EffectNWN2SpecialEffectFile("fx_pmysticmight");
			eVFX = SetEffectSpellId(eVFX,34050);
			eVFX = ExtraordinaryEffect(eVFX);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVFX,oPC,2.0);	
			break;
			
			case 22: //Rapid Renewall	
			eVFX = EffectNWN2SpecialEffectFile("fx_rapidrenewall");
			eVFX = SetEffectSpellId(eVFX,34050);
			eVFX = ExtraordinaryEffect(eVFX);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVFX,oPC,600.0);	
			break;
	}
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
	int nPRAYER = StringToInt(sPRAYER);
	int nFAMILY;
	int nCOST;
	int nREQ;
	switch (nPRAYER)
	{
		case 1: nFAMILY = -681; nCOST = 1; nREQ = 1; break; //Thick Skin
		case 2: nFAMILY = -682; nCOST = 4; nREQ = 4; break; //Burst of Strength
		case 3: nFAMILY = -687; nCOST = 7; nREQ = 7; break; //Clarity of Thought
		case 4: nFAMILY = -683; nCOST = 8; nREQ = 8; break; //Sharp Eye
		case 5: nFAMILY = -684; nCOST = 9; nREQ = 9; break; //Mystic Will
		case 6: nFAMILY = -681; nCOST = 10; nREQ = 10; break; //Rock Skin
		case 7: nFAMILY = -682; nCOST = 13; nREQ = 13; break; //Superhuman Strength
		case 8: nFAMILY = -687; nCOST = 16; nREQ = 16; break; //Improved Reflexes
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
		return;
	}
	if (nPOINTS < nCOST)
	{
		return;
	}
	RemoveEffectsFromSpell(oPC, nFAMILY);
	DelayCommand(0.0f, Overhead(oPC, nPRAYER, nFAMILY));
}