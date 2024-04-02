/*

    Script:			Called by the master item activated code, this script will fire
					when a player uses an item with the tag of "leg_secret_kit" and
					perform a skill check on any configured spawn points in the vicinity.
	Version:		1.1
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		11/19/2012 - 1.0 MV - Initial Release
					02/17/2013 - 1.1 MV - Removed Ioun stone effect when using detectives kit.
	
*/

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_spawn_include"



// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main(object oPC, object oKit)
{
	// Find out if the info plugin is active.
	int iInfoActive = GetLocalInt(GetModule(), "LEG_INFO_ACTIVE");

	// Get the Tag of the item.
	string sItemTag = GetTag(oKit);
	
	// If we are one of the legends secret detective's kits, then let's go!
	if (sItemTag == "leg_secret_kit" || sItemTag == "smalldetectiveskit")
	{	
		// Grab the nearest waypoint.
    	int iCount = 1;
	    object oSecretPoint = GetNearestObject(OBJECT_TYPE_WAYPOINT, oPC, iCount);
		
		// Look for nearby waypoints...
		int iSkillCheck = GetLocalInt(oSecretPoint, "LEG_SPAWN_SkillCheck");
		int iType = GetLocalInt(oSecretPoint, "LEG_SPAWN_SkillTool");
		while (GetIsObjectValid(oSecretPoint) && iCount <= 25 && (iType == FALSE && iSkillCheck == FALSE))
		{
			iCount++;
			oSecretPoint = GetNearestObject(OBJECT_TYPE_WAYPOINT, oPC, iCount);
			iSkillCheck = GetLocalInt(oSecretPoint, "LEG_SPAWN_SkillCheck");
			iType = GetLocalInt(oSecretPoint, "LEG_SPAWN_SkillTool");			
		}

		// Message the PC accordingly.
		if (iInfoActive)
			LEG_COMMON_ProgBar(oPC, TOOLUSETIME, "Searching", -1, ANIMATION_LOOPING_KNEELIDLE, 0, 0, "kneeltalk", 1, TOOLUSETIME, "", 0, 0, oPC);
		else
			SendMessageToPC(oPC, "Searching...");
				
		// So we've searched for some waypoints.  Did we catch a secret one?
		if(GetIsObjectValid(oSecretPoint) && GetDistanceBetween(oPC, oSecretPoint) <= 6.0)
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
				else
				{
					if (iInfoActive)
						DelayCommand(IntToFloat(TOOLUSETIME), LEG_COMMON_DisplayInfoBox(oPC, "You Did Not Find Anything."));
					else
						DelayCommand(IntToFloat(TOOLUSETIME), SendMessageToPC(oPC, "You do not find anything."));
				}
			}
			else
			{
				if (iInfoActive)
					DelayCommand(IntToFloat(TOOLUSETIME), LEG_COMMON_DisplayInfoBox(oPC, "You Did Not Find Anything."));
				else
					DelayCommand(IntToFloat(TOOLUSETIME), SendMessageToPC(oPC, "You do not find anything."));
			}
		}
		else
		{
			if (iInfoActive)
				DelayCommand(IntToFloat(TOOLUSETIME), LEG_COMMON_DisplayInfoBox(oPC, "You Did Not Find Anything."));
			else
				DelayCommand(IntToFloat(TOOLUSETIME), SendMessageToPC(oPC, "You do not find anything."));
		}
	}
}