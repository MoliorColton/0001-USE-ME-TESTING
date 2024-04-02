//-----------------------------------------------------------------------
// <copyright file="gc_sls2_checkstate.nss" company="Molior RS">
// Copyright (c) Molior RS. All rights reserved.
// </copyright>
// <revision> 1 </revision>
// <lasteditedby>Austin Jensen</lasteditedby>
//-----------------------------------------------------------------------
// *************************************************
// Conversation condition, check if the state of the
// light matches the one specified
// Last Updated: 2008-09-20
// Brendan 'Slayster' Ellis - http://www.slayweb.com
// *************************************************

// nState: SLS2 Light State To Check
// Standard SLS2 Light State numbers are:
// ON		 = 220000;
// OFF 		 = 220001;
// PERMA ON  = 220002;
// PERMA OFF = 220003;
// sFitting: tag of light fitting to check
int StartingConditional(int nState,string sFitting="") {
	object oFitting = OBJECT_SELF;
	if (sFitting!="") {
		oFitting = GetObjectByTag(sFitting);
	}	

	if (GetLocalInt(oFitting,"sls2_state")==nState) {
		return TRUE;
	} else {
		return FALSE;
	}	

}