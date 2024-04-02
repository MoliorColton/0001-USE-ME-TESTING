//-----------------------------------------------------------------------
// <copyright file="gui_tb_quest_journaldetail.nss" company="Molior RS">
// Copyright (c) Molior RS. All rights reserved.
// </copyright>
// <revision> 1 </revision>
// <lasteditedby>Austin Jensen</lasteditedby>
//-----------------------------------------------------------------------
#include "tb_questinclude"
#include "tb_questbook"
#include "tb_persistents"

void main(string sQuestNum)
{
	oPC = OBJECT_SELF;
	SetLocalInt(oPC, "qSelected", StringToInt(sQuestNum));
	//SendMessageToPC(oPC, "saving box"+sQuestNum);
	//SendMessageToPC(oPC, "tile selected " + sQuestNum);
	sGUI = GetLocalString(oPC, "SGUI");
	int iQNum = StringToInt(sQuestNum)+1;//GetLocalInt(oPC, "QBOXSELECTED");
	//SendMessageToPC(oPC, "n: " + IntToString(iQNum) + " s: " + sQuestNum);
	playerstep = TBGetPersistentInt(oPC, QIDToTag(iQNum), 1);
	//SendMessageToPC(oPC, QIDToTag(iQNum)+"_journal found " + IntToString(playerstep));
	RunQBook(QIDToTag(iQNum));
	//KillCount("crat");
	//SendMessageToPC(oPC, "n: " + IntToString(iQNum) + " s: " + sTitle);
	sQIcon = sQIcon;
	string sCompleted;
	if (playerstep == 999) 
	{
		SetLocalInt(oPC, "compdQs", GetLocalInt(oPC, "compdQs")+1);
		sCompleted = "Quest Complete!\n";
		sQIcon = sCompletedIcon;
	}
	//questReqs = (questReqs == "") ? sObjectives : questReqs;
	// Set New Screen details
	//SendMessageToPC(oPC, "journ: " + sJournalText);
	questReqs += (showObj == 0 || showObj == 2) ? sObjectives : "";
	string sqdiff = "Difficulty: "+GetStringUpperCase(questDifficulty)+"\n\n";
	SetGUIObjectText(oPC, sGUI, "title", -1, sTitle);
	SetGUIObjectText(oPC, sGUI, "questdetails", -1, sJournalText);
	SetGUIObjectText(oPC, sGUI, "REWARDS", -1, sqdiff+sCompleted+questReqs);					
	SetGUITexture(oPC, sGUI, "TYPE1", sQIcon);						
	SetGUITexture(oPC, sGUI, "TYPE2", sQIcon);
}