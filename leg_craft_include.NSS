/*

    Script:			This main include for the CRAFT PLUGIN.  This handles all the functions from
					harvesting resources to crafting items.
	Version:		1.01
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		06/23/2011 - 1.00 MV - Initial Release
					12/06/2011 - 1.01 MV - Updated to use Sub Races instead of Base Races
	
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// USER CONFIGURABLE CONSTANTS
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_craft_constants"


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_all_masterinclude"





// /////////////////////////////////////////////////////////////////////////////////////////////////////
// FUNCTION DECLARATIONS
// /////////////////////////////////////////////////////////////////////////////////////////////////////




// ///////////////////////////////////////////////////////////////////////////
// Find out what the chance the PC has to succeed in a skill based on the
// difficulty of the target, the skill and the PC's skill using the Crafting
// math we have in place.
// int iSkill					- The skill we are checking against
// int iMin						- The Min difficulty of the object.
// int iMax						- The Max difficulty of the object.
// int iPCSkill					- The skill of the PC for this trade.
//	Returns: Int of the chance.
int LEG_CRAFT_GetSkillChance(int iSkill, int iMin, int iMax, int iPCSkill);

// ///////////////////////////////////////////////////////////////////////////
// Function that creates an item object on the passed player.  The item
// ResRef is passed and quantities are passed.  In this context, it is used
// to created item results from harvesting and crafting.
// object oPC					- Target where the item will be created.
// string sItem					- ResRef of the item to create.
// int iMin						- Minimum quantity to create.
// int iMax						- Maximum quantity to create.
//	Returns: Nothing
void LEG_CRAFT_CreateResult(object oPC, string sItem, int iMin, int iMax);

// ///////////////////////////////////////////////////////////////////////////
// This function will check the current PC and skill and return the maximum
// base skill the PC is allowed to have for their current difficulty level.  
// There are 10 difficulties and a PC must LEARN each difficulty to advance.  
// Typically this would be performed via a quest, or purchase something or 
// from a book.
// object oPC					- Target player to find out skill
// int iSkill					- Tradeskill we are checking
//	Returns: Int of the maximum skill value for the PC's current level.
int LEG_CRAFT_GetSkillCap(object oPC, int iSkill);

// ///////////////////////////////////////////////////////////////////////////
// Get's the Skill Level from 1-10 by name  You just pass the name, along
// with the skill and player and it returns the integer value of the 
// skill level the PC is currently at.
// object oPC					- The Player we are checking
// string sSkillLevelName		- The skill level name from the defined list.
// int iSkill					- Tradeskill we are checking
//	Returns: Int of the level the PC is at.
int LEG_CRAFT_GetSkillLevelByName(object oPC, string sSkillLevelName, int iSkill);

// ///////////////////////////////////////////////////////////////////////////
// Get's a color value based on the percentage passed to it.  At various 
// percent rates, a different color is applied.  
// float fPercent				- The percentage we want to examine.
//	Returns: String value of the color coded.
string LEG_CRAFT_GetPercentColor(float fPercent);

// ///////////////////////////////////////////////////////////////////////////
// Function to get the name of the skill level a PC is at without bonuses.  
// Yes that means that even if you have over 294 skill or whatever the 
// amount is, you are not Legendary until you have a BASE skill level up there.  
// NOTE: This function can return one of two things.  It can return the actual 
// NAME of the level a PC is at, OR it can return a color based on the Level
// a PC is at.
// object oPC					- The player that we are checking.
// int iSkill					- The tradeskill we are checking.
// int iColor					- Return the color string or not
// int iNextSkill				- Return the NEXT level of the PC or Current
//	Returns: String value of the color coded OR the name of the level.
string LEG_CRAFT_GetSkillLevelName(object oPC, int iSkill, int iColor = FALSE, int iNextSkill = FALSE);

// ///////////////////////////////////////////////////////////////////////////
// This function will pass the skill and the PC and see if they have learned 
// anything at this iteration.  A PC can learn by doing, even on a failure.
// object oPC					- The player that we are checking.
// int iSkill					- The tradeskill we are checking.
// int iLearnChance				- The chance they have to learn
// int iTrivial					- The trivial value for easy.
//	Returns: Nothing
void LEG_CRAFT_LearnSkill(object oPC, int iSkill, int iLearnChance, int iTrivial);

// ///////////////////////////////////////////////////////////////////////////
// Function to determine what the PC's crafting skill is with all the bonuses 
// applied based on race, class and in game skills if applicable.
// object oPC					- The player that we are checking.
// int iSkill					- The tradeskill we are checking.
//	Returns: Modified Crafting skill
int LEG_CRAFT_GetPCSkill(object oPC, int iSkill);

// ///////////////////////////////////////////////////////////////////////////
// On a resource or optional tradestation, a tool must be in hand of the PC.
// This tool will only have so many uses before it needs replacement.  This 
// function will reduce the number of uses available on the tool.
// object oPC					- The player that we are checking.
// object oWeaponOnPlayer		- The tool in the players hand
//	Returns: Nothing
void LEG_CRAFT_ToolDurabilities(object oPC, object oWeaponOnPlayer);

// ///////////////////////////////////////////////////////////////////////////
// When using renewable resources, a tool must be in the hand of the player.
// This tool will only have so many uses before it needs replacement.  This 
// function will reduce the number of uses available on the tool.
// It will also reduce the strength of resource placeables.
// object oPC					- The player that we are checking.
// object oWeaponOnPlayer		- The tool in the players hand
//	Returns: Nothing
void LEG_CRAFT_Durabilities(object oPC, object oWeaponOnPlayer);

// ///////////////////////////////////////////////////////////////////////////
// We are harvesting a resource so let's perform a skill check and act
// accordingly.  This is all the code to check, perform and harvest a
// resource placeable object.
// object oPC					- The player that we are checking.
// object oTarget				- The harvest resource.
//	Returns: Nothing
void LEG_CRAFT_HarvestResource(object oPC, object oTarget);

// ///////////////////////////////////////////////////////////////////////////
// Check the ingredient and quantity passed and see if the PC has enough
// of them.  Return true if they do, false if they don't
// object oPC					- The player that we are checking.
// object oTarget				- The harvest resource.
//	Returns: Int if the ingredients exist on PC return TRUE
int LEG_CRAFT_CheckRecipeIngredients(object oPC, string sIngredient, string sIngQty);

// ///////////////////////////////////////////////////////////////////////////
// Check the ingredient spell and see if the PC has it memorized.
// object oPC					- The player that we are checking.
// string sSpellID				- The ID of the spell.
// string sSpellID2				- The ID of the spell #2.
// string sSpellID				- The ID of the spell gate.
//	Returns: Int if the ingredients exist on PC return TRUE
int LEG_CRAFT_CheckSpellIngredient(object oPC, string sSpellID, string sSpellID2 = "", string sSpellGate = "", int iSilent = FALSE);

// ///////////////////////////////////////////////////////////////////////////
// This is the primary function for crafting at a tradeskill station.
// It attempts to craft the recipe passed for the PC and itself.
// object oPC					- The player that we are checking.
// object oTarget				- The station.
// int iRecipeIndex				- The index ID of the recipe attempted
//	Returns: Nothing
void LEG_CRAFT_Craft(object oPC, object oTarget, int iRecipeIndex);





// /////////////////////////////////////////////////////////////////////////////////////////////////////
// FUNCTIONS
// /////////////////////////////////////////////////////////////////////////////////////////////////////




// //////////////////////////////////////////////////
// LEG_CRAFT_GetSkillChance
// //////////////////////////////////////////////////
int LEG_CRAFT_GetSkillChance(int iSkill, int iMin, int iMax, int iPCSkill)
{
    // Calulate Chances for PC to succeed.  Here, we find out the chance PER skill point
	// in the category.  There are 10 difficulty categories.
    float fChancePer = 1.0 / IntToFloat((iMax - iMin + 1));
    int iChance = 0;
    int iQty = 0;
	
    // See if the PC has the skill and at least has minimum score.  If the BASE skill is 0, the
	// GetPCSkill function above will return a 0.
    if (iPCSkill >= iMin)
    {
        // PC has enough skill, so lets see if its trivial.  If so, just make it.
        if (iPCSkill >= iMax)
		{
			// Return Trivial chance.
			return 10000;
		}
		else
		{
	        // Now we need to find out what our chances of performing this skill is.  First
			// we use our handy dandy math formula that we invented...
	        float fChance = 1.0 - (IntToFloat(iMax-iPCSkill) * fChancePer);
	        if (fChance >= 0.95)
	            iChance = 9500;
	        else if (fChance <= 0.0)
	            iChance = 0;
	        else
	            iChance = FloatToInt(fChance * 10000.0);
			
			// Return the calulated Chance	
			return iChance;
		}
	}
	else
		return 0;
}


// //////////////////////////////////////////////////
// LEG_CRAFT_CreateResult
// //////////////////////////////////////////////////
void LEG_CRAFT_CreateResult(object oPC, string sItem, int iMin, int iMax)
{
	// If there is no default quantities, we'll set it to 1.
	int iQty;
	if (iMax == 0)
		iQty = 1;
	else
		iQty = Random(iMax - iMin + 1) + iMin;
	
	// Go ahead and create the result.	
	string sCreator = "<color=red>Item Crafted by: " + GetName(oPC) + "</color>";
	LEG_COMMON_CreateItem(oPC, sItem, iQty, OBJECT_INVALID, sCreator);
}


// //////////////////////////////////////////////////
// LEG_CRAFT_GetSkillCap
// //////////////////////////////////////////////////
int LEG_CRAFT_GetSkillCap(object oPC, int iSkill)
{
	// Setup the Cap variable.
    int iCap;

	// This is base max.  This is currently hard coded to 300 however we can set some
	// configuration options in the future to force different classes or races to
	// have a different base max.  For example, a Fighter might not be so great at
	// Alchemy so we can set his max at 100.  He could then never be better than a
	// Journeyman at this skill.  For now though, all things will be equal.
	int iBaseMax = 300;

    // Grab the PC's current base skill
	int iPCSkill = GetLocalInt(oPC, "Skill_" + IntToString(iSkill));
	if (iPCSkill == 0)
	{
		string sTable = LEG_COMMON_GetPCTable(oPC, "craftskills");
        iPCSkill = GetPersistentInt(oPC, "Skill_" + IntToString(iSkill), sTable); // This is a persistent.	
		SetLocalInt(oPC, "Skill_" + IntToString(iSkill), iPCSkill);
	}
	
    // Find out which rank they are at.
    if (iPCSkill <= 20)
        iCap = 20;
    if (iPCSkill >= 21 && iPCSkill <=45)
        iCap = 45;
    if (iPCSkill >= 46 && iPCSkill <=76)
        iCap = 76;
    if (iPCSkill >= 77 && iPCSkill <=110)
        iCap = 110;
    if (iPCSkill >= 111 && iPCSkill <=139)
        iCap = 139;
    if (iPCSkill >= 140 && iPCSkill <=169)
        iCap = 169;
    if (iPCSkill >= 170 && iPCSkill <=204)
        iCap = 204;
    if (iPCSkill >= 205 && iPCSkill <=245)
        iCap = 245;
    if (iPCSkill >= 246 && iPCSkill <=294)
        iCap = 294;
    if (iPCSkill >= 295)
        iCap = iBaseMax;

	// The PC is not allowed to go over their Base Maximum skill no matter what.  Base Max will
	// either be 300 or a restriction based on class or race.
    if (iPCSkill >= iBaseMax)
        iCap = iBaseMax;

	// Return our value.
    return iCap;
}


// //////////////////////////////////////////////////
// LEG_CRAFT_GetSkillLevelByName
// //////////////////////////////////////////////////
int LEG_CRAFT_GetSkillLevelByName(object oPC, string sSkillLevelName, int iSkill)
{
    // Grab the PC's current skill
    int iPCSkill = GetLocalInt(oPC, "Skill_" + IntToString(iSkill));
	if (iPCSkill == 0)
	{
		string sTable = LEG_COMMON_GetPCTable(oPC, "craftskills");
        iPCSkill = GetPersistentInt(oPC, "Skill_" + IntToString(iSkill), sTable); // This is a persistent.	
		SetLocalInt(oPC, "Skill_" + IntToString(iSkill), iPCSkill);
	}
		
    int iLevel;

	// Using the Name, we return the skill level.
    if (iPCSkill <= 20 && iPCSkill >= 1 && sSkillLevelName == "Unskillful")
        iLevel = 1;
    else if (sSkillLevelName == "Novice")
		iLevel = 2;
    else if (sSkillLevelName == "Apprentice")
		iLevel = 3;
    else if (sSkillLevelName == "Journeyman")
		iLevel = 4;
    else if (sSkillLevelName == "Veteran")
		iLevel = 5;
    else if (sSkillLevelName == "Expert")
		iLevel = 6;
    else if (sSkillLevelName == "Adept")
		iLevel = 7;
    else if (sSkillLevelName == "Master")
		iLevel = 8;
    else if (sSkillLevelName == "Grand Master")
		iLevel = 9;
    else if (sSkillLevelName == "Legendary")
		iLevel = 10;
		
	return iLevel;
}


// //////////////////////////////////////////////////
// LEG_CRAFT_GetPercentColor
// //////////////////////////////////////////////////
string LEG_CRAFT_GetPercentColor(float fPercent)
{
        int iRating = FloatToInt(fPercent);
        string sSkillColor;
        if (iRating <= 20)
            sSkillColor = "<color=#FF00FF>"; // Magenta
        else if (iRating >= 21 && iRating <= 36)
            sSkillColor = "<color=#FF0000>"; // Red
        else if (iRating >= 37 && iRating <= 52)
            sSkillColor = "<color=#FFFF00>"; // Yellow
        else if (iRating >= 53 && iRating <= 68)
            sSkillColor = "<color=#0000FF>"; // Blue
        else if (iRating >= 69 && iRating <= 84)
            sSkillColor = "<color=#00FF00>"; // Green
        else if (iRating >= 85)
            sSkillColor = "<color=#C0C0C0>"; // Grey

        return sSkillColor;
}


// //////////////////////////////////////////////////
// LEG_CRAFT_GetSkillLevelName
// //////////////////////////////////////////////////
string LEG_CRAFT_GetSkillLevelName(object oPC, int iSkill, int iColor = FALSE, int iNextSkill = FALSE)
{
    // Grab the PC's current skill
    int iPCSkill = GetLocalInt(oPC, "Skill_" + IntToString(iSkill));
    int iTop, iBottom;
    string sSkillLevel;

	// Find out if we're looking for the current or next skill level.  
	if (iNextSkill)
		iPCSkill++;
		
    // Find out which rank they are at.  Give it a name and then set the tops and bottoms
	// for the math for finding out the color in a given skill.  The color will represent how
	// difficult the skill is and how far along the PC is in a level.
    if (iPCSkill <= 20)
    {
        sSkillLevel = "Unskillful";
        iTop = 20;
        iBottom = 1;
    }
    if (iPCSkill >= 21 && iPCSkill <=45)
    {
        sSkillLevel = "Novice";
        iTop = 45;
        iBottom = 21;
    }
    if (iPCSkill >= 46 && iPCSkill <=76)
    {
        sSkillLevel = "Apprentice";
        iTop = 76;
        iBottom = 46;
    }
    if (iPCSkill >= 77 && iPCSkill <=110)
    {
        sSkillLevel = "Journeyman";
        iTop = 110;
        iBottom = 77;
    }
    if (iPCSkill >= 111 && iPCSkill <=139)
    {
        sSkillLevel = "Veteran";
        iTop = 139;
        iBottom = 111;
    }
    if (iPCSkill >= 140 && iPCSkill <=169)
    {
        sSkillLevel = "Expert";
        iTop = 169;
        iBottom = 140;
    }
    if (iPCSkill >= 170 && iPCSkill <=204)
    {
        sSkillLevel = "Adept";
        iTop = 204;
        iBottom = 170;
    }
    if (iPCSkill >= 205 && iPCSkill <=245)
    {
        sSkillLevel = "Master";
        iTop = 245;
        iBottom = 205;
    }
    if (iPCSkill >= 246 && iPCSkill <=294)
    {
        sSkillLevel = "Grand Master";
        iTop = 294;
        iBottom = 246;
    }
    if (iPCSkill >= 295)
    {
        sSkillLevel = "Legendary";
        iTop = 295;
        iBottom = 300;
    }

    // If we've been asked to return color, then this is what we must do:
    if (iColor)
    {
        float fPercent = IntToFloat((iPCSkill - iBottom)) * 100.0 / IntToFloat((iTop - iBottom));
		return LEG_CRAFT_GetPercentColor(fPercent);
    }
    return sSkillLevel;
}



// //////////////////////////////////////////////////
// LEG_CRAFT_LearnSkill
// //////////////////////////////////////////////////
void LEG_CRAFT_LearnSkill(object oPC, int iSkill, int iLearnChance, int iTrivial)
{
	// Find out if the Info Plugin is active.
	int iInfoActive = GetLocalInt(GetModule(), "LEG_INFO_ACTIVE");

	// Now we check to see if we are at our Cap for the purpose of further learning because
	// no learning allowed if we are at the current difficulty cap.
    int iSkillCap = LEG_CRAFT_GetSkillCap(oPC, iSkill);
	
	// Grab the PC's current skill level.
	int iPCSkill = GetLocalInt(oPC, "Skill_" + IntToString(iSkill));
	
    // Find out our Skill Level Name.
	string sSkillLevel = GetStringUpperCase(LEG_CRAFT_GetSkillLevelName(oPC, iSkill, FALSE, TRUE));
    if (sSkillLevel == "LEGENDARY")
	    sSkillLevel = "NO MORE";

	// Get the PC's table
	string sTableID = LEG_COMMON_GetPCTable(oPC, "craftskills");
	
	// If the PC is at their cap, or already at Legendary status.
    if (iPCSkill >= iSkillCap)
    {
		if (iInfoActive)
			DelayCommand(6.0, LEG_COMMON_DisplayInfoBox(oPC, "YOU REQUIRE " + sSkillLevel + " TRAINING TO LEARN MORE"));
		else
        	DelayCommand(1.75, FloatingTextStringOnCreature("!! YOU REQUIRE " + sSkillLevel + " TRAINING TO LEARN MORE !!", oPC, FALSE));
    }
    else
    {
		if (iTrivial == 10000)
		{
			// If we are at 100% then we should be easy.
			if (iInfoActive)
				DelayCommand(6.0, LEG_COMMON_DisplayInfoBox(oPC, "THIS IS EASY"));
			else
	            DelayCommand(1.75, FloatingTextStringOnCreature("!! THIS IS EASY !!", oPC, FALSE));
			return;			
		}
        else if ((Random(10000) + 1) <= iLearnChance)
        {
			// Well it isn't trivial, so let's try to learn something from it.  We rolled, we are
			// successful based on the passed LearnChance value.
			if (iInfoActive)
				DelayCommand(6.0, LEG_COMMON_DisplayInfoBox(oPC, "YOU HAVE BECOME BETTER"));
			else
	            DelayCommand(1.75, FloatingTextStringOnCreature("!! YOU HAVE BECOME BETTER !!", oPC, FALSE));

			// Let's add a skill point to the PC's skills
            iPCSkill++;
            SetPersistentInt(oPC, "Skill_" + IntToString(iSkill), iPCSkill, 0, sTableID); // This is a persistent.
            SetLocalInt(oPC, "Skill_" + IntToString(iSkill), iPCSkill);
        }
    }
}


// //////////////////////////////////////////////////
// LEG_CRAFT_GetPCSkill
// //////////////////////////////////////////////////
int LEG_CRAFT_GetPCSkill(object oPC, int iSkill)
{
	// Get the PC's table
	string sTable = LEG_COMMON_GetPCTable(oPC, "craftskills");

	// If the PC has no base skill, we return 0.
	int iPCSkill = GetLocalInt(oPC, "Skill_" + IntToString(iSkill));
	//SpeakString("GetPCSkill: Local Int Skill: " + IntToString(iPCSkill), TALKVOLUME_SHOUT);
	if (iPCSkill == 0)
	{
        iPCSkill = GetPersistentInt(oPC, "Skill_" + IntToString(iSkill), sTable); // This is a persistent.	
		SetLocalInt(oPC, "Skill_" + IntToString(iSkill), iPCSkill);
		//SpeakString("GetPCSkill: Pers Int Skill: " + IntToString(iPCSkill), TALKVOLUME_SHOUT);
	}

	// If the PC still has no skill from the Persistant Table, then just return nothing.
	if (iPCSkill == 0)
		return 0;
	else
	{
		// Find out if the Info Plugin is active.
		//int iInfoActive = GetLocalInt(GetModule(), "LEG_INFO_ACTIVE");
		
		// First thing we need to get is the index number for this skill
		object oModule = GetModule();
		string sResult = LEG_COMMON_GetFirstArrayElement(oModule, "arSkillIDs");
		while (StringToInt(sResult) != iSkill)
		{
			// If we are at the end of the array, then break out of it.
			if (sResult == "#EOA#")
				break;
			
			// Let's look for the next skill.
			sResult = LEG_COMMON_GetNextArrayElement(oModule, "arSkillIDs");
		}
		
		//SpeakString("GetPCSkill: Skill ID Found in Array: " + sResult, TALKVOLUME_SHOUT);
		
		// Hopefully we've found our skill.  If not, let's get out of this function.
		if (sResult == "#EOA#")
			return 0;
		
		// Ok, we have a winner.  Let's get the Index.
		int iSkillIndex = LEG_COMMON_GetCurrentArrayIndex(oModule, "arSkillIDs");
		
		// Now that we have the Skill Index, we can get some other info about the skill.
		// Let's get any Ability Mapping Bonus
		int iAbilityBonus;
		int iAbility = StringToInt(LEG_COMMON_GetArrayElement(oModule, "arSkillAbility", iSkillIndex));
		if (iAbility != -1)
			iAbilityBonus = GetAbilityModifier(iAbility, oPC);
		
		// Now let's get the bonus based on a skill mapping if there is one.
		int iSkillBonus;
		int iSkillMap = StringToInt(LEG_COMMON_GetArrayElement(oModule, "arSkillMap", iSkillIndex));
		if (iSkillMap != -1)
			iSkillBonus = GetSkillRank(iSkillMap, oPC);
		
	    // Lets get the player bonuses for class.
		sResult = LEG_COMMON_GetFirstArrayElement(oModule, "arSkillClassBonusIDs");
		int iClass, iClass1Bonus, iClass2Bonus, iClass3Bonus, iClassBonus;
		while (sResult != "#EOA#")
		{
			// If we find an array element that is our skill.
			if (StringToInt(sResult) == iSkill)
			{
				// This element matches our skill.  Do we have a matching class?
				iSkillIndex = LEG_COMMON_GetCurrentArrayIndex(oModule, "arSkillClassBonusIDs");
				iClass = StringToInt(LEG_COMMON_GetArrayElement(oModule, "arSkillClassBonus", iSkillIndex));
				
				// If Class Position 1 matches this entry, then add the bonus.
				if (iClass == GetClassByPosition(1, oPC))
					iClass1Bonus = StringToInt(LEG_COMMON_GetArrayElement(oModule, "arSkillClassBonusValue", iSkillIndex));
				if (iClass == GetClassByPosition(2, oPC))
					iClass2Bonus = StringToInt(LEG_COMMON_GetArrayElement(oModule, "arSkillClassBonusValue", iSkillIndex));
				if (iClass == GetClassByPosition(3, oPC))
					iClass3Bonus = StringToInt(LEG_COMMON_GetArrayElement(oModule, "arSkillClassBonusValue", iSkillIndex));
			}
			
			// Cycle through the rest.
			sResult = LEG_COMMON_GetNextArrayElement(oModule, "arSkillClassBonusIDs");
		}
		
		// Do we add in the other 2 classes?  Depends on the flag setting.
		if (CHECKALLCLASSES)
			iClassBonus = iClass1Bonus + iClass2Bonus + iClass3Bonus;
		else
			iClassBonus = iClass1Bonus;
			
	    // Lets get the player bonuses for race.
		sResult = LEG_COMMON_GetFirstArrayElement(oModule, "arSkillRaceBonusIDs");
		int iRace, iRaceBonus;
		while (sResult != "#EOA#")
		{
			// If we find an array element that is our skill.
			if (StringToInt(sResult) == iSkill)
			{
				// This element matches our skill.  Do we have a matching class?
				iSkillIndex = LEG_COMMON_GetCurrentArrayIndex(oModule, "arSkillRaceBonusIDs");
				iRace = StringToInt(LEG_COMMON_GetArrayElement(oModule, "arSkillRaceBonus", iSkillIndex));
				
				// If Class Position 1 matches this entry, then add the bonus.
				if (iRace == GetSubRace(oPC))
					iRaceBonus = StringToInt(LEG_COMMON_GetArrayElement(oModule, "arSkillRaceBonusValue", iSkillIndex));
			}
			
			// Cycle through the rest.
			sResult = LEG_COMMON_GetNextArrayElement(oModule, "arSkillRaceBonusIDs");
		}

	    // Lets get the player bonuses for race.
		sResult = LEG_COMMON_GetFirstArrayElement(oModule, "arSkillFeatBonusIDs");
		int iFeat, iFeatBonus;
		while (sResult != "#EOA#")
		{
			// If we find an array element that is our skill.
			if (StringToInt(sResult) == iSkill)
			{
				// This element matches our skill.  Do we have a matching feat?
				iSkillIndex = LEG_COMMON_GetCurrentArrayIndex(oModule, "arSkillFeatBonusIDs");
				iFeat = StringToInt(LEG_COMMON_GetArrayElement(oModule, "arSkillFeatBonus", iSkillIndex));
				
				// If we have the feat.
				if (GetHasFeat(iFeat, oPC, TRUE))
					iFeatBonus = StringToInt(LEG_COMMON_GetArrayElement(oModule, "arSkillFeatBonusValue", iSkillIndex));
			}
			
			// Cycle through the rest.
			sResult = LEG_COMMON_GetNextArrayElement(oModule, "arSkillFeatBonusIDs");
		}

		
		// Return the TOTAL skill value!
    	return iPCSkill + iAbilityBonus + iSkillBonus + iClassBonus + iRaceBonus + iFeatBonus;
	}
}


// //////////////////////////////////////////////////
// LEG_CRAFT_ToolDurabilities
// //////////////////////////////////////////////////
void LEG_CRAFT_ToolDurabilities(object oPC, object oWeaponOnPlayer)
{
    // Reduce the durability of the PC's tool by 1
    int iDurability = GetItemCharges(oWeaponOnPlayer);
	
	// Find out if this resource causes extra damage to crafting tools.
	int iToolDamage = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_ToolDamage");
	if (!iToolDamage)
		iToolDamage = 1;
	
	// Perform the damage and destroy the tool if need be.
    SetItemCharges(oWeaponOnPlayer, iDurability - iToolDamage);
    if ((iDurability - iToolDamage) <= 0)
    {
		// Clean up just in case we were stuck in a Craft All loop
		SetLocalInt(oPC, "LEG_CRAFT_CRAFTALL", FALSE);
	
        DestroyObject(oWeaponOnPlayer, 1.5);
		if (GetLocalInt(GetModule(), "LEG_INFO_ACTIVE"))
			DelayCommand(8.0, LEG_COMMON_DisplayInfoBox(oPC, "YOUR TOOL HAS BROKEN"));
		else
	        DelayCommand(2.75, FloatingTextStringOnCreature("!! YOUR TOOL HAS BROKEN !!", oPC, FALSE));
        SetCommandable(TRUE, oPC);
   }	
}

// //////////////////////////////////////////////////
// LEG_CRAFT_Durabilities
// //////////////////////////////////////////////////
void LEG_CRAFT_Durabilities(object oPC, object oWeaponOnPlayer)
{
    // Adjust the Resource Durability down 1.
	int iStrength = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_Strength");
	if (!iStrength)
	{
    	int iStrengthMin = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_StrengthMin");
		int iStrengthMax = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_StrengthMax");
		iStrength = Random(iStrengthMax - iStrengthMin + 1) + iStrengthMin;
	}

	// Save the new current strength on the resource.  Yes, strengths are reset if 
	// we should have a server reset.
    SetLocalInt(OBJECT_SELF, "LEG_CRAFT_Strength", iStrength - 1);
	
	// If the resource is done and over with, we'll want to destroy it.  We support the Legends
	// Spawn plugin for respawning however if you are not using that, it is up to you to figure 
	// out how to respawn resources using your own spawning system.  I highly recomment the
	// Legends Spawn plugin as it is quite powerful.
    if ((iStrength - 1) <= 0)
    {
		if (GetLocalInt(GetModule(), "LEG_INFO_ACTIVE"))
			DelayCommand(7.0, LEG_COMMON_DisplayInfoBox(oPC, "RESOURCE EXHAUSTED"));
		else
        	DelayCommand(2.25, FloatingTextStringOnCreature("!! RESOURCE EXHAUSTED !!", oPC, FALSE));
		
		// See if this resource had a parent because if so, we want to destroy that too if the option is
		// turned on.
		object oParent = GetLocalObject(OBJECT_SELF, "LEG_CRAFT_Parent");
		if (DESTROYCORPSE && GetIsObjectValid(oParent))
			DestroyObject(oParent, 2.0);
		
		// Check to see if this resource needs to be respawned by the SPAWN plugin
		if (GetLocalInt(GetModule(), "LEG_SPAWN_ACTIVE"))
		{
			object oParent = GetLocalObject(OBJECT_SELF, "SPAWN_Parent");
			string sIndex = GetLocalString(OBJECT_SELF, "SPAWN_Index");
			SetLocalObject(oParent, "SPAWN_" + sIndex, OBJECT_INVALID);
			LEG_COMMON_TimeOfDeath(OBJECT_SELF, oParent);
		}
		
		// Now destroy the resource.
        DestroyObject(OBJECT_SELF, 3.0);
        SetCommandable(TRUE, oPC);
        SetLocalInt(OBJECT_SELF, "Toast", TRUE);
    }

    // Reduce the durability of the PC's tool by 1
    int iDurability = GetItemCharges(oWeaponOnPlayer);
	
	// Find out if this resource causes extra damage to crafting tools.
	int iToolDamage = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_ToolDamage");
	if (!iToolDamage)
		iToolDamage = 1;
	
	// Perform the damage and destroy the tool if need be.
    SetItemCharges(oWeaponOnPlayer, iDurability - iToolDamage);
    if ((iDurability - iToolDamage) <= 0)
    {
		// Clean up just in case we were stuck in a Craft All loop
		SetLocalInt(oPC, "LEG_CRAFT_CRAFTALL", FALSE);
	
        DestroyObject(oWeaponOnPlayer, 1.5);
		if (GetLocalInt(GetModule(), "LEG_INFO_ACTIVE"))
			DelayCommand(8.0, LEG_COMMON_DisplayInfoBox(oPC, "YOUR TOOL HAS BROKEN"));
		else
	        DelayCommand(2.75, FloatingTextStringOnCreature("!! YOUR TOOL HAS BROKEN !!", oPC, FALSE));
        SetCommandable(TRUE, oPC);
   }	
}


// //////////////////////////////////////////////////
// LEG_CRAFT_HarvestResource
// //////////////////////////////////////////////////
void LEG_CRAFT_HarvestResource(object oPC, object oTarget)
{
	// Find out if the Info Plugin is active.
	int iInfoActive = GetLocalInt(GetModule(), "LEG_INFO_ACTIVE");

	// Do this again just in case it didn't turn off.
    SetCommandable(TRUE, oPC);

    // Look up the main stats for the resource.
    int iSkill = GetLocalInt(oTarget, "LEG_CRAFT_Skill");
    int iMin = GetLocalInt(oTarget, "LEG_CRAFT_MinSkill");
    int iMax = GetLocalInt(oTarget, "LEG_CRAFT_MaxSkill");

    // Calulate Chances for PC to succeed.  Here, we find out the chance PER skill point
	// in the category.  There are 10 difficulty categories.
    float fChancePer = 1.0 / IntToFloat((iMax - iMin + 1));
    int iTrivial = FALSE;
    int iChance = 0;
    int iQty = 0;
	
	// Find out what the player's skill is with bonuses.
    int iPCSkill = LEG_CRAFT_GetPCSkill(oPC, iSkill);

	//SpeakString("PC Skill: " + IntToString(iPCSkill), TALKVOLUME_SHOUT);
	//SpeakString("Min Skill: " + IntToString(iMin), TALKVOLUME_SHOUT);
	//SpeakString("Max Skill: " + IntToString(iMax), TALKVOLUME_SHOUT);
	//SpeakString("Skill: " + IntToString(iSkill), TALKVOLUME_SHOUT);
	
    // See if the PC has the skill and at least has minimum score.  If the BASE skill is 0, the
	// GetPCSkill function above will return a 0.
	iChance = LEG_CRAFT_GetSkillChance(iSkill, iMin, iMax, iPCSkill);
    if (iChance)
    {
        // Setup Learnng Potential.  Sometimes a PC will advance their skill by doing.  
		// Even if they fail, they still have a slight chance to learn.
        int iLearnChance;
        float fBaseChance = 1.0 - (IntToFloat(iMax-iPCSkill) * fChancePer);
        float fLearnChance = 1.0 - (fBaseChance * 1.13);
        if (fLearnChance >= (IntToFloat(MAXLEARNCHANCE) / 100.00))
            iLearnChance = MAXLEARNCHANCE * 100;
        else if (fLearnChance <= (IntToFloat(MINLEARNCHANCE) / 100.00))
            iLearnChance = MINLEARNCHANCE * 100;
        else
            iLearnChance = FloatToInt(fLearnChance * 10000.0);

        // Use the formula and we move the decimal 2 places so we can get 2 decimal points
        // in the percent chance.  The MAXSUCCESS ensures that even if the PC rolls good,
		// there is still a slight chance they may fail if MAXSUCCESS < 100.
        int iRoll = Random(10000) + 1;
        if (iRoll <= iChance && iRoll <= (MAXSUCCESS * 100))
        {
            // Create the harvested object on the PC.
			int iMinQty = GetLocalInt(oTarget, "LEG_CRAFT_HarvestMin");
			int iMaxQty = GetLocalInt(oTarget, "LEG_CRAFT_HarvestMax");
			string sItem = GetLocalString(oTarget, "LEG_CRAFT_Harvest");
			DelayCommand(0.75, LEG_CRAFT_CreateResult(oPC, sItem, iMinQty, iMaxQty));

            // Create any additional item that may appear on this.
			int iMinAddQty = GetLocalInt(oTarget, "LEG_CRAFT_HarvestAddMin");
			int iMaxAddQty = GetLocalInt(oTarget, "LEG_CRAFT_HarvestAddMax");
			sItem = GetLocalString(oTarget, "LEG_CRAFT_HarvestAdd");
			int iChance = GetLocalInt(oTarget, "LEG_CRAFT_HarvestAddChance");
			if (d100() <= iChance && sItem != "")
			{
				// Now that we have a success, make any additional items and inform the PC.
				DelayCommand(0.75, LEG_CRAFT_CreateResult(oPC, sItem, iMinAddQty, iMaxAddQty));
				if (iInfoActive)
					LEG_COMMON_DisplayInfoBox(oPC, "SUCCESSFUL HARVEST WITH EXTRAS");
				else
	            	FloatingTextStringOnCreature("!! SUCCESS !!", oPC, FALSE);
			}
			else
			{
	            // Now that we have a success, inform the PC.
				if (iInfoActive)
					LEG_COMMON_DisplayInfoBox(oPC, "SUCCESSFUL HARVEST");
				else
	            	FloatingTextStringOnCreature("!! SUCCESS !!", oPC, FALSE);
			}
			
			// Let's learn something from this.  Trivial for purposes of learning must be the PC's BASE skill
			// without bonuses.  The GetPCSkill check includes bonuses and is fine for displaying to the PC
			// the chance they have to succeed, but for learning, we are only trivial there from the PC's base
			// skill.  ie; They must have 20 base skill before they can advance.
			int iPCSkill = GetLocalInt(oPC, "Skill_" + IntToString(iSkill));
			
			// Get the Chance WITHOUT bonuses
			iChance = LEG_CRAFT_GetSkillChance(iSkill, iMin, iMax, iPCSkill);
			LEG_CRAFT_LearnSkill(oPC, iSkill, iLearnChance, iChance);
        }
        else
        {
            // Now that we have a failure...
			if (iInfoActive)
				LEG_COMMON_DisplayInfoBox(oPC, "FAILED HARVEST");
			else
	            FloatingTextStringOnCreature("!! FAILURE !!", oPC, FALSE);
				
			// We can even learn if we failed.  Though we have a low success chance.
			LEG_CRAFT_LearnSkill(oPC, iSkill, FAILLEARNCHANCE * 100, FALSE);

            // We also have a chance to make something when we fail.
			int iMin = GetLocalInt(oTarget, "LEG_CRAFT_HarvestFailMin");
			int iMax = GetLocalInt(oTarget, "LEG_CRAFT_HarvestFailMax");
			int iChance = GetLocalInt(oTarget, "LEG_CRAFT_HarvestFailChance");
			string sItem = GetLocalString(oTarget, "LEG_CRAFT_HarvestFail");
			
			// If configured, let's check for creating some junk.
			if (sItem != "")
			{
				if (d100() <= iChance)
					DelayCommand(0.75, LEG_CRAFT_CreateResult(oPC, sItem, iMin, iMax));
			}
			
			// All done here.
			return;
        }
    }
    else
    {
        // PC does not have enough skill points, well, let them know.
		if (iInfoActive)
			LEG_COMMON_DisplayInfoBox(oPC, "YOU LACK THE SKILLS TO HARVEST THIS");
		else
	        FloatingTextStringOnCreature("YOU LACK THE SKILLS TO HARVEST THIS", oPC, FALSE);
        return;
    }
}


// //////////////////////////////////////////////////
// LEG_CRAFT_CheckRecipeIngredients
// //////////////////////////////////////////////////
int LEG_CRAFT_CheckRecipeIngredients(object oPC, string sIngredient, string sIngQty)
{
	// Pre-First off LOL, we need to see if this ingredient is even valid.  If not,
	// then we can return true.
	if (sIngredient == "#OUTOFBOUNDS#" || sIngredient == "#EOA#" || sIngredient == "")
		return TRUE;
	
	// First, we'll find out if we have enough inventory of the required ingredient.
	// If we do, then we'll return TRUE, otherwise, we return FALSE.
	int iMyQty = LEG_COMMON_GetInventoryCount(oPC, sIngredient);
	
	// Check to see if we have enough!
	if (iMyQty < StringToInt(sIngQty))
	{
		// Clean up just in case we were stuck in a Craft All loop
		SetLocalInt(oPC, "LEG_CRAFT_CRAFTALL", FALSE);
		
		// Ruh-Roh, don't have enough.  ABORT!
		if (GetLocalInt(GetModule(), "LEG_INFO_ACTIVE"))
			LEG_COMMON_DisplayInfoBox(oPC, "YOU DON'T HAVE ALL THE INGREDIENTS");
		else
			FloatingTextStringOnCreature("YOU DON'T HAVE ALL THE INGREDIENTS", oPC, FALSE);
		return FALSE;
	}
	else
		return TRUE;
}	


// //////////////////////////////////////////////////
// LEG_CRAFT_CheckSpellIngredient
// //////////////////////////////////////////////////
int LEG_CRAFT_CheckSpellIngredient(object oPC, string sSpellID, string sSpellID2 = "", string sSpellGate = "", int iSilent = FALSE)
{
	// Pre-First off LOL, we need to see if this spell ingredient is even valid.  If not,
	// then we can return true.
	if (sSpellID == "#OUTOFBOUNDS#" || sSpellID == "#EOA#" || sSpellID == "")
		return TRUE;
	
	// Are we checking the presence of 2 spells?
	if (sSpellGate == "And")
	{
		// PC Must have both spells.  If spell #2 isn't valid, but we're supposed to be
		// then just return true.  (This should never happen)
		
		// So here's a problem.. pesky classes that don't actually have to memorize spells.  They 
		// can use spells interchangably so if one of these classes has only 1 spell left for the day
		// the check GetHasSpell will return true for both spells if they are the same level.  We need to catch this.
		int iSpellQtyRequired = 1;
		
		// If the spell level is the same for both spells, and we are a class that doesn't need
		// to memorize spells, then we'll need a quantity of 2 required.
		if (GetSpellLevel(StringToInt(sSpellID)) == GetSpellLevel(StringToInt(sSpellID2)))
		{
			// Need an IF statement or something here to get around the Sorcerer issue of having
			// one spell left per day and the GetHasSpell function returning True for both.  Need
			// some kind of check for - If GetHasSpell == 1 and Class type is Sorcerer, then 
			// iSpellQtyRequired = 2 but how does that affect Multi-Class?  Is there a way to tell
			// if a class casts like this with a function?  Once we resolve this, update this code
			// and change the plugin as per the comments in the code.
			iSpellQtyRequired = 2;
		}
		
		
		if (sSpellID2 == "#OUTOFBOUNDS#" || sSpellID2 == "#EOA#" || sSpellID2 == "")
			return TRUE;

		if (GetHasSpell(StringToInt(sSpellID), oPC) < iSpellQtyRequired || GetHasSpell(StringToInt(sSpellID2), oPC) <= 0)
		{
			// Ruh-Roh, don't have enough.  ABORT!
			// Clean up just in case we were stuck in a Craft All loop
			if (!iSilent)
			{
				SetLocalInt(oPC, "LEG_CRAFT_CRAFTALL", FALSE);
				if (GetLocalInt(GetModule(), "LEG_INFO_ACTIVE"))
					LEG_COMMON_DisplayInfoBox(oPC, "YOU DON'T HAVE THE REQUIRED SPELLS READY");
				else
					FloatingTextStringOnCreature("YOU DON'T HAVE THE REQUIRED SPELLS READY", oPC, FALSE);
			}
			return FALSE;
		}
		else
			return TRUE;		
			
	}
	else if (sSpellGate == "Or")
	{
		// PC Must have both spells.  If spell #2 isn't valid, but we're supposed to be
		// then just return true.  (This should never happen)
		if (sSpellID2 == "#OUTOFBOUNDS#" || sSpellID2 == "#EOA#" || sSpellID2 == "")
			return TRUE;
			
		if (GetHasSpell(StringToInt(sSpellID), oPC) <= 0 && GetHasSpell(StringToInt(sSpellID2), oPC) <= 0)
		{
			// Ruh-Roh, don't have enough.  ABORT!
			// Clean up just in case we were stuck in a Craft All loop
			if (!iSilent)
			{
				SetLocalInt(oPC, "LEG_CRAFT_CRAFTALL", FALSE);
				if (GetLocalInt(GetModule(), "LEG_INFO_ACTIVE"))
					LEG_COMMON_DisplayInfoBox(oPC, "YOU DON'T HAVE THE REQUIRED SPELL READY");
				else
					FloatingTextStringOnCreature("YOU DON'T HAVE THE REQUIRED SPELL READY", oPC, FALSE);
			}
			return FALSE;
		}
		else
			return TRUE;		
			
	}
	else
	{
		// First, we'll find out if we have enough inventory of the required ingredient.
		// If we do, then we'll return TRUE, otherwise, we return FALSE.
		if (GetHasSpell(StringToInt(sSpellID), oPC) <= 0)
		{	
			// Ruh-Roh, don't have enough.  ABORT!
			// Clean up just in case we were stuck in a Craft All loop
			if (!iSilent)
			{
				SetLocalInt(oPC, "LEG_CRAFT_CRAFTALL", FALSE);
				if (GetLocalInt(GetModule(), "LEG_INFO_ACTIVE"))
					LEG_COMMON_DisplayInfoBox(oPC, "YOU DON'T HAVE THE REQUIRED SPELL READY");
				else
					FloatingTextStringOnCreature("YOU DON'T HAVE THE REQUIRED SPELL READY", oPC, FALSE);
			}
			return FALSE;
		}
		else
			return TRUE;
	}
}	


// //////////////////////////////////////////////////
// LEG_CRAFT_Craft
// //////////////////////////////////////////////////
void LEG_CRAFT_Craft(object oPC, object oTarget, int iRecipeIndex)
{
	// Find out if the Info Plugin is active.
	int iInfoActive = GetLocalInt(GetModule(), "LEG_INFO_ACTIVE");

	// Get the Module Object
	object oModule = GetModule();

	// Get our Cancel and Craft All vars
	int iCancel = GetLocalInt(oPC, "LEG_INFO_PROGBARCANCEL");
	int iCraftAll = GetLocalInt(oPC, "LEG_CRAFT_CRAFTALL");	
	
	// Do this again just in case it didn't turn off.
	if (iCancel || iCraftAll == FALSE)
    	SetCommandable(TRUE, oPC);

    // Look up the main stats for the resource.
    int iSkill = GetLocalInt(oTarget, "LEG_CRAFT_Skill");
    int iMin = StringToInt(LEG_COMMON_GetArrayElement(oModule, "arRecipeMin", iRecipeIndex));
	int iMax = StringToInt(LEG_COMMON_GetArrayElement(oModule, "arRecipeMax", iRecipeIndex));
    
	// Get the recipe ingredients and ensure PC has them all.
	string sIng1 = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng1", iRecipeIndex);
	string sIng1Qty = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng1Qty", iRecipeIndex);
	string sIng2 = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng2", iRecipeIndex);
	string sIng2Qty = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng2Qty", iRecipeIndex);
	string sIng3 = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng3", iRecipeIndex);
	string sIng3Qty = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng3Qty", iRecipeIndex);
	string sIng4 = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng4", iRecipeIndex);
	string sIng4Qty = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng4Qty", iRecipeIndex);
	string sIng5 = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng5", iRecipeIndex);
	string sIng5Qty = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng5Qty", iRecipeIndex);	
	string sIng6 = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng6", iRecipeIndex);
	string sIng6Qty = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng6Qty", iRecipeIndex);	
	string sIng7 = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng7", iRecipeIndex);
	string sIng7Qty = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng7Qty", iRecipeIndex);	
	string sIng8 = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng8", iRecipeIndex);
	string sIng8Qty = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng8Qty", iRecipeIndex);	

	// Get the Spell Ingredient. 
	string sSpellID = LEG_COMMON_GetArrayElement(oModule, "arRecipeSpellIng", iRecipeIndex);	
	string sSpellID2 = LEG_COMMON_GetArrayElement(oModule, "arRecipeSpellIng2", iRecipeIndex);		
	string sSpellGate = LEG_COMMON_GetArrayElement(oModule, "arRecipeSpellGate", iRecipeIndex);		

	// Get the gold ingredient
	string sGold = LEG_COMMON_GetArrayElement(oModule, "arRecipeGold", iRecipeIndex);		
	
	// Here we are performing a check to see if we have all the required ingredients.  If
	// we do, then we can move on, otherwise, we exit.
	if (!LEG_CRAFT_CheckRecipeIngredients(oPC, sIng1, sIng1Qty))
		return;
	if (!LEG_CRAFT_CheckRecipeIngredients(oPC, sIng2, sIng2Qty))
		return;
	if (!LEG_CRAFT_CheckRecipeIngredients(oPC, sIng3, sIng3Qty))
		return;
	if (!LEG_CRAFT_CheckRecipeIngredients(oPC, sIng4, sIng4Qty))
		return;
	if (!LEG_CRAFT_CheckRecipeIngredients(oPC, sIng5, sIng5Qty))
		return;
	if (!LEG_CRAFT_CheckRecipeIngredients(oPC, sIng6, sIng6Qty))
		return;
	if (!LEG_CRAFT_CheckRecipeIngredients(oPC, sIng7, sIng7Qty))
		return;
	if (!LEG_CRAFT_CheckRecipeIngredients(oPC, sIng8, sIng8Qty))
		return;

	// Check to see if the PC has the required spell(s)
	if (sSpellGate != "")
	{
		if (!LEG_CRAFT_CheckSpellIngredient(oPC, sSpellID, sSpellID2, sSpellGate))
			return;
	}
	else
	{
		if (!LEG_CRAFT_CheckSpellIngredient(oPC, sSpellID))
			return;
	}
		
	// Check to see if the PC has the required gold.
	if (sGold != "")
	{
		if (GetGold(oPC) < StringToInt(sGold))
		{
			if (GetLocalInt(GetModule(), "LEG_INFO_ACTIVE"))
				LEG_COMMON_DisplayInfoBox(oPC, "YOU DON'T HAVE THE REQUIRED GOLD");
			else
				FloatingTextStringOnCreature("YOU DON'T HAVE THE REQUIRED GOLD", oPC, FALSE);
			return;		
		}
	}
		
	// If we made it this far, we have all the required ingredients.  Let's destroy them
	// and move on.		
	if (sIng1 != "#OUTOFBOUNDS#" && sIng1 != "#EOA#")
		LEG_COMMON_DestroyItems(oPC, sIng1, StringToInt(sIng1Qty));
	if (sIng2 != "#OUTOFBOUNDS#" && sIng2 != "#EOA#")
		LEG_COMMON_DestroyItems(oPC, sIng2, StringToInt(sIng2Qty));
	if (sIng3 != "#OUTOFBOUNDS#" && sIng3 != "#EOA#")
		LEG_COMMON_DestroyItems(oPC, sIng3, StringToInt(sIng3Qty));
	if (sIng4 != "#OUTOFBOUNDS#" && sIng4 != "#EOA#")
		LEG_COMMON_DestroyItems(oPC, sIng4, StringToInt(sIng4Qty));
	if (sIng5 != "#OUTOFBOUNDS#" && sIng5 != "#EOA#")
		LEG_COMMON_DestroyItems(oPC, sIng5, StringToInt(sIng5Qty));
	if (sIng6 != "#OUTOFBOUNDS#" && sIng6 != "#EOA#")
		LEG_COMMON_DestroyItems(oPC, sIng6, StringToInt(sIng6Qty));
	if (sIng7 != "#OUTOFBOUNDS#" && sIng7 != "#EOA#")
		LEG_COMMON_DestroyItems(oPC, sIng7, StringToInt(sIng7Qty));
	if (sIng8 != "#OUTOFBOUNDS#" && sIng8 != "#EOA#")
		LEG_COMMON_DestroyItems(oPC, sIng8, StringToInt(sIng8Qty));

	// Get rid of the spell by 1.
	if (sSpellGate != "")
	{
		// If the Spell Gate is AND, then we remove both
		if (sSpellGate == "And")
		{
			if ((sSpellID != "#OUTOFBOUNDS#" && sSpellID != "#EOA#" && sSpellID != "") && (sSpellID2 != "#OUTOFBOUNDS#" && sSpellID2 != "#EOA#" && sSpellID2 != ""))
			{
				//int iSpellCount = GetHasSpell(StringToInt(sSpellID), oPC);
				DecrementRemainingSpellUses(oPC, StringToInt(sSpellID));
				//iSpellCount = GetHasSpell(StringToInt(sSpellID2), oPC);
				DecrementRemainingSpellUses(oPC, StringToInt(sSpellID2));
				AssignCommand(oPC, ActionCastFakeSpellAtObject(StringToInt(sSpellID), GetLocalObject(OBJECT_SELF, "CNPC")));
			}			
		}
		else
		{
			// Remove the Spell #1 if the PC has it, otherwise, remove spell #2
			if (LEG_CRAFT_CheckSpellIngredient(oPC, sSpellID, "", "", TRUE))
			{
				DecrementRemainingSpellUses(oPC, StringToInt(sSpellID));
				AssignCommand(oPC, ActionCastFakeSpellAtObject(StringToInt(sSpellID), GetLocalObject(OBJECT_SELF, "CNPC")));
			}
			else
			{
				DecrementRemainingSpellUses(oPC, StringToInt(sSpellID2));
				AssignCommand(oPC, ActionCastFakeSpellAtObject(StringToInt(sSpellID2), GetLocalObject(OBJECT_SELF, "CNPC")));
			}
		
		}
	}
	else
	{
		if (sSpellID != "#OUTOFBOUNDS#" && sSpellID != "#EOA#" && sSpellID != "")
		{
			//int iSpellCount = GetHasSpell(StringToInt(sSpellID), oPC);
			DecrementRemainingSpellUses(oPC, StringToInt(sSpellID));
			AssignCommand(oPC, ActionCastFakeSpellAtObject(StringToInt(sSpellID), GetLocalObject(OBJECT_SELF, "CNPC")));
		}	
	}
	
	// Remove the gold if needed.
	if (sGold != "")
		TakeGoldFromCreature(StringToInt(sGold), oPC, TRUE);
			
    // Calulate Chances for PC to succeed.  Here, we find out the chance PER skill point
	// in the category.  There are 10 difficulty categories.
    float fChancePer = 1.0 / IntToFloat((iMax - iMin + 1));
    int iTrivial = FALSE;
    int iChance = 0;
    int iQty = 0;
	
	// Find out what the player's skill is with bonuses.
    int iPCSkill = LEG_CRAFT_GetPCSkill(oPC, iSkill);

    // See if the PC has the skill and at least has minimum score.  If the BASE skill is 0, the
	// GetPCSkill function above will return a 0.
	iChance = LEG_CRAFT_GetSkillChance(iSkill, iMin, iMax, iPCSkill);
    if (iChance)
    {
        // Setup Learnng Potential.  Sometimes a PC will advance their skill by doing.  
		// Even if they fail, they still have a slight chance to learn.
        int iLearnChance;
        float fBaseChance = 1.0 - (IntToFloat(iMax-iPCSkill) * fChancePer);
        float fLearnChance = 1.0 - (fBaseChance * 1.13);
        if (fLearnChance >= (IntToFloat(MAXLEARNCHANCE) / 100.00))
            iLearnChance = MAXLEARNCHANCE * 100;
        else if (fLearnChance <= (IntToFloat(MINLEARNCHANCE) / 100.00))
            iLearnChance = MINLEARNCHANCE * 100;
        else
            iLearnChance = FloatToInt(fLearnChance * 10000.0);

        // Use the formula and we move the decimal 2 places so we can get 2 decimal points
        // in the percent chance.
        int iRoll = Random(10000) + 1;
        if (iRoll <= iChance && iRoll <= (MAXSUCCESS * 100))
        {
			// Ensure PC is no longer crafting.
			if (iCancel || iCraftAll == FALSE)
			    SetLocalInt(oPC, "SkillInUse", FALSE);

            // Create the crafted object on the PC.
			int iMinQty = StringToInt(LEG_COMMON_GetArrayElement(oModule, "arRecipeMinQty", iRecipeIndex));
			int iMaxQty = StringToInt(LEG_COMMON_GetArrayElement(oModule, "arRecipeMaxQty", iRecipeIndex));
			string sItem = LEG_COMMON_GetArrayElement(oModule, "arRecipeRef", iRecipeIndex);
			
			// Check to see if item is exceptional
			int iEMinQty = StringToInt(LEG_COMMON_GetArrayElement(oModule, "arRecipeExcepMin", iRecipeIndex));
			int iEMaxQty = StringToInt(LEG_COMMON_GetArrayElement(oModule, "arRecipeExcepMax", iRecipeIndex));
			int iEChance = StringToInt(LEG_COMMON_GetArrayElement(oModule, "arRecipeExcepChance", iRecipeIndex));
			int iEBonus = StringToInt(LEG_COMMON_GetArrayElement(oModule, "arRecipeExcepBonus", iRecipeIndex));
			string sEItem = LEG_COMMON_GetArrayElement(oModule, "arRecipeExcepItem", iRecipeIndex);
			
			// If configured, let's check for creating exceptional or not.
			if (sEItem != "")
			{
				// Looks like we have a chance to make one.  Let's get the PC's
				// total chance.
				int iPCOverBy = iPCSkill - iMax;
				float fPCBonus = 0.0;
				if (iEBonus)
					fPCBonus = IntToFloat(iPCOverBy) * 1.25;
				int iRoundedPCChance = FloatToInt(fPCBonus) + iEChance;
				if (iRoundedPCChance > 100)
					iRoundedPCChance = 100;
				if (iRoundedPCChance > EXCEPLIMIT)
					iRoundedPCChance = EXCEPLIMIT;

				// Now that we have a chance for exceptional, let's roll and create!				
				if (d100() <= iRoundedPCChance)
				{
					DelayCommand(0.75, LEG_CRAFT_CreateResult(oPC, sEItem, iEMinQty, iEMaxQty));
		            // Now that we have a success, inform the PC.
					if (iInfoActive)
						LEG_COMMON_DisplayInfoBox(oPC, "EXCEPTIONAL CRAFT");
					else
		            	FloatingTextStringOnCreature("!! EXCEPTIONAL !!", oPC, FALSE);
				}
				else
				{
					DelayCommand(0.75, LEG_CRAFT_CreateResult(oPC, sItem, iMinQty, iMaxQty));
		            // Now that we have a success, inform the PC.
					if (iInfoActive)
						LEG_COMMON_DisplayInfoBox(oPC, "SUCCESSFUL CRAFT");
					else
		            	FloatingTextStringOnCreature("!! SUCCESS !!", oPC, FALSE);
				}
			}
			else
			{
				// Make it now!
				DelayCommand(0.75, LEG_CRAFT_CreateResult(oPC, sItem, iMinQty, iMaxQty));
	            // Now that we have a success, inform the PC.
				if (iInfoActive)
					LEG_COMMON_DisplayInfoBox(oPC, "SUCCESSFUL CRAFT");
				else
	            	FloatingTextStringOnCreature("!! SUCCESS !!", oPC, FALSE);
				
			}
			
			// Let's learn something from this.
			// Let's learn something from this.  Trivial for purposes of learning must be the PC's BASE skill
			// without bonuses.  The GetPCSkill check includes bonuses and is fine for displaying to the PC
			// the chance they have to succeed, but for learning, we are only trivial there from the PC's base
			// skill.  ie; They must have 20 base skill before they can advance.
			int iPCSkill = GetLocalInt(oPC, "Skill_" + IntToString(iSkill));
			
			// Get the Chance WITHOUT bonuses
			iChance = LEG_CRAFT_GetSkillChance(iSkill, iMin, iMax, iPCSkill);
			LEG_CRAFT_LearnSkill(oPC, iSkill, iLearnChance, iChance);
			
			// Re-call Progress Bar if we are Crafting All and not cancelled.
			if (iCancel == FALSE && iCraftAll == TRUE)
			{
				DelayCommand(1.6, ExecuteScript("leg_info_progbar", oTarget));
			}
			
        }
        else
        {
            // Now that we have a failure...
			if (iInfoActive)
				LEG_COMMON_DisplayInfoBox(oPC, "FAILED CRAFT");
			else
	            FloatingTextStringOnCreature("!! FAILURE !!", oPC, FALSE);
				
			// Free up the PC
			if (iCancel || iCraftAll == FALSE)
        	    SetLocalInt(oPC, "SkillInUse", FALSE);

			// We can even learn if we failed.  Though we have a low success chance.
			LEG_CRAFT_LearnSkill(oPC, iSkill, FAILLEARNCHANCE * 100, FALSE);

            // We also have a chance to make something when we fail.
			int iMinQty = StringToInt(LEG_COMMON_GetArrayElement(oModule, "arRecipeFailMin", iRecipeIndex));
			int iMaxQty = StringToInt(LEG_COMMON_GetArrayElement(oModule, "arRecipeFailMax", iRecipeIndex));
			int iChance = StringToInt(LEG_COMMON_GetArrayElement(oModule, "arRecipeFailChance", iRecipeIndex));
			string sItem = LEG_COMMON_GetArrayElement(oModule, "arRecipeFailItem", iRecipeIndex);
			
			// If configured, let's check for creating some junk.
			if (sItem != "")
			{
				if (d100() <= iChance)
					DelayCommand(0.75, LEG_CRAFT_CreateResult(oPC, sItem, iMinQty, iMaxQty));
			}
			
			// Re-call Progress Bar if we are Crafting All and not cancelled.
			if (iCancel == FALSE && iCraftAll == TRUE)
			{
				DelayCommand(1.6, ExecuteScript("leg_info_progbar", oTarget));
			}
			
			// All done here.
			return;
        }
    }
    else
    {
        // PC does not have enough skill points, well, let them know.
		if (iInfoActive)
			LEG_COMMON_DisplayInfoBox(oPC, "YOU LACK THE SKILLS TO CRAFT THIS");
		else
	        FloatingTextStringOnCreature("YOU LACK THE SKILLS TO CRAFT THIS", oPC, FALSE);
        return;
    }
}