/*

    Script:			AI Script for the Attacked Event to go NPC's and Mobs.  Mostly a copy of the built
					in AI with minor modifications.
	Version:		1.1
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		06/23/2011 - 1.00 MV - Initial Release
					11/12/2012 - 1.1 MV - Added support to call optional Pre Scripts

		
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
	// Run custom script
	string sScript = GetLocalString(OBJECT_SELF, "LEG_AI_OnAttackedScript");
	if (sScript != "")
		ExecuteScript(sScript, OBJECT_SELF);

	// If we're in retreat mode, then ignore everything.
    if (GetLocalInt(OBJECT_SELF, "Retreat_Mode") == TRUE)
		return;	

	// Default Stuff
    //--------------------------------------------------------------------------
    // GZ: 2003-10-16
    // Make Plot Creatures Ignore Attacks
    //--------------------------------------------------------------------------
    if (GetPlotFlag(OBJECT_SELF))
    {
        return;
    }
	
    int iFocused = GetIsFocused();

	// I've been attacked so no longer partially focused
	if (iFocused == FOCUSED_PARTIAL)
		SetLocalInt(OBJECT_SELF, VAR_FOCUSED, FOCUSED_STANDARD); // no longer focused
	
    if (iFocused == FOCUSED_FULL) {
        // remain focused
    } else if(GetFleeToExit()) {
        // Run away!
        ActivateFleeToExit();
    } else if (GetSpawnInCondition(NW_FLAG_SET_WARNINGS)) {
        // We give an attacker one warning before we attack
        // This is not fully implemented yet
        SetSpawnInCondition(NW_FLAG_SET_WARNINGS, FALSE);

        //Put a check in to see if this attacker was the last attacker
        //Possibly change the GetNPCWarning function to make the check
    } else {
        object oAttacker = GetLastAttacker();
        if (!GetIsObjectValid(oAttacker)) {
            // Don't do anything, invalid attacker

        } else if (!GetIsFighting(OBJECT_SELF)) {
            // We're not fighting anyone else, so
            // start fighting the attacker
            if(GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL))
			{
                SetSummonHelpIfAttacked();
				if (GetIsValidRetaliationTarget(oAttacker))	//DBR 5/30/06 - this if line put in for quest giving/plot NPC's
	                HenchDetermineSpecialBehavior(oAttacker);
            } else if (GetArea(oAttacker) == GetArea(OBJECT_SELF))
			{
                SetSummonHelpIfAttacked();
				if (GetIsValidRetaliationTarget(oAttacker))	//DBR 5/30/06 - this if line put in for quest giving/plot NPC's
                	HenchDetermineCombatRound(oAttacker);
            }

            //Shout Attack my target, only works with the On Spawn In setup
            SpeakString("NW_ATTACK_MY_TARGET", TALKVOLUME_SILENT_TALK);

            //Shout that I was attacked
            SpeakString("NW_I_WAS_ATTACKED", TALKVOLUME_SILENT_TALK);
        }
    }	
	
	
	
	
	
}