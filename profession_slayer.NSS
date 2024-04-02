/*
	Script to be used in conversation for handling the slayer profession.
	sMONSTER: The tag of the monster for the slayer task.
	nQTY: How many sMONSTERs have to be killed for the task to be completed.
	nXP: How much XP the task grants when completed.
	NOTE: Set sMONSTER to "DELETE_EVERYTHING", if you wish to abandon current task.
*/

void main(int iROW, int nQTY)
{
	object oPC = GetPCSpeaker();
	object oESSENCE = GetItemPossessedBy(oPC, "player_essence");
	if (iROW == 0)
	{
		 int iRow = GetLocalInt(oESSENCE,"SLAYER_ROW");
		 int iCR = StringToInt(Get2DAString("slayertasks","CR",iRow));
		 int iGold;
		 switch(iCR){
		  case 4: iGold = 100; break;
		  case 6: iGold = 500; break;
		  case 10: iGold = 2500; break;
		  case 14: iGold = 7500; break;
		  case 20: iGold = 10000; break;
		  case 26: iGold = 50000; break;
		 }
		TakeGoldFromCreature(iGold,oPC,TRUE); 
	 
		DeleteLocalInt(oESSENCE, "SLAYER_KILLS");
		DeleteLocalInt(oESSENCE, "SLAYER_TOTAL");
		DeleteLocalInt(oESSENCE, "SLAYER_ROW");
		DeleteLocalInt(oESSENCE, "SLAYER_STREAK");

		SendMessageToPC(oPC, "Slayer Task Abandoned.");
		return;
	}
	SetLocalInt(oESSENCE, "SLAYER_TOTAL", nQTY);
	SetLocalInt(oESSENCE, "SLAYER_ROW", iROW);
}