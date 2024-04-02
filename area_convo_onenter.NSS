void main()
{
	object oPC = GetEnteringObject();
	if (GetIsPC(oPC) == FALSE) return;
	if (IsInConversation(oPC) == TRUE) return;
	object oAREA = OBJECT_SELF;
	string sCONV = GetLocalString(oAREA, "CONVO");
	AssignCommand(oPC, ActionStartConversation(oPC, sCONV, TRUE, FALSE));
}