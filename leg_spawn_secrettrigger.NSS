/*

    Script:			Placed on the On Enter event of a trigger.  This will perform a skill
					check on nearby spawn points that are configured to spawn based on
					triggers.
	Version:		1.0
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		11/19/2012 - 1.0 MV - Initial Release
	
*/

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_spawn_include"

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	// Find out if the info plugin is active.
	int iInfoActive = GetLocalInt(GetModule(), "LEG_INFO_ACTIVE");
	
	// If the spawn plugin is not enabled, don't do anything.
	if (GetLocalInt(GetModule(), "LEG_SPAWN_ACTIVE"))
	{
		// Get the player entering our trigger.
		object oPC = GetEnteringObject();
		
		// If this is invalid, try a mob killer...
		if (!GetIsObjectValid(oPC))
			oPC = GetLastUsedBy();
			
		// If this is invalid, get the last user
		if (!GetIsObjectValid(oPC))
			oPC = GetLastKiller();
		
		// If we are still invalid, just exit.
		if (!GetIsObjectValid(oPC))
			return;
	
		if (GetIsPC(oPC))
		{
			// Grab the nearest waypoint.
	    	int iCount = 1;
		    object oSecretPoint = GetNearestObject(OBJECT_TYPE_WAYPOINT, oPC, iCount);
			
			// Look for nearby waypoints...
			int iSkillCheck = GetLocalInt(oSecretPoint, "LEG_SPAWN_SkillCheck");
			int iType = GetLocalInt(oSecretPoint, "LEG_SPAWN_SkillTrigger");
			while (GetIsObjectValid(oSecretPoint) && !iSkillCheck && iCount <= 10 && !iType)
			{
				iCount++;
				oSecretPoint = GetNearestObject(OBJECT_TYPE_WAYPOINT, oPC, iCount);
			}

			// So we've searched for some waypoints.  Did we catch a secret one?
			if(GetIsObjectValid(oSecretPoint) && GetDistanceBetween(oPC, oSecretPoint) <= 15.0)
			{
				// We got one!  Could be a trap trigger, could be a secret door.. who knows!
				int iDC = GetLocalInt(oSecretPoint, "LEG_SPAWN_SkillCheckDC");
				int iAttempts = GetLocalInt(oSecretPoint, "LEG_SPAWN_SkillCheckOnce");
				if (!iAttempts || GetLocalInt(oPC, "SECRET_" + GetTag(oSecretPoint)) == FALSE)
				{
					if (GetIsSkillSuccessful(oPC, iSkillCheck, iDC, FALSE))
					{
						DelayCommand(IntToFloat(TOOLUSETIME), LEG_SPAWN_FindSpawn(oPC, oSecretPoint, iInfoActive));
					}
				}
			}
		}
	}
}