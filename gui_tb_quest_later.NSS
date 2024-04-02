//-----------------------------------------------------------------------
// <copyright file="gui_tb_quest_later.nss" company="Molior RS">
// Copyright (c) Molior RS. All rights reserved.
// </copyright>
// <revision> 1 </revision>
// <lasteditedby>Austin Jensen</lasteditedby>
//-----------------------------------------------------------------------
#include "tb_questinclude"
void main()
{
	//Get our favorite characters
	object oPC = OBJECT_SELF;
	SetCommandable(1, oPC);
	DeleteLocalString(oPC, "convAccepted");
	DeleteLocalString(oPC, "itemAccepted");
}