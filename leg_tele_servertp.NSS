/*

    Script:			Script that is placed on a placeable object that when used will teleport the player to another
					server location.  This should not be used for instance entry, however is useful for server to 
					server, transfer from a bootstrap server to a main world or even when exiting an instance.  
					A more complex script is available to ENTRY into instances though.
	Version:		1.1
	Plugin Version: 1.92
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		06/23/2011 - 1.00 MV - Initial Release
					10/11/2012 - 1.1 MV - Added support for cross server questing
	
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_tele_include"



// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	// Find out who clicked me and then pull up my destination ID.
	object oPC = GetPlaceableLastClickedBy();
	if (!GetIsObjectValid(oPC))
		oPC = GetClickingObject();

	object oTeleporter;
	object oParentSpawnPoint = GetLocalObject(OBJECT_SELF, "SPAWN_Parent");
	if (GetIsObjectValid(oParentSpawnPoint))
	{
		oTeleporter = oParentSpawnPoint;
	}
	else
	{
		oTeleporter = OBJECT_SELF;
	}
			
	string sPortalIP, sPortalBase, sPortalPass, sPortalID;
	string sWPID = LEG_TELE_GetTPDestination(oPC, oTeleporter);
	if (sWPID == "")
		return;
	
	// If we are going to the server START Location...
	if (sWPID == "ServerNOWP")
		sWPID = "";
		
	sPortalID = GetLocalString(oTeleporter, "TELE_PortalID");
	//string sPortalID = GetLocalString(OBJECT_SELF, "LEG_TELE_DestinationID");

	// Set up timer usage for Bind Points.  Need config box in plugin for mins between uses etc.
	int iCurrentTime = LEG_COMMON_TimeStamp();
	int iCoolDown = GetLocalInt(oTeleporter, "LEG_SPAWN_Cooldown");
	int iResetTime = (iCoolDown * REAL_MINUTES) + GetLocalInt(oPC, GetTag(oTeleporter) + "_LastUsed");

	if (iCurrentTime >= iResetTime || !iCoolDown)
	{
		SetLocalInt(oPC, GetTag(oTeleporter) + "_LastUsed", LEG_COMMON_TimeStamp());
	
		// Let's get the portal details from the Portals table.
		if (sPortalID != "Campsite")
		{
			SQLExecDirect("SELECT * FROM `" + TELEPREFIX + "_portals" + "` WHERE `PortalID` = '" + sPortalID + "'");
			SQLFetch();
			sPortalIP = SQLGetData(2);
			sPortalBase = SQLGetData(3);
			sPortalPass = SQLGetData(6);
		}
		else
		{
		// Are we going to our campsite?
			// If so, pull up the player's campsite server and send them there instead.  Unless of course they don't have
			// one.  If that's the case, use the door configured default.
			sPortalID = GetPersistentString(oPC, "ServerLocation", TELEPREFIX + "_campsite");
			if (sPortalID != "")
			{
				SQLExecDirect("SELECT * FROM `" + TELEPREFIX + "_portals" + "` WHERE `PortalID` = '" + sPortalID + "'");
				SQLFetch();
				sPortalIP = SQLGetData(2);
				sPortalBase = SQLGetData(3);
				sPortalPass = SQLGetData(6);
			}
		}
		
		// Ok, let's send the PC on their way.
		SetPersistentInt(oPC, "QUEST_RefreshQuests", 1, 0, TELEPREFIX + "_campsite");
		float fDelay = LEG_TELE_FunStuff(oPC, oTeleporter);
		DelayCommand(fDelay + 0.4, ActivatePortal(oPC, sPortalIP + ":" + sPortalBase, sPortalPass, sWPID, TRUE));
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
			
		LEG_COMMON_DisplayInfoBox(oPC, "This portal will be cooled down in " + sMessage);
		SetItemCharges(oTeleporter, GetItemCharges(oTeleporter) + 1);
		DelayCommand(1.0, ExecuteScript("leg_tele_savecampsite", oPC));
	}

}