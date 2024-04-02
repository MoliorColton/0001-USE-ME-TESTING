/*

    Script:			Used on the Action node of a conversation, this script will check to see if the
					Give Training book configuration option is active and if so, provides the PC with
					a training book for a particular skill.  The book resref is stored in a variable
					on the NPC.
	Version:		1.00
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		06/23/2011 - 1.00 MV - Initial Release
	
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_craft_include"


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	// Only give out books if we're configured to do so.
	if (!TRAININGBOOKS)
		return;
		
	// Get the PC
	object oPC = GetPCSpeaker();
	
	// First get the item we need to give
	string sBook = GetLocalString(OBJECT_SELF, "LEG_CRAFT_TrainingBook");
	
	// Give!
	LEG_COMMON_CreateItem(oPC, sBook, 1);


}