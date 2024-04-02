void ReallyPlayCustomAnimation(object oPC, string sANIM, int nLOOP, float fSPEED = 1.0f)
{
	PlayCustomAnimation(oPC, sANIM, nLOOP, fSPEED);
}

void main()
{
	object oCHAIR = OBJECT_SELF;
	object oPC = GetLastUsedBy();
	float fDIR = GetFacing(oCHAIR) + GetLocalFloat(oCHAIR, "DEGREES");
	if (fDIR >= 360.0) fDIR = fDIR - 360.0;
	AssignCommand(oPC, JumpToObject(oCHAIR));
	AssignCommand(oPC, ReallyPlayCustomAnimation(oPC, "sitidle", TRUE));
	DelayCommand(0.1, AssignCommand(oPC, SetFacing(fDIR)));
}