/*

    Script:			Main Quest Special Effect Plugin Include.  Any Special Effect scripts will include THIS include vs. the standard quest include.
	Version:		1.8
	Plugin Version: 2.00
	Author:			Marshall Vyper
	Parameters:		None

	Change Log:		11/22/2012 - 1.00 MV - Initial Build
					03/09/2013 - 1.1 MV - Extended Range of Info Box
					03/21/2013 - 1.2 MV - Added removal of visual effects, added start conversation
					07/17/2015 - 1.3 MV - Added numerous new functionality.
					07/19/2015 - 1.4 MV - Added Cast Spell and Cast Fake Spell Effects
					07/20/2015 - 1.5 MV - When toggle switches are turned off, allow re-run of flag parameters it matches.
					07/22/2015 - 1.5 MV - Fixed major flaw when spawning targets, assigning reactions to them with a delay in the same flag 
					07/24/2015 - 1.5 MV - Added support to teleport single objects to another object
					07/26/2015 - 1.6 MV - Added support to group disappear and group kill objects
					07/26/2015 - 1.7 MV - Added support for OFF Flags
					10/16/2015 - 1.8 MV - Added numerous new reactions such as Give Items / XP, Remove Items etc
					
*/

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_quest_include"
#include "leg_quest_ipspeaker"
#include "ginc_misc"

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// FUNCTION DECLARATIONS
// /////////////////////////////////////////////////////////////////////////////////////////////////////
int LEG_QUEST_SE_CheckFlags(int iCheckFlags1);
object LEG_QUEST_SE_GetObject(object oSE, string sCheckGroup, string sTargetTag);
void LEG_QUEST_SE_GoReactions(object oSE, int iOff = 0);

// Reactions
void LEG_QUEST_SER_SetSpawn(object oSE, string sCheckGroup, int iOff = 0);
void LEG_QUEST_SER_Damage(object oSE, string sCheckGroup, int iOff = 0);
void LEG_QUEST_SER_ChangeMusic(object oSE, string sCheckGroup, int iOff = 0, int iMusic = 0);
void LEG_QUEST_SER_VisualEffect(object oSE, string sCheckGroup, int iOff = 0);
void LEG_QUEST_SER_CastSpell(object oSE, string sCheckGroup, int iOff = 0, int iFakeSpell = FALSE);
void LEG_QUEST_SER_PlaySound(object oSE, string sCheckGroup, int iOff = 0);
void LEG_QUEST_SER_FireSpawn(int iOff);
void LEG_QUEST_SER_InfoBox(object oSE, string sCheckGroup, int iBoxType, int iOff = 0);
void LEG_QUEST_SER_SetPlot(object oSE, string sCheckGroup, int iOff = 0);
void LEG_QUEST_SER_SetHidden(object oSE, string sCheckGroup, int iOff = 0);
void LEG_QUEST_SER_SetLock(object oSE, string sCheckGroup, int iOff = 0);
void LEG_QUEST_SER_Teleport(object oSE, string sCheckGroup, int iOff = 0);
void LEG_QUEST_SER_OpenClose(object oSE, string sCheckGroup, int iOff = 0);
void LEG_QUEST_SER_RemoveVisualEffects(object oSE, string sCheckGroup, int iOff = 0);
void LEG_QUEST_SER_StartConversation(object oSE, string sCheckGroup, int iOff = 0);
void LEG_QUEST_SER_ChangeMobAI(object oSE, string sCheckGroup, int iOff = 0);
void LEG_QUEST_SER_TeleportSingle(object oSE, string sCheckGroup, int iOff = 0);
void LEG_QUEST_SER_ForceConversation(object oSE, string sCheckGroup, int iOff = 0);
void LEG_QUEST_SER_RunAI(object oSE, string sCheckGroup, int iOff = 0);
void LEG_QUEST_SER_SpeakOneLine(object oSE, string sCheckGroup, int iOff = 0);
void LEG_QUEST_SER_SetImmortal(object oSE, string sCheckGroup, int iOff = 0);
void LEG_QUEST_SER_GoHostile(object oSE, string sCheckGroup, int iOff = 0);
void LEG_QUEST_SER_RemoveHostile(object oSE, string sCheckGroup, int iOff = 0);
void LEG_QUEST_SER_KillTarget(object oSE, string sCheckGroup, int iOff = 0);
void LEG_QUEST_SER_Destroy(object oSE, string sCheckGroup, int iOff = 0);
void LEG_QUEST_SER_SetUseable(object oSE, string sCheckGroup, int iOff = 0);
void LEG_QUEST_SER_SetFacing(object oSE, string sCheckGroup, int iOff = 0);
void LEG_QUEST_SER_ForceRest(object oSE, string sCheckGroup, int iOff = 0);
void LEG_QUEST_SER_DestroyGroup(object oSE, string sCheckGroup, int iOff = 0);
void LEG_QUEST_SER_KillGroup(object oSE, string sCheckGroup, int iOff = 0);
void LEG_QUEST_SER_GiveItem(object oSE, string sCheckGroup, int iOff = 0);
void LEG_QUEST_SER_RemoveItem(object oSE, string sCheckGroup, int iOff = 0);
void LEG_QUEST_SER_GiveGold(object oSE, string sCheckGroup, int iOff = 0);
void LEG_QUEST_SER_GiveXP(object oSE, string sCheckGroup, int iOff = 0);
void LEG_QUEST_SER_Heal(object oSE, string sCheckGroup, int iOff = 0);
void LEG_QUEST_SER_ObjComplete(object oSE, string sCheckGroup);
void LEG_QUEST_SER_ObjChange(object oSE, string sCheckGroup);
void LEG_QUEST_SER_ShutDown(object oSE, string sCheckGroup);

// Internal Support Function Declarations
int LEG_QUEST_SER_CheckTOD(string sStartTOD, string sEndTOD);
void LEG_QUEST_SER_RemoveEffectsFromSpell(object oTarget, int SpellID);
void LEG_QUEST_ObjRuleHideShow(object oPC, string sQuestID, int iNPCObjective, int iObjectiveHide, int iObjectiveShow, int iMustHaveHide = 1);
int LEG_QUEST_REQ_HasReqs(object oPC, object oObject);
void LEG_QUEST_SE_AreaOffFlags(object oSE, int iOff);
void LEG_QUEST_SER_GoDamage(object oSE, string sCheckGroup);

// External Support Functions
int LEG_QUEST_SER_GetFlagID(object oTarget, string sEvent);

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// SUPPORT FUNCTIONS
// /////////////////////////////////////////////////////////////////////////////////////////////////////

// Perform AOE damage.  We have this in a separate function so we can add delays to it when there's a DOT going on.
void LEG_QUEST_SER_GoDamage(object oSE, string sCheckGroup)
{
	object oTarget = LEG_QUEST_SE_GetObject(oSE, sCheckGroup, GetLocalString(oSE, "LEG_SER_Target_" + sCheckGroup));

	int iMinDamage = GetLocalInt(oSE, "LEG_SER_iValue1_" + sCheckGroup);
	int iMaxDamage = GetLocalInt(oSE, "LEG_SER_iValue2_" + sCheckGroup);
	int iDamageType = GetLocalInt(oSE, "LEG_SER_iValue3_" + sCheckGroup);
	int iReflexSave = GetLocalInt(oSE, "LEG_SER_iValue4_" + sCheckGroup);
	int iReflexDC = GetLocalInt(oSE, "LEG_SER_iValue5_" + sCheckGroup);
	int iReflexType = GetLocalInt(oSE, "LEG_SER_iValue6_" + sCheckGroup);
	int iVisualEffect = GetLocalInt(oSE, "LEG_SER_iValue7_" + sCheckGroup);
	float fRadius = GetLocalFloat(oSE, "LEG_SER_fValue1_" + sCheckGroup);	

    effect eVis = EffectVisualEffect(iVisualEffect);	
	effect eDam;
	int iDamage;

	object oObject = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oTarget), FALSE, OBJECT_TYPE_CREATURE|OBJECT_TYPE_DOOR|OBJECT_TYPE_PLACEABLE);
	while (GetIsObjectValid(oObject))
	{
		iDamage = Random(iMaxDamage - iMinDamage + 1) + iMinDamage;
		if (iReflexSave)
			iDamage = GetReflexAdjustedDamage(iDamage, oObject, iReflexDC, iReflexType);
	
		eDam = EffectDamage(iDamage, iDamageType);
		//Set the damage effect
		if(iDamage > 0)
		{
		    DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oObject));
		    DelayCommand(0.2, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oObject));
		}
		oObject = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oTarget), FALSE, OBJECT_TYPE_CREATURE|OBJECT_TYPE_DOOR|OBJECT_TYPE_PLACEABLE);
	}	
}

// Check Time of day
int LEG_QUEST_SER_CheckTOD(string sStartTOD, string sEndTOD)
{
	// We need this function to determine Start and End TOD's.  
	int iStart = LEG_COMMON_StringToHour(sStartTOD);
	int iEnd = LEG_COMMON_StringToHour(sEndTOD);
	int iCurrentHour = GetTimeHour();
	
	// We want to return TRUE if its time to start, and FALSE if it's time to end.  If the End is in the next
	// day, we need to be able to identify and deal with that.
	if (iEnd < iStart)
	{
		// Looks like our end is the next day so we'll throw a little check here for time due to that.
		if (iCurrentHour < iEnd)
			return TRUE;
		else if (iCurrentHour >= iStart)
			return TRUE;
		else
			return FALSE;
	}
	else
	{
		// Here the start time and end time are in the same day so it's a little simpler.
		if (iCurrentHour >= iStart && iCurrentHour < iEnd)
			return TRUE;
		else
			return FALSE;
	}
}



// LEG_QUEST_SER_RemoveEffectsFromSpell
void LEG_QUEST_SER_RemoveEffectsFromSpell(object oTarget, int SpellID)
{
  	effect eLook = GetFirstEffect(oTarget);
  	while (GetIsEffectValid(eLook)) 
	{
    	if (GetEffectSpellId(eLook) == SpellID)
		{
      		RemoveEffect(oTarget, eLook);
			eLook = GetFirstEffect(oTarget);
		}
		else	eLook = GetNextEffect(oTarget);
  	}
}


// LEG_QUEST_ObjRuleHideShow
void LEG_QUEST_ObjRuleHideShow(object oPC, string sQuestID, int iNPCObjective, int iObjectiveHide, int iObjectiveShow, int iMustHaveHide = 1)
{
	if (!iMustHaveHide || LEG_QUEST_CheckObjective(oPC, sQuestID, iNPCObjective, iObjectiveHide))
	{
		// We've completed the objective so set ourselves to be hidden.  
		LEG_COMMON_DisplayInfoBox(oPC, "Objectives Updated", 0, 0, 1);
		AssignCommand(oPC, PlaySound("gui_journaladd"));
		
		LEG_QUEST_SetOBJ(oPC, sQuestID, iNPCObjective, iObjectiveHide, "OBJHideSelf", "1");
		LEG_QUEST_SetOBJ(oPC, sQuestID, iNPCObjective, iObjectiveShow, "OBJHideSelf", "");
		LEG_QUEST_SetOBJ(oPC, sQuestID, iNPCObjective, iObjectiveShow, "OBJInactive", "");
	}
}

