//-----------------------------------------------------------------------
// <copyright file="gui_tb_magic.nss" company="Molior RS">
// Copyright (c) Molior RS. All rights reserved.
// </copyright>
// <revision> 1 </revision>
// <lasteditedby>Austin Jensen</lasteditedby>
//-----------------------------------------------------------------------
#include "tb_magic"

void main(int spell)
{
	object oPC = OBJECT_SELF;
	//SendMessageToPC(oPC, "<color=white>" + "Spell clicked.");
	//prevent casting spam
	if (GetCommandable(oPC) == 0)
	{
		return;
	}
	
	SetVariables(oPC, spell);
	
	if (GetSkillRank(SKILL_RUNECRAFTING, oPC) < level)
	{
		SendMessageToPC(oPC, "<color=white>" + "You need level "+IntToString(level)+
		" runecrafting to cast that.");
		return;
	}
	
	mindcost = mindcost * PRIMARY_MULTIPLIER;
	bodycost = bodycost * PRIMARY_MULTIPLIER;
	lawcost = lawcost * PRIMARY_MULTIPLIER;
	cosmiccost = cosmiccost * PRIMARY_MULTIPLIER;
	aircost = aircost * SECONDARY_MULTIPLIER;
	earthcost = earthcost * SECONDARY_MULTIPLIER;
	firecost = firecost * SECONDARY_MULTIPLIER;
	watercost = watercost * SECONDARY_MULTIPLIER;
	
	int myminds = GetNumItems(oPC, MIND_TAG);
	int mybodys = GetNumItems(oPC, BODY_TAG);
	int mylaws = GetNumItems(oPC, LAW_TAG);
	int mycosmics = GetNumItems(oPC, COSMIC_TAG);
	int myairs = GetNumItems(oPC, AIR_TAG);
	int myearths = GetNumItems(oPC, EARTH_TAG);
	int myfires = GetNumItems(oPC, FIRE_TAG);
	int mywaters = GetNumItems(oPC, WATER_TAG);
	
	int cancast = 1;
	cancast = (myminds >= mindcost);
	cancast = (mybodys >= bodycost && cancast != 0);
	cancast = (mylaws >= lawcost && cancast != 0);
	cancast = (mycosmics >= cosmiccost && cancast != 0);
	cancast = (myairs >= aircost && cancast != 0);
	cancast = (myearths >= earthcost && cancast != 0);
	cancast = (myfires >= firecost && cancast != 0);
	cancast = (mywaters >= watercost && cancast != 0);
	if (!cancast)
	{
		string castcheck;
		castcheck += (0 < mindcost) ? IntToString(mindcost)+" mind; " : "";
		castcheck += (0 < bodycost) ? IntToString(bodycost)+" body; " : "";
		castcheck += (0 < lawcost) ? IntToString(lawcost)+" law; " : "";
		castcheck += (0 < cosmiccost) ? IntToString(cosmiccost)+" cosmic; " : "";
		castcheck += (0 < aircost) ? IntToString(aircost)+" air; " : "";
		castcheck += (0 < earthcost) ? IntToString(earthcost)+" earth; " : "";
		castcheck += (0 < firecost) ? IntToString(firecost)+" fire; " : "";
		castcheck += (0 < watercost) ? IntToString(watercost)+" water; " : "";
		
		return;
	}
	//SendMessageToPC(oPC, "<color=white>" + "Ping.");
	if (enchantment != "")
	{
		SetLocalString(oPC, "enchantment", enchantment);
		AssignCommand(oPC, ActionStartConversation(oPC, "enchant", TRUE, FALSE));
	}
	else if (teleportTag != "") 
	{
		TakeRunes(oPC);
		Teleport(oPC, teleportTag);
	}
}