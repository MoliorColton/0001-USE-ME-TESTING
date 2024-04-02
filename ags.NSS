//-----------------------------------------------------------------------
// <copyright file="ags.nss" company="Molior RS">
// Copyright (c) Molior RS. All rights reserved.
// </copyright>
// <revision> 1 </revision>
// <lasteditedby>Austin Jensen</lasteditedby>
//-----------------------------------------------------------------------
#include "ginc_wp"
void main()
{
int iCurrentWP = GetCurrentWaypoint();
PlayCustomAnimation(OBJECT_SELF, "c2h_1attack04", 1);
}