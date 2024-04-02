//-----------------------------------------------------------------------
// <copyright file="close_oo.nss" company="Molior RS">
// Copyright (c) Molior RS. All rights reserved.
// </copyright>
// <revision> 1 </revision>
// <lasteditedby>Austin Jensen</lasteditedby>
//-----------------------------------------------------------------------
void main()
{
object oDoor = OBJECT_SELF;
ActionWait (15.0);
ActionCloseDoor (oDoor);
}