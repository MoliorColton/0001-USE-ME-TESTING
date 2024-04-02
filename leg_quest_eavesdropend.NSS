/*

    Script:			This script is called from the leg_quest_eavesdrop script and is used
					when a conversation iteration ends that was triggered by a questor.  It will
					update anyone within 20m of the trigger area that is also in need of this eavesdrop.
					NOTE: Is important to know that the 20m is from the start/end point of where the trigger
					is drawn.  
	Version:		1.1
	Plugin Version: 2.00
	Author:			Marshall Vyper

	Change Log:		1.0 - 10/02/2012 MV - Initial Version
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
	object oParent = OBJECT_SELF;
	string sConvoID = GetLocalString(oParent, "LEG_BANTER_ID");
	string sTriggerText = GetName(oParent);
	string sQuestID = GetLocalString(oParent, "LEG_QUEST_QuestID_1");
	string sTableID;
	int iObjective = GetLocalInt(oParent, "LEG_QUEST_IsObjective_1");
	int iNPCObjective = GetLocalInt(oParent, "LEG_QUEST_ObjectiveFor_1");
	int iMyFlagID = GetLocalInt(OBJECT_SELF, "LEG_QUEST_SE_MyFlag_1");
	int iPCNowHas = -1;
	object oIcon, oNextNPC;
	float fTimer = 0.1;
	
	object oPC = GetFirstObjectInShape(SHAPE_SPHERE, 20.0, GetLocation(oParent), FALSE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oPC))
	{
		if (GetIsPC(oPC))
		{
			iPCNowHas = LEG_QUEST_PCQualify(oPC, oParent);
			if (iPCNowHas > 0)
			{
				// Get this PC's table
				sTableID = LEG_COMMON_GetPC2Table(oPC);

				// Update this PC
				LEG_COMMON_DisplayInfoBox(oPC, sTriggerText);
				
				// Save and give credit.
				SetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ" + IntToString(iObjective), 1);
				SetPersistentInt(oPC, "QuestID_" + sQuestID + "_OBJ" + IntToString(iObjective), 1, 0, sTableID);
				
				// Any special OBJ Rules?
				LEG_QUEST_ApplyObjectiveRules(oPC, sQuestID, iNPCObjective, iObjective, iMyFlagID);
				
				// Play a pretty sound.
				PlaySound("gui_journaladd");
			}
			
			// Even if you are not on the quest, enure you are commandable now that it's done.
			SetCommandable(TRUE, oPC);
			
		}
		oPC = GetNextObjectInShape(SHAPE_SPHERE, 10.0, GetLocation(oParent), FALSE, OBJECT_TYPE_CREATURE);			
	}

	// If we're supposed to set a flag at the end of this convo.
	int iSetSEFlag = GetLocalInt(OBJECT_SELF, "LEG_BANTER_SetSEFlag");
	if (GetLocalInt(GetModule(), "LEG_QUEST_ACTIVE") && iSetSEFlag > 0)
	{
		AddScriptParameterInt(iSetSEFlag);
		ExecuteScriptEnhanced("leg_quest_se_setflag", OBJECT_SELF);
	}	
}