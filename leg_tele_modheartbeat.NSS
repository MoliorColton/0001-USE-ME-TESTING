/*

    Script:			This script is called by the Master Heartbeat script.  It is used only on instances and
					checks to see if there are any PC's in the module.  If a PC enters the module for the first time,
					the RESETONEMPTY var is set, then this goes into action, waiting for everyone to leave.  Once done,
					the module is restarted and the active flag in the DB is cleared.
	Version:		1.0
	Plugin Version: 1.92
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		10/08/2012 - 1.0 MV - Initial Release
					
	
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "nwnx_system"
#include "leg_tele_include"



// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	if (GetLocalInt(GetModule(), "LEG_TELE_INSTANCE"))
	{
		object oPC = GetFirstPC();
		if (GetIsObjectValid(oPC) == FALSE)
		{
			// No PC's in the mod, but has there been any since I loaded?
			if (GetLocalInt(GetModule(), "TELE_RESTARTONEMPTY"))
			{
				string sPortalID = GetLocalString(GetModule(), "LEG_TELE_SERVERID");
				int iMyInstance = GetLocalInt(GetModule(), "InstanceID");
				//SpeakString("My Instance: " + IntToString(iMyInstance), TALKVOLUME_SHOUT);
				SQLExecDirect("UPDATE `" + TELEPREFIX + "_instances" + "` SET `Restarting`='1' WHERE `PortalID` = '" + sPortalID + "' AND `InstanceNumber` = '" + IntToString(iMyInstance) + "'");
			
				// My Restart variable is set as a result of a PC entering in here.
				ResetServer();
			}
			else
			{
				// There are no PC's and I am a fresh load because I don't have the TELE_RESTARTONEMPTY var.  BUT, I may have
				// crashed.  If so, there may be an active flag in the DB.  Problem is, I don't know which one I am.
			}
		}
	}	
}