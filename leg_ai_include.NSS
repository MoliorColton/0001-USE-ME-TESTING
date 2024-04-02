/*

    Script:			The AI include file.  This contains mostly functions for the heartbeat scripts.  The AI functions do
					things like equipping weapons and checking for range.
	Version:		2.0
	Plugin Version: 1.94
	Author:			Marshall Vyper
	Parameters:		None
	
	Change Log:		1.00 - 06/23/2011 - MV - Initial Version
					1.10 - 09/19/2011 - MV - Upgraded to support new Spawn Plugin v1.42
					1.2 - 09/27/2012 MV - Added option to turn off PLOT on retreat.
					1.3	- 10/13/2012 MV - Fixed bug with Banter and AI combo
					1.4 - 11/04/2012 MV - Added support for unequipping before NPC Actions
					1.5	- 11/11/2012 MV - Moved master include to NPC Actions as that script needed it.
					1.6 - 11/14/2012 MV - Added 3 new NPC activities
					1.7 - 05/31/2015 MV - Added support for Quest SE plugin to adjust run rate
					1.8 - 06/07/2015 MV - Added support for plot override caused by the SE plugin.
					1.9 - 07/19/2015 MV - Enhanced Guards Mob Type and improved pathing to home point reducing stalls.
					2.0 - 07/24/2015 MV - Fixed bug when switching AI profiles with patrol routes.
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_ai_npcactions"
#include "ginc_wp"
#include "INC_GUI_BOSSBAR"


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// FUNCTION DECLARATIONS
// /////////////////////////////////////////////////////////////////////////////////////////////////////


// ///////////////////////////////////////////////////////////////////////////
// Uncivilized Mobile Animations ignoring STOP waypoints.  We use waypoints a 
// lot in our AI system and we leverage the built in quite a bit.  One handly 
// waypoint is called the STOP waypoint.  This waypoint causes NPC's to wander
// around an area visiting any STOP type waypoint they can find.  This function
// causes said NPC's to NOT pay attention to these STOP waypoints basically
// ignoring them.  Useful for monsters in an area that may contain STOP 
// waypoints for NPC's as well.  This is called by the function below it.
//	Returns: N/A
void LEG_AI_AnimActionPlayRandomUncivilized();

// ///////////////////////////////////////////////////////////////////////////
// Custom Mobile Animations to ignore STOP waypoints.  The standard 
// "PlayMobileAmbientAnimations" we use on both mobs and NPC's causes mobs to
// follow STOP waypoints.  We had to change this up and modify it so MOBS don't
// and NPC's do.  This function calls the function above.
//	Returns: N/A
void LEG_AI_PlayMobileAmbientAnimations();


// ///////////////////////////////////////////////////////////////////////////
// This function sets a variable on the Mob to tell it where it's home is
// located.  The Mob will return here when a fight is over or if it has to run
// away due to range constraints.
// object oMob				- The NPC/Monster that is having it's home set.
//	Returns: N/A
void LEG_AI_SetMobHome(object oMob);


// ///////////////////////////////////////////////////////////////////////////
// Handy function for removing effects on mobs.  We use a spell effect to
// increase speed of mobs when chasing players.  This can be used to remove 
// that effect.
// int nEffectTypeID		- The ID of the special effect type to remove
// object oTarget			- The target mob that we're removing it from.
//  Returns: N/A
void LEG_AI_RemoveSpecificEffect(int nEffectTypeID, object oTarget);


// ///////////////////////////////////////////////////////////////////////////
// When a mob has to run after a player, we give them a speed boost to help
// catch them and avoid being kited.
// string sDirection		- Change the speed "Up" or "Down"
//  Returns: N/A
void LEG_AI_ChangeSpeed(string sDirection);


// ///////////////////////////////////////////////////////////////////////////
// When a mob needs to go to their home location for whatever reason, we use
// this function to perform that task.  We can pass it a TRUE value in the
// iRun variable to cause them to run home vs. walk home.
// object oMob			- The Mob we want to make go home.
// int iRun				- TRUE if we want the mob to Run vs. Walk
//  Returns: N/A
void LEG_AI_GoHome(object oMob, int iRun);


// ///////////////////////////////////////////////////////////////////////////
// One of the major functions for AI.  We are checking to see where our home 
// location is when fired, and acting accordingly.  This could mean, continue
// milling about, move closer to our home location or other activities.
//  Returns: N/A
void LEG_AI_CheckHome();


// ///////////////////////////////////////////////////////////////////////////
// Now we move on to our custom heartbeat code.  I wonder if this should even
// be here or if it should be in the AI heartbeat script called by a Master
// Heart Beat script... All this does is call our major function up there about
// what to do each heartbeat.  If we're in Retreat Mode and heading hom, all
// we do is continue checking.  If however we are NOT in retreat mode anymore,
// then set our magically enhanced speed back to normal, then check. This is 
// called when we are NOT in combat.
//  Returns: N/A
void LEG_AI_OnHeartbeat();


// ///////////////////////////////////////////////////////////////////////////
// Same as above but called when we ARE in combat.  Yes, we are fighting.
// We speed up and check our home location. If we're in Retreat mode, we 
// back off everything else though.  Check our weapons and then look for friends
// to help out.
// object oBadGuy			- If a mob is passed, this is who we are fighting.
//  Returns: N/A
void LEG_AI_OnHeartbeat_Combat(object oBadGuy = OBJECT_INVALID);


// ///////////////////////////////////////////////////////////////////////////
// This is currently called by the Spawn Code.  It became it's own function 
// because it could prove valuable for other things.  It takes the animation
// passed and makes the target do it.
// object oPC				- The target that is performing the animation
// string sAnimation		- The animation sef file
// int iLoop				- If we are looping the animation
void LEG_AI_Animations(object oPC, string sAnimation, int iLoop = 1);


// ///////////////////////////////////////////////////////////////////////////
// Used to return an integer value of a grou for Item passed.  Groups are 
// outlined in the function itself.  Handy for grouping items into shields,
// 1handed weapons etc.
// int nItem				- Item Type ID that we want to group.
//  Returns: A Group number that is assigned to the item by type
int LEG_AI_GetBaseGroup(int nItem);


// ///////////////////////////////////////////////////////////////////////////
// Check's to see if Right Hand of OBJECT_SELF is empty or not.
//  Returns: TRUE if the Right hand is empty
int LEG_AI_GetIsRightHandEmpty();


// ///////////////////////////////////////////////////////////////////////////
// Check's to see if Left Hand of OBJECT_SELF is empty or not.
//  Returns: TRUE if the Left hand is empty
int LEG_AI_GetIsLeftHandEmpty();


// ///////////////////////////////////////////////////////////////////////////
// This function causes the player to equip a 1 handed weapon from their
// inventory provided they are not already wielding one.
//  Returns: N/A
void LEG_AI_EquipWeapon();


// ///////////////////////////////////////////////////////////////////////////
// This function causes the player to equip a ranged weapon from their
// inventory provided they are not already wielding one.
//  Returns: N/A
void LEG_AI_EquipRangeWeapon();


// ///////////////////////////////////////////////////////////////////////////
// This function causes the player to equip a 1 handed weapon from their
// inventory into their offhand.
//  Returns: N/A
void LEG_AI_EquipOffWeapon();


// ///////////////////////////////////////////////////////////////////////////
// This function causes the player to equip a 2 handed weapon from their
// inventory provided they are not already wielding one.
//  Returns: N/A
void LEG_AI_EquipTwoHandWeapon();


// ///////////////////////////////////////////////////////////////////////////
// This function causes the player to equip a shield from their
// inventory provided they are not already wearing one.
//  Returns: N/A
void LEG_AI_EquipShield();


// ///////////////////////////////////////////////////////////////////////////
// This function performs a check for weapons and equips appropriately. If 
// an enemy exists, and is more than 10 meters away, we switch to ranged.
// object oTarget		- Our current target if we have one.
//	Returns: N/A
void LEG_AI_WeaponsCheck(object oTarget = OBJECT_INVALID);


// ///////////////////////////////////////////////////////////////////////////
// This is called during spawn.  The only real difference between this and 
// the above is that we're not determining combat round.  Other than that, 
// it's pretty much the same thing.  We're also setting up our ready variable
// to let the other parts of the AI know we've finished spawning and are ready
// to go.
// object oTarget			- If I have a target, check range, I may use it.
//  Returns: N/A
void LEG_AI_Equip(object oTarget = OBJECT_INVALID);



// /////////////////////////////////////////////////////////////////////////////////////////////////////
// FUNCTIONS
// /////////////////////////////////////////////////////////////////////////////////////////////////////


void SJS_DebugShout(string sParentTag, string sMessage)
{
	return;
	object oMob = GetObjectByTag("SPAWN_" + sParentTag);
	oMob = GetObjectByTag(sParentTag);
	if (GetIsObjectValid(oMob))
		AssignCommand(oMob, SpeakString(sMessage, TALKVOLUME_SHOUT));
	else
		SpeakString("Mob is not valid.", TALKVOLUME_SHOUT);

}


// //////////////////////////////////////////////////
// LEG_AI_AnimActionPlayRandomUncivilized
// //////////////////////////////////////////////////
void LEG_AI_AnimActionPlayRandomUncivilized()
{
	// Perform a Random Walk 5 out of 6 times.
    int nRoll = Random(6);
    if (nRoll != 5) {
        ClearActions(CLEAR_X0_I0_ANIMS_AnimActionPlayRandomUncivilized);
        ActionRandomWalk();
    }

    // Play one of our few random animations
    AnimActionPlayRandomBasicAnimation();
}



// //////////////////////////////////////////////////
// LEG_AI_PlayMobileAmbientAnimations
// //////////////////////////////////////////////////
void LEG_AI_PlayMobileAmbientAnimations()
{

    if (!GetAnimationCondition(NW_ANIM_FLAG_INITIALIZED)) {
        // General initialization
        AnimInitialization();

        // Mark us as mobile
        SetAnimationCondition(NW_ANIM_FLAG_IS_MOBILE);
    }

    // Short-circuit everything if we're not active yet
    if (!GetAnimationCondition(NW_ANIM_FLAG_IS_ACTIVE))
        return;

    // Check if we should turn off
    if (!CheckIsAnimActive(OBJECT_SELF))
        return;

    //SpawnScriptDebugger();
    int nCurrentAction = GetCurrentAction();

    // Check current actions so we don't interrupt something in progress
    // Feb 14 2003: Because of the random walkthere needs to be a chance
    //  to stop walking.
    // May 26 2004: Added ACTION_RANDOMWALK to the exclusion list.
    if (CheckCurrentAction() && (nCurrentAction != ACTION_MOVETOPOINT)&& (nCurrentAction != ACTION_WAIT) && (nCurrentAction != ACTION_RANDOMWALK)) {
        return;
    }

    // Go someplace safe and rest if we are hurt
    if (AnimActionRest()) {
        //AnimDebug("resting");
        return;
    }

    // Check if current modes should change
    CheckCurrentModes();
    LEG_AI_AnimActionPlayRandomUncivilized();
}




// //////////////////////////////////////////////////
// LEG_AI_SetMobHome
// //////////////////////////////////////////////////
void LEG_AI_SetMobHome(object oMob)
{
	// Set the AI Variable for home location.
	location lHome = GetLocation(oMob);
	
	// Set Home Location for All AI Except NPC Actions
	SetLocalLocation(oMob, "LEG_AI_HomeLocation", lHome);
	
	// Set Facing for guards
	SetLocalFloat(oMob, "AI_Facing", GetFacing(oMob));
	
	// New Systems for NPC Intelligent Waypoint Selection.
	if (GetLocalInt(oMob, "LEG_AI_MobType") == 7 && !GetIsInCombat())
	{
		// Delete old Home iPoint if there was one.
		object oOldHome = GetLocalObject(oMob, "LEG_AI_IPHome");
		if (GetIsObjectValid(oOldHome))
			DestroyObject(oOldHome);
	    
		// Create and save new home.
		object oHome = CreateObject(OBJECT_TYPE_PLACEABLE, "leg_ai_home", lHome, FALSE);
		SetLocalObject(oMob, "LEG_AI_IPHome", oHome);
	}
}




// //////////////////////////////////////////////////
// LEG_AI_RemoveSpecificEffect
// //////////////////////////////////////////////////
void LEG_AI_RemoveSpecificEffect(int nEffectTypeID, object oTarget)
{
    //Declare major variables
    //Get the object that is exiting the AOE
    int bValid = FALSE;
    effect eAOE;
    //Search through the valid effects on the target.
    eAOE = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eAOE))
    {
        if (GetEffectType(eAOE) == nEffectTypeID)
        {
            //If the effect was created by the spell then remove it
            bValid = TRUE;
            RemoveEffect(oTarget, eAOE);
        }
        //Get next effect on the target
        eAOE = GetNextEffect(oTarget);
    }
}




// //////////////////////////////////////////////////
// LEG_AI_ChangeSpeed
// //////////////////////////////////////////////////
void LEG_AI_ChangeSpeed(string sDirection)
{
    effect eSpeedUp = EffectMovementSpeedIncrease(99);
    if (sDirection == "Up")
    {
        if (GetLocalInt(OBJECT_SELF, "FastSpeed"))  return;
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSpeedUp, OBJECT_SELF);
        SetLocalInt(OBJECT_SELF, "FastSpeed", TRUE);
    }
    else
    {
        if (!GetLocalInt(OBJECT_SELF, "FastSpeed"))  return;
        LEG_AI_RemoveSpecificEffect(EFFECT_TYPE_MOVEMENT_SPEED_INCREASE, OBJECT_SELF);
        SetLocalInt(OBJECT_SELF, "FastSpeed", FALSE);
    }


}




// //////////////////////////////////////////////////
// LEG_AI_GoHome
// //////////////////////////////////////////////////
void LEG_AI_GoHome(object oMob, int iRun)
{
	// If my movement speed was artificially inflated or deflated due to the Legends Quest SE plugin, account for it here.
	if (GetLocalInt(OBJECT_SELF, "LEG_QUEST_SE_Run"))
		iRun = TRUE;

	// Get moving...quick.
	ActionForceMoveToLocation(GetLocalLocation(oMob, "LEG_AI_HomeLocation"), iRun, 15.0);
	
	// I am enroute to home
	SetLocalInt(OBJECT_SELF, "AI_EnRoute", 1);
	
	// Set My current location
	SetLocalLocation(OBJECT_SELF, "AI_MyLocation", GetLocation(OBJECT_SELF));
}




// //////////////////////////////////////////////////
// LEG_AI_CheckHome
// //////////////////////////////////////////////////
void LEG_AI_CheckHome()
{
    // This is the stuck counter.  If a mob is on his way home, but he's stuck,
    // then we can use this as a trigger to port him.  Be careful of patrollers
    int iStuckCounter = 0;

    // If this PC is a PLOT PC currently for questing purposes, then lets not take off the plot
    // flag.  Every quest NPC has this variable on them so we don't want that changed.  Quest NPC's
	// can't be killed in our AI.
    int iPlot;
    if (GetLocalInt(OBJECT_SELF, "LEG_QUEST_NPCID_1") || GetLocalInt(OBJECT_SELF, "LEG_QUEST_SE_PlotOverride"))
        iPlot = TRUE;
    else
        iPlot = FALSE;

    // First we see if we've gone too far from our home point by getting the distance bettwen our current
	// location and where our home point is stored.
    float fCurrentDistance = GetDistanceBetweenLocations(GetLocation(OBJECT_SELF), GetLocalLocation(OBJECT_SELF, "LEG_AI_HomeLocation"));
    float fRange;
    int iRun;

	// Look up on ourselves to find out how far we are allowed to mill about from our home location.
	fRange = GetLocalFloat(OBJECT_SELF, "LEG_AI_MillRange");
	
    // Check and see if I am in Retreat Mode or Milling about or on a patrol route, my Decision range is R.
	// If I am Retreating, my range is going to be 5.0 meters from home point.  If I am not retreating and I
	// am milling about (not combat), my range is going to be 5.0 meters as well.
    if (GetLocalInt(OBJECT_SELF, "LEG_AI_Retreat_Mode") || GetIsInCombat() == FALSE)
	{
		if (fRange == 0.0)
            fRange = 1.0;
	}
    // If I got here, then I am in a fight and not currently retreating, could be out of range, dunno yet.
    else
	{
		// So looks like I am fighting and not in retreat mode.  Let's set my Range so I can be sure
		// I don't go outside of it.. now swing!  If I am inside, my combat range is going to be 15.0
		// meters.  If I am outside, my combat range is going to be 30.0 meters.  Note that I can travel
		// an extra 5-10 meters as this function is probably only called every heartbeat.. that means that
		// if this is fired right at 30.0 meters, then I can travel for 6 more seconds before this is checked
		// again.
		if (GetIsAreaInterior(GetArea(OBJECT_SELF)))
            fRange = IntToFloat(GetLocalInt(OBJECT_SELF, "LEG_AI_InteriorRunRange"));
		else
			fRange = IntToFloat(GetLocalInt(OBJECT_SELF, "LEG_AI_ExteriorRunRange"));
	}

	// Double check we have "something"
	if (fRange <= 0.0)
		fRange = 50.0;
		
	// Now find out if I am within range of my home point or not.  If I'm out of my area, I'm definatly out.
	// We've done everything to ensure mobs don't leave their area.  Don't forget, because of the nature of
	// the heartbeat, this is only checked every 6 seconds.  A Mob can travel far in 6 seconds so may be
	// further than their fRange!
    if (fCurrentDistance > fRange || GetArea(OBJECT_SELF) != GetAreaFromLocation(GetLocalLocation(OBJECT_SELF, "LEG_AI_HomeLocation")) || (GetLocalInt(OBJECT_SELF, "Retreat_Mode") && fCurrentDistance > 5.0))
    {
		// If the Mob is in battle, and it reaches its range, its going to Run Home.  When its running
        // home, we don't want to allow new perceptions to interfere.  If we are WALKING home however,
        // then perceptions are fine to allow.  
        if (GetIsInCombat())
        {
			if (!GetLocalInt(OBJECT_SELF, "LEG_AI_NoPlot"))
			{
            	SetPlotFlag(OBJECT_SELF, TRUE);
			}
            SetLocalInt(OBJECT_SELF, "Retreat_Mode", TRUE);
            iRun = TRUE;
			// If the BANTER plugin is active, let's say something!
			if (GetLocalInt(GetModule(), "LEG_BANTER_ACTIVE"))
			{
				AddScriptParameterString("");
				AddScriptParameterInt(GetLocalInt(OBJECT_SELF, "LEG_BANTER_AIRangeChance"));
				AddScriptParameterString("LegAIRange");
				ExecuteScriptEnhanced("leg_banter_speak", OBJECT_SELF);	
			}
        }
        else
        {
			// If this flag is on, then we WERE in combat because thats the only way this gets turned on.
			// If we WERE in combat, that means we need to get home no matter what so keep the Plot flag up
			// and the Retreat Mode on.  Once we get home, the retreat mode turns off.  That said, if we
			// simply wandered out of our range, and we weren't fighting, then its ok to walk home with no
			// retreat flag or plot flag.
			if (!GetLocalInt(OBJECT_SELF, "Retreat_Mode"))
			{
				// Remember only set FALSE on plot if we're not a quest NPC!
		        if (!iPlot)
		            SetPlotFlag(OBJECT_SELF, FALSE);
	            iRun = FALSE;
			}
        }

        // Clear my actions and send me home.  Only if I'm out of range of course.
        if (GetCurrentAction(OBJECT_SELF) == ACTION_MOVETOPOINT || GetLocalInt(OBJECT_SELF, "AI_EnRoute"))
        {
			// I'm supposed to be en-route but I've seen it where the slacker NPC doesn't actually move.  So what's the
			// deal.  Am I REALLY enroute?
			if(GetLocalInt(OBJECT_SELF, "AI_EnRoute"))
			{
				// Am I travelling at all?
				location lmyLocation = GetLocation(OBJECT_SELF);
				if (lmyLocation == GetLocalLocation(OBJECT_SELF, "AI_MyLocation"))
				{
					LEG_AI_GoHome(OBJECT_SELF, iRun);
				}
				SetLocalLocation(OBJECT_SELF, "AI_MyLocation", lmyLocation);
			}
            SetLocalInt(OBJECT_SELF, "StuckCounter", 0);
			SJS_DebugShout("c_goblin0", "I'm moving to my home point RIGHT NOW!!  No need to clear me.");
        }
        else
        {
			// SO.. I am out of range, I know it, you know it, I am not on my way home.. what do I do?  First let's
			// advance my stuck counter by 1.. after all, I'm not on my way am I?
            SetLocalInt(OBJECT_SELF, "StuckCounter", GetLocalInt(OBJECT_SELF, "StuckCounter") + 1);
			SJS_DebugShout("c_goblin0", "I NEED to go home, but I'm not doing it, Clear my actions.");
            
			// Considering I am NOT on my way, then stop whatever it is I am doing!
			ClearAllActions(TRUE);
			
            // If Stuck Counter reachs 5 rounds (~30 seconds, port them)
            if (GetLocalInt(OBJECT_SELF, "StuckCounter") >= 5)
            {
				SJS_DebugShout("c_goblin0", "Jumping Home.");
                SetLocalInt(OBJECT_SELF, "StuckCounter", 0);
                ActionJumpToLocation(GetLocalLocation(OBJECT_SELF, "LEG_AI_HomeLocation"));
                // Now that we're home via jump, lets heal right away.
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints() - GetCurrentHitPoints()), OBJECT_SELF);
				ForceRest(OBJECT_SELF);
            }
			
			// Ok I am not stuck too long, but I am not on my way home either.. so GO HOME!  Note that this won't
			// fire if I am in ACTION_MOVETOPOINT which we're not 100% sure what that means.
	        LEG_AI_GoHome(OBJECT_SELF, iRun);
		}
    }
	
	// Ok that takes care of what we're doing if we're OUT of range.. do we need to do stuff if
	// we are WITHIN range? If we are within range of our home point.  That range could be 50 or 3 depending on if
    // I am in combat or not.  If I'm running home because I hit my range during combat, I should head home no 
	// matter what.  That's important because my range could be 50 but I may be inside it, but not yet home.  Hmmm...
    else if(fCurrentDistance <= fRange)
    {
		SJS_DebugShout("c_goblin0", "I am at my Home Point.");
		// If I am Not in combat but within range.. heal up!
        if (!GetIsInCombat())
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints() - GetCurrentHitPoints()), OBJECT_SELF);
			//ForceRest(OBJECT_SELF);
        }

        // If I'm am JUST coming out of a retreat, and I'm not in combat any more, then
        // do one more DetermineCombatRound to ensure there's no one around.
		// Having this on normally messes up patrollers, so we'll do it at the end of a 
		// retreat.
        if (GetLocalInt(OBJECT_SELF, "Retreat_Mode"))
		{
            //HenchDetermineCombatRound();
			DetermineCombatRound();
		}
		
		if (GetLocalString(OBJECT_SELF, "LEG_AI_WalkRoute") == "" && !GetLocalInt(OBJECT_SELF, "Retreat_Mode"))
		{
            //HenchDetermineCombatRound();
			DetermineCombatRound();
		}

		// So we're within range, we've been healed up.  Let's ensure we are no longer retreating and turn plot off.
        SetLocalInt(OBJECT_SELF, "StuckCounter", 0);
        SetLocalInt(OBJECT_SELF, "Retreat_Mode", FALSE);
        if (!iPlot)
            SetPlotFlag(OBJECT_SELF, FALSE);

		// If we're not in combat...
		if (!GetIsInCombat())
		{
			if (GetLocalString(OBJECT_SELF, "LEG_AI_WalkRoute") == "" && GetLocalInt(OBJECT_SELF, "LEG_AI_MobType") != 4)
			{
				// I am not enroute anywhere
				SetLocalInt(OBJECT_SELF, "AI_EnRoute", 0);
				
				// I am within home range so go ahead and play some animations
				if(GetSpawnInCondition(NW_FLAG_AMBIENT_ANIMATIONS))
				{
					// Am I Civilized or a wandering glob of raging fear.  If I am Civil, then I am
					// going to use STOP waypoints!  If I am not CIVIL then I won't.
					if (GetLocalInt(OBJECT_SELF, "AMCIVIL"))
					{
						//if (GetCurrentAction(OBJECT_SELF) != ACTION_MOVETOPOINT)
							PlayMobileAmbientAnimations();
					}
					else
					{
						//if (!GetCurrentAction(OBJECT_SELF) == ACTION_MOVETOPOINT)
							LEG_AI_PlayMobileAmbientAnimations();
					}
				}
				else if(GetSpawnInCondition(NW_FLAG_IMMOBILE_AMBIENT_ANIMATIONS))
					//if (!GetCurrentAction(OBJECT_SELF) == ACTION_MOVETOPOINT)
						PlayImmobileAmbientAnimations();
			}
			else if(GetLocalInt(OBJECT_SELF, "LEG_AI_MobType") == 4)
			{
				// Maybe I'm a guard?
				SetFacing(GetLocalFloat(OBJECT_SELF, "AI_Facing"));
			}
			
		}
		else
		{
			// I am not enroute anywhere because I'm in combat
			SetLocalInt(OBJECT_SELF, "AI_EnRoute", 0);
		}
    }
}




// //////////////////////////////////////////////////
// LEG_AI_OnHeartbeat
// //////////////////////////////////////////////////
void LEG_AI_OnHeartbeat()
{
	if (!GetLocalInt(OBJECT_SELF, "Retreat_Mode"))
		LEG_AI_ChangeSpeed("Down");

	SJS_DebugShout("c_goblin0", "Firing Check Home");
	// I don't want to wander and stuff if I am sleeping.
	if (!GetLocalInt(OBJECT_SELF, "AI_SLEEP"))
		LEG_AI_CheckHome();
}




// //////////////////////////////////////////////////
// LEG_AI_OnHeartbeat_Combat
// //////////////////////////////////////////////////
void LEG_AI_OnHeartbeat_Combat(object oBadGuy = OBJECT_INVALID)
{
    LEG_AI_ChangeSpeed("Up");
    LEG_AI_CheckHome();

	if (GetLocalInt(oBadGuy, "REST_REZEFFECTS"))
		return;
		
    if (GetLocalInt(OBJECT_SELF, "Retreat_Mode"))
		return;
 		
	// I am not enroute anywhere because I'm probably in combat
	SetLocalInt(OBJECT_SELF, "AI_EnRoute", 0);
		
	// I'm in combat, let's call some friends that I may be linked with.  Note this only works in conjunction
	// with the SPAWN plugin.
	if (GetLocalInt(GetModule(), "LEG_SPAWN_ACTIVE"))
	{
		
		// Where is my spawn point?  Oh it's stored on me!  YAY!
		object oMyGroupPoint = GetLocalObject(OBJECT_SELF, "SPAWN_Parent");
		
		// Now that I have my waypoint, let's get the name without the counter.  The Spawn plugin denotes that
		// we place a counter on groups of them.
		string sWaypointGroup = GetStringLeft(GetTag(oMyGroupPoint), GetStringLength(GetTag(oMyGroupPoint)) - 2);
		int iWPCount = 1;
		object oFriend;
		object oWP = GetWaypointByTag(sWaypointGroup + "01");
		string sWPCount;

		// Using the main tag of the spawnpoint along with the 01 counter, we can find out the PARENT spawn point
		// of the entire group.  This is the master spawn point with all the variables on it.
		while (GetIsObjectValid(oWP))
		{
			// All mobs are stored on the WP now.
			string sCountType = GetLocalString(oWP, "LEG_SPAWN_Count");
			int iTotalCount;
			if (sCountType == "Full")
			{
				string sParentID = GetLocalString(oWP, "LEG_SPAWN_ParentID");
				iTotalCount = LEG_COMMON_GetArrayElementCount(oWP, sParentID + "ResRef");
			}
			else
				iTotalCount = GetLocalInt(oWP, "LEG_SPAWN_CountTotal");
			int iFriends = GetLocalInt(oWP, "LEG_SPAWN_Friends");
			int iSpawnCount = 0;
			
			if (iFriends)
			{
				// See how many spawns are alive.
				int iIndex = 1;
				for (iIndex = 1; iIndex <= iTotalCount; iIndex++)
				{
					oFriend = GetLocalObject(oWP, "SPAWN_" + IntToString(iIndex));
					if (GetIsObjectValid(oFriend))
					{
						// That spawn point has a child.
						if (oFriend != OBJECT_SELF)
						{
							// That child is NOT in combat!  Get over here!  Well not yet, we basically tell this mob
							// that we have a friend in need and store our friend.
							if (!GetIsInCombat(oFriend))
							{
								SetLocalInt(oFriend, "FriendInNeed", 1);
								SetLocalObject(oFriend, "MyFriend", OBJECT_SELF);
							}
						}
					}
				}
			}
			
			// Cycle through all the waypoints in the group.
			iWPCount++;
			if (iWPCount < 10)
				sWPCount = "0" + IntToString(iWPCount);
			else
				sWPCount = IntToString(iWPCount);
				
			oWP = GetWaypointByTag(sWaypointGroup + sWPCount);
		}
	}
}



// //////////////////////////////////////////////////
// LEG_AI_Animations
// //////////////////////////////////////////////////
void LEG_AI_Animations(object oPC, string sAnimation, int iLoop = 1)
{
	PlayCustomAnimation(oPC, sAnimation, iLoop);
}



// //////////////////////////////////////////////////
// LEG_AI_GetBaseGroup
// //////////////////////////////////////////////////
int LEG_AI_GetBaseGroup(int nItem)
{
    // 0 - Non-equippable items
    // 1 - Shields
    // 2 - One handed weapons
    // 3 - Two handed weapons
    // 4 - Torch
    // 5 - Ranged Weapon
    int nValue = 0;
    switch (nItem ) {
    //Shield group - usable in off hand only.
    case BASE_ITEM_SMALLSHIELD:
    case BASE_ITEM_TOWERSHIELD:
    case BASE_ITEM_LARGESHIELD:
        nValue = 1;
        break;
    //One handed weapons
    case BASE_ITEM_BASTARDSWORD:
    case BASE_ITEM_BATTLEAXE:
    case BASE_ITEM_CLUB:
    case BASE_ITEM_DAGGER:
    case BASE_ITEM_HANDAXE:
    case BASE_ITEM_KAMA:
    case BASE_ITEM_KATANA:
    case BASE_ITEM_KUKRI:
    case BASE_ITEM_LIGHTFLAIL:
    case BASE_ITEM_LIGHTHAMMER:
    case BASE_ITEM_LIGHTMACE:
    case BASE_ITEM_LONGSWORD:
    case BASE_ITEM_RAPIER:
    case BASE_ITEM_SCIMITAR:
    case BASE_ITEM_SHORTSWORD:
    case BASE_ITEM_MORNINGSTAR:
    case BASE_ITEM_SICKLE:
    case BASE_ITEM_WARHAMMER:
        nValue = 2;
        break;
    //Two Handed Weapons
    case BASE_ITEM_GREATSWORD:
    case BASE_ITEM_DIREMACE:
    case BASE_ITEM_DOUBLEAXE:
    case BASE_ITEM_GREATAXE:
    case BASE_ITEM_HALBERD:
    case BASE_ITEM_HEAVYFLAIL:
    case BASE_ITEM_QUARTERSTAFF:
    case BASE_ITEM_SCYTHE:
    case BASE_ITEM_SHORTSPEAR:
    case BASE_ITEM_TWOBLADEDSWORD:
	case BASE_ITEM_SPEAR:
        nValue = 3;
        break;
    case BASE_ITEM_TORCH:
        nValue = 4;
        break;
    case BASE_ITEM_LIGHTCROSSBOW:
    case BASE_ITEM_HEAVYCROSSBOW:
    case BASE_ITEM_DART:
    case BASE_ITEM_SHURIKEN:
    case BASE_ITEM_THROWINGAXE:
    case BASE_ITEM_LONGBOW:
    case BASE_ITEM_SHORTBOW:
    case BASE_ITEM_SLING:
        nValue = 5;

    }
    return nValue;
}



// //////////////////////////////////////////////////
// LEG_AI_GetIsRightHandEmpty
// //////////////////////////////////////////////////
int LEG_AI_GetIsRightHandEmpty()
{
    object objInHand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
    if(objInHand == OBJECT_INVALID)
    {
        return TRUE;
    }
    else return FALSE;
}




// //////////////////////////////////////////////////
// LEG_AI_GetIsLeftHandEmpty
// //////////////////////////////////////////////////
int LEG_AI_GetIsLeftHandEmpty()
{
    object objInHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
    if(objInHand == OBJECT_INVALID)
    {
        return TRUE;
    }
    else return FALSE;
}



// //////////////////////////////////////////////////
// LEG_AI_EquipWeapon
// //////////////////////////////////////////////////
void LEG_AI_UnEquipWeapons()
{
	// If I have nothing in my weapon hand or if I have a different type of weapon equipped.
    if (LEG_AI_GetIsRightHandEmpty() != TRUE)
    {
        object objInHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
		ActionUnequipItem(objInHand);
        objInHand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
		ActionUnequipItem(objInHand);
    }
    return;
}


// //////////////////////////////////////////////////
// LEG_AI_EquipWeapon
// //////////////////////////////////////////////////
void LEG_AI_EquipWeapon()
{
	// If I have nothing in my weapon hand or if I have a different type of weapon equipped.
    if (LEG_AI_GetIsRightHandEmpty() == TRUE || GetLocalInt(OBJECT_SELF, "MOB_CurrentWeapon") != 2)
    {
        object objInv;
        //start getting the inventory items
        objInv = GetFirstItemInInventory();
        //If there was no inventory item to get quit looking.
        while( objInv !=  OBJECT_INVALID )
        {
            if(LEG_AI_GetBaseGroup(GetBaseItemType(objInv)) == 2)
            {
                //Found a weapon so equip it
                ActionEquipItem( objInv, INVENTORY_SLOT_RIGHTHAND );
                SetLocalInt(OBJECT_SELF, "MOB_CurrentWeapon", 2);
                break;
            }
            objInv = GetNextItemInInventory();
        }
    }
    return;
}

// //////////////////////////////////////////////////
// LEG_AI_EquipRangeWeapon
// //////////////////////////////////////////////////
void LEG_AI_EquipRangeWeapon()
{
	// Of course only equip if my hand is empty of if I have a differnt weapon type.
    if(LEG_AI_GetIsRightHandEmpty() == TRUE || GetLocalInt(OBJECT_SELF, "MOB_CurrentWeapon") != 5)
    {
        object objInv;
        //start getting the inventory items
        objInv = GetFirstItemInInventory();
        //If there was no inventory item to get quit looking.
        while( objInv !=  OBJECT_INVALID )
        {
            if(LEG_AI_GetBaseGroup( GetBaseItemType( objInv ) ) == 5 )
            {
                //Found a weapon so equip it
                ActionEquipItem( objInv, INVENTORY_SLOT_RIGHTHAND );
                SetLocalInt(OBJECT_SELF, "MOB_CurrentWeapon", 5);
                break;
            }
            objInv = GetNextItemInInventory();
        }
    }
    return;
}


// //////////////////////////////////////////////////
// LEG_AI_EquipOffWeapon
// //////////////////////////////////////////////////
void LEG_AI_EquipOffWeapon()
{
    if(LEG_AI_GetIsLeftHandEmpty() == TRUE )
    {
        object objInv;
        //start getting the inventory items
        objInv = GetFirstItemInInventory();
        //If there was no inventory item to get quit looking.
        while( objInv !=  OBJECT_INVALID )
        {
            if(LEG_AI_GetBaseGroup( GetBaseItemType( objInv ) ) == 2 )
            {
                //Found a weapon so equip it
                ActionEquipItem( objInv, INVENTORY_SLOT_LEFTHAND );
                break;
            }
            objInv = GetNextItemInInventory();
        }
    }
    return;
}




// //////////////////////////////////////////////////
// LEG_AI_EquipTwoHandWeapon
// //////////////////////////////////////////////////
void LEG_AI_EquipTwoHandWeapon()
{
    if (LEG_AI_GetIsRightHandEmpty() == TRUE || GetLocalInt(OBJECT_SELF, "MOB_CurrentWeapon") != 3)
    {
        object objInv;
        //start getting the inventory items
        objInv = GetFirstItemInInventory();
        //If there was no inventory item to get quit looking.
        while( objInv !=  OBJECT_INVALID )
        {
            //check and see if it's a weapon, shield or other.
            if(LEG_AI_GetBaseGroup( GetBaseItemType( objInv ) ) == 3 )
            {
                //Found a weapon so equip it
                ActionEquipItem( objInv, INVENTORY_SLOT_RIGHTHAND );
                SetLocalInt(OBJECT_SELF, "MOB_CurrentWeapon", 3);
                break;
            }
            objInv = GetNextItemInInventory();
        }
    }
    return;
}


// //////////////////////////////////////////////////
// LEG_AI_EquipShield
// //////////////////////////////////////////////////
void LEG_AI_EquipShield()
{
    if(LEG_AI_GetIsLeftHandEmpty() == TRUE )
    {
        object objInv;
        //start getting the inventory items
        objInv = GetFirstItemInInventory();
        //If there was no inventory item to get quit looking.
        while( objInv !=  OBJECT_INVALID )
        {
            //check and see if it's a weapon, shield or other.
            if(LEG_AI_GetBaseGroup( GetBaseItemType( objInv ) ) == 1 )
            {
                //Found a weapon so equip it
                ActionEquipItem( objInv, INVENTORY_SLOT_LEFTHAND );
                break;
            }
            objInv = GetNextItemInInventory();
        }
    }
    return;
}


// //////////////////////////////////////////////////
// LEG_AI_WeaponsCheck
// //////////////////////////////////////////////////
void LEG_AI_WeaponsCheck(object oTarget = OBJECT_INVALID)
{
    if (GetIsObjectValid(oTarget))
    {
        if(GetDistanceToObject(oTarget) > 10.0)
        {
            LEG_AI_EquipRangeWeapon();
			//HenchDetermineCombatRound();
			DetermineCombatRound();
        }
        else
        {
			// First equip my shield if I have one.
            LEG_AI_EquipShield();
			
			// Next equip my two handed weapon if I have one.  Chances are, if I have one of
			// these, I don't have a shield.
            LEG_AI_EquipTwoHandWeapon();
			
			// Now equip my one hander.  If I have one of these, I probably don't have a two hander.
            LEG_AI_EquipWeapon();
			
			// If I have 2 1 handed melee weapons in my inventory, then guess what, the second one is going
			// in my other hand.
			LEG_AI_EquipOffWeapon();
			
			// Now let's get ready to rumble!
			//HenchDetermineCombatRound();
			DetermineCombatRound();
        }

	}

}

// //////////////////////////////////////////////////
// LEG_AI_Equip
// //////////////////////////////////////////////////
void LEG_AI_Equip(object oTarget = OBJECT_INVALID)
{
	ClearAllActions();
    if (GetIsObjectValid(oTarget))
    {
        if(GetDistanceToObject(oTarget) > 5.0 || GetCombatCondition(X0_COMBAT_FLAG_RANGED))
            LEG_AI_EquipRangeWeapon();
        else
        {
            LEG_AI_EquipShield();
            LEG_AI_EquipTwoHandWeapon();
            LEG_AI_EquipWeapon();
        }
    }
    else
    {
		if (GetCombatCondition(X0_COMBAT_FLAG_RANGED))
		{
			LEG_AI_EquipRangeWeapon();
		}
		else		
        {
       		LEG_AI_EquipShield();
        	LEG_AI_EquipTwoHandWeapon();
        	LEG_AI_EquipWeapon();
		}
    }

    // If the Mob has just spawned, we want to ensure that they are not interupted by their own heartbeat
    // before they get set up.  So the heartbeat script will do a check for the READY varaible.  If its
    // False, then it will not fire.  The READY variable should be set to TRUE at the LAST thing the Mob
    // Needs to do before its ready.  In our case, that would be finishing equipping his weapons and shields.
    DelayCommand(1.0, SetLocalInt(OBJECT_SELF, "Ready", TRUE));
}




// //////////////////////////////////////////////////
// LEG_AI_InitRandomNPC
// //////////////////////////////////////////////////
void LEG_AI_InitRandomNPC(int iSetValue1, int iSetValue2)
{
	// Initialize all the selections an NPC can have into an array
	if (iSetValue1 & 1)				LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "1");
	if (iSetValue1 & 2)				LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "2");
	if (iSetValue1 & 4)				LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "3");
	if (iSetValue1 & 8)				LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "4");
	if (iSetValue1 & 16)			LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "5");
	if (iSetValue1 & 32)			LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "6");
	if (iSetValue1 & 64)			LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "7");
	if (iSetValue1 & 128)			LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "8");
	if (iSetValue1 & 256)			LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "9");
	if (iSetValue1 & 512)			LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "10");
	if (iSetValue1 & 1024)			LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "11");
	if (iSetValue1 & 2048)			LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "12");
	if (iSetValue1 & 4096)			LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "13");
	if (iSetValue1 & 8192)			LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "14");
	if (iSetValue1 & 16384)			LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "15");
	if (iSetValue1 & 32768)			LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "16");
	if (iSetValue1 & 65536)			LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "17");
	if (iSetValue1 & 131072)		LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "18");
	if (iSetValue1 & 262144)		LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "19");
	if (iSetValue1 & 524288)		LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "20");
	if (iSetValue1 & 1048576)		LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "21");
	if (iSetValue1 & 2097152)		LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "22");
	if (iSetValue1 & 4194304)		LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "23");
	if (iSetValue1 & 8388608)		LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "24");
	if (iSetValue1 & 16777216)		LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "25");
	if (iSetValue1 & 33554432)		LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "26");
	if (iSetValue1 & 67108864)		LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "27");
	if (iSetValue1 & 134217728)		LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "28");
	if (iSetValue1 & 268435456)		LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "29");
	if (iSetValue1 & 536870912)		LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "30");
	if (iSetValue1 & 1073741824)	LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "31");
	if (iSetValue2 & 1)				LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "32");
	if (iSetValue2 & 2)				LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "33");
	if (iSetValue2 & 4)				LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "34");
	if (iSetValue2 & 8)				LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "35");
	if (iSetValue2 & 16)			LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "36");
	if (iSetValue2 & 32)			LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "37");
	if (iSetValue2 & 64)			LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "38");
	if (iSetValue2 & 128)			LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "39");
	if (iSetValue2 & 256)			LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "40");
	if (iSetValue2 & 512)			LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "41");
	if (iSetValue2 & 1024)			LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "42");
	if (iSetValue2 & 2048)			LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "43");
	if (iSetValue2 & 4096)			LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_RandomActions", "44");
	
	// NPC is now initialized
	SetLocalInt(OBJECT_SELF, "AI_RandomNPCInit", 1);
}


// //////////////////////////////////////////////////
// LEG_AI_GetRandomObjectByTag
// //////////////////////////////////////////////////
object LEG_AI_GetRandomObjectByTag(string sTag, float fMaxDistance, object oCaller)
{
	int iObject; object oObject;
	int i = 1;
	LEG_COMMON_ClearArray(OBJECT_SELF, "AI_ActionWaypoints");
	
	object oNear = GetNearestObjectByTag(sTag, oCaller, i);
	
  	// GetNearest seems to work only in the area of OBJECT_SELF, good.
  	while ((GetIsObjectValid(oNear)) && (GetDistanceBetween(oNear, oCaller) <= fMaxDistance))
  	{
		if (!GetLocalInt(oNear, "AI_Inuse"))
			LEG_COMMON_AddArrayElement(OBJECT_SELF, "AI_ActionWaypoints", IntToString(i));	
		i++;
		oNear = GetNearestObjectByTag(sTag, oCaller, i);
  	}
	
  	int iTotalWP = LEG_COMMON_GetArrayElementCount(OBJECT_SELF, "AI_ActionWaypoints");
	int iSelection = Random(iTotalWP) + 1;
   	iObject = StringToInt(LEG_COMMON_GetArrayElement(OBJECT_SELF, "AI_ActionWaypoints", iSelection));
  	
	oObject = GetNearestObjectByTag(sTag, oCaller, iObject);
  	if (GetIsObjectValid(oObject) && GetDistanceBetween(oObject, oCaller) <= fMaxDistance)
	{
		if (!GetLocalInt(oObject, "AI_Inuse"))
		{
    		return oObject;
		}
		else
		{
			return OBJECT_INVALID;
		}
	}
	return OBJECT_INVALID;
}


// //////////////////////////////////////////////////
// LEG_AI_ChooseNPCTask
// //////////////////////////////////////////////////
object LEG_AI_ChooseNPCTask(int iCurrentTask = -1)
{
	// If we are passing a task to this, then force use that one, otherwise, choose one.
	string sSelection = "";
	if (iCurrentTask == -1)
	{
		// NPC will now choose one of the tasks in his array, grab an inactive WP for it and assign it.
		int iTotalTasks = LEG_COMMON_GetArrayElementCount(OBJECT_SELF, "AI_RandomActions");
		
		// Choose one of them randomly.
		sSelection = LEG_COMMON_GetArrayElement(OBJECT_SELF, "AI_RandomActions", Random(iTotalTasks) + 1);
	}
	else
	{
		sSelection = IntToString(iCurrentTask);
	}
		
	// Find a WP for the selection
	float fTaskRange = GetLocalFloat(OBJECT_SELF, "LEG_AI_TaskRange");
	if (fTaskRange <= 0.0)
		fTaskRange = 50.0;
	
	// Do I have a spawn point?  If so, then I need to grab one near THAT in case I was trained away.
	object oHomePoint = GetLocalObject(OBJECT_SELF, "LEG_AI_IPHome");
	if (!GetIsObjectValid(oHomePoint))
		oHomePoint = OBJECT_SELF;
		
	object oWP = LEG_AI_GetRandomObjectByTag("leg_ai_npcaction_" + sSelection, fTaskRange, oHomePoint);
	if (GetIsObjectValid(oWP))
	{
		// If we have a valid WP, set it to In Use
		SetLocalInt(oWP, "AI_Inuse", 1);
		SetLocalObject(OBJECT_SELF, "AI_TaskWP", oWP);
		SetLocalInt(OBJECT_SELF, "AI_CurrentTask", StringToInt(sSelection));
		SetLocalLocation(OBJECT_SELF, "LEG_AI_HomeLocation", GetLocation(oWP));
		return oWP;	
	}
	else
		return OBJECT_INVALID;
	
}



// //////////////////////////////////////////////////
// LEG_AI_PerformTask
// //////////////////////////////////////////////////
void LEG_AI_PerformTask()
{
	// Do the task I have assigned.
	int iTask = GetLocalInt(OBJECT_SELF, "AI_CurrentTask");
	object oWP = GetLocalObject(OBJECT_SELF, "AI_TaskWP");
	int iRoll = d100();
	switch (iTask)
	{
		case 1:		if (GetLocalInt(OBJECT_SELF, "LEG_AI_UnEquip")) LEG_AI_UnEquipWeapons(); DelayCommand(0.1, LEG_AI_NPCAction_Agree(OBJECT_SELF, oWP, iRoll)); break;
		case 2:		if (GetLocalInt(OBJECT_SELF, "LEG_AI_UnEquip")) LEG_AI_UnEquipWeapons(); DelayCommand(0.1, LEG_AI_NPCAction_Angry(OBJECT_SELF, oWP, iRoll)); break;
		case 3:		if (GetLocalInt(OBJECT_SELF, "LEG_AI_UnEquip")) LEG_AI_UnEquipWeapons(); DelayCommand(0.1, LEG_AI_NPCAction_Sad(OBJECT_SELF, oWP, iRoll)); break;
		case 4:		if (GetLocalInt(OBJECT_SELF, "LEG_AI_UnEquip")) LEG_AI_UnEquipWeapons(); DelayCommand(0.1, LEG_AI_NPCAction_Cook(OBJECT_SELF, oWP, iRoll)); break;
		case 5:		if (GetLocalInt(OBJECT_SELF, "LEG_AI_UnEquip")) LEG_AI_UnEquipWeapons(); DelayCommand(0.1, LEG_AI_NPCAction_FemDance(OBJECT_SELF, oWP, iRoll)); break;
		case 6:		if (GetLocalInt(OBJECT_SELF, "LEG_AI_UnEquip")) LEG_AI_UnEquipWeapons(); DelayCommand(0.1, LEG_AI_NPCAction_MaleDance(OBJECT_SELF, oWP, iRoll)); break;
		case 7:		if (GetLocalInt(OBJECT_SELF, "LEG_AI_UnEquip")) LEG_AI_UnEquipWeapons(); DelayCommand(0.1, LEG_AI_NPCAction_Drum(OBJECT_SELF, oWP, iRoll)); break;
		case 8:		if (GetLocalInt(OBJECT_SELF, "LEG_AI_UnEquip")) LEG_AI_UnEquipWeapons(); DelayCommand(0.1, LEG_AI_NPCAction_Flute(OBJECT_SELF, oWP, iRoll)); break;
		case 9:		if (GetLocalInt(OBJECT_SELF, "LEG_AI_UnEquip")) LEG_AI_UnEquipWeapons(); DelayCommand(0.1, LEG_AI_NPCAction_Forge(OBJECT_SELF, oWP, iRoll)); break;
		case 10:	if (GetLocalInt(OBJECT_SELF, "LEG_AI_UnEquip")) LEG_AI_UnEquipWeapons(); DelayCommand(0.1, LEG_AI_NPCAction_Guitar(OBJECT_SELF, oWP, iRoll)); break;
		case 11:	if (GetLocalInt(OBJECT_SELF, "LEG_AI_UnEquip")) LEG_AI_UnEquipWeapons(); else LEG_AI_Equip(); DelayCommand(0.1, LEG_AI_NPCAction_Woodsman(OBJECT_SELF, oWP, iRoll)); break;
		case 12:	if (GetLocalInt(OBJECT_SELF, "LEG_AI_UnEquip")) LEG_AI_UnEquipWeapons(); DelayCommand(0.1, LEG_AI_NPCAction_Meditate(OBJECT_SELF, oWP, iRoll)); break;
		case 13:	if (GetLocalInt(OBJECT_SELF, "LEG_AI_UnEquip")) LEG_AI_UnEquipWeapons(); DelayCommand(0.1, LEG_AI_NPCAction_SitRead(OBJECT_SELF, oWP, iRoll)); break;
		case 14:	if (GetLocalInt(OBJECT_SELF, "LEG_AI_UnEquip")) LEG_AI_UnEquipWeapons(); DelayCommand(0.1, LEG_AI_NPCAction_Sit(OBJECT_SELF, oWP, iRoll)); break;
		case 15:	if (GetLocalInt(OBJECT_SELF, "LEG_AI_UnEquip")) LEG_AI_UnEquipWeapons(); DelayCommand(0.1, LEG_AI_NPCAction_SitEat(OBJECT_SELF, oWP, iRoll)); break;
		case 16:	if (GetLocalInt(OBJECT_SELF, "LEG_AI_UnEquip")) LEG_AI_UnEquipWeapons(); DelayCommand(0.1, LEG_AI_NPCAction_Cheer(OBJECT_SELF, oWP, iRoll)); break;
		case 17:	if (GetLocalInt(OBJECT_SELF, "LEG_AI_UnEquip")) LEG_AI_UnEquipWeapons(); else LEG_AI_Equip(); DelayCommand(0.1, LEG_AI_NPCAction_NPC1Training(OBJECT_SELF, oWP)); break;
		case 18:	if (GetLocalInt(OBJECT_SELF, "LEG_AI_UnEquip")) LEG_AI_UnEquipWeapons(); else LEG_AI_Equip(); DelayCommand(0.1, LEG_AI_NPCAction_NPC2Training(OBJECT_SELF, oWP)); break;
		case 19:	if (GetLocalInt(OBJECT_SELF, "LEG_AI_UnEquip")) LEG_AI_UnEquipWeapons(); DelayCommand(0.1, LEG_AI_NPCAction_CookingMulti(OBJECT_SELF, oWP, iRoll)); break;
		case 20:	if (GetLocalInt(OBJECT_SELF, "LEG_AI_UnEquip")) LEG_AI_UnEquipWeapons(); DelayCommand(0.1, LEG_AI_NPCAction_ForgeMulti(OBJECT_SELF, oWP, iRoll)); break;
		case 21:	if (GetLocalInt(OBJECT_SELF, "LEG_AI_UnEquip")) LEG_AI_UnEquipWeapons(); DelayCommand(0.1, LEG_AI_NPCAction_Taunt(OBJECT_SELF, oWP, iRoll)); break;
		case 22:	if (GetLocalInt(OBJECT_SELF, "LEG_AI_UnEquip")) LEG_AI_UnEquipWeapons(); DelayCommand(0.1, LEG_AI_NPCAction_Worship(OBJECT_SELF, oWP, 2)); break;
		case 23:	if (GetLocalInt(OBJECT_SELF, "LEG_AI_UnEquip")) LEG_AI_UnEquipWeapons(); DelayCommand(0.1, LEG_AI_NPCAction_KneelTalk(OBJECT_SELF, oWP, iRoll)); break;
		case 24:	if (GetLocalInt(OBJECT_SELF, "LEG_AI_UnEquip")) LEG_AI_UnEquipWeapons(); DelayCommand(0.1, LEG_AI_NPCAction_BardSong(OBJECT_SELF, oWP)); break;
		case 25:	if (GetLocalInt(OBJECT_SELF, "LEG_AI_UnEquip")) LEG_AI_UnEquipWeapons(); DelayCommand(0.1, LEG_AI_NPCAction_Drink(OBJECT_SELF, oWP, d20())); break;		
		case 26:	if (GetLocalInt(OBJECT_SELF, "LEG_AI_UnEquip")) LEG_AI_UnEquipWeapons(); DelayCommand(0.1, LEG_AI_NPCAction_AnimalGraze(OBJECT_SELF, oWP, d20())); break;
		case 27:	if (GetLocalInt(OBJECT_SELF, "LEG_AI_UnEquip")) LEG_AI_UnEquipWeapons(); DelayCommand(0.1, LEG_AI_NPCAction_SitFiget(OBJECT_SELF, oWP, d20())); break;		
	}
}



// //////////////////////////////////////////////////
// LEG_AI_SetNextTaskTime
// //////////////////////////////////////////////////
void LEG_AI_SetNextTaskTime()
{
	// Set my next time to change events
	int iEventChange = GetLocalInt(OBJECT_SELF, "LEG_AI_NPCTaskFrequency");
	int iCurrentHour = GetTimeHour();
	int iNextTaskHour;
	switch (iEventChange)
	{
		case 0:		iNextTaskHour = 100; break;
		case 1:		iNextTaskHour = iCurrentHour + 1; break;
		case 2:		iNextTaskHour = iCurrentHour + 12; break;
		case 3:		iNextTaskHour = iCurrentHour + 8; break;
		case 4:		iNextTaskHour = iCurrentHour + 6; break;
		case 5:		iNextTaskHour = iCurrentHour + 4; break;
		case 6:		iNextTaskHour = iCurrentHour + 2; break;
	
	}
	if (iNextTaskHour > 23 && iNextTaskHour != 100)
		iNextTaskHour = iNextTaskHour - 24;
			
	SetLocalInt(OBJECT_SELF, "AI_NextTaskHour", iNextTaskHour);
}

void LEG_AI_SetAIProfile(int iProfileID)
{
		// Set up some AI type stuff for our critter here.
		SetLocalInt(OBJECT_SELF, "NW_ANIM_FLAG_CONSTANT", 1);
		SetLocalInt(OBJECT_SELF, "X2_USERDEFINED_ONSPAWN_EVENTS", 2);
		SetLocalInt(OBJECT_SELF, "NW_FLAG_HEARTBEAT_EVENT", 1);
		
		string sProfileID = "_" + IntToString(iProfileID);
		
		SetLocalInt(OBJECT_SELF, "LEG_AI_SpawnCondition", GetLocalInt(OBJECT_SELF, "LEG_AI_SpawnCondition" + sProfileID));
		SetLocalInt(OBJECT_SELF, "LEG_AI_CombatBehavior", GetLocalInt(OBJECT_SELF, "LEG_AI_CombatBehavior" + sProfileID));
		SetLocalFloat(OBJECT_SELF, "LEG_AI_MillRange", GetLocalFloat(OBJECT_SELF, "LEG_AI_MillRange" + sProfileID));
		SetLocalInt(OBJECT_SELF, "LEG_AI_MobType", GetLocalInt(OBJECT_SELF, "LEG_AI_MobType" + sProfileID));
		SetLocalString(OBJECT_SELF, "LEG_AI_WalkRoute", GetLocalString(OBJECT_SELF, "LEG_AI_WalkRoute" + sProfileID));
		SetLocalInt(OBJECT_SELF, "LEG_AI_PatrolType", GetLocalInt(OBJECT_SELF, "LEG_AI_PatrolType" + sProfileID));
		SetLocalInt(OBJECT_SELF, "LEG_AI_SleepChance", GetLocalInt(OBJECT_SELF, "LEG_AI_SleepChance" + sProfileID));
		SetLocalInt(OBJECT_SELF, "LEG_AI_DayNight", GetLocalInt(OBJECT_SELF, "LEG_AI_DayNight" + sProfileID));
		SetLocalInt(OBJECT_SELF, "LEG_AI_NoPlot", GetLocalInt(OBJECT_SELF, "LEG_AI_NoPlot" + sProfileID));
		SetLocalFloat(OBJECT_SELF, "LEG_AI_TaskRange", GetLocalFloat(OBJECT_SELF, "LEG_AI_TaskRange" + sProfileID));
		SetLocalInt(OBJECT_SELF, "LEG_AI_InteriorRunRange", GetLocalInt(OBJECT_SELF, "LEG_AI_InteriorRunRange" + sProfileID));
		SetLocalInt(OBJECT_SELF, "LEG_AI_ExteriorRunRange", GetLocalInt(OBJECT_SELF, "LEG_AI_ExteriorRunRange" + sProfileID));
		SetLocalInt(OBJECT_SELF, "LEG_AI_BehaviorSet1", GetLocalInt(OBJECT_SELF, "LEG_AI_BehaviorSet1" + sProfileID));
		SetLocalInt(OBJECT_SELF, "LEG_AI_BehaviorSet2", GetLocalInt(OBJECT_SELF, "LEG_AI_BehaviorSet2" + sProfileID));
		SetLocalString(OBJECT_SELF, "LEG_AI_Bartender", GetLocalString(OBJECT_SELF, "LEG_AI_Bartender" + sProfileID));
		SetLocalString(OBJECT_SELF, "LEG_AI_BarExclude1", GetLocalString(OBJECT_SELF, "LEG_AI_BarExclude1" + sProfileID));
		SetLocalString(OBJECT_SELF, "LEG_AI_BarExclude2", GetLocalString(OBJECT_SELF, "LEG_AI_BarExclude2" + sProfileID));
		SetLocalString(OBJECT_SELF, "LEG_AI_BarExclude3", GetLocalString(OBJECT_SELF, "LEG_AI_BarExclude3" + sProfileID));
		SetLocalString(OBJECT_SELF, "LEG_AI_BarExclude4", GetLocalString(OBJECT_SELF, "LEG_AI_BarExclude4" + sProfileID));
		SetLocalString(OBJECT_SELF, "LEG_AI_UnEquip", GetLocalString(OBJECT_SELF, "LEG_AI_UnEquip" + sProfileID));
		SetLocalString(OBJECT_SELF, "LEG_AI_OnAttackedScript", GetLocalString(OBJECT_SELF, "LEG_AI_OnAttackedScript" + sProfileID));
		SetLocalString(OBJECT_SELF, "LEG_AI_OnDamagedScript", GetLocalString(OBJECT_SELF, "LEG_AI_OnDamagedScript" + sProfileID));
		SetLocalString(OBJECT_SELF, "LEG_AI_OnDeathScript", GetLocalString(OBJECT_SELF, "LEG_AI_OnDeathScript" + sProfileID));
		SetLocalString(OBJECT_SELF, "LEG_AI_OnEndOfRoundScript", GetLocalString(OBJECT_SELF, "LEG_AI_OnEndOfRoundScript" + sProfileID));
		SetLocalString(OBJECT_SELF, "LEG_AI_OnHeartbeatScript", GetLocalString(OBJECT_SELF, "LEG_AI_OnHeartbeatScript" + sProfileID));
		SetLocalString(OBJECT_SELF, "LEG_AI_OnPerceptionScript", GetLocalString(OBJECT_SELF, "LEG_AI_OnPerceptionScript" + sProfileID));
		SetLocalString(OBJECT_SELF, "LEG_AI_OnSpawnScript", GetLocalString(OBJECT_SELF, "LEG_AI_OnSpawnScript" + sProfileID));
		SetLocalString(OBJECT_SELF, "LEG_AI_OnSpellCastAtScript", GetLocalString(OBJECT_SELF, "LEG_AI_OnSpellCastAtScript" + sProfileID));
		SetLocalInt(OBJECT_SELF, "LEG_AI_NPCTaskFrequency", GetLocalInt(OBJECT_SELF, "LEG_AI_NPCTaskFrequency" + sProfileID));
		
		SetLocalString(OBJECT_SELF, "WP_TAG", "");
}

void LEG_AI_SetAIProfileOld(int iProfileID)
{
		// Set up some AI type stuff for our critter here.
		SetLocalInt(OBJECT_SELF, "NW_ANIM_FLAG_CONSTANT", 1);
		SetLocalInt(OBJECT_SELF, "X2_USERDEFINED_ONSPAWN_EVENTS", 2);
		SetLocalInt(OBJECT_SELF, "NW_FLAG_HEARTBEAT_EVENT", 1);
		
		string sProfileID = "_" + IntToString(iProfileID);
		
		if (GetLocalInt(OBJECT_SELF, "LEG_AI_SpawnCondition" + sProfileID))
			SetLocalInt(OBJECT_SELF, "LEG_AI_SpawnCondition", GetLocalInt(OBJECT_SELF, "LEG_AI_SpawnCondition" + sProfileID));
		if (GetLocalInt(OBJECT_SELF, "LEG_AI_CombatBehavior" + sProfileID))
			SetLocalInt(OBJECT_SELF, "LEG_AI_CombatBehavior", GetLocalInt(OBJECT_SELF, "LEG_AI_CombatBehavior" + sProfileID));
		if (GetLocalFloat(OBJECT_SELF, "LEG_AI_MillRange" + sProfileID) > 0.0)
			SetLocalFloat(OBJECT_SELF, "LEG_AI_MillRange", GetLocalFloat(OBJECT_SELF, "LEG_AI_MillRange" + sProfileID));
		if (GetLocalInt(OBJECT_SELF, "LEG_AI_MobType" + sProfileID))
			SetLocalInt(OBJECT_SELF, "LEG_AI_MobType", GetLocalInt(OBJECT_SELF, "LEG_AI_MobType" + sProfileID));
		if (GetLocalString(OBJECT_SELF, "LEG_AI_WalkRoute" + sProfileID) != "")
			SetLocalString(OBJECT_SELF, "LEG_AI_WalkRoute", GetLocalString(OBJECT_SELF, "LEG_AI_WalkRoute" + sProfileID));
		if (GetLocalInt(OBJECT_SELF, "LEG_AI_PatrolType" + sProfileID) != 0)
			SetLocalInt(OBJECT_SELF, "LEG_AI_PatrolType", GetLocalInt(OBJECT_SELF, "LEG_AI_PatrolType" + sProfileID));
		if (GetLocalInt(OBJECT_SELF, "LEG_AI_SleepChance" + sProfileID) != 0)
			SetLocalInt(OBJECT_SELF, "LEG_AI_SleepChance", GetLocalInt(OBJECT_SELF, "LEG_AI_SleepChance" + sProfileID));
		if (GetLocalInt(OBJECT_SELF, "LEG_AI_DayNight" + sProfileID) != 0)
			SetLocalInt(OBJECT_SELF, "LEG_AI_DayNight", GetLocalInt(OBJECT_SELF, "LEG_AI_DayNight" + sProfileID));
		if (GetLocalInt(OBJECT_SELF, "LEG_AI_NoPlot" + sProfileID) != 0)
			SetLocalInt(OBJECT_SELF, "LEG_AI_NoPlot", GetLocalInt(OBJECT_SELF, "LEG_AI_NoPlot" + sProfileID));
		if (GetLocalFloat(OBJECT_SELF, "LEG_AI_TaskRange" + sProfileID) != 0.0)
			SetLocalFloat(OBJECT_SELF, "LEG_AI_TaskRange", GetLocalFloat(OBJECT_SELF, "LEG_AI_TaskRange" + sProfileID));
		if (GetLocalInt(OBJECT_SELF, "LEG_AI_InteriorRunRange" + sProfileID) != 0)
			SetLocalInt(OBJECT_SELF, "LEG_AI_InteriorRunRange", GetLocalInt(OBJECT_SELF, "LEG_AI_InteriorRunRange" + sProfileID));
		if (GetLocalInt(OBJECT_SELF, "LEG_AI_ExteriorRunRange" + sProfileID) != 0)
			SetLocalInt(OBJECT_SELF, "LEG_AI_ExteriorRunRange", GetLocalInt(OBJECT_SELF, "LEG_AI_ExteriorRunRange" + sProfileID));
		if (GetLocalInt(OBJECT_SELF, "LEG_AI_BehaviorSet1" + sProfileID) != 0)
			SetLocalInt(OBJECT_SELF, "LEG_AI_BehaviorSet1", GetLocalInt(OBJECT_SELF, "LEG_AI_BehaviorSet1" + sProfileID));
		if (GetLocalInt(OBJECT_SELF, "LEG_AI_BehaviorSet2" + sProfileID) != 0)
			SetLocalInt(OBJECT_SELF, "LEG_AI_BehaviorSet2", GetLocalInt(OBJECT_SELF, "LEG_AI_BehaviorSet2" + sProfileID));
		if (GetLocalString(OBJECT_SELF, "LEG_AI_Bartender" + sProfileID) != "")
			SetLocalString(OBJECT_SELF, "LEG_AI_Bartender", GetLocalString(OBJECT_SELF, "LEG_AI_Bartender" + sProfileID));
		if (GetLocalString(OBJECT_SELF, "LEG_AI_BarExclude1" + sProfileID) != "")
			SetLocalString(OBJECT_SELF, "LEG_AI_BarExclude1", GetLocalString(OBJECT_SELF, "LEG_AI_BarExclude1" + sProfileID));
		if (GetLocalString(OBJECT_SELF, "LEG_AI_BarExclude2" + sProfileID) != "")
			SetLocalString(OBJECT_SELF, "LEG_AI_BarExclude2", GetLocalString(OBJECT_SELF, "LEG_AI_BarExclude2" + sProfileID));
		if (GetLocalString(OBJECT_SELF, "LEG_AI_BarExclude3" + sProfileID) != "")
			SetLocalString(OBJECT_SELF, "LEG_AI_BarExclude3", GetLocalString(OBJECT_SELF, "LEG_AI_BarExclude3" + sProfileID));
		if (GetLocalString(OBJECT_SELF, "LEG_AI_BarExclude4" + sProfileID) != "")
			SetLocalString(OBJECT_SELF, "LEG_AI_BarExclude4", GetLocalString(OBJECT_SELF, "LEG_AI_BarExclude4" + sProfileID));
		if (GetLocalString(OBJECT_SELF, "LEG_AI_UnEquip" + sProfileID) != "")
			SetLocalString(OBJECT_SELF, "LEG_AI_UnEquip", GetLocalString(OBJECT_SELF, "LEG_AI_UnEquip" + sProfileID));
		if (GetLocalString(OBJECT_SELF, "LEG_AI_OnAttackedScript" + sProfileID) != "")
			SetLocalString(OBJECT_SELF, "LEG_AI_OnAttackedScript", GetLocalString(OBJECT_SELF, "LEG_AI_OnAttackedScript" + sProfileID));
		if (GetLocalString(OBJECT_SELF, "LEG_AI_OnDamagedScript" + sProfileID) != "")
			SetLocalString(OBJECT_SELF, "LEG_AI_OnDamagedScript", GetLocalString(OBJECT_SELF, "LEG_AI_OnDamagedScript" + sProfileID));
		if (GetLocalString(OBJECT_SELF, "LEG_AI_OnDeathScript" + sProfileID) != "")
			SetLocalString(OBJECT_SELF, "LEG_AI_OnDeathScript", GetLocalString(OBJECT_SELF, "LEG_AI_OnDeathScript" + sProfileID));
		if (GetLocalString(OBJECT_SELF, "LEG_AI_OnEndOfRoundScript" + sProfileID) != "")
			SetLocalString(OBJECT_SELF, "LEG_AI_OnEndOfRoundScript", GetLocalString(OBJECT_SELF, "LEG_AI_OnEndOfRoundScript" + sProfileID));
		if (GetLocalString(OBJECT_SELF, "LEG_AI_OnHeartbeatScript" + sProfileID) != "")
			SetLocalString(OBJECT_SELF, "LEG_AI_OnHeartbeatScript", GetLocalString(OBJECT_SELF, "LEG_AI_OnHeartbeatScript" + sProfileID));
		if (GetLocalString(OBJECT_SELF, "LEG_AI_OnPerceptionScript" + sProfileID) != "")
			SetLocalString(OBJECT_SELF, "LEG_AI_OnPerceptionScript", GetLocalString(OBJECT_SELF, "LEG_AI_OnPerceptionScript" + sProfileID));
		if (GetLocalString(OBJECT_SELF, "LEG_AI_OnSpawnScript" + sProfileID) != "")
			SetLocalString(OBJECT_SELF, "LEG_AI_OnSpawnScript", GetLocalString(OBJECT_SELF, "LEG_AI_OnSpawnScript" + sProfileID));
		if (GetLocalString(OBJECT_SELF, "LEG_AI_OnSpellCastAtScript" + sProfileID) != "")
			SetLocalString(OBJECT_SELF, "LEG_AI_OnSpellCastAtScript", GetLocalString(OBJECT_SELF, "LEG_AI_OnSpellCastAtScript" + sProfileID));

		if (GetLocalInt(OBJECT_SELF, "LEG_AI_NPCTaskFrequency" + sProfileID) != 0)
			SetLocalInt(OBJECT_SELF, "LEG_AI_NPCTaskFrequency", GetLocalInt(OBJECT_SELF, "LEG_AI_NPCTaskFrequency" + sProfileID));
		
		SetLocalString(OBJECT_SELF, "WP_TAG", "");
}