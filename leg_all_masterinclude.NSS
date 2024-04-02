/*
    Script:			Master Include file housing all common functions that may or may not be used by individual modular
					systems.  Each module has its own include file that each script belonging to that module will call.
					Each of those includes will include this Master Include.  Functions created that may have use in other
					modules should be placed here rather than the module include file.
	Version:		3.3
	Plugin Version: 2.00
	Author:			Marshall Vyper
	NOTES:			Sunjammer's placeable object code has been added.  Full credit to him/her for it.  Functions renamed to follow 
					Legends Framework.

	Change Log:		11/26/2010 - MV - Updated to support Legends Master Modular Systems
					12/14/2010 - MV - Added Game Year configuration option for Time based functions.
					12/16/2010 - MV - Added Functions from Quest Plugin (ie; LEG_COMMON_StripBadChars)
					12/20/2010 - 1.04 MV - Updated docs, removed /'s from Random Name Generator, Added ProgBar
					12/21/2010 - 1.05 MV - Added GetItemLevel function, New time functions, New Array functions
					12/22/2010 - 1.06 MV - Added Text Replace function
					07/06/2011 - 1.07 MV - Added Inventory Count function
					09/10/2011 - 1.41 MV - Fixed bug in GetInventoryItemByTag function
					09/18/2011 - 1.42 MV - Added support for new Spawn Plugin functions
					09/12/2012 - 1.43 MV - Changed PCPREFIX table name to auto-include "_" standard
					09/13/2012 - 1.5 MV - Added support to ProgBar from the Info Plugin for Cancel Button
					10/01/2012 - 1.6 MV - Changed Item GetTag functions to GetResRef functions
					10/06/2012 - 1.7 MV - Fixed bug with PCTable function for characters with ' in their names
					10/14/2012 - 1.8 MV - Fixed bug with PCTable to force lower case characters in table name
					10/31/2012 - 1.9 MV - Added new function to remove brace text {xxx} from strings
					11/02/2012 - 2.0 MV - Fixed bug with {xxx} string removal in that it only would remove 1 pair.
					11/11/2012 - 2.1 MV - Added wrapper for Animations, added Progbar custom animation capabilities
					11/14/2012 - 2.2 MV - Added support for Visuals on Progress Bars
					11/18/2012 - 2.3 MV - Added support for determining real mins between two time stamps.
					11/22/2012 - 2.4 MV - Added new Search Array Element function
					12/05/2012 - 2.5 MV - Added several new functions for Direction, Visual Effects and String manipulation
					02/14/2013 - 2.6 MV - Updated Prog Bar to use new visuals system
					08/17/2013 - 2.7 MV - Fixed database bug when players put colors in their names.
					01/06/2014 - 2.8 MV - Added option to ProgBar to set ClearAllActions to be optional.
					05/23/2015 - 2.9 MV - Added support for TChos HD Panels and added timers to Infoboxes
					06/19/2015 - 3.0 MV - Added support for new Skill to Text function.
					08/07/2015 - 3.1 MV - Added Sunjammer's placeable object movement code.  Full credit to his code goes to him.
					08/11/2015 - 3.2 MV - Plugins Version 2.0 - Added code for performing PC Data table consolidation
					08/30/2015 - 3.3 MV - Added overload method for destroy items and return nothing for DelayCommand happiness.
*/

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// USER CONFIGURABLE CONSTANTS
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_all_masterconstants"
#include "x0_i0_position"

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "nwnx_sql"										// nwnx functions

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// FUNCTION DECLARATIONS
// /////////////////////////////////////////////////////////////////////////////////////////////////////

void LEG_COMMON_TimerBar(object oPC, int iDuration, string sTitle, object oTarget = OBJECT_SELF, int iClearActions = 1);

// ///////////////////////////////////////////////////////////////////////////
// Because we support both NWNX and NWN's built in Campaigns DB, we need to 
// make sure we have a function that will cover both SETs and GETs
// string sDBType				- The database type to use, usually a constant
// object oPC					- Player or Object to assign variable to
// string sVarName				- Name of variable
// string sTable				- Table name in nwnx or DB name in nwn2
//	Returns: Int of the database value
int LEG_COMMON_GetPersistentInt(string sDBType, object oPC, string sVarName, string sTable);

// //////////////////////////////////////////////////////////////////////////
// Because we support both NWNX and NWN's built in Campaigns DB, we need to 
// make sure we have a function that will cover both SETs and GETs
// string sDBType				- The database type to use, usually a constant
// object oPC					- Player or Object to assign variable to
// string sVarName				- Name of variable
// int iValue					- Integer value to store in the database
// string sTable				- Table name in nwnx or DB name in nwn2
//	Returns: N/A
void LEG_COMMON_SetPersistentInt(string sDBType, object oPC, string sVarName, int iValue, string sTable);

// //////////////////////////////////////////////////////////////////////////
// The ever handy Name and password generator.  This function creates a
// human readable word that is the passed value length in letters.
// int iPassPhraseLength		- Number of letters to use.
//	Returns: String of the name/password
string LEG_COMMON_GeneratePass(int iPassPhraseLength);

// ///////////////////////////////////////////////////////////////////////////
// Because NWN GetTimeMins doesn't actually give mins but a divisible representation of mins/hour
// We need a special function for determining mins
//	Returns: Int of the actual game minute of the game hour
int LEG_COMMON_GetGameTimeMinute();

// ///////////////////////////////////////////////////////////////////////////
// Get a Timestamp based on the current game time.  Highly used in things like
// respawning systems eliminated the need for DelayCommand and Heartbeat scripts
//	Returns: A time stamp based on current game time
int LEG_COMMON_TimeStamp();

// ///////////////////////////////////////////////////////////////////////////
// Returns REAL Mins left between two Timestamps
// int iStart					- Start time which is further in the past.
// int iEnd						- End time which is more recent.
//	Returns: Mins between two stamps
int LEG_COMMON_MinsLeft(int iStart, int iEnd);

// ///////////////////////////////////////////////////////////////////////////
// Time of Death - we need to know when we died so we can respawn correctly.
// Used in various places to set the time the object died in order for it
// to respawn.  Can be seen in closing script for chests etc. and simply
// sets a variable on the parent spawner.
// object oMob					- Actual mob object.
// object oParent				- Parent spawner, usually a waypoint.
//	Returns: N/A
void LEG_COMMON_TimeOfDeath(object oMob, object oParent);

// ///////////////////////////////////////////////////////////////////////////
// Time of Birth - we need to know when we were born so we can despawn correctly.
// Used in various places to set the time the object was born in order for it
// to despawn.  Used when the DeSpawn mins of the parent spawner is set.
// object oMob					- Actual mob object.
// object oParent				- Parent spawner, usually a waypoint.
//	Returns: N/A
void LEG_COMMON_TimeOfBirth(object oMob, object oParent);

// ///////////////////////////////////////////////////////////////////////////
// Making Items on stuff.  WOOT!  This function takes a passed resref and
// creates it on the passed target in the passed quantity.  If successful
// the last quantity item created is returned.
// object oTarget				- Object to create item in.  PC, Chest, Bag
// string sItem					- Resref of Item to create
// int iQty						- Quantity of items to create
//	Returns: Object of the last item in the quantity stack.
object LEG_COMMON_CreateItem(object oTarget, string sItem, int iQty, object oBag = OBJECT_INVALID, string sDescriptionAdd = "");

// ///////////////////////////////////////////////////////////////////////////
// A handy function for removing the inventory content of the passed target.
// Target could be a chest or bag or NPC.
// object oTarget				- Object's inventory to destroy.  PC, Chest, Bag
//	Returns: N/A
void LEG_COMMON_DestroyInventory(object oTarget);

// ///////////////////////////////////////////////////////////////////////////
// This function is required by several plugins however it comes from the
// standalone Legends InfoBox Plugin.  This is often included in other kits
// such as the quest kit.  It takes a custom message and displays it to
// the PC's screen.
// object oPC					- PC to send the message to.
// string sText					- Message to display
// int iTextMessage				- Flag if the text should be displayed in chat.
//	Returns: N/A
void LEG_COMMON_DisplayInfoBox(object oPC, string sText, int iTextMessage = 1, int iShout = 0, int iBoxType = 0);

// ///////////////////////////////////////////////////////////////////////////
// This function accepts a string variable of 0-23, dawn, dusk, day, night
// midnight, or noon and converts it and returns the integer value of the
// hour the string represented.
// string sTOD					- String value of the time requested.
//	Returns: Integer of the Time Hour the string represents
int LEG_COMMON_StringToHour(string sTOD);

// ////////////////////////////////////////////////////////////////////////////
// Removes nasty characters we dont want in strings
// string sInput				- String we want cleaned.
//   Returns: String of the Cleaned String
string LEG_COMMON_StripBadChars(string sInput);

// ////////////////////////////////////////////////////////////////////////////
// Obtains an inventory object from the target's inventory by using the
// tag of the item.
// object oTarget				- The objects inventory we're looking in.
// string sItem					- Tag of the item we are looking for.
//   Returns: The the first Item Object or OBJECT_INVALID if not found.
object LEG_COMMON_GetInventoryItemByTag(object oTarget, string sItem);


// ////////////////////////////////////////////////////////////////////////////
// Adds up all of the items with the same tag as the passed item in the 
// passed container inventory.                                
// object oContainer			- Container Object with Inventory
// string sMaterial				- Tag of items we want to count
//   Returns: String - The text skill name          
int LEG_COMMON_GetInventoryCount(object oContainer, string sMaterial);


// ////////////////////////////////////////////////////////////////////////////
// Destroys a quantity of items from the targets inventory by the Item Tag
// If the quantity is -1, it will delete all of them.
// NOTE: I don't yet know the behavior on stacked items yet when deleting
// only a part of the stack.  I should test this at some point.
// object oTarget				- The objects inventory we're looking in.
// string sItem					- Tag of the item we are looking for.
// int nNumItems			    - The quantity we want to destroy, -1 = ALL
//   Returns: The NAME of the item destroyed.
string LEG_COMMON_DestroyItems(object oTarget,string sItem,int nNumItems = -1);

// ////////////////////////////////////////////////////////////////////////////
// Destroys a quantity of items from the targets inventory by the Item Tag
// If the quantity is -1, it will delete all of them.  Created this specifically
// for the purpose of needing a second overload that returned nothing for
// delay commands
// NOTE: I don't yet know the behavior on stacked items yet when deleting
// only a part of the stack.  I should test this at some point.
// object oTarget				- The objects inventory we're looking in.
// string sItem					- Tag of the item we are looking for.
// int nNumItems			    - The quantity we want to destroy, -1 = ALL
//   Returns: Nothing
void LEG_COMMON_DestroyItemsByTag(object oTarget,string sItem,int nNumItems = -1);

// ////////////////////////////////////////////////////////////////////////////
// Get's the defacto standard Player table for all player data from all legends
// plugins.  This is new as of v2.0 where we consolidated player data into a 
// single table per player system.
// object oPC					- Player that we are getting a table name for
//   Returns: The completed table name for a particular player of a certain type
string LEG_COMMON_GetPC2Table(object oPC);

// ////////////////////////////////////////////////////////////////////////////
// Get's the defacto standard Player table from v1 of whatever type we're looking
// for.  For example, the quest plugin will use several of these tables such
// as quests and objects.  Even the INFO plugin will grab from this.
// object oPC					- Player that we are getting a table name for
// string sTableType			- Suffix of the table that appears before the
//							      PC ID.
//   Returns: The completed table name for a particular player of a certain type
string LEG_COMMON_GetPCTable(object oPC, string sTableType, int iNoQuotes = FALSE);

// ////////////////////////////////////////////////////////////////////////////
// Figures out if the current time is within two time windows based on various
// words such as noon, night, day, dusk or actual hour of the day.
// string sStartTOD				- The Starting Hour for the window
// string sEndTOD				- The Ending Hour for the window
//   Returns: TRUE if the current time falls in between these two times.
int LEG_COMMON_CheckTOD(string sStartTOD, string sStopTOD);

