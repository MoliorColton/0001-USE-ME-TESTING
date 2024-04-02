#include "x0_i0_spells"

void main(string mode, string text)
{
	object oPC = OBJECT_SELF;
//	SendMessageToPC(oPC,"Debug Mode: "+mode);
//	SendMessageToPC(oPC,"Debug Text: "+text);
		
	if(mode == "S")	DeleteLocalInt(oPC,"WhisperMode");
	else if(mode == "W") SetLocalInt(oPC,"WhisperMode",1);
	else if(mode == "type" && text != "" && GetLocalInt(oPC,"WhisperMode") == 0
	&& GetIsObjectValid(oPC) && GetIsPC(oPC) && !GetIsPossessedFamiliar(oPC) && !GetIsDM(oPC)
	&& !GetIsDMPossessed(oPC) )
	{		
	
		SetLocalInt(oPC,"TextLength",GetStringLength(text));
		
		if(GetHasSpellEffect(34050,oPC)) RefreshSpellEffectDurations(oPC,34050,4.0f);
		else
		{
			effect eVFX = EffectNWN2SpecialEffectFile("fx_chatbubble");
			eVFX = SetEffectSpellId(eVFX,34050);
			eVFX = ExtraordinaryEffect(eVFX);
			
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVFX,oPC,4.0f);
		}
	}
	else if(mode =="clear")
	{
		RemoveAnySpellEffects(34050,oPC);
	}
}