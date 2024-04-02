void main()
{
    object oPC = GetEnteringObject();
    object oTrigger = OBJECT_SELF;  // Get the current trigger object
    object oWaypoint = GetWaypointByTag(GetTag(oTrigger));

    if (GetIsPC(oPC))
    {
        // Define the probability of success (e.g., 70% chance)
        int nSuccessChance = 70;
        // Generate a random number between 1 and 100
        int nRandomNum = Random(100) + 1;
		
		// Get the player's current and maximum hit points
        int nCurrentHP = GetCurrentHitPoints(oPC);
        int nMaxHP = GetMaxHitPoints(oPC);

        if (nRandomNum <= nSuccessChance)
        {
            // Success: Teleport the player to the waypoint and apply the immobilization effect
            AssignCommand(oPC, JumpToObject(oWaypoint));
            effect eImmobilize = EffectParalyze();
            DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eImmobilize, oPC, 0.2));
            SendMessageToPC(oPC, "You swiftly jump over the chasm!");
        }
        else
        {
            // Check if the player's health is below 5%
            if ((nCurrentHP * 100 / nMaxHP) < 5)
            {
                // Health is below 5%: Kill the player
                effect eDeath = EffectDeath();
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oPC);
                SendMessageToPC(oPC, "You died!");
            }
            else
            {
				// Failure: Player takes 100 physical damage and is teleported
				int nDMG = 100;
				effect eDAMAGE = EffectDamage(nDMG, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_NORMAL, TRUE);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eDAMAGE, oPC);
				SendMessageToPC(oPC, "You failed to make the jump!");

                // Teleport the player to the waypoint FAIL
                location locWaypoint = GetLocation(GetWaypointByTag("upswfail1z"));
                AssignCommand(oPC, ActionJumpToLocation(locWaypoint));
            }
        }
    }
}