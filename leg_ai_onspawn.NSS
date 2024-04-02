/*

    Script:			AI Script for the Spawn Event to go NPC's and Mobs.  Mostly a copy of the built
					in AI with major modifications.
	Version:		1.2
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		06/23/2011 - 1.00 MV - Initial Release
					11/12/2012 - 1.1 MV - Added support to call optional Pre Scripts
					05/29/2015 - 1.2 MV - Added support for SE recalling when a Mob changes AI
	
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_ai_include"

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// BUILT IN CONSTANTS
// /////////////////////////////////////////////////////////////////////////////////////////////////////
const int EVENT_USER_DEFINED_PRESPAWN = 1510;
const int EVENT_USER_DEFINED_POSTSPAWN = 1511;

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	object oNPC = OBJECT_SELF;
	
	//If Passive, turn names to Aqua color
	if (GetLocalInt(oNPC, "PASSIVE") == TRUE)
	{
		SetFirstName(oNPC, "<c=aqua>" + GetFirstName(oNPC));
		SetLastName(oNPC, "<c=aqua>" + GetLastName(oNPC));
	}
	
	// Run custom script
	string sScript = GetLocalString(oNPC, "LEG_AI_OnSpawnScript");
	if (sScript != "") ExecuteScript(sScript, oNPC);
	
	// Start with default code with any minor mods in them.
    // User defined OnSpawn event requested?
    int nSpecEvent = GetLocalInt(oNPC,"X2_USERDEFINED_ONSPAWN_EVENTS");

    // Pre Spawn Event requested
    if (nSpecEvent == 1  || nSpecEvent == 3) SignalEvent(oNPC, EventUserDefined(EVENT_USER_DEFINED_PRESPAWN));

    /*  Fix for the new golems to reduce their number of attacks */
    int nNumber = GetLocalInt(oNPC,CREATURE_VAR_NUMBER_OF_ATTACKS);
    if (nNumber > 0) SetBaseAttackBonus(nNumber);

	// Setup default profile if we're using them - If we weren't calling for a change in profile then set default profile up
	int iProfiles = GetLocalInt(oNPC, "LEG_AI_Profile");
	int iChangeCalled = GetLocalInt(oNPC, "LEG_AI_ChangeCalled");
	
	if (iProfiles)
	{
		if (!iChangeCalled) LEG_AI_SetAIProfile(1);
		else LEG_AI_SetAIProfile(iChangeCalled);
	}
	
	// Get Vars
	int iDayNight = GetLocalInt(oNPC, "LEG_AI_DayNight");
	int iEscort = GetLocalInt(oNPC, "LEG_QUEST_Escort");
	int iSpawnBehavior = GetLocalInt(oNPC, "LEG_AI_SpawnCondition");
	int iCombatBehavior = GetLocalInt(oNPC, "LEG_AI_CombatBehavior");
	int iMobType = GetLocalInt(oNPC, "LEG_AI_MobType");
	
	string sPatrolRoute = GetLocalString(oNPC, "LEG_AI_WalkRoute");
	string sWPTAG = GetLocalString(oNPC, "WP_TAG");
	
	// See if he is supposed to be on a Patrol Route or not.
	if (iDayNight) SetSpawnInCondition(NW_FLAG_DAY_NIGHT_POSTING);
		
	if (sPatrolRoute != "" && iEscort == 0 && sWPTAG != sPatrolRoute)
	{
		SetLocalString(oNPC, "WP_TAG", sPatrolRoute);
	 	SetWWPController(sPatrolRoute);
	}

	// Look up what their behavior is going to be.  The first is their spawn in condition, the second is
	// how they behave in a fight.

	// Elevated AI?
	if (GetLocalInt(oNPC, "LEG_AI_AILevel") == 3) SetAILevel(oNPC, AI_LEVEL_NORMAL);

	// Ok, let's do something about their spawn in condition.		
	switch (iSpawnBehavior)
	{
		case 1:				SetSpawnInCondition(NW_FLAG_STEALTH);
							SetLocalInt(oNPC, "X2_L_SPAWN_USE_STEALTH", 1);
							SetCreatureFlag(oNPC, "CREATURE_VAR_USE_SPAWN_STEALTH", TRUE);
							break;

		case 2: 			AssignCommand(oNPC, LEG_AI_Animations(oNPC, "laydownB", 0));
							DelayCommand(2.0, AssignCommand(oNPC, LEG_AI_Animations(oNPC, "proneB", 1)));
							DelayCommand(2.5, SetFacing(GetFacing(oNPC), TRUE));
							SetOrientOnDialog(oNPC, FALSE);
							SetLocalInt(oNPC, "LEG_AI_MobType", 4);
							break;
		case 3:				ExecuteScript("x2_spn_dead", oNPC);
							break;
		case 4:				SetSpawnInCondition(NW_FLAG_SLEEPING_AT_NIGHT);
							SetLocalString(GetModule(),"X2_S_SLEEP_AT_NIGHT_SCRIPT", "leg_ai_sleep");
							break;
	}			

	// Now setup the traits for the combat behavior.
	switch (iCombatBehavior)
	{
		case 1:				SetLocalInt(oNPC, "X0_COMBAT_FLAG_RANGED", 1);
							SetCombatCondition(X0_COMBAT_FLAG_RANGED);
							break;
			
		case 2:				SetLocalInt(oNPC, "X0_COMBAT_FLAG_DEFENSIVE", 1);
							SetCombatCondition(X0_COMBAT_FLAG_DEFENSIVE);
							break;		
		
		case 3:				SetLocalInt(oNPC, "X0_COMBAT_FLAG_AMBUSHER", 1);
							SetCombatCondition(X0_COMBAT_FLAG_AMBUSHER);
							break;
							
		case 4:				SetLocalInt(oNPC, "X0_COMBAT_FLAG_COWARDLY", 1);
							SetCombatCondition(X0_COMBAT_FLAG_COWARDLY);
							break;
		case 5:				SetLocalInt(oNPC, "X2_L_BEH_MAGIC", 100);
							//SetCombatCondition(X0_COMBAT_FLAG_COWARDLY);
							break;
		case 6:				SetLocalInt(oNPC, "X2_L_BEH_OFFENSE", 100);
							//SetCombatCondition(X0_COMBAT_FLAG_COWARDLY);
							break;
	}
	
    // Execute default OnSpawn script.
    //ExecuteScript("nw_c2_default9", oNPC);

    //Post Spawn event requeste
    if (nSpecEvent == 2 || nSpecEvent == 3) SignalEvent(oNPC,EventUserDefined(EVENT_USER_DEFINED_POSTSPAWN));
	
	// Here is our additional code.
	// First, now that we've spawned, all mobs require that they have a home point, which is their spawn point
	// unless they are a patroller.  We're going to try and make their home point their next waypoint!  
    LEG_AI_SetMobHome(oNPC);

	// Setup some Spawn in conditions for various events.
	SetSpawnInCondition(NW_FLAG_HEARTBEAT_EVENT);
	SetSpawnInCondition(NW_FLAG_DAMAGED_EVENT);
	SetSpawnInCondition(NW_FLAG_PERCIEVE_EVENT);
	SetAnimationCondition(NW_ANIM_FLAG_CONSTANT);

	
	// Set up some AI type stuff for our critter here.
	SetLocalInt(oNPC, "NW_ANIM_FLAG_CONSTANT", 1);
	SetLocalInt(oNPC, "X2_USERDEFINED_ONSPAWN_EVENTS", 2);
	SetLocalInt(oNPC, "NW_FLAG_HEARTBEAT_EVENT", 1);
	
	// The MobType variable determines the MOB's movement behavior such as standing still,
	// Milling about, or standing guard etc.
	switch (iMobType)
	{
		case 1:
			SetLocalInt(oNPC, "X2_L_SPAWN_USE_AMBIENT_IMMOBILE", 1);
			SetCreatureFlag(oNPC, "CREATURE_VAR_USE_SPAWN_AMBIENT_IMMOBILE", TRUE);
			SetSpawnInCondition(NW_FLAG_IMMOBILE_AMBIENT_ANIMATIONS);
			break;
		case 2:
			SetLocalInt(oNPC, "X2_L_SPAWN_USE_AMBIENT", 1);
			SetCreatureFlag(oNPC, "CREATURE_VAR_USE_SPAWN_AMBIENT", TRUE);
			SetSpawnInCondition(NW_FLAG_AMBIENT_ANIMATIONS);
			break;
		case 3:
			SetLocalInt(oNPC, "X2_L_SPAWN_USE_AMBIENT", 1);
			SetCreatureFlag(oNPC, "CREATURE_VAR_USE_SPAWN_AMBIENT", TRUE);
			SetLocalInt(oNPC, "AMCIVIL", 1);
			SetSpawnInCondition(NW_FLAG_AMBIENT_ANIMATIONS);
			break;
		case 4:
			// don't set up any vars for guards.
			break;
	  	case 99:
			SetLocalInt(oNPC, "X2_L_SPAWN_USE_AMBIENT_IMMOBILE", 0);
			SetCreatureFlag(oNPC, "CREATURE_VAR_USE_SPAWN_AMBIENT_IMMOBILE", FALSE);
			SetSpawnInCondition(NW_FLAG_IMMOBILE_AMBIENT_ANIMATIONS);
			break;
		default:
			SetLocalInt(oNPC, "X2_L_SPAWN_USE_AMBIENT", 1);
			SetCreatureFlag(oNPC, "CREATURE_VAR_USE_SPAWN_AMBIENT", TRUE);
			SetSpawnInCondition(NW_FLAG_AMBIENT_ANIMATIONS);
			break;
	}  

	// Last thing we want to do is to call our Master Spawn script!
	if (iChangeCalled != TRUE) ExecuteScript("leg_all_masterspawn", oNPC);
	else SetLocalInt(oNPC, "LEG_QUEST_SE_Called", FALSE);
	
	// Ok we are now spawned.  Equip our gear and make us ready.
	DelayCommand(1.0, LEG_AI_Equip());	

	// Start walking if I'm supposed to.
	WalkWayPoints(FALSE, "spawn"); 
	//WalkWayPoints(TRUE, "spawn");
}