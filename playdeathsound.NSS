// Creates an iPoint at the location of the currently controlled character.
// A sound file is then played off of that iPoint before destroying it. 

void main()
{
	object oPC = GetFirstPC(FALSE);
	object oIP = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_ipoint ", GetLocation(oPC));
								//	do not remove this space	^ 	
	string sWave = "Oh_dear21";	// <--- sound file name

	DelayCommand(0.2f, AssignCommand(oIP, PlaySound(sWave, TRUE)));	
	SetPlotFlag(oIP, FALSE);
	DestroyObject(oIP, 0.3f);	
}