// Checks to see if passed PC and Object Requirements are met
int LEG_QUEST_REQ_HasReqs(object oPC, object oObject)
{
	int iHasReqs = TRUE;
	string sRequirementType = GetLocalString(oObject, "LEG_SE_REQ_RequirementType");
	
	// If there is no requirement type, there are no requirements, then PC HAS them.  Done!
	if (sRequirementType == "")
		return iHasReqs;
	
	// There are some requirements.
	int iFeat = GetLocalInt(oObject, "LEG_SE_REQ_Feat");
	int iMinLevel = GetLocalInt(oObject, "LEG_SE_REQ_MinLevel");
	int iMaxLevel = GetLocalInt(oObject, "LEG_SE_REQ_MaxLevel" );
	int iRace = GetLocalInt(oObject, "LEG_SE_REQ_Race");
	int iSubRace = GetLocalInt(oObject, "LEG_SE_REQ_SubRace");
	string sQuestStarted = GetLocalString(oObject, "LEG_SE_REQ_QuestStarted");
	string sQuestNotStarted = GetLocalString(oObject, "LEG_SE_REQ_QuestNotStarted");
	string sQuestFinished = GetLocalString(oObject, "LEG_SE_REQ_QuestFinished");
	string sAlignment = GetLocalString(oObject, "LEG_SE_REQ_Alignment");
	int iSkill = GetLocalInt(oObject, "LEG_SE_REQ_Skill");
	int iSkillDC = GetLocalInt(oObject, "LEG_SE_REQ_SkillDC");
	int iShowSkill = GetLocalInt(oObject, "LEG_SE_REQ_SkillShow");


	if (iFeat >= 0)
	{
		// Do we have a Feat Requirement for this destination?
		if (!GetHasFeat(iFeat, oPC, TRUE))
		{
			iHasReqs = FALSE;
			SetLocalString(oPC, "SE_FailMessage", "You do not have the required feat");
		}

	}
	else if (iSubRace >= 0)
	{
		// Do we have a Feat Requirement for this destination?
		if (GetSubRace(oPC) != iSubRace)
		{
			iHasReqs = FALSE;
			SetLocalString(oPC, "SE_FailMessage", "You do not have the required Sub Race");
		}

	}
	else if (iRace >= 0)
	{
		// Do we have a Feat Requirement for this destination?
		if (GetRacialType(oPC) != iRace)
		{
			iHasReqs = FALSE;
			SetLocalString(oPC, "SE_FailMessage", "You do not have the required race");
		}

	}
	else if (iMinLevel != 0)
	{
		// Do we have a Level Requirement for this destination?
		if (GetTotalLevels(oPC, FALSE) < iMinLevel)
		{
			iHasReqs = FALSE;
			SetLocalString(oPC, "SE_FailMessage", "You are not high enough level");
		}
	}
	else if (iMaxLevel != 0)
	{
		// Do we have a Level Requirement for this destination?
		if (GetTotalLevels(oPC, FALSE) > iMaxLevel)
		{
			iHasReqs = FALSE;
			SetLocalString(oPC, "SE_FailMessage", "You are too high level");
		}
	}
	else if (sQuestNotStarted != "")
	{
		if (GetLocalInt(GetModule(), "LEG_QUEST_ACTIVE"))
		{
			if (GetLocalInt(oPC, "QuestID_" + sQuestNotStarted + "_NPC") != 0)
			{
				iHasReqs = FALSE;
				SetLocalString(oPC, "SE_FailMessage", "You are too far along the quest line");
			}
		}			
	}
	else if (sQuestStarted != "")
	{
		if (GetLocalInt(GetModule(), "LEG_QUEST_ACTIVE"))
		{
			if (GetLocalInt(oPC, "QuestID_" + sQuestStarted + "_NPC") == 0 || GetLocalInt(oPC, "QuestID_" + sQuestStarted + "_NPC") >= 998)
			{
				iHasReqs = FALSE;
				SetLocalString(oPC, "SE_FailMessage", "You are not on the required quest");
			}
		}			
	}
	else if (sQuestFinished != "")
	{
		if (GetLocalInt(GetModule(), "LEG_QUEST_ACTIVE"))
		{
			if (GetLocalInt(oPC, "QuestID_" + sQuestFinished + "_NPC") < 998)
			{
				iHasReqs = FALSE;
				SetLocalString(oPC, "SE_FailMessage", "You have not completed the required quest");
			}
		}			
	}
	else if (iSkillDC != 0)
	{
		if (!GetIsSkillSuccessful(oPC, iSkill, iSkillDC, iShowSkill))
		{
			iHasReqs = FALSE;
			SetLocalString(oPC, "SE_FailMessage", "You failed in your attempt");
		}
	}
	
	// Return the result.			
	return iHasReqs;
}

// LEG_QUEST_SER_GetFlagID - We do these because we could have multiple of these on a single target
int LEG_QUEST_SER_GetFlagID(object oTarget, string sEvent)
{
	if (sEvent == "Death")
			return GetLocalInt(oTarget, "LEG_QUEST_SE_MyFlagDeath");
	else if (sEvent == "NearDeath")
			return GetLocalInt(oTarget, "LEG_QUEST_SE_MyFlagNearDeath");
	else if (sEvent == "Spawn")
			return GetLocalInt(oTarget, "LEG_QUEST_SE_MyFlagSpawn");
	else if (sEvent == "OffDeath")
			return GetLocalInt(oTarget, "LEG_QUEST_SE_MyOffFlagDeath");
	else if (sEvent == "OffNearDeath")
			return GetLocalInt(oTarget, "LEG_QUEST_SE_MyOffFlagNearDeath");
	else if (sEvent == "OffSpawn")
			return GetLocalInt(oTarget, "LEG_QUEST_SE_MyOffFlagSpawn");
	
	return -1;

}


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// FUNCTIONS
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void LEG_QUEST_SER_SpeakOneLine(object oSE, string sCheckGroup, int iOff = 0)
{
	object oTarget = LEG_QUEST_SE_GetObject(oSE, sCheckGroup, GetLocalString(oSE, "LEG_SER_Target_" + sCheckGroup));
		
	if (!iOff)
	{
		// Check for objects
		string sSpeak = GetLocalString(oSE, "LEG_SER_Info_" + sCheckGroup);
		AssignCommand(oTarget, SpeakString(sSpeak));
	}
}

void LEG_QUEST_SER_RunAI(object oSE, string sCheckGroup, int iOff = 0)
{
	object oTarget = LEG_QUEST_SE_GetObject(oSE, sCheckGroup, GetLocalString(oSE, "LEG_SER_Target_" + sCheckGroup));
	int iRunFlag = StringToInt(GetLocalString(oSE, "LEG_SER_Value1_" + sCheckGroup));

	if (iOff)
	{
		if (iRunFlag)
			iRunFlag = FALSE;
		else
			iRunFlag = TRUE;		
	}
	SetLocalInt(oTarget, "LEG_QUEST_SE_Run", iRunFlag);
}



void LEG_QUEST_SER_ForceConversation(object oSE, string sCheckGroup, int iOff = 0)
{
	object oTarget = LEG_QUEST_SE_GetObject(oSE, sCheckGroup, GetLocalString(oSE, "LEG_SER_Target_" + sCheckGroup));
	if (!iOff)
	{
		object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oTarget);
		MarkAsDone(oTarget);
		AssignCommand(oTarget, SurrenderToEnemies());
		ChangeFaction(oTarget, GetObjectByTag("leg_quest_se_neutral"));
		object oPlayer = GetFirstFactionMember(oPC, FALSE);
		while(GetIsObjectValid(oPlayer))
		{
			AssignCommand(oPlayer, ClearAllActions(TRUE));
			oPlayer = GetNextFactionMember(oPC, FALSE);
		}
		string sConversation = GetLocalString(oSE, "LEG_SER_SubObject1_" + sCheckGroup);
		CreateIPSpeaker(GetTag(oTarget), sConversation, GetLocation(oTarget), 0.0, oPC);
		DelayCommand(10.0, MarkAsUndone(oTarget));
	}
}

void LEG_QUEST_SER_TeleportSingle(object oSE, string sCheckGroup, int iOff = 0)
{
	object oTarget = LEG_QUEST_SE_GetObject(oSE, sCheckGroup, GetLocalString(oSE, "LEG_SER_Target_" + sCheckGroup));
	object oDestination = GetObjectByTag(GetLocalString(oSE, "LEG_SER_SubObject1_" + sCheckGroup));
	if (!iOff)
	{
		AssignCommand(oTarget, ClearAllActions());
		AssignCommand(oTarget, ActionJumpToObject(oDestination));
	}	
}


void LEG_QUEST_SER_Heal(object oSE, string sCheckGroup, int iOff = 0)
{
	object oTarget = LEG_QUEST_SE_GetObject(oSE, sCheckGroup, GetLocalString(oSE, "LEG_SER_Target_" + sCheckGroup));
	float fPercent = StringToFloat(GetLocalString(oSE, "LEG_SER_SubObject1_" + sCheckGroup)) / 100;
	if (!iOff)
	{
		int iMaxHP = GetMaxHitPoints(oTarget);
		int iHPTarget = FloatToInt(IntToFloat(iMaxHP) * fPercent);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(iHPTarget - GetCurrentHitPoints()), oTarget);
	}	
}

