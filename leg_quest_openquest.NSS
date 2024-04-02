/*

    Script:			Popup the Quest Box.  Called from the generic quest conversation.
	Version:		1.8
	Plugin Version: 2.00
	Author:			Marshall Vyper
	
	Change Log:		06/23/2011 - 1.00 MV - Initial Release
					10/12/2012 - 1.1 MV - Fixed bug where the "Required Items" message was coming up wrong.
					10/14/2012 - 1.2 MV - Implement all Requirement checking options					
					11/10/2012 - 1.3 MV - Fixed bug that would not properly give PROP items to players
					03/01/2013 - 1.4 MV - Added support to check for quantity of prop items to deliver in players inventory.
					03/12/2013 - 1.5 MV - Updated to resolve issues with checking for props and removing too many.
					12/27/2013 - 1.6 MV - Fixed bug where repeatable quests and reluctance failures would not honor time plugin.
					12/27/2013 - 1.7 MV - Fixed bug where prop items were not being removed if quest finisher gave the PC the prop item to start.					
					08/11/2015 - 1.8 MV - Plugins Version 2.0 - Added code for performing PC Data table consolidation					
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_quest_include"


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	// Fist let's see who is talking to me.  Enhance this so we can call this script from anything and not just
	// a conversation.
	object oNPC = OBJECT_SELF;
	object oPC = GetLastSpeaker();

	// The usual, am I a PC?  If not.. punt.
	if (!GetIsPC(oPC))
	{
		oPC = GetLocalObject(OBJECT_SELF, "LASTPC");
		if (!GetIsPC(oPC))
			return;
	}

	// Am I currently wandering along my path as a result of an escort quest?  If so, don't 
	// try interupting me with idle chatter!  I have places to be!
	if (GetLocalInt(OBJECT_SELF, "OnEscort") == 1)
		return;

	// Ok, now we're getting somewhere.  Let's do a nice hello.
	PlayVoiceChat(VOICE_CHAT_HELLO, oNPC);
	
	// Store this NPC object on the player in the event we need it for some reason (duh, we will).
	SetLocalObject(oPC, "QNPC", oNPC);
	
	// Create a name for the table structure for this player.  In this case, we're looking at
	// the "quests" table for this PC.
	string sTableID = LEG_COMMON_GetPC2Table(oPC);

	// Set up some vars.
	int iPlayerStep, iTotalQuests, iCount, iNPCPosition, iNextNPC, iFireOneliner, iQuestStarter, iQuestFinisher, iFirePostLiner, iFireFailure;
	string sQuestID, sRequirement, sQuestStarted, sCount;
	
	// Figure out if this NPC has any quests.
	iTotalQuests = GetLocalInt(oNPC, "LEG_QUEST_TotalQuests");

	// Initialize this var for use later.
	SetLocalInt(oPC, "QUEST_PreviousNPC", 0);
	
	// Loop through each quest and see if the PC is on one.  The PC can only be on
	// one of them at any given time so most NPC's with two quests are chain
	// quests.
	for (iCount=1; iCount<=iTotalQuests; iCount++)
	{
		// Get the string value of the counter so we can use it in *_ variables.
		sCount = IntToString(iCount);
		
		// Grab the Quest ID for this quest.
		sQuestID = GetLocalString(oNPC, "LEG_QUEST_QuestID_" + sCount);
				
		// See where the Player stands in this quest.
		iPlayerStep = GetLocalInt(oPC, "QuestID_" + sQuestID + "_NPC");
		
		// Find out which position along the quest line this NPC is.
		iNPCPosition = GetLocalInt(oNPC, "LEG_QUEST_NPCID_" + sCount);
		
		// Find out who the Next NPC is going to be (if there is one)
		iNextNPC = GetLocalInt(oNPC, "LEG_QUEST_NextNPC_" + sCount);
		
		// Find out if there is a previous requirement before an offer can take place.
		sRequirement = GetLocalString(oNPC, "LEG_QUEST_Requirement_" + sCount);
		sQuestStarted = GetLocalString(oNPC, "LEG_QUEST_QuestStarted_" + sCount);

		// Am I the quest starter?
		int iQuestStarter = GetLocalInt(oNPC, "LEG_QUEST_Starter_" + sCount);
		
		// Am I the quest finisher?
		int iQuestFinisher = GetLocalInt(oNPC, "LEG_QUEST_Finisher_" + sCount);
		
		// Am I reluctant?
		int iReluctance = GetLocalInt(oNPC, "LEG_QUEST_Reluctant_" + sCount);
		int iReluctantPassed = GetLocalInt(oPC, "QuestID_" + sQuestID + "_" + IntToString(iPlayerStep) + "_ReluctantPassed");
		
		// Before I move along on a quest, I must see if talking to me is actually an
		// objective for the player.
		int iTalktoNPC = GetLocalInt(oNPC, "LEG_QUEST_IsObjective_" + sCount);
		int iNPCObjective = GetLocalInt(oNPC, "LEG_QUEST_ObjectiveFor_" + sCount);

		// Check to see if the PC has completed this quest previously and if they are allowed to repeat.
		int iTimeSystem = GetLocalInt(GetModule(), "LEG_TIME_ACTIVE");
		if (GetLocalInt(oPC, "QuestID_" + sQuestID + "_NPC") == 998)
		{
			int iPCStamp = GetLocalInt(oPC, "QuestID_" + sQuestID + "_NextRepeat");
			if (iPCStamp == 0 && iTimeSystem == TRUE)
			{
				iPCStamp = GetPersistentInt(oPC, "QuestID_" + sQuestID + "_NextRepeat", sTableID);
				SetLocalInt(oPC, "QuestID_" + sQuestID + "_NextRepeat", iPCStamp);
			}
			// If the timer has not passed, then fire the oneliner.
			if (iPCStamp > LEG_COMMON_TimeStamp())
			{
				iFireOneliner = TRUE;
			}
			else
			{
				iPlayerStep = 0;
				SetLocalInt(oPC, "QuestID_" + sQuestID + "_NPC", 0);
				SetPersistentInt(oPC, "QuestID_" + sQuestID + "_NPC", 0, 0, sTableID);
			}
		}
		
		// The following section ONLY applies if the player is switching NPC's where the current NPC is
		// an objective for another NPC.  If this NPC is the same one the player is already on, this 
		// section is skipped.
		// iNPCPosition = CURRENT NPC
		// iNPCObjective = WHICH NPC WOULD HAVE SENT PLAYER TO ME
		// iPlayerStep = WHICH NPC IS THE PLAYER ACTUALLY ON, NOT CURRENT NPC.
		// iTalkToNPC = THE OBJECTIVE NUMBER THAT I AM FOR THE PREVIOUS NPC.
		int iJustSpokeToNPC = 0;
		if (iTalktoNPC && iPlayerStep == iNPCObjective)
		{
			// Looks like I AM an objective.  Does the player need this objective?
			// The iTalktoNPC is actually an objective Number from 1-10
			// We pull that objective from the row for the NPC that asked us to talk to this guy
			// and if it matches this NPC's ID, then we advance the Player's Step.
			// If the player's step is advanced, the original guy will always spew his
			// oneliner, otherwise, the original guy will fire a continue until we talk to this
			// NPC.
			SQLExecDirect("SELECT * FROM `" + QUESTPREFIX + "_mainquests` AS t1, `" + QUESTPREFIX + "_questheader` AS t2 WHERE t1.`QuestID`=t2.`QuestID` AND t1.`QuestID` = " + sQuestID + " AND t1.`QuestNPC` = " + IntToString(iPlayerStep));
			SQLFetch();
			int iObjective = StringToInt(SQLGetData(13 + iTalktoNPC));

			if (iObjective == iNPCPosition)
			{
				// 
				
				// Set the current player step in the event the PC hits "Later" on
				// the finish button in the finish dialogue.  This is used in the
				// laterquest gui script.
				SetLocalInt(oPC, "QUEST_PreviousNPC", iPlayerStep);
				
				// Check and see if this NPC requires all OTHER NPC -1 objectives are complete first.
				// This is useful if NPC #1 says, kill me a mob, THEN talk to NPC #2.  It will cause
				// NPC #2 NOT to talk to the player until the first and any OTHER objectives are
				// complete.
				
				// iTalktoNPC is the objective ID (1-10) this NPC is, so we don't mind if this
				// one is not complete.  We do this by calling a special CheckObjectives function
				// passing the one objective (the NPC) that we don't need to come back as TRUE.  As
				// long as the rest are True, we are good to proceed, otherwise we simply skip this section.
				if ((GetLocalInt(oNPC, "LEG_QUEST_OtherObjectivesDone_" + sCount) && LEG_QUEST_CheckOtherObjectives(oPC, sQuestID, iPlayerStep, iTalktoNPC, 1)) || !GetLocalInt(oNPC, "LEG_QUEST_OtherObjectivesDone_" + sCount))
				{
					// If this objective is currently active and available for a PC to perform
					if (LEG_QUEST_GetOBJ(oPC, sQuestID, iPlayerStep, iTalktoNPC, "OBJInactive") != "1")
					{
						// Put this in here to catch the "Required Items" message when a PC speaks to an NPC objective.
						iJustSpokeToNPC = 1;

						// Check to see if I am supposed to take any prop items and if I should have them.
						// I don't remove them in this BUT I'll find out if I have them or not.  I only check
						// items that were given to the player by a different NPC.  If I gave the prop item
						// to the PC and I'm the one taking it back, I'd only do that if I were the
						// quest finisher so there's one there for that.
						if (!LEG_QUEST_CheckInventoryProps(oPC, oNPC, sQuestID, iNPCPosition, FALSE))
							return;
						
						
						// Give and Remove any props that I should...
						// Check and see if there are any props that have to be given to the PC
						// Time to hand out the goods or take them as the case may be!
						// I only give and remove props if I am advancing along the quest.  Coming back and talking to me
						// while still on my step won't re-run the prop stuff.
						int iRemoveCycle = FALSE;
						string sGiveItem = "";
						SQLExecDirect("SELECT * FROM `" + QUESTPREFIX + "_propitems` WHERE `QuestID` = '" + sQuestID + "' AND `NPCID` = '" + IntToString(iNPCPosition) + "' ORDER BY `Action`;");
						while (SQLFetch())
						{
							string sAction = SQLGetData(2);
							string sParameter1 = SQLGetData(3);
							string sParameter2 = SQLGetData(4);
							string sParameter3 = SQLGetData(5);	
							string sParameter4 = SQLGetData(6);	
							
							// Look for those GIVEITEM actions
							if (sAction == "GIVEITEM")
							{
								// Put our props in the lootbag, then call our special Loot Bag item create function 
								object oLootBag = LEG_COMMON_GetInventoryItemByTag(oPC, "leg_quest_questbag");
								LEG_COMMON_CreateItem(oPC, sParameter1, StringToInt(sParameter2), oLootBag);
								
								// Because of the ORDER BY clause, GIVEITEM will ALWAYS appear before a TAKEITEM.  We'll
								// want this in the TAKEITEM section to make sure we don't take it if we just gave it.
								sGiveItem = sParameter1;
							}
							
							// If we are NOT finishing the quest, but we should take some prop items
							// the we should do that now.  A Remove All is a master blow away all prop items
							// option
							if (sAction == "TAKEITEM")
							{
								if (sParameter1 == "<Remove All>")
								{
									iRemoveCycle = TRUE;
								}
								else
								{
									// If we have a single TAKEITEM, we will need to ensure we didnt just GIVE it the player
									// a moment ago and then remove it.  This can happen when NPC1, sends player to NPC2.  NPC2
									// then gives a player a prop (such as a quest tool), has some objectives, then will remove
									// the quest tool at finish time.  This would have a GIVE and TAKE at the same time.  In
									// this case, we will let the GUI Finish take the prop not here.  So If GIVE ITEM = TAKE ITEM
									// then we skip.  If NPC2 is not finisher, then NPC3 will take the prop item.
									if (sGiveItem != sParameter1)
										LEG_COMMON_DestroyItems(oPC, sParameter1, StringToInt(sParameter2));
								}
							}
						}
				
						if (iRemoveCycle)
						{		
							SQLExecDirect("SELECT * FROM `" + QUESTPREFIX + "_propitems` WHERE `QuestID` = '" + sQuestID + "' AND `Action` = 'GIVEITEM';");
							while (SQLFetch())
							{
								string sAction = SQLGetData(2);
								string sParameter1 = SQLGetData(3);
								string sParameter2 = SQLGetData(4);
								string sParameter3 = SQLGetData(5);	
								string sParameter4 = SQLGetData(6);	
								
								// Look for those GIVEITEM actions
								if (sAction == "GIVEITEM")
								{
									// Take all the GIVE items.
									LEG_COMMON_DestroyItems(oPC, sParameter1, StringToInt(sParameter2));
								}
							}						
						}
	
						iPlayerStep = iNPCPosition;
						SetLocalInt(oPC, "QuestID_" + sQuestID + "_NPC", iPlayerStep);
						SetPersistentInt(oPC, "QuestID_" + sQuestID + "_NPC", iPlayerStep, 0, sTableID);
						LEG_QUEST_ClearOBJRuleSet(oPC, sQuestID, iNPCObjective);
						LEG_QUEST_InitializeOBJRule(oPC, sQuestID, IntToString(iPlayerStep), -1);
					
						// We've changed NPC's.  Let's clean up my objectives.  Moving from one NPC
						// to another can only EVER be one objective.  You can't have multiple objectives
						// when one NPC sends you to talk to another.
						// If you are a return customer from talking to another NPC and this NPC previously
						// had objectives, then we need to run an auto-complete.
						if (GetLocalInt(oNPC, "LEG_QUEST_CompleteOldObjectives_" + sCount))
							LEG_QUEST_CompleteObjectives(oPC, sQuestID, iPlayerStep);
						else
							LEG_QUEST_ClearObjectives(oPC, sQuestID, sTableID);
							
					}
				}
			}
		}

		// Ok, I am now here.  I may have changed to this NPC, or I may be on this NPC already just doing his tasks.
		if (GetLocalInt(oPC, "QuestID_" + sQuestID + "_NPC") != 999)
		{
			// Check to see if the PC has messed things up by failing a skill check and now has to wait.
			if (iReluctance)
			{
				int iPCStamp = GetLocalInt(oPC, "QuestID_" + sQuestID + "_FailTime");
				if (iPCStamp == 0 && iTimeSystem == TRUE)
				{
					iPCStamp = GetPersistentInt(oPC, "QuestID_" + sQuestID + "_FailTime", sTableID);
					SetLocalInt(oPC, "QuestID_" + sQuestID + "_FailTime", iPCStamp);
				}
				
				// If the timer has not passed, then fire the failure.
				if (iPCStamp > LEG_COMMON_TimeStamp())
				{
					iFireFailure = TRUE;
				}
				else
				{
					SetLocalInt(oPC, "QuestID_" + sQuestID + "_FailTime", 0);
					SetPersistentInt(oPC, "QuestID_" + sQuestID + "_FailTime", 0, 0, sTableID);
				}
			}
			
			if (iFireFailure)
			{
				// We've had a failure in skill so let's wait and inform.
				string sFailSkillMessage;
				SQLExecDirect("SELECT * FROM `" + QUESTPREFIX + "_skills` WHERE `QuestID` = '" + sQuestID + "' AND `NPCID` = '" + IntToString(iPlayerStep) + "';");
				while(SQLFetch())
				{
					sFailSkillMessage = SQLGetData(5);
				}
				AssignCommand(oNPC, ActionSpeakString(sFailSkillMessage));
				return;
			}		
		
			// I have not completed a quest this guy has.
			iFirePostLiner = FALSE;
			
			// Let's see where the PC is with respect to this quest.
			if ((GetLocalInt(oPC, "QuestID_" + sRequirement + "_NPC") == 999 || sRequirement == "") && (GetLocalInt(oPC, "QuestID_" + sQuestStarted + "_NPC") != 0 || sQuestStarted == ""))
			{
				// Check other requiremnts				
				if (LEG_QUEST_CheckQuestRequirements(oPC, oNPC, sCount))
				{
			
					// If the player is on step 0, they do not have the quest, however this NPC
					// may not be the quest starting person, just a member of the quest, so how
					// do we tell if this NPC is the starter?
					if (iPlayerStep == 0 && iQuestStarter)
					{
						iFireOneliner = FALSE;
						iCount = iTotalQuests;
						LEG_QUEST_FireQuestGUI("leg_quest_offer", "leg_quest_offer.xml", oPC, iNPCPosition, sQuestID);
						SetPersistentInt(oPC, "QuestID_" + sQuestID + "_" + IntToString(iNPCPosition) + "_ReluctantPassed", 1, 0, sTableID);
						SetLocalInt(oPC, "QuestID_" + sQuestID + "_" + IntToString(iNPCPosition) + "_ReluctantPassed", 1);
					}
					else if (iPlayerStep == iNPCPosition)
					{
						iFireOneliner = FALSE;
						// Looks like you're already on this quest and you need to talk to this NPC
						// But do you have the objectives complete?
						// There can be 10 objectives stored in the database.  if the PC has all 10, then
						// we can show the Finish Box.  If not, we show the continue Box.
						
						// Note, NPC # 999 is always the last one in the quest.  Anyone other NPC in the quest chain
						// will always pop up a continue Box even if objectives are complete.  The key is that
						// if the player completed the objectives, then the quest step advances to the next NPC.
						
						// Now the big IF
						if (!LEG_QUEST_CheckObjectives(oPC, sQuestID, iPlayerStep, iJustSpokeToNPC))
						{
							// The player has not completed ALL the objectives - show the Continue Box without
							// advancement.
							iCount = iTotalQuests;
							int iReluctantPassed;
							
							// If we have a timer bar running from a different NPC but we got here, then this NPC 
							// should turn off the timer bar because we were supposed to be here.
							// Do you need a timer running before you can move on to me?  If you were sent here by another NPC or Objective that started a timer, and I 
							// REQUIRE that one is running, then you best have one!
							int iRequireTimer = GetLocalInt(oNPC, "LEG_QUEST_TimerRequired_" + sQuestID);
							int iDeactivateTimer = GetLocalInt(oNPC, "LEG_QUEST_TimerOff_" + sQuestID);
							if (iDeactivateTimer || iRequireTimer)
							{
								string sTimerQuestID = GetLocalString(oPC, "LEG_INFO_TimerBarQuestID");
								if (sTimerQuestID == sQuestID && iDeactivateTimer)
								{
									// Who's timer is this and am I allowed to turn it off?
									if (GetLocalInt(oPC, "LEG_INFO_TimerBarNPC") == iNPCObjective)
									{
										// You DO have a timer running right now and it's for my quest AND you have one running so you are good to proceed
										// Let's turn off your timer and move on!
										ExecuteScript("leg_info_timerstop", oPC);
									}
								}
								else if (sTimerQuestID == sQuestID && !iDeactivateTimer)
								{
									// I require a timer, you have one running, but I don't deactivate it.  So do nothing but let the script continue...	
								
								}
								
								// If you got here, you either A. Ran out of time before reaching me or B. Had a timer that was stopped by something else earlier in the quest
								// and my require timer is for my OWN objectives.
								// If A. Then you either ran out of one that was started by another NPC (or one of his objectives) in which case I must stop you or it ran out from one 
								// that I gave you and you didn't complete MY objectives in which case I must allow you to pass so you can get another.
								// If B. Then I shall allow you to pass and continue but you won't have a MOBTIMERFAILED for your other NPC nor will there be one for me.
								else if (iRequireTimer && iNPCObjective != 0 && GetPersistentInt(oPC, "QuestID_" + sQuestID + "_MOBTIMERFAILED" + IntToString(iNPCObjective), sTableID) != 1)
								{
									// You don't have a timer, I require one, you came from a different NPC but you didn't fail his timer either.  That MUST mean you succeeded in his timer.
									// So do nothing.	
								}
								else if (iRequireTimer && iNPCObjective != 0 && GetPersistentInt(oPC, "QuestID_" + sQuestID + "_MOBTIMERFAILED" + IntToString(iNPCPosition), sTableID) != 1)
								{
									// You don't have one running, but i REQUIRE one running so you are out of luck.
									LEG_COMMON_DisplayInfoBox(oPC, "SORRY, YOU RAN OUT OF TIME, TRY AGAIN!");
									return;
								}
							}
							
							
							// Find out if PC has already resolved any reluctance issues.
							if (iReluctance)
							{
								if (!iReluctantPassed)
								{
									// Check database just in case.
									iReluctantPassed = GetLocalInt(oPC, "QuestID_" + sQuestID + "_" + IntToString(iPlayerStep) + "_ReluctantPassed");
								}
							}
							
							if (!iReluctance || iReluctantPassed)
							{
								LEG_QUEST_FireQuestGUI("leg_quest_continue", "leg_quest_continue.xml", oPC, iNPCPosition, sQuestID);
								if (!iReluctance)
								{
									SetPersistentInt(oPC, "QuestID_" + sQuestID + "_" + IntToString(iPlayerStep) + "_ReluctantPassed", 1, 0, sTableID);
									SetLocalInt(oPC, "QuestID_" + sQuestID + "_" + IntToString(iPlayerStep) + "_ReluctantPassed", 1);
								}
							}
							else
							{
								SQLExecDirect("SELECT * FROM `" + QUESTPREFIX + "_skills` WHERE `QuestID` = '" + sQuestID + "' AND `NPCID` = '" + IntToString(iPlayerStep) + "';");
								SQLFetch();
								int iBribe = StringToInt(SQLGetData(6));
								int iSkill1 = StringToInt(SQLGetData(9));
								int iSkill2 = StringToInt(SQLGetData(10));
								string sGUI, sGUIFile;
								if (iBribe)
								{
									sGUI = "leg_quest_continue_bribe"; 
									sGUIFile = "leg_quest_continue_bribe.xml"; 
								}
								if (iBribe && iSkill1 != -1)
								{
									sGUI = "leg_quest_continue_bribe_skill"; 
									sGUIFile = "leg_quest_continue_bribe_skill.xml"; 
								}
								if (iBribe && iSkill1 != -1 && iSkill2 != -1)
								{
									sGUI = "leg_quest_continue_all"; 
									sGUIFile = "leg_quest_continue_all.xml"; 
								}
								if (!iBribe && iSkill1 != -1 && iSkill2 == -1)
								{
									sGUI = "leg_quest_continue_skill1"; 
									sGUIFile = "leg_quest_continue_skill1.xml"; 
								}	
								if (!iBribe && iSkill1 != -1 && iSkill2 != -1)
								{
									sGUI = "leg_quest_continue_skills"; 
									sGUIFile = "leg_quest_continue_skills.xml"; 
								}
								if (!iBribe && iSkill1 == -1 && iSkill2 == -1)
								{
									sGUI = "leg_quest_continue"; 
									sGUIFile = "leg_quest_continue.xml"; 
								}
								LEG_QUEST_FireQuestGUI(sGUI, sGUIFile, oPC, iNPCPosition, sQuestID);									
							}
							

						}
						else
						{
							// The player has completed all objectives, see if this NPC is the last.  If he/she
							// is, then popup the finish box, otherwise, advance to the next NPC.
							if (iQuestFinisher)
							{
								// I'm a quest finisher.  I may be able to turn off a timer.  If you have a timer running that was set by me
								// then I will turn it off if I can.
								int iRequireTimer = GetLocalInt(oNPC, "LEG_QUEST_TimerRequired_" + sQuestID);
								int iDeactivateTimer = GetLocalInt(oNPC, "LEG_QUEST_TimerOff_" + sQuestID);
								int iTimerBypass = GetPersistentInt(oPC, "QuestID_" + sQuestID + "_TIMERBYPASS" + IntToString(iNPCPosition), sTableID);
								if (iDeactivateTimer)
								{
									string sTimerQuestID = GetLocalString(oPC, "LEG_INFO_TimerBarQuestID");
									if (sTimerQuestID == sQuestID)
									{
										// Who's timer is this and am I allowed to turn it off?
										//if (GetLocalInt(oPC, "LEG_INFO_TimerBarNPC") == iNPCPosition)
										//{
											// You DO have a timer running right now and it's for my quest AND you have one running so you are good to proceed
											// Let's turn off your timer and move on!
											ExecuteScript("leg_info_timerstop", oPC);
										//}
									}
									else if (iRequireTimer && !iTimerBypass)
									{
										// You don't have one running, but i REQUIRE one running so you are out of luck.
										LEG_COMMON_DisplayInfoBox(oPC, "SORRY, YOU RAN OUT OF TIME, TRY AGAIN!");
										return;
									}
								}
							
								SetLocalInt(oPC, "LEG_QuestPos", iCount);
								iCount = iTotalQuests;
								LEG_QUEST_FireQuestGUI("leg_quest_finish", "leg_quest_finish.xml", oPC, iNPCPosition, sQuestID);
							}	
							else
							{
								iCount = iTotalQuests;
								LEG_QUEST_FireQuestGUI("leg_quest_continue", "leg_quest_continue.xml", oPC, iNPCPosition, sQuestID);
							}
						}
					}
					else
					{
						// I don't equal 0 and am not talking to the quest starter. (I'll match if an objective is to talk to this one
						// from someone elses request.
						// I don't Match this guy's NPC ID
						iFireOneliner = TRUE;
					}
				
				}
				else
					iFireOneliner = TRUE;	
			}
			else
				iFireOneliner = TRUE;	
		}
		else
			iFirePostLiner = TRUE;
	}
	
	// Fire my oneliner - Player has more questing!
	if (iFireOneliner)
	{
		// Go get my Oneliner from the table because the PC doesn't have what it takes to make
		// my quest box pop!
		string sOneLiner = LEG_QUEST_GetOneLiner(GetResRef(oNPC));
		AssignCommand(oNPC, ActionSpeakString(sOneLiner));
	}
	
	if (iFirePostLiner)
	{
		// Go get my Post Oneliner from the table because the PC has completed all my quests.
		string sOneLiner = LEG_QUEST_GetPostOneLiner(GetResRef(oNPC));
		AssignCommand(oNPC, ActionSpeakString(sOneLiner));
	}
	
}