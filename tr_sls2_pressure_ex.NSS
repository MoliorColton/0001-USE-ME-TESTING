// *************************************************
// On Exit script for SLS2 Pressure Triggers
// Last Updated: 2008-09-20
// Brendan 'Slayster' Ellis - http://www.slayweb.com
// *************************************************

#include "ginc_sls2"

void main() {
	SLS2TriggerLightEvent(SLS2_EVENT_TURNOFFPERM,OBJECT_SELF);
}