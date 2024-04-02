//:: Icequeen's Persistent Banking (10/28/08)
// Author: Icequeen6769


// *** Add this to your module pc_loaded script, above "void main()"
#include "iq_func_lib"
// -------------------------------------------------------------

void main()
{
object oPC = GetEnteringObject();
// Failsafe prevent objects other than PCs & DMs from running this script
if (!GetIsPC(oPC)) return;

// This section for DMs ONLY
if (GetIsDM(oPC))
	{
	// Do nothing at this time
	}
	
// *** FOR PLAYER BANKING: Add everything below this to your module's pc_loaded script
// This section for non-DM PCs ONLY
if (!GetIsDM(oPC))
	{
	// --run for all entering Non-DM PCs
	string sDB=GetStringLeft(GetPCPlayerName(oPC),7)+"_"+GetPCPublicCDKey(oPC);
	// NWNX systems seem to have a problem with giving multiple database tools
	object oItem=GetFirstItemInInventory(oPC);
	while (GetIsObjectValid(oItem))
		{
		if (GetTag(oItem)=="pc_db_tool" && GetLocalString(oItem, "PC_DB_Name")==sDB)
			{
			CleanUp(oItem, oPC);
			break;
			}
		oItem=GetNextItemInInventory(oPC);
		}

	// --run if the pc was never in this module before--
	if (GetItemPossessedBy(oPC,"pc_db_tool")==OBJECT_INVALID)
   		{
   		SendMessageToPC(oPC,"Welcome newbie!");
		// setup a unique "key" id for the database & give the PC a tool
    	//sKey must be unique for each character.
		object oToken=CreateItemOnObject("pc_db_tool",oPC,1,"pc_db_tool");
		SetPlotFlag(oToken, TRUE);
		SetItemCursedFlag(oToken, TRUE);
		SetPickpocketableFlag(oToken, FALSE);
		SetDroppableFlag(oToken, FALSE);
		 // Setup Player's Database name
		SetLocalString(oToken,"PC_DB_Name",sDB);
		 // Setup Character's Unique ID for use within Player's database
		 // Max DB Variable string length=32 -8(Datestamp) =24 left
		string sDateStamp=IntToString(GetCalendarYear())+IntToString(GetCalendarMonth())+IntToString(GetCalendarDay());
		string sShortName=GetStringLeft(GetName(oPC),8); // down to 16 characters ...
		string sKey=sDateStamp+"_"+sShortName+"_";       // leaves us 14 characters for function variable names.
		SetLocalString(oToken,"PC_DB_Key",sKey);
		}
	// --run if the player has been in this module before--
	else  
   		{
		// Do nothing at this time
		}
	}
}