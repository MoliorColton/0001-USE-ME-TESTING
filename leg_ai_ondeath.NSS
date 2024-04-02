/*

    Script:			AI Script for the Death Event to go NPC's and Mobs.  Mostly a copy of the built in
					AI with minor modifications.
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
#include "x2_inc_compon"
#include "x0_i0_spawncond"



// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	// Run custom script
	string sScript = GetLocalString(OBJECT_SELF, "LEG_AI_OnDeathScript");
	if (sScript != "")
		ExecuteScript(sScript, OBJECT_SELF);

	string sDeathScript = GetLocalString(OBJECT_SELF, "DeathScript");
	if (sDeathScript != "")
		ExecuteScript(sDeathScript, OBJECT_SELF);

	
    int nClass = GetLevelByClass(CLASS_TYPE_COMMONER);
    int nAlign = GetAlignmentGoodEvil(OBJECT_SELF);
    object oKiller = GetLastKiller();

    // If we're a good/neutral commoner,
    // adjust the killer's alignment evil
    if(nClass > 0 && (nAlign == ALIGNMENT_GOOD || nAlign == ALIGNMENT_NEUTRAL))
    {
        AdjustAlignment(oKiller, ALIGNMENT_EVIL, 5);
    }

    // Call to allies to let them know we're dead
    SpeakString("NW_I_AM_DEAD", TALKVOLUME_SILENT_TALK);

    //Shout Attack my target, only works with the On Spawn In setup
    SpeakString("NW_ATTACK_MY_TARGET", TALKVOLUME_SILENT_TALK);
	
	// Last thing we want to do is to call our Master Death script!
	ExecuteScript("leg_all_masterdeath", OBJECT_SELF);
		// REMOVE ANY BARS ANYWAY (DIRECT TO DEATH BYPASS DAMAGE)
	RemoveSEFFromObject(OBJECT_SELF, "alb_hp_100");	
	RemoveSEFFromObject(OBJECT_SELF, "alb_hp_90");	
	RemoveSEFFromObject(OBJECT_SELF, "alb_hp_80");	
	RemoveSEFFromObject(OBJECT_SELF, "alb_hp_70");	
	RemoveSEFFromObject(OBJECT_SELF, "alb_hp_60");	
	RemoveSEFFromObject(OBJECT_SELF, "alb_hp_50");	
	RemoveSEFFromObject(OBJECT_SELF, "alb_hp_40");	
	RemoveSEFFromObject(OBJECT_SELF, "alb_hp_30");	
	RemoveSEFFromObject(OBJECT_SELF, "alb_hp_20");	
	RemoveSEFFromObject(OBJECT_SELF, "alb_hp_10");	
}