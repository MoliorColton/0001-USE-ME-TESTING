// =============================================================
//
//    File: row_fp_chest_close
//    Desc: Rowell's Fair Play Chest - Close Event
//  Author: Michael Marzilli
//    Site: http://www.engliton.org
//
// Created: Oct 02, 2006
// Updated: Oct 02, 2006
// Version: 1.0.0
//
// =============================================================

void main() {
	object oChest   = OBJECT_SELF;
	int    iLocked  = GetLocalInt(oChest, "IsLocked");
	int	   iTrapped = GetLocalInt(oChest, "IsTrapped");


	// LOCK THE CHEST (if NECESSARY)
	if (iLocked) { DelayCommand(30.1, AssignCommand(oChest, ActionLockObject(oChest))); }

	// RESET THE CHEST LOCK'S HIT POINTS
	SetLocalInt(oChest, "CurHP", GetMaxHitPoints(oChest));

	// RESET THE TRAP
	SetTrapActive(oChest, iTrapped);
	
}