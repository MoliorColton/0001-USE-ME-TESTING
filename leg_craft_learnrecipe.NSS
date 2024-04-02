/*

    Script:			Legacy script to teach a recipe based on item or NPC but not using the GUI.  These are
					now in a dedicated Item Activated script and a conversation action node script.
	Version:		1.1
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		06/23/2011 - 1.00 MV - Initial Release
					08/26/2011 - 1.00 MV - RETIRED SCRIPT
					08/17/2013 - 1.1 MV - Fixed bug that caused players with colors or dashes in names to fail database
*/


// /////////////////////////////////////////////////////////////////////////////////////////////////////
// INCLUDES
// /////////////////////////////////////////////////////////////////////////////////////////////////////
#include "leg_craft_include"

void main(int iRecipeID)
{
	SpeakString("NOTE: The script activated here was thought to be retired.  Please communicate this to your server administrator.", TALKVOLUME_SHOUT);

	// Try and get the PC
	object oPC = GetPCSpeaker();
	if (!GetIsObjectValid(oPC))
		oPC = GetItemActivator();
	if (!GetIsObjectValid(oPC))
		oPC = GetLastUsedBy();
	if (!GetIsObjectValid(oPC))
		oPC = GetPlaceableLastClickedBy();
			
	// Find out what the recipe ID is.
	if (iRecipeID == 0 || iRecipeID > LEG_COMMON_GetArrayElementCount(GetModule(), "arRecipeName"))
		iRecipeID = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_RecipeID");
		
	// Get the skill
	int iSkill = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_Skill");
	
	// Do we destroy after use?
	int iDestroyMe = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_DestroyMe");
	
	// Learn!
	string sTableID = LEG_COMMON_GetPCTable(oPC, "knownrecipes");
	string SQL = "INSERT INTO " + sTableID + " (`RecipeID`, `SkillID`) VALUES ('" + IntToString(iRecipeID) + "', '" + IntToString(iSkill) + "');";
	SQLExecDirect(SQL);	

	// Send some info to the PC
	string sRecipeName = LEG_COMMON_GetArrayElement(GetModule(), "arRecipeName", iRecipeID);
	if (GetLocalInt(GetModule(), "LEG_INFO_ACTIVE"))
		LEG_COMMON_DisplayInfoBox(oPC, "Learned to Craft " + sRecipeName);
	else
		FloatingTextStringOnCreature("Learned to Craft " + sRecipeName, oPC, FALSE);
	return;
	
	if (iDestroyMe)
	{
		SetPlotFlag(OBJECT_SELF,FALSE);
		AssignCommand(OBJECT_SELF, SetIsDestroyable(TRUE, FALSE, FALSE));
		DestroyObject(OBJECT_SELF);
	}
}