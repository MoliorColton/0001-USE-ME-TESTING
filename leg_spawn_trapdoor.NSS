/*

    Script:			This is OnUsed script for animated secret trap doors.  It's typically used in conjunction with the
					teleport plugin.  The spawn plugin owns this because secret trap doors belong to Spawn.
	Version:		1.0
	Plugin Version: 2.00
	Author:			Marshall Vyper
	
	Change Log:		08/20/2015 - 1.0 MV - Initial Release
	
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	int nActive = GetLocalInt(OBJECT_SELF,"SPAWN_DoorState");
	if (!nActive)
	{
		PlaySound("as_dr_secretdoor2_open");		
		ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);
		SetLocalInt(OBJECT_SELF,"SPAWN_DoorState",!nActive);
	}
	else
	{
		// Close the door after the teleport?  Nah.  Annoying for other party members.
		//ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE);
		
		// If teleport plugin is active, we should run the appropriate script.
		if (GetLocalInt(GetModule(), "LEG_TELE_ACTIVE"))
		{
			
			object oTeleporter;
			object oParentSpawnPoint = GetLocalObject(OBJECT_SELF, "SPAWN_Parent");
			if (GetIsObjectValid(oParentSpawnPoint))
			{
				oTeleporter = oParentSpawnPoint;
			}
			else
			{
				oTeleporter = OBJECT_SELF;
			}		
			string sScript = GetLocalString(oTeleporter, "LEG_TELE_Script");	
			if (sScript != "")
				ExecuteScript(sScript, OBJECT_SELF);
		}
	}
	
	// Close the door after the teleport?  Nah.  Annoying for other party members.
	//SetLocalInt(OBJECT_SELF,"SPAWN_DoorState",!nActive);
}