//-----------------------------------------------------------------------
// <copyright file="gui_tb_quest_finishquest.nss" company="Molior RS">
// Copyright (c) Molior RS. All rights reserved.
// </copyright>
// <revision> 1 </revision>
// <lasteditedby>Austin Jensen</lasteditedby>
//-----------------------------------------------------------------------
#include "tb_quest_progressquest"
// //////////////////////////////////////////////////
// LEG_COMMON_DisplayInfoBox
// //////////////////////////////////////////////////
void GiveRewards(object oPC, string questTag);
void main(string message)
{
	object oPC = OBJECT_SELF;
	object oNPC = GetLocalObject(OBJECT_SELF, "QNPC");
	string questTag = GetLocalString(oNPC, "questTag"+IntToString(GetLocalInt(oPC, "curQuestID")));
	SetCommandable(1, oPC);
	FinishQuest(oPC, questTag);
}