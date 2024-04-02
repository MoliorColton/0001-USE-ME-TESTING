/*

    Script:			This is the TELE on load script.  It is primarily used for dungeon instances but
					can be used for other things if we ever come up with something to use for it.
	Version:		1.1
	Plugin Version: 2.00
	Author:			Marshall Vyper
	
	Change Log:		10/08/2012 - 1.0 MV - Initial Release
					08/11/2015 - 1.1 MV - Plugins Version 2.0 - Added code for performing PC Data table consolidation					
	

*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_tele_include"
#include "nwnx_spawn"


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	if (GetLocalInt(GetModule(), "LEG_TELE_INSTANCE"))
	{
		string sPortalID = GetLocalString(GetModule(), "LEG_TELE_SERVERID");
		SQLExecDirect("UPDATE `" + TELEPREFIX + "_instances" + "` SET `Active`='0', `Restarting`='0' WHERE `PortalID` = '" + sPortalID + "' AND `Restarting` = '1'");
	
		// Just in case we crashed...
		SQLExecDirect("SELECT * FROM `" + TELEPREFIX + "_portals" + "` WHERE `PortalID` = '" + sPortalID + "'");
		SQLFetch();
		
		string sPort = SpawnEnvironment("PORT");
		string sDBBasePort = SQLGetData(3);
		string sInstanceID = IntToString(StringToInt(sPort) - StringToInt(sDBBasePort));
		SQLExecDirect("UPDATE `" + TELEPREFIX + "_instances"+ "` SET `Active`='0', `Restarting`='0' WHERE `PortalID` = '" + sPortalID + "' AND `InstanceNumber` = '" + sInstanceID + "'");
	}
}