void LEG_QUEST_SER_ChangeMobAI(object oSE, string sCheckGroup, int iOff = 0)
{
	object oTarget = LEG_QUEST_SE_GetObject(oSE, sCheckGroup, GetLocalString(oSE, "LEG_SER_Target_" + sCheckGroup));
	int iProfile = StringToInt(GetLocalString(oSE, "LEG_SER_SubObject1_" + sCheckGroup));
	string sType = GetLocalString(oSE, "LEG_SER_SubObject2_" + sCheckGroup);

	if (sType == "WP")
	{
		string sParentID = GetLocalString(oTarget, "LEG_SPAWN_ParentID");
		string sCountType = GetLocalString(oTarget, "LEG_SPAWN_Count");
		
		if (sCountType == "Full")
		{
			// Cycle through the array and look for a spawner.  (Note we skip element 0)
			string sMobResRef = LEG_COMMON_GetFirstArrayElement(oTarget, sParentID + "ResRef");
			int iIndex = 1;
			while (sMobResRef != "#OUTOFBOUNDS#" && sMobResRef != "#EOA#")
			{
				// Now look for a mob or placeable with this array index.
				object oMob = GetLocalObject(oTarget, "SPAWN_" + IntToString(iIndex));
				if (GetIsObjectValid(oMob))
				{
					// Mob exists and is alive
					if (!iOff)
						SetLocalInt(oMob, "LEG_AI_ChangeCalled", iProfile);
					else
						SetLocalInt(oMob, "LEG_AI_ChangeCalled", 1);
						
					// We're changing AI Profiles which means if we have multiple NPC Task types, we need to clear
					// this NPC's list of tasks from the previous AI profile and set up the new ones.  This means
					// we need to de-initialize him and clear his random task array.
					SetLocalInt(oMob, "AI_RandomNPCInit", 0);
					LEG_COMMON_ClearArray(oMob, "AI_RandomActions");
					
					// If the NPC was on an NPC task WP, we need to free it up for others to use now that we're switching.
					object oTaskWP = GetLocalObject(oMob, "AI_TaskWP");
					if (GetIsObjectValid(oTaskWP))
						SetLocalInt(oTaskWP, "AI_Inuse", 0);
				
					// Now delete his currently stored Task WP
					DeleteLocalObject(oMob, "AI_TaskWP");
					
					// Re-Init					
					ExecuteScript("leg_ai_onspawn", oMob);
				}
				sMobResRef = LEG_COMMON_GetNextArrayElement(oTarget, sParentID + "ResRef");
			}	
		}
		else
		{
			int iTotalCount = GetLocalInt(oTarget, "LEG_SPAWN_CountTotal");
			
			// See how many spawns are alive.
			int iIndex = 1;
			object oMob;
			for (iIndex = 1; iIndex <= iTotalCount; iIndex++)
			{
				//SpeakString("Processing Index: " + IntToString(iIndex), TALKVOLUME_SHOUT);
				oMob = GetLocalObject(oTarget, "SPAWN_" + IntToString(iIndex));
				if (GetIsObjectValid(oMob))
				{
					// Mob exists and is alive
					if (!iOff)
						SetLocalInt(oMob, "LEG_AI_ChangeCalled", iProfile);
					else
						SetLocalInt(oMob, "LEG_AI_ChangeCalled", 1);
					
					// We're changing AI Profiles which means if we have multiple NPC Task types, we need to clear
					// this NPC's list of tasks from the previous AI profile and set up the new ones.  This means
					// we need to de-initialize him and clear his random task array.
					SetLocalInt(oMob, "AI_RandomNPCInit", 0);
					LEG_COMMON_ClearArray(oMob, "AI_RandomActions");

					// If the NPC was on an NPC task WP, we need to free it up for others to use now that we're switching.
					object oTaskWP = GetLocalObject(oMob, "AI_TaskWP");
					if (GetIsObjectValid(oTaskWP))
						SetLocalInt(oTaskWP, "AI_Inuse", 0);
				
					// Now delete his currently stored Task WP
					DeleteLocalObject(oMob, "AI_TaskWP");
					
					// Re-Init					
					ExecuteScript("leg_ai_onspawn", oMob);
					
				}
			}
		}		
	}
	else
	{
		if (!iOff)
			SetLocalInt(oTarget, "LEG_AI_ChangeCalled", iProfile);
		else
			SetLocalInt(oTarget, "LEG_AI_ChangeCalled", 1);	
			
		// Re-Call spawn script to set these (Hope this works LOL)
		ExecuteScript("leg_ai_onspawn", oTarget);
	}
}


void LEG_QUEST_SER_GiveItem(object oSE, string sCheckGroup, int iOff = 0)
{
	string sResRef = GetLocalString(oSE, "LEG_SER_Target_" + sCheckGroup);
	if (!iOff)
	{
		int iQty = StringToInt(GetLocalString(oSE, "LEG_SER_SubObject1_" + sCheckGroup));
		string sContainer = GetLocalString(oSE, "LEG_SER_SubObject2_" + sCheckGroup);
		
		float fRadius = 20.0;
	
		// Check for objects
		object oContainer;
		object oObject = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oSE), FALSE, OBJECT_TYPE_CREATURE);
		float fDelay = 0.0;
		while (GetIsObjectValid(oObject))
		{
			if (GetIsPC(oObject))
			{
				fDelay = fDelay + 0.5;
				oContainer = LEG_COMMON_GetInventoryItemByTag(oObject, sContainer);
				LEG_COMMON_CreateItem(oObject, sResRef, iQty, oContainer);
			}
			oObject = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oSE), FALSE, OBJECT_TYPE_CREATURE);
		}			
	}	
}

void LEG_QUEST_SER_RemoveItem(object oSE, string sCheckGroup, int iOff = 0)
{
	string sTag = GetLocalString(oSE, "LEG_SER_Target_" + sCheckGroup);
	if (!iOff)
	{
		int iQty = StringToInt(GetLocalString(oSE, "LEG_SER_SubObject1_" + sCheckGroup));
		
		float fRadius = 20.0;
	
		// Check for objects
		object oObject = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oSE), FALSE, OBJECT_TYPE_CREATURE);
		float fDelay = 0.0;
		while (GetIsObjectValid(oObject))
		{
			if (GetIsPC(oObject))
			{
				fDelay = fDelay + 0.5;
				LEG_COMMON_DestroyItemsByTag(oObject, sTag, iQty);
			}
			oObject = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oSE), FALSE, OBJECT_TYPE_CREATURE);
		}			
	}	
}


void LEG_QUEST_SER_GiveGold(object oSE, string sCheckGroup, int iOff = 0)
{
	object oTarget = LEG_QUEST_SE_GetObject(oSE, sCheckGroup, GetLocalString(oSE, "LEG_SER_Target_" + sCheckGroup));
	if (!iOff)
	{
		int iQty = StringToInt(GetLocalString(oSE, "LEG_SER_SubObject1_" + sCheckGroup));
		int iPersist = GetLocalInt(oSE, "LEG_SER_CheckBoxValue1_" + sCheckGroup);	
		string sUniqueID = GetTag(oSE);
		string sTableID = "";
		float fRadius = 15.0;
	
		// Check for objects
		object oObject = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oSE), FALSE, OBJECT_TYPE_CREATURE);
		float fDelay = 0.0;
		while (GetIsObjectValid(oObject))
		{
			if (GetIsPC(oObject))
			{
				if (iPersist != 1)
					LEG_COMMON_CreateItem(oObject, "nw_it_gold001", iQty);
				else
				{
					sTableID = LEG_COMMON_GetPC2Table(oObject);
					if (GetPersistentInt(oObject, "QuestID_SEGold_" + sCheckGroup + sUniqueID, sTableID) != 1)
					{
						LEG_COMMON_CreateItem(oObject, "nw_it_gold001", iQty);
						SetPersistentInt(oObject, "QuestID_SEGold_" + sCheckGroup + sUniqueID, 1, 0, sTableID);	
					}
				}
			}
			
			oObject = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oSE), FALSE, OBJECT_TYPE_CREATURE);
		}
	}	
}


void LEG_QUEST_SER_GiveXP(object oSE, string sCheckGroup, int iOff = 0)
{
	object oTarget = LEG_QUEST_SE_GetObject(oSE, sCheckGroup, GetLocalString(oSE, "LEG_SER_Target_" + sCheckGroup));
	if (!iOff)
	{
		int iXP = StringToInt(GetLocalString(oSE, "LEG_SER_SubObject1_" + sCheckGroup));
		int iStatic = GetLocalInt(oSE, "LEG_SER_RadSet12_" + sCheckGroup);
		int iLevel = StringToInt(GetLocalString(oSE, "LEG_SER_Value1_" + sCheckGroup));
		int iPersist = GetLocalInt(oSE, "LEG_SER_CheckBoxValue1_" + sCheckGroup);
		string sUniqueID = GetTag(oSE);
		string sTableID = "";	
		float fRadius = 15.0;
	
		// Check for objects
		object oObject = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oSE), FALSE, OBJECT_TYPE_CREATURE);
		float fDelay = 0.0;
		while (GetIsObjectValid(oObject))
		{
			if (GetIsPC(oObject))
			{
				if (iStatic != 1)
				{ 
					// Adjust XP reward based on level.. we don't want high level players getting too much XP from low
					// level quests so lets chop it up some.
					int iPCLevel = GetTotalLevels(oObject, FALSE);
					if (iPCLevel - iLevel > 1)
						iXP = iXP / (iPCLevel - iLevel);
				}

				string sParameter1 = IntToString(iXP);
				if (iPersist != 1)
				{			
					// Now Hand the XP over and display how much we got!
					GiveXPToCreature(oObject, iXP);
					FloatingTextStringOnCreature("<color=lightblue> " + sParameter1 + " XP Gained </color>", oObject, FALSE);				
				}
				else
				{
					sTableID = LEG_COMMON_GetPC2Table(oObject);
					if (GetPersistentInt(oObject, "QuestID_SEXP_" + sCheckGroup + sUniqueID, sTableID) != 1)
					{
						GiveXPToCreature(oObject, iXP);
						FloatingTextStringOnCreature("<color=lightblue> " + sParameter1 + " XP Gained </color>", oObject, FALSE);				
						SetPersistentInt(oObject, "QuestID_SEXP_" + sCheckGroup + sUniqueID, 1, 0, sTableID);	
					}					
				}
			}
			oObject = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oSE), FALSE, OBJECT_TYPE_CREATURE);
		}			
	}	
}

void LEG_QUEST_SER_StartConversation(object oSE, string sCheckGroup, int iOff = 0)
{
	object oTarget = LEG_QUEST_SE_GetObject(oSE, sCheckGroup, GetLocalString(oSE, "LEG_SER_Target_" + sCheckGroup));
	if (!iOff)
	{
		object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oTarget);
		MarkAsDone(oTarget);
		object oPlayer = GetFirstFactionMember(oPC, FALSE);
		while(GetIsObjectValid(oPlayer))
		{
			AssignCommand(oPlayer, ClearAllActions(TRUE));
			oPlayer = GetNextFactionMember(oPC, FALSE);
		}
		string sConversation = GetLocalString(oSE, "LEG_SER_SubObject1_" + sCheckGroup);
		CreateIPSpeaker(GetTag(oTarget), sConversation, GetLocation(oTarget), 0.0, oPC);
		DelayCommand(10.0, MarkAsUndone(oTarget));
	}
}

void LEG_QUEST_SER_SetFacing(object oSE, string sCheckGroup, int iOff = 0)
{
	object oTarget = LEG_QUEST_SE_GetObject(oSE, sCheckGroup, GetLocalString(oSE, "LEG_SER_Target_" + sCheckGroup));
	if (!iOff)
	{
		string sObjectTag = GetLocalString(oSE, "LEG_SER_SubObject1_" + sCheckGroup);
		float fFacing = GetFacing(oTarget);
		float fWPFacing = GetFacing(GetObjectByTag(sObjectTag)) + 180.0;
		if (fFacing != fWPFacing)
		{
			AssignCommand(oTarget, SetFacing(fWPFacing));
		}
	}
}


