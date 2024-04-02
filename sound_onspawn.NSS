void main()
{
	object oSOUND = OBJECT_SELF;
	string sSOUND = GetTag(oSOUND);
	int n2D = FALSE;
	if (GetStringLeft(sSOUND, 2) == "D_")
	{
		n2D = TRUE;
		sSOUND = GetStringRight(sSOUND, GetStringLength(sSOUND) - 2);
	}
	AssignCommand(oSOUND, PlaySound(sSOUND, n2D));
	AssignCommand(oSOUND, SetIsDestroyable(TRUE, FALSE));
	DestroyObject(oSOUND, 0.5);
}