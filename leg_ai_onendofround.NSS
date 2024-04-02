/*

    Script:			AI Script for the End Of Round Event to go NPC's and Mobs.  Mostly a copy of
					the built in AI with minor modifications.
					in AI with minor modifications.
	Version:		1.2
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		06/23/2011 - 1.00 MV - Initial Release
					11/12/2012 - 1.1 MV - Added support to call optional Pre Scripts
					05/30/2015 - 1.2 MV - Added support to call Master End of Round scripts for plugins
	
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_ai_include"
#include "hench_i0_ai"


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	object oNPC = OBJECT_SELF;
	
	// Run custom script
	string sScript = GetLocalString(oNPC, "LEG_AI_OnEndOfRoundScript");
	if (sScript != "") ExecuteScript(sScript, oNPC);
			
	// If we're in retreat mode, then ignore everything.
    if (GetLocalInt(oNPC, "Retreat_Mode") == TRUE) return;	
	
   	HenchResetCombatRound();

    int iFocused = GetIsFocused();
 
    if (iFocused <= FOCUSED_STANDARD)
    {
		if (!HenchCheckEventClearAllActions(TRUE))
		{
		    if(GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL))
		    {
		        HenchDetermineSpecialBehavior();
		    }
		    else if(!GetSpawnInCondition(NW_FLAG_SET_WARNINGS))
		    {
		        HenchDetermineCombatRound();
		    }
		}
	}
    if(GetSpawnInCondition(NW_FLAG_END_COMBAT_ROUND_EVENT))
    {
        SignalEvent(oNPC, EventUserDefined(EVENT_END_COMBAT_ROUND));
    }
	
	// Last thing we want to do is to call our Master script!
	ExecuteScript("leg_all_masterendofround", oNPC);
		
	// The round has ended.  Should we continue using the weapon we have or change up to something else?
	//LEG_AI_WeaponsCheck(oBadGuy);
}