void LEG_QUEST_SER_Teleport(object oSE, string sCheckGroup, int iOff = 0)
{
	object oTarget = LEG_QUEST_SE_GetObject(oSE, sCheckGroup, GetLocalString(oSE, "LEG_SER_Target_" + sCheckGroup));
	if (!iOff)
	{
		string sWP = GetLocalString(oSE, "LEG_SER_SubObject1_" + sCheckGroup);
		float fRadius = StringToFloat(GetLocalString(oSE, "LEG_SER_Value1_" + sCheckGroup));
		int iTeleporters = GetLocalInt(oSE, "LEG_SER_RadSet12_" + sCheckGroup);

		if (fRadius == 0.0)
			fRadius = 20.0;
		
		// Check for objects
		object oObject = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oTarget), FALSE, OBJECT_TYPE_CREATURE);
		float fDelay = 0.0;
		while (GetIsObjectValid(oObject))
		{
			if (iTeleporters == 1)
			{
				if (!GetIsPC(oObject))
				{
					fDelay = fDelay + 0.5;
					DelayCommand(fDelay, LEG_COMMON_ExecuteScript("leg_tele_send", oObject, oObject, OBJECT_INVALID, sWP));
				}
			}
			else
			{
				if (GetIsPC(oObject))
				{
					fDelay = fDelay + 0.5;
					DelayCommand(fDelay, LEG_COMMON_ExecuteScript("leg_tele_send", oObject, oObject, OBJECT_INVALID, sWP));
				}
			}
			oObject = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oTarget), FALSE, OBJECT_TYPE_CREATURE);
		}	
	}
}

void LEG_QUEST_SER_KillGroup(object oSE, string sCheckGroup, int iOff = 0)
{
	object oTarget = LEG_QUEST_SE_GetObject(oSE, sCheckGroup, GetLocalString(oSE, "LEG_SER_Target_" + sCheckGroup));
	if (!iOff)
	{
		string sObject = GetLocalString(oSE, "LEG_SER_SubObject1_" + sCheckGroup);
		float fRadius = StringToFloat(GetLocalString(oSE, "LEG_SER_Value1_" + sCheckGroup));
	
		if (fRadius == 0.0)
			fRadius = 20.0;
		
		// Check for objects
		object oObject = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oTarget), FALSE, OBJECT_TYPE_CREATURE|OBJECT_TYPE_DOOR|OBJECT_TYPE_PLACEABLE);
		float fDelay = 0.0;
		effect eKill = EffectDamage(9999);
		
		while (GetIsObjectValid(oObject))
		{
			if (GetTag(oObject) == sObject)
			{
				if ((GetIsDead(oObject) == FALSE))
				{
					SetPlotFlag(oObject, FALSE);
					SetImmortal(oObject, FALSE);
					AssignCommand(oObject, SetIsDestroyable(TRUE, FALSE, FALSE));
					DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oObject ));
				}				
			}
			oObject = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oTarget), FALSE, OBJECT_TYPE_CREATURE|OBJECT_TYPE_DOOR|OBJECT_TYPE_PLACEABLE);
		}	
	}
}

void LEG_QUEST_SER_DestroyGroup(object oSE, string sCheckGroup, int iOff = 0)
{
	object oTarget = LEG_QUEST_SE_GetObject(oSE, sCheckGroup, GetLocalString(oSE, "LEG_SER_Target_" + sCheckGroup));
	if (!iOff)
	{
		string sObject = GetLocalString(oSE, "LEG_SER_SubObject1_" + sCheckGroup);
		float fRadius = StringToFloat(GetLocalString(oSE, "LEG_SER_Value1_" + sCheckGroup));
	
		if (fRadius == 0.0)
			fRadius = 20.0;
			
		// Check for objects
		object oObject = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oTarget), FALSE, OBJECT_TYPE_CREATURE|OBJECT_TYPE_DOOR|OBJECT_TYPE_PLACEABLE);
		float fDelay = 0.0;
		while (GetIsObjectValid(oObject))
		{
			if (GetTag(oObject) == sObject)
			{
				fDelay = fDelay + 0.1;
				SetPlotFlag(oObject, FALSE);
				SetImmortal(oObject, FALSE);
				AssignCommand(oObject, SetIsDestroyable(TRUE, FALSE, FALSE));
			
				// Stop me from patrolling now...
				SetLocalInt(oObject, "X2_L_SPAWN_USE_AMBIENT_IMMOBILE", 1);
				SetCreatureFlag(oObject, "CREATURE_VAR_USE_SPAWN_AMBIENT_IMMOBILE", TRUE);
				SetLocalString(oObject, "WP_TAG", "NA");
				SetWWPController("NA", oObject);
				AssignCommand(oObject, ClearAllActions());
				AssignCommand(oObject, WalkWayPoints(FALSE, "heartbeat"));	
				SetBumpState(oObject, BUMPSTATE_UNBUMPABLE);
				
				// Assign a player to my death.  Useful for quest based spawners.  Be careful though, don't destroy mobs the players ACTUALLY need to kill later on with this.
				object oPlayerObject = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oSE), FALSE, OBJECT_TYPE_CREATURE);
				while (GetIsObjectValid(oPlayerObject))
				{
					if (GetIsPC(oPlayerObject))
					{
						SetLocalObject(oObject, "SE_PlayerKiller", oPlayerObject);
					}
					oPlayerObject = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oSE), FALSE, OBJECT_TYPE_CREATURE);
				}			
				
				// Added because often the death script for spawn doesn't fire, so let's do this just in case.
				ExecuteScript("leg_all_masterdeath", oTarget);
				DestroyObject(oObject, 1.0);				
			}
			oObject = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oTarget), FALSE, OBJECT_TYPE_CREATURE|OBJECT_TYPE_DOOR|OBJECT_TYPE_PLACEABLE);
		}	
	}
}

void LEG_QUEST_SER_SetLock(object oSE, string sCheckGroup, int iOff = 0)
{
	object oTarget = LEG_QUEST_SE_GetObject(oSE, sCheckGroup, GetLocalString(oSE, "LEG_SER_Target_" + sCheckGroup));
	int iLock = StringToInt(GetLocalString(oSE, "LEG_SER_Value1_" + sCheckGroup));

	if (iOff)
	{
		if (iLock)
			iLock = FALSE;
		else
			iLock = TRUE;		
	}
	
	// Ensure door is closed.
	if (GetIsOpen(oTarget))
	{
		AssignCommand(oTarget, ActionCloseDoor(oTarget));
		DelayCommand(5.0, SetLocked(oTarget, iLock));
	}
	else
	{
		SetLocked(oTarget, iLock);
	}
}


void LEG_QUEST_SER_OpenClose(object oSE, string sCheckGroup, int iOff = 0)
{
	object oTarget = LEG_QUEST_SE_GetObject(oSE, sCheckGroup, GetLocalString(oSE, "LEG_SER_Target_" + sCheckGroup));
	int iOpen = StringToInt(GetLocalString(oSE, "LEG_SER_Value1_" + sCheckGroup));

	if (iOff)
	{
		if (iOpen)
			iOpen = FALSE;
		else
			iOpen = TRUE;		
	}
	
	// Ensure door is closed.
	if (GetIsOpen(oTarget) && iOpen == FALSE)
	{
		AssignCommand(oTarget, ActionCloseDoor(oTarget));
	}
	else if (GetIsOpen(oTarget) == FALSE && iOpen == TRUE)
	{
		AssignCommand(oTarget, ActionOpenDoor(oTarget));
	}
}

void LEG_QUEST_SER_SetHidden(object oSE, string sCheckGroup, int iOff = 0)
{
	object oTarget = LEG_QUEST_SE_GetObject(oSE, sCheckGroup, GetLocalString(oSE, "LEG_SER_Target_" + sCheckGroup));
	int iHidden = StringToInt(GetLocalString(oSE, "LEG_SER_Value1_" + sCheckGroup));
	
	if (iOff)
	{
		if (iHidden)
			iHidden = FALSE;
		else
			iHidden = TRUE;		
	}
	SetScriptHidden(oTarget, iHidden, iHidden);
}

void LEG_QUEST_SER_SetPlot(object oSE, string sCheckGroup, int iOff = 0)
{
	object oTarget = LEG_QUEST_SE_GetObject(oSE, sCheckGroup, GetLocalString(oSE, "LEG_SER_Target_" + sCheckGroup));
	int iPlotFlag = StringToInt(GetLocalString(oSE, "LEG_SER_Value1_" + sCheckGroup));
	
	if (iOff)
	{
		if (iPlotFlag)
			iPlotFlag = FALSE;
		else
			iPlotFlag = TRUE;		
	}
	SetLocalInt(oTarget, "LEG_QUEST_SE_PlotOverride", iPlotFlag);
	SetPlotFlag(oTarget, iPlotFlag);
}

void LEG_QUEST_SER_SetImmortal(object oSE, string sCheckGroup, int iOff = 0)
{
	object oTarget = LEG_QUEST_SE_GetObject(oSE, sCheckGroup, GetLocalString(oSE, "LEG_SER_Target_" + sCheckGroup));
	int iImmortalFlag = StringToInt(GetLocalString(oSE, "LEG_SER_Value1_" + sCheckGroup));

	if (iOff)
	{
		if (iImmortalFlag)
			iImmortalFlag = FALSE;
		else
			iImmortalFlag = TRUE;		
	}
	SetImmortal(oTarget, iImmortalFlag);
}

void LEG_QUEST_SER_SetUseable(object oSE, string sCheckGroup, int iOff = 0)
{
	object oTarget = LEG_QUEST_SE_GetObject(oSE, sCheckGroup, GetLocalString(oSE, "LEG_SER_Target_" + sCheckGroup));
	int iUseableFlag = StringToInt(GetLocalString(oSE, "LEG_SER_Value1_" + sCheckGroup));

	if (iOff)
	{
		if (iUseableFlag)
			iUseableFlag = FALSE;
		else
			iUseableFlag = TRUE;		
	}
	SetUseableFlag(oTarget, iUseableFlag);
}


void LEG_QUEST_SER_InfoBox(object oSE, string sCheckGroup, int iBoxType, int iOff = 0)
{
	object oTarget = LEG_QUEST_SE_GetObject(oSE, sCheckGroup, GetLocalString(oSE, "LEG_SER_Target_" + sCheckGroup));
	if (!iOff)
	{
		// Check for objects
		string sInfo = GetLocalString(oSE, "LEG_SER_Info_" + sCheckGroup);
		string sDetailText = GetLocalString(oSE, "LEG_SER_InfoDetail_" + sCheckGroup);
		object oObject = GetFirstObjectInShape(SHAPE_SPHERE, 40.0, GetLocation(oTarget), FALSE, OBJECT_TYPE_CREATURE);
		while (GetIsObjectValid(oObject))
		{
			if (GetIsPC(oObject))
			{
				LEG_COMMON_DisplayInfoBox(oObject, sInfo, 1, 0, iBoxType);
				if (sDetailText != "")
					LEG_COMMON_DisplayInfoBox(oObject, sDetailText, 0, 0, 2);
			}
			oObject = GetNextObjectInShape(SHAPE_SPHERE, 40.0, GetLocation(oTarget), FALSE, OBJECT_TYPE_CREATURE);
		}	
	}	
}

