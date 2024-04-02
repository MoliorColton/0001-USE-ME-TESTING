//::///////////////////////////////////////////////
//:: Death Script
//:: 'kg_mod_death' / NW_O0_DEATH.NSS
//:: Copyright (c) 2012 kevL's / (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*    This script handles specific behavior that
    occurs when an Owned Character dies. It is
    part of the Kingz Gaite campaign setup and
    should not be overridden ... */
/*  This script handles the default behavior
    that occurs when a player dies.
    BK: October 8 2002: Overriden for Expansion */
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles     mod: kevL's
//:: Created On: November 6, 2001   on: May 2009, Jul 2010
//:://////////////////////////////////////////////
// BMA-OEI 7/20/06 -- Temp death screen
// BMA-OEI 11/08/06 -- Added engine death GUI: SCREEN_DEATH_DEFAULT
// (ingamegui.ini) is force closed upon resurrection
// kevL's modified, 2010 ..
//    - modded further, 2012 may 14


// Display death pop-up to oPC
void kL_ShowDeathScreen(object oPC)
{
    DisplayMessageBox(oPC,
                        FALSE,                        // MessageBox STRREF
                        GetStringByStrRef(181408),    // text: "You have died."
                        "gui_cityrespawn",        // callback for 'ok'
                        "",                            // callback for 'cancel'
                        FALSE,                        // no cancel option.
                        "",                            // GUIScreenName: "SCREEN_MESSAGEBOX_DEFAULT"
                        6603,                        // ok STRREF: "Respawn"
                        "Rspawn",                    // ok text, overrides STRREF
                        FALSE,                        // cancel STRREF: ""
                        "");                        // cancel text.
}



void main()
{
    SendMessageToPC(GetFirstPC(FALSE), ". Run ( kg_mod_death )");

    object oPC = GetLastPlayerDied();
    SendMessageToPC(GetFirstPC(FALSE), ". . died : " + GetName(oPC));

    // try to avoid possible complications
    AssignCommand(oPC, SetCommandable(TRUE));
    AssignCommand(oPC, ClearAllActions(TRUE));

    // he's dead jim
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oPC);

    // Check for additional death script
    string sDeathScript = GetLocalString(oPC, "duelarenadeath1");
    if (sDeathScript != "") ExecuteScript(sDeathScript, oPC);


    // player is controlling the OwnedPC; try to switch to Companion:
    if (GetIsPC(oPC))
    {
        object oCompanion;
        string sCompanion = GetFirstRosterMember();
        while (sCompanion != "")
        {
            oCompanion = GetObjectFromRosterName(sCompanion);
            if (GetIsObjectValid(oCompanion)
                    && GetFactionEqual(oCompanion, oPC)
                    && !GetIsDead(oCompanion)
                    && !GetIsCompanionPossessionBlocked(oCompanion)
                    && !GetIsPC(oCompanion))
            {
                // Give control to the first living, unblocked, uncontrolled Companion
                SetOwnersControlledCompanion(oPC, oCompanion);

                return;
            }

            sCompanion = GetNextRosterMember();
        }
    }
    // if you're not controlling the OwnedPC, just let it die unless everyone else is dead too
    else
    {
        // if the character that the player is controlling isn't dead-dead, do nothing.
        oPC = GetControlledCharacter(oPC);
        if (!GetIsDead(oPC, TRUE)) return;

        object oFM = GetFirstFactionMember(oPC, FALSE);
        while (GetIsObjectValid(oFM))
        {
            // if there is a living Companion ( not an Associate or another PC )
            // This really should check for things like, oh Permanent paralysis etc.
            if (oPC != oFM
                    && !GetIsDead(oFM)
//                    && !GetIsCompanionPossessionBlocked(oFM)
                    && !GetIsPC(oFM)
                    && !GetAssociateType(oFM))
            {
                // it's all good.
                return;
            }

            oFM = GetNextFactionMember(oPC, FALSE);
        }

        // else Pop the player into the OwnedCorpse:
        oPC = SetOwnersControlledCompanion(oPC);
    }


    // below this line, the Party is dead! ( except perhaps another PC )
    DelayCommand(4.6f, kL_ShowDeathScreen(oPC));
}