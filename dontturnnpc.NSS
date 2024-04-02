//-----------------------------------------------------------------------
// <copyright file="dontturnnpc.nss" company="Molior RS">
// Copyright (c) Molior RS. All rights reserved.
// </copyright>
// <revision> 1 </revision>
// <lasteditedby>Austin Jensen</lasteditedby>
//-----------------------------------------------------------------------
void main()
{
object oTarget = GetObjectByTag("tag_of_npc_statue");
AssignCommand(oTarget, SetFacing (90.0f));
}