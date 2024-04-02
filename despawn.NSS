//-----------------------------------------------------------------------
// <copyright file="despawn.nss" company="Molior RS">
// Copyright (c) Molior RS. All rights reserved.
// </copyright>
// <revision> 1 </revision>
// <lasteditedby>Austin Jensen</lasteditedby>
//-----------------------------------------------------------------------
// despawn(float delay)
/*
	Destroys object
	
	Parameters:
		float delay = Time before destroyed
*/
// Feb 10 2015
// @Triston Barker

void PrepForDestruction(object oTarget)
{
	SetPlotFlag(oTarget,FALSE);
    SetImmortal(oTarget,FALSE);
    AssignCommand(oTarget,SetIsDestroyable(TRUE,FALSE,FALSE));
}
// Destroy self object
void DestroyMe(object oObject)
{
	PrepForDestruction(oObject);
	DestroyObject (oObject);
}
void main(float delay)
{
		//GetObjectType(object oTarget);
	//set location
	DelayCommand(delay,DestroyMe(OBJECT_SELF));
}