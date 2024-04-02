/*
    Script:			AI Script for the Heartbeat Event to go NPC's and Mobs.  Mostly a copy of the
					built in AI with minor modifications.
	Version:		1.5
	Plugin Version: 2.00
	Author:			Marshall Vyper
	
	Change Log:		06/23/2011 - 1.00 MV - Initial Release
					11/12/2012 - 1.1 MV - Added support to call optional Pre Scripts
					07/13/2015 - 1.2 MV - Attempt to make sleeping NPC's work more betterer.
					07/19/2015 - 1.3 MV - Enhanced Guards Mob Type and improved pathing to home point reducing stalls.
					07/20/2015 - 1.4 MV - Major enhancements to AI for Patrol Routes and Posts, including ability to run scripts on arrival of posts.
					08/16/2015 - 1.5 MV - Enhanced friends system to work better when groups have differing perceptions 	
*/

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
//#include "leg_all_fixednw_i0_generic"
//const int HENCH_OPTION_DISABLE_HB_HEARING     		= 0x04000;      // turn off heartbeat hearing for monsters and associates
//const int HENCH_OPTION_DISABLE_HB_DETECTION    		= 0x08000;      // turn off heartbeat detection of enemies for monsters and associates

#include "leg_ai_include"
#include "hench_i0_ai"
#include "INC_GUI_BOSSBAR"


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	object oNPC = OBJECT_SELF;
	
    // If not ready to fire my HB, then don't.  Ready would be set by Equip Function in the spawn.
	if (GetLocalInt(oNPC, "Ready") == FALSE) return;

	// If we need to override the heartbeat because we're commanded to do something else then skip it.
	if (GetLocalInt(oNPC, "AI_Override")) return;
		
	// Run custom script
	string sScript = GetLocalString(oNPC, "LEG_AI_OnHeartbeatScript");
	if (sScript != "") ExecuteScript(sScript, oNPC);
		
	// Default Stuff
    // * if not runnning normal or better Ai then exit for performance reasons
    if (GetAILevel(oNPC) == AI_LEVEL_VERY_LOW) return;

    if(GetSpawnInCondition(NW_FLAG_FAST_BUFF_ENEMY))
    {
        if(HenchTalentAdvancedBuff(40.0))
        {
            SetSpawnInCondition(NW_FLAG_FAST_BUFF_ENEMY, FALSE);
            // TODO evaluate continue with combat
            return;
        }
    }

	// Friends being called upon, Only do this if I am not in retreat mode though.
	if (!GetLocalInt(oNPC, "Retreat_Mode"))
	{
		if (GetLocalInt(oNPC, "FriendInNeed") && !GetIsInCombat(oNPC))
		{
			object oFriend = GetLocalObject(oNPC, "MyFriend");
			object oTarget =  GetLocalObject(oFriend, sHenchLastTarget);
			if (GetDistanceToObject(oFriend) < 5.0)
			{
				HenchDetermineCombatRound(oTarget);
				SetLocalInt(oNPC, "FriendInNeed", 0);
			}
			else if (!GetIsInCombat(oFriend))
			{
				SetLocalInt(oNPC, "FriendInNeed", 0);
				return;
			}
			else
			{
				ClearAllActions();
				ActionMoveToObject(oFriend, TRUE);
				return;
			}
		}
	}
	
	if (HenchCheckHeartbeatCombat())
	{
	    HenchResetCombatRound();
	}

	// If we're posted, then ensure we set home to the post.
	string sPrefix = GetWPPrefix();
	int nPoints = GetNumWaypointsByPrefix(sPrefix);
	if (!GetIsInCombat())
	{
		if ((nPoints == 1) && (GetLocalInt(oNPC, VAR_WP_SINGLE_POINT_OVERRIDE)==FALSE))
		{
			string sPrefix = GetWPPrefix();
			object oWP = GetWaypointByNum(1, sPrefix);
			if (GetDistanceBetweenLocations(GetLocation(oNPC), GetLocation(oWP)) <= 1.0)
			{
				ClearAllActions();
				//SetFacing(GetFacing(oWP));
				ActionDoCommand(SetFacing(GetFacing(oWP)));
				//ActionDoCommand(SetFacingPoint(GetPosition(oWP)));				
				LEG_AI_SetMobHome(oNPC);
			}
		}
	}
		
	if (GetIsInCombat() && GetLocalInt(oNPC, "AI_SLEEP"))
	{
		// If I was sleeping, fix it now.
	 	SetLocalInt(oNPC, "AI_SLEEP", FALSE);
		SetLocalInt(oNPC, "AI_SleepChance", 0);
		SetLocalObject(oNPC, "AI_SleepLocation", OBJECT_INVALID);
	}			
	
	// The Big If
	int iMobType = GetLocalInt(oNPC, "LEG_AI_MobType");
	
    if((GetHasEffect(EFFECT_TYPE_SLEEP) || GetLocalInt(oNPC, "AI_SLEEP")) && !GetIsInCombat())
    {
		//SpeakString(GetName(oNPC) + " is asleep or supposed to en-route.", TALKVOLUME_SHOUT);
		// We're either asleep or on our way to a waypoint.  (Maybe even got stuck)
		if (!GetHasEffect(EFFECT_TYPE_SLEEP))
		{
			//SpeakString(GetName(oNPC) + " is NOT asleep.", TALKVOLUME_SHOUT);
			// Am not alseep so either I am enroute to my sleep waypoint, standing AT my sleep WP waiting for the
			// delay command (which could be interupted), or I totally got interupted enroute.
			object oSleepLocation = GetLocalObject(oNPC, "AI_SleepLocation");
			if (GetIsObjectValid(oSleepLocation))
			{
				if (GetDistanceBetweenLocations(GetLocation(oNPC), GetLocation(oSleepLocation)) > 1.0)
				{
        			if (GetCurrentAction(oNPC) == ACTION_MOVETOPOINT)
        			{
            			SetLocalInt(oNPC, "SleepStuckCounter", 0);
			        }
        			else
        			{
			            SetLocalInt(oNPC, "SleepStuckCounter", GetLocalInt(oNPC, "SleepStuckCounter") + 1);
						
						// Considering I am NOT on my way, then stop whatever it is I am doing!
						ClearAllActions(TRUE);
			
			            // If Stuck Counter reachs 5 rounds (~30 seconds, port them)
			            if (GetLocalInt(oNPC, "SleepStuckCounter") >= 5)
			            {
							//SpeakString(GetName(oNPC) + " is being forced teleported!", TALKVOLUME_SHOUT);
			                SetLocalInt(oNPC, "SleepStuckCounter", 0);
				                ActionJumpToLocation(GetLocation(oSleepLocation));
						}									
						else
						{
							//SpeakString(GetName(oNPC) + " is being told to move it!", TALKVOLUME_SHOUT);
							ActionForceMoveToLocation(GetLocation(oSleepLocation), FALSE, 15.0);
						}
					}
				}
				else
				{	
					//SpeakString(GetName(oNPC) + " is being put to sleep", TALKVOLUME_SHOUT);
					int iHours = GetLocalInt(oNPC, "AI_SleepHours");
		        	effect eSleep = EffectSleep();
					effect eKnock = EffectKnockdown();
					eSleep = EffectLinkEffects(eKnock, eSleep);
					DelayCommand(0.1f, SetCommandable(FALSE, oNPC));
					if (!GetLocalInt(oNPC, "AI_SLEEP_Override"))
					{
						ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSleep, oNPC, HoursToSeconds(iHours));
			        	DelayCommand(HoursToSeconds(iHours), SetCommandable(TRUE, oNPC));					
					}
					else
					{
						ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSleep, oNPC);						
					}
				}
			}
		}
		
        // If we're asleep and this is the result of sleeping
        // at night, apply the floating 'z's visual effect
        // every so often
        if(GetSpawnInCondition(NW_FLAG_SLEEPING_AT_NIGHT) || GetLocalInt(oNPC, "AI_SLEEP_Override"))
        {
            effect eVis = EffectNWN2SpecialEffectFile("fx_snore.sef");
            if(d10() > 6)
            {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oNPC, 3.0);
            }
        }
    } 
    else if (iMobType == 5 && !GetIsInCombat())
	{
		ExecuteScript("leg_ai_bartender", oNPC);	
	}
    else if (iMobType == 6 && !GetIsInCombat())
	{
		ExecuteScript("leg_ai_barmaid", oNPC);
	}
    else if (iMobType == 7 && !GetIsInCombat())
	{
		// If I am supposed to be performing random NPC tasks
		//
		// Have I been initialized yet?
		if (!GetLocalInt(oNPC, "AI_RandomNPCInit"))
		{
			// I do not have my array of tasks yet.
			LEG_AI_InitRandomNPC(GetLocalInt(oNPC, "LEG_AI_BehaviorSet1"), GetLocalInt(oNPC, "LEG_AI_BehaviorSet2"));
		}
			
		// Is it time to change my task?  If not, keep doing what I'm doing, otherwise, switch it up.
		object oTaskWP = GetLocalObject(oNPC, "AI_TaskWP");
		if (!GetIsObjectValid(oTaskWP) || GetTimeHour() == GetLocalInt(oNPC, "AI_NextTaskHour"))
		{
			// If time, go to an appropriate waypoint that I need to perform my task.  Once I get there, start
			if (GetIsObjectValid(oTaskWP)) SetLocalInt(oTaskWP, "AI_Inuse", 0);
			oTaskWP = LEG_AI_ChooseNPCTask();
			LEG_AI_SetNextTaskTime();
		}
		else if (GetLocalInt(oNPC, "AI_ChooseNewWP"))
		{
			// If we are continuing our task at another location.
			if (GetIsObjectValid(oTaskWP))
				SetLocalInt(oTaskWP, "AI_Inuse", 0);
			SetLocalInt(oNPC, "AI_ChooseNewWP", 0);
			oTaskWP = LEG_AI_ChooseNPCTask(GetLocalInt(oNPC, "AI_CurrentTask"));
		}
		
		if (GetIsObjectValid(oTaskWP))
		{
			// I have a task, am I at the location yet?
			if (GetDistanceToObject(oTaskWP) > 1.0)
			{
				// Keep going to it
				LEG_AI_CheckHome();
			}
			else
			{
				// I am here, keep doing what I do.
				LEG_AI_PerformTask();
			}
		}
	}
    else if (GetHenchOption(HENCH_OPTION_DISABLE_HB_DETECTION) || !GetIsObjectValid(GetNearestSeenOrHeardEnemyNotDead(GetHenchOption(HENCH_OPTION_DISABLE_HB_HEARING))))
    {
        if (GetLocalInt(oNPC, sHenchLastHeardOrSeen))
        {
			//Jug_Debug(GetName(oNPC) + " in determine combat section");
			if (!GetIsInCombat())
				ClearEnemyLocation();
			
            // continue to move to target
	        if (GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL))
	        {
	            HenchDetermineSpecialBehavior();
	        }
			else
			{
	        	HenchDetermineCombatRound();
			}
        }
        else
        {
			if (!GetIsObjectValid(GetNearestSeenOrHeardEnemyNotDead(FALSE)))
			{
	        	CleanCombatVars();
	            SetLocalInt(oNPC, HENCH_AI_SCRIPT_POLL, FALSE);
	            if (DoStealthAndWander())
	            {
					//Jug_Debug(GetName(oNPC) + " stealth");
	                // nothing to do here
	            }
	            // sometimes waypoints are not initialized
	            else if (GetWalkCondition(NW_WALK_FLAG_CONSTANT))
	            {
					//Jug_Debug(GetName(oNPC) + " walkwaypoints");
					if (!GetIsInCombat())
					{
						WalkWayPoints(TRUE, "heartbeat");
						LEG_AI_OnHeartbeat();
					}
					else LEG_AI_OnHeartbeat_Combat();
	            }
	            else
	            {
	                if(!IsInConversation(oNPC))
	                {
	                    if(GetSpawnInCondition(NW_FLAG_AMBIENT_ANIMATIONS) ||
	                        GetSpawnInCondition(NW_FLAG_AMBIENT_ANIMATIONS_AVIAN))
	                    {
							// For sleeping at night.
							int iConstantSleep = GetLocalInt(oNPC, "AI_ConstantSleep");
					        if(GetSpawnInCondition(NW_FLAG_SLEEPING_AT_NIGHT) || iConstantSleep)
					        {
							    if((GetIsNight() && !GetLocalInt(oNPC, "Retreat_Mode")) || (GetIsDawn() && !GetLocalInt(oNPC, "Retreat_Mode")) || iConstantSleep)
							    {
									//Jug_Debug(GetName(oNPC) + " in sleep section mobile ambient");
						            string sScript = GetLocalString(GetModule(),"X2_S_SLEEP_AT_NIGHT_SCRIPT");
						            if (sScript != "")
						            {
										AddScriptParameterInt(iConstantSleep);
										AddScriptParameterInt(0);
										ExecuteScriptEnhanced(sScript, oNPC);
						            }
									if (!GetLocalInt(oNPC, "AI_SLEEP"))	LEG_AI_OnHeartbeat();
						        }
								else LEG_AI_OnHeartbeat();
							}
							else LEG_AI_OnHeartbeat();
	                    }
	                    else if(GetSpawnInCondition(NW_FLAG_IMMOBILE_AMBIENT_ANIMATIONS))
	                    {
							// For sleeping at night.
							int iConstantSleep = GetLocalInt(oNPC, "AI_ConstantSleep");
					        if(GetSpawnInCondition(NW_FLAG_SLEEPING_AT_NIGHT) || iConstantSleep)
					        {
							    if((GetIsNight() && !GetLocalInt(oNPC, "Retreat_Mode")) || (GetIsDawn() && !GetLocalInt(oNPC, "Retreat_Mode")) || iConstantSleep)
							    {
									//Jug_Debug(GetName(oNPC) + " in sleep section immobile ambient");
						            string sScript = GetLocalString(GetModule(),"X2_S_SLEEP_AT_NIGHT_SCRIPT");
						            if (sScript != "")
						            {
										AddScriptParameterInt(iConstantSleep);
										AddScriptParameterInt(0);
										ExecuteScriptEnhanced(sScript, oNPC);
						            }
									if (!GetLocalInt(oNPC, "AI_SLEEP"))	LEG_AI_OnHeartbeat();									
						        }
								else LEG_AI_OnHeartbeat();
							}
							else LEG_AI_OnHeartbeat();
	                    }
						else LEG_AI_OnHeartbeat();
	                }
	            }
			}
        }
    }
    else if (GetUseHeartbeatDetect())
    {
        //Jug_Debug(GetName(oNPC) + " starting combat round in heartbeat");
		//Jug_Debug(GetName(oNPC) + " LEG_AI combat heartbeat");
        //Jug_Debug("*****" + GetName(oNPC) + " heartbeat action " + IntToString(GetCurrentAction()));
	  	LEG_AI_OnHeartbeat_Combat();
		if (!GetLocalInt(oNPC, "Retreat_Mode"))
		{
	        if (GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL))
	        {
	            HenchDetermineSpecialBehavior();
	        }
			else
			{
	        	HenchDetermineCombatRound();
			}
		}
    }						
	else
	{
		//Jug_Debug(GetName(oNPC) + " cleaning combat vars");
		if (GetLocalInt(oNPC, "Retreat_Mode"))
		{
			if (!GetIsInCombat()) LEG_AI_OnHeartbeat();
			else LEG_AI_OnHeartbeat_Combat();
		}
		else CleanCombatVars();
	}
	
    // Send the user-defined event signal if specified
    if(GetSpawnInCondition(NW_FLAG_HEARTBEAT_EVENT))
    {
         SignalEvent(oNPC, EventUserDefined(EVENT_HEARTBEAT));
    }

	// End of Default Stuff	
	
	// Last thing we want to do is to call our Master Death script!
	ExecuteScript("leg_all_masterheartbeat", oNPC);
	
}