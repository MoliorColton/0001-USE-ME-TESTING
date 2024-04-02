/*

    Script:			AI Script for the Damaged Event to go NPC's and Mobs.  Mostly a copy of the built
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
#include "INC_GUI_BOSSBAR"


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	// Run custom script
	string sScript = GetLocalString(OBJECT_SELF, "LEG_AI_OnDamagedScript");
	if (sScript != "")
		ExecuteScript(sScript, OBJECT_SELF);
	
	// If we're in retreat mode, then ignore everything.
    if (GetLocalInt(OBJECT_SELF, "Retreat_Mode") == TRUE)
		return;	
    int iFocused = GetIsFocused();
	
	// I've been damaged so no longer partially focused
	if (iFocused == FOCUSED_PARTIAL)
	{
		SetLocalInt(OBJECT_SELF, VAR_FOCUSED, FOCUSED_STANDARD); // no longer focused
	}
    if (iFocused == FOCUSED_FULL)
	{
        // remain focused
    }
	else if(GetFleeToExit())
	{
        // We're supposed to run away, do nothing
    }
    else if (GetSpawnInCondition(NW_FLAG_SET_WARNINGS))
    {
        // don't do anything?
    }
    else
    {
        object oDamager = GetLastDamager();
        if (!GetIsObjectValid(oDamager))
        {
        // don't do anything, we don't have a valid damager
        }
        else if (!GetIsFighting(OBJECT_SELF))
        {
            if ((GetLocalInt(OBJECT_SELF, HENCH_HEAL_SELF_STATE) == HENCH_HEAL_SELF_WAIT) &&
                (GetPercentageHPLoss(OBJECT_SELF) < 30))
            {
                // force heal
                HenchDetermineCombatRound(OBJECT_INVALID, TRUE);
            }
            else if (!GetIsObjectValid(GetAttemptedAttackTarget()) && !GetIsObjectValid(GetAttemptedSpellTarget()))
            {
//    Jug_Debug(GetName(OBJECT_SELF) + " responding to damage");
                if (GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL))
                {
                    HenchDetermineSpecialBehavior(oDamager);
                }
                else
                {
                    HenchDetermineCombatRound(oDamager);
                }
            }
        }
    }
    if(GetSpawnInCondition(NW_FLAG_DAMAGED_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_DAMAGED));
    }
}