/*

    Script:			This script starts a conversation between multiple NPC or Objects
					using the initialized arrays.  It can be called from the Quest
					plugin for directly from the banter plugin trigger.
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
void main(string sConvoID, object oPC, int iForceStart)
{
	object oModule = GetModule();
	object oParent = OBJECT_SELF;
	int iDelayTimer = GetLocalInt(oParent, "LEG_BANTER_Delay");
	int iLoop = GetLocalInt(oParent, "LEG_BANTER_Loop");
	int iRandomStart = GetLocalInt(oParent, "LEG_BANTER_RandomStart");
	int iOnceOnly = GetLocalInt(oParent, "LEG_BANTER_OnceOnly");

	object oStartingObject = GetObjectByTag(LEG_COMMON_GetFirstArrayElement(oModule, sConvoID + "_tag"));
	if (GetIsObjectValid(oStartingObject))
	{
		// Set Active
		SetLocalInt(oStartingObject, "LEG_BANTER_IsActive", 1);
	
		// Get the total number of convo nodes
		int iTotalConvoNodes = LEG_COMMON_GetArrayElementCount(oModule, sConvoID + "_tag");
		int iStartLocation = 1, iStartTimeOffset = 0;
		
		// Find out if we should start randomly.
		if (iRandomStart && !iForceStart)
		{
			iStartLocation = Random(iTotalConvoNodes) + 1;
			iStartTimeOffset = StringToInt(LEG_COMMON_GetArrayElement(oModule, sConvoID + "_timing", iStartLocation));
		}
		
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
					
		// Now we are at the end of the conversation assignments.  Find out if we should loop.  If not, set active false.
		if (iLoop)
		{
			// Never use a LOOP with a quest type.  Quest Type's should only ever fire once.
			DelayCommand(IntToFloat(iDelay - iStartTimeOffset + GetLocalInt(oParent, "LEG_BANTER_Delay")), ExecuteScript("leg_banter_convoloop", oParent));
		}
		else
		{
			DelayCommand(IntToFloat(iDelay - iStartTimeOffset), SetLocalInt(oStartingObject, "LEG_BANTER_IsActive", 0));
			if (iOnceOnly)
			{
				// Update for all PC's standing in the trigger at time of completion.
				DelayCommand(IntToFloat(iDelay - iStartTimeOffset + GetLocalInt(oParent, "LEG_BANTER_Delay")), ExecuteScript("leg_banter_convoend", oParent));	
			}
		}		
	}
}