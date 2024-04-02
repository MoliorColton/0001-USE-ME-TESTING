void main()
{
	object oPC = GetItemActivator();
	SetCommandable(1, oPC);
	int iQuestID = 1007;
	int qprog = GetLocalInt(oPC, "QuestID_" + IntToString(iQuestID) + "_NPC");
	SendMessageToPC(oPC, "Blood Ritual Progress: " + IntToString(qprog));
	SendMessageToPC(oPC, "Tut Island Progress: " + IntToString(GetLocalInt(oPC, "qtutorialisland")));
	CreateItemOnObject("anchovy", oPC, 1);
	CreateItemOnObject("thickskin", oPC, 1);
	CreateItemOnObject("bronzedagger", oPC, 1);
	CreateItemOnObject("runedagger", oPC, 1);
	CreateItemOnObject("flyfishingrod", oPC, 1);
}