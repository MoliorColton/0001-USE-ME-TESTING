void main()
{
	if (GetLastRestEventType() != REST_EVENTTYPE_REST_FINISHED) return;
	object oPC = GetLastPCRested();
	SendMessageToPC(oPC, "Character Saved.");
	DelayCommand(0.0f, ExportSingleCharacter(oPC));
}