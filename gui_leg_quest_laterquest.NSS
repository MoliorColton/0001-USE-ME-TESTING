//-----------------------------------------------------------------------
// <copyright file="gui_leg_quest_laterquest.nss" company="Molior RS">
// Copyright (c) Molior RS. All rights reserved.
// </copyright>
// <revision> 1 </revision>
// <lasteditedby>Austin Jensen</lasteditedby>
//-----------------------------------------------------------------------
/*

    Script:			Called when the PC clicks Later on a quest.  This is normally ok and would not
					require a special script however it can happen when NPC1 asks you to speak
					with NPC2 and THEN you click Later on the finish.  The "OpenQuest" script can
					advance your position in the quest even though you plan to hit "Later".  So 
					we need to ensure you are reverted back if that happens.
	Version:		1.3
	Plugin Version: 2.00
	Author:			Marshall Vyper
	
	Change Log:		10/10/2012 - 1.00 MV - Initial Release
					08/11/2015 - 1.3 MV - Plugins Version 2.0 - Added code for performing PC Data table consolidation					
	
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_quest_include"



// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main(int iQuestID, int iNPC, int iObj1, int iObj2, int iObj3, int iObj4, int iObj5, int iAdvanceNPC, int iRewardChoice, int iRewards, int iQuestType)
{
	// Get the quest finisher.
	object oPC = OBJECT_SELF;
	object oNPC = GetLocalObject(oPC, "QNPC");
	string sQuestID = IntToString(iQuestID);
	string sTableID = LEG_COMMON_GetPC2Table(oPC);
	
	// If a reward has been chosen then close the gui.
	CloseGUIScreen(oPC, "leg_quest_finish");
	
	// Player hit later.  Sigh.  If the NPC finisher had a requirement of a timer running, this messes that up.  So we have
	// to put in this bypass.
	SetPersistentInt(oPC, "QuestID_" + sQuestID + "_TIMERBYPASS" + IntToString(iNPC), 1, 0, sTableID);
	
	// Did we have a previous NPC that we should be going back to?
	int iPreviousNPC = GetLocalInt(oPC, "QUEST_PreviousNPC");
	
	if (iPreviousNPC)
	{
		// Yes, we need to revert back to a previous NPC in the steps.
		int iPlayerStep = iPreviousNPC;
		SetLocalInt(oPC, "QuestID_" + sQuestID + "_NPC", iPlayerStep);
		SetPersistentInt(oPC, "QuestID_" + sQuestID + "_NPC", iPlayerStep, 0, sTableID);
		LEG_QUEST_CompleteObjectives(oPC, sQuestID, iPlayerStep, 1, 1);
	}
	
	// Refresh any icons if we are using that ability.
	if (GetIsObjectValid(oNPC))
	{
		// Time to refresh OTHER NPC quest Icons that are nearby after accepting this quest.
		if (LEG_QUEST_ICONS)
		{
			object oIcon;
			object oTrap = GetNearestTrapToObject(oNPC, FALSE);
			SetTrapDisabled(oTrap);			
			float fTimer = 0.1;
			object oNextNPC = GetFirstObjectInShape(SHAPE_SPHERE, StringToFloat(ICONREFRESHRANGE), GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_CREATURE);
			while (GetIsObjectValid(oNextNPC))
			{
				// This section is there's another PC in the vicinity.  If so, I best reset my question
				// icon for them.
				if (GetIsPC(oNextNPC))
				{
					oIcon = GetLocalObject(oNPC, "MyIcon");
					DelayCommand(fTimer, LEG_QUEST_RefreshQuestIcon(oNPC, oIcon, oNextNPC));				
				}
				else
				{
					oIcon = GetLocalObject(oNextNPC, "MyIcon");
					DelayCommand(fTimer, LEG_QUEST_RefreshQuestIcon(oNextNPC, oIcon, OBJECT_SELF));
				}
				
				// Grab the next NPC.
				fTimer = fTimer + 0.1;
				oNextNPC = GetNextObjectInShape(SHAPE_SPHERE, StringToFloat(ICONREFRESHRANGE), GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_CREATURE);			
			}	
		}			
	}		
}