// ////////////////////////////////////////////////////////////////////////////
// Fires a progress bar GUI on the screen for a player using the passed
// parameters.
// object oPC					- The player's screen we want to display on
// int iDuration				- How long (secs) it takes the progress bar to finish
// string sTitle				- Text to display in the progress bar
// int iVisualEffect			- Visual to apply to the player during the bar
// int iAnimation				- Animation to have the player do during the bar
// int iCommandable				- If the PC can move or act during the progress bar
//   Returns: TRUE if the current time falls in between these two times.
void LEG_COMMON_ProgBar(object oPC, int iDuration, string sTitle, int iVisualEffect = 0, int iAnimation = 0, int iCommandable = 0, int iCancel = 0, string sAnimation1 = "kneeltalk", int iAnimationLoop1 = 1, int iDuration1 = 5, string sAnimation2 = "", int iAnimationLoop2 = 0, int iDuration2 = 0, object oTarget = OBJECT_SELF, int iClearActions = 1);

// ////////////////////////////////////////////////////////////////////////////
// Uses Item value in gold to determine the item level as specified by the ILR.
// object oItem					- The Item we want to evaluate
//   Returns: Integer value in levels
int LEG_COMMON_GetItemLevel(object oItem);

// ////////////////////////////////////////////////////////////////////////////
// Converts an integer of hour from 0-23 and min from 0-59 and returns
// a string in the format of "HH:MM AM|PM" in 12 hour format.
// int iHour					- The hour we want to convert
// int iMin						- The minute we want to convert
//   Returns: String Value 12 hour time in format "HH:MM AM|PM"
string LEG_COMMON_GetTimeNon24(int iHour, int iMin);

// ////////////////////////////////////////////////////////////////////////////
// Converts an integer from 1-12 and returns the month in Wordy format
// int iMonth					- The month number we want to convert
//   Returns: String Value of the Month as a whole word
string LEG_COMMON_GetMonthName(int iMonth);

// ////////////////////////////////////////////////////////////////////////////
// Adds a string value to a named array stored on the passed object.  If the
// array doesn't exist, it is created.  Each consecutive call of this 
// function will add a new element at the end of the array.
// object oObject				- The object we are storing the array on
// string sArrayName			- The Name of the Array
// string sValue				- The value of the element we are storing
void LEG_COMMON_AddArrayElement(object oObject, string sArrayName, string sValue);

// ////////////////////////////////////////////////////////////////////////////
// Deletes an array element at a specific index position.  Once the array
// element is deleted, the array is compressed.  As a result, the indexes
// will get re-numbered and the array pointer set to position 1.
// object oObject				- The object we are storing the array on
// string sArrayName			- The Name of the Array
// int iIndex					- The element index that we want to delete
//   Returns: N/A
void LEG_COMMON_DeleteArrayElement(object oObject, string sArrayName, int iIndex);

// ////////////////////////////////////////////////////////////////////////////
// Deletes an array element at current index pointer position.  Once the array
// element is deleted, the array is compressed.  As a result, the indexes
// will get re-numbered and the array pointer set to position 1.
// object oObject				- The object we are storing the array on
// string sArrayName			- The Name of the Array
//   Returns: N/A
void LEG_COMMON_DeleteCurrentArrayElement(object oObject, string sArrayName);

// ////////////////////////////////////////////////////////////////////////////
// Gets the value of the named array stored on the named object at index
// position 1.  If the array is empty or does not exist, returns "#EOA#"
// object oObject				- The object we are storing the array on
// string sArrayName			- The Name of the Array
//   Returns: string value of the stored element at position 1 or "#EOA#"
string LEG_COMMON_GetFirstArrayElement(object oObject, string sArrayName);

// ////////////////////////////////////////////////////////////////////////////
// Gets the value of the named array stored on the named object at the current
// index position +1.  If the array is empty or does not exist, returns "#EOA#"
// The new index position will be the old position +1
// object oObject				- The object we are storing the array on
// string sArrayName			- The Name of the Array
//   Returns: string value of the stored element at position +11 or "#EOA#"
string LEG_COMMON_GetNextArrayElement(object oObject, string sArrayName);

// ////////////////////////////////////////////////////////////////////////////
// Gets the value of the named array stored on the named object at the passed
// index position.  If the array is empty or does not exist, or the
// position is higher than the size of the array, returns "#OUTOFBOUNDS#"
// The index pointer is changed to the position passed
// object oObject				- The object we are storing the array on
// string sArrayName			- The Name of the Array
// int iIndex					- The element stored at this index
//   Returns: string value of the stored element at index or "#OUTOFBOUNDS#"
string LEG_COMMON_GetArrayElement(object oObject, string sArrayName, int iIndex);

// ////////////////////////////////////////////////////////////////////////////
// Sets the value of the named array stored on the named object at the passed
// index position.  The array must exist and the Index must already be
// initialized.
// The index pointer is changed to the position passed
// object oObject				- The object we are storing the array on
// string sArrayName			- The Name of the Array
// int iIndex					- The element stored at this index
//   Returns: string value of the stored element at index or "#OUTOFBOUNDS#"
void LEG_COMMON_SetArrayElement(object oObject, string sArrayName, int iIndex, string sValue);

// ////////////////////////////////////////////////////////////////////////////
// Changes the current index pointer position to position 1 at the start
// of the array.
// object oObject				- The object we are storing the array on
// string sArrayName			- The Name of the Array
//   Returns: N/A
void LEG_COMMON_ResetArrayIndex(object oObject, string sArrayName);

// ////////////////////////////////////////////////////////////////////////////
// Gets the current pointer position in the array and returns it as an int.
// object oObject				- The object we are storing the array on
// string sArrayName			- The Name of the Array
//   Returns: integer value of the current index pointer position
int LEG_COMMON_GetCurrentArrayIndex(object oObject, string sArrayName);

// ////////////////////////////////////////////////////////////////////////////
// Gets the total number of elements in the passed array.
// object oObject				- The object we are storing the array on
// string sArrayName			- The Name of the Array
//   Returns: integer value of the total number of elements in an array
int LEG_COMMON_GetArrayElementCount(object oObject, string sArrayName);

// ////////////////////////////////////////////////////////////////////////////
// Parses an array and removes all entries that have an element value of
// "LEG_DELETED_ARRAY_ELEMENT".  All elements are re-indexed when this is
// performed and total element count updated.  Position is moved to index
// 1.  
// object oObject				- The object we are storing the array on
// string sArrayName			- The Name of the Array
//   Returns: N/A
void LEG_COMMON_CompressArray(object oObject, string sArrayName);

// ////////////////////////////////////////////////////////////////////////////
// Changes the name of a stored array on an object from the passed current
// name to the new name.  The original named array is deleted.  All elements
// are preserved and moved to the new name.
// object oObject				- The object we are storing the array on
// string sOldName				- The Name of the Array you want to rename
// string sNewName			    - The Name of the resulting array.
//   Returns: N/A
void LEG_COMMON_RenameArray(object oObject, string sOldName, string sNewName);

// ////////////////////////////////////////////////////////////////////////////
// Destroys a named array and removes all elements.
// object oObject				- The object we are storing the array on
// string sArrayName			- The Name of the Array
//   Returns: N/A
void LEG_COMMON_ClearArray(object oObject, string sArrayName);

// ////////////////////////////////////////////////////////////////////////////
// Takes a string and substitutes all occurences of a character with a
// different character and returns the updated string.
// string sText					- The string that we are examining
// string sOld					- The character we want to replace
// string sNew					- The new character we want to use instead
//   Returns: string value of the updated text.
string LEG_COMMON_TextReplace(string sText, string sOld, string sNew);

// ////////////////////////////////////////////////////////////////////////////
// Takes a string and removes any braces and text in between them.  If the
// ClearWhiteSpace integers are true, then any single white space to the left of
// the opening brace is remove and any single white space to the right of the 
// closing brace is removed.
// string sText					- The string that we are examining
// int iClearWhiteSpaceLeft		- Remove a space on the left side of the opening brace
// int iClearWhiteSpaceRight	- Remove a space on the right side of the closing brace
//   Returns: string value of the updated text.
string LEG_COMMON_TextRemoveBrace(string sText, int iClearWhiteSpaceLeft, int iClearWhiteSpaceRight);


// ////////////////////////////////////////////////////////////////////////////
// Simple wrapper for Play Animations.  They work more reliably when you 
// do this from what I read.
// object oNPC					- Character doing the animation
// string sAnimationName		- The actual animation
// int nLooping					- Whether or not to loop the animation
// float fSpeed					- Speed to run animation at
// float fDuration				- How long to run the animation loop
//   Returns: Nothing
void LEG_COMMON_ActionPlayCustomAnimation(object oNPC, string sAnimationName, int nLooping, float fDuration = 0.0, float fSpeed = 1.0f);


// ////////////////////////////////////////////////////////////////////////////
// Provides the ability to search an array for a particular value and returns
// the index value of the location in the array.
// object oObject				- The object the array is stored on.
// string sArrayName			- The name of the array
// string sValue				- The value of the element we are searching for
//   Returns: Int - The index location of the searched value
int LEG_COMMON_SearchArrayElement(object oObject, string sArrayName, string sValue);


// ////////////////////////////////////////////////////////////////////////////
// Searches an inventory for an item based on ResRef template value and
// returns the item.
// object oTarget				- The object's inventory to check
// string sItem					- The ResRef template to search for
//   Returns: object - The item if found.
object LEG_COMMON_GetInventoryItemByResRef(object oTarget, string sItem);



// ////////////////////////////////////////////////////////////////////////////
// Performs a visual effect based on the passed effect ID.  NOTE that the
// standard visual effects list AS WELL AS the custom sef list are available
// here.  NOTE: The Legends QUEST plugin must be installed to get access to 
// the SEFs.
// int iEffect					- The effect ID.  0-1048 = VFX, 1049-2079 SEF's
// object oTarget				- The object to place the visual effect on
// object oSource				- For BEAM type effects, a source object is required.
// float fDuration				- For Non-Perm and Non-FNF type effects, this is the duration.
//   Returns: nothing
void LEG_COMMON_VisualEffect(int iEffect, object oTarget, object oSource, float fDuration = 0.0);


// ////////////////////////////////////////////////////////////////////////////
// Standard Enhanced Execute of script.  This is here for times when the
// Enhanced Script execution is needed to be performed with a delay.
// string sScript				- Name of Script to execute
// object oObj1					- Optional object #1 to pass to the script
// object oObj2					- Optional object #2 to pass to the script
// string sStr1					- Optional string #1 to pass to the script
// string sStr2					- Optional string #2 to pass to the script
// int iInt1					- Optional integer #1 to pass to the script
// int iInt2					- Optional integer #2 to pass to the script
// float fFloat1				- Optional float #1 to pass to the script
// float fFloat2				- Optional float #2 to pass to the script
//   Returns: nothing
void LEG_COMMON_ExecuteScript(string sScript, object oTarget, object oObj1 = OBJECT_INVALID, object oObj2 = OBJECT_INVALID, string sStr1 = "", string sStr2 = "", int iInt1 = 0, int iInt2 = 0, float fFloat1 = 0.0, float fFloat2 = 0.0);


// ////////////////////////////////////////////////////////////////////////////
// Function to accept a skill integer and convert it to its text name
// equivilent.
// int iSkill					- Skill ID to convert
//   Returns: string			- Name of skill
string LEG_COMMON_SkillToText(int iSkill);



// ////////////////////////////////////////////////////////////////////////////
// Helper function to create an array of objects between the original object and the destination.
//  - oOriginal:        the original placeable
//  - nCount:           the number of tweening objects
//  - vDestination:     destination position
void LEG_COMMON_CreateTweeningObjects(object oOriginal, int nCount, vector vDestination, float fFacing = -1.0);

// ////////////////////////////////////////////////////////////////////////////
// Helper function to destroy the original object and all but the last of the array of objects between
// the original object and the destination.
//  - oOriginal:        the original placeable
//  - nCount:           the number of tweening objects
//  * Returns:          noteR
//  * OnError:          noteE
void LEG_COMMON_DestroyTweeningObjects(object oOriginal, int nCount);

// ////////////////////////////////////////////////////////////////////////////
// Makes a placeable appear to move by creating a series of invisible clones between its location
// and the destination location and then temporarily revealing in sequence.
//  - oPlaceable:       the original placeable
//  - lDestination:     location of the destination
//  - nSteps:           the number of steps in the move (affects performance and smoothness)
//  - fDelay:           the delay (normally 0.5 seconds) to allow for object creation
//  - fDuration:        the duration of the move (affects performance and smoothness) 
//  - oSound:           a sound object to be played during the move
void LEG_COMMON_MovePlaceableToLocation(object oPlaceable, location lDestination, int nSteps, float fDelay, float fDuration, object oSound=OBJECT_INVALID, float fFacing = -1.0);

