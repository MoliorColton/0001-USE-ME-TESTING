//-----------------------------------------------------------------------
// <copyright file="gui_tb_quest_journalpop.nss" company="Molior RS">
// Copyright (c) Molior RS. All rights reserved.
// </copyright>
// <revision> 1 </revision>
// <lasteditedby>Austin Jensen</lasteditedby>
//-----------------------------------------------------------------------
/*

    Script:			When the Journal is up and the PC presses the Quest button.  This passes
					the proper variables to the journal switching script to load the data for the
					next page.
	Version:		1.01
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		06/23/2011 - 1.00 MV - Initial Release
					12/27/2011 - 1.01 MV - Fixed journal item bug not displaying correctly.
	
*/
// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
//#include "leg_quest_include"


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main(string val)
{
	//bugfix for the mistake called nwn2 UI events. local:1 on scene create event somehow fixing it
	//SendMessageToPC(OBJECT_SELF, "0: "+val);//IntToString(xval)
	if (val=="0") {return;}
	// Call the Journal Switch script and load its GUI data.
	string sJournalScreen = "SCREEN_JOURNAL";
	AddScriptParameterString("0");
	AddScriptParameterString("Quests");
	AddScriptParameterString(sJournalScreen);
	ExecuteScriptEnhanced("tb_journalswitch", OBJECT_SELF);
	AddScriptParameterString(IntToString(GetLocalInt(OBJECT_SELF, "qSelected")));
	ExecuteScriptEnhanced("gui_tb_quest_journaldetail", OBJECT_SELF);
}