void LEG_QUEST_SER_ChangeMusic(object oSE, string sCheckGroup, int iOff = 0, int iMusic = 0)
{
	if (!iOff)
	{
		object oArea = GetArea(OBJECT_SELF);
		int iMusicTrack = StringToInt(GetLocalString(oSE, "LEG_SER_SubObject1_" + sCheckGroup));
		string sTimeOfDay = GetLocalString(oSE, "LEG_SER_SubObject2_" + sCheckGroup);
		int iForcePlay = StringToInt(GetLocalString(oSE, "LEG_SER_Value1_" + sCheckGroup));
		
		// Music
		if (iMusic == 0)
		{
			if (sTimeOfDay == "Daytime" || sTimeOfDay == "Both")
			{
				SetLocalInt(oArea, "SER_Track0Daytime", MusicBackgroundGetDayTrack(oArea));
				MusicBackgroundChangeDay(oArea, iMusicTrack);
				if (iForcePlay)
					MusicBackgroundPlay(oArea);
			}
			if (sTimeOfDay == "Nighttime" || sTimeOfDay == "Both")
			{
				SetLocalInt(oArea, "SER_Track0Nighttime", MusicBackgroundGetNightTrack(oArea));
				MusicBackgroundChangeNight(oArea, iMusicTrack);
				if (iForcePlay)
					MusicBackgroundPlay(oArea);
			}
		}
		
		// Ambient Sounds - NOTE - there is not GET Ambient track so we can't "Reset" it.
		if (iMusic == 1)
		{
			if (sTimeOfDay == "Daytime" || sTimeOfDay == "Both")
			{
				AmbientSoundChangeDay(oArea, iMusicTrack);
				if (iForcePlay)
					AmbientSoundPlay(oArea);
			}
			if (sTimeOfDay == "Nighttime" || sTimeOfDay == "Both")
			{
				AmbientSoundChangeNight(oArea, iMusicTrack);
				if (iForcePlay)
					AmbientSoundPlay(oArea);
			}
		}
		
		// Battle Track
		if (iMusic == 2)
		{
			SetLocalInt(oArea, "SER_TrackBattle", MusicBackgroundGetBattleTrack(oArea));
			MusicBattleChange(oArea, iMusicTrack);
			if (iForcePlay)
				MusicBattlePlay(oArea);
		}
	}
	else
	{
		// Revert to original Music	
		object oArea = GetArea(OBJECT_SELF);
		string sTimeOfDay = GetLocalString(oSE, "LEG_SER_SubObject2_" + sCheckGroup);
		int iMusicTrack = GetLocalInt(oArea, "SER_Track" + IntToString(iMusic) + sTimeOfDay);
		
		// Music
		if (iMusic == 0)
		{
			if (sTimeOfDay == "Daytime" || sTimeOfDay == "Both")
			{
				MusicBackgroundChangeDay(oArea, iMusicTrack);
			}
			if (sTimeOfDay == "Nighttime" || sTimeOfDay == "Both")
			{
				MusicBackgroundChangeNight(oArea, iMusicTrack);
			}
		}
		
		// Battle Track
		if (iMusic == 2)
		{
			MusicBattleChange(oArea, GetLocalInt(oArea, "SER_TrackBattle"));
		}
	}	
}

void LEG_QUEST_SER_PlaySound(object oSE, string sCheckGroup, int iOff = 0)
{
	object oTarget = LEG_QUEST_SE_GetObject(oSE, sCheckGroup, GetLocalString(oSE, "LEG_SER_Target_" + sCheckGroup));
	if (!iOff)
	{
		string sSound = GetLocalString(oSE, "LEG_SER_Value1_" + sCheckGroup);
		AssignCommand(oTarget, PlaySound(sSound));
		
	}
}


void LEG_QUEST_SER_Damage(object oSE, string sCheckGroup, int iOff = 0)
{
	if (!iOff)
	{
		// Damage all nearby placeable objects, players and monsters.
		float fDuration = GetLocalFloat(oSE, "LEG_SER_fValue2_" + sCheckGroup);
		float fInterval = GetLocalFloat(oSE, "LEG_SER_fValue3_" + sCheckGroup);

		// Check for objects
		if (fDuration <= 0.0)
		{	
			LEG_QUEST_SER_GoDamage(oSE, sCheckGroup);
		}
		else
		{
			// We have to do damage more than once.
			int iNumberOfHits = FloatToInt(fDuration / fInterval);
			int iIndex = 0;
			for (iIndex = 0; iIndex <= iNumberOfHits; iIndex++)
			{
				float fDelay = IntToFloat(iIndex) * fInterval;	
				DelayCommand(fDelay, LEG_QUEST_SER_GoDamage(oSE, sCheckGroup));
			}	
		}
	}
}

void LEG_QUEST_SER_ObjComplete(object oSE, string sCheckGroup)
{
	// Get the Vars
	string sQuestID = GetLocalString(oSE, "LEG_SER_SubObject1_" + sCheckGroup);
	string sNPC = GetLocalString(oSE, "LEG_SER_SubObject2_" + sCheckGroup);
	string sObj = GetLocalString(oSE, "LEG_SER_Value1_" + sCheckGroup);

	// So here's the biggest challenge with this.  What "TYPE" of objective did we just complete?
	SQLExecDirect("SELECT `ObjType" + sObj + "` FROM `" + QUESTPREFIX + "_objrefs` WHERE `QuestID` = '" + sQuestID + "' AND `QuestNPC` = '" + sNPC + "'");
	SQLFetch();
	string sObjType = SQLGetData(1);
	
	// Cycle through all players in the area.  If they have completed the ObjHide objective, then
	// their journal will update.  Otherwise, nothing will happen.
	object oPC = GetFirstObjectInShape(SHAPE_SPHERE, 30.0, GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oPC))
	{
		if (GetIsPC(oPC))
		{
			// Let's make sure player is on this quest and on this NPC first.
			int iPlayerNPC = GetLocalInt(oPC, "QuestID_" + sQuestID + "_NPC");				
			if (iPlayerNPC == StringToInt(sNPC))
			{
				if (sObjType == "FakeObjective")
				{
					// Lookup the Quest Objective as seen in journal.  This will be used to show what we completed.
					SQLExecDirect("SELECT `Objective" + sObj + "_Text` FROM `" + QUESTPREFIX + "_mainquests` WHERE `QuestID` = '" + sQuestID + "' AND `QuestNPC` = '" + sNPC + "'");
					SQLFetch();
					string sObjectiveText = SQLGetData(1);
					
					LEG_QUEST_ObjectiveCredit(sQuestID, oPC, "", "", 1, 1, StringToInt(sObj), "", StringToInt(sNPC), "Completed - " + sObjectiveText, 0);
				}
				/*  We added these for possible future use but right now, it's too complicated to add "real objectives" due to the issues with
					figuring out if the Quest NPC needs advancing, quantity of items etc etc.
				else if (sObjType == "DiscoverPlace")
				{
					
				
				}
				else if (sObjType == "Eavesdrop")
				{
					
				
				}
				else if (sObjType == "ExaminePlaceable")
				{
					
				
				}
				else if (sObjType == "KillSomething")
				{
					
				
				}
				else if (sObjType == "LootCreature")
				{
					
				
				}
				else if (sObjType == "LootPlaceable")
				{
				}
				else if (sObjType == "ObtainItem")
				{
					
				
				}
				*/
			}
		}
		oPC = GetNextObjectInShape(SHAPE_SPHERE, 30.0, GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_CREATURE);
	}
}

void LEG_QUEST_SER_ObjChange(object oSE, string sCheckGroup)
{
	// We put this in here because as of SE 2.00 we changed this around so this is here for backward compatability.
	int iTest = StringToInt(GetLocalString(oSE, "LEG_SER_SubObject1_" + sCheckGroup));
	string sQuestID = "";
	int iNPC = 0;
	int iObjHide = 0;
	int iObjShow = 0;
	int iMustHaveHide = 0;
	
	if (iTest < 11)
	{
		// Change an objective - Backward Compatability
		sQuestID = GetLocalString(oSE, "LEG_SER_Value1_" + sCheckGroup);
		iNPC = StringToInt(GetLocalString(oSE, "LEG_SER_Value2_" + sCheckGroup));
		iObjHide = StringToInt(GetLocalString(oSE, "LEG_SER_SubObject1_" + sCheckGroup));
		iObjShow = StringToInt(GetLocalString(oSE, "LEG_SER_SubObject2_" + sCheckGroup));
		iMustHaveHide = StringToInt(GetLocalString(oSE, "LEG_SER_MustHaveHide_" + sCheckGroup));
	}
	else
	{
		// New as of 2.00
		sQuestID = GetLocalString(oSE, "LEG_SER_SubObject1_" + sCheckGroup);
		iNPC = StringToInt(GetLocalString(oSE, "LEG_SER_SubObject2_" + sCheckGroup));
		iObjHide = StringToInt(GetLocalString(oSE, "LEG_SER_Value1_" + sCheckGroup));
		iObjShow = StringToInt(GetLocalString(oSE, "LEG_SER_Value2_" + sCheckGroup));
		iMustHaveHide = StringToInt(GetLocalString(oSE, "LEG_SER_MustHaveHide_" + sCheckGroup));
	}
	
	// Cycle through all players in the area.  If they have completed the ObjHide objective, then
	// their journal will update.  Otherwise, nothing will happen.
	object oPC = GetFirstObjectInShape(SHAPE_SPHERE, 30.0, GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oPC))
	{
		if (GetIsPC(oPC))
		{
			// Let's make sure player is on this quest and on this NPC first.
			int iPlayerNPC = GetLocalInt(oPC, "QuestID_" + sQuestID + "_NPC");				
			if (iPlayerNPC == iNPC)
				LEG_QUEST_ObjRuleHideShow(oPC, sQuestID, iNPC, iObjHide, iObjShow, iMustHaveHide);
		}
		oPC = GetNextObjectInShape(SHAPE_SPHERE, 30.0, GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_CREATURE);
	}
}

void LEG_QUEST_SER_ShutDown(object oSE, string sCheckGroup)
{
	// Turn off all reactions
	LEG_QUEST_SE_GoReactions(oSE, 1);
	SetLocalInt(OBJECT_SELF, "OFF_IN_PROG", FALSE);
}



// //////////////////////////////////////////////////
// LEG_QUEST_SER_RemoveVisualEffects
// //////////////////////////////////////////////////
void LEG_QUEST_SER_RemoveVisualEffects(object oSE, string sCheckGroup, int iOff)
{
	object oTarget = LEG_QUEST_SE_GetObject(oSE, sCheckGroup, GetLocalString(oSE, "LEG_SER_Target_" + sCheckGroup));
	// Turn visual effects back on.
	if (!iOff)
	{
		// Turn visual effects off.  Something else will have to turn them on later or at the start.
	  	effect eLook = GetFirstEffect(oTarget);
	  	while (GetIsEffectValid(eLook)) 
		{
	    	if (GetIsEffectValid(eLook))
			{
	      		RemoveEffect(oTarget, eLook);
				eLook = GetFirstEffect(oTarget);
			}
			else	eLook = GetNextEffect(oTarget);
	  	}
	}
}


