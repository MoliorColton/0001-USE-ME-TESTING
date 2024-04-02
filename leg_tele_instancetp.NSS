/*

    Script:			This is the teleportation script for dungeon instances.  To be used only for dungeon instances
					and not world to world transfers.  Typically this is placed on the door or object in the OnUsed
					event.
	Version:		1.1
	Plugin Version: 2.00
	Author:			Marshall Vyper
	
	Change Log:		06/23/2011 - 1.0 MV - Initial Release
					08/11/2015 - 1.1 MV - Plugins Version 2.0 - Added code for performing PC Data table consolidation					
	
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
	// Let's find out who is clicking on us and then get our default destination info.
	object oPC = GetClickingObject();
	if (!GetIsObjectValid(oPC))
		oPC = GetLastUsedBy();
		
	object oPartyFaction = GetFactionLeader(oPC);

//	SpeakString("Door has been used by: " + GetName(oPC), TALKVOLUME_SHOUT); 
	
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
		
	string sWPID = LEG_TELE_GetTPDestination(oPC, oTeleporter);
	if (sWPID == "")
		return;
	
//	SpeakString("Requirements Met", TALKVOLUME_SHOUT); 
	// Set up timer usage for Bind Points.  Need config box in plugin for mins between uses etc.
	int iCurrentTime = LEG_COMMON_TimeStamp();
	int iCoolDown = GetLocalInt(oTeleporter, "LEG_SPAWN_Cooldown");
	int iResetTime = (iCoolDown * REAL_MINUTES) + GetLocalInt(oPC, GetTag(oTeleporter) + "_LastUsed");

	if (iCurrentTime >= iResetTime || !iCoolDown)
	{
		//SpeakString("Cool Down non issue", TALKVOLUME_SHOUT); 
		SetLocalInt(oPC, GetTag(oTeleporter) + "_LastUsed", LEG_COMMON_TimeStamp());
		
		// If we are going to the server START Location...
		if (sWPID == "ServerNOWP")
			sWPID = "";
			
		string sPortalID = GetLocalString(oTeleporter, "TELE_PortalID");
		
		// Let's get the portal details from the portals table.
		SQLExecDirect("SELECT * FROM `" + TELEPREFIX + "_portals" + "` WHERE `PortalID` = '" + sPortalID + "'");
		SQLFetch();
		string sPortalIP = SQLGetData(2);
		string sPortalBase = SQLGetData(3);
		//string sItem = SQLGetData(4);
		//string sFeat = SQLGetData(5);
		string sPortalPass = SQLGetData(6);
			
		//SpeakString("Door has been used by: " + GetName(oPC), TALKVOLUME_SHOUT); 
		
		// Setup some variables and check to see if the PC has a party already.
		int iCount, iMyInstance, iHasInstance, iPartyInstance;
		int iPartyID = GetLocalInt(oPC, "PartyID");
		
		// If I have a Party ID, then someone in my party is already in the instance.
		// If Not, I'm the first so I should assign everyone a party ID.
		if (!iPartyID)
		{
			//SpeakString("No Party ID.  First person is entering: " + GetName(oPC), TALKVOLUME_SHOUT); 
	
	
			// Check the database for non-active instances.  This is the instance table that we're going to pull
			// this information from.
			int iInstanceCounter, iActive;
			SQLExecDirect("SELECT * FROM `" + TELEPREFIX + "_instances" + "` WHERE `PortalID` = '" + sPortalID + "'");
			while (SQLFetch())
			{
				// Grab the instance # of this row and its active state.
				iInstanceCounter = StringToInt(SQLGetData(2));
				iActive = StringToInt(SQLGetData(3));
				
				// If the PC doesn't have an Instance assigned yet and the instance is not active according to the
				// database, then we're good to go with this one.
				if (!iActive && iHasInstance == FALSE)
				{
					// The instance isn't active and I don't have one, so let's clear the party ID off the door
					// just in case something goes wrong before I port.
					SetLocalInt(oTeleporter, "InstanceID_" + IntToString(iInstanceCounter), 0);
					iMyInstance = iInstanceCounter;
					iHasInstance = TRUE;						
				}
			}
	
			// So I've gone through all the instances and none were showing as available (non-active) and I ended
			// up without a HasInstance.  
			if (!iHasInstance)
			{
				//SpeakString("Ok, no Database Instances available: " + GetName(oPC), TALKVOLUME_SHOUT); 
				// Wow, all the instances are really full.  May need to another if this happens often.
				WriteTimestampedLogEntry("Instances all full for Instance ID: " + sPortalID);
				LEG_COMMON_DisplayInfoBox(oPC, "All instances full, please try later.");
			}
			else
			{
				// But, here, I got me an instance!  So now let's assign to our party and get moving!
				object oMember = GetFirstFactionMember(oPartyFaction, TRUE);
				int iPartyID = Random(1000) + 100;
				string sTableID;
				while (GetIsObjectValid(oMember))
				{
					SetLocalInt(oMember, "PartyID", iPartyID);
					SetLocalInt(oMember, "InstanceID", iMyInstance);
					sTableID = LEG_COMMON_GetPC2Table(oMember);
					SetPersistentInt(oMember, "InstanceID", iMyInstance, 0, sTableID);
					oMember = GetNextFactionMember(oPartyFaction, TRUE);	
				}
				
				// All members have a Party ID now.  Remember, we need to remove party ID's if we change areas!
				//SpeakString("Instance is available Porting: " + GetName(oPC) + " to Instance: " + sPortalID + " party id: " + IntToString(iPartyID) + " Instance Number: " + IntToString(iMyInstance), TALKVOLUME_SHOUT); 
				//SpeakString("Going to: " + sPortalIP + ":" + IntToString(StringToInt(sPortalBase) + iMyInstance), TALKVOLUME_SHOUT);
				ExecuteScript("leg_world_savepc", oPC);
				
				// If the plugin is configured to save locations in this module.
				if (GetLocalInt(GetModule(), "LEG_TELE_ACTIVE"))
				{
					ExecuteScript("leg_tele_savecampsite", oPC);
				}						
				
				// Allright it's GO TIME!  Store my party ID on the door so the rest of my party can follow easily.
				SetLocalInt(oTeleporter, "InstanceID_" + IntToString(iMyInstance), iPartyID);
				SQLExecDirect("UPDATE `" + TELEPREFIX + "_instances" + "` SET `Active`='1' WHERE `PortalID` = '" + sPortalID + "' AND `InstanceNumber` = '" + IntToString(iMyInstance) + "'");
				//SpeakString("Activating Port for: " + GetName(oPC) + ", IP: " + sPortalIP + ":" + IntToString(StringToInt(sPortalBase) + iMyInstance) + ", Pass: " + sPortalPass, TALKVOLUME_SHOUT);
				
				
				
				// Do any fun stuff before TPing.
				float fDelay = LEG_TELE_FunStuff(oPC, oTeleporter);
				DelayCommand(fDelay + 0.4, ActivatePortal(oPC, sPortalIP + ":" + IntToString(StringToInt(sPortalBase) + iMyInstance), sPortalPass, sWPID, TRUE));
			}
		}
		else
		{
			//SpeakString("Joining the rest of my party: " + GetName(oPC), TALKVOLUME_SHOUT); 
	
			// I have a party ID.  Let's find out which instance my Party's in.  We grab a matching party ID
			// which we stored on the door from above via the first party member that entered.
			iMyInstance = GetLocalInt(oPC, "InstanceID");
	
			//SpeakString("Porting to: " + sPortalID + " instance #: " + IntToString(iMyInstance) + " party #: " + IntToString(iPartyID), TALKVOLUME_SHOUT); 
			//SpeakString("Going to: " + sPortalIP + ":" + IntToString(StringToInt(sPortalBase) + iMyInstance), TALKVOLUME_SHOUT);
			ExecuteScript("leg_world_savepc", oPC);
			
			// If the plugin is configured to save locations in this module.
			if (GetLocalInt(GetModule(), "LEG_TELE_ACTIVE"))
			{
				ExecuteScript("leg_tele_savecampsite", oPC);
			}		
			float fDelay = LEG_TELE_FunStuff(oPC, oTeleporter);	
			DelayCommand(fDelay + 0.4, ActivatePortal(oPC, sPortalIP + ":" + IntToString(StringToInt(sPortalBase) + iMyInstance), sPortalPass, sWPID, TRUE));
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
			
		LEG_COMMON_DisplayInfoBox(oPC, "This portal will be cooled down in " + sMessage);
		SetItemCharges(oTeleporter, GetItemCharges(oTeleporter) + 1);
		DelayCommand(1.0, ExecuteScript("leg_tele_savecampsite", oPC));
	}
}