// *************************************************
// On Enter script for SLS2 Chain Stop Triggers
// Last Updated: 2008-09-17
// Brendan 'Slayster' Ellis - http://www.slayweb.com
// *************************************************

#include "ginc_sls2"

void main() {
	SLS2StopChain(GetLocalString(OBJECT_SELF,"chainTag"));
}