void LEG_QUEST_SER_ForceRest(object oSE, string sCheckGroup, int iOff = 0)
{
	object oTarget = LEG_QUEST_SE_GetObject(oSE, sCheckGroup, GetLocalString(oSE, "LEG_SER_Target_" + sCheckGroup));
	if (!iOff)
	{
		ForceRest(oTarget);
	}
}


void LEG_QUEST_SER_GoHostile(object oSE, string sCheckGroup, int iOff = 0)
{
	object oTarget = LEG_QUEST_SE_GetObject(oSE, sCheckGroup, GetLocalString(oSE, "LEG_SER_Target_" + sCheckGroup));
	if (!iOff)
	{
		ClearAllActions();
		ChangeToStandardFaction(oTarget, STANDARD_FACTION_HOSTILE);
		object oBadGuy = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oTarget);
		ClearPersonalReputation(oBadGuy, oTarget);
	    AdjustReputation(oBadGuy, oTarget, -100);
	    AdjustReputation(oTarget, oBadGuy, -100);
		DelayCommand(0.5, AssignCommand(oTarget, DetermineCombatRound(oBadGuy)));
	}
}

void LEG_QUEST_SER_RemoveHostile(object oSE, string sCheckGroup, int iOff = 0)
{
	object oTarget = LEG_QUEST_SE_GetObject(oSE, sCheckGroup, GetLocalString(oSE, "LEG_SER_Target_" + sCheckGroup));
	if (!iOff)
	{
		object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oTarget);
		MarkAsDone(oTarget);
		AssignCommand(oTarget, SurrenderToEnemies());
		ChangeFaction(oTarget, GetObjectByTag("leg_quest_se_neutral"));
		object oPlayer = GetFirstFactionMember(oPC, FALSE);
		while(GetIsObjectValid(oPlayer))
		{
			AssignCommand(oPlayer, ClearAllActions(TRUE));
			oPlayer = GetNextFactionMember(oPC, FALSE);
		}
		DelayCommand(10.0, MarkAsUndone(oTarget));
	}
}

void LEG_QUEST_SER_KillTarget(object oSE, string sCheckGroup, int iOff = 0)
{
	object oTarget = LEG_QUEST_SE_GetObject(oSE, sCheckGroup, GetLocalString(oSE, "LEG_SER_Target_" + sCheckGroup));
	if (!iOff)
	{
		SetPlotFlag(oTarget, FALSE);
		SetImmortal(oTarget, FALSE);
		AssignCommand(oTarget, SetIsDestroyable(TRUE, FALSE, FALSE));
		
		effect eKill = EffectDamage(9999);
		if (GetIsObjectValid(oTarget) == TRUE)
		{
			if ((GetIsDead(oTarget) == FALSE))
			{
				DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oTarget ));
			}
		}
	}
}

void LEG_QUEST_SER_Destroy(object oSE, string sCheckGroup, int iOff = 0)
{
	object oTarget = LEG_QUEST_SE_GetObject(oSE, sCheckGroup, GetLocalString(oSE, "LEG_SER_Target_" + sCheckGroup));
	if (!iOff)
	{
		SetPlotFlag(oTarget, FALSE);
		SetImmortal(oTarget, FALSE);
		AssignCommand(oTarget, SetIsDestroyable(TRUE, FALSE, FALSE));
	
		// Stop me from patrolling now...
		SetLocalInt(oTarget, "X2_L_SPAWN_USE_AMBIENT_IMMOBILE", 1);
		SetCreatureFlag(oTarget, "CREATURE_VAR_USE_SPAWN_AMBIENT_IMMOBILE", TRUE);
		SetLocalString(oTarget, "WP_TAG", "NA");
		SetWWPController("NA", oTarget);
		AssignCommand(oTarget, ClearAllActions());
		AssignCommand(oTarget, WalkWayPoints(FALSE, "heartbeat"));	
		SetBumpState(oTarget, BUMPSTATE_UNBUMPABLE);
		
		// Assign a player to my death.  Useful for quest based spawners.  Be careful though, don't destroy mobs the players ACTUALLY need to kill later on with this.
		object oPlayerObject = GetFirstObjectInShape(SHAPE_SPHERE, 20.0, GetLocation(oSE), FALSE, OBJECT_TYPE_CREATURE);
		while (GetIsObjectValid(oPlayerObject))
		{
			if (GetIsPC(oPlayerObject))
			{
				SetLocalObject(oTarget, "SE_PlayerKiller", oPlayerObject);
			}
			oPlayerObject = GetNextObjectInShape(SHAPE_SPHERE, 20.0, GetLocation(oSE), FALSE, OBJECT_TYPE_CREATURE);
		}			
		
		// Added because often the death script for spawn doesn't fire, so let's do this just in case.
		ExecuteScript("leg_all_masterdeath", oTarget);
		DestroyObject(oTarget, 1.0);
	}
}


void LEG_QUEST_SER_SetSpawn(object oSE, string sCheckGroup, int iOff = 0)
{
	object oTarget = LEG_QUEST_SE_GetObject(oSE, sCheckGroup, GetLocalString(oSE, "LEG_SER_Target_" + sCheckGroup));	
	if (iOff)
	{
		SetLocalInt(oTarget, "LEG_SPAWN_TriggerSpawn", TRUE);	
	}
	else
	{
		SetLocalInt(oTarget, "LEG_SPAWN_TriggerSpawn", FALSE);
	}
}

void LEG_QUEST_SER_FireSpawn(int iOff)
{
	if (!iOff)
	{
		ExecuteScript("leg_spawn_checkspawns", OBJECT_SELF);
		DelayCommand(3.1, ExecuteScript("leg_spawn_checkspawns", OBJECT_SELF));
	}
}


void LEG_QUEST_SER_CastSpell(object oSE, string sCheckGroup, int iOff = 0, int iFakeSpell = FALSE)
{
	object oTarget = LEG_QUEST_SE_GetObject(oSE, sCheckGroup, GetLocalString(oSE, "LEG_SER_Target_" + sCheckGroup));
	object oSpellTarget = LEG_QUEST_SE_GetObject(oSE, sCheckGroup, GetLocalString(oSE, "LEG_SER_SubObject1_" + sCheckGroup));
	int iSpellId = StringToInt(GetLocalString(oSE, "LEG_SER_SubObject2_" + sCheckGroup));

	// Prevent AI from interupting this
	SetLocalInt(oTarget, "AI_Override", 1);
	AssignCommand(oTarget, ClearAllActions());
	
	if (iOff)
	{
		if (!iFakeSpell)
			LEG_QUEST_SER_RemoveEffectsFromSpell(oSpellTarget, 100 + StringToInt(sCheckGroup));
	}
	else
	{
		if (!iFakeSpell)
			AssignCommand(oTarget, ActionCastSpellAtObject(iSpellId, oSpellTarget, METAMAGIC_ANY, TRUE));
		else
			AssignCommand(oTarget, ActionCastFakeSpellAtObject(iSpellId, oSpellTarget));
	}
	
	// Reset AI back to normal
	DelayCommand(6.0, SetLocalInt(oTarget, "AI_Override", 0));
}

void LEG_QUEST_SER_VisualEffect(object oSE, string sCheckGroup, int iOff = 0)
{
	object oTarget = LEG_QUEST_SE_GetObject(oSE, sCheckGroup, GetLocalString(oSE, "LEG_SER_Target_" + sCheckGroup));
	object oSource = LEG_QUEST_SE_GetObject(oSE, sCheckGroup, GetLocalString(oSE, "LEG_SER_SubObject1_" + sCheckGroup));
	effect eEffect;
	float fDuration = StringToFloat(GetLocalString(oSE, "LEG_SER_Value1_" + sCheckGroup));
	int iEffectId = StringToInt(GetLocalString(oSE, "LEG_SER_SubObject2_" + sCheckGroup));

	if (iOff)
	{
		LEG_QUEST_SER_RemoveEffectsFromSpell(oTarget, 100 + StringToInt(sCheckGroup));
	}
	else
	{
		if (iEffectId > 0)
		{
			int iRows = GetNum2DARows("visualeffects");
		    string sType;
			if (iEffectId <= iRows - 1)
	        	sType = Get2DAString("visualeffects", "Type_FD", iEffectId);
			else
			{
				iEffectId = iEffectId - iRows;
				sType = Get2DAString("sj_sef_browser", "TYPE", iEffectId);
			}
	
			// Display the effect according to type
		    if(sType == "B")
		    {
		        // beams
		        effect eEffect = SetEffectSpellId(EffectBeam(iEffectId, oSource, BODY_NODE_CHEST), 100 + StringToInt(sCheckGroup));
				if (fDuration == -1.0)
					ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oTarget); 
				else
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, fDuration); 
		    }
		    else if(sType == "D")
		    {
		        // duration VFXs
		        effect eEffect = SetEffectSpellId(EffectVisualEffect(iEffectId), 100 + StringToInt(sCheckGroup));
				if (fDuration == -1.0)
					ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oTarget); 
				else
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, fDuration); 
		    }
		    else if(sType == "F")
		    {
		        // fire and forget
		        effect eEffect = SetEffectSpellId(EffectVisualEffect(iEffectId), 100 + StringToInt(sCheckGroup));
		        ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, oTarget); 
		    }
		    else if(sType == "P")
		    {
		        // projectile VFXs
		        effect eEffect = SetEffectSpellId(EffectVisualEffect(iEffectId), 100 + StringToInt(sCheckGroup));
		        ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, oTarget); 
		    }
		    else if(sType == "C" || sType == "R")
		    {
		        // circular and rectangular AOEs
		        effect eEffect = SetEffectSpellId(EffectAreaOfEffect(iEffectId, "null", "null", "null"), 100 + StringToInt(sCheckGroup));
				if (fDuration == -1.0)
					ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eEffect, GetLocation(oTarget)); 
				else
		        	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eEffect, GetLocation(oTarget), fDuration); 
		    }
			else if (sType == "NWN2" || sType == "NX1" || sType == "NX2")
			{
				string sSefFile = Get2DAString("sj_sef_browser", "NAME", iEffectId);
				effect eEffect = SetEffectSpellId(EffectNWN2SpecialEffectFile(sSefFile, oSource), 100 + StringToInt(sCheckGroup));
				if (fDuration == -1.0)
					ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oTarget);
				else
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, fDuration);
			}
		}	
	}
}


