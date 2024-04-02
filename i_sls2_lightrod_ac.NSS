// *************************************************
// On Activated script for the Rod Of Light
// Last Updated: 2008-09-20
// Brendan 'Slayster' Ellis - http://www.slayweb.com
// *************************************************

// run the rod of light conversation
void main() {
	object oPC = GetItemActivator();
	if (GetIsPC(oPC)) {
		AssignCommand(oPC,ActionStartConversation(oPC,"sls2_lightrod",TRUE,FALSE,TRUE,FALSE));
	}
}