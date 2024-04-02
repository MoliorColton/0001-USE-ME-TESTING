/*

    Script:			This is the MASTER item activated script for the module event.  Used for quest tools
					on targets and other items such as camping kits etc.
	Version:		1.7
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		None
	
	Change Log:		12/29/2010 - 1.00 MV - Initial Release
					06/22/2011 - 1.01 MV - Added support for Rest Plugin
					07/17/2011 - 1.02 MV - Added support for Secret Plugin
					08/24/2011 - 1.03 MV - Added support for Craft Plugin
					11/01/2012 - 1.4 MV - Added support for Misc Plugin
					11/15/2012 - 1.5 MV - Added support for Teleport Plugin
					11/19/2012 - 1.6 MV - Converted Secret to Spawn
					05/13/2015 - 1.7 MV - Added Time plugin support

*/

// /////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN ROUTINE
// /////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	// Let's get the Item, the person that activated etc.
	object oItem = GetItemActivated();
	object oPC = GetItemActivator();
	location lLoc = GetItemActivatedTargetLocation();
	object oArea = GetArea(oPC);
	object oTarget = GetItemActivatedTarget();
	string sItemTag = GetTag(oItem);

	// As long as we're a playah.
	if (GetIsPC(oPC))
	{
		// Check for the Quest Plugin and fire its script if it is.
		if (GetLocalInt(GetModule(), "LEG_QUEST_ACTIVE"))
		{
			AddScriptParameterObject(oPC);
			AddScriptParameterObject(oItem);
			AddScriptParameterObject(oTarget);
			ExecuteScriptEnhanced("leg_quest_itemactivated", oPC);		
		}
		
		// Check for the Rest Plugin and fire its script if it is.
		if (GetLocalInt(GetModule(), "LEG_WORLD_ACTIVE"))
		{
			AddScriptParameterObject(oPC);
			AddScriptParameterObject(oItem);
			ExecuteScriptEnhanced("leg_world_itemactivated", oPC);		
		}
		
		// Check for the Secret Plugin and fire its script if it is.
		if (GetLocalInt(GetModule(), "LEG_SPAWN_ACTIVE"))
		{
			AddScriptParameterObject(oPC);
			AddScriptParameterObject(oItem);
			ExecuteScriptEnhanced("leg_spawn_itemactivated", oPC);		
		}

		// Check for the Secret Plugin and fire its script if it is.
		if (GetLocalInt(GetModule(), "LEG_CRAFT_ACTIVE"))
		{
			AddScriptParameterObject(oPC);
			AddScriptParameterObject(oItem);
			ExecuteScriptEnhanced("leg_craft_itemactivated", oPC);		
		}

		// Check for the Misc Plugin and fire its script if it is.
		if (GetLocalInt(GetModule(), "LEG_MISC_ACTIVE"))
		{
			AddScriptParameterObject(oPC);
			AddScriptParameterObject(oItem);
			ExecuteScriptEnhanced("leg_misc_itemactivated", oPC);		
		}						
		// Check for the Teleport Plugin and fire its script if it is.
		if (GetLocalInt(GetModule(), "LEG_TELE_ACTIVE"))
		{
			AddScriptParameterObject(oPC);
			AddScriptParameterObject(oItem);
			ExecuteScriptEnhanced("leg_tele_itemactivated", oPC);		
		}								
		// Check for the Teleport Plugin and fire its script if it is.
		if (GetLocalInt(GetModule(), "LEG_TIME_ACTIVE"))
		{
			AddScriptParameterObject(oPC);
			AddScriptParameterObject(oItem);
			ExecuteScriptEnhanced("leg_time_itemactivated", oPC);		
		}								

		if (sItemTag == "aidebug")
		{
			// For use with AI Debug tool
			AddScriptParameterObject(oPC);
			AddScriptParameterObject(oItem);
			AddScriptParameterObject(oTarget);
			ExecuteScriptEnhanced("ai_test", oPC);		
		}
		else if (sItemTag == "sevars")
		{
			// For use with AI Debug tool
			SpeakString("SE Vars for Area: " + IntToString(GetLocalInt(GetArea(oPC), "QUEST_SE_Flags1")), TALKVOLUME_SHOUT);
		}	
	}
}