/*

    Script:			Called from the On Item Un-Acquired Event of the module for processing quest items that are obtained by the PC
					through non-standard means.  Used when a PC drops an item.
	Version:		1.3
	Plugin Version: 2.00
	Author:			Marshall Vyper
	
	Change Log:		06/23/2011 - 1.00 MV - Initial Release
					12/23/2011 - 1.01 MV - Fixed bug that was overwritten previously.
					10/01/2012 - 1.1 MV - Changed GetTag to GetResRef on get inventory count
										- Update to verify inventory counts
					11/04/2012 - 1.2 MV - Fixed bug that would cause Objectives to mess up when a quest tool was dropped.
					08/11/2015 - 1.2 MV - Plugins Version 2.0 - Added code for performing PC Data table consolidation					
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_quest_include"


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main(object oPC, object oItem)
{
	// Check for quest items
	// Make sure PC is initialized - apparantly this fires when a player first logs in and we don't want it going off
	// at that point.
	if (GetLocalInt(oPC, "LEG_PLAYER_INIT"))
	{
		// Is our dropped item a quest item?
		if (GetLocalInt(oItem, "LEG_QUEST_TotalQuests"))
		{
			// Yes it is.  Let's see what quest its for.
			string sQuestID = GetLocalString(oItem, "LEG_QUEST_QuestID_1");
			int iObjective = GetLocalInt(oItem, "LEG_QUEST_IsObjective_1");
			int iNPCObjective = GetLocalInt(oItem, "LEG_QUEST_ObjectiveFor_1");

			// Quest tools can have TotalQuests var on them but not be an item objective.  They
			// do not have QuestID's on them.
			if (sQuestID == "")
				return;
			
			// Is the player on the quest and are they on this step?
			int iPlayerNPC = GetLocalInt(oPC, "QuestID_" + sQuestID + "_NPC");				
			int iPlayerOBJCount = GetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ" + IntToString(iObjective));
			if (iPlayerNPC == iNPCObjective)
			{
				// Yes, the PC is on the quest and is on the step.  Let's find out how many the PC has
				// and ensure we only de-crement the amount if the PC goes below what he or she needs
				// This is because I may only need 4 of something and have collected 10 of it.  I can freely
				// drop or trade 6 before I have an issue.
				int iNeeds = GetLocalInt(oItem, "LEG_QUEST_PCNeeds_1");
				//int iPCHas = LEG_COMMON_GetInventoryCount(oPC, GetResRef(oItem)) + GetItemStackSize(oItem);
				int iPCHas = LEG_COMMON_GetInventoryCount(oPC, GetResRef(oItem));
				
				// Ensure these vars don't get lost.  I've had it happen where I dropped a split stack and vars got lost.
				SetLocalString(oItem, "LEG_QUEST_QuestID_1", sQuestID);
				SetLocalInt(oItem, "LEG_QUEST_IsObjective_1", iObjective);
				SetLocalInt(oItem, "LEG_QUEST_ObjectiveFor_1", iNPCObjective);
				SetLocalInt(oItem, "LEG_QUEST_PCNeeds_1", iNeeds);
									
				// Do I have all of what I need?
				if (iNeeds >= iPCHas)
				{
					// Nope, I don't have MORE than what I need so let's drop one and decrement.
					//iPCHas = iPCHas - GetItemStackSize(oItem);
				
					// Display some informtation that the PC obtained this item.
					LEG_COMMON_DisplayInfoBox(oPC, "Lost " + GetName(oItem) + " (" + IntToString(iPCHas) + "/" + IntToString(iNeeds) + ")");
					
					// Save the fact that the PC lost the item
					SetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ" + IntToString(iObjective), iPCHas);
					string sTableID = LEG_COMMON_GetPC2Table(oPC);
					SetPersistentInt(oPC, "QuestID_" + sQuestID + "_OBJ" + IntToString(iObjective), iPCHas, 0, sTableID);
					
					// Play a pretty sound
					PlaySound("gui_journaladd");
					
					// If using the Quest Icon configuration, refresh anyone that's nearby that may need to be.
					if (LEG_QUEST_ICONS)
					{
						object oIcon;
						object oNextNPC = GetFirstObjectInShape(SHAPE_SPHERE, StringToFloat(ICONREFRESHRANGE), GetLocation(oPC), FALSE, OBJECT_TYPE_CREATURE);
						float fTimer = 0.1;
						while (GetIsObjectValid(oNextNPC))
						{
							oIcon = GetLocalObject(oNextNPC, "MyIcon");
							DelayCommand(fTimer, LEG_QUEST_RefreshQuestIcon(oNextNPC, oIcon, oPC));				
							fTimer = fTimer + 0.1;
							oNextNPC = GetNextObjectInShape(SHAPE_SPHERE, StringToFloat(ICONREFRESHRANGE), GetLocation(oPC), FALSE, OBJECT_TYPE_CREATURE);			
						}	
					}
				}
				else
				{
					// The PC has MORE than is required.  Let's find out how many he has.  Let's not do anything
					// here yet until we test better.  Do we even need to do anything at all?  PC has 10, needs 5,
					// drops 4, has 6.  Problems?
				}	
			}						
		}
		else if(GetLocalInt(oItem, "LEG_QUEST_IAmReq"))
		{
			// I'm an item requirement for a quest.  If the quest giver is nearby, I might want to updated their quest icon.
			if (LEG_QUEST_ICONS)
			{
				object oIcon;
				float fTimer = 0.1;
				object oNextNPC = GetFirstObjectInShape(SHAPE_SPHERE, StringToFloat(ICONREFRESHRANGE), GetLocation(oPC), FALSE, OBJECT_TYPE_CREATURE);
				while (GetIsObjectValid(oNextNPC))
				{
					oIcon = GetLocalObject(oNextNPC, "MyIcon");
					DelayCommand(fTimer, LEG_QUEST_RefreshQuestIcon(oNextNPC, oIcon, oPC));				
					fTimer = fTimer + 0.1;
					oNextNPC = GetNextObjectInShape(SHAPE_SPHERE, StringToFloat(ICONREFRESHRANGE), GetLocation(oPC), FALSE, OBJECT_TYPE_CREATURE);			
				}	
			}
		}
	}
}