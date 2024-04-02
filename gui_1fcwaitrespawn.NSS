
void ProperRespawnLoop(object oPC)
{
	if (GetIsDead(oPC) == FALSE) return;
	DisplayMessageBox(oPC, -1, "You have died.", "gui_1fcrespawn", "gui_1fcwaitrespawn", TRUE, "SCREEN_MESSAGEBOX_DEFAULT", -1, "Respawn", -1, "Wait");
}

void main()
{
	object oPC = OBJECT_SELF;
	SendMessageToPC(oPC, "You will be asked again to respawn or not in 1 minute, if you're still dead by then. DEBUG");
	DelayCommand(60.0, ProperRespawnLoop(oPC));
}