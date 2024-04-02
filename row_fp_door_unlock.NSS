// =============================================================
//
//    File: row_fp_door_unlock
//    Desc: Rowell's Fair Play Door - Unlock Event
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
	object oPC        = GetLastUnlocked();
	string sID        = GetPCPlayerName(oPC) + GetName(oPC) + "uFPD";
	string sText      = "";
	int    iReward    = GetSkillRank(SKILL_OPEN_LOCK , oPC);
	int	   iMinReward = 10;
	int    iMaxReward = 100;
			
	// CHECK IF DOOR IS INITIALIZED
	if (GetLocalInt(oDoor, "IsInitialized") != 1) {
		SetLocalInt(oDoor, "IsTrapped", GetIsTrapped(oDoor));
		SetLocalInt(oDoor, "IsLocked", 1);
		SetLocalInt(oDoor, "CurHP", GetMaxHitPoints(oDoor));
		SetLocalInt(oDoor, "IsInitialized", 1);
	}

	// GIVE A REWARD FOR UNLOCKING THE DOOR
	if (iReward > 0 && GetLocalInt(oDoor, sID) != 1) {
		iReward = ((GetLockUnlockDC(oDoor) - 10) - iReward) * 5;
		if (iReward > iMaxReward) { iReward = iMaxReward; }
		if (iReward < iMinReward) { iReward = iMinReward; }
		AssignCommand(oPC, GiveXPToCreature(oPC, iReward));
		sText = "You earned " + IntToString(iReward) + "xp for unlocking this door.";
		AssignCommand(oPC, FloatingTextStringOnCreature(sText, oPC, FALSE));
		SetLocalInt(oDoor, sID, 1);
	}
	
}