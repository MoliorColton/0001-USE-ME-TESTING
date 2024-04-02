/*

    Script:			AI Script for the Perception event to go NPC's and Mobs.  Mostly a copy of the built
					in AI with minor modifications.
	Version:		1.2
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		06/23/2011 - 1.00 MV - Initial Release
					10/13/2012 - 1.1 MV - Fixed bug with AI/Banter/Quest combo
					11/12/2012 - 1.2 MV - Added support to call optional Pre Scripts
	
*/

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "hench_i0_ai"
#include "ginc_behavior"

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	object oNPC = OBJECT_SELF;
	
	// Run custom script
	string sScript = GetLocalString(oNPC, "LEG_AI_OnPerceptionScript");
	if (sScript != "") ExecuteScript(sScript, oNPC);
	
	//If Passive, do not react.
	if (GetLocalInt(oNPC, "PASSIVE") == TRUE) return;
	
	// * if not running normal or better Ai then exit for performance reasons
    if (GetAILevel(oNPC) == AI_LEVEL_VERY_LOW) return;

	// If we're in retreat mode, then ignore everything.
    if (GetLocalInt(oNPC, "Retreat_Mode") == TRUE) return;	
			
    // script hidden object shouldn't react (for cases where AI not turned off)
    if (GetScriptHidden(oNPC)) return;

    int iFocused = GetIsFocused();

    object oLastPerceived = GetLastPerceived();
    int bSeen = GetLastPerceptionSeen();
    if (iFocused <= FOCUSED_STANDARD)
    {
        //This is the equivalent of a force conversation bubble, should only be used if you want an NPC
        //to say something while he is already engaged in combat.
        if(GetSpawnInCondition(NW_FLAG_SPECIAL_COMBAT_CONVERSATION) && GetIsPC(oLastPerceived) &&
            bSeen)
        {
            SpeakOneLinerConversation();
        }

        //If the last perception event was hearing based or if someone vanished then go to search mode
        if (GetLastPerceptionVanished() || GetLastPerceptionInaudible())
        {
//          Jug_Debug(GetName(oNPC) + " lost perceived " + GetName(oLastPerceived) + " seen " + IntToString(GetObjectSeen(oLastPerceived)) + " heard " + IntToString(GetObjectHeard(oLastPerceived)));
            if (!GetObjectSeen(oLastPerceived) && !GetObjectHeard(oLastPerceived) &&
                !GetIsDead(oLastPerceived, TRUE) && GetArea(oLastPerceived) == GetArea(oNPC) &&
                GetIsEnemy(oLastPerceived) && (!HENCH_MONSTER_DONT_CHECK_HEARD_MONSTER || GetIsPCGroup(oLastPerceived)))
            {
//              Jug_Debug(GetName(oNPC) + " move to last heard or seen");
                if ((GetLastPerceptionVanished() || GetLocalInt(oNPC, henchCombatRoundStr) ||
					!HenchEnemyOnOtherSideOfDoor(oLastPerceived)) && !GetIsDisabled(oNPC))
                {
//                  Jug_Debug(GetName(oNPC) + " setting enemy location");
                    SetEnemyLocation(oLastPerceived);
                }
                // add check if target - prevents creature from following the target
                // due to ActionAttack without actually perceiving them
                if (GetLocalObject(oNPC, sHenchLastTarget) == oLastPerceived)
                {
//                  Jug_Debug(GetName(oNPC) + " calling det combat round, doing clearallactions");
                    ClearAllActions();
                    DeleteLocalObject(oNPC, sHenchLastTarget);
                    HenchDetermineCombatRound(oLastPerceived, TRUE);
                }
            }
        }
        //Do not bother checking the last target seen if already fighting
        else if (bSeen && !GetIsObjectValid(GetAttemptedAttackTarget()) && !GetIsObjectValid(GetAttemptedSpellTarget()))
        {
//          Jug_Debug(GetName(oNPC) + " checking perceived " + GetName(oLastPerceived) + " " + IntToString(GetObjectSeen(oLastPerceived)));
            // note : hearing is disabled and is only done in heartbeat. Calling GetIsEnemy with hearing causes
            // a noticeable lag to machine
            if (GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL))
            {
                HenchDetermineSpecialBehavior();
            }
            else if (GetIsEnemy(oLastPerceived) && !GetIsDead(oLastPerceived, TRUE))
            {
                if(!GetHasEffect(EFFECT_TYPE_SLEEP))
                {
//                  Jug_Debug(GetName(oNPC) + " starting combat round in percep");
                    SetFacingPoint(GetPosition(oLastPerceived));
                    HenchDetermineCombatRound(oLastPerceived);
                }
            }
            //Linked up to the special conversation check to initiate a special one-off conversation
            //to get the PCs attention
            else if (bSeen && GetSpawnInCondition(NW_FLAG_SPECIAL_CONVERSATION) && GetIsPC(oLastPerceived))
            {
                ActionStartConversation(oNPC);
            }
            // activate ambient animations or walk waypoints if appropriate
            if (!IsInConversation(oNPC))
            {
                if (GetIsPC(oLastPerceived) &&
                   (GetSpawnInCondition(NW_FLAG_AMBIENT_ANIMATIONS)
                    || GetSpawnInCondition(NW_FLAG_AMBIENT_ANIMATIONS_AVIAN)
                    || GetSpawnInCondition(NW_FLAG_IMMOBILE_AMBIENT_ANIMATIONS)
                    || GetIsEncounterCreature()))
                {
                    SetAnimationCondition(NW_ANIM_FLAG_IS_ACTIVE);
                }
            }
        }
        else if(GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL) && bSeen)
        {
            HenchDetermineSpecialBehavior();
        }
    }
    if(GetSpawnInCondition(NW_FLAG_PERCIEVE_EVENT) && bSeen)
    {
        SignalEvent(oNPC, EventUserDefined(EVENT_PERCEIVE));
    }
	
	// Last thing we want to do is to call our Master Death script!
	ExecuteScript("leg_all_masterperception", oNPC);	
}