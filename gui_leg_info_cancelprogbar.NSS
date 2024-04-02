//-----------------------------------------------------------------------
// <copyright file="gui_leg_info_cancelprogbar.nss" company="Molior RS">
// Copyright (c) Molior RS. All rights reserved.
// </copyright>
// <revision> 1 </revision>
// <lasteditedby>Austin Jensen</lasteditedby>
//-----------------------------------------------------------------------
/*

    Script:			This script is used to cancel a repeating progress bar.  Repeating progress bars
					always fire a follow up script that simply re-calls the leg_info_progbar script
					over and over until the LEG_INFO_PROGBARCANCEL variable is set to TRUE.
					This variable can be set to TRUE using the cancel button on the progress bar itself
					or programatically via the follow up script itself.
	Version:		1.00
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		09/13/2012 - 1.00 MV - Initial Release
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	// Set the Cancel Pending variable to TRUE so that progbar follow up
	// scripts know that they should stop re-firing the progbar.
	SetLocalInt(OBJECT_SELF, "LEG_INFO_PROGBARCANCEL", TRUE);
	
	// Send a message to the PC that this will be the last iteration if they happen to be using the Crafting Plugin.
	if (GetLocalInt(OBJECT_SELF, "LEG_CRAFT_CRAFTALL"))
	{
		SendMessageToPC(OBJECT_SELF, "Cancelling Craft.  NOTE that this iteration will complete first.");	
	}		
}