// XP Bar for Players

// Nifty Function for figuring out what our Level REALLY is.
int GetEffectiveLevel(object oPC, int iLevel)
{
	int iSubRace = GetSubRace(oPC);
	int iLevelAdj;
	
    // see what the level adjustment is for subrace type
    switch (iSubRace)
    {
       case RACIAL_SUBTYPE_AASIMAR:
       case RACIAL_SUBTYPE_TIEFLING:
	   case RACIAL_SUBTYPE_AIR_GENASI:
	   case RACIAL_SUBTYPE_EARTH_GENASI:
	   case RACIAL_SUBTYPE_FIRE_GENASI:
	   case RACIAL_SUBTYPE_WATER_GENASI:
       case RACIAL_SUBTYPE_GRAY_DWARF: iLevelAdj = 1; break;
       case RACIAL_SUBTYPE_DROW: iLevelAdj = 2; break;
       case RACIAL_SUBTYPE_SVIRFNEBLIN: iLevelAdj = 3; break;
       default:  iLevelAdj = 0; break;
    }
	
	return iLevel + iLevelAdj;

}


// Nifty function for getting XP needed to get to our current level.  Math and stuff.
int GetXPToCurrentLevel(object oPC)
{
	int iCurrentLevel = GetTotalLevels(oPC, FALSE);
	if (iCurrentLevel == 1)
		return 0;
	else		
	{
		int iEffectiveLevel = GetEffectiveLevel(oPC, iCurrentLevel);
		return 500 * iEffectiveLevel * (iEffectiveLevel - 1);
	}
}


// Find out how much XP we need to get to the next level.  More of that math stuff.
int GetXPToNextLevel(object oPC)
{
	int iCurrentLevel = GetTotalLevels(oPC, FALSE);
	int iEffectiveLevel = GetEffectiveLevel(oPC, iCurrentLevel + 1);
	return (500 * iEffectiveLevel * (iEffectiveLevel - 1)) - GetXP(oPC);
}



void main()
{
	// Get the PC... who me?
	object oPC = OBJECT_SELF;
	
	// Find out how much XP we need to get to the next level using funky GetXPToNextLevel function above.
	int iXPNeeded = GetXPToNextLevel(oPC);
	
	// Find out how much XP we needED to get to our current level.  Why do we need this again?  I forget.
	int iXPCurrentLevel = GetXPToCurrentLevel(oPC);
	
	// Find out how much XP it takes to get to our next level in total.  That could be a big number.  ouch.
	int iXPTotalOfNextLevel = GetXP(oPC) + iXPNeeded;
	
	// Now lets find out how much XP it takes to get from the beginning of our current level to the next level.
	// This is useful for figuring out the percentage of where we are at in the current level.. wow, thats a mouthful.
	int iXPInCurrentLevel = iXPTotalOfNextLevel - iXPCurrentLevel;
	
	// Now lets get a human readable number of the percent of what we need.. something about this in the previous comment.
	float fPercentXPNeeds = IntToFloat(iXPNeeded) * 100.0 / IntToFloat(iXPInCurrentLevel);
	
	// Now we know the percent of what we need, might as well find out what we got!
	float fPercentXPHas = 100.0 - fPercentXPNeeds;
	
	// Now we change that to a value that works with the GUI.
	float fXPHas = fPercentXPHas / 100.0;
	
	// Just like on the price is right, we aren't allowed to go over.
	if (fXPHas > 100.0)
		fXPHas = 100.0;
		
	// Show our super spiffy GUI XP Bar.
	DisplayGuiScreen(oPC, "SJS_XPBAR", FALSE, "xpbar.xml");
	
	// Display some text in case there's someone out there that can't grasp the concept of the bar.  Hee hee, ain't I a 
	// stinker.
	SetGUIObjectText(oPC, "SJS_XPBAR", "NAME_TEXT", -1, "XP Needed: " + IntToString(iXPNeeded));
	
	// Update the progress bar with our current XP value.
	SetGUIProgressBarPosition(oPC, "SJS_XPBAR", "XP_BAR", fXPHas);
	
}