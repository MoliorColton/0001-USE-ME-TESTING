// *************************************************
// On Enter script for SLS2 One Shot Triggers
// Last Updated: 2008-09-20
// Brendan 'Slayster' Ellis - http://www.slayweb.com
// *************************************************

#include "ginc_sls2"

void main() {
	SLS2TriggerLightEvent(SLS2_EVENT_ONESHOT,OBJECT_SELF);
}