//-----------------------------------------------------------------------
// <copyright file="death_timelootchest.nss" company="Molior RS">
// Copyright (c) Molior RS. All rights reserved.
// </copyright>
// <revision> 1 </revision>
// <lasteditedby>Austin Jensen</lasteditedby>
//-----------------------------------------------------------------------
void main()
{
	int time = GetLocalInt(OBJECT_SELF, "despawntimer");
	if (time < 10)
	{
		SetLocalInt(OBJECT_SELF, "despawntimer", time+1);
	}
	else
	{
		ExecuteScript("despawn", OBJECT_SELF);
	}
}