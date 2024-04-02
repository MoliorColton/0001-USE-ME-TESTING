//-----------------------------------------------------------------------
// <copyright file="gui_leg_craft_recipedetail.nss" company="Molior RS">
// Copyright (c) Molior RS. All rights reserved.
// </copyright>
// <revision> 1 </revision>
// <lasteditedby>Austin Jensen</lasteditedby>
//-----------------------------------------------------------------------
/*

    Script:			Script that is called when the PC clicks on one of the items in a recipe learning
					GUI. It will give detailed information in the GUI about the item recipe would make
					as well as show the final result in an examine window should an Item Viewer
					waypoint be placed.
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
void main(int iCraftChoice)
{
	// Get the Crafting Station
	object oStation = GetLocalObject(OBJECT_SELF, "CNPC");

	// Go through our Item Rewards table and get the RESREF of the reward the PC has selected.
	string sItemRef = LEG_COMMON_GetArrayElement(GetModule(), "arRecipeRef", iCraftChoice);
	
	// Temporarily create the item at the Item Viewer waypoint in the current area.  All areas that have
	// quest FINISHERS that hand out items will need to have an Item Viewer waypoint in them.  The
	// waypoint should be obscured so PC's will not see randomly appearing and disappearing items.
	object oItem = CreateObject(OBJECT_TYPE_ITEM, sItemRef, GetLocation(GetNearestObjectByTag("leg_craft_itemviewer")));
	
	//SpeakString("Craft ID: " + IntToString(iCraftChoice), TALKVOLUME_SHOUT);
	//SpeakString("ResRef: " + sItemRef, TALKVOLUME_SHOUT);
	
	if (GetIsObjectValid(oItem))
	{
		// Display the information box of the item.
		DelayCommand(1.0, ActionExamine(oItem));
		
		// Get rid of it.
		DestroyObject(oItem, 2.0);		
	}
	
	// Next we populate the details panel of the GUI with useful information such as the recipie itself, how many
	// a PC could make, and perhaps the chance for success?
	object oModule = GetModule();
	string sName = LEG_COMMON_GetArrayElement(oModule, "arRecipeName", iCraftChoice);
	string sSkill = LEG_COMMON_GetArrayElement(oModule, "arRecipeSkill", iCraftChoice);
	string sIcon = LEG_COMMON_GetArrayElement(oModule, "arRecipeIcon", iCraftChoice);
	string sIng1Name = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng1Name", iCraftChoice);
	string sIng1 = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng1", iCraftChoice);
	string sIng1Qty = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng1Qty", iCraftChoice);
	string sIng2Name = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng2Name", iCraftChoice);
	string sIng2 = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng2", iCraftChoice);
	string sIng2Qty = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng2Qty", iCraftChoice);
	string sIng3Name = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng3Name", iCraftChoice);
	string sIng3 = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng3", iCraftChoice);
	string sIng3Qty = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng3Qty", iCraftChoice);
	string sIng4Name = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng4Name", iCraftChoice);
	string sIng4 = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng4", iCraftChoice);
	string sIng4Qty = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng4Qty", iCraftChoice);
	string sIng5Name = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng5Name", iCraftChoice);
	string sIng5 = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng5", iCraftChoice);
	string sIng5Qty = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng5Qty", iCraftChoice);
	string sIng6Name = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng6Name", iCraftChoice);
	string sIng6 = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng6", iCraftChoice);
	string sIng6Qty = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng6Qty", iCraftChoice);
	string sIng7Name = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng7Name", iCraftChoice);
	string sIng7 = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng7", iCraftChoice);
	string sIng7Qty = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng7Qty", iCraftChoice);
	string sIng8Name = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng8Name", iCraftChoice);
	string sIng8 = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng8", iCraftChoice);
	string sIng8Qty = LEG_COMMON_GetArrayElement(oModule, "arRecipeIng8Qty", iCraftChoice);
	string sMin = LEG_COMMON_GetArrayElement(oModule, "arRecipeMin", iCraftChoice);
	string sMax = LEG_COMMON_GetArrayElement(oModule, "arRecipeMax", iCraftChoice);
	string sMinQty = LEG_COMMON_GetArrayElement(oModule, "arRecipeMinQty", iCraftChoice);
	string sMaxQty = LEG_COMMON_GetArrayElement(oModule, "arRecipeMaxQty", iCraftChoice);
	string sCost = LEG_COMMON_GetArrayElement(oModule, "arRecipeCost", iCraftChoice);
	string sGold = LEG_COMMON_GetArrayElement(oModule, "arRecipeGold", iCraftChoice);	
	string sSpellID = LEG_COMMON_GetArrayElement(oModule, "arRecipeSpellIng", iCraftChoice);
	string sSpellName = LEG_COMMON_GetArrayElement(oModule, "arRecipeSpellName", iCraftChoice);
	string sSpellID2 = LEG_COMMON_GetArrayElement(oModule, "arRecipeSpellIng2", iCraftChoice);
	string sSpellName2 = LEG_COMMON_GetArrayElement(oModule, "arRecipeSpellName2", iCraftChoice);
	string sSpellGate = LEG_COMMON_GetArrayElement(oModule, "arRecipeSpellGate", iCraftChoice);	
	
	// Get some stats for display purposes.
	int iSkill = StringToInt(sSkill);
    int iPCSkill = LEG_CRAFT_GetPCSkill(OBJECT_SELF, iSkill);
	int iMin = StringToInt(sMin);
	int iMax = StringToInt(sMax);
	int iChance = LEG_CRAFT_GetSkillChance(iSkill, iMin, iMax, iPCSkill);
	string sRating = LEG_CRAFT_GetPercentColor(IntToFloat(iChance / 100));
	string sSkillLevel = LEG_CRAFT_GetSkillLevelName(OBJECT_SELF, iSkill);
	string sSkillLevelColor = LEG_CRAFT_GetSkillLevelName(OBJECT_SELF, iSkill, TRUE);
	string sQtyColor;

	// Now we're going to find out how many of each ingredient is in the PC's inventory and display that.		
	int iMyQty1 = LEG_COMMON_GetInventoryCount(OBJECT_SELF, sIng1);
	if (iMyQty1 < StringToInt(sIng1Qty))
		sQtyColor = "<color=#FF0000>";
	else
		sQtyColor = "<color=#00FF00>";
	string sMainText = sIng1Qty + " x " + sIng1Name + " (" + sQtyColor + IntToString(iMyQty1) + "</color>)\n";
	if (sIng2Qty != "#OUTOFBOUNDS#" && sIng2Qty != "")
	{
		int iMyQty2 = LEG_COMMON_GetInventoryCount(OBJECT_SELF, sIng2);
		if (iMyQty2 < StringToInt(sIng2Qty))
			sQtyColor = "<color=#FF0000>";
		else
			sQtyColor = "<color=#00FF00>";
		sMainText = sMainText + sIng2Qty + " x " + sIng2Name + " (" + sQtyColor + IntToString(iMyQty2) + "</color>)\n";
	}
	if (sIng3Qty != "#OUTOFBOUNDS#" && sIng3Qty != "")
	{
		int iMyQty3 = LEG_COMMON_GetInventoryCount(OBJECT_SELF, sIng3);
		if (iMyQty3 < StringToInt(sIng3Qty))
			sQtyColor = "<color=#FF0000>";
		else
			sQtyColor = "<color=#00FF00>";
		sMainText = sMainText + sIng3Qty + " x " + sIng3Name + " (" + sQtyColor + IntToString(iMyQty3) + "</color>)\n";
	}
	if (sIng4Qty != "#OUTOFBOUNDS#" && sIng4Qty != "")
	{
		int iMyQty4 = LEG_COMMON_GetInventoryCount(OBJECT_SELF, sIng4);
		if (iMyQty4 < StringToInt(sIng4Qty))
			sQtyColor = "<color=#FF0000>";
		else
			sQtyColor = "<color=#00FF00>";
		sMainText = sMainText + sIng4Qty + " x " + sIng4Name + " (" + sQtyColor + IntToString(iMyQty4) + "</color>)\n";
	}
	if (sIng5Qty != "#OUTOFBOUNDS#" && sIng5Qty != "")
	{
		int iMyQty5 = LEG_COMMON_GetInventoryCount(OBJECT_SELF, sIng5);
		if (iMyQty5 < StringToInt(sIng5Qty))
			sQtyColor = "<color=#FF0000>";
		else
			sQtyColor = "<color=#00FF00>";
		sMainText = sMainText + sIng5Qty + " x " + sIng5Name + " (" + sQtyColor + IntToString(iMyQty5) + "</color>)\n";
	}
	if (sIng6Qty != "#OUTOFBOUNDS#" && sIng6Qty != "")
	{
		int iMyQty6 = LEG_COMMON_GetInventoryCount(OBJECT_SELF, sIng6);
		if (iMyQty6 < StringToInt(sIng6Qty))
			sQtyColor = "<color=#FF0000>";
		else
			sQtyColor = "<color=#00FF00>";
		sMainText = sMainText + sIng6Qty + " x " + sIng6Name + " (" + sQtyColor + IntToString(iMyQty6) + "</color>)\n";
	}
	if (sIng7Qty != "#OUTOFBOUNDS#" && sIng7Qty != "")
	{
		int iMyQty7 = LEG_COMMON_GetInventoryCount(OBJECT_SELF, sIng7);
		if (iMyQty7 < StringToInt(sIng7Qty))
			sQtyColor = "<color=#FF0000>";
		else
			sQtyColor = "<color=#00FF00>";
		sMainText = sMainText + sIng7Qty + " x " + sIng7Name + " (" + sQtyColor + IntToString(iMyQty7) + "</color>)\n";
	}
	if (sIng8Qty != "#OUTOFBOUNDS#" && sIng8Qty != "")
	{
		int iMyQty8 = LEG_COMMON_GetInventoryCount(OBJECT_SELF, sIng8);
		if (iMyQty8 < StringToInt(sIng8Qty))
			sQtyColor = "<color=#FF0000>";
		else
			sQtyColor = "<color=#00FF00>";
		sMainText = sMainText + sIng8Qty + " x " + sIng8Name + " (" + sQtyColor + IntToString(iMyQty8) + "</color>)\n";
	}
	if (sSpellName != "#OUTOFBOUNDS#" && sSpellName != "")
	{
		int iSpellQty = GetHasSpell(StringToInt(sSpellID), OBJECT_SELF);
		if (iSpellQty < 1)
			sQtyColor = "<color=#FF0000>";
		else
			sQtyColor = "<color=#00FF00>";
		sMainText = sMainText + "1 x Spell: " + sSpellName + " (" + sQtyColor + IntToString(iSpellQty) + "</color>)\n";
	}
	
	if (sSpellGate != "")
	{
		sMainText = sMainText + " " + GetStringUpperCase(sSpellGate) + "\n";
		if (sSpellName2 != "#OUTOFBOUNDS#" && sSpellName2 != "")
		{
			int iSpellQty = GetHasSpell(StringToInt(sSpellID2), OBJECT_SELF);
			if (iSpellQty < 1)
				sQtyColor = "<color=#FF0000>";
			else
				sQtyColor = "<color=#00FF00>";
			sMainText = sMainText + "1 x Spell: " + sSpellName2 + " (" + sQtyColor + IntToString(iSpellQty) + "</color>)\n";
		}
	}
	
	if (sGold != "")
	{
		int iPCGold = GetGold(OBJECT_SELF);
		if (iPCGold < StringToInt(sGold))
			sQtyColor = "<color=#FF0000>";
		else
			sQtyColor = "<color=#00FF00>";
		
		sMainText = sMainText + sGold + " Gold (" + sQtyColor + IntToString(iPCGold) + ")</color>\n";
	}
	
	
	// Display some information about skill level, how many are possible to make etc.
	sMainText = sMainText + "\n\n";
	if (sMinQty == sMaxQty)
		sMainText = sMainText + "Quantity Created: " + sMinQty + "\n";
	else
		sMainText = sMainText + "Quantity Created: " + sMinQty + "-" + sMaxQty + "\n";
	//sMainText = sMainText + "Chance of Success: " + sRating + IntToString(iChance / 100) + "%</color>\n";
	sMainText = sMainText + "Chance of Success: " + sSkillLevelColor + IntToString(LEG_COMMON_Round(iChance, 100) / 100) + "%</color>\n";
	sMainText = sMainText + "Your Current Skill: " + sSkillLevelColor + sSkillLevel + "</color>\n\n";
	sMainText = sMainText + "Recipe Cost: " + sCost + "\n";
	
	// Put the info we've got together onto the GUI.			
	SetGUIObjectText(OBJECT_SELF, "recipetraining", "title", -1, sName + " Recipe");
	SetGUIObjectText(OBJECT_SELF, "recipetraining", "recipedetails", -1, sMainText);
	
	
	
	
}