// ////////////////////////////////////////////////////////////////////////////
// Makes a placeable appear to move by creating a series of invisible clones between its location
// and the destination object and then temporarily revealing in sequence.
//  - oPlaceable:       the original placeable
//  - oDestination:     an object (normally a waypoint) indicating the destination
//  - nSteps:           the number of steps in the move (affects performance and smoothness)
//  - fDelay:           the delay (normally 0.5 seconds) to allow for object creation
//  - fDuration:        the duration of the move (affects performance and smoothness) 
//  - oSound:           a sound object to be played during the move
void LEG_COMMON_MovePlaceableToObject(object oPlaceable, object oDestination, int nSteps, float fDelay, float fDuration, object oSound=OBJECT_INVALID);

// ////////////////////////////////////////////////////////////////////////////
// Removes all Cutscene Invisibility visual effects from an object.
//  - oObject:          object with CSI visual effect
void LEG_COMMON_RemoveCutsceneInvisibility(object oObject);

// ////////////////////////////////////////////////////////////////////////////
// Helper function to reveal each tweening objects in sequence to give the illusion of movement.
// original object is in fact moving.
//  - oOriginal:        the original placeable
//  - nCount:           the number of tweening objects
//  - fDuration:        the duration of the tween, i.e. the "move"
void LEG_COMMON_RevealTweeningObjects(object oOriginal, int nCount, float fDuration);


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// FUNCTIONS
// /////////////////////////////////////////////////////////////////////////////////////////////////////


// //////////////////////////////////////////////////
// LEG_COMMON_GetPersistentLocation - Triston
// //////////////////////////////////////////////////
location LEG_COMMON_GetPersistentLocation(string sDBType, object oPC, string sVarName, string sTable)
{
	if (sDBType == "nwn2")
	{
		if (!GetIsPC(oPC))
			oPC = OBJECT_INVALID;
		return GetCampaignLocation(sTable, sVarName, oPC);
	}
	else
		return GetPersistentLocation(oPC, sVarName, sTable);

}
// //////////////////////////////////////////////////
// LEG_COMMON_GetPersistentString - Triston
// //////////////////////////////////////////////////
string LEG_COMMON_GetPersistentString(string sDBType, object oPC, string sVarName, string sTable)
{
	if (sDBType == "nwn2")
	{
		if (!GetIsPC(oPC))
			oPC = OBJECT_INVALID;
		return GetCampaignString(sTable, sVarName, oPC);
	}
	else
		return GetPersistentString(oPC, sVarName, sTable);

}

// //////////////////////////////////////////////////
// LEG_COMMON_GetPersistentInt
// //////////////////////////////////////////////////
int LEG_COMMON_GetPersistentInt(string sDBType, object oPC, string sVarName, string sTable)
{
	if (sDBType == "nwn2")
	{
		if (!GetIsPC(oPC))
			oPC = OBJECT_INVALID;
		return GetCampaignInt(sTable, sVarName, oPC);
	}
	else
		return GetPersistentInt(oPC, sVarName, sTable);

}

// //////////////////////////////////////////////////
// LEG_COMMON_SetPersistentLocation - Triston
// //////////////////////////////////////////////////
void LEG_COMMON_SetPersistentLocation(string sDBType, object oPC, string sVarName, location iValue, string sTable)
{
	// Note, setting variables on objects is limited in the NWN database so we must be mindful of it.
	if (sDBType == "nwn2")
	{
		if (!GetIsPC(oPC))
			oPC = OBJECT_INVALID;
		SetCampaignLocation(sTable, sVarName, iValue, oPC);
	}
	else
		SetPersistentLocation(oPC, sVarName, iValue, 0, sTable);
}
// //////////////////////////////////////////////////
// LEG_COMMON_SetPersistentString - Triston
// //////////////////////////////////////////////////
void LEG_COMMON_SetPersistentString(string sDBType, object oPC, string sVarName, string sValue, string sTable)
{
	// Note, setting variables on objects is limited in the NWN database so we must be mindful of it.
	if (sDBType == "nwn2")
	{
		if (!GetIsPC(oPC))
			oPC = OBJECT_INVALID;
		SetCampaignString(sTable, sVarName, sValue, oPC);
	}
	else
		SetPersistentString(oPC, sVarName, sValue, 0, sTable);
}
// //////////////////////////////////////////////////
// LEG_COMMON_SetPersistentInt
// //////////////////////////////////////////////////
void LEG_COMMON_SetPersistentInt(string sDBType, object oPC, string sVarName, int iValue, string sTable)
{
	// Note, setting variables on objects is limited in the NWN database so we must be mindful of it.
	if (sDBType == "nwn2")
	{
		if (!GetIsPC(oPC))
			oPC = OBJECT_INVALID;
		SetCampaignInt(sTable, sVarName, iValue, oPC);
	}
	else
		SetPersistentInt(oPC, sVarName, iValue, 0, sTable);
}



// //////////////////////////////////////////////////
// LEG_COMMON_GeneratePass
// //////////////////////////////////////////////////
string LEG_COMMON_GeneratePass(int iPassPhraseLength)
{
    // Make random letters for alphabet
    SetLocalString(GetModule(), "sAlphabet1", "a");
    SetLocalString(GetModule(), "sAlphabet2", "b");
    SetLocalString(GetModule(), "sAlphabet3", "c");
    SetLocalString(GetModule(), "sAlphabet4", "d");
    SetLocalString(GetModule(), "sAlphabet5", "e");
    SetLocalString(GetModule(), "sAlphabet6", "f");
    SetLocalString(GetModule(), "sAlphabet7", "g");
    SetLocalString(GetModule(), "sAlphabet8", "h");
    SetLocalString(GetModule(), "sAlphabet9", "i");
    SetLocalString(GetModule(), "sAlphabet10", "j");
    SetLocalString(GetModule(), "sAlphabet11", "k");
    SetLocalString(GetModule(), "sAlphabet12", "l");
    SetLocalString(GetModule(), "sAlphabet13", "m");
    SetLocalString(GetModule(), "sAlphabet14", "n");
    SetLocalString(GetModule(), "sAlphabet15", "o");
    SetLocalString(GetModule(), "sAlphabet16", "p");
    SetLocalString(GetModule(), "sAlphabet17", "q");
    SetLocalString(GetModule(), "sAlphabet18", "r");
    SetLocalString(GetModule(), "sAlphabet19", "s");
    SetLocalString(GetModule(), "sAlphabet20", "t");
    SetLocalString(GetModule(), "sAlphabet21", "u");
    SetLocalString(GetModule(), "sAlphabet22", "v");
    SetLocalString(GetModule(), "sAlphabet23", "w");
    SetLocalString(GetModule(), "sAlphabet24", "x");
    SetLocalString(GetModule(), "sAlphabet25", "y");
    SetLocalString(GetModule(), "sAlphabet26", "z");

    string sPassPhrase; // passphrase (password?)
    string sRanLetter; // random letter generated
    string sLetter; // letter to add to passphrase
    string sExistingLetter; // Pronounceable word test

    if (iPassPhraseLength == 0)
    {
        sPassPhrase = "";
        return sPassPhrase;
    }

    while (iPassPhraseLength != 0)
    {
        sRanLetter = IntToString(Random(26)+1);
        sLetter = GetLocalString(GetModule(), "sAlphabet" + sRanLetter);
        sExistingLetter = GetStringRight(sPassPhrase, 1);
        // As long as the first letter is not blank, and we don't have two consonants side by side..
        // it's ok, otherwise, re-iterate until we get a vowel

        while ( (sExistingLetter != "") && 
        (sExistingLetter == "b" || 
        sExistingLetter == "c" || 
        sExistingLetter == "d" || 
        sExistingLetter == "f" || 
        sExistingLetter == "g" || 
        sExistingLetter == "h" || 
        sExistingLetter == "j" || 
        sExistingLetter == "k" || 
        sExistingLetter == "l" || 
        sExistingLetter == "m" || 
        sExistingLetter == "n" || 
        sExistingLetter == "p" || 
        sExistingLetter == "q" || 
        sExistingLetter == "r" || 
        sExistingLetter == "s" || 
        sExistingLetter == "t" || 
        sExistingLetter == "v" || 
        sExistingLetter == "w" || 
        sExistingLetter == "x" || 
        sExistingLetter == "z") && 
        (sLetter == "b" || 
        sLetter == "c" || 
        sLetter == "d" || 
        sLetter == "f" || 
        sLetter == "g" || 
        sLetter == "h" || 
        sLetter == "j" || 
        sLetter == "k" || 
        sLetter == "l" || 
        sLetter == "m" || 
        sLetter == "n" || 
        sLetter == "p" || 
        sLetter == "q" || 
        sLetter == "r" || 
        sLetter == "s" || 
        sLetter == "t" || 
        sLetter == "v" || 
        sLetter == "w" || 
        sLetter == "x" || 
        sLetter == "z") 
        )
            {
            sRanLetter = IntToString(Random(26)+1);
            sLetter = GetLocalString(GetModule(), "sAlphabet"+sRanLetter);
            }

        sPassPhrase = sPassPhrase+sLetter;
        iPassPhraseLength--;
        }

    return sPassPhrase;
}



// //////////////////////////////////////////////////
// LEG_COMMON_GetGameTimeMinute
// //////////////////////////////////////////////////
int LEG_COMMON_GetGameTimeMinute()
{
  int MIN_GHR = GAME_MINUTES;    // The modules time rate of minutes per game hour
  int NUM_INT = 60;   // Minint = number of intervals of time per hour - marks per hour
  int nGHour = GetTimeHour();
  int nRMinute = GetTimeMinute();
  int nRSeconds = GetTimeSecond();
  int nRMSec=GetTimeMillisecond();
  int lMinint  = ( MIN_GHR * 60 / NUM_INT);
                  // lMinint = number of seconds per interval per hour
  int nFM;                          //False Minute we'll build.
  nFM = ( ( (60 * nRMinute) + nRSeconds ) / lMinint ) * ( 60 / NUM_INT );
  return nFM;
}



// //////////////////////////////////////////////////
// LEG_COMMON_TimeStamp
// //////////////////////////////////////////////////
int LEG_COMMON_TimeStamp()
{
    // This function will convert the 3 following times to minutes.  We use the Start Game Year so our timestamp
    // is actually representative of the actual in game time.
    int iYear = GetCalendarYear();
    int iMonth = GetCalendarMonth();
    int iDay = GetCalendarDay();
    int iHour = GetTimeHour();
    int iMin = LEG_COMMON_GetGameTimeMinute();

    int iYearMins = (iYear - GAME_START_YEAR) * 518400;
    int iMonthMins = iMonth * 43200;
    int iDayMins = iDay * 1440;         // Days to Mins.
    int iHourMins  = iHour * 60;        // House to Mins.

    int iTimeStamp = iYearMins + iMonthMins + iDayMins + iHourMins + iMin;
    return iTimeStamp;

}


// //////////////////////////////////////////////////
// LEG_COMMON_SpecificTimeStamp
// //////////////////////////////////////////////////
int LEG_COMMON_SpecificTimeStamp(int iYear, int iMonth, int iDay, int iHour, int iMin = 0)
{
    int iYearMins = (iYear - GAME_START_YEAR) * 518400;
    int iMonthMins = iMonth * 43200;
    int iDayMins = iDay * 1440;         // Days to Mins.
    int iHourMins  = iHour * 60;        // House to Mins.

    int iTimeStamp = iYearMins + iMonthMins + iDayMins + iHourMins + iMin;
    return iTimeStamp;
}


// //////////////////////////////////////////////////
// LEG_COMMON_RealMinsLeft
// //////////////////////////////////////////////////
int LEG_COMMON_MinsLeft(int iStart, int iEnd)
{
	int iTimeLeft = FloatToInt(((IntToFloat(iEnd - iStart)) / 60.0) * IntToFloat(GAME_MINUTES));
	return iTimeLeft;
}

