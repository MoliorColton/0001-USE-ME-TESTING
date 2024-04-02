/*

    Script:			The Cut Scene script that is placed on Cut Scene triggers.  It obtains the
					configured variables from the trigger and activates the appropriate conversation
					to fire off a cut scene.
	Version:		1.2
	Plugin Version: 2.00
	Author:			Marshall Vyper
	
	Change Log:		12/20/2010 - 1.00 MV - Initial Release
					06/27/2011 - 1.01 MV - Updated so there is no need for INFO_ID.  The unique trigger is now the camera name.
					10/18/2012 - 1.1 MV - Added support for camera triggers based on if a PC is on a quest
					08/11/2015 - 1.2 MV - Plugins Version 2.0 - Added code for performing PC Data table consolidation						
*/

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_info_include"



// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	// Get the PC
	object oPC = GetEnteringObject();
	
	
	if (GetIsPC(oPC))
	{
		// Are we active?
		// Find out of this should even be active right now based on time of day.
		string sStartTOD = GetLocalString(OBJECT_SELF, "LEG_INFO_StartTOD");
		string sEndTOD = GetLocalString(OBJECT_SELF, "LEG_INFO_EndTOD");
		int iActive = TRUE;		
	
		// Are we a quest camera?  This cutscene will only fire once if a PC is on a quest.
		// These are ALWAYS once only and not an objective.  Just atmosphere.
		if (GetLocalInt(GetModule(), "LEG_QUEST_ACTIVE"))
		{
			string sQuestID = GetLocalString(OBJECT_SELF, "LEG_INFO_Quest");
			if (sQuestID != "")
			{
				// Looks like we are on a quest.
				int iPlayerPosition = GetLocalInt(oPC, "QuestID_" + sQuestID + "_NPC");
				if (iPlayerPosition <= 0 || iPlayerPosition == 999 || iPlayerPosition == 998)
				{
					// But the player does not currently have this quest.
					return;
				}
			}
		}	
		// If we don't have a setting, we just assume Active is TRUE which mean go ahead and process for now.
		// Otherwise go based on the TOD.  If a Start Time is set, then an end time must be set too or
		// we will always spawn.
		if (sStartTOD == "" || sEndTOD == "")
			iActive = TRUE;
	    else
			iActive = LEG_COMMON_CheckTOD(sStartTOD, sEndTOD);
		
		// No point in going any further if we are TRUE for being active right now.  Return that I am NOT active.
		if (!iActive)
			return;		
		
		// Get the Trigger Options
		//string sCamID = GetLocalString(OBJECT_SELF, "LEG_INFO_ID");
		string sCamera = GetLocalString(OBJECT_SELF, "LEG_INFO_CutScene");
		int iParty = GetLocalInt(OBJECT_SELF, "LEG_INFO_PartyCam");
		string sTableID = LEG_COMMON_GetPC2Table(oPC);
		int iNoRepeat = GetLocalInt(OBJECT_SELF, "LEG_INFO_NoRepeat");

		// If we are allowed to repeat this cutscene over and over.		
		if (!iNoRepeat)
		{
			// If we're not a party camera, then just fire the convo for the PC entering the trigger.
			if (!iParty)
				ActionStartConversation(oPC, sCamera, TRUE, FALSE);				
			else
			{
				// If we are a party cam, fire off the convo for each PC in the party that are in the same area.
				object oMember = GetFirstFactionMember(oPC);
		    	while(oMember != OBJECT_INVALID)
		    	{
			        if (GetIsPC(oMember) && GetArea(oMember) == GetArea(oPC))
						ActionStartConversation(oPC, sCamera, TRUE, FALSE);				
					oMember = GetNextFactionMember(oPC);
				}
			}
		}
		else
		{
			// We are a one shot type camera
			if (!GetLocalInt(oPC, sCamera))
			{
				if (!GetPersistentInt(oPC, "Info_" + sCamera, sTableID))
				{
					// Again, check and see if we are a party camera.
					if (!iParty)
					{
						// Save this camera to the database that its been used
						SetPersistentInt(oPC, "Info_" + sCamera, TRUE, 0, sTableID);
						SetLocalInt(oPC, sCamera, TRUE);
						ActionStartConversation(oPC, sCamera, TRUE, FALSE);
					}
					else
					{
						// Cycle through the party, storing the fact they've used this cam.
						object oMember = GetFirstFactionMember(oPC);
				    	while(oMember != OBJECT_INVALID)
				    	{
							// Look up to see if each member has seen this or not, and that they are in the same area.
							sTableID = LEG_COMMON_GetPC2Table(oMember);
					        if (GetIsPC(oMember) && GetArea(oMember) == GetArea(oPC) && !GetPersistentInt(oMember, sCamera, sTableID))
				        	{
								// Save it and show the camera convo
								SetPersistentInt(oMember, "Info_" + sCamera, TRUE, 0, sTableID);
								SetLocalInt(oMember, sCamera, TRUE);
								ActionStartConversation(oMember, sCamera, TRUE, FALSE);
							}
							oMember = GetNextFactionMember(oPC);
						}
					}
				}
			}
		}
	}		
}