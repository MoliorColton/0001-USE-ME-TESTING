object oDM;
object oPC;
void CheckInConv(float wait)
{
	//SendMessageToPC(oPC, "dm exists: "+IntToString(GetLocalObject(oPC, "myDM") != OBJECT_INVALID));
	//SendMessageToPC(oPC, "conv: "+ IntToString(IsInConversation(oPC)));
	if (!IsInConversation(oPC))
	{
		//SendMessageToPC(oPC, "Conv ended, DM deleted, stored object 'myDM' deleted from PC\nScript returned.");
		DeleteLocalObject(oPC, "myDM");
		DestroyObject(oDM);
		return;
	}
	DelayCommand(wait, CheckInConv(wait));
}
void main()
{
	//getting the player that activated this item
	oPC = GetItemActivator();
	//send a message to the player to verify this script was even called
	//SendMessageToPC(oPC, "hello world!");
	//getting the item that activated and called this script
	object oItem = GetItemActivated();
	//send a message to the player to verify that the object I want was recieved
	//SendMessageToPC(oPC, "object recieved: "+GetName(oItem));
	//finally do the interactions for this script, spawn a DM and player starts a convo
	AssignCommand(oPC, ClearAllActions()); //clear any pending actions in actions queue
	location lMyLoc = GetLocation(oPC); //get location of the player
    oDM = CreateObject(OBJECT_TYPE_CREATURE, "gr_dm", lMyLoc); //create a DM creature where the player is
	SetFirstName(oDM, "Mod Potato"); //LOL
	SetLocalObject(oPC, "myDM", oDM); //store the DM for player's reference
	SetLocalObject(oDM, "myPC", oPC); //store the player for the DM's reference
	AssignCommand(oPC, ActionStartConversation(oDM)); //starts gr_dm with DM
	DelayCommand(3.0, CheckInConv(0.5)); //waits 3 secs before checking for end of interaction
}