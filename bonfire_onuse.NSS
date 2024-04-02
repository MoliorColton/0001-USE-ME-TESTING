void main(object oPC)

{
	if (GetLocalInt(OBJECT_SELF, "EXTINCT") == FALSE)
	CloseGUIScreen(GetLastUsedBy(), "SCREEN_INVENTORY"); 
	DisplayGuiScreen(GetLastUsedBy(), "OVENMENU", FALSE, "ovenorfire.xml");
}