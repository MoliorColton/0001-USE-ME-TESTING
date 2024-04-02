// =============================================================
//
//    File: row_fp_door_death
//    Desc: Rowell's Fair Play Door - Death Event
//  Author: Michael Marzilli
//    Site: http://www.engliton.org
//
// Created: Oct 02, 2006
// Updated: Oct 02, 2006
// Version: 1.0.0
//
// =============================================================

void main() {
	object oDoor = OBJECT_SELF;
	object oLink;
	string sLink;
		
	// DOOR IS BROKEN AND OPENS
	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oDoor)), oDoor);
	AssignCommand(oDoor, ActionUnlockObject(oDoor));
	AssignCommand(oDoor, ActionOpenDoor(oDoor));
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectHealOnZeroHP(oDoor, 10), oDoor);
	
}
