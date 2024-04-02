/*

    Script:			AI Script for the Spell Cast At Event to go NPC's and Mobs.  Mostly a copy of the 
					built in AI with minor modifications.
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
	string sScript = GetLocalString(OBJECT_SELF, "LEG_AI_OnSpellCastAtScript");
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

    object oCaster = GetLastSpellCaster();
	int nSpellID = GetLastSpell();

    int iFocused = GetIsFocused();

	// spell cast at me so no longer partially focused
	if (iFocused == FOCUSED_PARTIAL)
		SetLocalInt(OBJECT_SELF, VAR_FOCUSED, FOCUSED_STANDARD); // no longer focused

    if (iFocused == FOCUSED_FULL) {
        // remain focused
    }
    else if(GetLastSpellHarmful())
    {
		object oCaster = GetLastSpellCaster();
       // ------------------------------------------------------------------
        // If I was hurt by someone in my own faction
        // Then clear any hostile feelings I have against them
        // After all, we're all just trying to do our job here
        // if we singe some eyebrow hair, oh well.
        // ------------------------------------------------------------------
        if (GetFactionEqual(oCaster, OBJECT_SELF))
        {
            ClearPersonalReputation(oCaster, OBJECT_SELF);
            // Send the user-defined event as appropriate
            if(GetSpawnInCondition(NW_FLAG_SPELL_CAST_AT_EVENT))
            {
                SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_SPELL_CAST_AT));
            }
            return;
        }
		CheckRemoveStealth();
        if(!GetIsFighting(OBJECT_SELF) && GetIsValidRetaliationTarget(oCaster))
        {
            if(GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL))
            {
                HenchDetermineSpecialBehavior(oCaster);
            }
            else
            {
                HenchDetermineCombatRound(oCaster);
            }
        }
	}

    // Send the user-defined event as appropriate
    if(GetSpawnInCondition(NW_FLAG_SPELL_CAST_AT_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_SPELL_CAST_AT));
    }


	
	
	
	
	
	
	
}