/*

    Script:			Called from the Item Activated Event script, it handles quest items for quest activations as
					well as items that are marked as quest tools.
	Version:		1.5
	Plugin Version: 2.00
	Author:			Marshall Vyper
	
	Change Log:		06/23/2011 - 1.00 MV - Initial Release
					10/01/2012 - 1.1 MV - Update to verify inventory counts
					10/14/2012 - 1.2 MV - Implement all Requirement checking options
					11/04/2012 - 1.3 MV - Fixed bug that incorrectly looked at PC's vars instead of corpses.
					07/24/2015 - 1.4 MV - User definable Nothing Interesting
					08/11/2015 - 1.5 MV - Plugins Version 2.0 - Added code for performing PC Data table consolidation	
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_quest_include"


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main(object oPC, object oItem, object oObject)
{
	// If our target object isn't valid, then just exit.
	if (!GetIsObjectValid(oObject))
		return;

	// If the Quest plugin isn't active, just exit.
	if (!GetLocalInt(GetModule(), "LEG_QUEST_ACTIVE"))
		return;
				
	// If this is the journal tool and we are not using the journal override then we'll want to
	// pop up the journal GUI.
	if (GetTag(oItem) == "leg_quest_journal")
	{
		DisplayGuiScreen(oPC, "LEG_SCREEN_JOURNAL", FALSE, "leg_quest_journal.xml");
		return;
	}
	
	if (GetTag(oItem) == "leg_quest_edit" && GetIsPC(oObject))
	{
		ExecuteScript("leg_quest_crossserver", oObject);
		
		LEG_COMMON_DisplayInfoBox(oObject, "Quests Refreshed", 0);
		SendMessageToPC(oPC, "Quests Refreshed");
		
		// If using the Quest Icon configuration, refresh anyone that's nearby that may need to be.
		if (LEG_QUEST_ICONS)
		{
			float fTimer = 0.1;
			object oIcon;
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
	
	// Get some variables from this item
	string sItem = GetResRef(oItem);
	string sName = GetName(oItem);
	int iTotalQuests = GetLocalInt(oItem, "LEG_QUEST_TotalQuests");		

	// If the item is an object that is used on a mob to obtain an item from it.  Sometimes an NPC
	// will provide the PC with an item to use to extract some sort of other item from the corpse
	// of a monster.
	if (iTotalQuests && GetLocalInt(oItem, "LEG_QUEST_ItemTool"))
	{
		// Make sure the PC is close enough to the corpse.
		if (GetDistanceBetween(oPC, oObject) > 3.0)
		{
			LEG_COMMON_DisplayInfoBox(oPC, "You are too far away.", 0);
			AssignCommand(oPC, ClearAllActions());
			return;
		}

		// Use the USE Time variable of the corpse placeable
		int iTime = GetLocalInt(oObject, "LEG_QUEST_UseTime");		
		if (iTime == 0)
			iTime = 5;
		
		// Our action here is going to be called "Using"
 		string sAction = "Using";
		
		// Find out how many quests are on the target.
		iTotalQuests = GetLocalInt(oObject, "LEG_QUEST_TotalQuests");		
		
		// Find out if there are quests on this thing and if the PC needs it.
		int iCount, iNeeds, iPCHas, iMin, iMax, iChance, iAdvanceNPC, iSpawnQty, iProgBarOn;
		string sQuestID, sQuestCounter;
		int iMultiplyer = 0;
		for (iCount = 1; iCount <= iTotalQuests; iCount++)
		{
			// Get some variables from the placeable.
			sQuestCounter = IntToString(iCount);
			string sValueID = "";
			string sQuestID = GetLocalString(oObject, "LEG_QUEST_QuestID_" + sQuestCounter);
			int iObjective = GetLocalInt(oObject, "LEG_QUEST_IsObjective_" + sQuestCounter);
			int iNPCObjective = GetLocalInt(oObject, "LEG_QUEST_ObjectiveFor_" + sQuestCounter);
			int iEffect = GetLocalInt(oObject, "LEG_QUEST_ItemToolEffect_" + sQuestCounter);
			
			// Find out if this placeable is the target of an Item Tool
			if (GetLocalInt(oObject, "LEG_QUEST_ItemToolTarget_" + sQuestCounter))
			{
				// This corpse has a quest for Item Target.  Get the tag of the item we want to give.
				if (GetLocalString(oObject, "LEG_QUEST_ItemToolTag_" + sQuestCounter) == sItem)
				{
					// In the event this is an instance or the server reset, let's check and see if 
					// this is a persistent placeable.
					location lLocation = GetLocation(oObject);
			    	object oArea = GetAreaFromLocation(lLocation);
			    	vector vPosition = GetPositionFromLocation(lLocation);
			    	float fOrientation = GetFacingFromLocation(lLocation);
			        string sValueID = GetTag(oArea) + "#" + FloatToString(vPosition.x) + "#" + FloatToString(vPosition.y) + "#" + FloatToString(vPosition.z) + "#" + FloatToString(fOrientation);
					sValueID = GetStringLeft(sValueID, 57);
			
					// Get the persistant Table Loot for placeables
					string sTableID = LEG_COMMON_GetPC2Table(oPC);
					
					
					// Is this a mob drop placeable?
					if (!GetLocalInt(OBJECT_SELF, "MOBDeath"))
					{		
						// See if the PC already searched this via persistence
						if (GetPersistentInt(oPC, sQuestID + "_" + sValueID, sTableID) > 0)
						{
							LEG_COMMON_DisplayInfoBox(oPC, ALREADYUSEDMESSAGE);
							return;
						}
					}
					else
					{
						// Can we check it?
						if (GetLocalInt(OBJECT_SELF, GetPCPublicCDKey(oPC)))
						{
							LEG_COMMON_DisplayInfoBox(oPC, ALREADYUSEDMESSAGE);
							return;
						}
					}					
					
					// Lets make sure they can't search anymore during this server reset.
					SetLocalInt(oObject, GetPCPublicCDKey(oPC), TRUE);
			
					// We also want to ensure the object isn't used again.
					if (!GetLocalInt(oObject, "MOBDeath"))
						SetPersistentInt(oPC, sQuestID + "_" + sValueID, TRUE, 0, sTableID);
							
					// We haven't used this corpse before with this correct item, so lets see if the PC actually
					// needs us.
					// Is the player on the quest and are they on this step?
					int iPlayerNPC = GetLocalInt(oPC, "QuestID_" + sQuestID + "_NPC");				
					int iPlayerOBJCount = GetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ" + IntToString(iObjective));
					
					// If they are, then let's continue.
					if (iPlayerNPC == iNPCObjective)
					{
						// If this objective is currently active and available for a PC to perform
						if (LEG_QUEST_GetOBJ(oPC, sQuestID, iNPCObjective, iObjective, "OBJInactive") == "1")
								return;
						
						// Find out what the PC needs and what they have.
						iNeeds = GetLocalInt(oObject, "LEG_QUEST_PCNeeds_" + sQuestCounter);
						iPCHas = iPlayerOBJCount;

						// If the PC needs this, then let's process that.
						if (iNeeds > iPCHas)
						{
							// PC now has another.  Let's find out what we need to create for the PC
							iPCHas++;
							string sItemForPC = GetLocalString(oObject, "LEG_QUEST_Item_" + sQuestCounter);
							
							// Find out some chances and quantities.
							iMin = GetLocalInt(oObject, "LEG_QUEST_MinQty_" + sQuestCounter);
							iMax = GetLocalInt(oObject, "LEG_QUEST_MaxQty_" + sQuestCounter);
							iChance = GetLocalInt(oObject, "LEG_QUEST_Chance_" + sQuestCounter);
							iAdvanceNPC = GetLocalInt(oObject, "LEG_QUEST_NPCAdvance_" + sQuestCounter);
							
							// Set some defaults in case we didn't bother entering any.
							if (iMin == 0)
								iMin = 1;
							if (iMax == 0)
								iMax = 1;
							if (iChance == 0)
								iChance = 100;
							
							// Make a roll against my chances
							if (Random(100) + 1 <= iChance)
							{
								// Figure out how many we are going to make and display some info.
								iSpawnQty = Random(iMax - iMin + 1) + iMin;
								if (!iProgBarOn)
								{
									iProgBarOn = TRUE;
									
									// See if there is a custom Prog Bar name
									string sAltProgBar = GetLocalString(oObject, "LEG_QUEST_AltProgBar_" + sQuestCounter);
									if (sAltProgBar != "")
										sAction = sAltProgBar;
									else
										sAction = sAction + " " + sName;
									LEG_COMMON_ProgBar(oPC, iTime, sAction, -1, ANIMATION_LOOPING_CONJURE1, 0, 0, "gen_conjure", 0, 0, "gen_conjureloop", 1, iTime - 1, oObject);
								}
								iMultiplyer++;

								// See if there is an alternate message configured to display.								
								string sAltMessage = GetLocalString(oObject, "LEG_QUEST_AltMessage_" + sQuestCounter);
								int iMyFlagID = GetLocalInt(oObject, "LEG_QUEST_SE_MyFlag_" + sQuestCounter);	
								DelayCommand(IntToFloat(iTime + ((iMultiplyer - 1) * 6)), LEG_QUEST_QuestCreditItem(sItemForPC, oPC, sQuestID, iObjective, 1, iSpawnQty, 1, iPCHas, iNeeds, sValueID, iAdvanceNPC, iNPCObjective, sAltMessage, iMyFlagID, oObject));

								// We need to check and see if this is a Lorebook Quest and if this Looted Item
								// will advance it and pop-up the GUI
								int iQuestType = GetLocalInt(oPC, "QuestID_" + sQuestID + "_Type");
								if (iQuestType == 1 && iPCHas >= iNeeds)
								{
									// This is a lore book and we have completed a Kill objective
									// Pop up the continue GUI if there is another NPC to be had.
									// Otherwise pop up the finish GUI
									int iQuestFinisher = GetLocalInt(oObject, "LEG_QUEST_Finisher_" + sQuestCounter);
									iCount = iTotalQuests;
									if (iQuestFinisher)
										LEG_QUEST_FireQuestGUI("leg_quest_finish", "leg_quest_finish.xml", oPC, iPlayerNPC, sQuestID);
									else
										LEG_QUEST_FireQuestGUI("leg_quest_continue", "leg_quest_continue.xml", oPC, iAdvanceNPC, sQuestID, iAdvanceNPC);
								}
																
								// Check for effect
								DelayCommand(IntToFloat(iTime), LEG_COMMON_VisualEffect(iEffect, oObject, OBJECT_INVALID));
							
							}
							else
							{
								// If we failed our chance to have an item spawn, then let's notify the PC
								// they are SOL.
								if (iCount == iTotalQuests && iProgBarOn == FALSE)
								{
									LEG_COMMON_DisplayInfoBox(oPC, NOQUESTMESSAGE, 0);
									return;
								}
							}
						}
						else if (iCount == iTotalQuests && iProgBarOn == FALSE)
						{
							// If the PC has all they need then no effect.
							LEG_COMMON_DisplayInfoBox(oPC, "No Effect", 0);
							return;
						}
					}
				}
			}
		}
	}	

	
	// This item could also be just a quest giver, like a lorebook or a looted item from a treasure drop or chest
	if (iTotalQuests && GetLocalInt(oItem, "LEG_QUEST_ItemTool") == 0)
	{
		// Items that hand out quests have only 1 quest on them always.
		string sQuestID = GetLocalString(oItem, "LEG_QUEST_QuestID_1");
		int iObjective = GetLocalInt(oItem, "LEG_QUEST_IsObjective_1");
		int iNPCObjective = GetLocalInt(oItem, "LEG_QUEST_ObjectiveFor_1");

		// Store the item as the quest giver on the NPC.  Sometimes we have to destroy the item so we
		// need to know what it is.
		SetLocalObject(oPC, "QNPC", oItem);
		
		// Am I the quest starter?
		int iQuestStarter = GetLocalInt(oItem, "LEG_QUEST_Starter_1");
				
		// Is the player on the quest and are they on this step?
		int iPlayerNPC = GetLocalInt(oPC, "QuestID_" + sQuestID + "_NPC");				
		int iPlayerOBJCount = GetLocalInt(oPC, "QuestID_" + sQuestID + "_OBJ" + IntToString(iObjective));

		// If the Player isn't on this quest and we have a quest starter then...
		if (iPlayerNPC == 0 && iQuestStarter)
		{
			// Find out if there is a previous requirement before an offer can take place.
			string sRequirement = GetLocalString(oItem, "LEG_QUEST_Requirement_1");
			string sQuestStarted = GetLocalString(oItem, "LEG_QUEST_QuestStarted_1");
			int iAdvanceOBJ = GetLocalInt(oItem, "LEG_QUEST_ObjectiveAdvance_1");
		
			// If the PC is on step 0 - hasn't started and this item is a quest starter, then
			// start the quest.  (Commonly used for collections)
			if ((GetLocalInt(oPC, "QuestID_" + sRequirement + "_NPC") == 999 || sRequirement == "") && (GetLocalInt(oPC, "QuestID_" + sQuestStarted + "_NPC") != 0 || sQuestStarted == ""))
			{
				// Check for other requirements
				if (LEG_QUEST_CheckQuestRequirements(oPC, oItem, "1"))
				{
					LEG_QUEST_FireQuestGUI("leg_quest_offer", "leg_quest_offer.xml", oPC, 1, sQuestID, 0, iAdvanceOBJ);
					string sTableID = LEG_COMMON_GetPC2Table(oPC);
					SetPersistentInt(oPC, "QuestID_" + sQuestID + "_1_ReluctantPassed", 1, 0, sTableID);
					SetLocalInt(oPC, "QuestID_" + sQuestID + "_1_ReluctantPassed", 1);
				}
				else
				{
					LEG_COMMON_DisplayInfoBox(oPC, "You do not meed the requirements for this", 0);
				}
			}
			else
			{
				LEG_COMMON_DisplayInfoBox(oPC, "You do not meed the requirements for this", 0);
			}				
		}
	}
}