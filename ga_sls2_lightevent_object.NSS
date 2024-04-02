//-----------------------------------------------------------------------
// <copyright file="ga_sls2_lightevent_object.nss" company="Molior RS">
// Copyright (c) Molior RS. All rights reserved.
// </copyright>
// <revision> 1 </revision>
// <lasteditedby>Austin Jensen</lasteditedby>
//-----------------------------------------------------------------------
// *************************************************
// Conversation action, sends a light event to an object
// Last Updated: 2008-09-20
// Brendan 'Slayster' Ellis - http://www.slayweb.com
// *************************************************

#include "ginc_sls2"

// nEvent: SLS2 Event Number
// Standard SLS2 event numbers are:
// INIT			 = 221000;
// TOGGLE		 = 221001;
// TURN ON		 = 221002;
// TURN OFF		 = 221003;
// TURN ON PERM	 = 221004;
// TURN OFF PERM = 221005;
// UPDATE		 = 221006;
// RESET		 = 221007;
// ONE SHOT		 = 221008;
// CHAIN         = 221009;
// sObjectTag: Tag of the objects to send the light event too
// if left blank OBJECT_SELF is in will be used
void main(int nEvent, string sObjectTag) {
	SLS2ObjectLightEvent(nEvent,sObjectTag);
}