/*

    Script:			This script is only EVER called by other scripts with two lines of passed text.
					These lines are announced by all Town Criers unless the sCrierPostTag is 
					configured which will apply the message to only that crier.  It will take each
					line and inject it into the appropriate queues waiting for the Crier to speak
					them.
	Version:		1.1
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		12/21/2010 - 1.00 MV - Initial Release
					05/11/2015 - 1.1 MV - Added intelligence to skip adding crier messages if crier post doesn't exist.
*/

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_info_include"


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main(string sText1, string sText2, string sCrierPostTag)
{
	// Define our post
	object oCrierPost;
	
	// Find out if we are supposed to inject a message into all criers
	// or just a specific one.
	if (sCrierPostTag != "")
	{
		// Looks like we are injecting into a specific crier
		oCrierPost = GetObjectByTag(sCrierPostTag);
		LEG_COMMON_AddArrayElement(oCrierPost, "LEG_CRIER_LINE1", sText1);
		LEG_COMMON_AddArrayElement(oCrierPost, "LEG_CRIER_LINE2", sText2);
	}
	else
	{
		// Figure out where all the criers are.
		SQLExecDirect("SELECT * FROM `" + INFOPREFIX + "criers`");
		while(SQLFetch())
		{
			sCrierPostTag = SQLGetData(1);
			oCrierPost = GetObjectByTag(sCrierPostTag);
			if (GetIsObjectValid(oCrierPost))
			{
				LEG_COMMON_AddArrayElement(oCrierPost, "LEG_CRIER_LINE1", sText1);
				LEG_COMMON_AddArrayElement(oCrierPost, "LEG_CRIER_LINE2", sText2);
			}
		}
	}
}