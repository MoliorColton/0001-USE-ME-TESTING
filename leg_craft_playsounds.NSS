/*

    Script:			This plays sounds based on the stored variabled on a tradeskill station or resource.
					Called from the INFO plugin's leg_info_progbar script which is used at the time
					of harvest or craft.
	Version:		1.00
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		09/14/2012 - 1.00 MV - Initial Release
	
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
	// Get the crafting station.
	object oStation = OBJECT_SELF;
	
	int iDuration = GetLocalInt(oStation, "LEG_INFO_ProgBarDuration");
	if (iDuration == 0)
		iDuration = 5;
	
	// Get the sound variables if there are any.
	string sSounds = GetLocalString(oStation, "LEG_CRAFT_Sounds");
	if (sSounds != "")
	{
		// Play some sounds.
		if (sSounds == "Mining")
		{
			int i;
			for (i=0; i < iDuration; i++)
			{
				int randomsound = Random(3);
				randomsound += 1;
				
				DelayCommand(IntToFloat(i+1), PlaySound( "fs_ice_soft"+IntToString(randomsound) ) );
			}
		}		
		else if (sSounds == "Woodcutting")
		{
				int i;
				for (i=0; i < iDuration; i++)
				{
					int randomsound = Random(3);
					randomsound += 1;
					
					DelayCommand(IntToFloat(i+1), PlaySound( "fs_hoof_large"+IntToString(randomsound) ) );
				}
		}
		else if (sSounds == "Smelting")
		{
				DelayCommand(0.5, PlaySound( "as_cv_smithwatr1" ) );
				DelayCommand(2.5, PlaySound( "as_cv_smithwatr2" ) );
		}
		else if (sSounds == "Weaponcraft")
		{
				DelayCommand(1.5, PlaySound( "as_cv_smithhamr1" ) );
		}	
	}
}