// =============================================================
//
//    File: row_fp_door_damage
//    Desc: Rowell's Fair Play Door - Damage Event
//  Author: Michael Marzilli
//    Site: http://www.engliton.org
//
// Created: Oct 02, 2006
// Updated: Nov 01, 2006
// Version: 1.0.0
//
// =============================================================

void main() {
	object oDoor  = OBJECT_SELF;
	object oPC    = GetLastAttacker(oDoor);
	int    iMaxHP = GetMaxHitPoints(oDoor);
	int    iCurHP = GetCurrentHitPoints(oDoor);
	int    iDmg   = GetTotalDamageDealt();

	// CHECK IF DOOR IS INITIALIZED
	if (GetLocalInt(oDoor, "IsInitialized") != 1) {
		SetPlotFlag(oDoor, TRUE);
		SetLocalInt(oDoor, "IsTrapped", GetIsTrapped(oDoor));
		SetLocalInt(oDoor, "IsLocked", GetLocked(oDoor));
		SetLocalInt(oDoor, "CurHP", GetMaxHitPoints(oDoor));
		SetLocalInt(oDoor, "IsInitialized", 1);
	}

	// IF OBJECT IS UNLOCKED, THEN EXIT
	if (GetLocked(oDoor) == FALSE) {
		FloatingTextStringOnCreature("The lock is already broken.", oPC, FALSE);
		return;
	}
	
	// APPLY BASE BASHING DAMAGE IF OBJECT IS PLOT
	if (iDmg < 1) { 
		iDmg = (GetHitDice(oPC) / 2) + d6() + GetAbilityModifier(ABILITY_STRENGTH, oPC);
		if (iDmg < 1) { iDmg = 1; }
		FloatingTextStringOnCreature("You damage the lock for " + IntToString(iDmg) + " points of damage.", oPC, FALSE);		
	}
			
	// CALCULATE DAMAGE TO DEATH RATIO
	iCurHP = GetLocalInt(oDoor, "CurHP");
	iCurHP = iCurHP - iDmg;
	if (iCurHP < 1) {
		SetLocked(oDoor, FALSE);
		FloatingTextStringOnCreature("You have broken the lock.", oPC, FALSE);
		AssignCommand(oPC, ClearAllActions(TRUE));
		iCurHP = iMaxHP;
	}

	// DO NOT LET THE CHEST GET DESTROYED
	SetLocalInt(oDoor, "CurHP", iCurHP);

	// DOORS MAKE NOISE WHEN BASHED, ATTRACTING MONSTERS
	AssignCommand(oDoor, ActionSpeakString("HELP",  TALKVOLUME_SILENT_TALK));
	
}