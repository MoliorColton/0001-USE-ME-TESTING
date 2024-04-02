/*

    Script:			This script is called on Banter Trigger conversations and is only used when the 
					banter plugin is active in the module.
	Version:		1.0
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		10/02/2011 - 1.1 MV - Initial Release
	
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_quest_include"


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main(string sConvoID, object oPC, int iForceStart)
{
	object oModule = GetModule();
	object oParent = OBJECT_SELF;
	object oStartingObject = GetObjectByTag(LEG_COMMON_GetFirstArrayElement(oModule, sConvoID + "_tag"));
	int iPCNowHas = LEG_QUEST_PCQualify(oPC, OBJECT_SELF);
	if (iPCNowHas > 0)
	{
		if (GetIsObjectValid(oStartingObject))
		{
			// If the convo is already active, then we're just participating as someone who entered the trigger but ALSO needs the quest.
			if (!GetLocalInt(oStartingObject, "LEG_BANTER_IsActive"))
			{
				// Set Active
				SetLocalInt(oStartingObject, "LEG_BANTER_IsActive", 1);
			
				// Get the total number of convo nodes
				int iTotalConvoNodes = LEG_COMMON_GetArrayElementCount(oModule, sConvoID + "_tag");
				int iStartLocation = 1, iStartTimeOffset = 0;
				
				// Now loop through the conversations and begin.
				object oActor;
				int iDelay, iIndex;
				string sLine;
				for (iIndex = iStartLocation; iIndex <= iTotalConvoNodes; iIndex++)
				{
					oActor = GetObjectByTag(LEG_COMMON_GetArrayElement(oModule, sConvoID + "_tag", iIndex));
					iDelay = StringToInt(LEG_COMMON_GetArrayElement(oModule, sConvoID + "_timing", iIndex));
					sLine = LEG_COMMON_GetArrayElement(oModule, sConvoID + "_line", iIndex);
					DelayCommand(IntToFloat(iDelay - iStartTimeOffset), AssignCommand(oActor, ActionSpeakString(sLine)));
				}
				
				// If PC should not be commandable during the conversation
				if (GetLocalInt(oParent, "LEG_BANTER_NotCommandable"))
				{
					SetCommandable(FALSE, oPC);	
				}
				DelayCommand(IntToFloat(iDelay - iStartTimeOffset), SetLocalInt(oStartingObject, "LEG_BANTER_IsActive", 0));
				DelayCommand(IntToFloat(iDelay - iStartTimeOffset + GetLocalInt(oParent, "LEG_BANTER_Delay")), ExecuteScript("leg_quest_eavesdropend", oParent));	
		
				// Extra Commandable just in case.
				DelayCommand(IntToFloat(iDelay - iStartTimeOffset + GetLocalInt(oParent, "LEG_BANTER_Delay")), SetCommandable(TRUE, oPC));
			}
			else
			{
				// I'm on the quest too but someone else already started it so I shall wait my turn.
				if (GetLocalInt(oParent, "LEG_BANTER_NotCommandable"))
				{
					SetCommandable(FALSE, oPC);	
				}
			}
		}
	}
	// Players who triggered this quest convo but do NOT have the quest.  If it's active, someone else has the quest and are running through so we wait.
	else
	{
		if(GetLocalInt(oStartingObject, "LEG_BANTER_IsActive"))
		{
			// Quest Convo is active by someone else.  I don't need this quest but I'm not allowed to be a loose cannon either.
			if (GetLocalInt(oParent, "LEG_BANTER_NotCommandable"))
			{
				SetCommandable(FALSE, oPC);	
			}
		}
	}
}