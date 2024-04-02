//-----------------------------------------------------------------------
// <copyright file="gui_tb_quest_acceptquest.nss" company="Molior RS">
// Copyright (c) Molior RS. All rights reserved.
// </copyright>
// <revision> 1 </revision>
// <lasteditedby>Austin Jensen</lasteditedby>
//-----------------------------------------------------------------------
#include "tb_questinclude"
#include "tb_persistents"
void main()
{
	//Get our favorite characters
	object oPC = OBJECT_SELF;
	SetCommandable(1, oPC);
	object oNPC = GetLocalObject(OBJECT_SELF, "QNPC");
	string questTag = GetLocalString(oNPC, "questTag"+IntToString(GetLocalInt(oPC, "curQuestID")));
	//Increase the journal variable
	//SendMessageToPC(oPC, questTag+"Quest step: " + IntToString(GetLocalInt(oPC, questTag)));
	//Triston save persistent quest
	TBSetPersistentInt(oPC, questTag, 1);
	//SendMessageToPC(oPC, questTag+"Quest step: " + IntToString(GetLocalInt(oPC, questTag)));
	// Tell our hearty adventurer what we've just done.
	LEG_COMMON_DisplayInfoBox(oPC, "Accepted New Quest");// + sQuestType);
	//TRISTON MOLIOR 2/21/16 open quest accepted convo if there is one
	DelayCommand(0.8, DeleteLocalString(oPC, "convAccepted")); //don't need it stored, used or not.
	//SendMessageToPC(oPC, "Running accepted convo for Quest:"+GetLocalString(oPC, "convAccepted")+"=="+questTag+"; NPC: " + GetName(oNPC) + " oPC: "+GetName(oPC));
	if (GetLocalString(oPC, "convAccepted") == questTag)
	{
		ClearAllActions();
		ActionStartConversation(oNPC);
	}
	/*
	string onAcceptConvo = GetLocalString(oPC, "convAccepted");
	//SendMessageToPC(oPC, onAcceptConvo);
	if (onAcceptConvo != "")
	{
		//SendMessageToPC(oPC, "<color=white>" + "Now firing the afteraccept convo: " + onAcceptConvo);
		AssignCommand(oPC, ClearAllActions());
		AssignCommand(oPC, ActionStartConversation(oNPC, onAcceptConvo));
		DeleteLocalString(oPC, "convAccepted");
		DeleteLocalString(oPC, "itemAccepted");
	}
	*/
	string onAcceptItem = GetLocalString(oPC, "itemAccepted");
	if (onAcceptItem != "")
	{
		CreateItemOnObject(onAcceptItem, oPC);
	}
	PlaySound("gui_journaladd");
}