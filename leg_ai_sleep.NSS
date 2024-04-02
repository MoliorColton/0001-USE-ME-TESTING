/*

    Script:			Called by the AI Heartbeat when its time for an NPC to go to sleep should
					their AI call for that.  The script will cause them to go to a sleep
					WP or drop where they are and sleep for the appropriate duration.
	Version:		1.1
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		10/15/2011 - 1.00 MV - Initial Release
					07/13/2015 - 1.1 MV - Attempt to make sleeping NPC's work more betterer.
	
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_ai_include"



// /////////////////////////////////////////////////////////////////////////////////////////////////////
// SCRIPT ONLY FUNCTIONS
// /////////////////////////////////////////////////////////////////////////////////////////////////////
object GetRandomSleep(float fMaxDistance)
{
    object oStop;
    object oArea = GetArea(OBJECT_SELF);
    if (! GetLocalInt(oArea, "ANIM_SLEEP_INITIALIZED") ) {
        //AnimDebug("Initializing stops in area " + GetName(oArea));
        // first time -- look up all the stops in the area and store them
        int nNth = 1;
        oStop = GetNearestObjectByTag("NW_SLEEP");
        while (GetIsObjectValid(oStop)) {
            //AnimDebug("Stop found");
            SetLocalObject(oArea, "ANIM_SLEEP_" + IntToString(nNth), oStop);
            nNth++;
            oStop = GetNearestObjectByTag("NW_SLEEP", OBJECT_SELF, nNth);
        }
        SetLocalInt(oArea, "ANIM_SLEEP", nNth-1);
        SetLocalInt(oArea, "ANIM_SLEEP_INITIALIZED", TRUE);
    }

    int nStop = Random(GetLocalInt(oArea, "ANIM_SLEEP")) + 1;
    oStop = GetLocalObject(oArea, "ANIM_SLEEP_" + IntToString(nStop));
    //AnimDebug("Stop: " + IntToString(nStop)
    //            + ": " + GetTag(oStop)
    //            + ": " + FloatToString(GetDistanceToObject(oStop)));
    if (GetIsObjectValid(oStop) && GetDistanceToObject(oStop) <= fMaxDistance)
        return oStop;
    return OBJECT_INVALID;
}


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main(int iSleepOverride, int iWakeOverride)
{
	// OBJECT_SELF is going to sleep.
	if(GetIsNight() || iSleepOverride)
    {
		// Don't want everyone falling asleep at the same time, so give 15% chance of sleeping, increasing by 5% each iteration.
		int iSavedChanceToSleep = GetLocalInt(OBJECT_SELF, "AI_SleepChance");
		int iChanceToSleep = (iSavedChanceToSleep == 0) ? 15 : iSavedChanceToSleep + 5;
		if (iSleepOverride)
			iChanceToSleep = 100;
		int iGlobalSleepChance = GetLocalInt(OBJECT_SELF, "LEG_AI_SleepChance");
		if (iGlobalSleepChance <= 0)
			iGlobalSleepChance = 100;
			
		//SpeakString(GetName(OBJECT_SELF) + " in sleep script.", TALKVOLUME_SHOUT);
		// If I am en-route to a sleep location, then don't fire this again, I've already been told to sleep.
		if (!GetLocalInt(OBJECT_SELF, "AI_SLEEP"))
		{
			//SpeakString(GetName(OBJECT_SELF) + " am not alseep. Global Chance: " + IntToString(iGlobalSleepChance), TALKVOLUME_SHOUT);
			if (d100() <= iGlobalSleepChance)
			{
				//SpeakString(GetName(OBJECT_SELF) + " passed Global Chance, local chance: " + IntToString(iChanceToSleep), TALKVOLUME_SHOUT);
				SetLocalInt(OBJECT_SELF, "AI_SleepChance", iChanceToSleep);
				
				if (d100() <= iChanceToSleep)
				{
					//SpeakString(GetName(OBJECT_SELF) + " passed chance to sleep", TALKVOLUME_SHOUT);
					if (!GetLocalInt(OBJECT_SELF, "AI_SLEEP") && !GetHasEffect(EFFECT_TYPE_SLEEP) && !GetLocalInt(OBJECT_SELF, "Retreat_Mode"))
					{
						//SpeakString(GetName(OBJECT_SELF) + " not asleep, not in retreat.", TALKVOLUME_SHOUT);
						int iCurrentHour = GetTimeHour();
						int iDawn = TIME_HOUR_DAWN;
						int iHours = 0;
						if (iDawn < iCurrentHour)
						{
							// Looks like dawn is the next day so we'll throw a little check here for time due to that.
							iHours = (24 - iCurrentHour) + iDawn;
						}
						else
						{
							// Dawn is later than night (go figure)
							iHours = iDawn - iCurrentHour;
						}
					
						if (GetLocalInt(GetModule(), "LEG_BANTER_ACTIVE"))
						{
							// See if we have and Banter ID's
							string sBanterID = GetLocalString(OBJECT_SELF, "LEG_BANTER_OnSleep");
							int iBanterChance = GetLocalInt(OBJECT_SELF, "LEG_BANTER_OnSleepChance");
							
							// If we do, then lets see if we can speak.
							if (sBanterID != "")
							{
								// We're not in combat so lets speak our Regular one.
								AddScriptParameterString(sBanterID);
								AddScriptParameterInt(iBanterChance);
								AddScriptParameterString("Custom");
								ExecuteScriptEnhanced("leg_banter_speak", OBJECT_SELF);
							}
							else
							{
								if (d100() <= 50)
									SpeakString("Yawn...");	
							}
						}	
						else
						{
							if (d100() <= 50)
								SpeakString("Yawn...");	
						}
						
						SetLocalInt(OBJECT_SELF, "AI_SLEEP", TRUE);
						//SpeakString(GetName(OBJECT_SELF) + " sleep var now set.", TALKVOLUME_SHOUT);
			        	effect eSleep = EffectSleep();
						effect eKnock = EffectKnockdown();
						eSleep = EffectLinkEffects(eKnock, eSleep);
						
						object oSleepLocation = GetRandomSleep(30.0);
						if (!GetIsObjectValid(oSleepLocation))
						{
							DelayCommand(0.1f, SetCommandable(FALSE, OBJECT_SELF));
							if (!iSleepOverride)
							{
								ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSleep, OBJECT_SELF, HoursToSeconds(iHours));
					        	DelayCommand(HoursToSeconds(iHours), SetCommandable(TRUE, OBJECT_SELF));
								SetLocalInt(OBJECT_SELF, "AI_SLEEP_Override", 0);
							
							}
							else
							{
								ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSleep, OBJECT_SELF);
								SetLocalInt(OBJECT_SELF, "AI_SLEEP_Override", 1);
							}
						}
						else
						{
							SetLocalObject(OBJECT_SELF, "AI_SleepLocation", oSleepLocation);
							//SpeakString(GetName(OBJECT_SELF) + " going to a WP for sleep.", TALKVOLUME_SHOUT);
							// Looks like we're going to a WP for sleep.
							SetLocalInt(OBJECT_SELF, "AI_SleepHours", iHours);
							ActionForceMoveToLocation(GetLocation(oSleepLocation), FALSE, 15.0);
							//DelayCommand(17.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSleep, OBJECT_SELF, HoursToSeconds(iHours)));
						}
					}
				}
			}
		}
	}
	
	// For waking up in the morning.
    if(GetIsDawn() || iWakeOverride)
    {
		// Wake up
		SetCommandable(TRUE, OBJECT_SELF);
		SetLocalInt(OBJECT_SELF, "AI_SLEEP_Override", 0);
		
		if (GetHasEffect(EFFECT_TYPE_SLEEP))
		{
			SetLocalInt(OBJECT_SELF, "AI_SLEEP", FALSE);
	        effect eSleep = GetFirstEffect(OBJECT_SELF);
	        while(GetIsEffectValid(eSleep))
	        {
	            if(GetEffectCreator(eSleep) == OBJECT_SELF)
	            {
                    RemoveEffect(OBJECT_SELF, eSleep);
					if (GetLocalInt(GetModule(), "LEG_BANTER_ACTIVE"))
					{
						// See if we have and Banter ID's
						string sBanterID = GetLocalString(OBJECT_SELF, "LEG_BANTER_OnWake");
						int iBanterChance = GetLocalInt(OBJECT_SELF, "LEG_BANTER_OnWakeChance");
						
						// If we do, then lets see if we can speak.
						if (sBanterID != "")
						{
							// We're not in combat so lets speak our Regular one.
							AddScriptParameterString(sBanterID);
							AddScriptParameterInt(iBanterChance);
							AddScriptParameterString("Custom");
							ExecuteScriptEnhanced("leg_banter_speak", OBJECT_SELF);
						}
						else
						{
							if (d100() <= 50)
								SpeakString("Yawn...");	
						}
					}	
					else
					{
						if (d100() <= 50)
							SpeakString("Yawn...");	
					}
	            }
	            eSleep = GetNextEffect(OBJECT_SELF);
	        }
		}
	}
}