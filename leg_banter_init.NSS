/*

    Script:			The Initialization script for the BANTER system.  This script needs to be executed during module
					initialization.  That may be during load, when the first player enters or anywhere the end user
					chooses as long as it is run only during that time.  It will obtain all BANTER messages from the
					database during load and store them on local variables so when used during runtime, database hits
					are removed increasing performance.
	Version:		1.1
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		None

	Change Log:		1.0 - MV - Initial Version
					1.1 - 09/25/2012 MV - Added support for Conversations
					1.2 - 10/27/2012 MV - Fixed bug with respect to ordering the SQL when awarding quest completion
	
*/

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_banter_include"




// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	// Initialize some variables
	string sID = "";
	string sOldID = "";
	string sOneliner = "";
	int iCounter = 0;
	
	// Execute the SQL database SELECT.
	SQLExecDirect("SELECT * FROM `" + LEG_BANTER_TABLEPREFIX + "_oneliners` ORDER BY `BanterID`");
	while (SQLFetch())
	{
		iCounter++;
		sOldID = sID;
		sID = SQLGetData(1);
		sOneliner = SQLGetData(2);

		// As this one table will contain all messages for all ID's, we
		// reset the counter when the ID changes.  As there is a one to
		// many relationship between ID's and messages.
		if (sID != sOldID)
			iCounter = 1;

		// Store the message in a variable prefixing the variable name with the ID.
		// Store how many messages are associated with the ID.			
		SetLocalString(GetModule(), sID + IntToString(iCounter), sOneliner);
		SetLocalInt(GetModule(), sID + "_Count", iCounter);
	}
	
	// Create arrays of conversation nodes.
	string sConvoID = "", sTimingID, sTag = "", sLine = "";
	object oModule = GetModule();
	SQLExecDirect("SELECT * FROM `" + LEG_BANTER_TABLEPREFIX + "_convos` ORDER BY `ConvoID`, CAST(TimingID AS SIGNED) ASC;");
	while (SQLFetch())
	{
		sConvoID = SQLGetData(1);
		sTimingID = SQLGetData(2);
		sTag = SQLGetData(3);
		sLine = SQLGetData(4);
		
		LEG_COMMON_AddArrayElement(oModule, sConvoID + "_timing", sTimingID);
		LEG_COMMON_AddArrayElement(oModule, sConvoID + "_tag", sTag);
		LEG_COMMON_AddArrayElement(oModule, sConvoID + "_line", sLine);
	}
}