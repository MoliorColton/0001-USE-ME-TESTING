//-----------------------------------------------------------------------
// <copyright file="gui_cityrespawn.nss" company="Molior RS">
// Copyright (c) Molior RS. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------

void ResurrectPlayer(object oPC)
{
	// resurrect effects + Healing visual effect
	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPC);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_S), oPC);
	// resurrection spell on PC
	SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_RESURRECTION, FALSE));
	//jumps the PC to the wapypoint tag
	DelayCommand(0.0f, AssignCommand(oPC, JumpToObject(GetObjectByTag("WP_RESPAWN1"))));
	// heals the PC to full HP
	DelayCommand(0.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oPC)), oPC));
	//DelayCommand(0.0f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDazed(), oPC, RoundsToSeconds(3)));
	DelayCommand(0.0f, ExportSingleCharacter(oPC));

}

void ApplyPenalty(object oPC, object oGRAVE)
{
	//XP Loss. PC cannot lose a level.
	int nXP = GetXP(oPC);
	int nSUBRACE = GetSubRace(oPC);
	int nCACHE = GetNum2DAColumns("racialsubtypes"); //Cache the 2DA
	int nECL = StringToInt(Get2DAString("racialsubtypes", "ECL", nSUBRACE));
	int nLVL = GetTotalLevels(oPC, FALSE) + nECL;
	int nXP_LOSS = nLVL * 100;
	nCACHE = GetNum2DAColumns("exptable"); //Cache the 2DA
	int nXP_MIN = StringToInt(Get2DAString("exptable", "XP", nLVL - 1));
	int nXP_NEW = nXP - nXP_LOSS;
	if (nXP_NEW < nXP_MIN) nXP_NEW = nXP_MIN;
	if (nXP_NEW < nXP) SetXP(oPC, nXP_NEW);
	
	
	//Item Loss. All items are placed on the gravestone.
	SetDescription(oGRAVE, "Here lies " + GetName(oPC) + ".");
	SetLocalObject(oGRAVE, "GRAVE_PC", oPC);
	int nCOUNT;
	location lGRAVE = GetLocation(oGRAVE);
	object oINVALID = OBJECT_INVALID;
	DelayCommand(0.0f, ResurrectPlayer(oPC));
}

void main()
{
	object oPC = OBJECT_SELF;
	// reset StandardFactions, should remain consistent with the Faction table.
	// can use constants in the FactionTable for custom factions, i believe
	SetStandardFactionReputation(STANDARD_FACTION_COMMONER, 60, oPC);
	SetStandardFactionReputation(STANDARD_FACTION_MERCHANT, 70, oPC);
	SetStandardFactionReputation(STANDARD_FACTION_DEFENDER, 80, oPC);
	object oGRAVE = CreateObject(OBJECT_TYPE_PLACEABLE, "gravestone", GetLocation(oPC), TRUE, "grave_" + GetBicFileName(oPC));
	DelayCommand(0.0f, ApplyPenalty(oPC, oGRAVE));
}