// //////////////////////////////////////////////////
// LEG_COMMON_TimeOfDeath
// //////////////////////////////////////////////////
void LEG_COMMON_TimeOfDeath(object oMob, object oParent)
{
	int iTimeOfDeath = LEG_COMMON_TimeStamp();
	string sParentID = GetLocalString(oMob, "SPAWN_ParentID");
	string sIndex = GetLocalString(oMob, "SPAWN_Index");
	string sCountType = GetLocalString(oParent, "LEG_SPAWN_Count");
	if (sCountType == "Full")
		LEG_COMMON_SetArrayElement(oParent, sParentID + "TOD", StringToInt(sIndex), IntToString(iTimeOfDeath));
	else
		SetLocalInt(oParent, "SPAWN_TOD_" + sIndex, iTimeOfDeath);
		
	// When a mob of a spawn point dies or is despawned, we will change the spawn point for groups to ensure
	// the next time around, we spawn somewhere else.  This only occurs when MOB #1 dies of each WP.  If we
	// kill off every mob except #1, they will continue to spawn at the one chosen point until #1 either
	// despawns or is killed off, at which point, this is reset to a new waypoint.
	if (sIndex == "1")
		SetLocalObject(oParent, "SPAWN_NextSpawnLocation", OBJECT_INVALID);		

}


// //////////////////////////////////////////////////
// LEG_COMMON_TimeOfBirth
// //////////////////////////////////////////////////
void LEG_COMMON_TimeOfBirth(object oMob, object oParent)
{
	int iTimeOfBirth = LEG_COMMON_TimeStamp();
	string sParentID = GetLocalString(oMob, "SPAWN_ParentID");
	string sIndex = GetLocalString(oMob, "SPAWN_Index");
	string sCountType = GetLocalString(oParent, "LEG_SPAWN_Count");
	if (sCountType == "Full")
		LEG_COMMON_SetArrayElement(oParent, sParentID + "TOB", StringToInt(sIndex), IntToString(iTimeOfBirth));
	else
		SetLocalInt(oParent, "SPAWN_TOB_" + sIndex, iTimeOfBirth);
}


// //////////////////////////////////////////////////
// LEG_COMMON_CreateItem
// //////////////////////////////////////////////////
object LEG_COMMON_CreateItem(object oTarget, string sItem, int iQty, object oBag = OBJECT_INVALID, string sDescriptionAdd = "")
{
	// Sometimes stackable stuff won't stack right when there is pre-existing items
	// so we do this the hard way.  Bleh
	object oItem;
	int iCount;
	
	// If we're supposed to put this stuff in a bag, then lets do that.
	if (GetIsObjectValid(oBag))
		oTarget = oBag;
	
	// Populate!
	for (iCount=1; iCount <= iQty; iCount++)
	{
		oItem = CreateItemOnObject(sItem, oTarget, 1);
	}

	if (GetIsObjectValid(oItem) && sDescriptionAdd != "")
	{
		string sDesc = GetDescription(oItem);
		sDesc = sDescriptionAdd + "\n" + sDesc;
		SetDescription(oItem, sDesc);
	}
	
	return oItem;
}


// //////////////////////////////////////////////////
// LEG_COMMON_DestroyInventory
// //////////////////////////////////////////////////
void LEG_COMMON_DestroyInventory(object oTarget)
{
	// Let's grab the first object in the inventory.
	object oItem = GetFirstItemInInventory(oTarget);
	
	// And send it to the afterlife.
	while (GetIsObjectValid(oItem))
	{
		SetPlotFlag(oItem,FALSE);
		AssignCommand(oItem, SetIsDestroyable(TRUE, FALSE, FALSE));
		DestroyObject(oItem);
		oItem = GetNextItemInInventory(oTarget);
	}
}


// //////////////////////////////////////////////////
// LEG_COMMON_DisplayInfoBox
// //////////////////////////////////////////////////
void LEG_COMMON_DisplayInfoBox(object oPC, string sText, int iTextMessage = 1, int iShout = 0, int iBoxType = 0)
{
	// Display the GUI screen message.
	string sBoxType, sBox;
	switch (iBoxType)
	{
		case 0:	sBoxType = "leg_info_infobox"; break;
		case 1:	sBoxType = "leg_info_infoboxalert"; sText = "<color=red>" + sText + "</color>"; break;
		case 2:	sBoxType = "leg_info_infoboxdetail"; break;	
	}
	DisplayGuiScreen(oPC, sBoxType, FALSE, sBoxType + ".xml");
	SetGUIObjectText(oPC, sBoxType, "info", -1, sText);
	
	// If we're supposed to also send the text to the PC's chat box.
	if (iTextMessage)
		SendMessageToPC(oPC, sText);
	else if (iShout)
		AssignCommand(oPC, SpeakString(sText, TALKVOLUME_SHOUT));
}



// //////////////////////////////////////////////////
// LEG_COMMON_StringToHour
// //////////////////////////////////////////////////
int LEG_COMMON_StringToHour(string sTOD)
{
	// Take various inputs and does its best to convert them to integer hours.
	if (sTOD == "dusk")
		return TIME_HOUR_DUSK;
	else if (sTOD == "dawn")
		return TIME_HOUR_DAWN;
	else if (sTOD == "day")
		return TIME_HOUR_DAWN + 1;
	else if (sTOD == "night")
		return TIME_HOUR_DUSK + 1;
	else if (sTOD == "noon")
		return 12;
	else if (sTOD == "midnight")
		return 0;
	else
		return StringToInt(sTOD);
}


// //////////////////////////////////////////////////
// LEG_COMMON_StringToHour
// //////////////////////////////////////////////////
string LEG_COMMON_StripBadChars(string sInput)
{
	// Do some setup like getting the length of the string.
	string sOutput, sTemp;
	int iCounter;
	int iLen = GetStringLength(sInput);
	
	// Parse the string characters
	while (iCounter <= iLen)
	{
		// Store each character temporarily from the String to analyze.
		sTemp = GetSubString(sInput, iCounter, 1);
		
		// Remove spaces, commas, periods, apostrophe's, left apostrophe's and carets
		if (sTemp != " " && sTemp != "," && sTemp != "." && sTemp != "'" && sTemp != "`" && sTemp != "~")
		{
			sOutput = sOutput + sTemp;
		}
		iCounter++;
	}
	
	// All done, returned cleaned string.
	return sOutput;
}



// //////////////////////////////////////////////////
// LEG_COMMON_GetInventoryItemByTag
// //////////////////////////////////////////////////
object LEG_COMMON_GetInventoryItemByTag(object oTarget, string sItem)
{
	// Setup to loop through the target's inventory.  I have no idea if this will seek into
	// bags or not, but if it doesn't, I'm sure it'll crop up as a bug somewhere and 
	// we'll deal with it then.
    int nCount = 0;
	string sName;
    object oItem = GetFirstItemInInventory(oTarget);
	int nNumItems = 700;
	
	// Keep the count down to 500 items for sanity reasons.
    while (GetIsObjectValid(oItem) == TRUE && nCount < nNumItems)
    {
        if (GetTag(oItem) == sItem)
			return oItem;
        nCount++;
        oItem = GetNextItemInInventory(oTarget);
    }

	// If we didn't find the item then we'll return invalid.
	return OBJECT_INVALID;
}


// //////////////////////////////////////////////////
// LEG_COMMON_GetInventoryItemByTag
// //////////////////////////////////////////////////
object LEG_COMMON_GetInventoryItemByResRef(object oTarget, string sItem)
{
	// Setup to loop through the target's inventory.  I have no idea if this will seek into
	// bags or not, but if it doesn't, I'm sure it'll crop up as a bug somewhere and 
	// we'll deal with it then.
    int nCount = 0;
	string sName;
    object oItem = GetFirstItemInInventory(oTarget);
	int nNumItems = 500;
	
	// Keep the count down to 500 items for sanity reasons.
    while (GetIsObjectValid(oItem) == TRUE && nCount < nNumItems)
    {
        if (GetResRef(oItem) == sItem)
			return oItem;
        nCount++;
        oItem = GetNextItemInInventory(oTarget);
    }

	// If we didn't find the item then we'll return invalid.
	return OBJECT_INVALID;
}


// //////////////////////////////////////////////////
// LEG_COMMON_GetInventoryCount
// //////////////////////////////////////////////////
int LEG_COMMON_GetInventoryCount(object oContainer, string sMaterial)
{
    int iTotal = 0;
    object oItem = GetFirstItemInInventory(oContainer);
    while (GetIsObjectValid(oItem))
    {
        if (GetResRef(oItem) == sMaterial)
        {
            iTotal = iTotal + GetNumStackedItems(oItem);
        }

        oItem = GetNextItemInInventory(oContainer);
    }
    return iTotal;
}


// //////////////////////////////////////////////////
// LEG_COMMON_DestroyItems
// //////////////////////////////////////////////////
string LEG_COMMON_DestroyItems(object oTarget, string sItem, int nNumItems = -1)
{
	// Destroy all of them if told to do so.
	if (nNumItems == -1)
	{
		nNumItems = LEG_COMMON_GetInventoryCount(oTarget, sItem);
	}

	// Set up some variables and get the first inventory item.
    int nCount = 0;
	string sName;
    object oItem = GetFirstItemInInventory(oTarget);

	// Go through inventory and zap items.
    while (GetIsObjectValid(oItem) == TRUE && nCount < nNumItems)
    {
		sName = GetName(oItem);
        if (GetResRef(oItem) == sItem)
        {
            int nRemainingToDestroy = nNumItems - nCount;
			int nStackSize = GetItemStackSize(oItem);
			
			if(nStackSize <= nRemainingToDestroy)
			{
				DestroyObject(oItem,0.1f);
				nCount += nStackSize;
			}
            else
			{
				int nNewStackSize = nStackSize - nRemainingToDestroy;
				SetItemStackSize(oItem, nNewStackSize);
				break;
			}
        }
        oItem = GetNextItemInInventory(oTarget);
    }
	
	// Return the Name of the Item we have destroyed from inventory.  Can be handy.
	return sName;
}


// //////////////////////////////////////////////////
// LEG_COMMON_DestroyItemsByTag
// //////////////////////////////////////////////////
void LEG_COMMON_DestroyItemsByTag(object oTarget, string sItem, int nNumItems = -1)
{
	// Destroy all of them if told to do so.
	if (nNumItems == -1)
	{
		nNumItems = LEG_COMMON_GetInventoryCount(oTarget, sItem);
	}

	// Set up some variables and get the first inventory item.
    int nCount = 0;
	string sName;
    object oItem = GetFirstItemInInventory(oTarget);

	// Go through inventory and zap items.
    while (GetIsObjectValid(oItem) == TRUE && nCount < nNumItems)
    {
		sName = GetName(oItem);
        if (GetTag(oItem) == sItem)
        {
            int nRemainingToDestroy = nNumItems - nCount;
			int nStackSize = GetItemStackSize(oItem);
			
			if(nStackSize <= nRemainingToDestroy)
			{
				DestroyObject(oItem,0.1f);
				nCount += nStackSize;
			}
            else
			{
				int nNewStackSize = nStackSize - nRemainingToDestroy;
				SetItemStackSize(oItem, nNewStackSize);
				break;
			}
        }
        oItem = GetNextItemInInventory(oTarget);
    }
}

// //////////////////////////////////////////////////
// LEG_COMMON_DestroyItemsByTag
// //////////////////////////////////////////////////
void LEG_COMMON_DestroyItemsByResRef(object oTarget, string sItem, int nNumItems = -1)
{
	// We put this in, even though its pretty much the same thing as LEG_COMMON_DestroyItems
	// but we needed one that had a void return for calling this with a DelayCommand.
	
	// Destroy all of them if told to do so.
	if (nNumItems == -1)
	{
		nNumItems = LEG_COMMON_GetInventoryCount(oTarget, sItem);
	}

	// Set up some variables and get the first inventory item.
    int nCount = 0;
	string sName;
    object oItem = GetFirstItemInInventory(oTarget);

	// Go through inventory and zap items.
    while (GetIsObjectValid(oItem) == TRUE && nCount < nNumItems)
    {
		sName = GetName(oItem);
        if (GetResRef(oItem) == sItem)
        {
            int nRemainingToDestroy = nNumItems - nCount;
			int nStackSize = GetItemStackSize(oItem);
			
			if(nStackSize <= nRemainingToDestroy)
			{
				DestroyObject(oItem,0.1f);
				nCount += nStackSize;
			}
            else
			{
				int nNewStackSize = nStackSize - nRemainingToDestroy;
				SetItemStackSize(oItem, nNewStackSize);
				break;
			}
        }
        oItem = GetNextItemInInventory(oTarget);
    }
}

