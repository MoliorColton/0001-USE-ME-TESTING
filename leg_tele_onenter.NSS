/*

    Script:			This script is called by the Master On Area Enter script.  It simply clears any party id's 
					a player may have.  When a party enters an instance, the ground rules are all members of the
					party need to be in the area where the instance entrance is located.  Without this, we had 
					many random things occur so we put this rule in place to help simplify things considering it
					isn't too much to ask for a party to gather at the instance entrance before proceding into the
					dark scary dungeon together as a group!
	Version:		1.3
	Plugin Version: 2.00
	Author:			Marshall Vyper
	
	Change Log:		06/23/2011 - 1.00 MV - Initial Release
					10/08/2012 - 1.1 MV - Added support for instance resetting
					10/11/2012 - 1.2 MV - Added support for cross server questing
					08/11/2015 - 1.3 MV - Plugins Version 2.0 - Added code for performing PC Data table consolidation					
	
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_tele_include"

void main()
{
	// A party needs to be all in the same zone before entering an instance, otherwise, the player will not be able
	// to join the party.  
	object oPC = OBJECT_SELF;
	
	string sTableID = LEG_COMMON_GetPC2Table(oPC);
	
	if (GetLocalInt(GetModule(), "LEG_TELE_INSTANCE"))
	{
		SetLocalInt(GetModule(), "TELE_RESTARTONEMPTY", 1);
		string sPortalID = GetLocalString(GetModule(), "LEG_TELE_SERVERID");
		int iMyInstance = GetPersistentInt(oPC, "InstanceID", sTableID);
		//SpeakString("My Instance: " + IntToString(iMyInstance), TALKVOLUME_SHOUT);
		SetLocalInt(GetModule(), "InstanceID", iMyInstance);
	}

	SetLocalInt(oPC, "PartyID", 0);
	SetLocalInt(oPC, "InstanceID", 0);
	SetPersistentInt(oPC, "InstanceID", 0, 0, sTableID);

	// If the plugin is configured to save locations in this module.
	ExecuteScript("leg_tele_savecampsite", oPC);

	// If the quest plugin is active and we are here then we've just crossed servers.  Let's
	// update our variables.
	if (GetLocalInt(GetModule(), "LEG_QUEST_ACTIVE") && GetPersistentInt(oPC, "QUEST_RefreshQuests", TELEPREFIX + "_campsite"))
	{
		ExecuteScript("leg_quest_crossserver", oPC);
		DeletePersistentVariable(oPC, "QUEST_RefreshQuests", TELEPREFIX + "_campsite");
	}

	object oArea = GetArea(oPC);
	int iDestinations = GetLocalInt(oArea, "LEG_TELE_Destinations");
	if (iDestinations)
	{
		string sWPName = LEG_TELE_GetTPDestination(oPC, oArea);
		if (sWPName == "")
			return;
		
		// Get the destination
		if (sWPName == "Campsite")
		{	
			location lSpawnSite = GetPersistentLocation(oPC, "CampLocation", TELEPREFIX + "_campsite");
			if (!GetIsLocationValid(lSpawnSite))
			{
			    // No valid campsite, so lets go to our alternate.
				object oSpawnPoint = GetObjectByTag(GetLocalString(GetModule(), "LEG_TELE_SERVERSTARTWP"));
				location lSpawnSite = GetLocation(oSpawnPoint);
				DelayCommand(1.0, AssignCommand(oPC,JumpToLocation(lSpawnSite)));			
			}
			else
				DelayCommand(1.0, AssignCommand(oPC,JumpToLocation(lSpawnSite)));
			return;
		}	
		
		object oChildWP = GetObjectByTag(sWPName);
	
		// Transport the PC to the location.
	    AssignCommand(oPC, ActionJumpToObject(oChildWP, FALSE));
	
		// Transport any critters that's along for the ride with the PC.
	    if (GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION,oPC)))
	    {
	        AssignCommand(GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION,oPC), JumpToObject(oChildWP, FALSE));
	    }
	    if (GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_DOMINATED,oPC)))
	    {
	        AssignCommand(GetAssociate(ASSOCIATE_TYPE_DOMINATED,oPC), JumpToObject(oChildWP, FALSE));
	    }
	    if (GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_FAMILIAR,oPC)))
	    {
	        AssignCommand(GetAssociate(ASSOCIATE_TYPE_FAMILIAR,oPC), JumpToObject(oChildWP, FALSE));
	    }
	    if (GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oPC)))
	    {
	        AssignCommand(GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oPC), JumpToObject(oChildWP, FALSE));
	    }
	    if (GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_SUMMONED,oPC)))
	    {
	        AssignCommand(GetAssociate(ASSOCIATE_TYPE_SUMMONED,oPC), JumpToObject(oChildWP, FALSE));
	    }
	}
}