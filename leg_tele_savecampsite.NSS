/*

    Script:			Called from a variety of places, this script actually performs the save function for
					the tele system which includes storing the PC's location in the database.
	Version:		1.1
	Plugin Version: 1.92
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		10/08/2012 - 1.1 MV - Initial Release
	
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_tele_include"



// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	if (GetLocalInt(GetModule(), "LEG_TELE_SAVECAMPSITES"))
	{
		if (!GetLocalInt(GetArea(OBJECT_SELF), "LEG_TELE_NOSAVES"))
		{
			// Save Area and the World we are in.
			string sServerID = GetLocalString(GetModule(), "LEG_TELE_SERVERID");
			SetPersistentLocation(OBJECT_SELF, "CampLocation", GetLocation(OBJECT_SELF), 0, TELEPREFIX + "_campsite");
			if (sServerID != "")
				SetPersistentString(OBJECT_SELF, "ServerLocation", sServerID, 0, TELEPREFIX + "_campsite");
		}
	}
	
}