// //////////////////////////////////////////////////
// LEG_COMMON_ProgBar
// //////////////////////////////////////////////////
void LEG_COMMON_ProgBar(object oPC, int iDuration, string sTitle, int iVisualEffect = 0, int iAnimation = 0, int iCommandable = 0, int iCancel = 0, string sAnimation1 = "kneeltalk", int iAnimationLoop1 = 1, int iDuration1 = 5, string sAnimation2 = "", int iAnimationLoop2 = 0, int iDuration2 = 0, object oTarget = OBJECT_SELF, int iClearActions = 1)
{
	// Clearing all actions seems to help with the animation
	if (iClearActions == 1)
		AssignCommand(oPC, ClearAllActions());
	
	// Display our little progress bar GUI
	if (iCancel)
	{
		DisplayGuiScreen(oPC, "leg_info_progbar", FALSE, "leg_info_progbarcan.xml");
	}
	else
	{
		DisplayGuiScreen(oPC, "leg_info_progbar", FALSE, "leg_info_progbar.xml");
	}
	SetGUIObjectText(oPC, "leg_info_progbar", "NAME_TEXT", -1, sTitle);
	SetGUIObjectText(oPC, "leg_info_progbar", "TIME_TEXT", -1, IntToString(iDuration) + " Seconds");
	float fInterval = 0.0, fProgress;
	float fIntervalSize = 100.0 / IntToFloat(iDuration);
	int iCount;

	// Cycle through our interval counter so that we may put ticks on the progress bar.  We do 4 ticks per interval.
	for (iCount=0; iCount<iDuration; iCount++)
	{
		fProgress = fInterval / 100.0;
		DelayCommand(IntToFloat(iCount), SetGUIProgressBarPosition(oPC, "leg_info_progbar", "TIME_BAR", fProgress));
		DelayCommand(IntToFloat(iCount) + 0.05, SetGUIProgressBarPosition(oPC, "leg_info_progbar", "TIME_BAR", fProgress + (fIntervalSize / 100.0 * 0.05)));
		DelayCommand(IntToFloat(iCount) + 0.1, SetGUIProgressBarPosition(oPC, "leg_info_progbar", "TIME_BAR", fProgress + (fIntervalSize / 100.0 * 0.1)));
		DelayCommand(IntToFloat(iCount) + 0.15, SetGUIProgressBarPosition(oPC, "leg_info_progbar", "TIME_BAR", fProgress + (fIntervalSize / 100.0 * 0.15)));
		DelayCommand(IntToFloat(iCount) + 0.2, SetGUIProgressBarPosition(oPC, "leg_info_progbar", "TIME_BAR", fProgress + (fIntervalSize / 100.0 * 0.2)));
		DelayCommand(IntToFloat(iCount) + 0.25, SetGUIProgressBarPosition(oPC, "leg_info_progbar", "TIME_BAR", fProgress + (fIntervalSize / 100.0 * 0.25)));
		DelayCommand(IntToFloat(iCount) + 0.3, SetGUIProgressBarPosition(oPC, "leg_info_progbar", "TIME_BAR", fProgress + (fIntervalSize / 100.0 * 0.3)));
		DelayCommand(IntToFloat(iCount) + 0.35, SetGUIProgressBarPosition(oPC, "leg_info_progbar", "TIME_BAR", fProgress + (fIntervalSize / 100.0 * 0.35)));		
		DelayCommand(IntToFloat(iCount) + 0.4, SetGUIProgressBarPosition(oPC, "leg_info_progbar", "TIME_BAR", fProgress + (fIntervalSize / 100.0 * 0.4)));
		DelayCommand(IntToFloat(iCount) + 0.45, SetGUIProgressBarPosition(oPC, "leg_info_progbar", "TIME_BAR", fProgress + (fIntervalSize / 100.0 * 0.45)));
		DelayCommand(IntToFloat(iCount) + 0.5, SetGUIProgressBarPosition(oPC, "leg_info_progbar", "TIME_BAR", fProgress + (fIntervalSize / 100.0 * 0.5)));
		DelayCommand(IntToFloat(iCount) + 0.55, SetGUIProgressBarPosition(oPC, "leg_info_progbar", "TIME_BAR", fProgress + (fIntervalSize / 100.0 * 0.55)));
		DelayCommand(IntToFloat(iCount) + 0.6, SetGUIProgressBarPosition(oPC, "leg_info_progbar", "TIME_BAR", fProgress + (fIntervalSize / 100.0 * 0.6)));
		DelayCommand(IntToFloat(iCount) + 0.65, SetGUIProgressBarPosition(oPC, "leg_info_progbar", "TIME_BAR", fProgress + (fIntervalSize / 100.0 * 0.65)));
		DelayCommand(IntToFloat(iCount) + 0.7, SetGUIProgressBarPosition(oPC, "leg_info_progbar", "TIME_BAR", fProgress + (fIntervalSize / 100.0 * 0.7)));
		DelayCommand(IntToFloat(iCount) + 0.75, SetGUIProgressBarPosition(oPC, "leg_info_progbar", "TIME_BAR", fProgress + (fIntervalSize / 100.0 * 0.75)));
		DelayCommand(IntToFloat(iCount) + 0.8, SetGUIProgressBarPosition(oPC, "leg_info_progbar", "TIME_BAR", fProgress + (fIntervalSize / 100.0 * 0.8)));
		DelayCommand(IntToFloat(iCount) + 0.85, SetGUIProgressBarPosition(oPC, "leg_info_progbar", "TIME_BAR", fProgress + (fIntervalSize / 100.0 * 0.85)));
		DelayCommand(IntToFloat(iCount) + 0.9, SetGUIProgressBarPosition(oPC, "leg_info_progbar", "TIME_BAR", fProgress + (fIntervalSize / 100.0 * 0.9)));
		DelayCommand(IntToFloat(iCount) + 0.95, SetGUIProgressBarPosition(oPC, "leg_info_progbar", "TIME_BAR", fProgress + (fIntervalSize / 100.0 * 0.95)));
		fInterval = fInterval + fIntervalSize;
		DelayCommand(IntToFloat(iCount), SetGUIObjectText(oPC, "leg_info_progbar", "TIME_TEXT", -1, IntToString(iDuration - iCount) + " Seconds"));
	}
	
	// Finish with 0 
	DelayCommand(IntToFloat(iCount), SetGUIObjectText(oPC, "leg_info_progbar", "TIME_TEXT", -1, "0 Seconds"));

	// Of course if the PC is commandable during the progress bar.  Sometimes we may enjoy forcing the PC to not be able
	// to do anything when they are using a placeable.  Seems a bit more realistic in a completely, non-realistic universe weeee!
	if (!iCommandable)
	{
		DelayCommand(1.0, SetCommandable(FALSE, oPC));
		DelayCommand(IntToFloat(iDuration), SetCommandable(TRUE, oPC));			
	}

	// When done, let's close up the Progress Bar.	
	if (iClearActions == 1)
		AssignCommand(oPC, ClearAllActions());
		
	if (iVisualEffect != -1)
	{
		DelayCommand(0.2, LEG_COMMON_VisualEffect(iVisualEffect, oTarget, OBJECT_INVALID, IntToFloat(iDuration1 + iDuration2)));
	}
	
	if (sAnimation1 != "NONE")
		LEG_COMMON_ActionPlayCustomAnimation(oPC, sAnimation1, iAnimationLoop1, IntToFloat(iDuration1));
	if (sAnimation2 != "")
		DelayCommand(IntToFloat(iDuration1), LEG_COMMON_ActionPlayCustomAnimation(oPC, sAnimation2, iAnimationLoop2, IntToFloat(iDuration2)));
	//AssignCommand(oPC, ActionPlayAnimation(iAnimation, 1.0, IntToFloat(iDuration)));
	DelayCommand(IntToFloat(iCount + 1), SetGUIProgressBarPosition(oPC, "leg_info_progbar", "TIME_BAR", 1.0));
	DelayCommand(IntToFloat(iCount) + 1.25, CloseGUIScreen(oPC, "leg_info_progbar"));
	
	// Threw an extra one of these in just to see what would happen.  Once in a while I found that the progress bar
	// would get stuck and not disappear.  Not sure why, but with any luck this will fix it.
	DelayCommand(IntToFloat(iCount) + 1.5, CloseGUIScreen(oPC, "leg_info_progbar"));
}

// //////////////////////////////////////////////////
// LEG_COMMON_TimerBar_CleanVars
// //////////////////////////////////////////////////
void LEG_COMMON_TimerBar_CleanVars(object oPC)
{
	// Split this out because A. It's used in a timer is turned off on success and B. we need it for delays
	// in order for fail scripts to pull out vars.
	
	// Clean Up Persistent Timer Flags
	string sQuestID = GetLocalString(oPC, "LEG_INFO_TimerBarQuestID");
	string sTablePlayer = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
	string sTableToon = SQLEncodeSpecialChars(GetName(oPC));
	string sPCTableName = LEG_COMMON_GetPC2Table(oPC);
	SQLExecDirect("DELETE FROM " + sPCTableName + " WHERE `player` = '" + sTablePlayer + "' AND `tag` = '" + sTableToon + "' AND `Name` LIKE 'QuestID_" + sQuestID + "_TIMER%'");	
	
	SetLocalInt(oPC, "LEG_INFO_TimerBarDuration", 0);
	SetLocalInt(oPC, "LEG_INFO_TimerBarNPC", 0);
	SetLocalInt(oPC, "LEG_INFO_TimerBarNPCOBJ", 0);
	SetLocalString(oPC, "LEG_INFO_ProgBarTimerFailScript", "");
	SetLocalString(oPC, "LEG_INFO_TimerBarQuestID", "");
	
	SetLocalInt(oPC, "LEG_INFO_TimerBarActive", 0);
}

// //////////////////////////////////////////////////
// LEG_COMMON_TimerBar_Complete
// //////////////////////////////////////////////////
void LEG_COMMON_TimerBar_Complete(object oPC, int iNode, string sFailScript)
{
	// If we've gotten here and we're still running, then the timer bar has run its course.
	if (GetLocalInt(oPC, "INFO_TimerBarNode") == iNode)
	{
		SetGUIObjectText(oPC, "leg_info_timerbar", "TIME_TEXT", -1, "0 Seconds");
		SetGUIProgressBarPosition(oPC, "leg_info_timerbar", "TIME_BAR", 0.0);
		CloseGUIScreen(oPC, "leg_info_timerbar");

		// Run the fail script
		if (sFailScript != "")
			ExecuteScript(sFailScript, oPC);
				
		// Clean up the PC
		DelayCommand(1.5, LEG_COMMON_TimerBar_CleanVars(oPC));
	}
}

// //////////////////////////////////////////////////
// LEG_COMMON_TimerBar_Update
// //////////////////////////////////////////////////
void LEG_COMMON_TimerBarUpdate(object oPC, float fProgress, float fIntervalSize, float fMicroInterval, int iNode)
{
	//if (!GetLocalInt(oPC, "LEG_INFO_AbortTimer"))
	if (GetLocalInt(oPC, "INFO_TimerBarNode") == iNode)
		SetGUIProgressBarPosition(oPC, "leg_info_timerbar", "TIME_BAR", fProgress + (fIntervalSize / 100.0 * fMicroInterval));
}

// //////////////////////////////////////////////////
// LEG_COMMON_TimerBarSeconds
// //////////////////////////////////////////////////
void LEG_COMMON_TimerBarSeconds(object oPC, int iSecond, int iNode)
{
	if (GetLocalInt(oPC, "INFO_TimerBarNode") == iNode)
		SetGUIObjectText(oPC, "leg_info_timerbar", "TIME_TEXT", -1, IntToString(iSecond) + " Seconds");
}

