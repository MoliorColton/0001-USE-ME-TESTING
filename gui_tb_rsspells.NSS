//-----------------------------------------------------------------------
// <copyright file="gui_tb_rsspells.nss" company="Molior RS">
// Copyright (c) Molior RS. All rights reserved.
// </copyright>
// <revision> 1 </revision>
// <lasteditedby>Austin Jensen</lasteditedby>
//-----------------------------------------------------------------------
/*
	Disabled button style Brightness -100, Contrast -50, Hue/Sat Lightness -50
*/
#include "tb_magic"
#include "tb_skillsandxp"
void main()
{
	object oPC = OBJECT_SELF;
	SendMessageToPC(oPC, "gui_tb_rsspells: Spells clicked");
	
	int ix;
	for (ix = 0; ix < 99; ix++)
	{
		SetVariables(oPC, ix);
		if (level > 0){SendMessageToPC(oPC, "gui_tb_rsspells "+spellname+" level: "+IntToString(level));}
		if (GetSkillRank(SKILL_RUNECRAFTING, oPC) < level)
		{
			SetLocalGUIVariable(oPC, "SCREEN_CUSTOM_RSSPELLS", ix, "disabled");
		}
	}
	//SetGUIObjectDisabled
}