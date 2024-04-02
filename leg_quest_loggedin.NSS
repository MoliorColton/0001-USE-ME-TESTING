#include "leg_quest_include"

void main()
{
	object oPC = OBJECT_SELF;
	
	// Player just logged in.  Let's do things related to the quest plugin when a player logs in.  NOTE, this will fire if the server was reset or not!
		
	// Player logged out while they had a quest based timer bar running.  Tsk Tsk Tsk.  Bad player.  Let's FAIL their Timer Bar.
	string sTablePlayer = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
	string sTableToon = SQLEncodeSpecialChars(GetName(oPC));
	string sPCTableName = LEG_COMMON_GetPC2Table(oPC);
	
	// First we see if this was a failed objective timer...
	SQLExecDirect("SELECT * FROM " + sPCTableName + " WHERE `player` = '" + sTablePlayer + "' AND `tag` = '" + sTableToon + "' AND `name` LIKE '%TIMERMOBOBJ%'");
	SQLFetch();
	string sTimerID = SQLGetData(3);
	if (sTimerID != "")
	{
		// If you are a failed Objective then...			
		string sQuestID = GetStringRight(GetStringLeft(sTimerID, 12), 4);
		int iObjective = StringToInt(GetStringRight(sTimerID, GetStringLength(sTimerID) - 24));
		SQLExecDirect("SELECT * FROM " + sPCTableName + " WHERE `player` = '" + sTablePlayer + "' AND `tag` = '" + sTableToon + "' AND `name` LIKE '%TIMERMOB%'");
		SQLFetch();
		sTimerID = SQLGetData(3);
		if (GetStringLength(sTimerID) > 24)
		{
			SQLFetch();
			sTimerID = SQLGetData(3);
		}		
		int iNPC = StringToInt(GetStringRight(sTimerID, 1));
		SetLocalString(oPC, "LEG_INFO_TimerBarQuestID", sQuestID);
		SetLocalInt(oPC, "LEG_INFO_TimerBarNPC", iNPC);
		SetLocalInt(oPC, "LEG_INFO_TimerBarNPCOBJ", iObjective);

		// Fire the fail script which should have fired if they stayed logged in.
		ExecuteScript("leg_quest_objtimerfail", oPC);
	}
	else
	{
		// No failed objective timer so lets check for an NPC timer
		SQLExecDirect("SELECT * FROM " + sPCTableName + " WHERE `player` = '" + sTablePlayer + "' AND `tag` = '" + sTableToon + "' AND `name` LIKE '%TIMERMOB%'");
		SQLFetch();
		if (sTimerID != "")
		{
			// If you are a failed NPC then...
			string sQuestID = GetStringRight(GetStringLeft(sTimerID, 12), 4);
			int iNPC = StringToInt(GetStringRight(sTimerID, 1));
			SetLocalString(oPC, "LEG_INFO_TimerBarQuestID", sQuestID);
			SetLocalInt(oPC, "LEG_INFO_TimerBarNPC", iNPC);
			
			// Fire the fail script which should have fired if they stayed logged in.
			ExecuteScript("leg_quest_npctimerfail", oPC);
		}
	}
}