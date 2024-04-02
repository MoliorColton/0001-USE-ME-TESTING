//-----------------------------------------------------------------------
// <copyright file="gui_leg_quest_continuequest.nss" company="Molior RS">
// Copyright (c) Molior RS. All rights reserved.
// </copyright>
// <revision> 1 </revision>
// <lasteditedby>Austin Jensen</lasteditedby>
//-----------------------------------------------------------------------
/*

    Script:			When the Journal is up and the PC presses the Collections button.  This passes
					the proper variables to the journal switching script to load the data for the
					next page.
	Version:		1.1
	Plugin Version: 2.00
	Author:			Marshall Vyper
	
	Change Log:		06/23/2011 - 1.00 MV - Initial Release
					12/27/2011 - 1.01 MV - Fixed journal item bug not displaying correctly.
					08/11/2015 - 1.1 MV - Plugins Version 2.0 - Added code for performing PC Data table consolidation					
	
*/
// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_quest_include"


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	// Call the Journal Switch script and load its GUI data.
	string sJournalScreen;
	if (JOURNAL_OVERRIDE == 0)
		sJournalScreen = "LEG_SCREEN_JOURNAL";
	else
		sJournalScreen = "SCREEN_JOURNAL";
	AddScriptParameterString("3");
	AddScriptParameterString("Collections");
	AddScriptParameterString(sJournalScreen);
	ExecuteScriptEnhanced("leg_quest_journalswitch", OBJECT_SELF);
}