// //////////////////////////////////////////////////
// LEG_COMMON_TimerBar
// //////////////////////////////////////////////////
void LEG_COMMON_TimerBar(object oPC, int iDuration, string sTitle, object oTarget = OBJECT_SELF, int iClearActions = 1)
{
	// Clearing all actions seems to help with the animation
	if (iClearActions == 1)
		AssignCommand(oPC, ClearAllActions());
	
	int iNode = GetLocalInt(oPC, "INFO_TimerBarNode");
		
		
	// Display our little progress bar GUI
	DisplayGuiScreen(oPC, "leg_info_timerbar", FALSE, "leg_info_timerbar.xml");
	SetGUIProgressBarPosition(oPC, "leg_info_timerbar", "TIME_BAR", 1.0);
	
	SetGUIObjectText(oPC, "leg_info_timerbar", "NAME_TEXT", -1, sTitle);
	SetGUIObjectText(oPC, "leg_info_timerbar", "TIME_TEXT", -1, IntToString(iDuration) + " Seconds");
	float fIntervalSize = 100.0 / IntToFloat(iDuration);
	float fInterval = IntToFloat(iDuration - 1) * fIntervalSize;
	float fProgress;
	int iCount;

	// Cycle through our interval counter so that we may put ticks on the progress bar.  We do 4 ticks per interval.
	for (iCount=0; iCount<iDuration; iCount++)
	{
		fProgress = fInterval / 100.0;
		DelayCommand(IntToFloat(iCount), LEG_COMMON_TimerBarUpdate(oPC, fProgress, fIntervalSize, 0.95, iNode));
		DelayCommand(IntToFloat(iCount) + 0.05, LEG_COMMON_TimerBarUpdate(oPC, fProgress, fIntervalSize, 0.9, iNode));
		DelayCommand(IntToFloat(iCount) + 0.1, LEG_COMMON_TimerBarUpdate(oPC, fProgress, fIntervalSize, 0.85, iNode));
		DelayCommand(IntToFloat(iCount) + 0.15, LEG_COMMON_TimerBarUpdate(oPC, fProgress, fIntervalSize, 0.8, iNode));
		DelayCommand(IntToFloat(iCount) + 0.2, LEG_COMMON_TimerBarUpdate(oPC, fProgress, fIntervalSize, 0.75, iNode));
		DelayCommand(IntToFloat(iCount) + 0.25, LEG_COMMON_TimerBarUpdate(oPC, fProgress, fIntervalSize, 0.7, iNode));
		DelayCommand(IntToFloat(iCount) + 0.3, LEG_COMMON_TimerBarUpdate(oPC, fProgress, fIntervalSize, 0.65, iNode));
		DelayCommand(IntToFloat(iCount) + 0.35, LEG_COMMON_TimerBarUpdate(oPC, fProgress, fIntervalSize, 0.6, iNode));
		DelayCommand(IntToFloat(iCount) + 0.4, LEG_COMMON_TimerBarUpdate(oPC, fProgress, fIntervalSize, 0.55, iNode));
		DelayCommand(IntToFloat(iCount) + 0.45, LEG_COMMON_TimerBarUpdate(oPC, fProgress, fIntervalSize, 0.5, iNode));
		DelayCommand(IntToFloat(iCount) + 0.5, LEG_COMMON_TimerBarUpdate(oPC, fProgress, fIntervalSize, 0.45, iNode));
		DelayCommand(IntToFloat(iCount) + 0.55, LEG_COMMON_TimerBarUpdate(oPC, fProgress, fIntervalSize, 0.4, iNode));
		DelayCommand(IntToFloat(iCount) + 0.6, LEG_COMMON_TimerBarUpdate(oPC, fProgress, fIntervalSize, 0.35, iNode));
		DelayCommand(IntToFloat(iCount) + 0.65, LEG_COMMON_TimerBarUpdate(oPC, fProgress, fIntervalSize, 0.3, iNode));
		DelayCommand(IntToFloat(iCount) + 0.7, LEG_COMMON_TimerBarUpdate(oPC, fProgress, fIntervalSize, 0.25, iNode));
		DelayCommand(IntToFloat(iCount) + 0.75, LEG_COMMON_TimerBarUpdate(oPC, fProgress, fIntervalSize, 0.2, iNode));
		DelayCommand(IntToFloat(iCount) + 0.8, LEG_COMMON_TimerBarUpdate(oPC, fProgress, fIntervalSize, 0.15, iNode));
		DelayCommand(IntToFloat(iCount) + 0.85, LEG_COMMON_TimerBarUpdate(oPC, fProgress, fIntervalSize, 0.1, iNode));
		DelayCommand(IntToFloat(iCount) + 0.9, LEG_COMMON_TimerBarUpdate(oPC, fProgress, fIntervalSize, 0.05, iNode));
		DelayCommand(IntToFloat(iCount) + 0.95, LEG_COMMON_TimerBarUpdate(oPC, fProgress, fIntervalSize, 0.0, iNode));
		
		fInterval = fInterval - fIntervalSize;
		DelayCommand(IntToFloat(iCount), LEG_COMMON_TimerBarSeconds(oPC, iDuration - iCount, iNode));
	}
	
	
	// Threw an extra one of these in just to see what would happen.  Once in a while I found that the progress bar
	// would get stuck and not disappear.  Not sure why, but with any luck this will fix it.
	// Finish with 0.  We need to pull of up Follow Up Int and the Fail Script because later on, the object we got this timer bar from may not exist (player leaves area object despawns)
	string sTimerFailScript = GetLocalString(OBJECT_SELF, "LEG_INFO_ProgBarTimerFailScript");

	DelayCommand(IntToFloat(iCount), LEG_COMMON_TimerBar_Complete(oPC, iNode, sTimerFailScript));
	
	// When done, let's close up the Progress Bar.	
	if (iClearActions == 1)
		AssignCommand(oPC, ClearAllActions());
	
}

// //////////////////////////////////////////////////
// LEG_COMMON_GetItemName
// //////////////////////////////////////////////////
string LEG_COMMON_GetItemName(object oTarget, string sItem)
{
	// Find an item in the target's inventory and get it's name by tag.
    int nCount = 0;
	string sName;
    object oItem = GetFirstItemInInventory(oTarget);
	int nNumItems = 150;

	// Loop through all the valid items, limiting ourself to 150 checks for sanity.	
    while (GetIsObjectValid(oItem) == TRUE && nCount < nNumItems)
    {
        if (GetResRef(oItem) == sItem)
        {
			return sName = GetName(oItem);
            nCount++;
        }
        oItem = GetNextItemInInventory(oTarget);
    }

   // If we don't have an item by that name, then return something invalid.
   return "Invalid Item";
}

// //////////////////////////////////////////////////
// LEG_COMMON_GetOldPCTable
// //////////////////////////////////////////////////
string LEG_COMMON_GetPCTable(object oPC, string sTableType, int iNoQuotes = FALSE)
{
	string sTablePlayer, sTableTag, sTableID;
	sTablePlayer = GetStringLowerCase(SQLEncodeSpecialChars(LEG_COMMON_StripBadChars(GetPCPlayerName(oPC))));
	sTableTag = GetStringLowerCase(SQLEncodeSpecialChars(LEG_COMMON_StripBadChars(GetName(oPC))));
	sTableID = GetStringLowerCase(LEG_COMMON_StripBadChars(PCPREFIX) + "_" + LEG_COMMON_StripBadChars(sTableType) + "_" + sTablePlayer + sTableTag);
	if (iNoQuotes)
		return sTableID;
	else
		return "`" + sTableID + "`";
}


// //////////////////////////////////////////////////
// LEG_COMMON_GetPC2Table
// //////////////////////////////////////////////////
string LEG_COMMON_GetPC2Table(object oPC)
{
	string sTablePlayer, sTableTag, sTableID;
	sTablePlayer = GetStringLowerCase(SQLEncodeSpecialChars(LEG_COMMON_StripBadChars(GetPCPlayerName(oPC))));
	sTableID = GetStringLowerCase(LEG_COMMON_StripBadChars(PCPREFIX) + "_" + sTablePlayer);
	return "`" + sTableID + "`";
}

// //////////////////////////////////////////////////
// LEG_COMMON_CheckTOD
// //////////////////////////////////////////////////
int LEG_COMMON_CheckTOD(string sStartTOD, string sStopTOD)
{
	// We need this function to determine Spawn and DeSpawn TOD's.  If we are supposed to Despawn during a particular
	// time of day, we certainly don't want a critter spawning etc.
	int iStart = LEG_COMMON_StringToHour(sStartTOD);
	int iEnd = LEG_COMMON_StringToHour(sStopTOD);
	int iCurrentHour = GetTimeHour();
	
	// We want to return TRUE if its time to spawn, and FALSE if it's time to Despawn.  If the End Spawn is in the next
	// day, we need to be able to identify and deal with that.
	if (iEnd < iStart)
	{
		// Looks like our end spawn is the next day so we'll throw a little check here for time due to that.
		if (iCurrentHour < iEnd)
			return TRUE;
		else if (iCurrentHour >= iStart)
			return TRUE;
		else
			return FALSE;
	}
	else
	{
		// Here the Spawn time and Despawn time are in the same day so it's a little simpler.
		if (iCurrentHour >= iStart && iCurrentHour < iEnd)
			return TRUE;
		else
			return FALSE;
	}
}

// //////////////////////////////////////////////////
// LEG_COMMON_GetItemLevel
// //////////////////////////////////////////////////
int LEG_COMMON_GetItemLevel(object oItem)
{
	int iGoldValue = GetGoldPieceValue(oItem);
	if (iGoldValue <= 1000)
		return 1;
	else if (iGoldValue >= 1001 && iGoldValue <=1500)
		return 2;
	else if (iGoldValue >= 1501 && iGoldValue <=2500)
		return 3;
	else if (iGoldValue >= 2501 && iGoldValue <=3500)
		return 4;
	else if (iGoldValue >= 3501 && iGoldValue <=5000)
		return 5;
	else if (iGoldValue >= 5001 && iGoldValue <=6500)
		return 6;
	else if (iGoldValue >= 6501 && iGoldValue <=9000)
		return 7;
	else if (iGoldValue >= 9001 && iGoldValue <=12000)
		return 8;
	else if (iGoldValue >= 12001 && iGoldValue <=15000)
		return 9;
	else if (iGoldValue >= 15001 && iGoldValue <=19500)
		return 10;
	else if (iGoldValue >= 19501 && iGoldValue <=25000)
		return 11;
	else if (iGoldValue >= 25001 && iGoldValue <=30000)
		return 12;
	else if (iGoldValue >= 30001 && iGoldValue <=35000)
		return 13;
	else if (iGoldValue >= 35001 && iGoldValue <=40000)
		return 14;
	else if (iGoldValue >= 40001 && iGoldValue <=50000)
		return 15;
	else if (iGoldValue >= 50001 && iGoldValue <=65000)
		return 16;
	else if (iGoldValue >= 65001 && iGoldValue <=75000)
		return 17;
	else if (iGoldValue >= 75001 && iGoldValue <=90000)
		return 18;
	else if (iGoldValue >= 90001 && iGoldValue <=110000)
		return 19;
	else if (iGoldValue >= 110001 && iGoldValue <=130000)
		return 20;
	else if (iGoldValue >= 130001 && iGoldValue <=250000)
		return 21;
	else if (iGoldValue >= 250001 && iGoldValue <=500000)
		return 22;
	else if (iGoldValue >= 500001 && iGoldValue <=750000)
		return 23;
	else if (iGoldValue >= 750001 && iGoldValue <=1000000)
		return 24;
	else if (iGoldValue >= 1000001 && iGoldValue <=1200000)
		return 25;
	else if (iGoldValue >= 1200001 && iGoldValue <=1400000)
		return 26;
	else if (iGoldValue >= 1400001 && iGoldValue <=1600000)
		return 27;
	else if (iGoldValue >= 1600001 && iGoldValue <=1800000)
		return 28;
	else if (iGoldValue >= 1800001 && iGoldValue <=2000000)
		return 29;
	else if (iGoldValue >= 2000001 && iGoldValue <=2200000)
		return 30;
	else
		return 0;
}

// //////////////////////////////////////////////////
// LEG_COMMON_GetMonthName
// //////////////////////////////////////////////////
string LEG_COMMON_GetMonthName(int iMonth)
{
	switch (iMonth)
	{
		case 1:		return "January";
		case 2:		return "Febuary";
		case 3:		return "March";
		case 4:		return "April";
		case 5:		return "May";
		case 6:		return "June";
		case 7:		return "July";
		case 8:		return "August";
		case 9:		return "September";
		case 10:	return "October";
		case 11:	return "November";
		case 12:	return "December";
	}
	
	return "Unknown";
}

// //////////////////////////////////////////////////
// LEG_COMMON_GetTimeNon24
// //////////////////////////////////////////////////
string LEG_COMMON_GetTimeNon24(int iHour, int iMin)
{
	string sMin;
	if (iMin < 10)
		sMin = "0" + IntToString(iMin);
	else
		sMin = IntToString(iMin);
	
	if (iHour == 0)
		return "12:" + sMin + " AM";
	else if (iHour >= 1 && iHour <= 12)
		return IntToString(iHour) + ":" + sMin + " AM";
	else if (iHour >= 12 && iHour <= 23)
		return IntToString(iHour - 12) + ":" + sMin + " PM";

	return "Unknown";

}

