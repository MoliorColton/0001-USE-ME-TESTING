
/*

    Script:			Script to place on a gold pile placeable.  It's a one shot gold pile for each player.
					Any single player can loot this and it will then disappear.  If for whatever reason it
					is respawned (either through a spawner or server reset), the gold pile will be available
					once again to the next player however anyone who loots it will only be able to loot it
					one time.  A unique ID on the loot pile will be set by the loot plugin to track.
	Version:		1.0
	Plugin Version: 2.00
	Author:			Marshall Vyper

	Change Log:		08/16/2015 - 1.2 MV - Initial Version
					

*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_loot_include"


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
string sGOLDRANGE_MAX = "LEG_LOOT_GoldMax";	//Defaults to 300, 0 is not a valid entry.
string sGOLDRANGE_MIN = "LEG_LOOT_GoldMin";	//Defaults to 100, if MAX is specified it will default to 1/3 of that, 0 is not a valid entry.
string sUSES_LEFT = "LEG_LOOT_Uses";		//Defaults to 1, 0 is not a valid entry.

void main()
{

	// Who just opened me and who's mah daddy?
	object oPC = GetLastUsedBy();
	object oParent = GetLocalObject(OBJECT_SELF, "SPAWN_Parent");

	if (!GetIsObjectValid(oParent))
	{
		oParent = OBJECT_SELF;
	}
	else
	{
		if (GetLocalString(oParent, "LEG_LOOT_ID") == "")
		{
			oParent = OBJECT_SELF;
		}
	}
	
	
	// Get the ID of this loot object, because that's what we'll be storing and reading in the DB.
	string sLootObjectID = GetLocalString(oParent, "LEG_LOOT_ID");
	if (GetPersistentInt(oPC, sLootObjectID, DBTABLENAME))
	{
		// Nope, sorry, the database says you've looted this before.  Too bad.
		LEG_COMMON_DisplayInfoBox(oPC, "You only find fools gold.");
		return;
	}
	else
	{
		// Database says its ok to loot, but you can only loot once so we need to store this
		// action.	
		SetPersistentInt(oPC, sLootObjectID, 1, 0, DBTABLENAME);
	}		


	// Code stolen from the built in scripts.
	int nUsesLeft = GetLocalInt(OBJECT_SELF,sUSES_LEFT);	//if zero, assume the value is uninitialized.
		SetLocalInt(OBJECT_SELF,sUSES_LEFT,nUsesLeft-1);
	
	if (nUsesLeft>=0)
	{
			
		int nGoldRangeMax = GetLocalInt(OBJECT_SELF,sGOLDRANGE_MAX);
		int nGoldRangeMin = GetLocalInt(OBJECT_SELF,sGOLDRANGE_MIN);
	
		if (nGoldRangeMax == 0)
			nGoldRangeMax = 300;
		if (nGoldRangeMin == 0)
			nGoldRangeMin = nGoldRangeMax/3;
			
		int nGP = Random(nGoldRangeMax-nGoldRangeMin)+nGoldRangeMin;
	
		object oPC = GetLastUsedBy();		
		GiveGoldToCreature(oPC,nGP);
		AssignCommand(oPC, PlaySound("it_coins"));
	
	}
	if (nUsesLeft<=1)
	{
		AssignCommand(OBJECT_SELF,DestroyObject(OBJECT_SELF));	
	}
}