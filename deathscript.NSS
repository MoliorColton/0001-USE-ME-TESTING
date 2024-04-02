//-----------------------------------------------------------------------
// <copyright file="deathscript.nss" company="Molior RS">
// Copyright (c) Molior RS. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------

void main()
{
    // Get the player character who died
    object oPC = GetLastPlayerDied();

    // Get the area where the player character died
    object oArea = GetArea(oPC);

    // Check the area tag to determine how to handle the player's death
    string sAreaTag = GetTag(oArea);
    if (sAreaTag == "60fightcave1")
    {
        // Handle player death in area with tag "fightcaves"
        // Jump the player to the "RESPAWNFIGHTCAVES" waypoint
        DisplayMessageBox(oPC, -1, "You have perished while attempting to brave the Fight Caves, you will be returned to the entrance.", "gui_1fcrespawn", "gui_1fcwaitrespawn", TRUE, "SCREEN_MESSAGEBOX_DEFAULT", -1, "Respawn", -1, "Wait");
		}
    else
    {
        // Handle player death in all other areas
        // For example, you might display a message box to the player and give them a choice to respawn or wait
        DisplayMessageBox(oPC, -1, "You have died.", "gui_cityrespawn", "gui_waitrespawn", TRUE, "SCREEN_MESSAGEBOX_DEFAULT", -1, "Respawn", -1, "Wait");
		}
}