// //////////////////////////////////////////////////
// LEG_COMMON_AddArrayElement
// //////////////////////////////////////////////////
void LEG_COMMON_AddArrayElement(object oObject, string sArrayName, string sValue)
{
    int iArrayCount = GetLocalInt(oObject, sArrayName + "_Count");
    iArrayCount++;
    SetLocalString(oObject, sArrayName + "_Value" + IntToString(iArrayCount), sValue);
    SetLocalInt(oObject, sArrayName + "_Count", iArrayCount);
	SetLocalString(oObject, sArrayName + "_Value" + IntToString(iArrayCount + 1), "#EOA#");
}

// //////////////////////////////////////////////////
// LEG_COMMON_DeleteCurrentArrayElement
// //////////////////////////////////////////////////
void LEG_COMMON_DeleteArrayElement(object oObject, string sArrayName, int iIndex)
{
    SetLocalString(oObject, sArrayName + "_Value" + IntToString(iIndex), "LEG_DELETED_ARRAY_ELEMENT");
	LEG_COMMON_CompressArray(oObject, sArrayName);
}

// //////////////////////////////////////////////////
// LEG_COMMON_DeleteCurrentArrayElement
// //////////////////////////////////////////////////
void LEG_COMMON_DeleteCurrentArrayElement(object oObject, string sArrayName)
{
    int iPosition = GetLocalInt(oObject, sArrayName + "_Position");
    SetLocalString(oObject, sArrayName + "_Value" + IntToString(iPosition), "LEG_DELETED_ARRAY_ELEMENT");
	LEG_COMMON_CompressArray(oObject, sArrayName);
}

// //////////////////////////////////////////////////
// LEG_COMMON_GetFirstArrayElement
// //////////////////////////////////////////////////
string LEG_COMMON_GetFirstArrayElement(object oObject, string sArrayName)
{
	// If there are no elements in the array, return EOA.
	if (GetLocalInt(oObject, sArrayName + "_Count") == 0)
		return "#EOA#";

    SetLocalInt(oObject, sArrayName + "_Position", 1);
	string sElement = GetLocalString(oObject, sArrayName + "_Value1");
	while(sElement == "LEG_DELETED_ARRAY_ELEMENT")
    {
		sElement = LEG_COMMON_GetNextArrayElement(oObject, sArrayName);
	}
	return sElement;
}


// //////////////////////////////////////////////////
// LEG_COMMON_GetNextArrayElement
// //////////////////////////////////////////////////
string LEG_COMMON_GetNextArrayElement(object oObject, string sArrayName)
{
	// Get the current position and count
	int iPosition = GetLocalInt(oObject, sArrayName + "_Position");
	int iArrayCount = GetLocalInt(oObject, sArrayName + "_Count");
    iPosition++;

	// If adding one more position puts us outside the array, return EOA.
	if (iPosition > iArrayCount)
		return "#EOA#";

	SetLocalInt(oObject, sArrayName + "_Position", iPosition);
    string sElement = GetLocalString(oObject, sArrayName + "_Value" + IntToString(iPosition));
	while (sElement == "LEG_DELETED_ARRAY_ELEMENT")
	{
	    iPosition++;
    	SetLocalInt(oObject, sArrayName + "_Position", iPosition);
    	sElement = GetLocalString(oObject, sArrayName + "_Value" + IntToString(iPosition));
	}

	return sElement;
}

// //////////////////////////////////////////////////
// LEG_COMMON_GetArrayElement
// //////////////////////////////////////////////////
string LEG_COMMON_GetArrayElement(object oObject, string sArrayName, int iIndex)
{
	// Get's the array element at a specific index.
	string sElement;
	int iCounter;
	int iArrayCount = GetLocalInt(oObject, sArrayName + "_Count");
	if (iIndex > iArrayCount)
		return "#OUTOFBOUNDS#";
	
    SetLocalInt(oObject, sArrayName + "_Position", iIndex);
	return sElement = GetLocalString(oObject, sArrayName + "_Value" + IntToString(iIndex));
}

// //////////////////////////////////////////////////
// LEG_COMMON_GetArrayElement
// //////////////////////////////////////////////////
void LEG_COMMON_SetArrayElement(object oObject, string sArrayName, int iIndex, string sValue)
{
	// Get's the array element at a specific index.
	string sElement;
	int iCounter;
	int iArrayCount = GetLocalInt(oObject, sArrayName + "_Count");
	if (iIndex > iArrayCount)
		return;
	
    SetLocalInt(oObject, sArrayName + "_Position", iIndex);
	SetLocalString(oObject, sArrayName + "_Value" + IntToString(iIndex), sValue);
}

// //////////////////////////////////////////////////
// LEG_COMMON_SearchArrayElement
// //////////////////////////////////////////////////
int LEG_COMMON_SearchArrayElement(object oObject, string sArrayName, string sValue)
{
	string sResult = LEG_COMMON_GetFirstArrayElement(oObject, sArrayName);
	int iIndex = 1;
	while (sResult != "#EOA#")
	{
		if (sResult == sValue)
			return iIndex;
		iIndex++;
		sResult = LEG_COMMON_GetNextArrayElement(oObject, sArrayName);
	}
	return -1;
}

// //////////////////////////////////////////////////
// LEG_COMMON_ResetArrayIndex
// //////////////////////////////////////////////////
void LEG_COMMON_ResetArrayIndex(object oObject, string sArrayName)
{
	SetLocalInt(oObject, sArrayName + "_Position", 1);
}

// //////////////////////////////////////////////////
// LEG_COMMON_GetCurrentArrayIndex
// //////////////////////////////////////////////////
int LEG_COMMON_GetCurrentArrayIndex(object oObject, string sArrayName)
{
	return GetLocalInt(oObject, sArrayName + "_Position");
}

// //////////////////////////////////////////////////
// LEG_COMMON_GetArrayElementCount
// //////////////////////////////////////////////////
int LEG_COMMON_GetArrayElementCount(object oObject, string sArrayName)
{
	return GetLocalInt(oObject, sArrayName + "_Count");
}

// //////////////////////////////////////////////////
// LEG_COMMON_CompressArray
// //////////////////////////////////////////////////
void LEG_COMMON_CompressArray(object oObject, string sArrayName)
{
	// Reindex the array removing deleted elements.
	string sValue;
	string sTempArrayName = sArrayName + "_tmp";
    int iArrayCount = GetLocalInt(oObject, sArrayName + "_Count");
    int iCounter, iNewIndex, iNewCount;
	iNewCount = iArrayCount;
	
    while (iCounter < iArrayCount)
    {
		iCounter++;
        sValue = GetLocalString(oObject, sArrayName + "_Value" + IntToString(iCounter));
		if (sValue != "LEG_DELETED_ARRAY_ELEMENT")
		{
			// Anything that's not deleted, add to the new temp array.
			iNewIndex++;
			SetLocalString(oObject, sTempArrayName + "_Value" + IntToString(iNewIndex), sValue);
		}
	}
	
	// Now that we have a new temporary array, we need to delete the old array and rename this one.
	SetLocalInt(oObject, sTempArrayName + "_Count", iNewIndex);
	SetLocalInt(oObject, sTempArrayName + "_Position", 1);
	LEG_COMMON_ClearArray(oObject, sArrayName);
	LEG_COMMON_RenameArray(oObject, sTempArrayName, sArrayName);
	SetLocalString(oObject, sArrayName + "_Value" + IntToString(iNewIndex + 1), "#EOA#");
	SetLocalInt(oObject, sArrayName + "_Count", iNewIndex);
	SetLocalInt(oObject, sArrayName + "_Position", 1);
}

// //////////////////////////////////////////////////
// LEG_COMMON_RenameArray
// //////////////////////////////////////////////////
void LEG_COMMON_RenameArray(object oObject, string sOldName, string sNewName)
{
    int iArrayCount = GetLocalInt(oObject, sOldName + "_Count");
    int iCounter;
	string sValue;

    while (iCounter < iArrayCount)
    {
		iCounter++;
		sValue = GetLocalString(oObject, sOldName + "_Value" + IntToString(iCounter));		
        SetLocalString(oObject, sNewName + "_Value" + IntToString(iCounter), sValue);
    }
	LEG_COMMON_ClearArray(oObject, sOldName);
}

// //////////////////////////////////////////////////
// LEG_COMMON_ClearArray
// //////////////////////////////////////////////////
void LEG_COMMON_ClearArray(object oObject, string sArrayName)
{
    int iArrayCount = GetLocalInt(oObject, sArrayName + "_Count");
    int iCounter;

    while (iCounter < iArrayCount)
    {
        DeleteLocalString(oObject, sArrayName + "_Value" + IntToString(iCounter));
        iCounter++;
    }
    DeleteLocalInt(oObject, sArrayName + "_Count");
    DeleteLocalInt(oObject, sArrayName + "_Position");
}

// //////////////////////////////////////////////////
// LEG_COMMON_TextReplace
// //////////////////////////////////////////////////
string LEG_COMMON_TextReplace(string sText, string sOld, string sNew)
{
	int iLength = GetStringLength(sText);
	int iCounter;
	string sNewString, sChar;
	while (iCounter <= iLength)
	{
		sChar = GetSubString(sText, iCounter, 1);
		if (sChar == sOld) sChar = sNew;
		sNewString = sNewString + sChar;
		iCounter++;
	}
	
	return sNewString;
}

// //////////////////////////////////////////////////
// LEG_COMMON_TextRemoveBrace
// //////////////////////////////////////////////////
string LEG_COMMON_TextRemoveBrace(string sText, int iClearWhiteSpaceLeft, int iClearWhiteSpaceRight)
{
	int iBracesFound = 0;
	int iBraceStart = FindSubString(sText, "{");
	int iBraceEnd = FindSubString(sText, "}");
	if (iBraceStart > 0 && iBraceEnd > 0) iBracesFound = 1;
	
	while (iBracesFound)
	{
		// Looks like we have some braces.
		if (iBraceStart < iBraceEnd)
		{
			// And they are positioned correctly
			string sLeftPart = GetStringLeft(sText, iBraceStart - 1);
			string sRightPart = GetStringRight(sText, GetStringLength(sText) - (iBraceEnd + 1));
			
			// If we need to remove any whitespace
			if (iClearWhiteSpaceLeft && GetStringRight(sLeftPart, 1) == " ") sLeftPart = GetStringLeft(sLeftPart, GetStringLength(sLeftPart) - 1);
			if (iClearWhiteSpaceRight && GetStringLeft(sRightPart, 1) == " ") sRightPart = GetStringRight(sRightPart, GetStringLength(sRightPart) - 1);
			sText = sLeftPart + sRightPart;
		}
		else iBracesFound = 0;
			
		iBraceStart = FindSubString(sText, "{");
		iBraceEnd = FindSubString(sText, "}");
		if (iBraceStart > 0 && iBraceEnd > 0) iBracesFound = 1;
		else iBracesFound = 0;
	}
	return sText;
}

// //////////////////////////////////////////////////
// ActionPlayCustomAnimation (Wrapper)
// //////////////////////////////////////////////////
void LEG_COMMON_ActionPlayCustomAnimation(object oNPC, string sAnimationName, int nLooping, float fDuration = 0.0, float fSpeed = 1.0f)
{
   	PlayCustomAnimation(oNPC, sAnimationName, nLooping, fSpeed);	
	if (fDuration != 0.0) DelayCommand(fDuration, LEG_COMMON_ActionPlayCustomAnimation(oNPC, "%", 0));

}

float LEG_COMMON_GetDirectionAngle(object oTarget1, object oTarget2)
{
    vector vPos1 = GetPosition(oTarget1);
    vector vPos2 = GetPosition(oTarget2);
    int xPCPoint = abs(FloatToInt(vPos1.x));
    int yPCPoint = abs(FloatToInt(vPos1.y));
    int xTargetPoint = abs(FloatToInt(vPos2.x));
    int yTargetPoint = abs(FloatToInt(vPos2.y));
    int xPoint = xPCPoint;
    int yPoint = yTargetPoint;
    int iOpposite = abs(yPCPoint - yPoint);
    int iAdjacent = abs(xTargetPoint - xPoint);
    float fPreTanAngle, fAngle;
    if (iAdjacent == 0) fAngle = 90.0;
    else
    {
        fPreTanAngle = IntToFloat(iOpposite) / IntToFloat(iAdjacent);
        fAngle = atan(fPreTanAngle);
    }

    // if My X,Y are both positive, I am in Quad 1
    if (FloatToInt(vPos1.x - vPos2.x) >= 0 && FloatToInt(vPos1.y - vPos2.y) >= 0)
        fAngle = 90.0 - fAngle;
    // if x is pos and y is neg, I am in quad 2 so add 90
    else if (FloatToInt(vPos1.x - vPos2.x) >= 0 && FloatToInt(vPos1.y - vPos2.y) < 0)
        fAngle = fAngle + 90.0;
    // if x is negative and y is neg, I am in quad 3 so add 180
    else if (FloatToInt(vPos1.x - vPos2.x) < 0 && FloatToInt(vPos1.y - vPos2.y) < 0)
        fAngle = 180.0 + (90.0 - fAngle);
    // if x is neg and y is pos, I am in quad 4 so add 270
    else if (FloatToInt(vPos1.x - vPos2.x) < 0 && FloatToInt(vPos1.y - vPos2.y) >= 0)
		fAngle = fAngle + 270.0;

    fAngle = GetOppositeDirection(fAngle);
    return fAngle;
}

