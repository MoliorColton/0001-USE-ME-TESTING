/*

    Script:			This is the MASTER on end of round script.  It goes on all NPC's and monsters or is called from an
					existing end of round script via ExecuteScript function.  Like all Master Run Scripts, this script 
					examines which plugins are available and active and calls them.
	Version:		1.1
	Plugin Version: 1.93
	Author:			Marshall Vyper
	
	Change Log:		05/30/2015 - MV - Initial Version
	
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{

	// If the QUEST Plugin is active for criers.
	if (GetLocalInt(GetModule(), "LEG_QUEST_ACTIVE"))
	{
		ExecuteScript("leg_quest_onendofround", OBJECT_SELF);
	}
	
	// If the BANTER Plugin is active.
	if (GetLocalInt(GetModule(), "LEG_BANTER_ACTIVE"))
	{
		// Get the Chance for perception messages and speak.
		int iBanterCombatChance = GetLocalInt(OBJECT_SELF, "LEG_BANTER_OnEndOfCombatRoundChance");
		string sBanterCombatID = GetLocalString(OBJECT_SELF, "LEG_BANTER_OnEndOfCombatRound");
		AddScriptParameterString(sBanterCombatID);
		AddScriptParameterInt(iBanterCombatChance);
		AddScriptParameterString("Combat");
		ExecuteScriptEnhanced("leg_banter_speak", OBJECT_SELF);
				
	}	
}