// *************************************************
// Wrapper function for SLS2 objects onUserDefined events
// Last Updated: 2008-02-23
// Brendan 'Slayster' Ellis - http://www.slayweb.com
// *************************************************

#include "ginc_sls2"

void main() {
	SLS2ObjectOnUserDefinedEvent(OBJECT_SELF,GetUserDefinedEventNumber());
}