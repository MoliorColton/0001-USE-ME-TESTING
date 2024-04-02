/*

    Script:			This script is called from the leg_banter_startconvo script and is used
					when a conversation iteration ends and is set to Once Only.  It will
					update anyone within 10m of the trigger area.  NOTE: Is important to
					know that the 10m is from the start/end point of where the trigger
					is drawn.  
	Version:		1.2
	Plugin Version: 2.00
	Author:			Marshall Vyper

	Change Log:		1.0 - MV - Initial Version
					08/11/2015 - 1.1 MV - Plugins Version 2.0 - Added code for performing PC Data table consolidation
					09/03/2015 - 1.2 MV - Ensure player is commandable based on new Stop Player Option

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
	string sConvoID = GetLocalString(oParent, "LEG_BANTER_ID");
	string sTableID;

	object oPC = GetFirstObjectInShape(SHAPE_SPHERE, 10.0, GetLocation(oParent), FALSE, OBJECT_TYPE_CREATURE);
	
	// If we're supposed to set a flag at the end of this convo.
	int iSetSEFlag = GetLocalInt(OBJECT_SELF, "LEG_BANTER_SetSEFlag");
	if (GetLocalInt(GetModule(), "LEG_QUEST_ACTIVE") && iSetSEFlag > 0)
	{
		AddScriptParameterInt(iSetSEFlag);
		ExecuteScriptEnhanced("leg_quest_se_setflag", OBJECT_SELF);
	}	
	
	while (GetIsObjectValid(oPC))
	{
		if (GetIsPC(oPC))
		{
			sTableID = LEG_COMMON_GetPC2Table(oPC);
			SetLocalInt(oPC, "convoheard_" + sConvoID, 1);
			SetPersistentInt(oPC, "convoheard_" + sConvoID, 1, 0, sTableID);
			
			// Ensure oPC is commandable.
			SetCommandable(TRUE, oPC);
		}
		oPC = GetNextObjectInShape(SHAPE_SPHERE, 10.0, GetLocation(oParent), FALSE, OBJECT_TYPE_CREATURE);			
	}
}