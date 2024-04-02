/*

    Script:			This is the magical opening script for Pandora's... er.. the loot.. yeah loot..mmmmm.  Actually
					it is the script that actually creates loot on things.  This could be called via the on open
					event of a chest, the end of a conversation with an NPC or when killing a monster.  There are 3
					parameters used in this script.  The first being oPC which is always the player.  The second is
					the Parent object or the place where the variables are stored for this loot.  The last one is
					the target of the Loot which is usually the caller of this script.  This script is NEVER placed
					in an event and is always called via ExecuteScriptEnhanced from somewhere else.
	Version:		1.8
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		object oPC, object oParent

	Change Log:		11/24/2010 - 1.00 MV - Initial Release
					11/26/2010 - 1.01 MV - Updated to support Legends Plugin Systems
					11/27/2010 - 1.02 MV - Added support for random Armor
					12/18/2010 - 1.03 MV - Upgraded to Plugin 1.3, Added database support for random items.
					12/22/2010 - 1.04 MV - Added support for random spell scrolls/potions, ammo quantities, LevelMax
					12/23/2010 - 1.05 MV - Bug fixes, changed prop and spell selection to array based.  Slower, but more accurate.
					10/03/2012 - 1.6 MV - Bug fixes.
					10/06/2012 - 1.7 MV - Fixed bug in using TABLE LOOT_ID value for persistent loot.
					06/05/2013 - 1.8 MV - Fixed bug when using Loot Levels
*/

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_loot_include"
#include "x2_inc_itemprop"

	

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main(object oPC, object oParent)
{
	// The target that will recieve the loot will always be the object the script is running on.
	object oTarget = OBJECT_SELF;
	
	// Have I been opened before and do I only spawn once when I am opened the first time?
	if (!GetLocalInt(oParent, "LEG_LOOT_PerPlayer") && GetLocalInt(oTarget, "LOOT_BeenOpened"))
		return;
	else
		SetLocalInt(oTarget, "LOOT_BeenOpened", 1);
		
	// Has this person opened me since I was created?
	if (GetLocalInt(oTarget, GetPCPublicCDKey(oPC) + "_" + GetName(oPC)))
	{
		// Yep, this guy opened me before so lets do nothing.
		return;	
	}
	else
	{
		// Am I allowed to loot this each time it spawns?  If not, then I had better not do anything.  Of course
		// this means I can loot it between server resets.
		if (GetLocalInt(oParent, "LEG_LOOT_OncePerReset"))
		{
			// Looks like I am only allowed to loot this once per reset so lets check
			if (GetLocalInt(oParent, GetPCPublicCDKey(oPC) + "_" + GetName(oPC)))
			{
				// Yep, this guy opened me before so lets do nothing.
				return;	
			}
			else
			{
				// Let's make sure he/she/it can't loot until the server resets.
				SetLocalInt(oParent, GetPCPublicCDKey(oPC) + "_" + GetName(oPC), TRUE);
			}
		}
		
		
		// Let's make sure this guy doesn't open it again during this spawn.
		SetLocalInt(oTarget, GetPCPublicCDKey(oPC) + "_" + GetName(oPC), TRUE);
		
		// First time I've been opened by this person!  WOOT! Oh wait, have I "EVER" opened this before?
		// If the object is configured to only let me loot this once ever, then I had better find out.
		if (GetLocalInt(oParent, "LEG_LOOT_LootOnceOnly"))
		{
			object oLimitedObject;
			
			// We need to decide if this is a ONCE PER PLAYER ONLY EVER or ONCE PER SERVER ONLY EVER, ONE PLAYER ONLY.
			if (GetLocalInt(oParent, "LEG_LOOT_PerPlayer"))
			{
				// Each PC can loot this once ONLY EVER.
				oLimitedObject = oPC;
			}
			else
			{
				// Only the first PC that loots this, gets it... EVER.
				oLimitedObject = GetModule();
			}
			
			// Get the ID of this loot object, because that's what we'll be storing and reading in the DB.
			string sLootObjectID = GetLocalString(oParent, "LEG_LOOT_ID");
			if (GetPersistentInt(oLimitedObject, sLootObjectID, DBTABLENAME))
			{
				// Nope, sorry, the database says you've looted this before.  Too bad.
				return;
			}
			else
			{
				// Database says its ok to loot, but you can only loot once so we need to store this
				// action.	
				SetPersistentInt(oLimitedObject, sLootObjectID, 1, 0, DBTABLENAME);
			}
		}

		// Well the local integer says we can loot this, and if we got this far, the database says its ok as well.		
		// So Let's make LOOTS!  First we'll see how many loots I'm allowed to spawn and go from there.
		int iLootCount = GetLocalInt(oParent, "LEG_LOOT_Count");
		int iPCLootLevel = 0;
		int iCRLootLevel = 0;
		int iItemLootLevel = 0;
		int iCount, iChance, iMinQty, iMaxQty, iQty;
		string sCount, sHardItem;
		
		for (iCount=1; iCount <= iLootCount; iCount++)
		{
			sCount = IntToString(iCount);	
			
			iPCLootLevel = GetLocalInt(oParent, "LEG_LOOT_PCLootLevel_" + sCount);
			iCRLootLevel = GetLocalInt(oParent, "LEG_LOOT_CRLootLevel_" + sCount);
			iItemLootLevel = 0;
			
			// Ok, we're on an item.  Let's see if this is a hard item creation rather than a 
			// dynamic on.  Grab its chance etc to spawn and make it so.
			iChance = GetLocalInt(oParent, "LEG_LOOT_Chance_" + sCount);
			iMinQty = GetLocalInt(oParent, "LEG_LOOT_MinQty_" + sCount);
			iMaxQty = GetLocalInt(oParent, "LEG_LOOT_MaxQty_" + sCount);
			iQty = Random(iMaxQty - iMinQty + 1) + iMinQty;
			sHardItem = GetLocalString(oParent, "LEG_LOOT_HardItem_" + sCount);
			
			// Well are we hard?  hehehe.
			if (sHardItem != "")
			{
				// Looks like this item is a hard item so lets create it if we succeed a d100 (d for dork) and move on.
				if (d100() <= iChance)
				{
					// Before we spawn this item we need to do is to ensure this item is not a unique one that has
					// already spawned. If it has, we are SOL because there CAN BE ONLY ONE!  Muahahahaha!
					if (GetLocalInt(oParent, "LEG_LOOT_UniqueItem_" + sCount))
					{
						// The only way this works of course is if its been stored in the database.
						if (!LEG_COMMON_GetPersistentInt(DATABASETYPE, GetModule(), sHardItem, DBTABLENAME))
						{
							// Make so item can't be spawned again.
							LEG_COMMON_SetPersistentInt(DATABASETYPE, GetModule(), sHardItem, 1, DBTABLENAME);
							
							// Woot we rolled in the good!  Make Item go Now!
							LEG_COMMON_CreateItem(oTarget, sHardItem, iQty);	
						}
						else
						{
							// Uh oh, this was a unique item and it has spawned!  We can at least now go
							// check and see if there is an alternate that we should use.
							string sHardAlternate = GetLocalString(oParent, "LEG_LOOT_HardAlternate_" + sCount);
							if (sHardAlternate != "")
							{
								// Make a roll against the Hard Alternate chance to drop.
								int iHardAltChance = GetLocalInt(oParent, "LEG_LOOT_AlternateChance_" + sCount);
								if (d100() <= iHardAltChance)
								{
									// Looks like we have a winner on the alternate, so lets create it.
									LEG_COMMON_CreateItem(oTarget, sHardAlternate, iQty);	
								}
							}
						}
					}
					else
					{
						object oItem = LEG_COMMON_CreateItem(oTarget, sHardItem, iQty);
						
						// Should our new item be automagically identified?
						if (GetLocalInt(oParent, "LEG_LOOT_Identified_" + sCount))
							SetIdentified(oItem, TRUE);
						else
							SetIdentified(oItem, FALSE);						
					}
				}
				else
				{
					// The Hard Item Drop failed its chance to drop so we now check and see if there is a Hard Alternate
					// that should drop in its place.
					string sHardAlternate = GetLocalString(oParent, "LEG_LOOT_HardAlternate_" + sCount);
					if (sHardAlternate != "")
					{
						// Make a roll against the Hard Alternate chance to drop.
						int iHardAltChance = GetLocalInt(oParent, "LEG_LOOT_AlternateChance_" + sCount);
						if (d100() <= iHardAltChance)
						{
							// Looks like we have a winner on the alternate, so lets create it.
							object oItem = LEG_COMMON_CreateItem(oTarget, sHardAlternate, iQty);	
							
							// Should our new item be automagically identified?
							if (GetLocalInt(oParent, "LEG_LOOT_Identified_" + sCount))
								SetIdentified(oItem, TRUE);
							else
								SetIdentified(oItem, FALSE);							
						}
					}
				}
			}
			else if (GetLocalString(oParent, "LEG_LOOT_BaseType_" + sCount) != "" || GetLocalString(oParent, "LEG_LOOT_RandomBase_" + sCount) != "")
			{
				// Lets define an item because we'll need to work with it.
				object oItem;
				int iItemTypes, iItemType;
				string sRandomItem;
				string sNewName;
				
				// Looks like this item is a dynamic item so lets create it if we succeed a d100 (d for dork) and move on.
				if (d100() <= iChance)
				{
					// Woot we rolled in the good!  Make Item go Now!  (We'll add Qty later and property count later)
					// First we need to figure out what we're supposed to create - we'll need to get the base item
					// resref from the waypoint.  If we are choosing a random basetype, lets do that, otherwise
					// use the hardcoded base type.
					string sBaseItem;
					string sRandomType = GetLocalString(oParent, "LEG_LOOT_RandomBase_" + sCount);
					if (sRandomType != "")
					{
						// If we are to use a random item from the items 2da, first we'll see if we are allowed to
						// choose from ANY item, or just from a specific group of items.
						if (sRandomType == "*")
						{						
							// YAY!  We're allowed to choose ANY item that has a valid resref in the 2da.  We'll have
							// to randomly choose an item until we get one with a resref and then we'll use that.
							iItemTypes = GetNum2DARows(ITEMGRPMEMBERFILE);
							iItemType = Random(iItemTypes);
							sRandomItem = Get2DAString(ITEMGRPMEMBERFILE, "RESREF", iItemType);
							while (sRandomItem == "*")
							{
								iItemType = Random(iItemTypes);
								sRandomItem = Get2DAString(ITEMGRPMEMBERFILE, "RESREF", iItemType);
								
							}
							// Because armor has only one base type, we standardize on that in the Group 2da.  Then
							// select one from an existing list in the armor 2da file.
							if (sRandomItem == "BASEARMOR")
							{
								int iArmorCount = GetNum2DARows(ARMORFILE2DA);
								iItemType = Random(iArmorCount);
								sRandomItem = Get2DAString(ARMORFILE2DA, "RESREF", iItemType);
							}
						}						
						else
						{
							// Looks like we have to choose from a specific group of items.  So we have a couple of things
							// we need to check for.  We need to ensure that first the item has a valid resref and if 
							// so, we then check and see what groups the item is a member of.  If its not a member of
							// the group we need to get, then we start all over again till we find one.  Bleh.
							int iItemFound;
							string sGroupMember1, sGroupMember2, sGroupMember3;
							iItemTypes = GetNum2DARows(ITEMGRPMEMBERFILE);
							
							while (iItemFound == FALSE)
							{
								iItemType = Random(iItemTypes);
								sRandomItem = Get2DAString(ITEMGRPMEMBERFILE, "RESREF", iItemType);
								while (sRandomItem == "*")
								{
									iItemType = Random(iItemTypes);
									sRandomItem = Get2DAString(ITEMGRPMEMBERFILE, "RESREF", iItemType);
								}
								sGroupMember1 = Get2DAString(ITEMGRPMEMBERFILE, "GROUP1", iItemType);
								sGroupMember2 = Get2DAString(ITEMGRPMEMBERFILE, "GROUP2", iItemType);
								sGroupMember3 = Get2DAString(ITEMGRPMEMBERFILE, "GROUP3", iItemType);
								if (sRandomType == sGroupMember1 || sRandomType == sGroupMember2 || sRandomType == sGroupMember3)
									iItemFound = TRUE;
								else
									iItemFound = FALSE;
							}
							
							// Because armor has only one base type, we standardize on that in the Group 2da.  Then
							// select one from an existing list in the armor 2da file.
							if (sRandomItem == "BASEARMOR")
							{
								int iArmorCount = GetNum2DARows(ARMORFILE2DA);
								iItemFound = FALSE;
								iItemType = Random(iArmorCount);
								sRandomItem = Get2DAString(ARMORFILE2DA, "RESREF", iItemType);
								if (sRandomType != "B" && sRandomType != "L")
								{
									while (iItemFound == FALSE)
									{
										sGroupMember1 = Get2DAString(ARMORFILE2DA, "GROUP1", iItemType);
										if (sRandomType == sGroupMember1)
											iItemFound = TRUE;
										else
										{
											iItemType = Random(iArmorCount);
											sRandomItem = Get2DAString(ARMORFILE2DA, "RESREF", iItemType);
											iItemFound = FALSE;
										}
									}
								}
							}
						}
						// Finally we found a random item to use.  WOOT!
						sBaseItem = sRandomItem;
						
					}
					else
						sBaseItem = GetLocalString(oParent, "LEG_LOOT_BaseType_" + sCount);
					
					// Now create the base item.
					oItem = LEG_COMMON_CreateItem(oTarget, sBaseItem, 1);
					
					// First thing we check is to see if this item requires a specific property from what we have
					// available in our 2DA.
					itemproperty ipItemProperty;
					int iParameter1, iParameter2, iParameter3;
					int iPropertyType = GetLocalInt(oParent, "LEG_LOOT_RequiredProp_" + sCount);
					if (iPropertyType)
					{
						iParameter1 = GetLocalInt(oParent, "LEG_LOOT_RequiredPropPar1_" + sCount);
						iParameter2 = GetLocalInt(oParent, "LEG_LOOT_RequiredPropPar2_" + sCount);
						iParameter3 = GetLocalInt(oParent, "LEG_LOOT_RequiredPropPar3_" + sCount);
						
						// Ok we have an Item, we have a property, let's get the property.
						itemproperty ipItemProperty = LEG_LOOT_GetItemProperty(iPropertyType, iParameter1, iParameter2, iParameter3);
						
						// Now we actually have the property, lets apply it to our base item.
						IPSafeAddItemProperty(oItem, ipItemProperty, 0.0, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
					}
					
					// Should our new item be automagically identified?
					if (GetLocalInt(oParent, "LEG_LOOT_Identified_" + sCount))
						SetIdentified(oItem, TRUE);
					else
						SetIdentified(oItem, FALSE);
														
					// Time for a dynamic properties.  This is where things get interesting.  First we'll need to start with
					// the level of the property to add.  If we are using Monster CR, that overrides everything, otherwise
					// we check for Player level and finally failing that we use Area Level.  Without any of these
					// settings, we default the property to item level 0.  We allow 1 Item level for every X 
					// levels as defined in the main loot include file.
					iItemLootLevel = GetLocalInt(oParent, "LEG_LOOT_ItemLevel_" + sCount);
					int iItemLevel;
					if (iCRLootLevel)
					{
						int iCRLevel = FloatToInt(GetChallengeRating(oParent));
						iItemLevel = iCRLevel / ITEMLEVELS;
					}
					else if (iPCLootLevel)
					{
						int iPCLevel = GetTotalLevels(oPC, FALSE);
						int iItemLevel = iPCLevel / ITEMLEVELS;
					}				
					else if (iItemLootLevel)
					{
						iItemLevel = iItemLootLevel;
					}
					else
					{
						// If we use Area Level for then get that, otherwise if Player Level option is set, use that.
						iItemLevel = GetLocalInt(GetArea(oTarget), "LEG_LOOT_Level");
					}
					
					//SpeakString("Level: " + IntToString(iItemLevel), TALKVOLUME_SHOUT);
					
					// Next we need to identify the name of the 2da file for that Level of Properties.  We store all the
					// properties for each level in a separate 2da file.  File names are in the format of:
					// BASEFILENAME0 for level 0 items replacing 0 with the item level.  BASEFILENAME is defined in the
					// main loot include
					string sPropertiesFile = BASEFILENAME + IntToString(iItemLevel);
	
					// We need to find out how many different properties are in this level so we can
					// randomly choose one.
					int iTotalProperties = GetNum2DARows(sPropertiesFile);
	
					// Sanity check
					if (iTotalProperties == -1)
					{
						// Ruh-Roh - missing 2da, looks like all your getting is the base item.
						SendMessageToAllDMs("Notice:  An attempt to open a 2da file failed because it does not exist.  File: " + sPropertiesFile);
						return;
					}

					// How many properties are we gonna add?  This can go 2 ways.  We have either specified
					// random item properties to match the total level or we have hard specified the number
					// of properties.  Let's figure out which.
					int iPropCounter;
					int iPropertiesCount = GetLocalInt(oParent, "LEG_LOOT_Properties_" + sCount);

					// Let's find out if our item properties needs to be the TOTAL ITEM LEVEL configured or if each
					// property is = to the ITEM LEVEL configured.
					int iItemLevelMax = GetLocalInt(oParent, "LEG_LOOT_ItemLevelMax_" + sCount);
					int iCurrentItemLevel, iRemainingLevels;
					int iNoRandomName;
					if (iItemLevelMax)
					{
						// Looks like our properties are based on the total item level.  Let's see what level
						// our item is already based on any required properties we already put on it.
						iCurrentItemLevel = LEG_COMMON_GetItemLevel(oItem);
						iRemainingLevels = iItemLevel + 1 - iCurrentItemLevel;
					}
										
					// Did we add a required property and if so, do we need to count that property against
					// the alloted properties?  
					int iPropertyUsed = GetLocalInt(oParent, "LEG_LOOT_RequiredPropInc_" + sCount);
					if (iPropertyUsed)
						iPropertiesCount--;
						
					
					// That's how many.  So lets set up for that.  First thing we do is choose a property.  We'll
					// need to do some checks so we don't end up with duplicate properties, restricted ones etc.
					for (iPropCounter = 0; iPropCounter < iPropertiesCount; iPropCounter++)
					{
						// If we're all out of property item levels as a result of specifying the ItemLevelMax
						// flag, then no more properties allowed
						if (iItemLevelMax)
						{
							if (iRemainingLevels <= 0)
								break;
							else
							{
								// We are using the ItemLevelMax flag so we want to specify random item
								// level properties.  Given we have specified our BaseFile 2DA name above
								// for when we are not doing this, we need to choose one at random now.
								// We can choose one based on the remaining item levels allowed
								int iRandomLevel = Random(iRemainingLevels) + 1;
								sPropertiesFile = BASEFILENAME + IntToString(iRandomLevel);
								iRemainingLevels = iRemainingLevels - iRandomLevel;
							}
						}
						
						// Ok for this property iteration, we need to choose one and check to ensure it is not
						// restricted for this item, and if so, choose another.
						int iDupeCounter, iRestrictionFound;
						int iDupeFound = TRUE;
						int i2DAProperty = LEG_LOOT_FindProperty(sPropertiesFile, oItem, oPC);
						
						// Only attempt to apply a property if there are some at this level, otherwise,
						// try the next property (Of course, if we are not using ItemLevelMax, it will
						// just cycle through aborting all of them because they would all be the same
						// level, HOWEVER, if we are using ItemLevelMax, we have a "chance" to choose
						// a different level file.
						if (i2DAProperty != -1)
						{
							iPropertyType = StringToInt(Get2DAString(sPropertiesFile, "PROPERTY", i2DAProperty));
							
							// And now Mr. Lottery man, which property do we choose?  When we create the item properties,
							// we don't want any duplicate types, so we loop through until we get unique properties.  Be
							// careful here because if there are more properties assigned than there are unique properties
							// well.. loopidy loop time and SPLAT.
							int iSanity = 0;
							if (!GetLocalInt(oParent, "LEG_LOOT_AllowDupeProps_" + sCount))
							{
								while (iDupeFound && iSanity < 20)
								{
									// Decided to put in a sanity checker.  If we don't get through this mess in 50
									// attempts, then jump out with what we got.  (So yeah it's POSSBILE to get a dupe,
									// especially if there's not many properties in the 2da that are acceptable for the
									// item.)
									iSanity++;
									
									// Check to see if this property is already on the item.
									iDupeFound = LEG_LOOT_CheckDupe(iPropCounter, iPropertyType, oItem);
									
									// If a Duplicate property was found, or this property is restricted,
									// then choose another.
									if (iDupeFound)
									{
										i2DAProperty = LEG_LOOT_FindProperty(sPropertiesFile, oItem, oPC);
										iPropertyType = StringToInt(Get2DAString(sPropertiesFile, "PROPERTY", i2DAProperty));
									}
									else
										iSanity = 20;
								}	
							}	
							else
								iDupeFound = FALSE;
								
							// Went through 100 iterations and could not find a valid property so we
							// skip the property.
							if (iDupeFound || iRestrictionFound)
							{
								// No property found for this iteration.  That sucks, this means that there are
								// not enough properties in the 2DA to accomodate this item's requirements.
								// We have a unique property, let's clear the array that we used earlier.
								LEG_COMMON_ClearArray(OBJECT_SELF, "PropArray_" + sPropertiesFile + "Row" + GetName(oPC));
								
								SetLocalInt(oItem, "Prop_" + IntToString(iPropCounter), -1);
							}
							else
							{
								// We have a unique property, let's clear the array that we used earlier.
								LEG_COMMON_ClearArray(OBJECT_SELF, "PropArray_" + sPropertiesFile + "Row" + GetName(oPC));
								
								// Store the property ID on the item so we can check for future dupes
								SetLocalInt(oItem, "Prop_" + IntToString(iPropCounter), iPropertyType);
							
								// We have a winner!  Let's get some parameters from it.
								int iParameter1Low = StringToInt(Get2DAString(sPropertiesFile, "PARAMETER1LOW", i2DAProperty));
								int iParameter1High = StringToInt(Get2DAString(sPropertiesFile, "PARAMETER1HIGH", i2DAProperty));
								int iParameter2Low = StringToInt(Get2DAString(sPropertiesFile, "PARAMETER2LOW", i2DAProperty));
								int iParameter2High = StringToInt(Get2DAString(sPropertiesFile, "PARAMETER2HIGH", i2DAProperty));
								int iParameter3Low = StringToInt(Get2DAString(sPropertiesFile, "PARAMETER3LOW", i2DAProperty));
								int iParameter3High = StringToInt(Get2DAString(sPropertiesFile, "PARAMETER3HIGH", i2DAProperty));
								
								// Because many item properties have multiple parameters within a given range of values,
								// we'll want to randomly select one from the ranges.  It would seem there are at most
								// 2 possible values at the moment.
								int iParameter1, iParameter2, iParameter3;
								iParameter1 = Random(iParameter1High - iParameter1Low + 1) + iParameter1Low;
								iParameter2 = Random(iParameter2High - iParameter2Low + 1) + iParameter2Low;
								iParameter3 = Random(iParameter3High - iParameter3Low + 1) + iParameter3Low;
								
								// Ok we have an Item, we have a property, let's get the property.  Note, that if
								// the Property is of type CastRandomSpell, we have some extra work to do.  The
								// parameters of CastRandomSpell are a default spell should we fail to get one
								// randomly.
								if (iPropertyType == CastRandomSpell)
								{
									int iSpellToApply = -1;
									int iSanityCounter, iRandomSpellID, iSpellLevel;
									//int iTotalSpells = GetNum2DARows(DBSPELLFILE);
									int iSpellAllowed, iSpellIndex;
									int iBaseItemType = GetBaseItemType(oItem);									
									
									// Get a spell.
									iSpellToApply = LEG_LOOT_GetSpell(iItemLevel, iBaseItemType, sPropertiesFile, oPC);
									
									// Did I get a spell?
									if (iSpellToApply != -1)
									{
										// Woot, Got one, now I need the index.
										iParameter1 = iSpellToApply;
										sNewName = Get2DAString(DBSPELLFILE, "Label", iSpellToApply);
									}
									else
										sNewName = Get2DAString(DBSPELLFILE, "Label", iParameter1);
									iParameter2 = 1;
									
									// Cleanup
									LEG_COMMON_ClearArray(OBJECT_SELF, "SpellArray_" + sPropertiesFile + "Row" + GetName(oPC));
									
									// Let's name this thing appropriatlylylyly
									iNoRandomName = TRUE;
									sNewName = LEG_COMMON_TextReplace(sNewName, "_", " ");
									SetFirstName(oItem, GetName(oItem) + " of " + sNewName);							
								}
		
								// Ok we have an Item, we have a property, let's get the property.
								ipItemProperty = LEG_LOOT_GetItemProperty(iPropertyType, iParameter1, iParameter2, iParameter3);
								
								// Now we actually have the property, lets apply it to our base item.
								IPSafeAddItemProperty(oItem, ipItemProperty, 0.0, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
								//if (GetBaseItemType(oItem) == 20)
								//{
								//	SpeakString("Arrow Found, Applying Property: " + IntToString(iPropertyType) + " Parm1: " + IntToString(iParameter1) + " Parm2: " + IntToString(iParameter2), TALKVOLUME_SHOUT);
								//}
							}
						}
					}
					
					// If we need to create a funky whizbang name on this, then lets do that now.
					int iNameLength = GetLocalInt(oParent, "LEG_LOOT_RandomName_" + sCount);
					if (iNameLength && !iNoRandomName)
					{
						// Generate a Random name and make the first letter capital.
						sNewName = LEG_COMMON_GeneratePass(iNameLength);
						string sFirstLetter = GetStringUpperCase(GetStringLeft(sNewName, 1));
						string sRestOfName = GetStringRight(sNewName, GetStringLength(sNewName) - 1);
						sNewName = sFirstLetter + sRestOfName;
						SetFirstName(oItem, GetName(oItem) + " of " + sNewName);
					}

					// If the Min and Max quantities are set to 0, then we use the quantity range from the
					// base item 2da
					if (iMinQty <= 0 && iMaxQty <= 0)
					{
						// Let's get our overrides.
						iMinQty = StringToInt(Get2DAString(ITEMGRPMEMBERFILE, "MINQTYOV", iItemType));
						iMaxQty = StringToInt(Get2DAString(ITEMGRPMEMBERFILE, "MAXQTYOV", iItemType));
						iQty = Random(iMaxQty - iMinQty + 1) + iMinQty;
						
						// If we want to multiply the quantity by the value in the Quantity Multiplier.
						int iMultiplyerByLevel = GetLocalInt(oParent, "LEG_LOOT_QtyMultiplyer_" + sCount);
						if (iMultiplyerByLevel)
						{
							// Can't do this for EVERY item though.  Some are exempt!  Unless of
							// course we force the plugin to ignore exemptions on this loot.
							// Confused yet?  Hell I know I am!  Muahahah!
							if (Get2DAString(ITEMGRPMEMBERFILE, "MULTEXEMPT", iItemType) != "1" || GetLocalInt(oParent, "LEG_LOOT_QtyMultiplyerNoExempt_" + sCount))
								iQty = iQty * iMultiplyerByLevel;
						}
					}
										
					// Now that we have finished and polished and made shiny our new dynamic item.  Lets check
					// the quantity and ensure we have enough of what we're supposed to have.
					if (iQty > 1)
					{
						// Looks like we need more than one!  Lets get copying!  The problem with copying is that
						// if we copy an object in an target's inventory to the SAME target, the item, if it is
						// stackable, is returned with a new quantity (the new stack size).  Further copies will
						// then be a copy of the stack vs. the individual item.  Yeah that's dumb but what
						// do you do.  The only way around it is to copy one of them to a different target that
						// will remain stack size of 1 during the process and just copy that.
						int iItemCounter = 1;
						object oTempItem = CopyItem(oItem, GetObjectByTag("LEG_LOOT_TEMPSTORAGE"));
						while (iItemCounter < iQty)
						{
							CopyItem(oTempItem, OBJECT_SELF);
							iItemCounter++;						
						}
						
						DestroyObject(oTempItem);
					}					
				}				
			}
			else
			{
				// This section is for loot items that come from a database table.
				int iItemCount = GetLocalInt(oParent, "LEG_LOOT_TableQty_" + sCount);
				string sItemTable = GetLocalString(oParent, "LEG_LOOT_TableCode_" + sCount);
				string sItemDropTag;
				int iTableCount = 0, iRandomCount;
				int iGroupTotal = GetLocalInt(oParent, "LEG_LOOT_TableGroupCount_" + sCount);
				int iItemDropChance, iItemMin, iItemMax, iQty, iItemCounter;
				
				// For each quantity, check its chance and start spawning.				
				for (iItemCounter=1; iItemCounter <= iItemCount; iItemCounter++)
				{
					// Find out what our chances of dropping each on is, the quantity and chances.
					iItemDropChance = GetLocalInt(oParent, "LEG_LOOT_Chance_" + sCount);
					iMinQty = GetLocalInt(oParent, "LEG_LOOT_MinQty_" + sCount);
					iMaxQty = GetLocalInt(oParent, "LEG_LOOT_MaxQty_" + sCount);
					iQty = Random(iMaxQty - iMinQty + 1) + iMinQty;
					
					// Randomly select one of the items from the loot table.
					iRandomCount = Random(iGroupTotal) + 1;
					SQLExecDirect("SELECT * FROM `" + DBLOOTTABLE + "` WHERE `TableID`='" + sItemTable + "'");
					for (iTableCount=1; iTableCount <= iRandomCount; iTableCount++)
					{
						SQLFetch();
					}
					
					// Grab the resref.
					sItemDropTag = SQLGetData(2);				
					
					// Check for chances and spawn.
					if (d100() <= iItemDropChance)
					{
						// Go ahead and drop Mr. Repeatable.
						object oItem = LEG_COMMON_CreateItem(oTarget, sItemDropTag, iQty);
						
						// Should our new item be automagically identified?
						if (GetLocalInt(oParent, "LEG_LOOT_Identified_" + sCount))
							SetIdentified(oItem, TRUE);
						else
							SetIdentified(oItem, FALSE);						
					}
				}			
			}
		}
	}
}