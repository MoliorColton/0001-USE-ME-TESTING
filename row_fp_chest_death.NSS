// =============================================================
//
//    File: row_fp_chest_death
//    Desc: Rowell's Fair Play Chest - Death Event
//  Author: Michael Marzilli
//    Site: http://www.engliton.org
//
// Created: Oct 02, 2006
// Updated: Oct 02, 2006
// Version: 1.0.0
//
// =============================================================

void main() {
	object oChest = OBJECT_SELF;
	object oNew;
	int    iIsTrapped = GetIsTrapped(oChest);		
	
	// CHEST IS BROKEN AND OPENS
	oNew = CopyObject(oChest, GetLocation(oChest));
	AssignCommand(oNew, ActionUnlockObject(oNew));
	if (iIsTrapped) { SetTrapDisabled(oNew); }
	
}