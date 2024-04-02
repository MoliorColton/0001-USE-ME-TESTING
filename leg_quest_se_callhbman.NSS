/*

    Script:			This script is used to call the Quest HB Man for special effects.
	Version:		1.0
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		07/17/2015 - 1.0 MV - Initial Release
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
		object oSEMan = GetNearestObjectByTag("legquestheartbeat", OBJECT_SELF);
		ExecuteScript("leg_quest_se_hb", oSEMan);		
}