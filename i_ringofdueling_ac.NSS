#include "tb_magic"

void main()
{
	object oPC = GetItemActivator();
	SendMessageToPC(oPC, "<color=white>" + "Your spell is ring of dueling.");
	Teleport(oPC, "fromalkhariddeserttoduel");
	
	//Teleport(oPC, "wqt_tele");
	//ActionStartConversation(oPC, "ringofdueling");
	//CreateItemOnObject("shears", oPC, 1);
}