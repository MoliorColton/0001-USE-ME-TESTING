//-----------------------------------------------------------------------
// <copyright file="grave_onclose.nss" company="Molior RS">
// Copyright (c) Molior RS. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------

void main()
{
	int nITEM;
	object oINVALID = OBJECT_INVALID;
	object oGRAVE = OBJECT_SELF;
	object oITEM = GetFirstItemInInventory(oGRAVE);
	while (oITEM != oINVALID)
	{
		nITEM = nITEM + 1;
		oITEM = GetNextItemInInventory(oGRAVE);
	}
	if (nITEM > 0) return;
	SetIsDestroyable(TRUE, FALSE);
	DestroyObject(oGRAVE);
}