// //////////////////////////////////////////////////
// LEG_COMMON_VisualEffect
// //////////////////////////////////////////////////
void LEG_COMMON_VisualEffect(int iEffect, object oTarget, object oSource, float fDuration = 0.0)
{
	// Check for a spawn in effect.
	if (iEffect > 0)
	{
		int iRows = GetNum2DARows("visualeffects");
	    string sType;
		if (iEffect <= iRows - 1) sType = Get2DAString("visualeffects", "Type_FD", iEffect);
		else
		{
			iEffect = iEffect - iRows;
			sType = Get2DAString("sj_sef_browser", "TYPE", iEffect);
		}

	    // Display the effect according to type
	    if(sType == "B")
	    {
	        // beams
	        effect eEffect = EffectBeam(iEffect, oSource, BODY_NODE_CHEST);
			if (fDuration == -1.0) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oTarget); 
			else ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, fDuration); 
	    }
	    else if(sType == "D")
	    {
	        // duration VFXs
	        effect eEffect = EffectVisualEffect(iEffect);
			if (fDuration == -1.0) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oTarget); 
			else ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, fDuration); 
	    }
	    else if(sType == "F")
	    {
	        // fire and forget
	        effect eEffect = EffectVisualEffect(iEffect);
	        ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, oTarget); 
	    }
	    else if(sType == "P")
	    {
	        // projectile VFXs
	        effect eEffect = EffectVisualEffect(iEffect);
	        ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, oTarget); 
	    }
	    else if(sType == "C" || sType == "R")
	    {
	        // circular and rectangular AOEs
	        effect eEffect = EffectAreaOfEffect(iEffect, "null", "null", "null");
			if (fDuration == -1.0) ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eEffect, GetLocation(oTarget)); 
			else ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eEffect, GetLocation(oTarget), fDuration); 
	    }
		else if (sType == "NWN2" || sType == "NX1" || sType == "NX2")
		{
			string sSefFile = Get2DAString("sj_sef_browser", "NAME", iEffect);
			effect eEffect = EffectNWN2SpecialEffectFile(sSefFile, oSource);
			if (fDuration == -1.0) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oTarget);
			else ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, fDuration);
		}
	}
}


// //////////////////////////////////////////////////
// LEG_COMMON_ExecuteScript
// //////////////////////////////////////////////////
void LEG_COMMON_ExecuteScript(string sScript, object oTarget, object oObj1 = OBJECT_INVALID, object oObj2 = OBJECT_INVALID, string sStr1 = "", string sStr2 = "", int iInt1 = 0, int iInt2 = 0, float fFloat1 = 0.0, float fFloat2 = 0.0)
{
	if (GetIsObjectValid(oObj1)) AddScriptParameterObject(oObj1);
	if (GetIsObjectValid(oObj2)) AddScriptParameterObject(oObj2);
	if (sStr1 != "") AddScriptParameterString(sStr1);
	if (sStr2 != "") AddScriptParameterString(sStr2);
	if (iInt1 != 0) AddScriptParameterInt(iInt1);
	if (iInt2 != 0)	AddScriptParameterInt(iInt2);
	if (fFloat1 != 0.0)	AddScriptParameterFloat(fFloat1);
	if (fFloat2 != 0.0)	AddScriptParameterFloat(fFloat2);
	ExecuteScriptEnhanced(sScript, oTarget);
}

// //////////////////////////////////////////////////
// LEG_COMMON_SkillToText
// //////////////////////////////////////////////////
string LEG_COMMON_SkillToText(int iSkill)
{
	string sSkill = "";
	switch (iSkill)
	{
		case 1:		sSkill = "Concentration"; break;
		case 2:		sSkill = "Disable Trap"; break;
		case 3:		sSkill = "Discipline"; break;
		case 4:		sSkill = "Heal"; break;
		case 5:		sSkill = "Hide"; break;
		case 6:		sSkill = "Listen"; break;
		case 7:		sSkill = "Lore"; break;
		case 8:		sSkill = "Move Silently"; break;
		case 9:		sSkill = "Open Lock"; break;
		case 10:	sSkill = "Parry"; break;
		case 11:	sSkill = "Perform"; break;
		case 12:	sSkill = "Diplomacy"; break;
		case 13:	sSkill = "Sleight Of Hand"; break;
		case 14:	sSkill = "Search"; break;
		case 15:	sSkill = "Set Trap"; break;
		case 16:	sSkill = "Spellcraft"; break;
		case 17:	sSkill = "Spot"; break;
		case 18:	sSkill = "Taunt"; break;
		case 19:	sSkill = "Use Magic Device"; break;
		case 20:	sSkill = "Appraise"; break;
		case 21:	sSkill = "Tumble"; break;
		case 22:	sSkill = "Craft Trap"; break;
		case 23:	sSkill = "Bluff"; break;
		case 24:	sSkill = "Intimidate"; break;
		case 25:	sSkill = "Craft Armor"; break;
		case 26:	sSkill = "Craft Weapon"; break;
		case 27:	sSkill = "Craft Alchemy"; break;
		case 29:	sSkill = "Survival"; break;
	}
	return sSkill;
}

// //////////////////////////////////////////////////
// LEG_COMMON_CreateTweeningObjects
// //////////////////////////////////////////////////
void LEG_COMMON_CreateTweeningObjects(object oOriginal, int nCount, vector vDestination, float fFacing = -1.0)
{
	int n;
	object oNew;
	effect eCSI = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY);
	
	// decompose the original object
	string sRes = GetResRef(oOriginal);
	string sTag = GetTag(oOriginal);

    // decompose the original location
	object oArea = GetArea(oOriginal);
	vector vPosition = GetPosition(oOriginal);
	if (fFacing == -1.0) fFacing = GetFacing(oOriginal);

    // calculate the translation vector for each tween
    vector vTranslation = (vDestination - vPosition) / IntToFloat(nCount);

   	// create tweening objects between original object and the destination
    // NOTE: that for GetObjectByTag purposes the original object starts as nNth = 0 but is pushed
    // down the stack until nNth = nCount and the last tweening object (i.e. the one we want to 
    // persist) becomes nNth = 0
    for(n = 0; n < nCount; n++)
	{
        vPosition += vTranslation;
	
		// create a new object and instantly make it cutscene-invisible
	    oNew = CreateObject(OBJECT_TYPE_PLACEABLE, sRes, Location(oArea,  vPosition, fFacing), FALSE, sTag);
    	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCSI, oNew);
	}
}

// //////////////////////////////////////////////////
// LEG_COMMON_DestroyTweeningObjects
// //////////////////////////////////////////////////
void LEG_COMMON_DestroyTweeningObjects(object oOriginal, int nCount)
{
	int n;
	
	// decompose object
	string sTag = GetTag(oOriginal);

    // destroy the original object and all tweening objects except the last 
    // NOTE: that for GetObjectByTag purposes the original object starts as nNth = 0 but is pushed
    // down the stack until nNth = nCount and the last tweening object (i.e. the one we want to 
    // persist) becomes nNth = 0
    for(n = nCount; n > 0; n--)
	{
		DestroyObject(GetObjectByTag(sTag, n));
	}	
}

// //////////////////////////////////////////////////
// LEG_COMMON_RemoveCutsceneInvisibility
// //////////////////////////////////////////////////
void LEG_COMMON_RemoveCutsceneInvisibility(object oObject)
{
	effect eEffect = GetFirstEffect(oObject);
	while(GetIsEffectValid(eEffect))
	{
        // only remove the effect if it is a cutscene invisible visual effect
        // NOTE: the first entry in a visual effect's (0-based) IntList is the visual effect id
		if(GetEffectType(eEffect) == EFFECT_TYPE_VISUALEFFECT
		&& GetEffectInteger(eEffect, 0) == VFX_DUR_CUTSCENE_INVISIBILITY)
        {
			RemoveEffect(oObject, eEffect);
		}
		eEffect = GetNextEffect(oObject);
	}
}

// //////////////////////////////////////////////////
// LEG_COMMON_RevealTweeningObjects
// //////////////////////////////////////////////////
void LEG_COMMON_RevealTweeningObjects(object oTarget, int nCount, float fDuration)
{
	int n;
	
	effect eCSI = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY);
    float fInterval = fDuration / nCount;
	string sTag = GetTag(oTarget);

    // NOTE: that for GetObjectByTag purposes the original object starts as nNth = 0 but is pushed
    // down the stack until nNth = nCount and the last tweening object (i.e. the one we want to 
    // persist) becomes nNth = 0
	object oObjA;
	object oObjB;
    for(n = 0; n < nCount; n++)
	{
		oObjA = GetObjectByTag(sTag, n + 1);
		oObjB = GetObjectByTag(sTag, n);
		
		// hide the previous object and reveal the next
		DelayCommand(fInterval * (nCount - n), ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCSI, oObjA));
		DelayCommand(fInterval * (nCount - n), LEG_COMMON_RemoveCutsceneInvisibility(oObjB));
		//DelayCommand(fInterval * (nCount - n), AssignCommand(oObjA, SpeakString("Invisible")));
		//DelayCommand(fInterval * (nCount - n), AssignCommand(oObjB, SpeakString("Visible")));
	}
}

// //////////////////////////////////////////////////
// LEG_COMMON_MovePlaceableToLocation
// //////////////////////////////////////////////////
void LEG_COMMON_MovePlaceableToLocation(object oPlaceable, location lDestination, int nSteps, float fDelay, float fDuration, object oSound=OBJECT_INVALID, float fFacing = -1.0)
{
    // create, reveal and destroy all the tweening objects
	LEG_COMMON_CreateTweeningObjects(oPlaceable, nSteps, GetPositionFromLocation(lDestination), fFacing);
	DelayCommand(fDelay, LEG_COMMON_RevealTweeningObjects(oPlaceable, nSteps, fDuration));
	DelayCommand(fDelay + fDuration + 1.0, LEG_COMMON_DestroyTweeningObjects(oPlaceable, nSteps));

    // start and stop the sound object (if appropriate)
	if(GetIsObjectValid(oSound))
	{
		DelayCommand(fDelay, SoundObjectPlay(oSound));
		DelayCommand(fDelay + fDuration, SoundObjectStop(oSound));
	}
}

// //////////////////////////////////////////////////
// LEG_COMMON_MovePlaceableToObject
// //////////////////////////////////////////////////
void LEG_COMMON_MovePlaceableToObject(object oPlaceable, object oDestination, int nSteps, float fDelay, float fDuration, object oSound=OBJECT_INVALID)
{
    LEG_COMMON_MovePlaceableToLocation(oPlaceable, GetLocation(oDestination), nSteps, fDelay, fDuration, oSound);
}

void LEG_COMMON_ForceFacing(float fDesiredFacing, object oObject = OBJECT_SELF)
{
	// MV Legends: Sometime SetFacing doesn't work.  This is an extra kick
	float fRadiusX, fRadiusY;
	fRadiusX = 5.0 * cos(fDesiredFacing);
	fRadiusY = 5.0 * sin(fDesiredFacing);
	vector vTarget = Vector(fRadiusX, fRadiusY);
	
	int iObjType = GetObjectType(oObject);
	if (iObjType == OBJECT_TYPE_CREATURE) ActionDoCommand(SetFacingPoint(GetPosition(oObject) + vTarget));
	else SetFacingPoint(GetPosition(oObject) + vTarget);
}

int LEG_COMMON_Round(int iNumber, int iNearest)
{
	int iHalf = iNearest / 2;
	return iNumber + iHalf - ((iNumber + iHalf) % iNearest);
}