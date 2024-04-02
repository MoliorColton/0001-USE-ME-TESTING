//-----------------------------------------------------------------------
// <copyright file="b_sls2_npc_ud.nss" company="Molior RS">
// Copyright (c) Molior RS. All rights reserved.
// </copyright>
// <revision> 1 </revision>
// <lasteditedby>Austin Jensen</lasteditedby>
//-----------------------------------------------------------------------
// *************************************************
// Wrapper function for SLS2 creatures onUserDefined events
// Last Updated: 2008-02-23
// Brendan 'Slayster' Ellis - http://www.slayweb.com
// *************************************************

#include "ginc_sls2"

void main() {
	int nEvent = GetUserDefinedEventNumber();
	SLS2ObjectOnUserDefinedEvent(OBJECT_SELF,nEvent);
	
	ExecuteScript("nw_c2_defaultd",OBJECT_SELF);
}