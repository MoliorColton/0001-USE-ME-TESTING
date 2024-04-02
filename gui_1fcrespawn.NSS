//-----------------------------------------------------------------------
// <copyright file="gui_cityrespawn.nss" company="Molior RS">
// Copyright (c) Molior RS. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------
// 

//
void ResurrectPlayer(object oPC)
{
	// resurrect effects + Healing visual effect
	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPC);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_S), oPC);
	// resurrection spell on PC
	SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_RESURRECTION, FALSE));
	//jumps the PC to the wapypoint tag
	DelayCommand(0.0f, AssignCommand(oPC, JumpToObject(GetObjectByTag("fcaveexit444"))));
	// heals the PC to full HP
	DelayCommand(0.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oPC)), oPC));
	DelayCommand(0.0f, ExportSingleCharacter(oPC));
}

void ApplyPenalty(object oPC)
{

	DelayCommand(0.0f, ResurrectPlayer(oPC));
}

void main() // resets factions, in case soemthing really fucked up happens.
{
	object oPC = OBJECT_SELF;
	// reset StandardFactions, should remain consistent with the Faction table.
	// can use constants in the FactionTable for custom factions, i believe
	SetStandardFactionReputation(STANDARD_FACTION_COMMONER, 60, oPC);
	SetStandardFactionReputation(STANDARD_FACTION_MERCHANT, 70, oPC);
	SetStandardFactionReputation(STANDARD_FACTION_DEFENDER, 80, oPC);
	DelayCommand(0.0f, ApplyPenalty(oPC));

}