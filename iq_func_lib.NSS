//  Miscellaneous functions library
//  Author: Icequeen6769

// Send Debug Message to DM tester
void Debug(object oPlayer, string sMessage)
{
if (!GetIsDM(oPlayer) && !GetIsDMPossessed(oPlayer)) return;
SendMessageToPC(oPlayer,sMessage);
}

// Returns the Player's unique Database Name
string SSGetPlayerDatabase(object oPC)
{
	string bReturn=GetLocalString(GetItemPossessedBy(oPC, "pc_db_tool"), "PC_DB_Name");
	if (bReturn=="") bReturn="DM_Database";
	return bReturn;
}

// Returns the Character's Database "key" variable
string SSGetCharacterKey(object oPC)
{
	string bReturn=GetLocalString(GetItemPossessedBy(oPC, "pc_db_tool"), "PC_DB_Key");
	if (bReturn=="") bReturn=GetName(oPC);
	return bReturn;
}

// Checks for & Removes all extra copies of oItemToClean from oPlayer's inventory
void CleanUp(object oItemToClean, object oPlayer)
{
if (!GetIsObjectValid(oItemToClean)) return; 
object oCheck=GetFirstItemInInventory(oPlayer);
while (GetIsObjectValid(oCheck))
	{
	if (GetTag(oCheck)==GetTag(oItemToClean) && oItemToClean!=oCheck) DestroyObject(oCheck,0.0,FALSE);
	oCheck=GetNextItemInInventory(oPlayer);
	}
}

// StoreCampaignObject as a command - for delayed commands
void DoStoreCampaignObject(string sCampaign, string sVariable, object oObject, object oPlayer=OBJECT_INVALID)
{
StoreCampaignObject(sCampaign, sVariable, oObject, oPlayer);
}

// Icequeen's persistent systems;
// Return Left-end identifier from tagname of oObject
string IQGetIDLeft(object oObject)
{
return GetStringLeft(GetTag(oObject),9);
}

// Icequeen's persistent systems;
// Return Right-end identifier from tagname of oObject
string IQGetIDRight(object oObject)
{
return GetStringRight(GetTag(oObject),3);
}

// Returns TRUE if there is a PC in the area
int GetIsPCInArea(object oTarget=OBJECT_SELF)
{
object oCheck=GetFirstObjectInArea(GetArea(oTarget));
while (GetIsObjectValid(oCheck))
	{
	if (GetIsPC(oCheck)) return TRUE;
	oCheck=GetNextObjectInArea(oTarget);
	}
return FALSE;
}