/*
    Script:			This is the MASTER module on death script for when a player dies.  It will call the REST
					system for death penalties as well as optionally store the PC's state.
	Version:		1.00
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		None
	
	Change Log:		07/22/2011 - 1.00 MV - Initial Release
*/

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	// Who died?
	object oPC = GetLastPlayerDied();
	object oMODULE = GetModule();

	//SpeakString("Firing World Death", TALKVOLUME_SHOUT);
	// If the Rest Plugin is active, then do this....
	if (GetLocalInt(oMODULE, "LEG_WORLD_ACTIVE"))
	{
		// Fire the death script
		//SpeakString("Firing World On PC Death", TALKVOLUME_SHOUT);
		ExecuteScript("leg_world_onpcdeath", oPC);
		
		// If the Legends Resting Plugin is being used and the Death Systems are active in it.
		ExecuteScript("leg_world_savepc", oPC);
		
		// If the plugin is configured to save locations in this module.
		if (GetLocalInt(oMODULE, "LEG_TELE_ACTIVE")) ExecuteScript("leg_tele_savecampsite", oPC);
	}
}