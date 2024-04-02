/*

    Script:			This is the MASTER on load script.  It is primarily used for dungeon instances but
					can be used for other things if we ever come up with something to use for it.
	Version:		1.1
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		None
	
	Change Log:		10/08/2012 - 1.0 MV - Initial Release
					10/12/2012 - 1.1 MV - Found with large recipe databases, craft gets bumped and they won't all get loaded.
										  So moved the recipe loads to here.

*/

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	object oModule = GetModule();
	DelayCommand(0.0f, PackCampaignDatabase("bank_items"));
	
	
	// Check for the Tele Plugin and fire its script if it is.
	if (GetLocalInt(GetModule(), "LEG_TELE_ACTIVE"))
	{
		ExecuteScriptEnhanced("leg_tele_modonload", oModule);		
	}	

	// Check for the Tele Plugin and fire its script if it is.
	if (GetLocalInt(GetModule(), "LEG_CRAFT_ACTIVE"))
	{
		ExecuteScriptEnhanced("leg_craft_init", oModule);		
	}	
}