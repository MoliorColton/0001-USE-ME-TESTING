// =============================================================
//
//    File: row_fp_door_hb
//    Desc: Rowell's Fair Play Door - Heart Beat Event
//  Author: Michael Marzilli
//    Site: http://www.engliton.org
//
// Created: Dec 21, 2006
// Updated: Dec 21, 2006
// Version: 1.0.0
//
// =============================================================

void main() {
	object oPC;
	object oDoor     = OBJECT_SELF;
	int    bFound    = FALSE;
	float  fDistance = 10.0;
	
	// CHECK IF DOOR IS INITIALIZED
	if (GetLocalInt(oDoor, "IsInitialized") != 1) {
		SetLocalInt(oDoor, "IsTrapped", GetIsTrapped(oDoor));
		SetLocalInt(oDoor, "IsLocked", GetLocked(oDoor));
		SetLocalInt(oDoor, "CurHP", GetMaxHitPoints(oDoor));
		SetLocalInt(oDoor, "IsInitialized", 1);
	}

	// IF DOOR_STYLE = 1, THEN CHECK IF ANY PC'S ARE WITHIN 10ft OF THE DOOR
	// IF NO PC'S ARE AROUND THE DOOR, CLOSE IT
	if (GetLocalInt(oDoor, "DOOR_STYLE") == 1 && GetIsOpen(oDoor)) {
		oPC = GetFirstObjectInShape(SHAPE_SPHERE, fDistance, GetLocation(oDoor), TRUE, OBJECT_TYPE_CREATURE);
		while (oPC != OBJECT_INVALID && bFound ==FALSE) {
			if (GetIsPC(oPC))
				bFound = TRUE;
			oPC = GetNextObjectInShape(SHAPE_SPHERE, fDistance, GetLocation(oDoor), TRUE, OBJECT_TYPE_CREATURE);	
		}
		
		if (bFound == FALSE)
			DelayCommand(30.0, AssignCommand(oDoor, ActionCloseDoor(oDoor)));			
	}
		
	
}