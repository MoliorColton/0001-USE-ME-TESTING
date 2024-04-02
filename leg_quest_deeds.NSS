/*

    Script:			This script is called when a creature that is assigned a deed needs to be checked 
					against the player quest objectives.  If the PC has the quest or needs it, the 
					deed is advanced or offered or finished.
	Version:		1.4
	Plugin Version: 2.00
	Author:			Marshall Vyper
	
	Change Log:		06/23/2011 - 1.00 MV - Initial Release
					10/14/2012 - 1.2 MV - Implement all Requirement checking options						
					12/08/2012 - 1.3 MV - Bug fix where repeatable deeds were not repeating correctly (reported by pcentobie)
					08/11/2015 - 1.4 MV - Plugins Version 2.0 - Added code for performing PC Data table consolidation					
	
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_quest_include"


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main(object oPC, object oTarget)
{
	// The oTarget is the target or holder of the deed.  This could be a
	// mob, placeable or pretty much anything.  Importantly, it is the thing
	// that has the deed variables on it.  So lets check for that first.
	//SpeakString(GetName(oPC) + " in Deeds Script.", TALKVOLUME_SHOUT);

	int iTotalDeeds = GetLocalInt(oTarget, "LEG_QUEST_TotalQuests");
	if (iTotalDeeds)
	{
		// Looks like this guy is part of one or more deeds.
		int iDeedCount;
		for (iDeedCount = 1; iDeedCount <= iTotalDeeds; iDeedCount++)
		{
			// For each deed this guys has, lets do something.
			string sDeedCount = IntToString(iDeedCount);
			string sDeedID = GetLocalString(oTarget, "LEG_QUEST_QuestID_" + sDeedCount);
			int iDeedQty = GetLocalInt(oTarget, "LEG_QUEST_DeedQty_" + sDeedCount);

			// Don't do anything if this isn't a deed.			
			if (iDeedQty > 0)
			{
				
				// For each PC in the party we need to check this.
				object oMember = GetFirstFactionMember(oPC, TRUE);			

				//SpeakString(GetName(oPC) + " is running with Death.", TALKVOLUME_SHOUT);
				//SpeakString(GetName(oMember) + " is First Member.", TALKVOLUME_SHOUT);
							
			   	while(oMember != OBJECT_INVALID)
   				{
					//SpeakString(GetName(oMember) + " is Valid.", TALKVOLUME_SHOUT);
					
			        if (GetIsPC(oMember) && GetArea(oMember) == GetArea(oPC))
			       	{					
						//SpeakString(GetName(oMember) + " is PC and in same area as " + GetName(oPC), TALKVOLUME_SHOUT);

						// Now get the player's info
						string sTableID = LEG_COMMON_GetPC2Table(oMember);
						int iPlayerStep = GetLocalInt(oMember, "QuestID_" + sDeedID + "_NPC");
						
						// Deed NPC is always 1.
						int iNPCPosition = 1;
					
						
						// Check to see if the PC has completed this quest previously and if they are allowed to repeat.
						int iTimeSystem = GetLocalInt(GetModule(), "LEG_TIME_ACTIVE");
						if (iPlayerStep == 998)
						{
							int iPCStamp = GetLocalInt(oMember, "QuestID_" + sDeedID + "_NextRepeat");
							if (iPCStamp == 0 && iTimeSystem == TRUE)
								iPCStamp = GetPersistentInt(oMember, "QuestID_" + sDeedID + "_NextRepeat", sTableID);
							
							// If the timer has not passed, then fire the oneliner.
							if (GetLocalInt(oMember, "QuestID_" + sDeedID + "_NextRepeat") <= LEG_COMMON_TimeStamp())
							{
								iPlayerStep = 0;
								SetLocalInt(oMember, "QuestID_" + sDeedID + "_NPC", 0);
								SetPersistentInt(oMember, "QuestID_" + sDeedID + "_NPC", 0, 0, sTableID);
							}
						}				
						
						// See if the PC is on or needs to start this quest
						if (iPlayerStep < iNPCPosition)
						{
							string sRequirement = GetLocalString(oTarget, "LEG_QUEST_Requirement_" + sDeedCount);
							string sQuestStarted = GetLocalString(oTarget, "LEG_QUEST_QuestStarted_" + sDeedCount);				
							if ((GetLocalInt(oMember, "QuestID_" + sRequirement + "_NPC") == 999 || sRequirement == "") && (GetLocalInt(oMember, "QuestID_" + sQuestStarted + "_NPC") != 0 || sQuestStarted == ""))
							{
								// Check for other requirements
								if (LEG_QUEST_CheckQuestRequirements(oMember, oTarget, sDeedCount))
								{
						
									// Player needs the offer gui
									LEG_QUEST_FireQuestGUI("leg_quest_offer", "leg_quest_offer.xml", oMember, 1, sDeedID, 0, 1);
									string sTableID = LEG_COMMON_GetPC2Table(oMember);
									SetPersistentInt(oMember, "QuestID_" + sDeedID + "_1_ReluctantPassed", 1, 0, sTableID);
									SetLocalInt(oMember, "QuestID_" + sDeedID + "_1_ReluctantPassed", 1);
								}
							}
						}
						else if (iPlayerStep == iNPCPosition)
						{
							// PC is already on the quest, let's see how many qty they have
							int iPCHas = GetLocalInt(oMember, "QuestID_" + sDeedID + "_OBJ1");
						
							// Add one more and lets see if they are done.
							iPCHas++;
							if (iPCHas >= iDeedQty)
							{
								// All done, fire the Finish GUI
								LEG_QUEST_FireQuestGUI("leg_quest_finish", "leg_quest_finish.xml", oMember, 1, sDeedID);
							}
							else
							{
								//SpeakString(GetName(oMember) + " getting deed credit.", TALKVOLUME_SHOUT);
								// Not done yet, store the fact they just added one though.
								SendMessageToPC(oMember, "Deed Advanced (" + IntToString(iPCHas) + "/" + IntToString(iDeedQty) + ")");	
								
								// Next, we update the PC's objective counter with how many they have now.		
								SetLocalInt(oMember, "QuestID_" + sDeedID + "_OBJ1", iPCHas);
								
								// Store that same fact persistently.
								string sTableID = LEG_COMMON_GetPC2Table(oMember);
								SetPersistentInt(oMember, "QuestID_" + sDeedID + "_OBJ1", iPCHas, 0, sTableID);
								
								// Play a pretty sound!
								PlaySound("gui_journaladd");								
							}
						}
					}
					oMember = GetNextFactionMember(oPC, TRUE);
					//SpeakString(GetName(oMember) + " is Next Member.", TALKVOLUME_SHOUT);
				}
			}
		}
	}
}