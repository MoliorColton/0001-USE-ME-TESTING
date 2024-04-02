/*

    Script:			This main include for the INFO PLUGIN.  As there are not many functions, this script
					is quite small however it does offer the configuration options for the INFO PLUGIN and
					thus exists to follow the Legends Plugin Standards.
	Version:		1.1
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		12/20/2010 - 1.00 MV - Initial Release
					06/19/2015 - 1.1 MV - Added new Skill Show function
	
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// USER CONFIGURABLE CONSTANTS
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_info_constants"

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_all_masterinclude"


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// FUNCTIONS
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void LEG_INFO_ShowSkillOnSuccess(object oPC, int iSkillCheck, int iSkillDC)
{
	if (GetLocalInt(OBJECT_SELF, "LEG_INFO_ShowSkillOnSuccess") && iSkillDC)
	{
		float x = 0.0, y = 0.0, z = 1.0;
		vector vText = Vector(x,y,z);
		FloatingTextStringOnCreature(LEG_COMMON_SkillToText(iSkillCheck) + " Check Successful", oPC, FALSE, 5.0, 4294967295, 4294967295, 0.2, vText);
	}
}