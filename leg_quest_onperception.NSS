/*

    Script:			This script is for NPC's when the Quest ICON config is active to refresh/update and icon the NPC may have.
	Version:		1.1
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		06/23/2011 - 1.00 MV - Initial Release
					05/18/2015 - 1.1 MV - Added code to prevent quest icons from spawning on temporary neutral enemies.
	
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_quest_include"


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main(object oPC)
{
	// First see if the ICON config is active.
	if (LEG_QUEST_ICONS)
	{
		if (!GetLocalInt(OBJECT_SELF, "LEG_QUEST_NoIcon"))
		{
			// Next see if I have an Icon.		
			if (!GetIsObjectValid(GetLocalObject(OBJECT_SELF, "MyIcon")))
			{
				// And do I have quests?
				if (GetLocalInt(OBJECT_SELF, "LEG_QUEST_TotalQuests") > 0)
				{
					// Who did I just see?
					if (GetIsPC(oPC))
					{
						// Are we hostile?  We don't wanna be.
						if (!GetIsReactionTypeHostile(oPC, OBJECT_SELF))
						{
							// Am I in the middle of an escort quest?  Hope not.
							if (GetLocalInt(OBJECT_SELF, "OnEscort") != 1)
							{
								// Am I just a monster on the Neutral faction waiting for the PC to piss me off?
								int iTotalQuests = GetLocalInt(OBJECT_SELF, "LEG_QUEST_TotalQuests");
								int iHostile = FALSE;
								int iCounter = 1;
								for (iCounter; iCounter <= iTotalQuests; iCounter++)
								{
									if (GetLocalString(OBJECT_SELF, "LEG_QUEST_Action_" + IntToString(iCounter)) == "Drop" || GetLocalString(OBJECT_SELF, "LEG_QUEST_Action_" + IntToString(iCounter)) == "Kill")
										iHostile = TRUE;
								}
								if (iHostile == FALSE)								
								{
									// Let's create my icon!  WOOT!
									vector vSpawnVector = GetPosition(OBJECT_SELF);
									vector vRadius = Vector(0.0, 0.0, 2.5);
									location lLoc = Location(GetArea(OBJECT_SELF), vSpawnVector + vRadius, 0.0);
									string sIconType = "leg_quest_icon";
									if (ICONTYPE == "Loot")
										sIconType = "leg_quest_icon2";
										
									object oQuestIcon = CreateObject(OBJECT_TYPE_PLACEABLE, sIconType, lLoc, FALSE, GetTag(OBJECT_SELF) + "_qicon");
									SetLocalObject(OBJECT_SELF, "MyIcon", oQuestIcon);
								}
							}
						}
					}
				}	
			}
		}
	
		// Now that I have a valid Icon...
		if (GetIsObjectValid(GetLocalObject(OBJECT_SELF, "MyIcon")))
		{
			// I've already got an icon.  Let's see if I am viewable to this person or not.
			object oTrap;
			object oMyIcon = GetLocalObject(OBJECT_SELF, "MyIcon");
	
			// And the PC is valid.
			if (GetIsPC(oPC))
				LEG_QUEST_RefreshQuestIcon(OBJECT_SELF, oMyIcon, oPC);
		}	
	}	
}