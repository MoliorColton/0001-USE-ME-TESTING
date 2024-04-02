//-----------------------------------------------------------------------
// <copyright file="ga_sls2_lightevent_shape.nss" company="Molior RS">
// Copyright (c) Molior RS. All rights reserved.
// </copyright>
// <revision> 1 </revision>
// <lasteditedby>Austin Jensen</lasteditedby>
//-----------------------------------------------------------------------
// *************************************************
// Conversation action, sends a light event to all 
// objects in a sphere shape around the pc speaker
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
// fRange: the radius of the sphere
void main(int nEvent, float fRange) {
	location lLocation = GetLocation(GetPCSpeaker());
	SLS2ShapeLightEvent(nEvent,fRange,lLocation);
}