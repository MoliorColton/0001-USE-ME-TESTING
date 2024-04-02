/*

    Script:			This script is fired when a Banter Conversation trigger is entered.
					It will look up the conversation from the stored arrays and determine
					if the conversation should be fired off.  If so, it will then call
					the leg_banter_startconvo script.  That script could also be called
					from the quest plugin.
	Version:		1.1
	Plugin Version: 2.00
	Author:			Marshall Vyper

	Change Log:		1.0 - MV - Initial Version
					08/11/2015 - 1.1 MV - Plugins Version 2.0 - Added code for performing PC Data table consolidation
	
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
	object oPC = GetEnteringObject();
	
	if (GetIsPC(oPC))
	{
	
		// Get the Conversation ID
		string sConvoID = GetLocalString(oParent, "LEG_BANTER_ID");
		int iQuestTrigger = GetLocalInt(oParent, "LEG_BANTER_QuestConvo");
		int iOnceOnly = GetLocalInt(oParent, "LEG_BANTER_OnceOnly");

		// Find out if I am already active.  If my first NPC or Object exists, then
		// that is who I will use to track if I am active.  If my NPC/Object despawns,
		// then I can be deactivated.
		object oStartingObject = GetObjectByTag(LEG_COMMON_GetFirstArrayElement(GetModule(), sConvoID + "_tag"));
		if (GetIsObjectValid(oStartingObject))
		{
			int iIsActiveConvo = GetLocalInt(oStartingObject, "LEG_BANTER_IsActive");
			if (!iIsActiveConvo)
			{
				// Find out if the person entering has already heard it.
				if (!(iOnceOnly && GetLocalInt(oPC, "convoheard_" + sConvoID)))
				{
					string sTableID = LEG_COMMON_GetPC2Table(oPC);
					if (!(iOnceOnly && GetPersistentInt(oPC, "convoheard_" + sConvoID, sTableID)))
					{
						// We must play this conversation.  If we're a quest convo,
						// let the quest plugin do it because there are extra things
						// it will need to do.  Otherwise, let the banter plugin do it.
						SetLocalObject(oParent, "LEG_BANTER_ConvoStarter", oPC);
						AddScriptParameterString(sConvoID);
						AddScriptParameterObject(oPC);
						AddScriptParameterInt(0);
						if (iQuestTrigger)
						{
							ExecuteScriptEnhanced("leg_quest_eavesdrop", oParent);
						}
						else
						{
							ExecuteScriptEnhanced("leg_banter_startconvo", oParent);
						}	
					}
				}
			}
		}
	}
}