// Check Flags
int LEG_QUEST_SE_CheckFlags(int iCheckFlags1)
{
	int i;
	int iReturnValue = TRUE;
	int iAreaFlags1 = GetLocalInt(GetArea(OBJECT_SELF), "QUEST_SE_Flags1");
	
	(iCheckFlags1 & 1) ? (!(iAreaFlags1 & 1) ? (iReturnValue = FALSE):(i = 0)):(i = 0);
	(iCheckFlags1 & 2) ? (!(iAreaFlags1 & 2) ? (iReturnValue = FALSE):(i = 0)):(i = 0);
	(iCheckFlags1 & 4) ? (!(iAreaFlags1 & 4) ? (iReturnValue = FALSE):(i = 0)):(i = 0);	
	(iCheckFlags1 & 8) ? (!(iAreaFlags1 & 8) ? (iReturnValue = FALSE):(i = 0)):(i = 0);	
	(iCheckFlags1 & 16) ? (!(iAreaFlags1 & 16) ? (iReturnValue = FALSE):(i = 0)):(i = 0);	
	(iCheckFlags1 & 32) ? (!(iAreaFlags1 & 32) ? (iReturnValue = FALSE):(i = 0)):(i = 0);	
	(iCheckFlags1 & 64) ? (!(iAreaFlags1 & 64) ? (iReturnValue = FALSE):(i = 0)):(i = 0);	
	(iCheckFlags1 & 128) ? (!(iAreaFlags1 & 128) ? (iReturnValue = FALSE):(i = 0)):(i = 0);	
	(iCheckFlags1 & 256) ? (!(iAreaFlags1 & 256) ? (iReturnValue = FALSE):(i = 0)):(i = 0);	
	(iCheckFlags1 & 512) ? (!(iAreaFlags1 & 512) ? (iReturnValue = FALSE):(i = 0)):(i = 0);	
	(iCheckFlags1 & 1024) ? (!(iAreaFlags1 & 1024) ? (iReturnValue = FALSE):(i = 0)):(i = 0);	
	(iCheckFlags1 & 2048) ? (!(iAreaFlags1 & 2048) ? (iReturnValue = FALSE):(i = 0)):(i = 0);	
	(iCheckFlags1 & 4096) ? (!(iAreaFlags1 & 4096) ? (iReturnValue = FALSE):(i = 0)):(i = 0);	
	(iCheckFlags1 & 8192) ? (!(iAreaFlags1 & 8192) ? (iReturnValue = FALSE):(i = 0)):(i = 0);	
	(iCheckFlags1 & 16384) ? (!(iAreaFlags1 & 16384) ? (iReturnValue = FALSE):(i = 0)):(i = 0);	
	(iCheckFlags1 & 32768) ? (!(iAreaFlags1 & 32768) ? (iReturnValue = FALSE):(i = 0)):(i = 0);	
	(iCheckFlags1 & 65536) ? (!(iAreaFlags1 & 65536) ? (iReturnValue = FALSE):(i = 0)):(i = 0);	
	(iCheckFlags1 & 131072) ? (!(iAreaFlags1 & 131072) ? (iReturnValue = FALSE):(i = 0)):(i = 0);	
	(iCheckFlags1 & 262144) ? (!(iAreaFlags1 & 262144) ? (iReturnValue = FALSE):(i = 0)):(i = 0);	
	(iCheckFlags1 & 524288) ? (!(iAreaFlags1 & 524288) ? (iReturnValue = FALSE):(i = 0)):(i = 0);	
	(iCheckFlags1 & 1048576) ? (!(iAreaFlags1 & 1048576) ? (iReturnValue = FALSE):(i = 0)):(i = 0);	
	(iCheckFlags1 & 2097152) ? (!(iAreaFlags1 & 2097152) ? (iReturnValue = FALSE):(i = 0)):(i = 0);	
	(iCheckFlags1 & 4194304) ? (!(iAreaFlags1 & 4194304) ? (iReturnValue = FALSE):(i = 0)):(i = 0);	
	(iCheckFlags1 & 8388608) ? (!(iAreaFlags1 & 8388608) ? (iReturnValue = FALSE):(i = 0)):(i = 0);	
	(iCheckFlags1 & 16777216) ? (!(iAreaFlags1 & 16777216) ? (iReturnValue = FALSE):(i = 0)):(i = 0);	
	(iCheckFlags1 & 33554432) ? (!(iAreaFlags1 & 33554432) ? (iReturnValue = FALSE):(i = 0)):(i = 0);	
	(iCheckFlags1 & 67108864) ? (!(iAreaFlags1 & 67108864) ? (iReturnValue = FALSE):(i = 0)):(i = 0);	
	(iCheckFlags1 & 134217728) ? (!(iAreaFlags1 & 134217728) ? (iReturnValue = FALSE):(i = 0)):(i = 0);	
	(iCheckFlags1 & 268435456) ? (!(iAreaFlags1 & 268435456) ? (iReturnValue = FALSE):(i = 0)):(i = 0);	
	(iCheckFlags1 & 536870912) ? (!(iAreaFlags1 & 536870912) ? (iReturnValue = FALSE):(i = 0)):(i = 0);	
	(iCheckFlags1 & 1073741824) ? (!(iAreaFlags1 & 1073741824) ? (iReturnValue = FALSE):(i = 0)):(i = 0);	
	return iReturnValue;
}

// Check Flags
int LEG_QUEST_SE_CheckOffFlags(int iCheckFlags1)
{
	int i;
	int iReturnValue = FALSE;
	int iAreaFlags1 = GetLocalInt(GetArea(OBJECT_SELF), "QUEST_SE_Flags1");
	
	if (iCheckFlags1 & 1 && iAreaFlags1 & 1) return TRUE;
	if (iCheckFlags1 & 2 && iAreaFlags1 & 2) return TRUE;
	if (iCheckFlags1 & 4 && iAreaFlags1 & 4) return TRUE;
	if (iCheckFlags1 & 8 && iAreaFlags1 & 8) return TRUE;
	if (iCheckFlags1 & 16 && iAreaFlags1 & 16) return TRUE;
	if (iCheckFlags1 & 32 && iAreaFlags1 & 32) return TRUE;
	if (iCheckFlags1 & 64 && iAreaFlags1 & 64) return TRUE;
	if (iCheckFlags1 & 128 && iAreaFlags1 & 128) return TRUE;
	if (iCheckFlags1 & 256 && iAreaFlags1 & 256) return TRUE;
	if (iCheckFlags1 & 512 && iAreaFlags1 & 512) return TRUE;
	if (iCheckFlags1 & 1024 && iAreaFlags1 & 1024) return TRUE;
	if (iCheckFlags1 & 2048 && iAreaFlags1 & 2048) return TRUE;
	if (iCheckFlags1 & 4096 && iAreaFlags1 & 4096) return TRUE;
	if (iCheckFlags1 & 8192 && iAreaFlags1 & 8192) return TRUE;
	if (iCheckFlags1 & 16384 && iAreaFlags1 & 16384) return TRUE;
	if (iCheckFlags1 & 32768 && iAreaFlags1 & 32768) return TRUE;
	if (iCheckFlags1 & 65536 && iAreaFlags1 & 65536) return TRUE;
	if (iCheckFlags1 & 131072 && iAreaFlags1 & 131072) return TRUE;
	if (iCheckFlags1 & 262144 && iAreaFlags1 & 262144) return TRUE;
	if (iCheckFlags1 & 524288 && iAreaFlags1 & 524288) return TRUE;
	if (iCheckFlags1 & 1048576 && iAreaFlags1 & 1048576) return TRUE;
	if (iCheckFlags1 & 2097152 && iAreaFlags1 & 2097152) return TRUE;
	if (iCheckFlags1 & 4194304 && iAreaFlags1 & 4194304) return TRUE;
	if (iCheckFlags1 & 8388608 && iAreaFlags1 & 8388608) return TRUE;
	if (iCheckFlags1 & 16777216 && iAreaFlags1 & 16777216) return TRUE;
	if (iCheckFlags1 & 33554432 && iAreaFlags1 & 33554432) return TRUE;
	if (iCheckFlags1 & 67108864 && iAreaFlags1 & 67108864) return TRUE;
	if (iCheckFlags1 & 134217728 && iAreaFlags1 & 134217728) return TRUE;
	if (iCheckFlags1 & 268435456 && iAreaFlags1 & 268435456) return TRUE;
	if (iCheckFlags1 & 536870912 && iAreaFlags1 & 536870912) return TRUE;
	if (iCheckFlags1 & 1073741824 && iAreaFlags1 & 1073741824) return TRUE;
	return iReturnValue;
}
// Get Object
object LEG_QUEST_SE_GetObject(object oSE, string sCheckGroup, string sTargetTag)
{
	object oObject;
	if (sTargetTag == "Module")
		oObject = GetModule();
	else if (sTargetTag == "Area")
		oObject = GetArea(OBJECT_SELF);
	else if (sTargetTag == "Self")
		oObject = oSE;
	else if (sTargetTag == "Other")
		return OBJECT_INVALID;
	else
		oObject = GetNearestObjectByTag(sTargetTag);
	
	if (GetIsObjectValid(oObject))
	{
		return oObject;
	}
	else
		return OBJECT_INVALID;	
}

void LEG_QUEST_SE_AreaOffFlags(object oSE, int iOff)
{
	int iTotalReactions = GetLocalInt(oSE, "LEG_SER_TotalReactionEvents");
	int iIndex, iFlagOff, iFlagSet;
	string sCheckGroup;
	for (iIndex = 1; iIndex <= iTotalReactions; iIndex++)
	{
		sCheckGroup = IntToString(iIndex);
		iFlagSet = GetLocalInt(oSE, "LEG_SER_FlagSet_" + sCheckGroup);
		if (LEG_QUEST_SE_CheckFlags(iFlagSet))
		{
			iFlagOff = GetLocalInt(GetArea(OBJECT_SELF), "LEG_QUEST_SE_FlagOff_" + IntToString(iFlagSet));
			if (iFlagOff || iOff)
			{
				LEG_QUEST_SER_SetFlag(GetArea(OBJECT_SELF), iFlagSet, 1);
				SetLocalInt(oSE, "LEG_SER_Active_" + sCheckGroup, FALSE);
			}
		}
	}	
}

