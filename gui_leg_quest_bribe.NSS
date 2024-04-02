//-----------------------------------------------------------------------
// <copyright file="gui_leg_quest_bribe.nss" company="Molior RS">
// Copyright (c) Molior RS. All rights reserved.
// </copyright>
// <revision> 1 </revision>
// <lasteditedby>Austin Jensen</lasteditedby>
//-----------------------------------------------------------------------
/*

    Script:			If the PC is on a quest and they speak to an NPC that offers the option to
					bribe and the PC selects it.
	Version:		1.1
	Plugin Version: 2.00
	Author:			Marshall Vyper
	
	Change Log:		06/23/2011 - 1.00 MV - Initial Release
					08/11/2015 - 1.1 MV - Plugins Version 2.0 - Added code for performing PC Data table consolidation					
	
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_quest_include"



// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main(int iQuestID, int iNPC, int iObj1, int iObj2, int iObj3, int iObj4, int iObj5, int iAdvanceNPC, int iQuestType)
{
	// Setup some variables, grabbing the string version of the Quest ID which was passed by the GUI.
	string sQuestID = IntToString(iQuestID);
	int iCount;
	
	// If this NPC is on an escort, just exit the gui.
	object oNPC = GetLocalObject(OBJECT_SELF, "QNPC");
	if (GetLocalInt(oNPC, "OnEscort"))
		return;
		
	// Get the PC's quest table
	string sTableID = LEG_COMMON_GetPC2Table(OBJECT_SELF);
	
	// All that really has to happen with this option is to take the PC's gold if they have it, and
	// set the proper variable, firing up the "continue" GUI and store that fact persistently.  Start
	// by getting the gold value.
	int iBribe;
	SQLExecDirect("SELECT * FROM `" + QUESTPREFIX + "_skills` WHERE `QuestID` = '" + sQuestID + "' AND `NPCID` = '" + IntToString(iNPC) + "';");
	while(SQLFetch())
		iBribe = StringToInt(SQLGetData(6));
	
	// Find out if the PC has enough.
	if (GetGold(OBJECT_SELF) >= iBribe)
	{
		// PC has the cash, let's take it!
		LEG_COMMON_DisplayInfoBox(OBJECT_SELF, "Bribe Success");
		TakeGoldFromCreature(iBribe, OBJECT_SELF, TRUE, TRUE);
		SetLocalInt(OBJECT_SELF, "QuestID_" + sQuestID + "_" + IntToString(iNPC) + "_ReluctantPassed", 1);
		SetPersistentInt(OBJECT_SELF, "QuestID_" + sQuestID + "_" + IntToString(iNPC) + "_ReluctantPassed", 1, 0, sTableID);
		
		// Throw up the Continue GUI
		LEG_QUEST_FireQuestGUI("leg_quest_continue", "leg_quest_continue.xml", OBJECT_SELF, iNPC, sQuestID);
	}
	else
	{
		// Not enough cash!
		LEG_COMMON_DisplayInfoBox(OBJECT_SELF, "Not enough gold.");
	}
	
	// We have our quest NPC, let's refresh their icon if that option is active.
	object oIcon;
	if (LEG_QUEST_ICONS)
	{
		oIcon = GetLocalObject(oNPC, "MyIcon");
		object oTrap = GetNearestTrapToObject(oNPC, FALSE);
		SetTrapDisabled(oTrap);
		LEG_QUEST_RefreshQuestIcon(oNPC, oIcon, OBJECT_SELF);
	}
			
	// Refresh my Quest Icon for anyone around me.  Of course, Me being the NPC you just accepted from which
	// isn't stored anywhere so we have to figure out who the hell gave it us.
	oNPC = GetLocalObject(OBJECT_SELF, "QNPC");
	if (GetIsObjectValid(oNPC))
	{
		// We have our quest NPC, let's refresh their icon if that option is active.
		object oIcon;
		if (LEG_QUEST_ICONS)
		{
			float fTimer = 0.1;
			oIcon = GetLocalObject(oNPC, "MyIcon");
			object oTrap = GetNearestTrapToObject(oNPC, FALSE);
			SetTrapDisabled(oTrap);			
			LEG_QUEST_RefreshQuestIcon(oNPC, oIcon, OBJECT_SELF);
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