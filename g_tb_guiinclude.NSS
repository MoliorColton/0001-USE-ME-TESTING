//-----------------------------------------------------------------------
// <copyright file="g_tb_guiinclude.nss" company="Molior RS">
// Copyright (c) Molior RS. All rights reserved.
// </copyright>
// <revision> 1 </revision>
// <lasteditedby>Austin Jensen</lasteditedby>
//-----------------------------------------------------------------------
const float OFF = 0.01f;
void BreakGUI()
{
	object oPC = OBJECT_SELF;
	SetCommandable(0,oPC); //we're running so break gui
	DelayCommand(OFF, SetCommandable(1, oPC));
}
/*
const float OFF = 0.1f;
void BreakGUI()
{
	object oPC = OBJECT_SELF;
	if (GetCommandable(oPC) == 1)
	{//we could already be disabled
		SetCommandable(0,oPC);
		DelayCommand(OFF, SetCommandable(1, oPC));
	}else {SendMessageToPC(oPC, "PC is already not commandable.");}
}*/