//-----------------------------------------------------------------------
// <copyright file="ga_sls2_changeblueprints.nss" company="Molior RS">
// Copyright (c) Molior RS. All rights reserved.
// </copyright>
// <revision> 1 </revision>
// <lasteditedby>Austin Jensen</lasteditedby>
//-----------------------------------------------------------------------
// *************************************************
// Conversation action, changes the blueprints of lights with specified tag
// Last Updated: 2008-09-20
// Brendan 'Slayster' Ellis - http://www.slayweb.com
// *************************************************

#include "ginc_sls2"

// sTag: tag of the light fittings to update
// sNewLightBP: blueprint to change light to, "" for no change
// sNewVfxBP: blueprint to change fx to, "" for no change
// bDelay: 0 - Instant Change (Default)
//         1 - Delayed Change (See SLS2_EVENT_DELAY)
void main(string sTag="",string sNewLightBP="",string sNewVfxBP="",int bDelay=0) {
	SLS2SetBlueprints(sTag,sNewLightBP,sNewVfxBP,bDelay);
}