// *************************************************
// On Enter script for SLS2 Chain Start Triggers
// Last Updated: 2008-09-17
// Brendan 'Slayster' Ellis - http://www.slayweb.com
// *************************************************

#include "ginc_sls2"

void main() {
	SLS2StartChain(GetLocalString(OBJECT_SELF,"chainTag"),GetLocalInt(OBJECT_SELF,"chainLength"),GetLocalString(OBJECT_SELF,"chainType"),GetLocalInt(OBJECT_SELF,"chainDir"));
}