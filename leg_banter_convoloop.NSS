/*

    Script:			This script is called from the leg_banter_startconvo script and is used
					to loop conversations if they are configured to do so.  
	Version:		1.0
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		None

	Change Log:		1.0 - MV - Initial Version
	
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
	object oParent = OBJECT_SELF;
	object oPC = GetLocalObject(oParent, "LEG_BANTER_ConvoStarter");
	string sConvoID = GetLocalString(oParent, "LEG_BANTER_ID");
	
	AddScriptParameterString(sConvoID);
	AddScriptParameterObject(oPC);
	AddScriptParameterInt(1);
	ExecuteScriptEnhanced("leg_banter_startconvo", oParent);
}