/*

    Script:			Called by the master on activated script, this allows standard teleport 
					options to be placed on an item.
	Version:		1.0
	Plugin Version: 1.92
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		11/18/2012 - 1.0 MV - Initial Release
	
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_tele_include"


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main(object oPC, object oItem)
{
	object oTeleporter = oItem;
	int iDestinations = GetLocalInt(oItem, "LEG_TELE_Destinations");
	if (iDestinations)
	{
		// Set up timer usage for Bind Points.  Need config box in plugin for mins between uses etc.
		int iCurrentTime = LEG_COMMON_TimeStamp();
		int iResetTime = (BINDRESET * REAL_MINUTES) + GetLocalInt(oPC, "TELE_LastBindUsed");
	
		if (iCurrentTime >= iResetTime)
		{
			string sWPName = LEG_TELE_GetTPDestination(oPC, oTeleporter);
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
					float fDelay = LEG_TELE_FunStuff(oPC, oTeleporter);
					DelayCommand(fDelay + 0.2, AssignCommand(oPC,JumpToLocation(lSpawnSite)));			
				}
				else
				{
					float fDelay = LEG_TELE_FunStuff(oPC, oTeleporter);
					DelayCommand(fDelay + 0.2, AssignCommand(oPC,JumpToLocation(lSpawnSite)));
				}
				return;
			
			}
			else if (sWPName == "BindPoint")
			{
				location lSpawnSite = GetPersistentLocation(oPC, "BindLocation", TELEPREFIX + "_campsite");
				if (!GetIsLocationValid(lSpawnSite))
				{
				    // No valid bind, so lets go to our alternate.
					LEG_COMMON_DisplayInfoBox(oPC, "You do not have a bind point in these lands");
					SetItemCharges(oTeleporter, GetItemCharges(oTeleporter) + 1);
				}
				else
				{
					SetLocalInt(oPC, "TELE_LastBindUsed", LEG_COMMON_TimeStamp());
					float fDelay = LEG_TELE_FunStuff(oPC, oTeleporter);
					DelayCommand(fDelay + 0.2, AssignCommand(oPC,JumpToLocation(lSpawnSite)));
				}
				return;		
			}
			else if (sWPName == "RezSite")
			{
				// Move them to the nearest spawn point.  First we see if we are inside a special
				// respawn override trigger.  
				object oSpawnPoint = GetObjectByTag(GetLocalString(GetArea(oPC), "LEG_WORLD_RespawnTag"));	
				object oSpawnTrigger = GetNearestObjectByTag("LEG_WORLD_RespawnTrig", oPC);		
			    if (GetIsObjectValid(oSpawnTrigger))
			    {
			        if (GetObjectType(oSpawnTrigger) == OBJECT_TYPE_TRIGGER)
			        {
			            object oInTrig = GetFirstInPersistentObject(oSpawnTrigger, OBJECT_TYPE_CREATURE);
			            while (GetIsObjectValid(oInTrig) == TRUE)
			            {
			                if (oPC == oInTrig)
			                {
			                    oSpawnPoint = GetObjectByTag(GetLocalString(oSpawnTrigger, "LEG_WORLD_RespawnTag"));	
								break;
			                }	
							oInTrig = GetNextInPersistentObject(oSpawnTrigger, OBJECT_TYPE_CREATURE);
						}
					}
				}
				AssignCommand(oPC, JumpToLocation(GetLocation(oSpawnPoint)));
			}
			else
			{
				object oChildWP = GetObjectByTag(sWPName);
			
				// Transport the PC to the location.
				if (GetIsObjectValid(oChildWP))
				{
					float fDelay = LEG_TELE_FunStuff(oPC, oTeleporter);
					DelayCommand(fDelay + 0.2, AssignCommand(oPC, ActionJumpToObject(oChildWP, FALSE)));
					// Transport any critters that's along for the ride with the PC.
				    if (GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION,oPC)))
				    {
				        DelayCommand(fDelay + 0.2, AssignCommand(GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION,oPC), JumpToObject(oChildWP, FALSE)));
				    }
				    if (GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_DOMINATED,oPC)))
				    {
				        DelayCommand(fDelay + 0.2, AssignCommand(GetAssociate(ASSOCIATE_TYPE_DOMINATED,oPC), JumpToObject(oChildWP, FALSE)));
				    }
				    if (GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_FAMILIAR,oPC)))
				    {
				        DelayCommand(fDelay + 0.2, AssignCommand(GetAssociate(ASSOCIATE_TYPE_FAMILIAR,oPC), JumpToObject(oChildWP, FALSE)));
				    }
				    if (GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oPC)))
				    {
				        DelayCommand(fDelay + 0.2, AssignCommand(GetAssociate(ASSOCIATE_TYPE_HENCHMAN,oPC), JumpToObject(oChildWP, FALSE)));
				    }
				    if (GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_SUMMONED,oPC)))
				    {
				        DelayCommand(fDelay + 0.2, AssignCommand(GetAssociate(ASSOCIATE_TYPE_SUMMONED,oPC), JumpToObject(oChildWP, FALSE)));
				    }
				}
			}			
		}
		else
		{
			int iTimeLeft = LEG_COMMON_MinsLeft(iCurrentTime, iResetTime);
			string sMessage = "";
			if (iTimeLeft > 1)
				sMessage = IntToString(iTimeLeft) + " minutes";
			else if (iTimeLeft == 1)
				sMessage = IntToString(iTimeLeft) + " minute";
			else if (iTimeLeft == 0)
				sMessage = " less than a minute";
				
			LEG_COMMON_DisplayInfoBox(oPC, "Your " + GetName(oItem) + " will be cooled down in " + sMessage);
			SetItemCharges(oTeleporter, GetItemCharges(oTeleporter) + 1);
			DelayCommand(1.0, ExecuteScript("leg_tele_savecampsite", oPC));
		}
	}
}