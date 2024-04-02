/*

    Script:			Script to call when a harvestable resource is located. Update Progbar to do a check 
					for an inventory item in the PC's hand.  With this, we need to update Progbar to 
					simply run a script and do NO checks or report NO messages about failure if it 
					doesn't do this already.  Success/Failure messages will be handled by this script.  
					That said however we DO want the ProgBar to be able to see if the PC has an item in their 
					hand/inventory before beginning and report a message if they don't.
	Version:		1.1
	Plugin Version: 1.93
	Author:			Marshall Vyper
	Parameters:		N/A
	
	Change Log:		06/23/2011 - 1.00 MV - Initial Release
					09/12/2012 - 1.01 MV - Fixed bug when the Info plugin was active, no tool check occured.
					11/11/2012 - 1.1 MV - Updated Animations
	
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
    // Who clicked on me.
	object oPC = GetLastUsedBy();
	// Add some intelligence so that if the resource is in USE, we don't want other players
	// coming along and using it again.
	if (!GetLocalInt(GetModule(), "LEG_CRAFT_ACTIVE"))
		return;
	
	// If the PC is already actively perform a skill task, or someone else
	// is already harvesting this, don't let them do more.
	if (GetLocalInt(oPC, "SkillInUse") || GetLocalInt(OBJECT_SELF, "SkillInUse"))
		return;
		
	// If the resource is in the process of getting destroyed because it is exhausted then...
	if (GetLocalInt(OBJECT_SELF, "Toast"))
		return;
		
    // Get the tool and method of this resource as well as some other information that could
	// be useful to the PC.
    int iSkill = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_Skill");
    string sMethod = GetLocalString(OBJECT_SELF, "LEG_CRAFT_Skill_Method");
    string sTool = GetLocalString(OBJECT_SELF, "LEG_CRAFT_Skill_Tool");
    int iPCSkill = LEG_CRAFT_GetPCSkill(oPC, iSkill);
    int iMin = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_MinSkill");
    int iMax = GetLocalInt(OBJECT_SELF, "LEG_CRAFT_MaxSkill");
	int iChance = LEG_CRAFT_GetSkillChance(iSkill, iMin, iMax, iPCSkill);
	string sSkillLevelColor = LEG_CRAFT_GetSkillLevelName(oPC, iSkill, TRUE);
	string sSkillLevel = LEG_CRAFT_GetSkillLevelName(oPC, iSkill);

    // Gets the weapon in the right hand slot of the player
    object oWeaponOnPlayer = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	
	// If we are using the INFO Plugin.
	if (GetLocalInt(GetModule(), "LEG_INFO_ACTIVE"))
	{
	    if (GetTag(oWeaponOnPlayer) == sTool)
	    {
			// Give the PC some feedback
			SendMessageToPC(oPC, "Chance of Success: " + sSkillLevelColor + IntToString(iChance / 100) + "%</color>");
			SendMessageToPC(oPC, "Your Current Skill: " + sSkillLevelColor + sSkillLevel + "</color>");
	
			// Perform the Skill
		    LEG_CRAFT_HarvestResource(oPC, OBJECT_SELF);
		
	        // Reduce the durabilities of the resource and the tool.
	        LEG_CRAFT_Durabilities(oPC, oWeaponOnPlayer);
			
			// Let Progbar fire again now that we're done.
			DelayCommand(3.5, SetLocalInt(OBJECT_SELF, "LEG_INFO_IsActive", 0));
		}
	    else
		{
			// If the PC does not have the proper tool equipped, then we will let them know.
			if (GetLocalInt(GetModule(), "LEG_INFO_ACTIVE"))
				LEG_COMMON_DisplayInfoBox(oPC, "YOU MUST EQUIP THE PROPER TOOL FIRST");
			else
		        FloatingTextStringOnCreature("YOU MUST EQUIP THE PROPER TOOL", oPC, FALSE);
		}		
	}
	else
	{
	    // Ensure the player has the appropriate tool equipped.
	    if (GetTag(oWeaponOnPlayer) == sTool)
	    {
			// Give the PC some feedback
			SendMessageToPC(oPC, "Chance of Success: " + sSkillLevelColor + IntToString(iChance / 100) + "%</color>");
			SendMessageToPC(oPC, "Your Current Skill: " + sSkillLevelColor + sSkillLevel + "</color>");
		
			// Once we know mr miner has the right tool equipped, we'll get some set the
			// PC and resource active.  This helps prevent multiple people from harvesting
			// at the same time and prevents the PC to continually click on the resource
			// queuing up harvests.  We want them to work for their loots!!
		    SetLocalInt(oPC, "SkillInUse", TRUE);
			SetLocalInt(OBJECT_SELF, "SkillInUse", TRUE);
		    AssignCommand(oPC, ClearAllActions());
	
			// These are the animations we're going to play during the harvest.
	        if (sMethod == "Bash")
				LEG_COMMON_ActionPlayCustomAnimation(oPC, "shoveling", 0, 5.0);
	            //AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_SHOVELING, 1.0, 5.0));
	        else if (sMethod == "Bend")
				LEG_COMMON_ActionPlayCustomAnimation(oPC, "kneeltalk", 0, 5.0);
	            //AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 5.0));
			
			// Now Release the PC and perform the skill check.		
	        DelayCommand(0.5, SetCommandable(FALSE, oPC));
	        DelayCommand(5.0, LEG_CRAFT_HarvestResource(oPC, OBJECT_SELF));
	
	        // Reduce the durabilities of the resource and the tool.
	        DelayCommand(5.25, LEG_CRAFT_Durabilities(oPC, oWeaponOnPlayer));
	        DelayCommand(5.3, SetCommandable(TRUE, oPC));
	    }
	    else
		{
			// If the PC does not have the proper tool equipped, then we will let them know.
			if (GetLocalInt(GetModule(), "LEG_INFO_ACTIVE"))
				LEG_COMMON_DisplayInfoBox(oPC, "YOU MUST EQUIP THE PROPER TOOL FIRST");
			else
		        FloatingTextStringOnCreature("YOU MUST EQUIP THE PROPER TOOL", oPC, FALSE);
		}
	}

	// The PC is no longer harvesting.
    SetLocalInt(oPC, "SkillInUse", FALSE);
	SetLocalInt(OBJECT_SELF, "SkillInUse", FALSE);
}