void LEG_QUEST_SE_GoReactions(object oSE, int iOff = 0)
{
	// Find out how many reactions we go through.
	int iTotalReactions = GetLocalInt(oSE, "LEG_SER_TotalReactionEvents");
	int iIndex;
	string sCheckGroup;
	for (iIndex = 1; iIndex <= iTotalReactions; iIndex++)
	{
		// Get the Check Group as a String
		sCheckGroup = IntToString(iIndex);
		
		// See if this Reaction has an active check
		int iFlagSet = GetLocalInt(oSE, "LEG_SER_FlagSet_" + sCheckGroup);
		int iFlagSetOff = GetLocalInt(oSE, "LEG_SER_FlagSetOff_" + sCheckGroup);

		if (iOff == 1 || LEG_QUEST_SE_CheckFlags(iFlagSet))
		{
			// Our ON flags are on (or we're in an iOff situration.  So let's check for OFF flags.
			if (iOff == 1 || iFlagSetOff == 0 || !LEG_QUEST_SE_CheckOffFlags(iFlagSetOff))
			{
				// If we're turning off flags, then do it here.
				if (iOff)
				{
					// Turn Off Flags On
					LEG_QUEST_SER_SetFlag(GetArea(OBJECT_SELF), iFlagSetOff, 0);
				}
				
				// Go ahead and perform the reaction.  Start by getting the target and type.
				int iReactionType = GetLocalInt(oSE, "LEG_SER_ReactionType_" + sCheckGroup);
				int iMyFlag = GetLocalInt(oSE, "LEG_SER_Value_" + sCheckGroup);
				float fMyDelay = GetLocalFloat(oSE, "LEG_SER_Delay_" + sCheckGroup);
				if (!GetLocalInt(oSE, "LEG_SER_Active_" + sCheckGroup) || iOff == 1)
				{
					switch (iReactionType)
					{
						// A Flag set.
						case 1:	DelayCommand(fMyDelay, LEG_QUEST_SER_SetFlag(GetArea(OBJECT_SELF), iMyFlag, iOff)); break;	
						// Activate a spawn point
						case 2: 
								// If we are deactivating a spawn point, do it now rather than when the original spawn time elapsed.
								if (iOff == 1)
									LEG_QUEST_SER_SetSpawn(oSE, sCheckGroup, iOff);
								else
									DelayCommand(fMyDelay, LEG_QUEST_SER_SetSpawn(oSE, sCheckGroup, iOff)); 
								break;
						// Damage Area
						case 3: DelayCommand(fMyDelay, LEG_QUEST_SER_Damage(oSE, sCheckGroup, iOff)); break;	
						// A special visual effect
						case 4: DelayCommand(fMyDelay, LEG_QUEST_SER_VisualEffect(oSE, sCheckGroup, iOff)); break;
						// Play a sound
						case 5: DelayCommand(fMyDelay, LEG_QUEST_SER_PlaySound(oSE, sCheckGroup, iOff)); break;
						// Fire Spawn Script now that spawn points are active.
						case 6: DelayCommand(fMyDelay, LEG_QUEST_SER_FireSpawn(iOff)); break;
						case 7: DelayCommand(fMyDelay, LEG_QUEST_SER_InfoBox(oSE, sCheckGroup, 0, iOff)); break;
						case 8: DelayCommand(fMyDelay, LEG_QUEST_SER_InfoBox(oSE, sCheckGroup, 1, iOff)); break;
						case 9: DelayCommand(fMyDelay, LEG_QUEST_SER_SetPlot(oSE, sCheckGroup, iOff)); break;
						case 10: DelayCommand(fMyDelay, LEG_QUEST_SER_SetLock(oSE, sCheckGroup, iOff)); break;
						case 11: DelayCommand(fMyDelay, LEG_QUEST_SER_Teleport(oSE, sCheckGroup, iOff)); break;
						case 12: DelayCommand(fMyDelay, LEG_QUEST_SER_OpenClose(oSE, sCheckGroup, iOff)); break;
						case 13: DelayCommand(fMyDelay, LEG_QUEST_SER_RemoveVisualEffects(oSE, sCheckGroup, iOff)); break;
						case 14: DelayCommand(fMyDelay, LEG_QUEST_SER_StartConversation(oSE, sCheckGroup, iOff)); break;
						case 15: DelayCommand(fMyDelay, LEG_QUEST_SER_ChangeMobAI(oSE, sCheckGroup, iOff)); break;
						case 16: DelayCommand(fMyDelay, LEG_QUEST_SER_ForceConversation(oSE, sCheckGroup, iOff)); break;
						case 17: DelayCommand(fMyDelay, LEG_QUEST_SER_RunAI(oSE, sCheckGroup, iOff)); break;
						case 18: DelayCommand(fMyDelay, LEG_QUEST_SER_SpeakOneLine(oSE, sCheckGroup, iOff)); break;
						case 19: DelayCommand(fMyDelay, LEG_QUEST_SER_SetImmortal(oSE, sCheckGroup, iOff)); break;
						case 20: DelayCommand(fMyDelay, LEG_QUEST_SER_GoHostile(oSE, sCheckGroup, iOff)); break;
						case 21: DelayCommand(fMyDelay, LEG_QUEST_SER_Destroy(oSE, sCheckGroup, iOff)); break;
						case 22: DelayCommand(fMyDelay, LEG_QUEST_SER_SetUseable(oSE, sCheckGroup, iOff)); break;
						case 23: DelayCommand(fMyDelay, LEG_QUEST_SER_SetFacing(oSE, sCheckGroup, iOff)); break;
						case 24: DelayCommand(fMyDelay, LEG_QUEST_SER_SetSpawn(oSE, sCheckGroup, TRUE)); 
						case 25: DelayCommand(fMyDelay, LEG_QUEST_SER_ForceRest(oSE, sCheckGroup, iOff)); break;
						case 26: DelayCommand(fMyDelay, LEG_QUEST_SER_CastSpell(oSE, sCheckGroup, iOff)); break;
						case 27: DelayCommand(fMyDelay, LEG_QUEST_SER_CastSpell(oSE, sCheckGroup, iOff, TRUE)); break;
						case 28: DelayCommand(fMyDelay, LEG_QUEST_SER_ChangeMusic(oSE, sCheckGroup, iOff, 0)); break;
						case 29: DelayCommand(fMyDelay, LEG_QUEST_SER_ChangeMusic(oSE, sCheckGroup, iOff, 2)); break;
						case 30: DelayCommand(fMyDelay, LEG_QUEST_SER_ChangeMusic(oSE, sCheckGroup, iOff, 1)); break;
						case 31: DelayCommand(fMyDelay, LEG_QUEST_SER_KillTarget(oSE, sCheckGroup, iOff)); break;
						case 32: DelayCommand(fMyDelay, LEG_QUEST_SER_TeleportSingle(oSE, sCheckGroup, iOff)); break;
						case 33: DelayCommand(fMyDelay, LEG_QUEST_SER_DestroyGroup(oSE, sCheckGroup, iOff)); break;
						case 34: DelayCommand(fMyDelay, LEG_QUEST_SER_KillGroup(oSE, sCheckGroup, iOff)); break;
						case 35: DelayCommand(fMyDelay, LEG_QUEST_SER_GiveItem(oSE, sCheckGroup, iOff)); break;
						case 36: DelayCommand(fMyDelay, LEG_QUEST_SER_RemoveItem(oSE, sCheckGroup, iOff)); break;
						case 37: DelayCommand(fMyDelay, LEG_QUEST_SER_GiveGold(oSE, sCheckGroup, iOff)); break;
						case 38: DelayCommand(fMyDelay, LEG_QUEST_SER_GiveXP(oSE, sCheckGroup, iOff)); break;
						case 39: DelayCommand(fMyDelay, LEG_QUEST_SER_RemoveHostile(oSE, sCheckGroup, iOff)); break;
						case 40: DelayCommand(fMyDelay, LEG_QUEST_SER_SetHidden(oSE, sCheckGroup, iOff)); break;
						case 41: DelayCommand(fMyDelay, LEG_QUEST_SER_Heal(oSE, sCheckGroup, iOff)); break;
						
						case 126: DelayCommand(fMyDelay, LEG_QUEST_SER_ObjComplete(oSE, sCheckGroup)); break;
						case 127: if (!iOff) DelayCommand(fMyDelay, LEG_QUEST_SER_ObjChange(oSE, sCheckGroup)); break;	
						case 128: 
									if (iOff == FALSE && GetLocalInt(OBJECT_SELF, "OFF_IN_PROG") == FALSE)
									{
										SetLocalInt(OBJECT_SELF, "OFF_IN_PROG", TRUE);
										DelayCommand(fMyDelay, LEG_QUEST_SER_ShutDown(oSE, sCheckGroup)); 
									}
									break;
					}
					if (iOff)
					{
						SetLocalInt(oSE, "LEG_SER_Active_" + sCheckGroup, FALSE);
					}
					else if (iReactionType != 128)
					{
						SetLocalInt(oSE, "LEG_SER_Active_" + sCheckGroup, TRUE);
					}
				}
			}
		}
	}
	
	// If an NPC arrives at a waypoint that sets a flag, and the "turn off flag after reactions" is checked
	// Then that flag should be turned off once the reactions are allowed to go through.  The flag that
	// needs to be turned off, is stored as a variable in the area using the flag(s) as part of its name.  
	// This is done by the plugin.  
	LEG_QUEST_SE_AreaOffFlags(oSE, iOff);
	
	// If OFF, check for objects that have been pulled or opened (levers, doors) and reset them.
	if (iOff)
	{
		object oObject;
		string sObjectTag = LEG_COMMON_GetFirstArrayElement(OBJECT_SELF, "SE_OBJECT_STATES");
		while (sObjectTag != "#OUTOFBOUNDS#" && sObjectTag != "#EOA#")
		{
			oObject = GetObjectByTag(sObjectTag);
			if (GetIsObjectValid(oObject))
			{
				// Am I a lever?
				if (GetLocalInt(oObject, "LEG_QUEST_SE_Lever"))
				{
					AssignCommand(oObject, PlaySound("as_sw_lever1"));
					int nActive = GetLocalInt(oObject,"SE_LeverState");
					if (!nActive)
						AssignCommand(oObject, ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
					else
						AssignCommand(oObject, ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));
					SetLocalInt(oObject,"SE_LeverState",!nActive);
				}				
				// Turn associated flags off.
				int iMyFlagID = GetLocalInt(oObject, "LEG_QUEST_SE_MyFlag");		
				int iMyOffFlagID = GetLocalInt(oObject, "LEG_QUEST_SE_MyOffFlag");		
				LEG_QUEST_SER_SetFlag(GetArea(OBJECT_SELF), iMyFlagID, TRUE);
				LEG_QUEST_SER_SetFlag(GetArea(OBJECT_SELF), iMyOffFlagID, FALSE);
			}
			sObjectTag = LEG_COMMON_GetNextArrayElement(OBJECT_SELF, "SE_OBJECT_STATES");
		}
		
		// Clear out the Array. 
		LEG_COMMON_ClearArray(OBJECT_SELF, "SE_OBJECT_STATES");
	}		
}


// Allows for the ability to re-run a reaction set.  Use wisely.
void LEG_QUEST_SE_DeactivateActiveFlag(object oSEMan, int iDeactivatedFlags)
{
	// Find out how many reactions we go through.
	object oSE = GetLocalObject(oSEMan, "SPAWN_Parent");
	int iTotalReactions = GetLocalInt(oSE, "LEG_SER_TotalReactionEvents");
	int iIndex;
	string sCheckGroup;
	for (iIndex = 1; iIndex <= iTotalReactions; iIndex++)
	{
		// Get the Check Group as a String
		sCheckGroup = IntToString(iIndex);
		
		// If the passed flags that are off match the flags from this group...
		int iFlagSet = GetLocalInt(oSE, "LEG_SER_FlagSet_" + sCheckGroup);
		if (iFlagSet == iDeactivatedFlags)
		{
			// The deactivate this group
			SetLocalInt(oSE, "LEG_SER_Active_" + sCheckGroup, FALSE);
		}
	}		
}