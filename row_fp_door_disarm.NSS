// =============================================================
//
//    File: row_fp_door_disarm
//    Desc: Rowell's Fair Play Door - Disarm Trap Event
//  Author: Michael Marzilli
//    Site: http://www.engliton.org
//
// Created: Oct 02, 2006
// Updated: Oct 02, 2006
// Version: 1.0.0
//
// =============================================================

void main() {
	object oDoor      = OBJECT_SELF;
	object oPC        = GetLastDisarmed();
	string sID        = GetPCPlayerName(oPC) + GetName(oPC) + "dFPD";
	string sText      = "";
	int    iReward    = GetSkillRank(SKILL_DISABLE_TRAP , oPC);
	int	   iMinReward = 10;
	int    iMaxReward = 100;
			
	// CHECK IF DOOR IS INITIALIZED
	if (GetLocalInt(oDoor, "IsInitialized") != 1) {
		SetLocalInt(oDoor, "IsTrapped", 1);
		SetLocalInt(oDoor, "IsLocked", GetLocked(oDoor));
		SetLocalInt(oDoor, "CurHP", GetMaxHitPoints(oDoor));
		SetLocalInt(oDoor, "IsInitialized", 1);
	}

		// GIVE A REWARD FOR DISARMING THE TRAP
	if (iReward > 0 && GetLocalInt(oDoor, sID) != 1) {
		iReward = ((GetTrapDisarmDC(oDoor) - 10) - iReward) * 5;
		if (iReward > iMaxReward) { iReward = iMaxReward; }
		if (iReward < iMinReward) { iReward = iMinReward; }
		AssignCommand(oPC, GiveXPToCreature(oPC, iReward));
		sText = "You earned " + IntToString(iReward) + "xp for disarming the trap.";
		AssignCommand(oPC, FloatingTextStringOnCreature(sText, oPC, FALSE));
		SetLocalInt(oDoor, sID, 1);
	}
	
}