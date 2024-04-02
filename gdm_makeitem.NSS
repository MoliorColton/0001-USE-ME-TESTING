//-----------------------------------------------------------------------
// <copyright file="gdm)makeitem.nss" company="Molior RS">
// Copyright (c) Molior RS. All rights reserved.
// </copyright>
// <revision> 1 </revision>
// <lasteditedby>Austin Jensen</lasteditedby>
//-----------------------------------------------------------------------
// gdm_makeitem
/*
    create item from specified blueprint.

    This script for use in normal conversation
*/
// ChazM 11/13/05

#include "gdm_inc"

void main(int count)
{
    string sResRef = GetStringParam();
    object oPC = GetPCSpeaker();
    object oItem;
	int ix;
	for (ix = 0; ix < count; ix++)
	{
		oItem = CreateItemOnObject(sResRef, oPC, 1, "", 0);
	    if (!GetIsObjectValid(oItem))
	        SpeakString("Item blueprint not found.");
	}
}