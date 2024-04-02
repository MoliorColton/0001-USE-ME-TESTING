//-----------------------------------------------------------------------
// <copyright file="death_lootchest.nss" company="Molior RS">
// Copyright (c) Molior RS. All rights reserved.
// </copyright>
// <revision> 1 </revision>
// <lasteditedby>Austin Jensen</lasteditedby>
//-----------------------------------------------------------------------
void main()
{
	object pHost = GetClickingObject();
	if (pHost == GetLocalObject(OBJECT_SELF, "oKiller"))
	{
		ActionUnlockObject(OBJECT_SELF);
	}
}